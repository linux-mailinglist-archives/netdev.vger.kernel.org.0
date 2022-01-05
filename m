Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D707D485A60
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 22:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244297AbiAEVCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 16:02:14 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:10484 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231715AbiAEVCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 16:02:14 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205KNnpk019066;
        Wed, 5 Jan 2022 21:01:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=EVXxxIFfg6NoWaFR+UR9598bnRrMccvG2IEo7sEBYhc=;
 b=r8DbXoTyQwZT8alSGsa4p0tx8tq+TI50M+YVfbkztwD+z2n0KPoyFeNqrTtKxYU44Pnx
 2htFvsnT5G6TJdeHjJ8kFvg29vnrffbYN5Oag1dQYVkseVLRVVirKoc4I1fox3imaYxb
 Hukz9lPzv6OPd6HyJ16cexf/vsObNYM2sqoPkZGK9oVGcBnBRa7OcTYrgWq8/gv4Fgn+
 fdCm+WmWRwIVElae0R8nNf6VA/YFg7Lazjgl8ZMf58FrW1l5nPYKG4IVnu5UxIzOqknL
 oA8MvzR26nIHC12ZGtbD81Xi0Tm/gQnxWVXrYi1yJxyo8BhU06/YkIH63ZR6Q/k54RXZ WQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dc40fntxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 21:01:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 205L1fLa022911;
        Wed, 5 Jan 2022 21:01:54 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2048.outbound.protection.outlook.com [104.47.74.48])
        by aserp3020.oracle.com with ESMTP id 3daes5rvyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 21:01:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2DdARzRMZIZPNXN3sAUr47q9Yzk743IR0tdIHonQ5yJyC5Sev6N5CE4GMzIE8JIYzirWJYj1o6x4U5j+hAV76/whVhu9AwvFm6LczBKbZJnd6+A1QPQSsD5KWfoT206YR8Wu4ryC+7C5WA2UCMTzl6O9sqLPzNOHuwUVFJeIdjjp3B68f79cffUZ12UhZxk6y57Ec1lKpM7lhLvHtvfIjQdxC7BC9N6QM+Muraf4wyw3QK8asV06TKVL3isSEFASa1eGPrJA9M5D3WztwSl3fUAVmyiQ2uYPSB+B49B6uNEIcEEG58bjEp7euNKebCd72hT+VG/Nf9/sJpv3/uGwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EVXxxIFfg6NoWaFR+UR9598bnRrMccvG2IEo7sEBYhc=;
 b=ipp/avh5evUewdrQEnbmS1mbQOpyTtxB7FzBz4ZlL7l+O5sdp0CRq4jo62OCe/yoFmDdeEI52Tvet6rNmwxilZz/40/CIwODCooRSPabR1EvDffkzSd0nueOnvnnbSjJsAEHj8goET+KoxebvUNPLl54C5GjZCie90RrtIA3BHMIWr4SztqR1zHKSFGYUcEqP8gqan31m1hSC8ZZyql8mi2za0UuIHrM4UJAf/Ci+FfrRFtmr84AqN2/7i+b0lraa45IkD8/8zXtCzd6KtWt8+WxZiO8sXp7s23OgUwthiN8PoObyjGwt56GJd9pLs1zkaFyQM3ZLXzmLXuqypujMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EVXxxIFfg6NoWaFR+UR9598bnRrMccvG2IEo7sEBYhc=;
 b=ock8YIsUq47cIqMa09daIfQhj+8pZUay88B8Fy/DkyZ1yVzvvnW2jji17ZdsrUIggDDIC+OvQ/qFB+ztcl9snX6mBRXPd5rl7m7Yj2/SSJIJwpA02fr7FBlSpfpAMcwO/7HE5giWuBkoZ5cGlAoJp0V0purAwuktpGti7ZGTJIs=
Received: from SN6PR10MB2975.namprd10.prod.outlook.com (2603:10b6:805:d2::10)
 by SN6PR10MB2495.namprd10.prod.outlook.com (2603:10b6:805:40::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Wed, 5 Jan
 2022 21:01:52 +0000
Received: from SN6PR10MB2975.namprd10.prod.outlook.com
 ([fe80::208b:c637:9c1b:758f]) by SN6PR10MB2975.namprd10.prod.outlook.com
 ([fe80::208b:c637:9c1b:758f%6]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 21:01:52 +0000
Date:   Wed, 5 Jan 2022 16:01:50 -0500
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Kris Van Hees <kris.van.hees@oracle.com>
Subject: [PATCH] bpf: fix verifier support for validation of async callbacks
Message-ID: <20220105210150.GH1559@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: SA9PR13CA0116.namprd13.prod.outlook.com
 (2603:10b6:806:24::31) To SN6PR10MB2975.namprd10.prod.outlook.com
 (2603:10b6:805:d2::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21d57034-c84c-456b-8578-08d9d08e9927
X-MS-TrafficTypeDiagnostic: SN6PR10MB2495:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB24959AD9E3E080C09C1D5286C24B9@SN6PR10MB2495.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ecpkmMusyBsVsGtzNAH7qOJ0r+x8JDnF9tR+uHqlnirN92GgT06k9HjLFIvWi+U3ZFRUX/CsKnFMDyWslb6idyI0M4D9PPRLOMo8LDwzqGiSI9ta69iLVS++Ztk2liE8/dUoAboj/5KI9AhiIgPbuInABMocAwBaJOWnB9ipAQ4pmgSUVExzd/mb8ZRhn1iUrgpO/LTguge0RECh9GMq6dSO8+vnTP9Ugve7ZgCYqa/1O4GoZK9yt4udD8+0hNpctyl+E9qrmFj5hwA67+VxS1Z/8v2ayTsFJhY3KisOI45KlphfYmXnmZJSEg+9qdaHDJtQHMdWbCPTc2EIGnZL+ODGfkSwW4mBk6/X2lEb2vJcvUL6QwaB7Fym30GzFOCSbPtG5MJKaQ2NBH4Nno1583bB3YYJSD328o5ONslFP7BAOOqugUZ0QgAwW7R4Ms0lv9Dyq8DxfPGQsTggR1doC7ZpnADZKl5EneYdrDxFZz058gn07016XRXX7LClqJsuD9BKEcrH7fEIG09emm2mxnd8kUo4GjQadfePMFoYd2lRf8Wb078zlaQhzBFdglTkv1eBxMPx5dAegg/k0G/ycSrMemEZRyeNKZFds/pcem4NG0or/KinlopK9vNyrXjWnyZaelb8P/zS3ZVU1+zKAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2975.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(316002)(38100700002)(6506007)(6512007)(107886003)(2616005)(8676002)(66476007)(66946007)(86362001)(6486002)(66556008)(186003)(4326008)(5660300002)(33656002)(54906003)(508600001)(2906002)(36756003)(83380400001)(1076003)(52116002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eNC9wcnWm58R+N4ickzf2MOY/ENS5/BMXQ1ZEkvoVAbi8jjKzqehJyUOd1WN?=
 =?us-ascii?Q?sCDJ2IvF5q0nV83ritzJcALZG6f8xN3aDiBPuV7ItTJNtIyBcnWDNP6jWXub?=
 =?us-ascii?Q?wlz6XBvAze83dxYzH3YBpjYTg1zm4X+yMMX6sOw76evag+nzPPa2QfCFL7Vb?=
 =?us-ascii?Q?BzO3jL9YmAvN5LQB6cLyYLB7E2KRvStvip1hU414dhKrLS18WiQIxZQsVvkx?=
 =?us-ascii?Q?qYsvoqrxdZ0GZRHuhW22LMCiOsH8LGr5xsDx1b5zAxSMcETivt4rV/cuuOO8?=
 =?us-ascii?Q?6ceK+Ww4YAf22k86lokzD3bJMip6IsPhuUolp+yy9NNOpABSfoSUgCCVOJsN?=
 =?us-ascii?Q?Mca5TyRkqZ5YgSgWMgdPgGgGezrydAfiicphSXrtT6OMZxCLKRvXqBg8CEO/?=
 =?us-ascii?Q?Xe5mdFIp7E7Wd1TFkshGdYk/oV+NrvoQR9OE1KW+fgxz8rOHSMPJKEQiXYBf?=
 =?us-ascii?Q?gGRzAhRGrGdAeshSnfVRmnsTnjnoCNkeX2PJ7tLR5neGrDjJRZVOmuaSDfY+?=
 =?us-ascii?Q?j7a1umTr6Fi+alHbNTSTlVN84L0IyPvowu09NerjfiNY0CmvMNnnwjqop3sT?=
 =?us-ascii?Q?wReTxfeZPJFzXSCSJsttncXPJ8pFSo5ETb4fjrWKz6EGdiWTbSwgvjBf2rvm?=
 =?us-ascii?Q?/1Bv5UIDpVJ5+BkAGdPJRKjtBdzj/ULczdmUYPD/AN/CND6dW2fJfUZJFWLT?=
 =?us-ascii?Q?sEL0y0kLMw/tDuXdKdICeG/0w1DNCGtcGNd9m7sHHNBRYhgwcF1R+beRsqjb?=
 =?us-ascii?Q?E4NTCgPUrwR7Hq9v+fOpkwVYBJHFip/QYtV0yz/yFX2W3Llx8BtaeTe0OJxc?=
 =?us-ascii?Q?Y8248mxcP7d2Ou8PTY6e8o1O8IS7W1mWUJ1hGbxir5ivVUQcUFb19Y/5TdEt?=
 =?us-ascii?Q?YkhWGrcrWHz7X45rJhMEODd5eWWGpd8Q7k1C81YAr72bJK7YgHfgSHYZEOT3?=
 =?us-ascii?Q?qMIrqUutJKLRDCPKylnA/yoprLpLRmlcdjir5fUY8oWPw62KvyeTBH4tJG17?=
 =?us-ascii?Q?mJUhK9usNUnwGEVjIu6W5K3NqRcqIfKwhls7W7Gyp1aQQMXo027xwupxiOgC?=
 =?us-ascii?Q?aLpBABfIfppojKJpIqmM2lF3MoC1iUvpgya7FlXuVmycZSWU/lf8sw8ZDwEP?=
 =?us-ascii?Q?KX2Yv9ZYWIk9hWe7ZZUs29QZx2Qj+h22X9+DE4EieAEV7Ki/nl76NAEuUAIh?=
 =?us-ascii?Q?qBMw2op+b4/hSQ4s1yxvF9cvmPGYFaIA4qRdeydkpK/QPsQaNIXny/ndEpgT?=
 =?us-ascii?Q?s+D33lTewirLN5KuMOI3yNqeU2xN9hMwIcEIwPEa/7b8X240lmuEiCqkGiHI?=
 =?us-ascii?Q?qds199en9dncqoV6ZHkE6nMtAebTTi5HIMBxobjYpBFLgdYPLRrchnsY7l2j?=
 =?us-ascii?Q?u1StXTdv6X/OW46qfwWbt75e2KnxLvRK0ilLb9ahac1lRXdjJUWm7Y4DvfzN?=
 =?us-ascii?Q?bMxBtezW8PzNO28P7DGjGiv8pyhWFGGV3QNfAeexY9sVBZJY0wosncUV1IKa?=
 =?us-ascii?Q?iFwt8JoX30DvbjiI5GAQf3+QgscdUGRGFJ3Gzs50dkqdx/Z3R9Egu7z9jE83?=
 =?us-ascii?Q?u0gTrkArWpeRDQxQkOwhK+4Eqe3yfviyZylJog7C76DArg1l8fJc1/XLOcWS?=
 =?us-ascii?Q?h+NGe1TAzJMFlkuwNnicRRYVrA3PFnbTmGX1v8L2v42ZqAb/vCpSVcBs7NHH?=
 =?us-ascii?Q?+PpgRV75Trvn+qnQ02KQzadqeEuAmIYAvo+L3eTz0/TPm1qb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21d57034-c84c-456b-8578-08d9d08e9927
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2975.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 21:01:52.4167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6LfpEUT95RLrGqMVRjO4mC+s1huEhPU/phqB8kE+UC40VspAY69+ta6liatAknJZ0XGzXX5T5f5OlJNhiDXAysevopf0eidW+0E/MSRJE+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2495
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201050136
X-Proofpoint-ORIG-GUID: gdR7kS1W4fnKgIa3JNrhguTxuwi9P2aY
X-Proofpoint-GUID: gdR7kS1W4fnKgIa3JNrhguTxuwi9P2aY
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit bfc6bb74e4 ("bpf: Implement verifier support for validation of
async callbacks.") added support for BPF_FUNC_timer_set_callback to
the __check_func_call() function.  The test in __check_func_call() is
flaweed because it can mis-interpret a regular BPF-to-BPF pseudo-call
as a BPF_FUNC_timer_set_callback callback call.

Consider the conditional in the code:

	if (insn->code == (BPF_JMP | BPF_CALL) &&
	    insn->imm == BPF_FUNC_timer_set_callback) {

The BPF_FUNC_timer_set_callback has value 170.  This means that if you
have a BPF program that contains a pseudo-call with an instruction delta
of 170, this conditional will be found to be true by the verifier, and
it will interpret the pseudo-call as a callback.  This leads to a mess
with the verification of the program because it makes the wrong
assumptions about the nature of this call.

Solution: include an explicit check to ensure that insn->src_reg == 0.
This ensures that calls cannot be mis-interpreted as an async callback
call.

Signed-off-by: Kris Van Hees <kris.van.hees@oracle.com>
---
 kernel/bpf/verifier.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b70c66c6db3b..a40ff2efe6be 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6031,6 +6031,7 @@ static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 	}
 
 	if (insn->code == (BPF_JMP | BPF_CALL) &&
+	    insn->src_reg == 0 &&
 	    insn->imm == BPF_FUNC_timer_set_callback) {
 		struct bpf_verifier_state *async_cb;
 
-- 
2.34.1

