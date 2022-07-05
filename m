Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38AE3566FCF
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 15:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbiGENtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 09:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiGENtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 09:49:03 -0400
X-Greylist: delayed 1237 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 Jul 2022 06:20:47 PDT
Received: from refb01.tmes.trendmicro.eu (refb01.tmes.trendmicro.eu [18.185.115.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535D4220C7;
        Tue,  5 Jul 2022 06:20:47 -0700 (PDT)
Received: from 104.47.0.55_.trendmicro.com (unknown [172.21.19.51])
        by refb01.tmes.trendmicro.eu (Postfix) with ESMTPS id 15168102F887E;
        Tue,  5 Jul 2022 13:00:11 +0000 (UTC)
Received: from 104.47.0.55_.trendmicro.com (unknown [172.21.167.194])
        by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 89F6310000C40;
        Tue,  5 Jul 2022 13:00:08 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1657026006.714000
X-TM-MAIL-UUID: bb9cbeab-c09d-458b-b057-a55f020b030e
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (unknown [104.47.0.55])
        by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id AE6441008F089;
        Tue,  5 Jul 2022 13:00:06 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HgwcrkLTwdrPSXCARIZu6Eo2igmnZlcbDqO8LolVf1WPHTWYzEUMjk7mLDU/KIB4cxlyVtIVz5w17flPFtvTPf+Hs0h26IKdTclCPuGtPf2ev8SCyRhL2shDlTJrX0R1J9fs7e7HGVtEO9Eqp4MoS5CUddiL8DrEip5unOUcjUMadueerilOXT919+voNUmvS1LicXmwoairzqv1BcK8sYtOr9cDMoGBRU3H1DIZFchrpx0sUhtMXk634h3Vn5ocETIdnXA+33bhgwhGIvZ9bXbz7z79jU3I4QP1IQeyGGJ2kp9xpSRIxAJ7w0cau1ykbwlmqmiooFzgmBBIzaHLfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N4In53M6i4y4lWT0YhqY5MdGnlfRbI42Ey0MaO6pZKU=;
 b=e2tTQ/ZLTxa4i9A3NZGfJV+fmjIUYElG3A8I5fuwDtMYPCSQabpyfwvk7kAxR7lOIMp2O2hCiWCEMf/27aEXONUJAB5YDCs54fzR9jTx8DAu3FUPdLqNO/r24OBGHq7Kot9Xygu2AF6+ZkT6tlYPmfCSKEnjS1Nv83HV4qhEwvx44TJ5lqGVPu7+gzZ0Eteu6HzMIA7P0lrKO8Ltei8fIPHM+basDIJWldT5aSVStbg1iwnqV2Yet1vq7exPkJQammfwTT3UfoLzIjslZRUHCS7XRUOMJjPZulH5Vo3075PuWy3AQSxqy4AurfJKnSDdPM6ZJfobMeHIe8awSO2GGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.66.60.4) smtp.rcpttodomain=davemloft.net smtp.mailfrom=opensynergy.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=opensynergy.com;
 dkim=none (message not signed); arc=none
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.66.60.4)
 smtp.mailfrom=opensynergy.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=opensynergy.com;
Received-SPF: Pass (protection.outlook.com: domain of opensynergy.com
 designates 217.66.60.4 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.66.60.4; helo=SR-MAIL-03.open-synergy.com; pr=C
From:   Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org,
        Max Krummenacher <max.oss.09@gmail.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        max.krummenacher@toradex.com
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
Subject: [PATCH] Bluetooth: core: Fix deadlock due to `cancel_work_sync(&hdev->power_on)` from hci_power_on_sync.
Date:   Tue,  5 Jul 2022 15:59:31 +0300
Message-Id: <20220705125931.3601-1-vasyl.vavrychuk@opensynergy.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220614181706.26513-1-max.oss.09@gmail.com>
References: <20220614181706.26513-1-max.oss.09@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 1d595ac2-6eb6-4ea3-3f30-08da5e864645
X-MS-TrafficTypeDiagnostic: PA4PR04MB7727:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vMsV4LJ8lEfuXd6lNB1gGPso7DN3kPnMOG1auOKbqIMokp3LePG8/zQV66KOfEFgZ6nEt0uJw0vlFjSS3YVGHZnE9CkwrWWDn8rPP1onsky8P1bVw04WfVBBEGFW7qH3mbtSJ2VI2bE5QB0jiAmXuheObpqdBK0K7+MvJND1veR5E0M7Ed8e9EutmZi+LBmC9Fu/jVNrCtIgJOpNTYwhwBTspWWIqRiVLhD/luO6DPMrFUI/+GfOObGbZLLGmmLd1PAqMmocnn1uV9960uhN+Nuqn8x8bHg6y89HF/tFJI3+PZPua8wE1hwhQGD0JMnESKJfzj20qvG2zqxAn/0zmYBs48RYkUMuOBt4ggg8UGKCUDLpZf+rvUomW9umBJmM9wIbLFHYYtjWsZoEoGC2+HtEkBr3PYpvp/5x71ydvV+7J0QJ6prZwpENu3cwCAfY2JrfEZ4t+Ue1xs5n4Qs9GVXeanroWPEJ17YqxEH5FaGpeJvZaEdeGLf2pxFAnFNVN0lfgUmt3U7y3HKRK09XYzV7/LKqyp4xeYdP09sJp3Hzx3W/nw4mt43XE6rJH2k5SrfqhynhUdIGRg5jt8j6S2ZGIdj8U/Gw/ZlVEy9ofi2i9l8KbElNZpg8sOZGIsTAk+I0RN9vjU6eFgH3yQCMaGUB/YGu/Xi81ajbXk1sN3DjB5MvM/FcQrfeidFzhGfOn4W3p8lBT7G8ABWVkfzMznMbME65PTjNinj9/V+UqRUYbqjIX6xc3CGLSKaOOz8pW7zgrSiBn0YbAjdhdbiIuUWbIYKgR4lvvFUjL5Z+cKZ1QLNgI+L1RgZpW0+XlQC5fbxOxvZpfQEZ6TM9AtyV1A==
X-Forefront-Antispam-Report: CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:mx1.opensynergy.com;CAT:NONE;SFS:(13230016)(376002)(39840400004)(136003)(346002)(396003)(36840700001)(46966006)(2906002)(1076003)(186003)(107886003)(26005)(336012)(83380400001)(2616005)(40480700001)(36860700001)(36756003)(41300700001)(82310400005)(54906003)(110136005)(44832011)(7416002)(478600001)(81166007)(5660300002)(8936002)(966005)(8676002)(70586007)(70206006)(4326008)(47076005)(316002)(42186006)(86362001)(81973001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 13:00:02.3293
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d595ac2-6eb6-4ea3-3f30-08da5e864645
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource: AM6EUR05FT055.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7727
X-TM-AS-ERS: 104.47.0.55-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.0.1004-26996.007
X-TMASE-Result: 10--10.482100-4.000000
X-TMASE-MatchedRID: hDt2nT7GHlPoSitJVour/f7FEhWgo0y8iK5qg1cmsr+dkHRvBVgJZmfL
        KEW7qlsHqUirzUPTZU8RXOKWV2pRUD3rUpOWwerc/kFj+75tvQwd7wYwkPJ/mh8DRANMiqtikrI
        9/WPu3jf68qduCW2JnM/NY1zQKKD4skLtspCGs70zOazjYfBb8Y0KoZnZ6F+XsMZG2pUzAfOyuh
        piqaRnanAm0uKJEVsP5erpc6fZVyrfytYpCSLCzr9A3Bl1/DcVUmlK22ARBaHCkJHfGKxhL7+Ih
        mgj6NxWiAaG2YvsCOK12HagvbwDji/7QU2czuUNA9lly13c/gFHyz3bB5kG50z5vzLEGq8DSebk
        8lenLCkkrfB4Sxx5OjKVinSQfz+2RGPq1SoWksB+yskgwrfsC30tCKdnhB58FMkUvzgg/cUqzDt
        2+ewmfO0d84ZRbF3AIAcCikR3vq/ZKrIEyWvT574TNGUN4s+AaKip7hpHodOcWpgypYPMbtdt5+
        WoqbOB
X-TMASE-XGENCLOUD: c53241e7-22e2-4b84-95f7-0e1209b093b6-0-0-200-0
X-TM-Deliver-Signature: 8AE3E450CD76EE7D70593E6C79C1DA51
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
        s=TM-DKIM-20210503141657; t=1657026008;
        bh=/mzkp2obN17YX5X2aYRTHkUYlkv9Lt075UpXK6TxCjo=; l=3043;
        h=From:To:Date;
        b=v8uQMikK0XKPHj2iHngFpC7c7Xrmb3DRgVP2ad8XJudMOk7z/shAMZSLeijq4dSby
         C3tZJzxHtVumf9nqr9d/u8VjW712PODZY0MIBWBxRqeNsNoTnVSGuOstAEu+iaQlKf
         qDWFlsq3e4RYrjczxtIStNk8gM/yc89H/W+Hnix/rTY0Z9W7lyhn51W9mJv5cGMBDl
         ak32o3lt5xD/zjbkPCFb+Sl+2qcsgEtG4xbHD2xHFyhpe/ivTc+ewnoZ9NlrxinJax
         sd7TfuvcUryaFus8K66+erkXKOCp/tozHDOrVL9kbJ/W8S48cteW3fldyLO87obN49
         EIuzg81MBRXuw==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

`cancel_work_sync(&hdev->power_on)` was moved to hci_dev_close_sync in
commit [1] to ensure that power_on work is canceled after HCI interface
down.

But, in certain cases power_on work function may call hci_dev_close_sync
itself: hci_power_on -> hci_dev_do_close -> hci_dev_close_sync ->
cancel_work_sync(&hdev->power_on), causing deadlock. In particular, this
happens when device is rfkilled on boot. To avoid deadlock, move
power_on work canceling out of hci_dev_do_close/hci_dev_close_sync.

Deadlock introduced by commit [1] was reported in [2,3] as broken
suspend. Suspend did not work because `hdev->req_lock` held as result of
`power_on` work deadlock. In fact, other BT features were not working.
It was not observed when testing [1] since it was verified without
rfkill in place.

NOTE: It is not needed to cancel power_on work from other places where
hci_dev_do_close/hci_dev_close_sync is called in case:
* Requests were serialized due to `hdev->req_workqueue`. The power_on
work is first in that workqueue.
* hci_rfkill_set_block which won't close device anyway until HCI_SETUP
is on.
* hci_sock_release which runs after hci_sock_bind which ensures
HCI_SETUP was cleared.

As result, behaviour is the same as in pre-dd06ed7 commit, except
power_on work cancel added to hci_dev_close.

[1]: commit dd06ed7ad057 ("Bluetooth: core: Fix missing power_on work cancel on HCI close")
[2]: https://lore.kernel.org/lkml/20220614181706.26513-1-max.oss.09@gmail.com/
[2]: https://lore.kernel.org/lkml/1236061d-95dd-c3ad-a38f-2dae7aae51ef@o2.pl/

Fixes: commit dd06ed7ad057 ("Bluetooth: core: Fix missing power_on work cancel on HCI close")
Signed-off-by: Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
Reported-by: Max Krummenacher <max.krummenacher@toradex.com>
Reported-by: Mateusz Jonczyk <mat.jonczyk@o2.pl>
---
 net/bluetooth/hci_core.c | 3 +++
 net/bluetooth/hci_sync.c | 1 -
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 59a5c1341c26..a0f99baafd35 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -571,6 +571,7 @@ int hci_dev_close(__u16 dev)
 		goto done;
 	}
 
+	cancel_work_sync(&hdev->power_on);
 	if (hci_dev_test_and_clear_flag(hdev, HCI_AUTO_OFF))
 		cancel_delayed_work(&hdev->power_off);
 
@@ -2675,6 +2676,8 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	list_del(&hdev->list);
 	write_unlock(&hci_dev_list_lock);
 
+	cancel_work_sync(&hdev->power_on);
+
 	hci_cmd_sync_clear(hdev);
 
 	if (!test_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks))
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 286d6767f017..1739e8cb3291 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4088,7 +4088,6 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 
 	bt_dev_dbg(hdev, "");
 
-	cancel_work_sync(&hdev->power_on);
 	cancel_delayed_work(&hdev->power_off);
 	cancel_delayed_work(&hdev->ncmd_timer);
 
-- 
2.30.2

