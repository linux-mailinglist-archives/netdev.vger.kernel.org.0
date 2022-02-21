Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23A814BDF4D
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359109AbiBUNeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 08:34:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359136AbiBUNd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 08:33:57 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140100.outbound.protection.outlook.com [40.107.14.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAEE2250B;
        Mon, 21 Feb 2022 05:33:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1a4KmTBLr4pYKhPLVWD68kRSHGJl/dIhPehFI878wqyE/EtO4sznI1G1Z/xvdPZDg8tWNJL17HdXEk/BTZd40qhTFNNm8P4WjwsVEnFVGdjm5XjOIQzECwg5g+gnFBin76ypeg59LMzrAv4WBaLK+3fAelBRVsGSExKkG9vVJ2qauwOXm7JE19CTaFisMZ4P7e9hhdI0OMROTy1LoL/c0xYNxz4KK3ls/tPWWaLZZTZv+mo5vO14f7vI5IxA/IiEug40d6/pLn2SYbKuieCqCXuYIAx2dqL/YcI/Hw8wzy2LgjGZqZlofi/tlxUr+e3G7e8ZlHRNgdEOjvVc7bKtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZXXC4Ms1YPF9rtbP/xo39+/D4ucpbMqmhYCjSs8cCzs=;
 b=DC/sFBDGHHTNhv7IuN5VnOjl51LF59QVzVjrGNiqpgqFQHKJ0A4J/5lK2k0yzdSGWeIPgGNPfqeoyHfjU0mAK0ONbxTPqwOaQhd9vuVPTFB1daLi4JfnC88pE5EvjvS2nskA9TlMf4svkgfbpG5ZcP8QPtb1x96K+2QxD544cjHjvRofQZfPplBKv1rljs6EiKt02z8/KfwSWF4OskiFNrwPU60MYjK8K4ldV0cVvDNtsHHpZjuRNyiVwgTyKyTjuN+ts4dMkyp0vuL7wG8ywR19rA8qy4ZJa90+rgOaC84Y115JHsfzoHjYZE/22BowU4Nd+SV/zgIAcXc6iQzvCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ugent.be; dmarc=pass action=none header.from=ugent.be;
 dkim=pass header.d=ugent.be; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ugent.be; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZXXC4Ms1YPF9rtbP/xo39+/D4ucpbMqmhYCjSs8cCzs=;
 b=Vffnyv/k+/bO53tc6Eejgos7dag3vIbNnx96/hEj/05ldyx6X5QLqinNUOi3PpLhlg4hiqg8B4jg7s5IuWQmtDhVOnAgEt0wiKYHyWg+Fau1RE6E8jV9/kCIbCCRs/kMzKg1V/JVXQMz9zPInW3+ET+QhlJAMY1XtK9G7gxVvaU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ugent.be;
Received: from AM0PR09MB2324.eurprd09.prod.outlook.com (2603:10a6:208:d9::26)
 by VE1PR09MB3136.eurprd09.prod.outlook.com (2603:10a6:802:a2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Mon, 21 Feb
 2022 13:33:26 +0000
Received: from AM0PR09MB2324.eurprd09.prod.outlook.com
 ([fe80::fc49:e396:8dd8:5cb9]) by AM0PR09MB2324.eurprd09.prod.outlook.com
 ([fe80::fc49:e396:8dd8:5cb9%5]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 13:33:26 +0000
Message-ID: <18b57f7b-6aa6-e87f-e187-feead42fc90a@ugent.be>
Date:   Mon, 21 Feb 2022 14:33:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Content-Language: en-US
To:     Jiri Pirko <jiri@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Niels Dossche <niels.dossche@ugent.be>
Subject: [PATCH] devlink: use devlink lock on DEVLINK_CMD_PORT_SPLIT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR0P264CA0175.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::19) To AM0PR09MB2324.eurprd09.prod.outlook.com
 (2603:10a6:208:d9::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9a8c3fc-1b2b-4c83-998a-08d9f53ebd8e
X-MS-TrafficTypeDiagnostic: VE1PR09MB3136:EE_
X-Microsoft-Antispam-PRVS: <VE1PR09MB3136B4714EC82BF992F75563883A9@VE1PR09MB3136.eurprd09.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x74WuRFcF1gH4IccNcxOTp/rOJQ5CD6Eq1woegCbxGcJHRBSpU4GWbKjvpZsl4DpW2JHRvEGsxlZ7WLJA7aX8DUBipbpjzvLCbl14iwXm92atCY2boVq032EaNgf5BDWDmtNu3mozsBtnArNPyJZu8lPvxdmaLRKLklbSBLffXPu6ZioGpsQNfzuAmBj3GWrq/At9cIhnkB1j/Jt/58H+3811MRULxuFRrYvBJmV/IFrZZPHXsyk0HAHQ8yHUW9QJh1H1R55KrJSVsrjdiVqB749HbHsy9+XvnmKuWKyg9iAN8kInYo7bmCNZXjzqp9N338xQxKxtbsqf3YchWz3QCJpEjSBtX6cUaJgY0WPz6+f5WEjikE/Xc3+sawEL3mcpcqlno2a9jnveygfOTr8dsl4xIWyE/LHm8DngCu08N11qauQwKoPAg+Zevxg8b1vy2JYFrHc/mI3OczNXCXyyu4Whfw5EXdZZ+A+KA7TtqT6M6R1G3Mp9AgxFC4u2N9xfJwVklVT1x4IgqrLnLHnh+Irz35qqpaYUkfiCTC9UVTEhuwZWnQXBZC9R5FwWO0AZfMLk+h0jVYfaXh5TcI/uK+NEuWyC96v2sEoi0fcx2ds6RwxOFwOtJmkmiKsfpJA9mfOEJPvl5hga1DQ7u9/IlnR7ke36HJLmoySFIfucv2skkLhJsVa0Ap7HSB/4purZpk0s8rHDnePg7+TbBvSCJT7EZaJIMb1ZOULnEUbrPM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR09MB2324.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(6506007)(508600001)(6486002)(6512007)(31686004)(2616005)(2906002)(38100700002)(66946007)(5660300002)(186003)(6916009)(8936002)(786003)(316002)(44832011)(31696002)(86362001)(83380400001)(66556008)(66476007)(4326008)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S09Lb2FCdkZlck1yZVZpVGlyUmkvdnV4bExOZXM4RFllUlVrdDZVLzFmcG1n?=
 =?utf-8?B?OE8wTzdxMUhwRzdEYlhvMS9HcXpwRVRtdDlyM3ZTaExZdXpaQjhhUEtTbXRp?=
 =?utf-8?B?VE5VU0JndXVpQTdsZlg1Q2pxYVZ5TVVJemt3WmFHcWNXdVhwQ1pyR0NVQkti?=
 =?utf-8?B?QUVBeXhzZHB4QzNlOTlrNTFsY1JxSVZHZWtVN3l4KzRUL2RyZ1N4SnJ5Rmh6?=
 =?utf-8?B?aXF3SjNQblNCSlQxcVE0UFV4MkNJdXNhMmlJWTJBdXVUbk12ODJrK1JHSGE4?=
 =?utf-8?B?RFZMS2tKSkFJK0NsWWtNTXRMN2RNSnhnZTI0L1JtL2dENFZyNGs5WU1aOXFw?=
 =?utf-8?B?OUdoSDdRZGhtclRJelR2S0hxV0N5VFc0T3VUSjRwZWo3V1FpS2swaTcxOGpF?=
 =?utf-8?B?QmRzM3didjdFUHdrRlF2SmorMHRVSzFnNFYzcTlVZlJkSHdKdFV3OE5nOXU2?=
 =?utf-8?B?bXJlTWoreGltNEZaOS9TVE5nZVVxYkJzbTVYVTIxUUR4Vm50OVFVNWdlYWM0?=
 =?utf-8?B?aDFFN21mVEVRNHBteEYyV3lNQzZYOWNGUUpqY0Eya0FQdVVWYmpvTUE3QVla?=
 =?utf-8?B?RnovRmhjMStJUkVXaENuQzB0Ni9idDc0a3k3eW9uOHN3UHJCWXdhcWhyYkli?=
 =?utf-8?B?ZnpJam1IVlkxREs4QnNEbzhubitPS2RqMVkwVEx2MWRJUFg5L08rQU5kTlVI?=
 =?utf-8?B?MWNNc1pNaGVTRTVWTVV4ejlRY2hYeUF3c3lrUUdFTTRETUhOeWxyMk9oSGxD?=
 =?utf-8?B?SXJaT09rM2xPaGo3YlFCOUJFT1d5Zkc1TWU2OExTMm9IYWdtc1BhU3k5cVhI?=
 =?utf-8?B?V25kVXhyZldvVk1VbmNsN01ZUTlqckoyUlIvdTF0RFpNL1hDMCtvV1lVNWhE?=
 =?utf-8?B?aXF4WEc1L2lrOUdjV2ppZXhPM0EwbjY4b2FzWUxka2FFOXVaYlA0QlNDSUow?=
 =?utf-8?B?NmRQenArNndJL3pYV0oxS3lxWlFCcVh3NE94QjdkS3UwV21nTm0ySGpIb2tY?=
 =?utf-8?B?ZGhxWFZtS3BPVWtCbG54dzhuZkJTWUM3ME1EeGVzTFpzMVUxeHVRZG1CN0Rw?=
 =?utf-8?B?OUtsQ2ljQ3h4SUVmV1N4dmU2b0J0NnVvS0c3dnUxcXNCYkVnVTg2Wmc0QTFN?=
 =?utf-8?B?MjhHbzF3eHd1M2p4d01pbG5rclkwd3pNUndCRHIvWHFGdWJoTVBqOVloanQw?=
 =?utf-8?B?TFUybEp0UW4xQjdQSmZlT01sOFA2TkwvZGtRWEQwdXE5TUp2K1JPY3pyQXJQ?=
 =?utf-8?B?eGlQZzJ6ckpxa3M5WmduenVWRlhqa1lTM2hMQUlUUXlMYzVqakJVd0FmNnZT?=
 =?utf-8?B?blNCUmxtcjgvcmx5U0NaODIvNW9LNGo5bFNaWFpXNzMzM05kSDJrRnpSaVFn?=
 =?utf-8?B?QTE0V1B6TW80OWg2VXR5RGNIVGdJVXBUdzVTNDc4QXVobDdzOUNheXd5a3Mx?=
 =?utf-8?B?SkovdEpVcFJmRzVvL3VNRzI5dVp2M3YrQUpJU1V6aVlQSFNGY1AxWU5Pd1VE?=
 =?utf-8?B?OHVzOFhQNEdSS21wNTRHL2lGNFdCVi9lV1VPbzhJVEp5UlhVYjVXVi8yRFR6?=
 =?utf-8?B?Vm00bGtHa1RFYXRsM2J6U1NLWU16dU5EOEtsMUE0am5lOHdTQUwrNlNndkNT?=
 =?utf-8?B?QXFtaXRwS3IrR2s2TUF2RVEzTmVNZmM2eWQrV0dCMXUzSy8zYUxJT0RBZFBV?=
 =?utf-8?B?WmJWNGdORFNVblA4RmRGTVg2SVpQMFByeDFPUXBvVGF5OWNzTndVcXZuR0xx?=
 =?utf-8?B?NHVQT1NCMnJLejVjNmVQclpQcG9oN0dHLzNKamhGS210T1ZBc2xVMEJoUENu?=
 =?utf-8?B?aHVyUHJnY3BvaXd1RS9ON2FYeEdJOXRZOEdJRGpOcVVML1dKN3U1NjFMUFpX?=
 =?utf-8?B?dU1mTldMN2xIaWhNZGh5M3lvci83eUpCQ3M3NHRtUVljak83R3ZuZXFtTFpo?=
 =?utf-8?B?UFIzdlJHZGFIRGFUTno4ZUVsdWthejJVWDUrYlRXRkRKRzlyS2VLR2JrY3VU?=
 =?utf-8?B?dFNLcGFuMzFqTW9BekNZSjZMd01BWTc2YWQzWXlnODFEQUkreXNlWFBOdk1Q?=
 =?utf-8?B?bUZhSk5kZCtqVC94aGZZRzhyem1NSnBsRG9JeWdIemM2R3hvUDlYUzFJaFBx?=
 =?utf-8?B?alVXZnQwV055SHo5cVVpS3Z0WWhTYVEzZlVwVG8rVTJkbDkrUGZVdUgvclZX?=
 =?utf-8?B?OUF5QTdUMEltMGEyOTBPY0t0TUVObGJ0V0tnS0YwTlJmc1RheDU3cXorWUV5?=
 =?utf-8?Q?w0u/WPKvV8l/Ewy2vyCu7say/eDxO/eyXPBas89drI=3D?=
X-OriginatorOrg: ugent.be
X-MS-Exchange-CrossTenant-Network-Message-Id: f9a8c3fc-1b2b-4c83-998a-08d9f53ebd8e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR09MB2324.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 13:33:26.8214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d7811cde-ecef-496c-8f91-a1786241b99c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wdZVDTjcaFnNDNtt4CdkyUqS45pT5QBQup71OaOqqfde+k63D0eeQNwHXCuIRzPkacKsVBiTQJhDiFT5SnApCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR09MB3136
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devlink_nl_cmd_port_split_doit is executed without taking the devlink
instance lock. This function calls to devlink_port_get_from_info, which
calls devlink_port_get_from_attrs, which calls
devlink_port_get_by_index, which accesses devlink->port_list without the
instance lock taken, while in other places devlink->port_list access
always happens with the instance lock taken. The documentation in the
struct also say that the devlink lock protects the port_list.

The flag for no locking was added after refactoring the code to no
longer use a global lock.

Fixes: 2406e7e546b2 ("devlink: Add per devlink instance lock")
Signed-off-by: Niels Dossche <niels.dossche@ugent.be>
---
 net/core/devlink.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index fcd9f6d85cf1..563becaa03a6 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8645,7 +8645,6 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_port_split_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_PORT_UNSPLIT,
-- 
2.35.1
