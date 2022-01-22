Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741854968ED
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 01:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbiAVA5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 19:57:00 -0500
Received: from mail-bn8nam08on2114.outbound.protection.outlook.com ([40.107.100.114]:63832
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231176AbiAVA47 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 19:56:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dUO04d5Cs2NmyrefcduTlEdgKhsACIQdnoIVG+TUWk/OR437Qf21oSnMzqjLa5W78q5YrY5RtHrfBupvkJdi3S8lJaSTeh65/uUC22e6v9tEwfMHIRZzcDMiTUphhbIKK2Pqy77mkBp+EUYTZ7vNR2c13nKRX78QNbVNWXXE18pf+Jidq6S5Goq7+mzLRfcLXfUtLihzpWUq/0gBg+3NzCzVQqJ9g3iZSvXInIwrB1+AULwbCCOYqk8+eppFwgpFJYGSl8IBCbHGQ5Bf6z7+ErXYyMsYEq7QRR0CzfuKw5Ki3x86Nqv1rIbEnxdkLbTCGNj2S/aRfbXs40doDUXfUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V5sSXDpwZywJqIs52lS3AJHxZvX8PsfKexFxT4gu9nk=;
 b=DRUMzxS1435Q/Kv8TdZb0tGRzJfaJDWsYyMtAyUxLKvC9GBmRTZ+oG78ha4H1ldFWHXUmfVfRru0bN+5j/bD2A8DFIpFVhtkIKItCd8pOu5LCU6W+Ji+HkzjoxH4UsywuOmLOFgJ/dsaAPXCcNdQ/83a/N3V3NOatlSXVC0JudKHxc/BTbUwsEdwM9joI9ercjYvN3ckw/mbEP0sMyp1/by5kWsg3whT6kaw20pu46j18RgPRFtRy1wWHhoLqSkJmo6tkQI5JgyLy+KzFjH8kkWTdkXQVNFRKtB4xCOwZl8N4NKrwQV5z4N5pIWbb4Y4HN2fieWjeB2H+rXY7xc+hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V5sSXDpwZywJqIs52lS3AJHxZvX8PsfKexFxT4gu9nk=;
 b=ViF8sUObTyjSm3vO20hvRyjA4smPQba1udbdWVX4aJZ420bpP3h2g00wgX3S9kTmYOUpB+xyhab0Z0PAklOh5Ky7NCcKWwoFrH4NWaq+hmoV9yuAt+eNZdMuBqKQP2KxvlUj9GQBpUENGSJh79uJB1IWHcN97nSwKmNESy0/bzI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH2PR10MB4022.namprd10.prod.outlook.com
 (2603:10b6:610:9::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Sat, 22 Jan
 2022 00:56:57 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4888.014; Sat, 22 Jan 2022
 00:56:57 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: [net RFC v1 1/1] page_pool: fix NULL dereference crash
Date:   Fri, 21 Jan 2022 16:56:44 -0800
Message-Id: <20220122005644.802352-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220122005644.802352-1-colin.foster@in-advantage.com>
References: <20220122005644.802352-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR13CA0030.namprd13.prod.outlook.com
 (2603:10b6:300:95::16) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f740f91-3131-4724-95eb-08d9dd4216b7
X-MS-TrafficTypeDiagnostic: CH2PR10MB4022:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB4022E867D9E6F2146EC3BA89A45C9@CH2PR10MB4022.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +R8JoeIAv1wjn7ts0qbVzimsvKCLloe7qQMeIskZ1prECSwZ1Yo98er6+3V9MgOuRs8yRzFFaXxuO95dSxagfaEHlMjtq8uErSt4SNXCCjHflCmFrHgbZ3nvZVO1uLtA5+Waz+U8PgfhWfBreaDSeAMkaXfxSRQ0PDP8toA4C0mEGlZqBHW43F/fn2j8DGjRBJj+SsuaN++mnXz7sfDhpB/6RZUe+yVsqMP6HKQQLT55uFs3U46jUKP9t+tbFWTbHLwdHsNUTSHci6bWCwtDUhJbXOOdU3m77MgbMP7/tXZ0wuirBVj2rB8JTHIGanpqWfjpzKzv6DdfPPCfaR1z6LsYmpKWMwEvPwxazovr1JohAKGdOtzg7CwDR+043qogkeUZGa9+99i6TDnchEO0jysVLrehsuVhurKA3+rQCImIgsMbqpJehsD3zWmVeR1pEz+dZduhP8t6TS/CJIGJ20Q5jIZaVJ6Cgwf3D5IWY4O7pVYVrbdGA2/5G9I9dPOPGguPNgYEdemGaFt3OsaEL28nJQsaMgeH+YTPZeuRmR6sNR/VBAS+BzJFVcUlyHLmCaS4OPNPdC6hUK+vGIjfsARAB5NClTM3D56JGkQ9uroClmYnoVwmyGx/H6MMo0sgla8AYNElb4fg2PvGWD/Kshv0TE0QKuoKRhbLIUDCQxR3G/5rSt3OV3VjvUgViuZZfrWGY7O8E9bGhwQ4nsS/2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(42606007)(39830400003)(376002)(366004)(136003)(346002)(396003)(2616005)(52116002)(2906002)(44832011)(6486002)(186003)(316002)(8676002)(6512007)(26005)(54906003)(8936002)(66946007)(66556008)(4326008)(66476007)(6666004)(4744005)(83380400001)(5660300002)(86362001)(38350700002)(38100700002)(6506007)(1076003)(508600001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6ten8WLISnGr4S6lg4SEzkqCv/rPiXhtkle3veCmLk5jlCBHDow7xNij9fOg?=
 =?us-ascii?Q?rdkwL77Kz5cVYH3/R6XoIdBm2z+293Wyj7b/pHbzgIbRfckosdcGwzKNP5Vv?=
 =?us-ascii?Q?X38+r4O9oszyNhkrNFKFxqurdR79LgZ8HtOGDKLhFbQb32VkcPRyH6EMKGqC?=
 =?us-ascii?Q?261DLeUkJh1f7luAbkQsJ1GS7sm1GmJok4Fqf5dBOje6qgKy9UzB3QRZo9Ma?=
 =?us-ascii?Q?KYi9A13nwprmeLXmwmZDEEPI/YHrg9zgsqdYxz660usgnuWVEX77Cbiz3aFj?=
 =?us-ascii?Q?Hhi7mXLPfYBmon58LItx9xIMz3NcLQ5HZUNF53htsQoYNF/Wj1mxaES+1Hmj?=
 =?us-ascii?Q?tJtFEBopSlO3Kvw3ikzP9GpC5rBxc+xhTrOP9cFeniH4tVFy+1tDpbBZqsSF?=
 =?us-ascii?Q?nqv9DbC9Zs8ae+QTBvIkjb0WxoOwi+7xePpKh6bV9G30a/SrEZTwTwinnvFs?=
 =?us-ascii?Q?PB2bJ7z+kbC+jgLrnW3Nn7bl3DPuGNqHrfvKyb9X62T+4WUzMIfuHPGII+QY?=
 =?us-ascii?Q?4DFndn640ylO4xtKYRh6xAP/SegpIDa/so6nEN22hHQvJ+alLPC3BqWPVkrH?=
 =?us-ascii?Q?p+ZL4H6TDLI4yZlTxpz2uObjDkEAflBNAN7S2gkbau85ucpHVd4VO7x2c/5j?=
 =?us-ascii?Q?WxcQBn3mXaRgPwTZIb6TZrj4Q5LHbRpEK+eIoQv9tzUcXNczpHOcob5YCwXl?=
 =?us-ascii?Q?U5IP0ysCqiM5U9KZkAjiejrBr+WmuF95f9atxF6eJ4BGxihyZVPLoyJGLge+?=
 =?us-ascii?Q?34IdDoySsSBoIrrUgu4MgQSPQLJhbbquhDmhd0Fr5XiJDlPRs2rt/bjOZNx2?=
 =?us-ascii?Q?mwWkGTkHxDDd1faEcAUd9mMtZ7QWTBjMAp1jJQZHD6KH9MQYVCRenuiGVqmI?=
 =?us-ascii?Q?FRfT2Pzrq2SMx0qWMY131RXYdwALQ+p5aPbbX5pYfhCgS6fYward6zLUWxZm?=
 =?us-ascii?Q?G5ImRZKErH3y4uGI6KqSAoiZzLkg7Fpg2OZvgSWisPUDhcU8RI4xoWS8n+0r?=
 =?us-ascii?Q?kGd+9nvFBpLVRsMDbpxjebBoAByjvUZilDw8bgeDSLcMIgtOFMDtwgwAlpEI?=
 =?us-ascii?Q?RYy5jC+P5cawID5auv8/wrzUgBKO/PFaSokx8b/njuSOl+GsPuKl4+Lr8SXm?=
 =?us-ascii?Q?j5VUhL02mgXyzNx57IQXy+mizldo6OLrQHXHt9V3eLn7UikcB9qlv+klU8iZ?=
 =?us-ascii?Q?T+XeFdQULWrEPfWLtBHE3k+inCxKnbp8xFb8U8UhJqyVjOx2ERrk6uyQrDi0?=
 =?us-ascii?Q?c6ol/w9g8mBHrwKhHU5PZlXoVvl9tbkjo/qxO4CJfEdj6NkaOtVWK0xANKB5?=
 =?us-ascii?Q?lA53LLSM11zxMpuLAjDMF3lI1tjlAi1x/fObsKe0oT9+87mGEwZjP8IYnWC9?=
 =?us-ascii?Q?KTAd5kNuKqUlVxXp6Df8AG/dxEyb7HUNZkPWI8s6XHIf9yTXVFl6ceRlWFuj?=
 =?us-ascii?Q?ttD0g9HktQnIrZYicZu5cdWvJ8C8aE9BnxS4PgfcEYLjqQ1xVXylHydn0vD2?=
 =?us-ascii?Q?Ri8irO7DEO4IR8nwHXoXPVbi6yl5meoX+rNnLmqmm5Sm2ZPSX/T0FPNLHKuS?=
 =?us-ascii?Q?aoLws9+CbqqTfzsGnSPMgg3pvQp5f7/+owoBPzJBSDv7KP0t+qDqz0C1ET4b?=
 =?us-ascii?Q?qyo1yqOOLKQ2xfsz3thL8N+rQrhEJ81Mc4fX1Qy6bglOhuvEPR0Xx96GvQwe?=
 =?us-ascii?Q?jiOmJg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f740f91-3131-4724-95eb-08d9dd4216b7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2022 00:56:57.0377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uCYP22+cH1KkrIulK2KC7JmC6PkOJrMuLr72FO5Hc2kK6hSa+6kZGhaimMgahZ7TIabl0ItIL4vTraKs/844TsGiZVvmFJrtMpVoLg8wKaM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4022
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check for the existence of page pool params before dereferencing. This can
cause crashes in certain conditions.

Fixes: 35b2e549894b ("page_pool: Add callback to init pages when they are
allocated")

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 net/core/page_pool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index bd62c01a2ec3..641f849c95e7 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -213,7 +213,7 @@ static void page_pool_set_pp_info(struct page_pool *pool,
 {
 	page->pp = pool;
 	page->pp_magic |= PP_SIGNATURE;
-	if (pool->p.init_callback)
+	if (pool->p && pool->p.init_callback)
 		pool->p.init_callback(page, pool->p.init_arg);
 }
 
-- 
2.25.1

