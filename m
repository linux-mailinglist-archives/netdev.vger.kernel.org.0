Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391DA4FC293
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 18:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348672AbiDKQkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 12:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239661AbiDKQkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 12:40:45 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E4A36B4C;
        Mon, 11 Apr 2022 09:38:30 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23BGcQ0s012128;
        Mon, 11 Apr 2022 09:38:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=4TDLENcW0T5RGdUqGGBAzQOM7Iwq2bej4zq1A9diPaY=;
 b=PY21v3FwN0rWMFujDCPlXGfnAzfn9B85+h95zBD2J2L72gTdqnZmrUpZx3q0f3Bcy5MX
 wBkQSXEjjf3CVbMg55s+vpgFNVS4G4EdzV64NdYS7Zusl4rsnDs6OCVxbDqRBnY0VNoH
 iaLVBeiDUVjOVavJ/R4uwJ3mUWUNSrORoz8= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fb7vwab6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 09:38:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXD8TLK/EBzkxdbpCBNrXiImm77xRx3H9qc83uOqgOjZLlT0lhK1d2l/gw025gF9umBSYeMrqyMcdmiysu8xUoetSZWh90fxd6ukyLeQO6ASURBH8z3dFCayzugNBnEgORZ6OV2/e/lV2w56+RdHEIQI4z2fagapTdqzmWEOEnCiqEMaTLi52rTiIlNjq7FB3ft3R4wx48jTfJ52Zo253Cozhp08t+9z1WBCyHYyKvgvJp8a6X7JG3IYPa0gD/w9fGQaDAiMLTywsbB2wsN0iRsDVyotU1JwHCfoqlYJoR6yG89AEEe7YEZSs9btTmJKkNlwiFLhDjcwYIG+c4KN0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4TDLENcW0T5RGdUqGGBAzQOM7Iwq2bej4zq1A9diPaY=;
 b=aN+6/kQBnbSg7/nbbnAD3cAyC7ebbaOJusjxR96K2ha/4sKz/JL7sWN4ohykpdUyq8HPBWx77U+PNmm6Q/J6IFPk4Hltr4FT8oqa6KbVxzRmU9Nxjkjq2SwIiaUG7hWFeRYM7FVticeqeec8SpOOPgMExnab4ECluO+AKtxoGxHeUY0ONkmZpfCE/5I9SO6v5PfKofYARsjzeEAOAbabCS9i+nPW2Pefm7AolSVKhIC049hKxfvzYT4c2BxdJJmIdTQBlkO957xwSLPII7dcddQvtGIDB0r6QtdLEMiJZaLqrQutkLzmdmVNRa1U+9iZziuAqzm6/4sH1rInfH3DfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM6PR15MB2409.namprd15.prod.outlook.com (2603:10b6:5:8d::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 16:37:01 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::20d2:26a2:6cb1:3c4b]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::20d2:26a2:6cb1:3c4b%6]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 16:37:01 +0000
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
Subject: Re: [PATCH bpf 2/2] selftests: bpf: add test for skb_load_bytes
Thread-Topic: [PATCH bpf 2/2] selftests: bpf: add test for skb_load_bytes
Thread-Index: AQHYTaQrc0KZZvnvAkOpw2pfOzSEm6zq6XMA
Date:   Mon, 11 Apr 2022 16:37:01 +0000
Message-ID: <090F7906-827C-4AC6-89AF-35E865FB54A1@fb.com>
References: <20220411130255.385520-1-liujian56@huawei.com>
 <20220411130255.385520-3-liujian56@huawei.com>
In-Reply-To: <20220411130255.385520-3-liujian56@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 50437e5b-e292-437d-00fd-08da1bd9810c
x-ms-traffictypediagnostic: DM6PR15MB2409:EE_
x-microsoft-antispam-prvs: <DM6PR15MB2409241E749C1EC12D3F8AB9B3EA9@DM6PR15MB2409.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bZcYssLc5Y4aWyIA1xDP/zwGDw7TYUv3TCMgSf5BMRTxcaavOIsTURrhmjqt60m3oLZ4O12UgAKKUke4feZ43kKQZ2JOe40XmzCCAjbP7FlqSDsfH+ZclIR1xcCunrgEPQlc6Ajccj43GZkR/cwTTMMN9TUZ4pGMghSBfLtlOzZ7YXYX5G1bsNE1sIz2Q8uhAEQmy6mgxwxpndOVGjJ9zPCdOf4fZDGqgY3kNUOxjfXnBQH8XK+FD63igBaACiM/CI8NIYNzKrFqirNbgfB2VHToAfYqLRLqR3J5puXyVL5OQHIRZnYiCQ5S+7w3WGnwvcPC9wpD5OHJuRCJRR4m9xBHBkkVpH2HqVZqr1hUX0Ly7n/Dx30kZPQjU8kK1lRD8m3bUJvpgGt1y19+Y5UyXNXF+UaeVPmi8N06nof/Gzj4D9ByhMWmfQsPPy6/EpKN0DVhl/DbVasjq+eiD+9ZJZnyzC3YTIyCCiu7RDHUHch7FN5nlMs0nbqeixNG1tqlG4aMgbZZnotWtsIkRJXdXAkRsthmfV4XaCryg0wxrGzQwjhhpnHzeqYc5D6GaiWpdllGQft6nfnaMdd6T4uNCIyUhjt+6E4R1fDzkfOcaGaQFOA8+nNc2lfiXl0Erxm5X39lHob68dw3xM7qLWFLb8G3ps9rjZZZ+akame58ApZjqDNRTvXgRj7M3PzIeKhpPeMoFxvduc89LMxd/bx8ZCAvgKmPs03jUyk/JYSy5fYvQaAmY+vJiWqZwDi5ii7B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(186003)(38070700005)(86362001)(66556008)(66446008)(66476007)(6512007)(83380400001)(6506007)(53546011)(7416002)(71200400001)(316002)(91956017)(2906002)(54906003)(6916009)(508600001)(122000001)(8936002)(36756003)(5660300002)(38100700002)(33656002)(4326008)(66946007)(76116006)(64756008)(6486002)(8676002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?W0eMZ0bniooiNLff+6DxBkzX4cp1sHXv0f2E2SGzeCP/gkSvhC6RyBn5t3T1?=
 =?us-ascii?Q?hKp2706/orSkpCbQ62cyxtYsdjDSL9lU50ZaXVerwtLysTOysCpishi7L44I?=
 =?us-ascii?Q?dhiTntLaR//qokHmhJa1DUczXDQJ4y3+6f5LxTEJFOY8B1cc0lqWTgtDQ7qN?=
 =?us-ascii?Q?Hw8pgW8803gwaqMwwsLNFDBi3qrsKH2HtV8dl51+Ga3uKEVH6PsP75dZi1No?=
 =?us-ascii?Q?8caW9vciW0UGOVy1TDzeK+wFVbeS/tLGVU15M/GuBYnnfxXwiMQbTTb3yVjz?=
 =?us-ascii?Q?vNqT6NqgmH4/lHmCmtDQf0ZAV6kA3+upvxeeQvvY/5swgTblqpHWD/fJKZY8?=
 =?us-ascii?Q?E++j2/v+by8YS9pQPhJqX9Pso4uw5skIKFvM0cmvBkwF98Zgqxv3pmYgGSu7?=
 =?us-ascii?Q?dQ20ehKYf2/D+cBecfrhv6wmFkBoY/za3so1m2V3kXwxTpQK7GhA9XkqFEEt?=
 =?us-ascii?Q?Q2olFG9a2lovxBInCeIbMIWlB5KnFW4l+K6JUwlruRDD4Alm5iwOB9wmk36b?=
 =?us-ascii?Q?FzL//Zj1JIJN3m2AmFwJkRjinVCLflWn+JCIyDvWdFDLAShWZ9R02SkviXd3?=
 =?us-ascii?Q?6YoVSQC6wWa4DKcatqzxU0edhPJJAq+tzCDSYln8+W/3UHyaoht5YW7zx/oT?=
 =?us-ascii?Q?X102HdlubU7eu3KBpDHeye3mKVvvCZ7PhqU2qpzquq6/dMdcHqty24kzKtNr?=
 =?us-ascii?Q?ZkF9f3BgOmuzdPySlubg3B13zyjuZepVXIEXL/g7RagU8J0ciA5GWiAU31nm?=
 =?us-ascii?Q?eE+xgitvwXeck1osndZCRfRwori9pPcqZ/LAdRP1aaeGI7w5ciQCJeye70tl?=
 =?us-ascii?Q?GyOiWgHUJc/Clzi8AMi2FNA2tQ+LInSkpHkKqwrsAO0wJEPvMvdDvO4RhO2s?=
 =?us-ascii?Q?h/FvM5yTNFCQw4ivJrnq0mexbtoD55Xx/JnJBQIJuzLz6DPWaiAPqVQsZA0Y?=
 =?us-ascii?Q?RPh/CsjnLVzFTiHqYKKfPhj5ePaWCC/4aNLXan3bCjVi2dl2dDl381W0WZOA?=
 =?us-ascii?Q?0rFBEFJMtvs1ph2Egbu8bh+4t/l5PztS7/I3ugwXWifHTY6uCf+SVKMKlt7I?=
 =?us-ascii?Q?uM3BeZwAp1eTL+tFymHrP/GPqWjnxaYf7swuHlUl/rkHYSXgfEaoATAawCkK?=
 =?us-ascii?Q?YGIiCS6y4LsveXLOI0GTwRFcBFk63agddUqFUax6HzrDpR8gj0YVPuN6/oO4?=
 =?us-ascii?Q?LUNpO4MI8WzjMWrJmIrj/NLxRbDan2WKth0tndr26qbdWd8kV3VnWoRhmIUi?=
 =?us-ascii?Q?Nf0YCYh32KtkkWfJw/hgHR6Wiz0ie3PHhWEkmWuHXvgYQ8VleT5nftc5ZVsX?=
 =?us-ascii?Q?mxD+wycpPRBuYx3fmeQtHAxBuabOg3IhuEkQotvsCf5UzH1LfNTRTftuHcyN?=
 =?us-ascii?Q?km9ZW94272s9G8xGcYo3lqw2fW3bCzdcFMcb6pMSJKE9HLpFPGGyqQ06GclV?=
 =?us-ascii?Q?P94zSHEbn/GNdYcuUWhdXgr+b/IbhgAtfsP/9MNcYCXaIagfRqR80R24Bi2v?=
 =?us-ascii?Q?7fLBSLvuoXVC8GqGsDu65POpPM23ZvcAyMwQ6uwjyWFbJccBTSqApEZ21S0R?=
 =?us-ascii?Q?c5eKViGfRAapJt0s5fYUEF4HsmaLh+n8/bpeCeZTkMgMRYsabMpXTYx/G7g9?=
 =?us-ascii?Q?VvWbrGAr1gKU4uGKfJjjIjzy6sLa8zLYGL2wRUmVSMSwX/6TktH7eD+ZQuV5?=
 =?us-ascii?Q?wwcDSG3oIku04143yGPuvImFR7vSBxffExWYqmfVaU2gdyAWGvo/4eLO0Po7?=
 =?us-ascii?Q?97fqdrFz0d+nP7/p0051FNS09eLP/95+SRnAGpUEVxR/c1nLOGka?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DBF3E4306DAEC14D93ED9988F35E39CC@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50437e5b-e292-437d-00fd-08da1bd9810c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2022 16:37:01.1997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h91qVJWAU+yTYP1p3PvdVTwtdK5fbbUGtiDAPsQzzo3CAU7MLqpf8oqYKAgnsTfhft9eVm0twCrcz/3hxl2+Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2409
X-Proofpoint-ORIG-GUID: lgVrflfXlc13I0qeaZTFf-KWnsED3jQZ
X-Proofpoint-GUID: lgVrflfXlc13I0qeaZTFf-KWnsED3jQZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_06,2022-04-11_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 11, 2022, at 6:02 AM, Liu Jian <liujian56@huawei.com> wrote:
> 
> Use bpf_prog_test_run_opts to test the skb_load_bytes function.
> Tests behavior when offset is greater than INT_MAX or a normal value.
> 
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
> .../selftests/bpf/prog_tests/skb_load_bytes.c | 65 +++++++++++++++++++
> .../selftests/bpf/progs/skb_load_bytes.c      | 37 +++++++++++
> 2 files changed, 102 insertions(+)
> create mode 100644 tools/testing/selftests/bpf/prog_tests/skb_load_bytes.c
> create mode 100644 tools/testing/selftests/bpf/progs/skb_load_bytes.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/skb_load_bytes.c b/tools/testing/selftests/bpf/prog_tests/skb_load_bytes.c
> new file mode 100644
> index 000000000000..2e86f81d85f1
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/skb_load_bytes.c
> @@ -0,0 +1,65 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include <network_helpers.h>
> +
> +void test_skb_load_bytes(void)
> +{
> +	struct bpf_map *test_result;
> +
> +	__u32 map_key = 0;
> +	__u32 map_value = 0;
> +
> +	struct bpf_object *obj;
> +	int err, map_fd, prog_fd;
> +
> +	struct __sk_buff skb = { 0 };
> +
> +	LIBBPF_OPTS(bpf_test_run_opts, tattr,
> +			.data_in = &pkt_v4,
> +			.data_size_in = sizeof(pkt_v4),
> +			.ctx_in = &skb,
> +			.ctx_size_in = sizeof(skb),
> +		   );
> +
> +	err = bpf_prog_test_load("./skb_load_bytes.o", BPF_PROG_TYPE_SCHED_CLS, &obj,
> +			&prog_fd);

Why don't we use bpf skeleton? 

> +	if (CHECK_ATTR(err, "load", "err %d errno %d\n", err, errno))
> +		return;
> +
> +	test_result = bpf_object__find_map_by_name(obj, "test_result");
> +	if (CHECK_FAIL(!test_result))
> +		goto close_bpf_object;
> +
> +	map_fd = bpf_map__fd(test_result);
> +	if (map_fd < 0)
> +		goto close_bpf_object;
> +
> +	map_key = 0;
> +	map_value = -1;
> +	err = bpf_map_update_elem(map_fd, &map_key, &map_value, BPF_ANY);
> +	if (CHECK_FAIL(err))
> +		goto close_bpf_object;
> +	tattr.data_out = NULL;
> +	tattr.data_size_out = 0;
> +	err = bpf_prog_test_run_opts(prog_fd, &tattr);
> +	CHECK_ATTR(err != 0, "offset -1", "err %d errno %d\n", err, errno);
> +	map_key = 1;
> +	bpf_map_lookup_elem(map_fd, &map_key, &map_value);
> +	CHECK_ATTR(map_value != -14, "offset -1", "get result error\n");
> +
> +	map_key = 0;
> +	map_value = 10;
> +	err = bpf_map_update_elem(map_fd, &map_key, &map_value, BPF_ANY);
> +	if (CHECK_FAIL(err))
> +		goto close_bpf_object;
> +	tattr.data_out = NULL;
> +	tattr.data_size_out = 0;
> +	err = bpf_prog_test_run_opts(prog_fd, &tattr);
> +	CHECK_ATTR(err != 0, "offset 10", "err %d errno %d\n", err, errno);
> +	map_key = 1;
> +	bpf_map_lookup_elem(map_fd, &map_key, &map_value);
> +	CHECK_ATTR(map_value != 0, "offset 10", "get result error\n");
> +
> +close_bpf_object:
> +	bpf_object__close(obj);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/skb_load_bytes.c b/tools/testing/selftests/bpf/progs/skb_load_bytes.c
> new file mode 100644
> index 000000000000..1652540aa45d
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/skb_load_bytes.c
> @@ -0,0 +1,37 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_ARRAY);
> +	__uint(max_entries, 2);
> +	__type(key, __u32);
> +	__type(value, __u32);
> +} test_result SEC(".maps");

We can simplify the code with BPF global variable for these. It is 
technical equivalent to a map, but much easier to use. 

> +
> +SEC("tc")
> +int skb_process(struct __sk_buff *skb)
> +{
> +	char buf[16];
> +	int ret = 0;
> +	__u32 map_key = 0;
> +	__u32 *offset = NULL;
> +
> +	offset = bpf_map_lookup_elem(&test_result, &map_key);
> +	if (offset == NULL) {
> +		bpf_printk("get offset failed\n");

bpf_printk doesn't add much value in selftests. 

> +		map_key = 1;
> +		ret = -1;
> +		bpf_map_update_elem(&test_result, &map_key, &ret, BPF_ANY);
> +		return ret;
> +	}
> +
> +	ret = bpf_skb_load_bytes(skb, *offset, buf, 10);
> +	map_key = 1;
> +	bpf_map_update_elem(&test_result, &map_key, &ret, BPF_ANY);
> +
> +	return 0;
> +}
> -- 
> 2.17.1
> 

