Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D866D48CD58
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 22:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiALVCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 16:02:13 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62862 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229544AbiALVCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 16:02:10 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 20CCMQYW003391;
        Wed, 12 Jan 2022 13:01:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=dNE81XqzLubxuyxaWh79inl8A7YEPofWujKfOhMHIfY=;
 b=AqvivS0ma1Kb2mBjbjySLU+T6Jx0IQW2Kxl1SpeHM63peEFTHxBQd9TqTR4E+p+XeLfn
 rnnllMK8ffNfIRKRQab6Cy4aAKugRepZ00ZE1j36Iyp5a5qf1vZKxYpLzblhMzgRVsSu
 K8U5d/ZJCD4Qs3YLCBBzJmEg864ChigDj1E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3dhxxak3fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 12 Jan 2022 13:01:47 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 12 Jan 2022 13:01:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lLPOIy11Rxjs/0ob8tLDq/WhOWMXHa3k9PiVLXryOLirKxdf19tfm3SA4StJwUt2OJ94zmEHYY1ztsHbiAB5cunzA6ZyF0R8IywuDx2DMn7aiL1Xo4Op/WA6bh+ndkcmkAfEQihUtKGtQ6K3yKj/0HHBlu0TKFxz0sqEBIgI2aSzNAMVcYeP0jRXbl40EHauUDw4O+T8h8rY0cII9XD+MEyGm28/VDBJKxOJJwKhVQWD6Vg9vyjFh0V0mfNxQexX1qjMl5AR+ZHGB09orMMuuGWazE2Y900q+qT6qXhz/GSOjzeJgusUrIt3mayQ1ooYF9RAI3TgtIZydHYPjNK8og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dNE81XqzLubxuyxaWh79inl8A7YEPofWujKfOhMHIfY=;
 b=Qkd5+KjxO2AuRbCgJ8x9NRrDYCsvCCTJvklghvKCzBADL/3DpPvk7ARmUMQk0m9b+oTFNxYF7MSJvAdRE597snckRGxGVXqxfeVto9qt/RVGysdATRfDAkI9197i6NHyhExkz5+lYHmsQf9TAX/iOyc+tEivoAEpGtzmpfJ9nRkroJDr9t0lRW+Q1wn7pHmLQmQkKdbPTlyeOB1i1lXk0OoPPmSrAuFBgsfMFOIU6iJrqkwXKVH2I1YdcNFaZyaUyN4szCPc7N4cddadH7jQqWJtJCvLj1YJFJ6qZj71mb82yqZMSvgxCiVgOErSsvNUPyeIaipcJ+HZ7FjRBHvpvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by MWHPR15MB1437.namprd15.prod.outlook.com (2603:10b6:300:bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Wed, 12 Jan
 2022 21:01:44 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437%4]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 21:01:44 +0000
Date:   Wed, 12 Jan 2022 13:01:41 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Tyler Wear <quic_twear@quicinc.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <maze@google.com>,
        <yhs@fb.com>, <toke@redhat.com>, <daniel@iogearbox.net>,
        <song@kernel.org>
Subject: Re: [PATCH bpf-next v5 2/2] selftests/bpf: CGROUP_SKB test for
 skb_store_bytes()
Message-ID: <20220112210141.yo656mjre2brof5j@kafai-mbp.dhcp.thefacebook.com>
References: <20220111000001.3118189-1-quic_twear@quicinc.com>
 <20220111000001.3118189-2-quic_twear@quicinc.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220111000001.3118189-2-quic_twear@quicinc.com>
X-ClientProxiedBy: MW4PR03CA0110.namprd03.prod.outlook.com
 (2603:10b6:303:b7::25) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 418664ad-f55a-448a-7ad7-08d9d60ebd5b
X-MS-TrafficTypeDiagnostic: MWHPR15MB1437:EE_
X-Microsoft-Antispam-PRVS: <MWHPR15MB143777ACE341A6D480EC8240D5529@MWHPR15MB1437.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ssheLSRun/cduVmNdGuDpprtjECzcQCvcczdPHUtDPOCOPic9WeJJy1bzkIsedEedW8YTVFX3GpIcVI1ezgIIKrC2ASnCT5cA9wVDxwgAVnR9TlXpknI0h4AOKIZ9wMBzvcDgSPtQNJh1JP8GlfH9bQZDLHvk8WK21iXUBQw04IzKyVu9DZV5oYD9xFkPtCxEuy6CT/69Wav8vq6VLahZYKYtLT8TcFh7OYRh8aZVan2LMmXGZG4ayk0CbmJRhnV5CnR5OFHYY5F+qtUsrQ3QoNEQRv44A7x4xgQAO3ZUGAQs8hfmfeGCmt3QK/9z5DSjSB+PIZmoMLNiBrVJLnqFbjqBH4BWHbIh30BIqSBoGEeuTiSPo9zIP8zGowHYD/wjNQ6sgJHorV2K4znpVvkb3KroFNiDy0O43hRwSgwuYPhNOJ6sd3I3u7wRHsGLdKSVQtBI5WIGh2KotgQoelolmqsYnJ2u460IyLIK82DglAJAYbzf1paABu57nLmlGvD0/v2tZLP8xd14s7e0KaIesa5lRVsNRjS1smANXBexoYQMF/6AUzV6Pv4xRKpoKrR4n6+IbMaNVbXApcD5sTbKBqpjIE/65oN9SlsecIZ7WakB5fHVCBwWOlF4cc1qGymx9g2CtzxKBU2CuFCPLo+xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66946007)(66476007)(8936002)(6486002)(8676002)(5660300002)(6506007)(6916009)(9686003)(52116002)(2906002)(6512007)(6666004)(508600001)(38100700002)(83380400001)(1076003)(186003)(86362001)(316002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cu6SkShg2zMySirGASll1mZw/ql7m22t9tSPhyNfIzwNmGzldZu3DQ5bjbkN?=
 =?us-ascii?Q?JFBIhLe970jXWdu8pa0kPcfB5ZIuwvN2837MDhK2SDS5wSeRcUP0lr93pAmn?=
 =?us-ascii?Q?GqdfAk2hUfUHlQyByXf0dFQ2NqbU/JZ9vx9fdOhrCq1pX66aDf2nSljl9nDz?=
 =?us-ascii?Q?hpNVsJlZVBGuSgOuPDQ6jUa8WyzsRO9VKA5ldeP2mKpLuPzQLcJ//srIXlVe?=
 =?us-ascii?Q?Zd5KZIkQuWNALf/MkS2JzQZ3PrJ91i+zCe9XyMSKup1Szx30ZUotPem5xtmr?=
 =?us-ascii?Q?r7bcLmF6YO9KFxQjVJQD/8unbesUNH04X+BS8vAAZrC2dNJrcw6XQONbcMsy?=
 =?us-ascii?Q?FLc//hBRZvCKrhZvdB1N4GRkbSjsZynLNBoe/jvzsRBpPMkytNEd2F+pe5/H?=
 =?us-ascii?Q?mocumVQONr39mRc73T6dyqBQKtCsk3Ruk+yBoRvde2XBSLexbL/OfAxCnPdA?=
 =?us-ascii?Q?x+NdfaoEon5rJBd+gZhe2tQfvfN/l1EJrWCFVZqi5yjIHFOsZMTy+/eNcdFL?=
 =?us-ascii?Q?AOD2De5y4f+r9XhegmszJRUrrzW7KnHCqriwhFhrlgbs647iPLX/fxDlZV23?=
 =?us-ascii?Q?txoTd2QJ+8sXJ2moVcsIKiZhJbqmxMnnPwfOSSE+JX9x+zxKQKr2GB3FhV5t?=
 =?us-ascii?Q?lsBFGMbjz9LGLgHPAICusoTTSUdulaauhaEHbzrc9oWqvOdIEq7l6qSlcsJS?=
 =?us-ascii?Q?FjehzqPskEhLXR/IccVPfv1cacB67JYiMVWU9q9FxXwdOt6NoJfw70NyPYnd?=
 =?us-ascii?Q?HNrP0xY46/jZJo2W0VSs1GuMQfadxan37waJ+z/G65BUmb/4d7Ekh6YP6a5+?=
 =?us-ascii?Q?9N+y24RXLfKbgPaetpTGvYClYcqd3MG6PHnDyUq5hb3Ab5voRGtdoIlpR1s8?=
 =?us-ascii?Q?Cg9VanPkMsFOxdLPa38K3qPgmdE0dQ1WewlVMInj9Jf/SrEi23L1dH/Pbewc?=
 =?us-ascii?Q?uyTi+pvDoBZnbAm+ObhyKT6To798r6j8TMEBUo9gpWA0lzKuUbg6lezw0mAe?=
 =?us-ascii?Q?gvsIMuXLHIwMy6Q2MpQDFPo3bqjx+nkYGOMG0X0wfCtWbMU5agd/ooLPsEU2?=
 =?us-ascii?Q?2v4YTOulIP1o2ecLDrPqZQTSdkCzQc71hcmJ4Y9Es0iGj7RkYcQt6wtAGFNF?=
 =?us-ascii?Q?qFkmzfckaLapmXeOiNr/goviFq2AKNF2LhrHWCNyzB77sy7Fc6oW7Ccy34uN?=
 =?us-ascii?Q?rHIGiFI3FV3f+l9fQYsskl1nL4gJupBiLYhdwnOzXWI5h4CCc7fKHZ6QvODm?=
 =?us-ascii?Q?2CDcnSUDmxJwaQ0OPunG4VGHF0tqk56bEadQXp38IwoZ2eINkvEbZNYImAZ0?=
 =?us-ascii?Q?DJEBXpcMfZh9oiblRSpjRc2cep3mHagy+elRI2WH1FJQ6F78FtunpAeyt73u?=
 =?us-ascii?Q?xvLCBISOJUqhP8Zdsj4svIjUok/DfBNNXEjCw9U2z0JSduYzAJ2pRQloezZ1?=
 =?us-ascii?Q?8uPMkrkhRfu05ozFzJw5k2eleNm3YtPGgPdoRv8tr4yWfYjwBzcIJdIswSzB?=
 =?us-ascii?Q?yza4DLXj7ER9cj+yKXFhZRNdoWrYrnBuSeNv4ecAcPvBRKwRDZt5yBF2KcUC?=
 =?us-ascii?Q?oq7o5iyc02C0IHoEL3phPbKlsQqLJOf12SRfLmA3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 418664ad-f55a-448a-7ad7-08d9d60ebd5b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 21:01:44.8160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w0ubluN+AWIzEzfu9JY7ubHFZUpxVqOnrbHHiA2bQjCakBRj0+ljdqYGVIltVdPI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1437
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: On9ExTiagAFY8Re9zRWzhEkKuJEPmap9
X-Proofpoint-GUID: On9ExTiagAFY8Re9zRWzhEkKuJEPmap9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0
 impostorscore=0 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201120124
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 04:00:01PM -0800, Tyler Wear wrote:
> Patch adds a test case to check that the source IP and Port of
> packet are correctly changed for BPF_PROG_TYPE_CGROUP_SKB via
> skb_store_bytes().
> 
> Test creates a client and server and checks that the packet
> received on the server has the updated source IP and Port
> that the bpf program modifies.
> 
> Signed-off-by: Tyler Wear <quic_twear@quicinc.com>
> ---
>  .../bpf/prog_tests/cgroup_store_bytes.c       | 81 +++++++++++++++++++
>  .../selftests/bpf/progs/cgroup_store_bytes.c  | 63 +++++++++++++++
>  2 files changed, 144 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c
>  create mode 100644 tools/testing/selftests/bpf/progs/cgroup_store_bytes.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c b/tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c
> new file mode 100644
> index 000000000000..f492fdb2f31b
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c
> @@ -0,0 +1,81 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <test_progs.h>
> +#include <network_helpers.h>
> +
> +#include "cgroup_store_bytes.skel.h"
> +
> +static int duration;
Replace all CHECK_* with ASSERT_* to avoid this.

Song has already mentioned it in v4.

> +
> +void test_cgroup_store_bytes(void)
> +{
> +	int server_fd, cgroup_fd, client_fd;
> +	struct sockaddr server_addr;
> +	socklen_t addrlen = sizeof(server_addr);
> +	char buf[] = "testing";
> +	struct sockaddr_storage ss;
> +	char recv_buf[BUFSIZ];
> +	socklen_t slen;
> +	struct in_addr addr;
> +	unsigned short port;
> +	struct cgroup_store_bytes *skel;
> +
> +	cgroup_fd = test__join_cgroup("/cgroup_store_bytes");
> +	if (!ASSERT_GE(cgroup_fd, 0, "cgroup_fd"))
> +		return;
> +
> +	skel = cgroup_store_bytes__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "skel"))
> +		goto close_cgroup_fd;
> +	if (!ASSERT_OK_PTR(skel->bss, "check_bss"))
> +		goto close_cgroup_fd;
> +
> +	skel->links.cgroup_store_bytes = bpf_program__attach_cgroup(
> +			skel->progs.cgroup_store_bytes, cgroup_fd);
> +	if (!ASSERT_OK_PTR(skel, "cgroup_store_bytes"))
> +		goto close_skeleton;
> +
> +	server_fd = start_server(AF_INET, SOCK_DGRAM, NULL, 0, 0);
> +	if (!ASSERT_GE(server_fd, 0, "server_fd"))
> +		goto close_cgroup_fd;
Incorrect goto here.

> +
> +	client_fd = start_server(AF_INET, SOCK_DGRAM, NULL, 0, 0);
> +	if (!ASSERT_GE(client_fd, 0, "client_fd"))
> +		goto close_server_fd;
> +
> +	if (getsockname(server_fd, &server_addr, &addrlen)) {
ASSERT_* test.

> +		perror("Failed to get server addr");
> +		goto close_client_fd;
> +	}
> +
> +	if (CHECK_FAIL(sendto(client_fd, buf, sizeof(buf), 0, &server_addr,
> +			sizeof(server_addr)) != sizeof(buf))) {
Indentation is off.

> +		perror("Can't write on client");
> +		goto close_client_fd;
> +	}
> +
> +	if (recvfrom(server_fd, &recv_buf, sizeof(recv_buf), 0,
> +			(struct sockaddr *)&ss, &slen) <= 0) {
Also missed ASSERT_* test.

and "slen" is not init.  At best slen could be 0.
However, I am not sure how this test could
pass considering "ss" is used in the following CHECK.
If the test did PASSED, my best guess is recvfrom() did fail here
but missing ASSERT_* test just makes it failed silently.

Indentation is off also.

> +		perror("Recvfrom received no packets");
If recvfrom() did fail, running with -v will print this message, like
./test_progs -v -t cgroup_store_bytes

> +		goto close_client_fd;
> +	}
> +
> +	addr = ((struct sockaddr_in *)&ss)->sin_addr;
> +
> +	CHECK(addr.s_addr != 0xac100164, "bpf", "bpf program failed to change saddr");
> +
> +	port = ((struct sockaddr_in *)&ss)->sin_port;
> +
> +	CHECK(port != htons(5555), "bpf", "bpf program failed to change port");
> +
> +	CHECK(skel->bss->test_result != 1, "bpf", "bpf program returned failure");
> +
> +close_client_fd:
> +	close(client_fd);
> +close_server_fd:
> +	close(server_fd);
> +close_skeleton:
> +	cgroup_store_bytes__destroy(skel);
> +close_cgroup_fd:
> +	close(cgroup_fd);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/cgroup_store_bytes.c b/tools/testing/selftests/bpf/progs/cgroup_store_bytes.c
> new file mode 100644
> index 000000000000..d81d39281526
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/cgroup_store_bytes.c
> @@ -0,0 +1,63 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <errno.h>
> +#include <linux/bpf.h>
> +#include <linux/if_ether.h>
> +#include <linux/ip.h>
> +#include <netinet/in.h>
> +#include <netinet/udp.h>
> +#include <bpf/bpf_helpers.h>
> +
> +#define IP_SRC_OFF offsetof(struct iphdr, saddr)
> +#define UDP_SPORT_OFF (sizeof(struct iphdr) + offsetof(struct udphdr, source))
> +
> +#define IS_PSEUDO 0x10
> +
> +#define UDP_CSUM_OFF (sizeof(struct iphdr) + offsetof(struct udphdr, check))
> +#define IP_CSUM_OFF offsetof(struct iphdr, check)
> +
> +int test_result;
> +
> +SEC("cgroup_skb/egress")
> +int cgroup_store_bytes(struct __sk_buff *skb)
> +{
> +	struct ethhdr eth;
> +	struct iphdr iph;
> +	struct udphdr udph;
> +
> +	__u32 map_key = 0;
> +	__u32 test_passed = 0;
> +
> +	if (bpf_skb_load_bytes_relative(skb, 0, &iph, sizeof(iph),
> +									BPF_HDR_START_NET))
Indentation is off.

> +		goto fail;
> +
> +	if (bpf_skb_load_bytes_relative(skb, sizeof(iph), &udph, sizeof(udph),
> +									BPF_HDR_START_NET))
Same here and a few other places below.

> +		goto fail;
> +
> +	__u32 old_ip = htonl(iph.saddr);
> +	__u32 new_ip = 0xac100164; //172.16.1.100
Define all variables at the beginning of the function.
Song has also mentioned that in v4.  Please address them.

and use C style comment /* */ instead of //

> +
> +	bpf_l4_csum_replace(skb, UDP_CSUM_OFF, old_ip, new_ip,
> +						IS_PSEUDO | sizeof(new_ip));
> +	bpf_l3_csum_replace(skb, IP_CSUM_OFF, old_ip, new_ip, sizeof(new_ip));
> +	if (bpf_skb_store_bytes(skb, IP_SRC_OFF, &new_ip, sizeof(new_ip), 0) < 0)
> +		goto fail;
> +
> +	__u16 old_port = udph.source;
> +	__u16 new_port = 5555;
> +
> +	bpf_l4_csum_replace(skb, UDP_CSUM_OFF, old_port, new_port,
> +						IS_PSEUDO | sizeof(new_port));
> +	if (bpf_skb_store_bytes(skb, UDP_SPORT_OFF, &new_port, sizeof(new_port),
> +							0) < 0)
> +		goto fail;
> +
> +	test_passed = 1;
> +
> +fail:
> +	test_result = test_passed;
> +
> +	return 1;
> +}
> -- 
> 2.25.1
> 
