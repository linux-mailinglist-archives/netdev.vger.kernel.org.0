Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0479432C4D
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 05:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbhJSDdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 23:33:42 -0400
Received: from mail-eopbgr1300118.outbound.protection.outlook.com ([40.107.130.118]:21600
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229742AbhJSDdl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 23:33:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b84RRAD8kSASHEASxQQcLGQCalnYyp7DgtrZE6/lqISAiW5vk4HxaX0j5qUsJUDTa/VFxT8LmjMHhvA4303uGdtqf0Y/gcAS7xJPC5tATStIq6kdJgjqrwXzzQHXCXq/XyobdDxniEiOD+/HwgiYk3LgJFambrq+2C78lB51uC008nIuC1jhQ+aFijMUA4nPf235GLG5LuK/5ioFt47Rg2v0anTVZLJOca7qrsvv+vZiPXvrOxt2wv/rqlLYilzeM/7WOF1nvJ0MirU8cae2pDHL1h09koWirl9te/hcghOTtMDxmWx526M/QoK9L2qXL7v1UKJJL8VWFFg6+WzJSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l+/Gbl9RcHPHALXzUQc/IaJJru4/7ck30TDwkTTPLi4=;
 b=KV0HmEVDMdkUoYyuEZtdzL5foTBkd2Ia/JDknfAUl/p+SdLqVaaBPTBet86zkUmiVgvOcXWcyi3noW6pAN7S5pleoczuRwus56nUGZvUbrfoI0GRw74nMxD4D9ONfs+HwV2EH6sNhPBN8lQcjhda+kHFVMQSvybT+30K45F64a7liVdQyfQFMVDWUBSbYrwGwDZHfpB1MgnfMY144nh0lHOjYrHD/Iw/54E84L7WAAV2720Qv2enDO3IZt5RB5j+W0DfqXrH+BjsFAR0+VQ8/EWJwKgUm/0UK0a1U/3yfprrNF0XAIEhDKTNXDizL4A3Zr7Pcq9fRoQiuVWzB5nUjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+/Gbl9RcHPHALXzUQc/IaJJru4/7ck30TDwkTTPLi4=;
 b=k5NVNdeImy4/NC664iMYbBhQi9gBMMGDvcSnqk9hcFiocbAou6gBIOP3wQ9ePCXKifZuzjRShC61/TWP/k16rbabkPK/BD9r5gwlT1p6lIHmUtdsCeYYsaQUlMeXyhmAeCLEGCfc16UxZ9/fIOChaRIpIQ19bql6T+uOQ7p4FOo=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 SG2PR06MB2121.apcprd06.prod.outlook.com (2603:1096:4:9::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.17; Tue, 19 Oct 2021 03:31:27 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0%6]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 03:31:27 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>,
        syzbot+4e7b6c94d22f4bfca9a0@syzkaller.appspotmail.com
Subject: [PATCH] mwifiex: Fix divide error in mwifiex_usb_dnld_fw
Date:   Mon, 18 Oct 2021 23:31:01 -0400
Message-Id: <20211019033101.27658-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HKAPR03CA0015.apcprd03.prod.outlook.com
 (2603:1096:203:c8::20) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
Received: from localhost.localdomain (218.213.202.190) by HKAPR03CA0015.apcprd03.prod.outlook.com (2603:1096:203:c8::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.13 via Frontend Transport; Tue, 19 Oct 2021 03:31:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47f3bd93-0aa7-4249-5e58-08d992b0eec5
X-MS-TrafficTypeDiagnostic: SG2PR06MB2121:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SG2PR06MB2121F713F67BC73DDDEC0C9DABBD9@SG2PR06MB2121.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NZXmGl7az5JVxAamJ9QAolSWAsvUjprAoXyi+PMmCiA0z33CWuY6NT+tyUHxg5Gh/851ZXErpUGSPBhuyR+sgEOrEy7vxu68rXxVFr0efqVM7nLR3q6DPOfvlN24rvLYqpItSu1Ebh3C5+tcHZOEC4AgxR9PVfVx/TOnIP8u0LfTb8CyjFEpODyrRy8NAvsyvlQZ2FYGcN32TDYjwyABcaCaF0LQtS+bT9c0vNtOJwYa1eZ860NFghrR05dZ+mKlhTZhz/MeoZqjgWsXoxmyMfEI71hTXtC6LXjZJo7+lrVDB+RVmvHA4rdNPv0feoY6y/V+WoDJmyACfSwHywiADfvIhDH/oS3QetNgOBz1+TPsGtjkkkt95IKRCAVXquMvxUDoxC0NIEE3fLcAXbqLxNb74ffEBZuXI2tAvpL06lTiyMLlRLNLJu5q+PFtnNXSQ0WoEsu4VBl2m8omw6TkFKPXeuXhBUSpliXJBmlTh17a4l6Xzpsd8LXfR1yyNn1V3KdPotu5MzolD29weur18rt5p0otEmZ4oABj5QqRiq8roUJaCwbaWko4vrooYVZDuabP3D4jxN0NGdJ2Po84xzM1gyqtN2RJhXzDBWUFfNvslJf4FYgG4OfKeQtYxSjpNEPn4BbZgKITjLglq+CvzEGY0eibf9btRIoKyWIYrAKh0ArpXQ/V64tHZCidocseEz/xTV6vtiiVSLGtn7tmhxphbR3JPiRvEAnFmGGpa/zq5crRU5N1RUJ/ODMTcTJj26TWTSOtnf9OwFAc48I7hwVtX0Ws3aAWSduUFt4eudDOgjMpLPi1Qk1FFQ54eAj2EjySfEH2i0kk9O8C5c6idF15vsSwEET0CDClbSQKMpLOyCkXM3WrrODGtWwVKm6ytVNKwcP1VUA7xKECza6SHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(6666004)(36756003)(6486002)(86362001)(83380400001)(66946007)(66556008)(316002)(66476007)(921005)(6512007)(8936002)(1076003)(52116002)(110136005)(6506007)(966005)(38350700002)(38100700002)(2906002)(2616005)(956004)(7416002)(4326008)(508600001)(5660300002)(8676002)(26005)(99710200001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TfegXpZXODXgHAlBC2CCIWAs8ALQ5NGfHi/9RngV0t3/8DmwRUBE7jGUa9K0?=
 =?us-ascii?Q?meD1HcGXxuJLXna5adU0L3/Deiuj1pIJXMfV74QX5raBA6whKSsjkUDmEMhu?=
 =?us-ascii?Q?8mZUekR95HiC5I60SzF99CUAqaHd/2rS2Qkl8TJ7RoXHqFHjcyxU3v8GyJ+x?=
 =?us-ascii?Q?OeBaNvbsogSXE3wanfLFCFGn+dGssZn4Im6awvVZoZ655VsDkUDZR0Qi3hM7?=
 =?us-ascii?Q?gYNohDHblFmJQRZp+r3ENvo3xxMkSMJSCQFunRVTbjzZ25eJUsqgnILkGMGT?=
 =?us-ascii?Q?X90BmX4h3Lx1wCuVTL5H8SWVR9sy3GgdHzTgAcBVj+7Tkq83654fk76RvGlP?=
 =?us-ascii?Q?CTHjEzXbZ/sSK9VAmitUM0YfukdsdFwi2tP5wnU238IxlxXzutwtJM2DkUar?=
 =?us-ascii?Q?w1vf3WbXqyOSCoKc3vYpjq77qqYnOZj9UkfUWRwp3pF4Y5yAChHMoBSrwno/?=
 =?us-ascii?Q?w68I8wcBpFdcHvyjbRNVF2yrc7g/hPgNZSfmQCCMybyelc3Wll8TyK+xGXck?=
 =?us-ascii?Q?9pSooZYyRUf+82B/CYY8DFREBSOLX4vympu+F/0WiNtvIl52x0j+oKgNYsvq?=
 =?us-ascii?Q?oPSYyH6iNQs/NtJXUZUaGwOYvKUnPEburRcTZaVeW6wkngRhL9bEjF81xHvQ?=
 =?us-ascii?Q?9F79rfDM0nclDjXsB4zppbh6fk+5SDfIFDZetzAaF+Dw+4Mpp0u/YbRCAzVl?=
 =?us-ascii?Q?yoV08AwKdnfsYNgdU/Utf4z8hxsp3xrmAGus+Y0dYgQkQVBV0QMc6lFDwLe9?=
 =?us-ascii?Q?iZNRi4E1umw4ygHCulcNjPDKMtDUgkrsZBzPBq+pmn5zQiJFntS+pkvDEv7O?=
 =?us-ascii?Q?d/0QO9goa8YSfAU1uLF9fe7TVVDKcYXtyLvw8BgfCB/rSqYDr2kwrnvEPQeu?=
 =?us-ascii?Q?srNsHl8KaxRJqpUL7mGCq64/UGSoHCAxriMtTMv/VyDrUJARRnDaQXhLpvEd?=
 =?us-ascii?Q?Xsasu90B/OJCSABk2IoyMGQOaBApqABalr6srf4neC6P4EWI/phnlYjXipHE?=
 =?us-ascii?Q?xWKEuO0QAYFcwaKacKK52LDgNiFEIe75ABkY8zOiByHz1avVzuRjWzCPrIHk?=
 =?us-ascii?Q?sa7kRAim5KhFX/DneStXIVPMnNEftZu6gJEJF4bx4sBB+IO/i4Jzox3yySzk?=
 =?us-ascii?Q?qXPFXyMBR/rCD0fSkiZrCoeOBjZaYhwlTStjhul0PCt70ixe8drnCidoTnMv?=
 =?us-ascii?Q?4yhe392yglqBbWxjWhTvSk+VUHmLtfhK4nlkUku6mZAHWHQVFaRUNS2GaIM0?=
 =?us-ascii?Q?8I8iLVOEbcBgyl4iPZxvvbxVG+aHRJ1qwRuGz6iZ4yOtboY3mwpA3x5B3WOD?=
 =?us-ascii?Q?xBMGOdoiV88S98fFfAQ1Rdft?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47f3bd93-0aa7-4249-5e58-08d992b0eec5
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 03:31:26.9935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cf+FfcmUM4ekKpLsS0OVptUn6WEDLb8sBIq53eLDHnPjL7qXcOwctgC4U5oqUzNP77/nVWXl8aQzyhLEYOxDHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB2121
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch try to fix bug reported by syzkaller:
divide error: 0000 [#1] SMP KASAN
CPU: 1 PID: 17 Comm: kworker/1:0 Not tainted 5.15.0-rc5-syzkaller #0
Hardware name: Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events request_firmware_work_func
RIP: 0010:mwifiex_write_data_sync drivers/net/wireless/marvell/mwifiex/usb.c:696 [inline]
RIP: 0010:mwifiex_prog_fw_w_helper drivers/net/wireless/marvell/mwifiex/usb.c:1437 [inline]
RIP: 0010:mwifiex_usb_dnld_fw+0xabd/0x11a0 drivers/net/wireless/marvell/mwifiex/usb.c:1518
Call Trace:
 _mwifiex_fw_dpc+0x181/0x10a0 drivers/net/wireless/marvell/mwifiex/main.c:542
 request_firmware_work_func+0x12c/0x230 drivers/base/firmware_loader/main.c:1081
 process_one_work+0x9bf/0x1620 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3c2/0x4a0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Link: https://syzkaller.appspot.com/bug?extid=4e7b6c94d22f4bfca9a0
Reported-and-tested-by: syzbot+4e7b6c94d22f4bfca9a0@syzkaller.appspotmail.com
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 426e39d4ccf0..c24ec27d4057 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -693,7 +693,7 @@ static int mwifiex_write_data_sync(struct mwifiex_adapter *adapter, u8 *pbuf,
 	struct usb_card_rec *card = adapter->card;
 	int actual_length, ret;
 
-	if (!(*len % card->bulk_out_maxpktsize))
+	if (card->bulk_out_maxpktsize && !(*len % card->bulk_out_maxpktsize))
 		(*len)++;
 
 	/* Send the data block */
-- 
2.20.1

