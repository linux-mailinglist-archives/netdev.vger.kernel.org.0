Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0946185146
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 22:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbgCMVkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 17:40:00 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39861 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727455AbgCMVj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 17:39:59 -0400
Received: by mail-lj1-f194.google.com with SMTP id f10so12182402ljn.6
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 14:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hackerdom.ru; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HtY5oImSA0+4YSNm6q/VHicARFJFbzmTkofRiaqhhKc=;
        b=i6Sda7uWBOD2K3vqcHwo7xd1p8sMeqiNPXsPFKYrcdGRCEdfq4sGW+sfz+6DtEY5ng
         CPG8Ksg9tqUzaZSW2/MpGEQHtBxkkjwEDR8hSP7vfSeXmmIWCgup8KWccyLJyd3ZoYeg
         hfc6zDthQwpj8jCV1Q2VN2YHdvr/jVU+TFWxs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HtY5oImSA0+4YSNm6q/VHicARFJFbzmTkofRiaqhhKc=;
        b=RFo9p2yJNftnYnMOsV9esmcU/t9/bDHWA/mP4gNaB7kCjs0BGFAMsgMWZSrFeckcgy
         CK/qFZ0R3gmuCKDUw2khQVeOJSCt5d9HPTsbBYLu8ywpC5KWTq97itZYla6vI1428U3W
         QMi7oXn/QWmZakxVWw+0/hG5LWzgEmClnRj3+Q/JrX8ITF5zoOjAmqiLRDSzmpER5boE
         t0KDfrXJ9hM9kBwb7KQtH9gfqTg4ayS1qv9agdr73wicwVBsvzUYaL1GkbJEq7fwIOiB
         A7PpB1+nHRmUSN2W9haSUavrj8GKaw3qPvVV9V9KST7wa/1+E98EbndVqw9/jX8N+Zlt
         GTxg==
X-Gm-Message-State: ANhLgQ3BNqY8Zn4K5AWs3qRHdQU5Txqe7hi1r5vjaaagxGqNYz75N0To
        6+xeNkF87MzHMrdjC/67Ws4Ecg==
X-Google-Smtp-Source: ADFU+vs0A/qJqrv937YyDOkFvvA1JoZQ9oheGaTY/TOQzzjwt31KNy+BHUUk/NPpRaEoBJe/cjI0Kg==
X-Received: by 2002:a2e:9b44:: with SMTP id o4mr5047746ljj.63.1584135598069;
        Fri, 13 Mar 2020 14:39:58 -0700 (PDT)
Received: from localhost.localdomain ([83.169.216.4])
        by smtp.googlemail.com with ESMTPSA id 3sm11178101ljq.18.2020.03.13.14.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 14:39:57 -0700 (PDT)
From:   Alexander Bersenev <bay@hackerdom.ru>
To:     bay@hackerdom.ru
Cc:     Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] cdc_ncm: Fix the build warning
Date:   Sat, 14 Mar 2020 02:38:21 +0500
Message-Id: <20200313213823.178435-2-bay@hackerdom.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200313213823.178435-1-bay@hackerdom.ru>
References: <20200313213823.178435-1-bay@hackerdom.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ndp32->wLength is two bytes long, so replace cpu_to_le32 with cpu_to_le16.
---
 drivers/net/usb/cdc_ncm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 5569077bd5b8..8929669b5e6d 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1172,7 +1172,7 @@ static struct usb_cdc_ncm_ndp32 *cdc_ncm_ndp32(struct cdc_ncm_ctx *ctx, struct s
 		ndp32 = ctx->delayed_ndp32;
 
 	ndp32->dwSignature = sign;
-	ndp32->wLength = cpu_to_le32(sizeof(struct usb_cdc_ncm_ndp32) + sizeof(struct usb_cdc_ncm_dpe32));
+	ndp32->wLength = cpu_to_le16(sizeof(struct usb_cdc_ncm_ndp32) + sizeof(struct usb_cdc_ncm_dpe32));
 	return ndp32;
 }
 
-- 
2.25.1

