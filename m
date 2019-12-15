Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCD7511F550
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 02:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfLOBv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 20:51:28 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:36782 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbfLOBv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 20:51:27 -0500
Received: by mail-il1-f196.google.com with SMTP id b15so2672306iln.3;
        Sat, 14 Dec 2019 17:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7ila3ACaEBkte0RQGIwBOqqVKb25YlQx6hZbg+XIx7w=;
        b=M2YznvDUbC+oI2ORLdlKHZU221buG1yFNbL3d3PnZEFpw0MpYpDAoHadWunc3MIeMh
         nT0ORJwX+0+c/DVfrF3oeUPXw4FvSMd6Z2YuZqHELAJeU0zVbVxMsc6YlopAePA1bmdf
         ae89PYWru7qVtptShh1y4/02s/JSRIGPPPnYP9cee/+TL7p3g0HBReLP5jPbbxpU1WgT
         N0T661QXxDElWDGXan5TmfKuts2sSB2IfFLimVM1Bf0VNz671cctClTeDoiR2bLzI8X7
         TjCt5heNFIMkH+BuwsuQbHW6K3Z7FTr5J5C9qp7reNus4ax1HXWHxR8PBpoPKwExmFU3
         cH8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7ila3ACaEBkte0RQGIwBOqqVKb25YlQx6hZbg+XIx7w=;
        b=nVFD/yKadg5cBMP1C8/Ilxmf6YTM5YfTK0dW/N9QY558Sf5hIWqT80uKGAF2TxXOSK
         g3WbTlwgwY88Cv89GoFeCUcoP3HfSobjtoZARR/AS4UQ+9PFL9y5LenumANIeckWdz0J
         2aalVwsKWSgY4e6UpPfOYdslPdiMZY2KL/K7frjhVmliNNfRYwXTsTYjenp/ZisVbG7F
         Gbd+xnYXEuvAksOgANLA5RZ2bXD1SBlkgpBfXU8ktBfuiLfd6Pz4tTi/JJ2mGndzBIvb
         YGZPcr2mN/wi5v58L4Ad4ID+IfwBT+YXRoGTebRSksAap4csjLRqqiQugfK6k19NQrY2
         Mu4Q==
X-Gm-Message-State: APjAAAXjNOnYwzWj+M5/5jsoIx10B0nF8v7HXk2hmm24+A68FN14ae90
        8NckfLTMH+e/nbOkpl0z7LI=
X-Google-Smtp-Source: APXvYqz0KmdNAXYfzGhk2gPnfOnNtd6IkkcGO0SiadEIk+YNhK3wzwvkU5gjfF4ogx0edteSrt9iew==
X-Received: by 2002:a92:b506:: with SMTP id f6mr6850648ile.103.1576374686670;
        Sat, 14 Dec 2019 17:51:26 -0800 (PST)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id f16sm4368858ilq.16.2019.12.14.17.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 17:51:26 -0800 (PST)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     Arend van Spriel <arend@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alwin Beukers <alwin@broadcom.com>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Kan Yan <kanyan@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Piotr Figiel <p.figiel@camlintechnologies.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        YueHaibing <yuehaibing@huawei.com>, Kangjie Lu <kjlu@umn.edu>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     emamd001@umn.edu, Navid Emamdoost <navid.emamdoost@gmail.com>
Subject: [PATCH] brcmfmac: Fix memory leak in brcmf_usbdev_qinit
Date:   Sat, 14 Dec 2019 19:51:14 -0600
Message-Id: <20191215015117.21801-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the implementation of brcmf_usbdev_qinit() the allocated memory for
reqs is leaking if usb_alloc_urb() fails. Release reqs in the error
handling path.

Fixes: 71bb244ba2fd ("brcm80211: fmac: add USB support for bcm43235/6/8 chipsets")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 06f3c01f10b3..237c6b491b88 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -430,6 +430,7 @@ brcmf_usbdev_qinit(struct list_head *q, int qsize)
 			usb_free_urb(req->urb);
 		list_del(q->next);
 	}
+	kfree(reqs);
 	return NULL;
 
 }
-- 
2.17.1

