Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA50350F4D0
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 10:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345289AbiDZIkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 04:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345510AbiDZIjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 04:39:11 -0400
X-Greylist: delayed 595 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 26 Apr 2022 01:30:00 PDT
Received: from refb02.tmes.trendmicro.eu (refb02.tmes.trendmicro.eu [18.185.115.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5600B1E6
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 01:30:00 -0700 (PDT)
Received: from 104.47.6.53_.trendmicro.com (unknown [172.21.19.198])
        by refb02.tmes.trendmicro.eu (Postfix) with ESMTPS id B69F81011169D
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 08:20:05 +0000 (UTC)
Received: from 104.47.6.53_.trendmicro.com (unknown [172.21.182.42])
        by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 7A03E1000125E;
        Tue, 26 Apr 2022 08:20:01 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1650961130.084000
X-TM-MAIL-UUID: df213d97-d164-4352-978f-460376b902cf
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (unknown [104.47.6.53])
        by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 14DAC1000218B;
        Tue, 26 Apr 2022 08:18:49 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pc+nvPWZW0CPHYOoSrFjWtBIe+3TJXBG0z08NNh1fBqbLYa1+BfY5rYXTOehO1N8pfnHaTjxMjHOymkHivjdJSN7ivezoyU680vvdzNdXOXZcmXFoiMnQ/xc/F0LIsz/ouSH2NZ1rfA2PaWj6ZSiU7EbCu56jVMBXdBTgF5bIou6g7kLg+7VIsDU75XPPpumLVlSHeqJH9ROHqYqUqlbQaUCav8xQ7xmXaMdOVZriwAm3zE1bJ7Sz/Vm4f6jbU/1teHhEvKK0cEtzrP3MTb599Za0Kvix0rZxOtR+a53i56nC0Q2QDzNJp7ASh2WpHzoytiqe6yeY6bwiLWYqUYH0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j6+Pgu/wG1SL3tSvBgFrY1T0JrsZ6JZG5UF1jpvUBZg=;
 b=S8CAJEUJYL56XOdVc0Y3gZLDzJs728uUR5k3O3ZZn/qDysaSDiaOmGJ0kSf0H3N+CZLKX69li1mcB2HM1oX5eYQGgHstfdG4/3G+VgPsalrUJEdodxaL99U5XQMkbUBIA9zSHMashmJUUqxcc2QEpucX5dQz7pVaCR0/XLWhWm6v2VIkXt29lpGGnF+bS7PD69IMJM3maDq/F9PWA8j+rzVq1+e0UY7sVOTljE9AltIDOD9z8oVDHOKqQNTBEOJE/Q/N8qq6TLPlLSXE2hEM5CX2a17pPt6sfJz8MfTtCa4RNQZVmwEY53mx+nlU5lNY5I1wOH6LsdpQT1dKbp+Ufg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.66.60.4) smtp.rcpttodomain=davemloft.net smtp.mailfrom=opensynergy.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=opensynergy.com;
 dkim=none (message not signed); arc=none
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.66.60.4)
 smtp.mailfrom=opensynergy.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=opensynergy.com;
Received-SPF: Pass (protection.outlook.com: domain of opensynergy.com
 designates 217.66.60.4 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.66.60.4; helo=SR-MAIL-03.open-synergy.com;
From:   Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
Subject: [PATCH] Bluetooth: core: Fix missing power_on work cancel on HCI close
Date:   Tue, 26 Apr 2022 11:18:23 +0300
Message-Id: <20220426081823.21557-1-vasyl.vavrychuk@opensynergy.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 501170bf-5ec7-43e7-45a0-08da275d636e
X-MS-TrafficTypeDiagnostic: DB7PR04MB4810:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB481061077A09DC5BD3B47D5AECFB9@DB7PR04MB4810.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nHzIGoZpIsmDUs6RiGVK8InnD4XkHa8bt9DR8QLtykxgX/SBMzLSHa3KmXedey5ykTtLsI1rJo+I9cPvS3QVc0j16PRMyFgK6IXPwA3mrf2WLhmigMGoKtg1YpSTEiswcgFEFw27WThALMMo/jmU1btPcBPpYvUGVHQjqqQJKyNDk36xKaE6i+eXqIfXEdGflnkD5c/bDDYP/HCCIWus/ufC5USfsoqdtYroVkLZHmmNRutLHoKKexRsVM607tvRbW8U7MypdH4EFdoMrwHRVRJUH2HSk0X3eA3MpjcHHSFoWQPmKEI2voswYr+LAefURkCkCR7lnmrRcxllKMl8E3fbii1o8MMcpYH/RuWjVgVtvjbVhkqWKwdl3aauiTfAvuJVna4Bo7OtCoaU9XalbxDA/EZzLCM85zBI+KlcfmYdJIiGFrum21/gPMaSHn64sj6Fs3Hik0xFnw2ncP/9q8wW++CbAz6osQLxqeprvlByddTPmsJzYOut31BaTWbkr1nQQikQz3E2GSH7sdMre6uzQHgaq2wIUV2tyBHxv8fRxXRkHdgFzQ976WzCMSPJKPKwHDRkNyVFjZTed5Ay9ViEg7DpuQoExZp3cwi91BHriZyHzjKgsAljwPb3H7SG8Ut8ZQGjoEmr3FCdCJgNQFUztZ/kTPvr1XK2Z5ELlwM+uneFn6ES2iOjfz4LaPRc
X-Forefront-Antispam-Report: CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:mx1.opensynergy.com;CAT:NONE;SFS:(13230001)(376002)(396003)(346002)(39840400004)(136003)(36840700001)(46966006)(81166007)(26005)(70586007)(36756003)(70206006)(86362001)(5660300002)(44832011)(2906002)(508600001)(4326008)(8936002)(83380400001)(40480700001)(36860700001)(54906003)(42186006)(316002)(107886003)(1076003)(336012)(186003)(82310400005)(2616005)(8676002)(47076005);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 08:18:47.9178
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 501170bf-5ec7-43e7-45a0-08da275d636e
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR05FT018.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4810
X-TM-AS-ERS: 104.47.6.53-0.0.0.0
X-TMASE-Version: StarCloud-1.3-8.8.1001-26856.005
X-TMASE-Result: 10--8.517500-4.000000
X-TMASE-MatchedRID: 87nu31iyiq0nUo7A2pUbcVVeGWZmxN2MiK5qg1cmsr/pDcNppAyF7y1s
        QGcqD7UtOLejJ6ccXRy9XH1WKh6kzcFnRyUPbswoOGTV4fFD6yCUq+GQ/zyJdNzONa1Rspx36Ch
        K9oqyX+Qi+t+0AiFaYvL3NxFKQpq19IaoJGJ/0IvR7uN8GOEHx2vaomg0i4KNNP1+Jpfbz7PbvL
        AHy5vsJOgc6mX1lwNHkRoxEQkO3VF1H8bw68oiD67rlQMPRoOCxEHRux+uk8jHUU+U0ACZwBU9o
        pSlzGWXgYVRxD442q71A99fjzIMpRmAwVUvIOlynqg/VrSZEiM=
X-TMASE-XGENCLOUD: 6f6d8b2e-5f7b-94ae-bd38-46078b2ad1fc-0-0-200-0
X-TM-Deliver-Signature: 8D88C8CFD38102D18328CE92B9635BE8
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
        s=TM-DKIM-20210503141657; t=1650961201;
        bh=6Luu7RUoPayupfIaY3ek/X2ofFiL4Tlr868h2CngHuo=; l=1389;
        h=From:To:Date;
        b=R1px1OR7jwykPfyyiROy+SRztnSV+EEIwyQw024P5MMiHuLttlCHLYk/fHTSfbwfz
         H6fEf3RkE6hRtvarGhZDQEftCv3PyndyOcku2IxGWihsLyT/fMoI9SOHcI7fqTWfGT
         t0x09wpC/xqd9i3dyGIKh00M38eL9SU89wlHkYag1ll6sdBN4JR8RlJechKe/iQs4N
         d0g6Ftke/aic7TC7pg3mOqnwj4yEt2aRpJJ0bdkRRCOkxOioa+OauHQ3TCKifgoMQY
         O4IKYSpWPCsaJ8Rqh87efTWjGr3XUZcMnthsahwrSd3qQh75tiiVQ13m+FHR9voiSg
         aeabMrsIFQh8A==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move power_on work cancel to hci_dev_close_sync to ensure that power_on
work is canceled after HCI interface down, power off, rfkill, etc.

For example, if

    hciconfig hci0 down

is done early enough during boot, it may run before power_on work.
Then, power_on work will actually bring up interface despite above
hciconfig command.

Signed-off-by: Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
---
 net/bluetooth/hci_core.c | 2 --
 net/bluetooth/hci_sync.c | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index b4782a6c1025..ad4f4ab0afca 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2675,8 +2675,6 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	list_del(&hdev->list);
 	write_unlock(&hci_dev_list_lock);
 
-	cancel_work_sync(&hdev->power_on);
-
 	hci_cmd_sync_clear(hdev);
 
 	if (!test_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks))
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 8f4c5698913d..c5b0dbfc0379 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4058,6 +4058,7 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 
 	bt_dev_dbg(hdev, "");
 
+	cancel_work_sync(&hdev->power_on);
 	cancel_delayed_work(&hdev->power_off);
 	cancel_delayed_work(&hdev->ncmd_timer);
 
-- 
2.30.2

