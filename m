Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCA3213296
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 06:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgGCEJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 00:09:28 -0400
Received: from mail-eopbgr80059.outbound.protection.outlook.com ([40.107.8.59]:59118
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725294AbgGCEJZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 00:09:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ESWkUVYg5QLmO+xFs1+CiMmiwFia9URyPGGvtt0hO+hOuCQT3x91tpfv0wDePfGN6H4xe/SoXqAGKa7eSWDjOf8FP5a6UORTTs4KkLBhT+qsAFdga6s8UkiAD35d6AmpcTJ4nYhvdicWOumWeTCAoVkusHdMJGXiVyW0vy/dybHkyT7i2BepnRqkoqFSJN/gv013UEixD5vwy613I78d3RhW+SFBcRNleTSQtEbh7tOGp0HXQGXi5xYb69c1JzV8Fs0UUGx0qnjllZzOjZP73gT4fuT6DCLltFf+cbm6C1RAmhmKkskXNmZUIb804o24gOFeolVoEUCKh+v+BsM9Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhmODa/ZLtNa4sAAWitjOocJXOHPMsxWmLh7hQJxgss=;
 b=OKUm97ua5M2VSjHHESqqd+AozAY1NOE6OAw23a2qai/Jce04fzKFaylDUvAi95b+z/1oi10duilPeEG3Gy9rI1L1jKwCUdhv7iCDBDnj+Rpoyb/yTUKoydgBwbJjTtlYgBtTU0WDXu50Qy/6yyabb80c4hQSW7ikhGPXLp1QJqiJinq40/Fn0gnXe0xzSj1xb15nvMr/frsjtzRmHw2NaD9KxA9PKco71VzZGppCrOQ15bIC5Q1pXGst3xMNbpbx3dtG5/sQE1zkagk1S4Ak93mfE0+FhXp95DaqkP6x9vctyX7IDcyk+EegcdrzOTSG979yreKNt3NPIoKllPwsdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhmODa/ZLtNa4sAAWitjOocJXOHPMsxWmLh7hQJxgss=;
 b=AuLGJ87ZOfnZ0hI0Ilge9VcKufLfNU0b1H5etbldHNWYjgximnego6Ejk++jA0BDzwvMw1iHWMYG7bjDYpq3bcblAIDhHc4o743ActOtRLU92vgnO+eQ1qx8H7QZC2FVv0W8J92Hgmin0vz+9fCAm1XhfjQuYWFCa9T69i/hRGM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5534.eurprd05.prod.outlook.com (2603:10a6:803:9c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Fri, 3 Jul
 2020 04:09:12 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Fri, 3 Jul 2020
 04:09:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/12] net/mlx5e: Align RX/TX reporters diagnose output format
Date:   Thu,  2 Jul 2020 21:08:24 -0700
Message-Id: <20200703040832.670860-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703040832.670860-1-saeedm@mellanox.com>
References: <20200703040832.670860-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24 via Frontend Transport; Fri, 3 Jul 2020 04:09:10 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c8277c77-075d-433a-e383-08d81f06d789
X-MS-TrafficTypeDiagnostic: VI1PR05MB5534:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5534D09B2705E1CE0A1C3DFBBE6A0@VI1PR05MB5534.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 045315E1EE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nCvTIgauT/G5ZA7TWnxBiT9DPXuTF1dGGaVQi7qyvYSSCtcqsmDVqKGrKviTx6wogsTynzEerPUv0Z5LEbebO2J68fvzAr5dT2N6mYk0Rm5q3iAZg2a+2q5FavmbtsIhtDMxY05V8fgZSNw8MKcIX3OOfYxMrbCua+H/W+eD2I0shJjfhjtxzQKM2ZoGpDU+W6qer481dqe1Is1nO3CoARp37TbmHEF2RBVT4tJ8ThCEmLFr6fEH9NI2tmMdWt150WXDBgC5Yo1+CIA/mY9UX5/5h9aZ95aP+Fa9E405fZLvaRYPTRQDkDoj7jPWiVjZ/0DZdcKuVK3W/mW1/z5GFzve8Wuj2qFg/WRAqg5EUmZD/iNNSZ6kqrWPoWadtxBp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(6486002)(107886003)(26005)(16526019)(186003)(2906002)(1076003)(6512007)(83380400001)(86362001)(66556008)(66476007)(36756003)(66946007)(956004)(2616005)(5660300002)(6666004)(478600001)(4326008)(8936002)(6506007)(8676002)(52116002)(110136005)(54906003)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FLc+bnfvWkyQYh2BprD9HrfmACFlXfFf4l8QR2MHrv5tpnJViUFLfmO9PWQcuuv2Aofkv42DlojMIPVXTKxN+uyIBnRVrQKEOnMp9ER2SzCXNuGN6PEzOuU8g60waWprkw+D6gYhoDlv1ntoVQnw9WrW79UHn43XED37mgWTVEqEtM4DBtuCTpNeSFbi3PNjFt+FFn/3kW/tSyM+2fl5rZXDIFG1pC4MvfdCqQ+KUi70DOFBg68DZRXTaDF3A5+5wtJXo11qjDyc0xDnU8R+RgLpEZkCk6bh/O+hUe8VoOCx954lEQ0p1txTcFykPT0XTyCLIClWkhVyoXgv5+RwwQBQhSZhlUxlSuRmD0ecV/SZVNOsdtMAL3SdHIR+sVW9OaKPTSsCW9BuBRYmBKepUj83qUdsVJQz26MXrFAOKIaP6zHRYnnxYVeNgVx5N2B7SIIJemKi1rg7uyOg/Wqyx7maZIJfRMNLR5bC5Z4dS6w=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8277c77-075d-433a-e383-08d81f06d789
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2020 04:09:12.1227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CiUGHOLnSIa0HoJr2R810YPjzInbMcBTKr14xw8TP9S/oub/TefOnPPopWb3dQyNaxw6ekMPuL43oYH5b5Aeyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5534
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Change the hierarchy of the RX reporter 'Common config' in the diagnose
output to match the 'Common config' of the TX reporter which reflects
that CQ is a helper to the traffic queues.

Before:
$ devlink health diagnose pci/0000:00:0b.0 reporter rx
Common config:
    RQ:
      type: 2 stride size: 2048 size: 8
    CQ:
      stride size: 64 size: 1024
    RQs:
    ...

After:
$ devlink health diagnose pci/0000:00:0b.0 reporter rx
Common config:
    RQ:
      type: 2 stride size: 2048 size: 8
      CQ:
        stride size: 64 size: 1024
    RQs:
    ...

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index b8b32aef1363..f1edde1ab8bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -284,11 +284,11 @@ static int mlx5e_rx_reporter_diagnose(struct devlink_health_reporter *reporter,
 	if (err)
 		goto unlock;
 
-	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	err = mlx5e_reporter_cq_common_diagnose(&generic_rq->cq, fmsg);
 	if (err)
 		goto unlock;
 
-	err = mlx5e_reporter_cq_common_diagnose(&generic_rq->cq, fmsg);
+	err = mlx5e_reporter_named_obj_nest_end(fmsg);
 	if (err)
 		goto unlock;
 
-- 
2.26.2

