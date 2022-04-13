Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C45E5000E3
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 23:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238917AbiDMVNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 17:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239115AbiDMVNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 17:13:45 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F82B8302F;
        Wed, 13 Apr 2022 14:11:19 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23DHTGhS022965;
        Wed, 13 Apr 2022 14:11:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=8gi16h/nHes7o/M8wCKlr0ssMlDZwJxkofiC2tPe0nw=;
 b=jfKI23rnS3dvITrDWCLftrJJYcRS6H7N0FDkWLcoMCQ/SQzBz19LuFy2Kxw+OV7suHVX
 mBbsnjpADcmpudn+T8uNavfM0gfy8L1O0n8q229118iPSxcP+LhzLnSBdPIIzG59SekF
 rSRO5WHTuck2ytsCS+gBacep7TJrrNqC3Q4= 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2044.outbound.protection.outlook.com [104.47.73.44])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fdx3ukv7n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 14:11:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NHEKaBgMpERUF/wXkiuUgy/03RsVs/Jh/WKcNjuNsGkZRe0mGTL9Dbo00Vjetfd66lXhNXhYpRyJp2JwMd6xSBBJ39BTHDnnXJ0GE6ALrtA7kkFavBS/g7HrwRt1BgSu5DDrcSl+f53smZ0x2RAcDhzCkrFa5qiDq5p5HyUdL4rS1nuIX6nvrwMpqyVeXgyQ2v0wOLC5bk1cOsBE/bCYD1snD+q2Nl2oeH4U4LKVBTAq5hDTfMExbOg8FNsGFI3TV0XbXQBQ1dGEVvhCKCPzjT4+k/IEPhoOSOe75ywfJ8ikivUYnE4KutDMZ8TrMqmRhomY8zJzJbhMWLQmmEyXnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8gi16h/nHes7o/M8wCKlr0ssMlDZwJxkofiC2tPe0nw=;
 b=CPs1iCY8CrYi5PEF9bCmwbzZbSEy14tQ+Shq7h5GXX6OKZjAeAkPl3g3m+APRR6KjlKRlMg1yG6HaFdHw1k2wEMTOfD44eadHnxn4oHUIOiwhMSVBqWwRjl0df7fbkqcbJzAVrHKtEJhQx9GTfZ3zYb6TTGfYFwSqY9t4MtPabUk9y7GQbfnLKq0rvM5jKSrh4sH5db+kuNcJWPgH1wZtt6wRxtMdypE8NJeAV15N6kosIRBdeWakg64En+X500S039HEGG6ODs8S69t51BE6ayqi6OTqdDBa8c4G2TF55qeidSz4AELP04PWsMs3eIt8rnrZloC7S2LpeiP1ShMbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BN7PR15MB2307.namprd15.prod.outlook.com (2603:10b6:406:8b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Wed, 13 Apr
 2022 21:11:16 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::20d2:26a2:6cb1:3c4b]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::20d2:26a2:6cb1:3c4b%6]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 21:11:16 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Liu Jian <liujian56@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf v2 2/2] selftests: bpf: add test for skb_load_bytes
Thread-Topic: [PATCH bpf v2 2/2] selftests: bpf: add test for skb_load_bytes
Thread-Index: AQHYTv5w8YpvQ/bYlkWOOTOCTD3Qe6zuWAiA
Date:   Wed, 13 Apr 2022 21:11:16 +0000
Message-ID: <B4666266-B6E2-4AF9-AFA2-75C4EC75C48A@fb.com>
References: <20220413062131.363740-1-liujian56@huawei.com>
 <20220413062131.363740-3-liujian56@huawei.com>
In-Reply-To: <20220413062131.363740-3-liujian56@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dfd2500c-1b93-424a-b9d1-08da1d9225b0
x-ms-traffictypediagnostic: BN7PR15MB2307:EE_
x-microsoft-antispam-prvs: <BN7PR15MB2307D8230541D4D6F49B63A7B3EC9@BN7PR15MB2307.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /5GgDjVh38j69C/ZPLDsMpshTPUyfBSh1TGrCb8WUCRXZZyg1i0gywVp1nQa/hkYUciflCKgXZOOXetm4V5ITL8xiRs79BBExbVE2rAodJRBAN0zW3npUQTgx+0clx28slOShH5/e/fBZeQSAu4dOLbkmqgl+AgHGdMhh8YV/DdowmcXgb1xDs5Wsp4WLOGdUpNCrQrt+AuXe4wfIXZMxZpDn86c86pDjpJ9exLuqs7sT0fFo+qAUIlaynYf8hwTLyECdPOjb9fVJvwCWU5TWL4vN/D+9/yogUvAJ+PvdJ3EureJ5YYm/Wbz+eYYlYJS5x6jJeaJd8xEZ9EPEb2FJWg87gJO4U44Dl1O3XiWiE3qFQGRwMQkH6UJLHjVsLbQtnD9I4JmaRTaFo71mjK7l3FBeF2xHlSbEkmQBFbZ1ExHL/kJEWs0p9uG6MIfwYbuf4yllYsjWHoVOrcF0Mo+e94k/PIt71mo0sgZNuhlJaALecZTSrGk7EAXnwH6J7SNMLNCZ1KJHQD/DLuDAc2tfB1kmw+bX7lS7eAhkj+441RHxW3V9sqQSvoQV4HqgF8E0qNvkxuPqqjAiTKal/2pb7bVrMehClIAE/EtFKF4k5Mr+ufQjTp10zrdtspSgTKObz40ZGwDI+WkyOJF8j3ytZUVDU/SDjHxR6wM9NidNfaZy5a4ckhCodjPtU6QhCh81TUMAfUoVq7k5Beo2rMOnULsrRHLE4dOSRkedXczWFBxIBmrWrhd1xaZZFj2sGHS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(6506007)(53546011)(2906002)(54906003)(38070700005)(6512007)(2616005)(186003)(33656002)(122000001)(38100700002)(508600001)(7416002)(5660300002)(36756003)(6916009)(316002)(91956017)(8936002)(71200400001)(76116006)(64756008)(66476007)(66946007)(66446008)(66556008)(4326008)(8676002)(6486002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hkmrlaC4yAFglvSPvhbsfSf2uYEnxhXrQ0tuhlDzJ6/ANR8lF88CRIzujVAj?=
 =?us-ascii?Q?DU/xwopCQrpc31DJUphsCR+AImfDI4Ij8cJ7sczm1zBmhrEDL3LnRD2fbcXY?=
 =?us-ascii?Q?VLFger+wcGxttYLzN29QhLW6uXTAGv2PEkIUwkFjFhRSwpnsHKhSbbIOU1AH?=
 =?us-ascii?Q?bri1G84jbbN9SMZ21NYo+GNr40JKadhJ8mLM56HdeLjx0ig4/oB2kB1U0sOZ?=
 =?us-ascii?Q?6ods+1Q4yYcA4bWPx5ktLmIhsnV9ZLtfGrqEkBlZTlYgIsmdu2yJNauBumlv?=
 =?us-ascii?Q?x1zezYkRHxXnDXsPLZzM2k9HcYIUqUigXubaV8VIgZfXqgOYSCeAb9RRRNlt?=
 =?us-ascii?Q?5mdw/KieNQZRSw1ZS00Bpdf5uuEdrl8Kaji7buNgNcCxXAA75bnkB0wGNIv5?=
 =?us-ascii?Q?48Ai/KxRKH742hh0oWJr3ZY/5XDLqs0JSZ4oL0+H2pw5yKwCS82X1Lzo2ouB?=
 =?us-ascii?Q?ZHjsu7i9U6l3BUBGrgKLMvcdbijqI+AplVomsNEUG+Po+yDTjRxYUQlusRCb?=
 =?us-ascii?Q?1QXyjURZPbo2bb8Z2DmIDMZjf/URamGR9sUHCky0NmMmjPrAjXQCSfUh2r7p?=
 =?us-ascii?Q?Yvu+dQffNkhC7l9D6/Vo6yQ81TZ9wszyG1RB9oUNnkP8nn0vqTqsBYZiv6T1?=
 =?us-ascii?Q?tDuCaJ9M5Gjeng9x2taIXke0WF74RLdXs5O8kURrKbROTmq3wfDogDUUJEUx?=
 =?us-ascii?Q?bq18Fl7gRFu36Z4WEb53g2SVk5l026VBXEhRSrR6FJlijmh/CXvnUtqjXWiL?=
 =?us-ascii?Q?xRooREewT9nh6AEZIbKTnCZB4TRN1reniwD9sdFOxDBFala0B6+0VgiPc+r2?=
 =?us-ascii?Q?urUmbczDN1g2va4T0UqYTET1guxUNDgDJcZY24pEGXiiXTFxbVrw6OnVIh9E?=
 =?us-ascii?Q?hr3vg363lkaEujMqaa3iqBGL4G0F4SazRUmPAVJn2Fh51qxY+WADH5rfEuA6?=
 =?us-ascii?Q?Co7kW3/1DX0tggWr7dWeYG6bUfG1i21xs1uMc0j1PBzAcqYxWceMeAUA90Q/?=
 =?us-ascii?Q?21nALHPlSwmjIpzU88vte1DFqOlnHWVVSk6aIrM1eMRyEUsypGoUPAVMXaUD?=
 =?us-ascii?Q?y6Z6l8UJ43uXQPeHUUzi8xI4voZa/NqDIh/UgVHkEjxj1ZjHPy0iDxdtfDeO?=
 =?us-ascii?Q?yJlcwmJgKSNVx6BfrXrIFWJHO7IGg+FS7+YP9OZZDDg4cHZKYkbDMWuSdTXQ?=
 =?us-ascii?Q?dmoImJLMbtA5ikavuwNFlY0koaGWhLd/pPI810D2fwcSZILn0ZzT1DLr2y//?=
 =?us-ascii?Q?oV7roi7v/lKhoYmFyQtWhmBh7sbUDKqcH84jVTpvs+Wt7jB8umLXOZ2jqjWX?=
 =?us-ascii?Q?0e7o7ngs05SKDo335GzPWizTsNcPn8yDiwWNlEC4vEhhxXnMIOGHfuuxqwh4?=
 =?us-ascii?Q?RpiB5c6t0y7CImcGqFwpY4WNXTPZiW4E9rPDuHlXoLpBpMQ6HHBN6Tnp2xJr?=
 =?us-ascii?Q?ccbmWjXE5aujtr03sty7qAnXBOA6FRF/hFq92wAoMDo3PfBDsJA6QaoObHrk?=
 =?us-ascii?Q?yDDEx1oz4AuhqL/QlJF1KwktbF+4XDC/Mvm6ZqEmR2B8r97eleTLusMpqaRR?=
 =?us-ascii?Q?3HaZnKKREcKmU+aPTHCOVcHUKrvBL2GKtNhl/x2+RKsK28QzK4jPU5AIUOlP?=
 =?us-ascii?Q?7Cj6AZwd+KSpkEh/OztGJhIcdUDlzCMBFkZQ+Jiw0INiPVvZzzqGk+ySdLEK?=
 =?us-ascii?Q?5XPfhmvF/A57JWKZysjAtezc9ZaacDfZp6ig2JQdrP8bI+kc4nJuK5AdVzC+?=
 =?us-ascii?Q?dsxtp2LfBuYZqWsTdxPuWaAOb57pVpvq6/CcdRE/gR2h3HCeFgZA?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BCBE2EEBABD3E3409EA8287A855E4ACB@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfd2500c-1b93-424a-b9d1-08da1d9225b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2022 21:11:16.0335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5aGpP6j/7M1bmlhJwUZyNWvFWqWFU0Nt0omCxgP588i+fMilQKBajXL2Haa65pNsEvIrIjEZ8qaoKU3p1G1GZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2307
X-Proofpoint-ORIG-GUID: ZmEzZgMc6aEU_iv5vlp7ZXAYH4pekg4v
X-Proofpoint-GUID: ZmEzZgMc6aEU_iv5vlp7ZXAYH4pekg4v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-13_04,2022-04-13_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I guess this should go via bpf-next instead? Please mark the patches with
prefix "PATCH bpf-next". 

> On Apr 12, 2022, at 11:21 PM, Liu Jian <liujian56@huawei.com> wrote:
> 
> Use bpf_prog_test_run_opts to test the skb_load_bytes function.
> Tests the behavior when offset is greater than INT_MAX or a normal value.
> 
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
> v1->v2: As Liu Song's review comments, use bpf skeleton and global variable.
> .../selftests/bpf/prog_tests/skb_load_bytes.c | 45 +++++++++++++++++++
> .../selftests/bpf/progs/skb_load_bytes.c      | 19 ++++++++
> 2 files changed, 64 insertions(+)
> create mode 100644 tools/testing/selftests/bpf/prog_tests/skb_load_bytes.c
> create mode 100644 tools/testing/selftests/bpf/progs/skb_load_bytes.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/skb_load_bytes.c b/tools/testing/selftests/bpf/prog_tests/skb_load_bytes.c
> new file mode 100644
> index 000000000000..81cc224a0c69
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/skb_load_bytes.c
> @@ -0,0 +1,45 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include <network_helpers.h>
> +#include "skb_load_bytes.skel.h"
> +
> +void test_skb_load_bytes(void)
> +{
> +	struct skb_load_bytes *skel;
> +	int err, prog_fd, test_result;
> +	struct __sk_buff skb = { 0 };
> +
> +	LIBBPF_OPTS(bpf_test_run_opts, tattr,
> +		.data_in = &pkt_v4,
> +		.data_size_in = sizeof(pkt_v4),
> +		.ctx_in = &skb,
> +		.ctx_size_in = sizeof(skb),
> +	);
> +
> +	skel = skb_load_bytes__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "skel_open_and_load"))
> +		return;
> +
> +	prog_fd = bpf_program__fd(skel->progs.skb_process);
> +	if (prog_fd < 0)
> +		goto out;

I guess we should report error here? like

	if (ASSERT_GE(prog_fd, 0, "prog_fd"))
		goto out;

> +
> +	skel->bss->load_offset = (uint32_t)(-1);
> +	tattr.data_out = NULL;
> +	tattr.data_size_out = 0;
> +	err = bpf_prog_test_run_opts(prog_fd, &tattr);
> +	CHECK_ATTR(err != 0, "offset -1", "err %d errno %d\n", err, errno);

We can use ASSERT_OK() here. 

> +	test_result = skel->bss->test_result;
> +	CHECK_ATTR(test_result != -EFAULT, "offset -1", "test error\n");
And ASSERT_NEQ

> +
> +	skel->bss->load_offset = (uint32_t)10;
> +	tattr.data_out = NULL;
> +	tattr.data_size_out = 0;

I guess = NULL and = 0 are not needed here. 

> +	err = bpf_prog_test_run_opts(prog_fd, &tattr);
> +	CHECK_ATTR(err != 0, "offset 10", "err %d errno %d\n", err, errno);
> +	test_result = skel->bss->test_result;
> +	CHECK_ATTR(test_result != 0, "offset 10", "test error\n");
> +
> +out:
> +	skb_load_bytes__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/skb_load_bytes.c b/tools/testing/selftests/bpf/progs/skb_load_bytes.c
> new file mode 100644
> index 000000000000..e4252fd973be
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/skb_load_bytes.c
> @@ -0,0 +1,19 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +__u32 load_offset = 0;
> +int test_result = 0;
> +
> +SEC("tc")
> +int skb_process(struct __sk_buff *skb)
> +{
> +	char buf[16];
> +
> +	test_result = bpf_skb_load_bytes(skb, load_offset, buf, 10);
> +
> +	return 0;
> +}
> -- 
> 2.17.1
> 

