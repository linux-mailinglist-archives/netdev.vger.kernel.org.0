Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4CC94792FC
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 18:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238142AbhLQRmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 12:42:47 -0500
Received: from mail-am6eur05on2062.outbound.protection.outlook.com ([40.107.22.62]:6476
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229694AbhLQRmr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 12:42:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DIOly2OTJ/9CUFJQWANcKGoXmiOtVWE/SK1F3AEAg2WjykJhDHNQvv7bAp98+NgPClMAdPPJ37/UePRyGlJQPs36Sblgg9KnCNw/3vMk8962vb0ljIOFOTRKonrQZuEvIqUCAcQsPhKhexCOAzYr/tbDmHbcqewofUOEeXYH+73rUoioHkwMBJfo5o9T8xJbPlvwzlhjGSFYS0taBlBYeiKCYSo5swi7mX8HGpcsFKVBrrzrTLx7NSMY833NnZ+/OArMIbVbpFhuyt5yEEom/mS+qqQlJbAJfuxXNBsSFMJtx/eO3zB9ZHt8xba05D0bc2VA5xvXmsyHTaLj3/lIwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6A7cQN2tFBrg5zmhnNVaYTKH25VoZFa2CclqdWmOU5U=;
 b=MMYWwkuJw2t1k8b0Glk7ueGxFXTEjs7MaOodUXvdgNqo60PyoUM0u5s0Zbau9/O2OZUkQ+odzPadbpZmqEnc/8ctxcq+bPJ8hmqalQQ2YoVBRrLkH8nVVYQsj7oDG7eoLJy8fHAX8QxYbo40hrIGFeXfV3b3TFfEcmHTboRiSpPaIuxdvLrTr2imsjL4N5Gmp3yVR9hw1ESu3WKp6g14MQ03e/Nyzoq2WYDeRrYu2Bz6RU+B+aTdXwLvc/LTyF/2AzxUBDcjC/dlwHOkJalpAu9R6a916SWu11t05ybwtDMoyDNdl/uXgnYezx6PuqUzoUZKnpvJJRDXCk8AYCzHYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6A7cQN2tFBrg5zmhnNVaYTKH25VoZFa2CclqdWmOU5U=;
 b=Dz+25KQ9JOY5G11vRWexQz/r8cmiLpRU3svkzvu3nBSzNdS2P+7idFOBWuytzGwqCjR9aYzwa4yO2EWcHW8H3FbAuH1N/BP0FLwAdlYmslA6t6YGESVeMVbk5p1G6Y8xf/NEPnNjnNhDsCkxemkh0yW9D/vGmxMGdO2i9JzXxeI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB6PR0302MB2630.eurprd03.prod.outlook.com (2603:10a6:4:ac::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Fri, 17 Dec
 2021 17:42:44 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee%4]) with mapi id 15.20.4778.019; Fri, 17 Dec 2021
 17:42:44 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     Stuart Yoder <stuyoder@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH] docs: networking: dpaa2: Fix DPNI header
Date:   Fri, 17 Dec 2021 12:42:31 -0500
Message-Id: <20211217174231.36419-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0057.prod.exchangelabs.com (2603:10b6:208:23f::26)
 To DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4962dae-d3e7-431d-f87a-08d9c184a1c2
X-MS-TrafficTypeDiagnostic: DB6PR0302MB2630:EE_
X-Microsoft-Antispam-PRVS: <DB6PR0302MB2630769BF2554B681516C80B96789@DB6PR0302MB2630.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 81UJgzcU3xtSTA0J5f7CDUokqsaZ5QmzDZCh71/fWeSBVwnMk2tKK2q8kFIyJ5u+2EghO8FdlogSNPEi1nikx3b6qxdawxhS5WWevTLj070w900yrJu2XVdbKXc7ljPsepKcCsTVdEvlX3Ocb37ngIVz0dkz4yKYH8ebBQpG5k7wZzaW6n5eu10jAZqTtu7LVar2c4cPNs5XGZl9eUqBM/HEezVYLbsD10J36I3+qJRysxGS1KzcjWGTIkO1OO76UhWBMRoP8Wi46QXfcY0BiwE2JIfaxMlBfhWIjBv2L5jjksP2gi3IoqVmoYdg6DA9cjL8YKyozWhl1b4SdoIClzYkdgnLazXJNNNswXgKoZ7mFg5sNChA07qEfAWaQaqhOxJgwgh8HoVqN+9fraPfdDUQ6GoSAElaamUR4PxztHxWzpxda+BOD1ul8qeiJLHM4Q6JQXGp8bvzrZ/RLz+nR3tHZlXMbfrF3VY4eCNj9nZ880V/+MGOr8+EUeAMndSQ/+LHFZFAV3vYAeLM8J0ut0mt1YxvYUreNJ0/Ny2uRFyXTfmhxJf0XaQLbB75/CPkewZ7ISy+Nokmc1R8vTfA/Ro5DUnEmOjylocpeURuWDnd/T/LAN8sJHZ5zw3ZrH2fYEDhTuv+LW7vx5SI5Do8f8nQ4+HT95wgx8ia+AhGgWKu/0q0u8YsDx+7DZPcIuV69ocUGKvtDx/qLEv2YsZd2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(54906003)(6512007)(38100700002)(2906002)(2616005)(38350700002)(44832011)(8936002)(316002)(66476007)(6486002)(1076003)(6506007)(5660300002)(36756003)(6666004)(52116002)(508600001)(86362001)(66556008)(66946007)(26005)(4326008)(186003)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BP98w6wN9c5H88/iZPSp32dCQ1ihq+DpHwmoFAxqptgB3uUGBO/jlPxPI8vY?=
 =?us-ascii?Q?BteTlQ3HVx3DiyFTiSxNZzOROb+sePKgawMoZKffOtGwhX+7H8TdnJi+qP0q?=
 =?us-ascii?Q?KE5lEn7vh0iywCd0ed4WrdM49hr9aEg+tvxMovguY8zye5C7WBCyvy+O493I?=
 =?us-ascii?Q?lWSrva8iKLvyyPe0gXD2RPKnPSWhJHhytkPe0tN2UZxF4hLiXZyYfQdCuZRW?=
 =?us-ascii?Q?aMKqWuxtpkbdO2wpdZ7W/y15u02mBzIbZir9OcDNdkJfiMZUeazMLOsV/oBM?=
 =?us-ascii?Q?h6keDIdu3l73KGk71TwGRBCJEGMrByzF1F0NyeHTU1Xxj+sKPw2DBS9UmfZH?=
 =?us-ascii?Q?J9Dqsxsd6OBsR8rjM+Tr1zj3llGAmlvESSe6FX9HHQ9dsJKUEvdcbEzhcWph?=
 =?us-ascii?Q?pThmbBtFhhO2TFB6TL7oiNFTk9yW40nUKPmHHqcmeGe/MbAKoAykAA9FjjWP?=
 =?us-ascii?Q?y1oGZGl1y1w352xyoJcXFzDOkSO5FocBpe9czx1+ehCEhvm1U554XpI6gMGg?=
 =?us-ascii?Q?K5lcnwNzi+pqot32jIScQl7lkA3Fm+3hyKUvcXGcm2+T2V3i5l121sHs+YUD?=
 =?us-ascii?Q?kaf5MehJTcV8oqrqer006CGavQI6NFTWfpDKc0bwDHgyxKhGJDuA6fYjlETe?=
 =?us-ascii?Q?QxdduAvy85N2NOwer1jvNrsZ895jqg3ukk6V0dxulM1ibE4hQihAIraygfic?=
 =?us-ascii?Q?NDGuEZ433P+XirBgNDGgctaWjEI9cIz6OPyjbvy10bF2MnX9Do8ZKIEMsbLm?=
 =?us-ascii?Q?Eb3pFrTJJKYdge9Im6OY94EC+tJGtq/a6Z61Nq7ZFqpmWWazLWD+bPWTXCo4?=
 =?us-ascii?Q?nDm0EiEowzcqa6cYJZXxhG503zV1E3YXBhJzvmzo4Y1N8PQjAplP6hpC/BI9?=
 =?us-ascii?Q?UH6aVphZ/f8gOVfsWrHMnsG9ELB+xHsUtUnTP6OT/rgfMPPAdUHLA7gtoMof?=
 =?us-ascii?Q?MrLSxdnRIbFynHTF3OcCyYCqHnrZ+KHFpVroUK/h+gVf2MIUBoxoEFiuyJoZ?=
 =?us-ascii?Q?Ms/ukKPgfXS17mPyTip09s//hJs3BO3CeNkPfcE8OUYTCU1fS/NmlXGw/hBU?=
 =?us-ascii?Q?7vH+p8RoHFAL2dAywiLmYglKl3ZH+CsMTDHSnKjC2E3eYXckbkp6lm+ZUW25?=
 =?us-ascii?Q?5+tuAnICxmIkmunHTjiGl+DuJ4tddJp7uuDNT/RDTg97AaaEXTmsJKU6a/T9?=
 =?us-ascii?Q?4xi8pdj0Vtxnr9bj7RrD17AsunhFN1B86BHKGy69FsbpKyftRgSqn9GmD5tw?=
 =?us-ascii?Q?uqkKSYo0uY2BAbyB8v3N3UHsV9/BIEHk37XkBzoSMjYBmEVCCjSmRTKtEC/b?=
 =?us-ascii?Q?hNl15mBo8e/ohEDWv8k5kd1kslVoDtu/IZLCZ3G19wBOACb6yCcGsmUkdn/l?=
 =?us-ascii?Q?SR6H19xXzwAJK4xNlQkcNZBj4IEga8kANcz/0rrg+Owr4qvRpGxwFVmDVW6F?=
 =?us-ascii?Q?XpflhAvAOTXl942fGBtYyU2xrxlXOwus9KO9tzCZRDaW0wKTUu463ycpodwq?=
 =?us-ascii?Q?gVzwYm53dEl1wc+YHs+xZP+887iae6L24GS/P9F+14XPpfxnSs3hhonUIlws?=
 =?us-ascii?Q?jm/73O0ScgDzQGkfwpX0K843IK3V9zP81kZvQ36mUO5beO4GyR3YMYFbFYMX?=
 =?us-ascii?Q?insddazUPL3l2iJst2EFLAg=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4962dae-d3e7-431d-f87a-08d9c184a1c2
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 17:42:44.5637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: itjkDoBSUnw68LkKnC0Ax6/prjkMkOfJAcgD2zsZe0ZgIWjZuTWm/HBlTyQ3t1omfKfDFZIE6V63euybTD0yag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0302MB2630
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DPNI object should get its own header, like the rest of the objects.

Fixes: 60b91319a349 ("staging: fsl-mc: Convert documentation to rst format")
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 .../device_drivers/ethernet/freescale/dpaa2/overview.rst         | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/overview.rst b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/overview.rst
index d638b5a8aadd..199647729251 100644
--- a/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/overview.rst
+++ b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/overview.rst
@@ -183,6 +183,7 @@ PHY and allows physical transmission and reception of Ethernet frames.
   IRQ config, enable, reset
 
 DPNI (Datapath Network Interface)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Contains TX/RX queues, network interface configuration, and RX buffer pool
 configuration mechanisms.  The TX/RX queues are in memory and are identified
 by queue number.
-- 
2.25.1

