Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1E5612532
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 22:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiJ2UZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 16:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiJ2UZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 16:25:29 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8918E55C79;
        Sat, 29 Oct 2022 13:25:24 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id o4so10797255wrq.6;
        Sat, 29 Oct 2022 13:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AjRHZ8fBkg3lgjizFn9B9hytM4UkuoK83SgqmM3ChZE=;
        b=LGNwBNf8jYxk8Z6LrnZoxsnGAaI9QpTYNSEQdu9SpePwkwCi/RCEaIJjHT5WAmHTTV
         eg+FHFOcaPOrU3QmPa7jy9i6KTNFiwLPe7F1MN20D4fMOcDkXXyUCj8n/a23gAN+Dwrf
         ztYqtS1GL96hHrUE8DK/vyrbfkFRXBAIm0V4h2i7YAt/owq4exZd5ercimwyZJJI6R5G
         JojWm7YiLxbdbtlMPXpUjM26ZK5eMkcgskeH/U0Sv1AMQMTkvUZSnr4nHb+8YOjBstEe
         hGhN4QaibO7LoL7POEaNQz1dBQc755yJtESpGs92kC0/KGK2WtzUI7q34f8Er94hUaox
         MhNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AjRHZ8fBkg3lgjizFn9B9hytM4UkuoK83SgqmM3ChZE=;
        b=bAe9MvXI/1P+GKyBCQpTa9jg8c5lnOQ0Xknk/IY905S/U6eSS3fhpuSUsXtZgCXhx9
         SEcOQ94deeCBm0KO6oH+0vaQ1T/k9Tii1KaSBqL9c+HmY8Pu3fIc//j09Bk+oWinTWUX
         BdEbvKoySQXd2XW0WMsTTY57DdgbrHdvJjWcWo8+8B+c6atfcPgnnxUFv3PB72HCIMi+
         Dyj5kKrGKaB65PwIBS9WrDAX/Or9xNvx+s97sKf6ZyV8AK1eW/0gNh28G6rdselAwhjd
         zAhzb8lMgbXUzSSeBin/N4op7R1nHCngw8nMkIrE5wQ/GF3yF3I8EbDlBVmzs2laNVF4
         7jbg==
X-Gm-Message-State: ACrzQf0Klmp4uKKPIjR3pEZlwCSmWm77WFN7bNH1sVEpELrF0dZ/J8pS
        A+b5Gpa+03T9BoCq6PInRbMeDvZrp7O2HpRI
X-Google-Smtp-Source: AMsMyM63HApAl5EyY21mbT9cgtvC76ltsknlLTRxfDi8U5bfACFANI/uFGLQYE36ILLcSg4KJ3GLYA==
X-Received: by 2002:adf:e610:0:b0:236:737f:8e5d with SMTP id p16-20020adfe610000000b00236737f8e5dmr3230801wrm.316.1667075122985;
        Sat, 29 Oct 2022 13:25:22 -0700 (PDT)
Received: from osgiliath.lan (201.ip-51-68-45.eu. [51.68.45.201])
        by smtp.gmail.com with ESMTPSA id k3-20020a05600c1c8300b003c6b7f5567csm16654829wms.0.2022.10.29.13.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 13:25:21 -0700 (PDT)
From:   Ismael Ferreras Morezuelas <swyterzone@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        luiz.von.dentz@intel.com, quic_zijuhu@quicinc.com,
        hdegoede@redhat.com, swyterzone@gmail.com
Cc:     linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/3] Bluetooth: btusb: Fix Chinese CSR dongles again by re-adding ERR_DATA_REPORTING quirk
Date:   Sat, 29 Oct 2022 22:24:52 +0200
Message-Id: <20221029202454.25651-1-swyterzone@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A patch series by a Qualcomm engineer essentially removed my
quirk/workaround because they thought it was unnecessary.

It wasn't, and it broke everything again:

https://patchwork.kernel.org/project/netdevbpf/list/?series=661703&archive=both&state=*

He argues that the quirk is not necessary because the code should check if the dongle
says if it's supported or not. The problem is that for these Chinese CSR
clones they say that it would work, but it's a lie. Take a look:

= New Index: 00:00:00:00:00:00 (Primary,USB,hci0)                              [hci0] 11.272194
= Open Index: 00:00:00:00:00:00                                                [hci0] 11.272384
< HCI Command: Read Local Version Information (0x04|0x0001) plen 0          #1 [hci0] 11.272400
> HCI Event: Command Complete (0x0e) plen 12                                #2
> [hci0] 11.276039
      Read Local Version Information (0x04|0x0001) ncmd 1
        Status: Success (0x00)
        HCI version: Bluetooth 5.0 (0x09) - Revision 2064 (0x0810)
        LMP version: Bluetooth 5.0 (0x09) - Subversion 8978 (0x2312)
        Manufacturer: Cambridge Silicon Radio (10)
...
< HCI Command: Read Local Supported Features (0x04|0x0003) plen 0           #5 [hci0] 11.648370
> HCI Event: Command Complete (0x0e) plen 68                               #12
> [hci0] 11.668030
      Read Local Supported Commands (0x04|0x0002) ncmd 1
        Status: Success (0x00)
        Commands: 163 entries
          ...
          Read Default Erroneous Data Reporting (Octet 18 - Bit 2)
          Write Default Erroneous Data Reporting (Octet 18 - Bit 3)
          ...
...
< HCI Command: Read Default Erroneous Data Reporting (0x03|0x005a) plen 0  #47 [hci0] 11.748352
= Close Index: 00:1A:7D:DA:71:XX                                               [hci0] 13.776824

So bring it back wholesale.

Fixes: 63b1a7dd3 (Bluetooth: hci_sync: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING)
Fixes: e168f69008 (Bluetooth: btusb: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for fake CSR)
Fixes: 766ae2422b (Bluetooth: hci_sync: Check LMP feature bit instead of quirk)

Cc: stable@vger.kernel.org
Cc: Zijun Hu <quic_zijuhu@quicinc.com>
Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Tested-by: Ismael Ferreras Morezuelas <swyterzone@gmail.com>
Signed-off-by: Ismael Ferreras Morezuelas <swyterzone@gmail.com>
---
 drivers/bluetooth/btusb.c   |  1 +
 include/net/bluetooth/hci.h | 11 +++++++++++
 net/bluetooth/hci_sync.c    |  9 +++++++--
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 3b269060e91f..1360b2163ec5 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2174,6 +2174,7 @@ static int btusb_setup_csr(struct hci_dev *hdev)
 		 * without these the controller will lock up.
 		 */
 		set_bit(HCI_QUIRK_BROKEN_STORED_LINK_KEY, &hdev->quirks);
+		set_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks);
 		set_bit(HCI_QUIRK_BROKEN_FILTER_CLEAR_ALL, &hdev->quirks);
 		set_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks);
 
diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index e004ba04a9ae..0fe789f6a653 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -228,6 +228,17 @@ enum {
 	 */
 	HCI_QUIRK_VALID_LE_STATES,
 
+	/* When this quirk is set, then erroneous data reporting
+	 * is ignored. This is mainly due to the fact that the HCI
+	 * Read Default Erroneous Data Reporting command is advertised,
+	 * but not supported; these controllers often reply with unknown
+	 * command and tend to lock up randomly. Needing a hard reset.
+	 *
+	 * This quirk can be set before hci_register_dev is called or
+	 * during the hdev->setup vendor callback.
+	 */
+	HCI_QUIRK_BROKEN_ERR_DATA_REPORTING,
+
 	/*
 	 * When this quirk is set, then the hci_suspend_notifier is not
 	 * registered. This is intended for devices which drop completely
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index bd9eb713b26b..0a7abc817f10 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3798,7 +3798,8 @@ static int hci_read_page_scan_activity_sync(struct hci_dev *hdev)
 static int hci_read_def_err_data_reporting_sync(struct hci_dev *hdev)
 {
 	if (!(hdev->commands[18] & 0x04) ||
-	    !(hdev->features[0][6] & LMP_ERR_DATA_REPORTING))
+	    !(hdev->features[0][6] & LMP_ERR_DATA_REPORTING) ||
+	    test_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks))
 		return 0;
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_READ_DEF_ERR_DATA_REPORTING,
@@ -4316,7 +4317,8 @@ static int hci_set_err_data_report_sync(struct hci_dev *hdev)
 	bool enabled = hci_dev_test_flag(hdev, HCI_WIDEBAND_SPEECH_ENABLED);
 
 	if (!(hdev->commands[18] & 0x08) ||
-	    !(hdev->features[0][6] & LMP_ERR_DATA_REPORTING))
+	    !(hdev->features[0][6] & LMP_ERR_DATA_REPORTING) ||
+	    test_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks))
 		return 0;
 
 	if (enabled == hdev->err_data_reporting)
@@ -4475,6 +4477,9 @@ static const struct {
 	HCI_QUIRK_BROKEN(STORED_LINK_KEY,
 			 "HCI Delete Stored Link Key command is advertised, "
 			 "but not supported."),
+	HCI_QUIRK_BROKEN(ERR_DATA_REPORTING,
+			 "HCI Read Default Erroneous Data Reporting command is "
+			 "advertised, but not supported."),
 	HCI_QUIRK_BROKEN(READ_TRANSMIT_POWER,
 			 "HCI Read Transmit Power Level command is advertised, "
 			 "but not supported."),
-- 
2.38.1

