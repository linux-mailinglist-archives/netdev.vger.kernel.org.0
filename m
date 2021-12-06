Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F2546933C
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 11:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbhLFKR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 05:17:29 -0500
Received: from mail-zr0che01on2133.outbound.protection.outlook.com ([40.107.24.133]:8033
        "EHLO CHE01-ZR0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233768AbhLFKR0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 05:17:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jCRqYoA46B3XiVz4cziFx0IX0fsqMiUqMj30FPD+Qw7fTFVCzFtm8rCc75C7XUU3Kg/gXBBWXTMchumNKtk/CbNhJtMzHKcI88ZPes4oRkrjFZx9HDw2BLP/6KBjrn/4DVBr+AIhg3ssA1dc4WA9JJUQiEdCOe5+5zYlvh1yhr9mvYiFUmg4K/ltjTknAn7QSEDXqo7gHJR/qBgMqLJJ7q0Zj7H24+LzkH5wxiUFxifK72C20tK9syeJgwghtRGLEErxhGHg45u/Ik7zUPPZfYG/+GPJOIbpe6BzB/MhYsAyTY8kBjsFeVW1XMWhpzGF1DC5Ek9vq6LRqPNM5nl+5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/gtuxkwCzUgyB89eyRvoAMss8BP+Rq2Eea01b4fnDQ4=;
 b=KpM37L5DL4lNxtGtmWBz3HiYNoYMCf0nIBTBGd1k6CKe3aZhfTgByeN0w8ntvgvdl1m/sJnOmHu3eLxxZ8TnJrePeWZzxPZJ7wFG1J6Yt2rHOich7CysQdZ58flsQDfU6iyRnWoMUcxNAyoLlXnqur3764rbVozBd7jalDmRslnmdyEMuDlIyseOO7bnuIiPYPbwony9jh6Llpbqvho6lGKkRdGetXZjNEdGm+jRn/nDlyzA8lBjk/N6UQfqu51ph8C3dnl1HiE3fIKs+Gf3aB9Qc8dTB+7SPJMKzAN+y5d+FiQhdPSx5sXpNozUtrF3xQgRo6aTVcRc7VTy0VluZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/gtuxkwCzUgyB89eyRvoAMss8BP+Rq2Eea01b4fnDQ4=;
 b=R3ebjC+tUKcFlItJ6zP64lzw9WIr5bRN7zVqZnDFaUx248EnxB1XHGyECDTgXlJ3d1L5k9S/14x7TAl5g1Kb6o7WhI1Py8esdNx9J7NZpYluH1wNp/MN90k9YMskk5Seo/Tb5zYT7cBIHmN0eqe95VTCHZGJne90mjRhUDyyRDk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:34::14)
 by ZRAP278MB0206.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Mon, 6 Dec
 2021 10:13:53 +0000
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::e5c4:5c29:1958:fbea]) by ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::e5c4:5c29:1958:fbea%9]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 10:13:53 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     netdev@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Cc:     Philippe Schenker <philippe.schenker@toradex.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/2] net: fec: reset phy in resume if it was powered down
Date:   Mon,  6 Dec 2021 11:13:26 +0100
Message-Id: <20211206101326.1022527-3-philippe.schenker@toradex.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211206101326.1022527-1-philippe.schenker@toradex.com>
References: <20211206101326.1022527-1-philippe.schenker@toradex.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0183.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::13) To ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:34::14)
MIME-Version: 1.0
Received: from philippe-pc.toradex.int (31.10.206.124) by ZR0P278CA0183.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:44::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Mon, 6 Dec 2021 10:13:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9123f02b-d50c-4281-83cf-08d9b8a11b13
X-MS-TrafficTypeDiagnostic: ZRAP278MB0206:EE_
X-Microsoft-Antispam-PRVS: <ZRAP278MB02060DD2102DC6B8526A1D10F46D9@ZRAP278MB0206.CHEP278.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: juZHUhCvcAX94biHx0bD4kx5oA+VMlNLlM4+kxV3oTqfYPufMjKtKLqZ83vbyKQRl87xkAZRuiWSKxT4GckJjP0B8JLpHxi7mXjTv49bsi/zy0Npl4xA6dH72B4ujS5BBDEGUzFAe/e60Yvcm626ozbpSl4i8yx8TljPebdhSDWG6Lh3CQ6VCyrccb87IWwrKpswIThfuu9ybZe0iq/sjvUYBTmwDVCRD2tnwKctQBtRbocMq21maLKZhyftWUyoQHb3l4WeFM/YLjU0ShkjPv9z9VtXMvFNiJ0YnRcTKZuJQGANLz6LYow2FEwO1qGBAnar+d9Fxjx2iZOwPPDETRFqIgjSUhxX2y03AO3oYw3hJuHbN10QyYai9KTaS3jvHttjLdMfRFNvFzHEUni1V3DgiBBoVKv2DpUpT8vGraCPPgS5a95B2oxEqLd4u9PMEnK9JHIUAqwizOjcK5mdNSAoOaAuvE/TMalobNIXOJEvRWwq14CQ8lGXdzTsqlHhIuo8QiYprHiF3fK+3zSehbkd8TDGIKeLTwN50AI27zQ3lAH3XfcM1pFMAsMqlBXu/jYfRlaXpqYwPMwkyljR8i99YdAkvffnf0hmQyN2jKjmzqhbcHow83b31oN6G3qAMfs3oe21l6Pq6CbBr8n7Cz3lu2LOYN0vccpD3OTJkpMwf+tUTzj5OndfWS5ph8j4yDpO2s9JTCU5Rc7aRJD6sOzB+H+qv9CdfHjV6m/su94=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(376002)(366004)(396003)(346002)(136003)(83380400001)(2616005)(66946007)(1076003)(86362001)(36756003)(2906002)(26005)(44832011)(956004)(6666004)(6512007)(66476007)(4744005)(66556008)(4326008)(8676002)(6486002)(110136005)(508600001)(316002)(186003)(6506007)(5660300002)(38100700002)(8936002)(52116002)(38350700002)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y+ONAH17lXQpkHywhNGMjhIZQRXm50+IBcBF75oNa+fNExUq7LT6T9/7GPR8?=
 =?us-ascii?Q?CuXX/qQYHJp8OdtVQZkz/+McDRUGcaimXT2fxK3oioDUevGnBLtTi7vr4pei?=
 =?us-ascii?Q?Ws6/DRx0altqFWGqBiISP3Y9eCXLKKTPuF/Ni35xNx5EmSHRyjZ1wf+BbCSG?=
 =?us-ascii?Q?yXvplfDkQsoHIg56/jdVPNsTr/dDzZzmSQD8vI0fjTl4rl3KYbCvc8mPC/ne?=
 =?us-ascii?Q?Jx+8sq3i6g8w6C2IEE8tCidgn9bUhV9h7SsTEyR4GkHdO0vgN3lJZrkxiptq?=
 =?us-ascii?Q?UaaYHuhJq1rnwEbC5hj8gtbc4AMge8YHpOhhxNjFJ1nDpUxrbj4LjlwrpXe2?=
 =?us-ascii?Q?PxGDR+5P0cAzgG5Miv6Cko6JUyZZAhquvuRMcSL+oWrJ5ypwaI/vEdcOT01U?=
 =?us-ascii?Q?ngQz43O2hLaJcP8BDt9oGpyo/jo7f4h29z7FjLKq9+WM9A0xvtdTOCIjHoQL?=
 =?us-ascii?Q?RL9QjcknQVqduLpm9iNV4fAgw6i/AJ1+nawUmKXkM+vGU3TjOGh+ehzsUuqj?=
 =?us-ascii?Q?2zvwymvJDThhzDrWWSrQCofl8KD1uBLeCP+JrErZ+iFeY/t9UQYHYOG3bidU?=
 =?us-ascii?Q?hznE0Pzcr2CHQ3gXhKUD4Z0Apxpi6V5js3wqIDztfBRkx12Ci7QU1/co+FGO?=
 =?us-ascii?Q?6TIWK8XXgt7wtxPyIdMQXGIPxIezQuO+V7s2YFAyltxUghH58tiB2jAqH8fL?=
 =?us-ascii?Q?OVLenrO/iIWCkcihZC95WhQhOR5vmgW4aCw29xlBh9T/PIXCL9p5WUr/5TCK?=
 =?us-ascii?Q?YndLAXu2WngTB6vAWnvLOjsxT59uYtNBB6Pi+9SGuhPCbfdaOfaUvq70Jn0M?=
 =?us-ascii?Q?mRCdD1uM6f+nfZ2OhXak+g3340mpUlrXGYLbP3mcBk6UEDRbCp2ZXU0aygn4?=
 =?us-ascii?Q?Asa6yumWs+qctEwXEzfIle+r1/TmooxJfRzNQ5ekvgqwtqVolvoFr106OvlT?=
 =?us-ascii?Q?5kGG1/eoUPI53A92Au5nV/ElmN6vLM+MNOd9UGgpXtreWd7AtKBpZQvSwOcx?=
 =?us-ascii?Q?PxkQpcxT/BnY4M8Qeh0/04ohGiBItP6GpLv/34D9IbhoEb3lts1VxG+7wrdZ?=
 =?us-ascii?Q?kwCHjWpPC91BFGEnarkwQhXAAt4a8mYzC/96/GwOggA5ZO7h31IjQyTgLYka?=
 =?us-ascii?Q?woRKtGOZiGjMQbD/4lv9MmEcDbbSyeSq+BdWShxcCToQYh7LYxepWBH2HiMZ?=
 =?us-ascii?Q?NhqpdH89RoKo15qsRyJ5o+TVSjoV0nvD3HDIvopxAyrWHHwQM0WKZAQx4A5u?=
 =?us-ascii?Q?X+se56jfGJcWrvy6konnsaep2nQCqKIUtdnxyEWreUd9Gms5JJfhqvc7yH0T?=
 =?us-ascii?Q?U5r33/KFkVDYZTCdAH2kxzOVxMKrSjJNC4DO895KDx5plIV9EU5uSeNbu7WK?=
 =?us-ascii?Q?Z7aUHT7DDzvelpGUMibBPXv5vDFtqNYOIdu/kTV/dhXyxzI5+u7ztKjC6wT1?=
 =?us-ascii?Q?QH1Eyztqy+FZlkBP0VRWDPRJychXQgKh/dcjwp3XkOQc5m8OGrXh8UjhUurf?=
 =?us-ascii?Q?GS+hJM9ApuCbSXYLPlMdn31M8CJPqbsXNZ6+QGY4PPDubptq1CHdDvhnsYe5?=
 =?us-ascii?Q?og7s/2lg4/4laVjblybuMxiqIYCK43KAvIX0cZkM/SUq977yUYJHtfVEiSoN?=
 =?us-ascii?Q?Z/4CCgiNv9fBO8CGFyV/xHyFDjCZX6jIfikc/eOlHBEof46APirixDqru+8L?=
 =?us-ascii?Q?aXb8VQ=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9123f02b-d50c-4281-83cf-08d9b8a11b13
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 10:13:53.4250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8kNmt8sfp0pTjsqC1PuWUjPUMUNPLsrJdw4Cjij9ci2VAyqNUL5eWwNyYkQlC6WszeKVOMxxpZUbZJ/81ivjntfe/ZfzxxDf7nQVFo4swwc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0206
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a board solely rely on a GPIO to reset the PHY after power-up, the
PHY won't work after a power-down where the power was cut.

Reset the PHY after power-enable in fec_resume.

Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>

---

 drivers/net/ethernet/freescale/fec_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 92840f18c48f..41c3825cd768 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -4118,6 +4118,10 @@ static int __maybe_unused fec_resume(struct device *dev)
 		ret = regulator_enable(fep->reg_phy);
 		if (ret)
 			return ret;
+
+		ret = fec_reset_phy(ndev);
+		if (ret)
+			return ret;
 	}
 
 	rtnl_lock();
-- 
2.34.0

