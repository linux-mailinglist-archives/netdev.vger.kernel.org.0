Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7836E61431C
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 03:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiKACRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 22:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiKACRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 22:17:41 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022015.outbound.protection.outlook.com [40.93.200.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00651209B;
        Mon, 31 Oct 2022 19:17:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iExj1b6+feyUUN13mIkNIUyDwErbtXl66Y3k6IsMkM52Mj6R62s0Dm6bqovyPBNb2BNXIGaACgiw9rJcWxBeLzYUdOxkGeQdU+fWqPhi8FoF3zWYMVVwvfAY9iCE58+YkcUGnDc6RZb8wRvlzeJ0tsyYfnt43fHWAGSeGIU8vApyQkLxNF02osNGHhecUkcFJBBEDt7Ta7/39tv4iq3NljZ/fA6P7ja0XrG8rSrEhRAxXqCdKHTkqv5Luy5zGMc4JV3nAuTD8ODAgCzF5v+ce9hTRRYnn4by4rFjsncYW2r1OIBubV2V85zjSn23RoPPJIjlOkDKlnzstsAOBMkEdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5gj5aPUL1qHxTSrsDrTkvNWxVfdI/1bnfbl8PHGDcMQ=;
 b=H75zKAth4RjE3cn86EMa2deZSpmDrxRsLy7vDNB/P+DtJuBqQtknNp77SHMo4v/+tbUNw+gFIju5oOqC9aHS8qKdVsCeM9EHtToDsZsiS/XCrk1f1n4f2o7OqxNeZ1yVOWTxBERCVYpF/ehJLeRiz/q/REPkC/CZVYgmAiXv40VRGnfoS6DwF458hak7r8ScpRj1PQh1ChZv5wIoo73yXu4SJzxH/EjxK8uKm76BqkDbwlCgmjhBkTQpVB8NFp37yDXNmDh6fHnuKDpU62+446XXUHACxTX0CPb/Wskb5nHv5zK07NXgjMIrwJRg/vAkXlqjdXTYNiwMhGHUpP9YsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5gj5aPUL1qHxTSrsDrTkvNWxVfdI/1bnfbl8PHGDcMQ=;
 b=H1lqEWioRqR8pWFp+0rBAzhFeZK4oMD06JuYMwB6p5srEBNAdxYzI2Zg/eQlA81vhKcBrFS2Z3bX/KckuAdYmd0bZ9J11NANxLjmXcHEtvEpmNXPHXDb38wApFjLrdPqXQOutPmgyajom2np8NNYAxteCSGsZuXbM8URM1bAIsE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by PH7PR21MB3140.namprd21.prod.outlook.com
 (2603:10b6:510:1d4::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.1; Tue, 1 Nov
 2022 02:17:38 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::a746:e3bf:9f88:152f]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::a746:e3bf:9f88:152f%7]) with mapi id 15.20.5813.001; Tue, 1 Nov 2022
 02:17:38 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     sgarzare@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, arseny.krasnov@kaspersky.com,
        netdev@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        wei.liu@kernel.org, linux-hyperv@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v2 1/2] vsock: remove the unused 'wait' in vsock_connectible_recvmsg()
Date:   Mon, 31 Oct 2022 19:17:05 -0700
Message-Id: <20221101021706.26152-2-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221101021706.26152-1-decui@microsoft.com>
References: <20221101021706.26152-1-decui@microsoft.com>
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-ClientProxiedBy: MW3PR06CA0022.namprd06.prod.outlook.com
 (2603:10b6:303:2a::27) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1092:EE_|PH7PR21MB3140:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e3f9e55-004b-40d4-b182-08dabbaf3f48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b+TqIQKx9w3ZN+Rl6qNxrDwu4K5pVTzWopJg1enpNvVV4DAlsYrU2MZSv3QsEtCcJD2q1XuCTm4mrRmPW5jNmItlH7Ki5ALg9nomR5EdPs0pID93xcMSot8Wf2teQ9xdkvY0s5SJwwxq+nawc9pvOoYOzchEYIAljMaToAaU2P53AJ7ghPd3WRXp52XPIozcv76/420dTpA8Qr5QlyiAaHaeTRR45Sfm+T0dMIcuNfsh97XA0LimxnwK/NG+ahN/MT1i7eWSb/oEizCSR4LS+6pVTvBgqOl7bYE1DFzcrWRoHsF8Gp351EvGLgdiX2PT0pHccilFOcGTCvE2G8r3aombzgjai1X5jZ3xF5K93nSy1aXaTEuK1TwBSjv53zPGEByCHr77XhB9PxbA1TEXCBg4KJLB8sGRvmRHc25cULpuyTXUA46vSV2q3KR2UFZ4+5EJHu0dkcV0JYQWcIs3FjLgq8FOA8RN2/cYlCxz6zvCTxTrngru03GQZ8ANO+I3Br991UqqlCVAabbOPjEe7v6oEGexmj5pZsCOt3FHRdIqJe/89p320+titg5XjyK+73oSHWfPv12XKfLPU3F/A9ksiSrs2n1cIlug6zg1bDZ6OySVh5DELgM1Z6f9gl3ChoDZ0AL7eJ/topT1QQ/XICPaYU8ErGgj8/W5WiNhpZZ+/aMriMcht3t8L1xMGQ45iVh8an2svm5pvy/fto3OzyrNqHwEwCsVA8T0k5+5vCTg8BxN33AHYH13lpxu1Z5I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(451199015)(10290500003)(316002)(52116002)(6506007)(107886003)(6512007)(6666004)(2616005)(478600001)(6486002)(41300700001)(8936002)(8676002)(36756003)(4326008)(66556008)(66476007)(3450700001)(5660300002)(7416002)(38100700002)(4744005)(82960400001)(86362001)(82950400001)(2906002)(83380400001)(1076003)(66946007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MC2fc/Rlyea88uMyrelMv6tIDyp/lTxB9L2wWvTK9kUTjY/Yi4WVGBWrSifn?=
 =?us-ascii?Q?J0b/kA72nWqrCL9tu3pxA3bbBJJsgRIV+iEGSPUu2hxmp6m0vC95/ItgX3g8?=
 =?us-ascii?Q?9dXErIOYbwFXHOntp8UOYF6fOfy4yiQUFp2sA+Fe7gqwPYqVd+/IA6VbIWEm?=
 =?us-ascii?Q?U6oEuvxp5pw1BgKp9LuZNKyY6Ysl15+YMCp/cQkchnxi2HQRvxESEoAxeS/j?=
 =?us-ascii?Q?4FAEkHrbFTrGVTzAlqantCOHWEWQQZPL9iX/xXWqfonfwjfv0ROxwf4T+hcD?=
 =?us-ascii?Q?X0Aje5qUM4fC5QBpQcQKWkHHZU33yxqkyhJ3dkue9WxBl8OtjCJrLZkBLIo+?=
 =?us-ascii?Q?xDT4ukXuAMKI4Sd8VjGVHPBAOWZMFmVjFsD+dRMBkTme5nC6E7avZZHJd4KK?=
 =?us-ascii?Q?d6Htft1IarZIW0KBbHTRC94tjD4i/vovbiARo6Z+dxhRT47ovLSrG5c2lCKO?=
 =?us-ascii?Q?O5FSXo1Wp+4U6T9KsogtqUrRPgHqL4GZ4AMNTFjVfAoyZUjEs/24EjW22FPg?=
 =?us-ascii?Q?ckFettYeqWF4rrT0xErPRvV83LygV4qJZQyiUBDcFoV9DrsuKKdyOuv8/1Fh?=
 =?us-ascii?Q?6lRI3hDJW6hy2VfunK1HidBwMWzznU+n6khWhBIRKiHEqgMa9C3F8/GcT/Ab?=
 =?us-ascii?Q?PMu+gheyK7twJKSGj1cXYMz53A1vhHoX5oie0FM/CkLWfDKJxaIh0UuLdNc3?=
 =?us-ascii?Q?du6+0lC6rqCig5xpJ3FKtvionJRCAhJY1UYJQYWmGTI1Iyxpng/81QeFCJoR?=
 =?us-ascii?Q?DPHjxLNQic88dqgy7seTI5hNL6mlt+Xv3+rrN1pc4v9RJJupea7R9fWMB5qf?=
 =?us-ascii?Q?YECJR+2egmskNhGabkY/j3jP/lvEe1P+nd8f3Z2fYF59CfCqFcSaWVmlHjyC?=
 =?us-ascii?Q?hrPV9lMwbjfs6DkgoUH71Hhz7xAseK4uqx0WnKyUMtJE+cOJMU++ombPfAnB?=
 =?us-ascii?Q?MXn/20BqDaPvnmZ1uyg8q5U9Y15/vsAeYxcQTa5o4C1OS7a8I5EJiGNtMHsc?=
 =?us-ascii?Q?4sc/zlqreN8f2hQ5RitnZwjxg6GjLwBWtbfqCow2HPRyTQH7fq+1AXUSyEDT?=
 =?us-ascii?Q?1Wi1ZC/yW1yca8ZG7kkU2CX1H7bn3Fd/di9A0AqL3NSle6hl6kl9bCPmVzjY?=
 =?us-ascii?Q?D7cEZdcw87Gyly453Y6Lz54kGlEkWxmLIBRzPaUMKCn0B0ZNhrhwhzTb7CEr?=
 =?us-ascii?Q?NQlLeGU6Tx9KI/F+IfakcnQ/lUVwd8nOcST5DRc704aeT4q8WHX1Rpdxk5oe?=
 =?us-ascii?Q?DnS+L0ubAf0IEtMYUbnNhoesiQK/0JYNpsZygY39kuGhaB65vD0VEDADVl6F?=
 =?us-ascii?Q?6YvN+fCZzd3Sm9BpwHoaGVDEtQ9oMSGyUpJC9yTu2mK3Fyx3P3B3OYDFi0uN?=
 =?us-ascii?Q?QiqwEMmdDCvugpfpp2Y4BfUkjE5HzICh3PQRIybLz5tQmei9QTYsrq1wEhtQ?=
 =?us-ascii?Q?FtpAuwZ82bxugAknlU/Oyna+jBbOT+h6szaXxY+zjkyUUnyc+RI+x6aIqJQS?=
 =?us-ascii?Q?30efnppfjq0U5zYkvaT2fpVY1pt6gtAsGZFljrXlUjn7HjEaYnYK+LBgjThr?=
 =?us-ascii?Q?gtj4hqpF1oMWAiA9EYMP0kc8zE2S+pBunOBp60b0omoAqsyLheRM0fZc9aP2?=
 =?us-ascii?Q?XcZvBOnH5DsAiU9XRNqeVz/lRdzGbSuGd6JuwBOkpFIO?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e3f9e55-004b-40d4-b182-08dabbaf3f48
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 02:17:38.4558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uyv0PVNwU0O88Ukz1NNrhlatZtlPr++RdjY4EpOXtJEqxqiAAKXRpUQek/QfVRlv1mdOYYR01kcfH6fwfvF2lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3140
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the unused variable introduced by 19c1b90e1979.

Fixes: 19c1b90e1979 ("af_vsock: separate receive data loop")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---

Changes in v2:
  Added Stefano's Reviewed-by.

 net/vmw_vsock/af_vsock.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index ee418701cdee..d258fd43092e 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2092,8 +2092,6 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	const struct vsock_transport *transport;
 	int err;
 
-	DEFINE_WAIT(wait);
-
 	sk = sock->sk;
 	vsk = vsock_sk(sk);
 	err = 0;
-- 
2.25.1

