Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D1A1C9E57
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 00:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgEGWVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 18:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727029AbgEGWVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 18:21:20 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on0729.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe02::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC10C05BD43;
        Thu,  7 May 2020 15:14:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lfrznmgiyx97wQtYztY0lIMLQBRUD/ffxTI7nH+s/T+XBTiB6w0gevpxAkz5oRZy30x1bIedstn3giG5Vd+KelPOfNi8SNxKhwG6sxdrlv/7OmlTOFt2xO8nkWCHxs24sPNjIzssIRIayvxA6kHU/byk2s3pm3GQKQ1ej3iyddgyXBEhPQy9FszQDx1jHTYLVjDb6qbREN1FiZx0wq8DZx+x+LODG615xU/wVEX2rMbFGCEJjASmxVQVZV2E9TwrF2d759BUkBwbEDjP6kSapQTC1c178ByBBg2FAsMKtlKLO2n8lG/nUEPLxuDxMwT1T/IscJN9RjHTY53qH/kkfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OpX+LulVK4KF2QCHRgf+FaJ8qLCSrjPQZA1aBvpvpsU=;
 b=WPY5dzhuOPyr9dlw0eu70J0XA3VcG0FtzA9tdfNjRekH0qRamaVpjb/GY7PasXpUgsWniME/gXD6txizgt+HipgGQmO61fatoEV24yBO5v1vVspfDZDohvY3wnwR8HxKCoqJA31MFg9mPdDH12EsoTvBILTKxb9mFxHnb42Orc29dVtjlfd9jqTdjcx8M52psrUl0zw4N5dV5Vuu8ikSQ11KEfvkjeD//crshNbl3+WcMo6STaLt1kfGH7J8zZGzD/8aFKnnF75r+FV4Tpf+gfO+1CQMlfpfKjM3xqG7RahFIA4uifwGYQm80ipSpqaIwbmM7WDDHyLVzTi0r4QXCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OpX+LulVK4KF2QCHRgf+FaJ8qLCSrjPQZA1aBvpvpsU=;
 b=g2bHM1wT5JjcYtIlQEWZb5E9eJz1yAUfybo0oayCvYhRAHAf+HSxmKtiRrkBB3NOssd5akhcs5+Ad7eABpQOg2/Ic1cpA0JxQBGEKb6CBXcRKdfbbgTyIILqOIGW2uf2dcvbrErkSqDS+HGQksUcFl2h1mJXsxlbzGUWBo1KjZg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=criteo.com;
Received: from AM6PR04MB4230.eurprd04.prod.outlook.com (2603:10a6:209:41::33)
 by AM6PR04MB6247.eurprd04.prod.outlook.com (2603:10a6:20b:be::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 7 May
 2020 22:14:46 +0000
Received: from AM6PR04MB4230.eurprd04.prod.outlook.com
 ([fe80::f151:2536:ba90:6629]) by AM6PR04MB4230.eurprd04.prod.outlook.com
 ([fe80::f151:2536:ba90:6629%5]) with mapi id 15.20.2979.028; Thu, 7 May 2020
 22:14:45 +0000
From:   Vincent Minet <v.minet@criteo.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vincent Minet <v.minet@criteo.com>
Subject: [PATCH] umh: fix memory leak on execve failure
Date:   Fri,  8 May 2020 00:14:22 +0200
Message-Id: <20200507221422.19338-1-v.minet@criteo.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P193CA0037.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:51::12) To AM6PR04MB4230.eurprd04.prod.outlook.com
 (2603:10a6:209:41::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.196.75.236) by PR3P193CA0037.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:51::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Thu, 7 May 2020 22:14:44 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [5.196.75.236]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e37a00b-56a7-4998-1ac5-08d7f2d40c6c
X-MS-TrafficTypeDiagnostic: AM6PR04MB6247:|AM6PR04MB6247:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB624759DE6B3743C40D20CC2C90A50@AM6PR04MB6247.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03965EFC76
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TcDBE5OwoFD1vdWWhSo/xsOOQxKk8Tk6TfauJGXcJ43doQeyqwTGIdii1WPCaUBNNzINL3j2L1FEF4IUOOGZQ8U+oqdZphKn8FJ8Ye6o6wEfGsg8IEodh4K5uo1n5QbOD6btiqE/jwWHi5mpNGk0aUmhThUhubQ3CcbDVNH11pwI5YRBxrylQ945eqHTEUGrv+xUAD1v9aPyKhYy6xyYvrmVlNDSEauKxCxSjKXnaXFhvqUSn62z8h6xgbQI7wgsGJa3gaMu745gI5dg6HctPdRtuxOMxVvp6NL+64nDPT+ww8x1iGV0LkoECzQf+TyZdEoPYI6V9zQ9SmLWB8H6jYIYQhtFPreXhwSqalv0SwPBsw6KvP9RHC8kpklVpiCcx5kxEFS0Qzkw5e29SCGWc18Q3NkMME66zgQG4iluy95kaOFoE6IjAzaiW7W/ECGbl1X+BcEtVgWYbSyojfb9dl9MULJSA7GLs1CI3uWRuivsjmoGMZCovd/GJ5zjinfF6ih3e6BHGr/rsz6WjcTuljtMUVDQEaOyb6CEIqZu+Lpg3j7YuxX3nX/MWkzo0T2u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB4230.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(33430700001)(66556008)(83280400001)(83290400001)(6512007)(6916009)(8936002)(36756003)(1076003)(66476007)(8676002)(107886003)(2906002)(6486002)(33440700001)(86362001)(2616005)(478600001)(956004)(4326008)(5660300002)(69590400007)(83320400001)(83310400001)(83300400001)(6666004)(186003)(54906003)(55236004)(316002)(52116002)(6506007)(16526019)(26005)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 86jiMfTlQ2BdiePor19gwjsuMSqjs3myWqImkTf7bQ/4Q4sYHhmk5QW8fz2xKyjIiGQ9nT3AxVuK5JCgfr/ZPJ7dDScgNbjy+NyLLFY/7ZlIlVepkQMhFPfIFCxVGGgvhDP6hWF2Jrz61Age4Inlh19r4e6aauizb8OMHHwiemHTiZOXqINvMAqqLxXmjJni9mqXaA0OCb4SdWrYQ47yhpry118QUbnpI5kKDhZaYfCb4FJ+nPW1KoIXWhZO4llhzfA49yygxBHG5BuQ6fM0YfND/aZ/1XuoW0zMU98cIZu25if0U7CKkQjG53ITIBci5hgm73Om5UCgViPstRt7Q1AlQ3Kiql5dEUMckzRFhGNw3v8JNbD5xzgl6DstJ0Gp0lgZFVRUqBOkdSigd1opx5ED0aD+4v9DrNYxtwAum3sm0od9IImUGH6aAoWx3ibZw6lZw/ysWfIj/Oa+WJwfnQHY6PKsBhQtGL5YxHRdquqJVPuN4aPSR9kkMhOa74STGAuLJ88cahoPLaspP27rl6mNxyjeNb7YA5IpAUP0ZqvpPHiGeUxHlRhdf57q3sFgSiEfAf8B/6s7JQU5FbnqVniyDARJXd1YZzG6dCt+K+TlIAAfV3pDyAX8Eb439rO8e7DuraaYcEC7wLbP0Nz+rF2HhdkGpfnSv7RvQTP/Lx1YsPpFE12HIy2ilZKcwaaYC2wldBdlwKXRdB8Xv48oXPgc3mFOD1i1HqyQYimg3cGHVsc0imUQ3xicUNHNx7VrFIWzY/5KjHI4/95eBs529MF4bJmmefrVDIndRc9gLFE=
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e37a00b-56a7-4998-1ac5-08d7f2d40c6c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2020 22:14:45.8440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V8jhr+KMxkPbp+D3iovXTk1caY4e6Y0FdHenhGLYZ/cXZBYUlvRpOiNfMw3aHF2EtuPp5dglvIhd49DGBvzpmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6247
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a UMH process created by fork_usermode_blob() fails to execute,
a pair of struct file allocated by umh_pipe_setup() will leak.

Under normal conditions, the caller (like bpfilter) needs to manage the
lifetime of the UMH and its two pipes. But when fork_usermode_blob()
fails, the caller doesn't really have a way to know what needs to be
done. It seems better to do the cleanup ourselves in this case.

Fixes: 449325b52b7a ("umh: introduce fork_usermode_blob() helper")
Signed-off-by: Vincent Minet <v.minet@criteo.com>
---
 kernel/umh.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/umh.c b/kernel/umh.c
index 7f255b5a8845..20d51e0957e0 100644
--- a/kernel/umh.c
+++ b/kernel/umh.c
@@ -475,6 +475,12 @@ static void umh_clean_and_save_pid(struct subprocess_info *info)
 {
 	struct umh_info *umh_info = info->data;
 
+	/* cleanup if umh_pipe_setup() was successful but exec failed */
+	if (info->pid && info->retval) {
+		fput(umh_info->pipe_to_umh);
+		fput(umh_info->pipe_from_umh);
+	}
+
 	argv_free(info->argv);
 	umh_info->pid = info->pid;
 }
-- 
2.26.2

