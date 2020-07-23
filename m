Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0006022B12E
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 16:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbgGWOWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 10:22:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60372 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726815AbgGWOWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 10:22:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595514138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=zSZAhL25JSXHpF0bAbKJRfBjeCgJ6YYI4dxlYgSnMIw=;
        b=Sm7Gmn9OBkhJNLgwyyBA6BPMcBawrHLy//SsDN2inGpmFdoeUy9M5uFdchje/8QiNEbzJd
        7wWZyZvlPXS7VVTC4MWUWamQt2wsDRAcjTIehLQ2EHI6KBftxccx5OaKsM2pCU/HsJiNqt
        u2dZFD+96HyQYHEmcXhdA48R9FHMuik=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-HGLulh8CNt2UnaWQgBv0AQ-1; Thu, 23 Jul 2020 10:22:17 -0400
X-MC-Unique: HGLulh8CNt2UnaWQgBv0AQ-1
Received: by mail-qk1-f200.google.com with SMTP id p126so3947232qkf.15
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 07:22:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zSZAhL25JSXHpF0bAbKJRfBjeCgJ6YYI4dxlYgSnMIw=;
        b=IAflI16azTkTZ9iI39OO+/OgpangYTRWTGa0QxKXRM7PUcHiaxpLHV1eQXgNiwlUM1
         gkWKWbnL3G3kFmAz6ISx7dvBJh4m1wAthBn+wQOVRhrhO5PgxhpdjnJbvYr9fgL6CTol
         43nWyDDPVKrMQjup1aCJJTE0G/NMc8AtO45AgN38SJVSEbE4Z5diQNVR3Nqfw936F+q1
         RdFJ+Kxj4gmwt4PMK1JlFRX2Qt9yxTRdKGtwsW8QbqQe82lDjYRPcgar+g9f0cHE/wb3
         bgrv03rRumAZ9j64X01UsttTSVEo1XzpnGOx02dU50v74XK5uKYq/1jC6gunbGmGmWdQ
         BP0A==
X-Gm-Message-State: AOAM5310gNO0izaU2qGhYJAA4RQPl4iyMyRpbbIrLWVZPWs2MI14AA2m
        kbHdytG2qDX9Jy3hbEl2C3+5/EkEmAcVCUp34ov5ousv5riLVG/HSGWwHg8+M4CB8OrZDrTa3Dq
        uN0clV++e13DwW7vf
X-Received: by 2002:ad4:4bb0:: with SMTP id i16mr5099823qvw.42.1595514136248;
        Thu, 23 Jul 2020 07:22:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw+P4z/SKan23uckp0U4ZwHA1Evj9o8JlarlIuBAqm40uOmGWRZUthDHWilRj8lh/rxbybNZQ==
X-Received: by 2002:ad4:4bb0:: with SMTP id i16mr5099803qvw.42.1595514136058;
        Thu, 23 Jul 2020 07:22:16 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id f53sm2225651qta.84.2020.07.23.07.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 07:22:15 -0700 (PDT)
From:   trix@redhat.com
To:     davem@davemloft.net, kuba@kernel.org, masahiroy@kernel.org
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] net: cdc_ncm: USB_NET_CDC_NCM selects USB_NET_CDCETHER
Date:   Thu, 23 Jul 2020 07:22:10 -0700
Message-Id: <20200723142210.21274-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

A link error

ld: drivers/net/usb/cdc_ncm.o:
  undefined reference to `usbnet_cdc_update_filter'

usbnet_cdc_update_filter is defined in cdc_ether.c
Building of cdc_ether.o is controlled by USB_NET_CDCETHER

Building of cdc_ncm.o is controlled by USB_NET_CDC_NCM

So add a select USB_NET_CDCETHER to USB_NET_CDC_NCM

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/usb/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index a7fbc3ccd29e..c7bcfca7d70b 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -252,6 +252,7 @@ config USB_NET_CDC_EEM
 config USB_NET_CDC_NCM
 	tristate "CDC NCM support"
 	depends on USB_USBNET
+	select USB_NET_CDCETHER
 	default y
 	help
 	  This driver provides support for CDC NCM (Network Control Model
-- 
2.18.1

