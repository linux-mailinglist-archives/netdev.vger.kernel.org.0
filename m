Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B337E55E0AB
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245049AbiF1ITw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 04:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241559AbiF1IS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 04:18:58 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2095.outbound.protection.outlook.com [40.107.96.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1D02DA97;
        Tue, 28 Jun 2022 01:17:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dYxHq8gwyW05BL0wCVyYstZ7bHC2QVc5rRm04Ta1MSSSWhrbH14kSmRfZYVFtzKKupNxkGzCwwxdgqQ6GnUMDtr+ZnM+q958C1q9BkJ3d92uI26hHgS1+ah2uZ+R9Wd/TJ6FwNdzq5htSfoW9U+Sf4pD01URvRMX8r7aPCN3sQvZKxx7aLGQ2o4k8H7EC3xzibPPmh9bM9UB49dV7Nk5rsCA7aPZxg6MfZGaI9p4rciDSMdwhVqt5qbpfNZQaXW3FBVG5+f94CCAtVTvWGaakbUMsNxGFC24rpGKM4aWGaCgsPwIRYjHF/bQBpeCabL+iLRur/YXkqVQBPaNFNGV6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdpu+ko3VfPuNkeVreHLdBfmtcqZDB3EUVhdCP9JkOI=;
 b=d5S1qTkYgZ1D69lUCahagDxeOkgYrW+SGjQYH4h06GQqg6ic4GtiKvcsB3e2WyWalm4agqQeVTPTqtoxlmCw8J+CxziApaP9JouumoRJxVTnX/7hH4kEA0/z95FuGieO970uOoWdwKeP94niykqFck4Qp6z6VrOc/ebqZmIDOmy+uyTzZyZP+khzacJhWEj2dF7e2c/Gof8aVVVaxrM37LaNu4iR3Dh/Ix3VOByRIUIkPZEnAo64P8QvHMNv0rx7Pu0b6UQx7w4qC1ox9BAlDZE9YmV9nLgtPInRS9DgvPbONvkxdoxTun+fD/Q6BH1QMy80EeQUoj0WQh0/jX+/oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdpu+ko3VfPuNkeVreHLdBfmtcqZDB3EUVhdCP9JkOI=;
 b=L/OYJnU/1MgsaD8m9W0NzVobh8PEF9A2CX9+dhlXpmGLzyISa8RyChKpqX72PlPl4DNbFUrcxppjqPJkbcfRMLD7TWX6TYWjLbUO+w7AzItqRet7zH1x6fW1d3eGce8PZbNNw+b0WIez1nZn6vvFMuFw8tgVqeTtqTc1jmpkXeg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5891.namprd10.prod.outlook.com
 (2603:10b6:a03:425::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 08:17:29 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 08:17:29 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v11 net-next 7/9] resource: add define macro for register address resources
Date:   Tue, 28 Jun 2022 01:17:07 -0700
Message-Id: <20220628081709.829811-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628081709.829811-1-colin.foster@in-advantage.com>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0259.namprd04.prod.outlook.com
 (2603:10b6:303:88::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5161778-4e4d-4dad-0132-08da58dea4c2
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5891:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9E4X/iL3+Gu3HsQJjbc+xKlkbyleoJcIRLaNlNNaaWzSHxNEGS0qGmn/aQVNfgbQRpezesSbNImoaTaKtIO3/rYG14LuB9kEZtj0gZuKtKgKYOZBDuM6DUS33fNK/ZtWL3vld/S4meP1fUfRMS+DGvavxvHMu2p1KypavSnEU/DEk78HbkMGmPzVkXWHcxm7cdDQ5NMvU85PTIMxrWT/FEic3CSeSz8ZMH8bE7b1wotkoCnNCdJto8xsTh8p26tF0Ve958D/ODmAOe0SBeAUTg1LyA1aDCyKnhkHRWebDMY0XGsb2jLk9jfyLzVZjrrVwl94uZgVNhmpJn7so9izqAyNg8tuqOBqQ5pRw8BNCl89wMksYF4zzseb/JLK7tcZQyqqwAVU530mplgrzc9YZsFCrP8QeKeHI0WcGtoZi0o7j65hrGyCkeplOr//Rju5SV2k+X0CsAdeDjPrd4da8tQVcOlwlZe28Ys34v0ENs6/bRFekoonjflFQf58eK1RxzjS7gv/d3BRT5OWQKQOHQIRKbHXzewvOcijRyTna8qBqbu5khDHOFSFKjdOa4iSaz/V4Z1g4BAIZOvmwXiwAOG0/sFzbpQFSgGWQ9abvwM3IdruxZ5zPIlcCw0HRWe0jIVj0yFw4tX9EmuzM+SIoreeyer07xFI++hqpV3izcwM4kCt096iEKAc4GBCCC4DLbkpQGZvbYB0xwvxS1h9psLemZax2TlE5ISR4aiHUv0im/IyVv1O5zHOFT6F0Vp7JsAKEqTGSLl2w4Zu6D6FdnUFXGtJUKUKyd68E+usFp0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(39840400004)(376002)(136003)(36756003)(38100700002)(6512007)(6666004)(41300700001)(38350700002)(44832011)(478600001)(8676002)(4744005)(4326008)(2616005)(66946007)(66556008)(66476007)(6506007)(2906002)(54906003)(86362001)(1076003)(6486002)(8936002)(186003)(5660300002)(7416002)(316002)(26005)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GrGMQRm18o/ySqJxW+QAmkC+jW7kOutmSvfUgTOkFjNSO6ccISKRuL7VxXtd?=
 =?us-ascii?Q?/1kCLxwoS8xiI86MncY3bEOO/WU29VsEsBoog50+/T3fKgfJaEFHLCyJGnRv?=
 =?us-ascii?Q?2mw4vSn/Q5VmE4PEMU3Jse7x7pr+qLDr4B6+v9NJjfTGGhxNu4FPHy8A0rKK?=
 =?us-ascii?Q?ajt2FinBfPbV5RNkiOC3yAc3bFkvFPSEjOPWwM6htnQcHYhD1fSD0qbUslbi?=
 =?us-ascii?Q?fpFO6wKKtwDp0bg7wEeglaayFvHHn77MbZFiGv1Twp9AAVqDWWhnQCAhgm+F?=
 =?us-ascii?Q?cYyWxoOUnhA/kitJR78PyidzfLVtPThPrcAATOXMLYZtMk97vp4iM0B1V7dq?=
 =?us-ascii?Q?PFNKxGV6U9K0EvlwcjsGetaqFf8PRFRrGwZSToQehOcGT0AtyTaUE91xHlwp?=
 =?us-ascii?Q?xMvrG1ZuKHl2+VRd7SxNHPGxSCdoLjA4JWHi5JVyQisD1LdHoO+2O5ut04Pf?=
 =?us-ascii?Q?ClFYLC+xuIUtj0qzcyCizBmA3HFxWboDWWMI56ZsULyz9nVSw6hC7tfhB8A8?=
 =?us-ascii?Q?7UxyskqoTe+rocXwSrArnGcjWmY3vNQG5CDsrWMRTEm2S6mSXAJsPi0+rvb+?=
 =?us-ascii?Q?/ytyfFd1H3t+wZRiQ6/WjNYAwOcrEQ4VEjp2OVPG95vVDb1ahCBgSOUUQyqK?=
 =?us-ascii?Q?5JXFVd+irArbj4hZPKTSTXa+bfMorx+YRmHfMDGm7t4M1W3TxnEsrN0rJ8S0?=
 =?us-ascii?Q?jpC8vQgLl/7gSf4UFlW5FxGBFNbINfX45qj4xBLBcsl2g/Ji0dHebCdCwwpw?=
 =?us-ascii?Q?lLgE416MfVTnRmrm45rLhKGHsZYhBDmXJpbYEtOAejwZcY98vTLy33ZsfCeY?=
 =?us-ascii?Q?FkExXV2Pb5+d6oelD7ZpLkbG92XlwDGBoYIJ1Ln0pjYo0dJp5Lf8gsOcywkb?=
 =?us-ascii?Q?8Y4mAVKOXrj/tEZYlp+UUSDu2IPUo0fMCIJtNrJ9oDidze5Wiu9e1x8Gm3OT?=
 =?us-ascii?Q?O5wxXsJ0D0waMnJzSIuVWbkDjTMtjAqMax6GibSy2s8mEUlJ7V4Xh9woxehg?=
 =?us-ascii?Q?Hkt+rCTyTYVF0GZlxEPSMQh879zjC9/tVsm9stLAoyGkq6p2iUi40BK4rzM7?=
 =?us-ascii?Q?6LaPuqWwCNdP+qcLzTko7BlGAzOZ9LcVSQS5hFb09Tmwx0/6iWi8heNjqgE1?=
 =?us-ascii?Q?OX/cNc5WvV1uob/X/Z5hV1x8nORoHwu7pJMl3jr7c1AWd9vZX1OFkW0C1Fje?=
 =?us-ascii?Q?u5c1I97zpW4h90Cy/vsbc1shvRZheVWkPE8skAcH+BUwiwYA88N6SV2T1aNh?=
 =?us-ascii?Q?gd0UN52lw5Vgb0NHPcfhG3YEwnJSwOhPmSzsqr4Hm317lpCeILUULDdKuz1c?=
 =?us-ascii?Q?VyvzC0bF2j9s36re9KKTpKJOSKK4A4tZ9YU7U8Mo6CxOJsy9kF35ScJRDsub?=
 =?us-ascii?Q?Rm6BGD+IImjZaD3YicBxuilIH7Z8bfr1itlMcevoGypXLgeudxeo4nFN19iK?=
 =?us-ascii?Q?nNdk7PtayMFhAZ9W687fd64U09Mvz1NSf4+6zSTV7mIgJhyuqXDtff8MI1ir?=
 =?us-ascii?Q?6kctr161QB1FSo6KMsvbtS8s/OkZjELg9mPcOZ2NR1DNb/BKU6iwpl4/qVPr?=
 =?us-ascii?Q?v+jGqChk7w4QrdRNQPODp0Fzk3aTRh4nxPmMxnMjN4ZhSsTpm8JbWWeHIVaF?=
 =?us-ascii?Q?SQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5161778-4e4d-4dad-0132-08da58dea4c2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 08:17:29.8226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zd96D2N94BqUjehqdL9WthN6XWaz3it3x3XkuOOQ/MmHp2P527kOuwJiQCnD/w1wXcmfYuDDzWHwrOa4DMYXrWdf5po0PlUv/WMF3Bq8l6Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5891
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DEFINE_RES_ macros have been created for the commonly used resource types,
but not IORESOURCE_REG. Add the macro so it can be used in a similar manner
to all other resource types.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 include/linux/ioport.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index ec5f71f7135b..b0d09b6f2ecf 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -171,6 +171,11 @@ enum {
 #define DEFINE_RES_MEM(_start, _size)					\
 	DEFINE_RES_MEM_NAMED((_start), (_size), NULL)
 
+#define DEFINE_RES_REG_NAMED(_start, _size, _name)			\
+	DEFINE_RES_NAMED((_start), (_size), (_name), IORESOURCE_REG)
+#define DEFINE_RES_REG(_start, _size)					\
+	DEFINE_RES_REG_NAMED((_start), (_size), NULL)
+
 #define DEFINE_RES_IRQ_NAMED(_irq, _name)				\
 	DEFINE_RES_NAMED((_irq), 1, (_name), IORESOURCE_IRQ)
 #define DEFINE_RES_IRQ(_irq)						\
-- 
2.25.1

