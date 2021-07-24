Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E933D4930
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 20:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhGXRye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 13:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhGXRyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 13:54:32 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A5FC061575;
        Sat, 24 Jul 2021 11:35:02 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id hb6so8722796ejc.8;
        Sat, 24 Jul 2021 11:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=OYA3ci3b6kMBnU+mtfcyeRkI+VLghBV/ejTMP2wgjbk=;
        b=lcGU5AZkxJgvvkmM0gsKcktB8hiUjMto2PdDe19tqvCNmYH93UeMtcZr5VltvvEj7l
         zMCYrcHLkEESBOmVTjVf4HOoFQMDWBAXJtUvoSrySLmrdrNcM8bKJXwtRaRrRemwdUSi
         ImnXqK+YMRCyK3F7R8IMm7IgT8YZzOO6PsSA88TGcpg49lnGUTSESEtMBx8KFj+GnUb+
         xUxmWDZNkTz0/jZlin29JCu3tzOJ7gwyYoI6eUDHmqRBeSmYdU06X9YMIoX4juug9e/2
         Yt2B9HO1Toa7FEpQk2n/MHkbu7ljdDhhn8sgQ8HnYZTtzWmfM72SrwjycVBbq7vynkEn
         iHVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=OYA3ci3b6kMBnU+mtfcyeRkI+VLghBV/ejTMP2wgjbk=;
        b=pPfHzcPsdbSIryevSGDx5KrVtW8ZjkpM9fQAB0crf5X8HwBUeX5/aEJ8wbAhwCkaff
         3FunuKN/WXbpqdVFcu3hYQgnXfFbwBGXoFenjgaE6XwDxLwOlo3w0L2CrpaTkAlg6WfD
         Ngf+B+Bg5nlgGTErGc3ZfPf81BlDwvX54Tv/cQXnZoqMAjOPj0R6Vi8Z3M+/ay0zB6Qc
         YJD+VQR5oN3WnRbRl8oDv7w/bCgsOZuWBZlvrP8w1Urk0Z7aCj+sukkESOzRduOToGWT
         Lz7hAOcHegvC70YAORNDCO22+hSNc3c/ZYlReUheZvcKoNX3za+6OvQQpkLx01ybJ/zs
         qrmQ==
X-Gm-Message-State: AOAM5318OQaDxHSmWzOm4yF7EO0xCOoxeT0hh254b0/AfyUH9DD8GcbJ
        v+UUpNrDZdLOgJg/YUiJa6w=
X-Google-Smtp-Source: ABdhPJxJNtYQUouT8g3hMDfErIithvJFi3+MI5uRbKPPMW/dyyA18GQfSC8G4AUom+PQ3CACvDB8ag==
X-Received: by 2002:a17:906:28c4:: with SMTP id p4mr10317176ejd.302.1627151701388;
        Sat, 24 Jul 2021 11:35:01 -0700 (PDT)
Received: from pc ([196.235.233.206])
        by smtp.gmail.com with ESMTPSA id i14sm12609218eja.91.2021.07.24.11.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jul 2021 11:35:00 -0700 (PDT)
Date:   Sat, 24 Jul 2021 19:34:57 +0100
From:   Salah Triki <salah.triki@gmail.com>
To:     Herton Ronaldo Krzesinski <herton@canonical.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, gregkh@linuxfoundation.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wireless: rtl8187: replace udev with usb_get_dev()
Message-ID: <20210724183457.GA470005@pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace udev with usb_get_dev() in order to make code cleaner.

Signed-off-by: Salah Triki <salah.triki@gmail.com>
---
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
index eb68b2d3caa1..30bb3c2b8407 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
@@ -1455,9 +1455,7 @@ static int rtl8187_probe(struct usb_interface *intf,
 
 	SET_IEEE80211_DEV(dev, &intf->dev);
 	usb_set_intfdata(intf, dev);
-	priv->udev = udev;
-
-	usb_get_dev(udev);
+	priv->udev = usb_get_dev(udev);
 
 	skb_queue_head_init(&priv->rx_queue);
 
-- 
2.25.1

