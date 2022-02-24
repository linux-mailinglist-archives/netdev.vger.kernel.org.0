Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A044C2149
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 02:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiBXBpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 20:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiBXBpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 20:45:15 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D02113C9D2;
        Wed, 23 Feb 2022 17:44:45 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21NGZ5et001954;
        Wed, 23 Feb 2022 17:19:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=V+7QVW02W2XPcyFI26zXNEJTZUv8v/B9V2Am3JoLitg=;
 b=kREbrWsBLSJOTo+umdvbh3NTU1Jlce9XzPzr9VSuPgwDGOaGf5L3LKnmmUgb7k6l1q89
 gK0wIjRDQhnRcdAqhzLAG1FjUbE1bdFx29DN8ux53H7pCkCNGDVm9Sa/UsVGIMOAf3wr
 G1h5daoarn6HmjL2GYEx2z3DFkM13flwkM0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3eddrj787s-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 23 Feb 2022 17:19:57 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Feb 2022 17:19:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dq6vibM/3WOJ+yfDJhW/g3Al1csyuv1ZYR/qZwkO0q2dSKxeXcC1127qHTjVtp4v45I4l91DkoxGruoEqf8Fg1H/7Gz3zEJxp0kGawGYNN7YCakPgLbhDJu/xDemmOD/9HLAF4QJ4fhMqp5flFF3bTmvXwJtrL6WkjaNMwMyQUklPZxN3IXueT68ksXuY+/dP8QKkImES/+PEyKtWasQpri6gn0cHrloiM7irnJFUoCnTtH+zSbldGN0CCj2G2lHxB9dXJMK4f+mSQE3SxjO9nR0rspQB5pHZPTr7Q1an7f+7VrIGmMMY7m6tlCIxM6QbFyFPJdDpTw24DGTIUKjuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=olA4FeWqVzQGw2e69X/PtAurGVhCkutZUkblBMpaubY=;
 b=KC5kLtR1La3hxTfQXuTnW4XJv/PZVkXj+2Iik1fxtHhT6In4l+ccNIatQv2iOzntqYAYJW+ewutv7W5wtYddPnaUjq2pk4dHuA5R1XatAalR8zW233C+qMtzyM3SMhvlFneV3pFxhUhgr4BNPPEREnr1qRpmwagF03GX1qKk8/cWk4aphEdxZuI+oF4zIVKb0ZumSFLkKD/8ESSkXCUZnaM0ArwgcsFEt1ehdgAvD5VEi4D4rMf7fVshfWNeW8iTuWyLZwesm/XsFhEhbhYeVtM8vQbIscabvr/WwGPFat7N2UGztvBRfzeZ0oCKJ82gL6mwogEt5BdihTa3zBZ6RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by MN2PR15MB3552.namprd15.prod.outlook.com (2603:10b6:208:186::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 01:19:54 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd%8]) with mapi id 15.20.5017.022; Thu, 24 Feb 2022
 01:19:54 +0000
Date:   Wed, 23 Feb 2022 17:19:49 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v8 5/5] selftests/bpf: Add selftest for
 XDP_REDIRECT in BPF_PROG_RUN
Message-ID: <20220224011949.7mt4pluj4apqr44h@kafai-mbp.dhcp.thefacebook.com>
References: <20220218175029.330224-1-toke@redhat.com>
 <20220218175029.330224-6-toke@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220218175029.330224-6-toke@redhat.com>
X-ClientProxiedBy: MW4PR03CA0067.namprd03.prod.outlook.com
 (2603:10b6:303:b6::12) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35de8831-d738-448d-e484-08d9f733c34c
X-MS-TrafficTypeDiagnostic: MN2PR15MB3552:EE_
X-Microsoft-Antispam-PRVS: <MN2PR15MB3552E2A6FE4D9FD99A956D56D53D9@MN2PR15MB3552.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p7rGGlNLnTQWyuZ0jtEpG0sLJElz/LBCOVKp/5k05VjnmEAj/w5EwsZox1kN371Ly7uxp5fH7DT8gTICd78WHBX465Zrw476oQrI8E+axOUasuKc3f0p4SFmiiNhDwPz/pXQdGWRf4OxeGy6uR+KhMQPXteZFL+W3mb4vX6D71JVi1OYl7TtazdaFDRxtDRbKyHgyCcS5dBAFfdXJHIR1zrXdFm2CzKsV6o25m5v8mkdLjxMsyHXKK5K02UeKjc7MTzbDdcH8Z44b72puuCS5Aav7CBnE6p86AvWWkY6AX/Uh07qsOEcXk03qRhbMYypDvgZxaLeK5pO+MslRmafkTF4OxQBZoHRpgs2/+l3hxN4Os3PUNkfHwV2S19z3gEnF0ZaRIYYOoNSVrm7rEIDarP/7CytVICevcHOGJw3Q9SH39glpOZ5Yb7DdsZsWHua9D6+o49B4k9f40a2IwbDOMIznWB9TXDV9f5jMFaxf/BuXW1WfAVNEG5E/atxdIVZOvYE4W8JkOZRFpeukrxASFOf2wmHSO9QcqaCZfLlExLH8BTnotcI4XkjOnKwthst5g1o3tWtmaJXJ92APoRkWMv/1wamGVcpdPiOPJeeFonPhHqv3FnSEoFJ4sxfsoz2wX/KhEsoNcG50z+vp99SAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(83380400001)(6506007)(2906002)(4326008)(8676002)(66476007)(66556008)(6916009)(38100700002)(7416002)(54906003)(186003)(8936002)(316002)(1076003)(5660300002)(9686003)(52116002)(6512007)(6666004)(86362001)(508600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?JOXQUg0o26j/mGf/oAa5/XYS2A3vGd0IaUHAp8mf5VYYuxc4i1ppm7KKlT?=
 =?iso-8859-1?Q?caZsQ1XKyccfjh0Fz8MeY4JH5XaShFYQFsDhTrMjAiZG6mvzoA8K3/io2n?=
 =?iso-8859-1?Q?iI5ekKIAUYtxabt1HR4g2+nlqYL970Dl9hDzVz6CnUhvd1f24nhA8p5sgr?=
 =?iso-8859-1?Q?NcRqERzbF6fotJBE4M2AUIHkyoJVThncUfjzAwxCNHt7KXacjs0EIQH1yj?=
 =?iso-8859-1?Q?22T5gIIh/Cq+HP6B7VHg4c/h3dKgBlsu/SJrFX0RYuRONIBC5GUdF3qNGE?=
 =?iso-8859-1?Q?Kcah9KYLNOx4uavDSkrUlJ//4oIlYM8T0bOp96fS482hKem51F2LmUf/Fl?=
 =?iso-8859-1?Q?zAQkypN2s4JGkqHdYq1LS6cgH0TtCweWR92N921b5NaEsY50GeqvTReoCi?=
 =?iso-8859-1?Q?2p0vLbL9Un20XySgttAIXktmiCu9IDYDb71prJv69qftZZHI6r6JwmSXQh?=
 =?iso-8859-1?Q?9VVTNNoaWLS7aKJFYdD3pLa/gJ23d58PpnCpuzqScszpWRElQChmMZZSnX?=
 =?iso-8859-1?Q?HTeBRrI5GHKyxQAOoE36Vr6st4DQ7BW/s9yGCZNTrJPOyCChSku8Nerdks?=
 =?iso-8859-1?Q?I0CRAz74O1nj0WlhbAu/bpdhXK3HE/TNcLtbUbKa0LdMytt+wpjxMxeU6E?=
 =?iso-8859-1?Q?TSf7gim0SP/RW2ubZViUPubxPeQ4LvDfwnpndrUYk5HYWlgh1WA3ncSqmW?=
 =?iso-8859-1?Q?Sa2OcBmk71Chxd0nUyFIvpgYvKQNJrOhLNiMy6vaG7KYX3M80NjIaRR3wb?=
 =?iso-8859-1?Q?YboaYrAlSCbjEvC0tMspc2h5ceWHCxbOWJT9dbNoo17O6NX3XjmFpVCVgk?=
 =?iso-8859-1?Q?VSc2CIFKhylXLto1NDXRcEkn83AtWRh7Zo5aTr+iz+2nGRTjcHGzwtqOpC?=
 =?iso-8859-1?Q?dSwsKftBWnZUDuzwDPkCHjJccaC8Q8PKs8nniXqbBe78dGYhJg6IB1R/VB?=
 =?iso-8859-1?Q?Xp/onbSYMRGHhwhES/6QSea0Tx4B0CVtTZsLHpjTklf3TXCVEhurYmKQVV?=
 =?iso-8859-1?Q?ud7dtpS4SlgQhQl53e1FyYqVZVm7Um7HsJmvxYldb/4tYkGYHpUV6eT3Ij?=
 =?iso-8859-1?Q?C8Wq9UTmPZ+PVyaRDF0KPxc1Hwb3HBVS9H+I7oSKNlh7QRNm8mgda1ONjk?=
 =?iso-8859-1?Q?iAYnSDeLG0IwdziCt2PnK9MwAGJnWpmGogq5iLEUwCXM3O5DpynwD0bUT8?=
 =?iso-8859-1?Q?jZa16PzNh5+mL0x0hHz0e61/ZvaxqqKWfaMttPK9qlne6ndv+ecVa8pxel?=
 =?iso-8859-1?Q?n5pLJ4VmhZF0ovxs9xH91ZasEciTampWqL1rm8uMBGXiPHbU1+3WKuyb2F?=
 =?iso-8859-1?Q?6ttvUZzDwx3P9W5SYpdP9dr6zPLdIpZMvKfxwV5I9b/SM7DQD1CcKqBUF1?=
 =?iso-8859-1?Q?217lC01pj/7NaMYIVFgzQI+qx4bSy/Dw5MwDR7DPKHoQtHWz4ictzriiGD?=
 =?iso-8859-1?Q?oU+XojGelXkA0N2VhDIVaRaz0YZKe1WAqF40sIJr8biJtMtWIlQuwnoSnh?=
 =?iso-8859-1?Q?aYi5bv98tulr3vjSfvUu7Tqjij8KwZv5DjgbHnl35GGiLHCYmu7Bin2EdA?=
 =?iso-8859-1?Q?fciD2KRFqpaHIqgtUsAGZsuWXJSke4rvfEYPg9e9PcncA6Z67/ikcz5fGU?=
 =?iso-8859-1?Q?ro9OcDguBqOyjd2X8e9PCN1fMrnkH6/A81?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 35de8831-d738-448d-e484-08d9f733c34c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 01:19:54.3812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MhNxyMm2aICW//OvDbetnMjWHCkK6JIfXXm54cBBI8FC3OJtb7L/Gi5UIVXvpffW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3552
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: u0oH22baU_-4wxhujDSaP7-AwaW_NCSs
X-Proofpoint-ORIG-GUID: u0oH22baU_-4wxhujDSaP7-AwaW_NCSs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_09,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 spamscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0
 clxscore=1011 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202240003
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 06:50:29PM +0100, Toke Høiland-Jørgensen wrote:
[ .. ]

> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> new file mode 100644
> index 000000000000..af3cffccc794
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> @@ -0,0 +1,85 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <vmlinux.h>
> +#include <bpf/bpf_helpers.h>
> +
> +#define ETH_ALEN 6
> +const volatile int ifindex_out;
> +const volatile int ifindex_in;
> +const volatile __u8 expect_dst[ETH_ALEN];
> +volatile int pkts_seen_xdp = 0;
> +volatile int pkts_seen_tc = 0;
> +volatile int retcode = XDP_REDIRECT;
> +
> +SEC("xdp")
> +int xdp_redirect(struct xdp_md *xdp)
> +{
> +	__u32 *metadata = (void *)(long)xdp->data_meta;
> +	void *data = (void *)(long)xdp->data;
> +	int ret = retcode;
> +
> +	if (xdp->ingress_ifindex != ifindex_in)
> +		return XDP_ABORTED;
> +
> +	if (metadata + 1 > data)
> +		return XDP_ABORTED;
> +
> +	if (*metadata != 0x42)
> +		return XDP_ABORTED;
> +
> +	if (bpf_xdp_adjust_meta(xdp, 4))
> +		return XDP_ABORTED;
> +
> +	if (retcode > XDP_PASS)
> +		retcode--;
> +
> +	if (ret == XDP_REDIRECT)
> +		return bpf_redirect(ifindex_out, 0);
> +
> +	return ret;
> +}
> +
> +static bool check_pkt(void *data, void *data_end)
> +{
> +	struct ethhdr *eth = data;
> +	struct ipv6hdr *iph = (void *)(eth + 1);
> +	struct udphdr *udp = (void *)(iph + 1);
> +	__u8 *payload = (void *)(udp + 1);
> +
> +	if (payload + 1 > data_end)
> +		return false;
> +
> +	if (iph->nexthdr != IPPROTO_UDP || *payload != 0x42)
> +		return false;
> +
> +	/* reset the payload so the same packet doesn't get counted twice when
> +	 * it cycles back through the kernel path and out the dst veth
> +	 */
> +	*payload = 0;
> +	return true;
> +}
> +
> +SEC("xdp")
> +int xdp_count_pkts(struct xdp_md *xdp)
> +{
> +	void *data = (void *)(long)xdp->data;
> +	void *data_end = (void *)(long)xdp->data_end;
> +
> +	if (check_pkt(data, data_end))
> +		pkts_seen_xdp++;
> +
> +	return XDP_PASS;
If it is XDP_DROP here (@veth-ingress), the packet will be put back
to the page pool with zero-ed payload and that will be closer to the
real scenario when xmit-ing out of a real NIC instead of veth?  Just
to ensure I understand the recycling and pkt rewrite description in
patch 2 correctly because it seems the test always getting
a data init-ed page.

Regarding to the tcp trafficgen in the xdptool repo,
do you have thoughts on how to handle retransmit (e.g. after seeing
SACK or dupack)?  Is it possible for the regular xdp receiver (i.e.
not test_run) to directly retransmit it after seeing SACK if it knows
the tcp payload?

An off topic question, I expect the test_run approach is faster.
Mostly curious, do you have a rough guess on what may be the perf
difference with doing it in xsk?
