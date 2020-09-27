Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741A927A21E
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 19:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgI0Roj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 13:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgI0Roj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 13:44:39 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF37C0613CE
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 10:44:38 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id i26so5145008ejb.12
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 10:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=FSQgkiyM3Izc5D+Pe8hInjJPMV4ZWjpx2nsXWCjBQR4=;
        b=dt01rDajtk+QgmTYgGCpmV/4k9VbpXPhoQHT6garUzbWY3HuElW8MdIEDsqmCXJdQZ
         Z0bg25RqrY6GU585jbn4JbPbUgH5aucKn1ow0tuUBOdq9pNn/Yx7BN0IYs77ZWDtK7XZ
         s7tEgH/P7fa/nt5j1YXol4HCSFJgzLxYhEq8K8X3HbDFx3ViJzyFZa/XpvJ0dznYRlZ0
         RPeq2FTeHjzeYQ3gN5Z2ItcneZvPt9P9uaU8+UlFnaTYJ7hkqKzgur9w1ibqhAcZjRTm
         wag/qj7OL43jy0Y0rg2nEq3QVOE26KsT45vRE9WQ0PMgNzzrlCQjOLlWY7va3/At4cHK
         hc7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=FSQgkiyM3Izc5D+Pe8hInjJPMV4ZWjpx2nsXWCjBQR4=;
        b=R79KhG5LxVXPztK1cZV4kZNdwDpuvnY48Tfj1O9Pyg12gbOUB+QVM68sqjfFEnAxwE
         9A+Jo8J5NnsXTGrk2K7GN/GFDvz5k86f7eTQVqNddBMFD3ac8bPLPlMM8gdrjSDB6VgP
         Hmu2XS8jcfYNVdt0jg85OQ/vMPSYLW0Z4S9oaVlrSyx1JU0o2AdHZC35v0iPynnsi2hH
         Ywz5Q9G7mAG71j4zq2Pps5pqQn0i3ZVFk9/ARFz6Grdp6TCMtTjxrJQzibLCEwckW+Im
         2in3PYhgsWCriYv+euQO5zcUIrjd3nuHNJj/X7OX5Wc3oUcpTV1AuSKkJPPTBVN9d7sl
         g3rg==
X-Gm-Message-State: AOAM533gXkn30LXilskvje/sHg5maahArHFf3a1TcCq8FaYLXbbEjFzn
        6EXlrdR5Mqmwm68S6D/m4BIw2Aj7LWE=
X-Google-Smtp-Source: ABdhPJxyyZxgKYd7CpTe3yCSL6clJsGsQJZDFKhdLaQTmLt50+PKcrwMV7lAFvIjy3xd2O+dNvWNZA==
X-Received: by 2002:a17:906:e88:: with SMTP id p8mr12855109ejf.134.1601228677216;
        Sun, 27 Sep 2020 10:44:37 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:e966:e5f6:832b:42f1? (p200300ea8f006a00e966e5f6832b42f1.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:e966:e5f6:832b:42f1])
        by smtp.googlemail.com with ESMTPSA id k9sm7776155edr.3.2020.09.27.10.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2020 10:44:36 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: fix RTL8168f/RTL8411 EPHY config
Message-ID: <9a059f0d-4865-3f21-be39-49a2b711d0bf@gmail.com>
Date:   Sun, 27 Sep 2020 19:44:29 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mistakenly bit 2 was set instead of bit 3 as in the vendor driver.

Fixes: a7a92cf81589 ("r8169: sync PCIe PHY init with vendor driver 8.047.01")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9e4e6a883..6c7c004c2 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2901,7 +2901,7 @@ static void rtl_hw_start_8168f_1(struct rtl8169_private *tp)
 		{ 0x08, 0x0001,	0x0002 },
 		{ 0x09, 0x0000,	0x0080 },
 		{ 0x19, 0x0000,	0x0224 },
-		{ 0x00, 0x0000,	0x0004 },
+		{ 0x00, 0x0000,	0x0008 },
 		{ 0x0c, 0x3df0,	0x0200 },
 	};
 
@@ -2918,7 +2918,7 @@ static void rtl_hw_start_8411(struct rtl8169_private *tp)
 		{ 0x06, 0x00c0,	0x0020 },
 		{ 0x0f, 0xffff,	0x5200 },
 		{ 0x19, 0x0000,	0x0224 },
-		{ 0x00, 0x0000,	0x0004 },
+		{ 0x00, 0x0000,	0x0008 },
 		{ 0x0c, 0x3df0,	0x0200 },
 	};
 
-- 
2.28.0

