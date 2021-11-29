Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFEDF462766
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 00:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235852AbhK2XEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 18:04:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236167AbhK2XCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 18:02:12 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F9DC0F74FA
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 13:14:16 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id i5so39720521wrb.2
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 13:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:from:to:cc
         :subject:content-transfer-encoding;
        bh=srpjM+m9JSVbLhmkoMDgkNUzsBwUW0ZKuLG4RFIBe9U=;
        b=VE4YeEhY07b0ts76fiWRR4NNPUyDIbFXDC20ibjjGzAErJw+czwq31XOaT8vrJnz6j
         vBeNOILKJ8jzb9rcgy0jbKUc+pMpajA+GtMOGfG20OJidzrFzcgUUw9BlSHyEZTHSX3l
         pi0e4hWpfn0GHRS9N2NMAtWI2mS1FbxJCNrBaR+5fcV1iTmGIkpgQlWGTfaANm98x1fC
         BTXo3If3OxbT18VJkLNAj1ZHnKT7IwchZeq1aYTmjvQVoFDn0rMY+Jo5UJG9zO93hTET
         dKWi2/9U8B5KwlSWgjolK7Wb6c5wOdYXMtIld1tCbfsvVWgT4/D9alo7BfVcGSlHPXCw
         J7eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:from:to:cc:subject:content-transfer-encoding;
        bh=srpjM+m9JSVbLhmkoMDgkNUzsBwUW0ZKuLG4RFIBe9U=;
        b=j5wtlgpTb1p9tqWXmVxPPpmSnwIsBVd1nJKDweOvB2flUD+rPJ+5snXdAGi0ffZHvA
         S3IpTjbIwgwVr5bfP3j/GJKEIllH20hHaVOOASS4OSXyed26zXlaj3ddBJhp1ZnXYgZB
         Utxhkz3yb9B5Xn1nv3CmdbnAJ4kQnAjWWd6E/rGlUSVEwNgq4pNppSec69KuoMtVI0tT
         zcxbfgukzEkj4WmxQulepHNEF1BSA37AWTlHlLkHfdZ/r0k7bxl8ZXPWB/ErKMDBBYVA
         tujPZRxv/ErgrWgIor/h4b+MplSixBAhQVvTS1fGdBKGo9U6sdOhCSb98la6uPez8VKe
         jEwQ==
X-Gm-Message-State: AOAM532G0XlOkNwuUeHlJzJFKNetFqN8k3PL55h+gmhm/UlRlCbxmaKe
        LtBZKId8xfRoLPpt7o2PHlg=
X-Google-Smtp-Source: ABdhPJy38C4v2oUW6VpP+dLOpd170KnfpHdmsZwqBVhAuS7jgxo+TOWeGoBLpeakOFYhC4jOSFSBjQ==
X-Received: by 2002:a05:6000:168f:: with SMTP id y15mr36091337wrd.61.1638220454987;
        Mon, 29 Nov 2021 13:14:14 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:8596:696b:f4cd:9c8e? (p200300ea8f1a0f008596696bf4cd9c8e.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:8596:696b:f4cd:9c8e])
        by smtp.googlemail.com with ESMTPSA id k37sm410371wms.21.2021.11.29.13.14.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 13:14:14 -0800 (PST)
Message-ID: <6bb28d2f-4884-7696-0582-c26c35534bae@gmail.com>
Date:   Mon, 29 Nov 2021 22:14:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Subject: [PATCH net] igb: fix deadlock caused by taking RTNL in RPM resume
 path
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent net core changes caused an issue with few Intel drivers
(reportedly igb), where taking RTNL in RPM resume path results in a
deadlock. See [0] for a bug report. I don't think the core changes
are wrong, but taking RTNL in RPM resume path isn't needed.
The Intel drivers are the only ones doing this. See [1] for a
discussion on the issue. Following patch changes the RPM resume path
to not take RTNL.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=215129
[1] https://lore.kernel.org/netdev/20211125074949.5f897431@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/t/

Fixes: bd869245a3dc ("net: core: try to runtime-resume detached device in __dev_open")
Fixes: f32a21376573 ("ethtool: runtime-resume netdev parent before ethtool ioctl ops")
Tested-by: Martin Stolpe <martin.stolpe@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index dd208930f..8073cce73 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -9254,7 +9254,7 @@ static int __maybe_unused igb_suspend(struct device *dev)
 	return __igb_shutdown(to_pci_dev(dev), NULL, 0);
 }
 
-static int __maybe_unused igb_resume(struct device *dev)
+static int __maybe_unused __igb_resume(struct device *dev, bool rpm)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct net_device *netdev = pci_get_drvdata(pdev);
@@ -9297,17 +9297,24 @@ static int __maybe_unused igb_resume(struct device *dev)
 
 	wr32(E1000_WUS, ~0);
 
-	rtnl_lock();
+	if (!rpm)
+		rtnl_lock();
 	if (!err && netif_running(netdev))
 		err = __igb_open(netdev, true);
 
 	if (!err)
 		netif_device_attach(netdev);
-	rtnl_unlock();
+	if (!rpm)
+		rtnl_unlock();
 
 	return err;
 }
 
+static int __maybe_unused igb_resume(struct device *dev)
+{
+	return __igb_resume(dev, false);
+}
+
 static int __maybe_unused igb_runtime_idle(struct device *dev)
 {
 	struct net_device *netdev = dev_get_drvdata(dev);
@@ -9326,7 +9333,7 @@ static int __maybe_unused igb_runtime_suspend(struct device *dev)
 
 static int __maybe_unused igb_runtime_resume(struct device *dev)
 {
-	return igb_resume(dev);
+	return __igb_resume(dev, true);
 }
 
 static void igb_shutdown(struct pci_dev *pdev)
@@ -9442,7 +9449,7 @@ static pci_ers_result_t igb_io_error_detected(struct pci_dev *pdev,
  *  @pdev: Pointer to PCI device
  *
  *  Restart the card from scratch, as if from a cold-boot. Implementation
- *  resembles the first-half of the igb_resume routine.
+ *  resembles the first-half of the __igb_resume routine.
  **/
 static pci_ers_result_t igb_io_slot_reset(struct pci_dev *pdev)
 {
@@ -9482,7 +9489,7 @@ static pci_ers_result_t igb_io_slot_reset(struct pci_dev *pdev)
  *
  *  This callback is called when the error recovery driver tells us that
  *  its OK to resume normal operation. Implementation resembles the
- *  second-half of the igb_resume routine.
+ *  second-half of the __igb_resume routine.
  */
 static void igb_io_resume(struct pci_dev *pdev)
 {
-- 
2.34.1

