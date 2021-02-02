Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E9B30BA37
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 09:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbhBBIqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 03:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbhBBIqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 03:46:20 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B995C061573;
        Tue,  2 Feb 2021 00:45:39 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z22so21948010edb.9;
        Tue, 02 Feb 2021 00:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2ox99HVhgfkKQy0YFujzXMK6SWexfPe2JQZv9y+VkcQ=;
        b=KQqLLQ5D9PDuj7IMWXFPJw+E5m8aYBX8Lxr9FdeNTJu+pa+Vq5B0ourfQE7E3lPMhN
         K5qk9cVGTkFvLrJWXuUpRd9j2IC0lLG4/lkfncm6xTRmjd4tp5Ymbmtv5s2AFXxHcHl9
         mUQ+e1AmMynwhmTjOtcrPuq45eOGaFwXa1orqVkrnFa/dZsS8GAGb+ZM/ujhsezbQww2
         K/M/EaNImksbZXS5P+4F+7vfqVUuELd/DtH70rhZmBqYpi41R73x70b3w1ZQ9e15UIne
         /y7MbheEZ+BgDPeKQ3iH2l9nTkbaT4WW30K6F52zlolPph4a2zFEzWz07enU8ppK32t7
         lE3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2ox99HVhgfkKQy0YFujzXMK6SWexfPe2JQZv9y+VkcQ=;
        b=KDnnHCCUU+oJ/uXQ08Suxxzw6KOdeYlTvHM5WF+l/lIaINmufRRLyDxTIYsCIhzLBP
         4E58mSxhGlXFCOZYTqoM5fcf8swXVrN7fg0zaAUBmxjQYIbwvmRcxEzHlHeSZWFex3x7
         ecCG85w7F61xFkVTlfY7lnboQWlo9hk3/T5H85OexBONwG6rt+1QLPIJtp+Ywr59P9f2
         O0kMEbXTPb2PY3/eIVijTcF0n/XTQMraUqPmIPDBEwdJn+FobTwOUlw82B2Y+iQ2rpXP
         vk4s+Tmeq3YnFhA3Qw/0/1H8XrxQZ/b6rVpLrt5KpyeDfX/LgrWg/pKB6ZnaMBdkRcNq
         duXA==
X-Gm-Message-State: AOAM532JzficvF49uUX2cy8jqPXKpf8m+mWs8LjXnw2Y82rY0xQw6HE3
        Qcqmqfu8MmyeYStQozMLQSRNoCdP2NjYQg==
X-Google-Smtp-Source: ABdhPJwy1hOut8xmhbJYwdSaY8cB723WFUy9Ci9dGMt9By8iU7bWfhtUVzU1A/HpRwRDN07RR+XR/w==
X-Received: by 2002:a05:6402:3122:: with SMTP id dd2mr22702869edb.262.1612255538290;
        Tue, 02 Feb 2021 00:45:38 -0800 (PST)
Received: from cinterion-pc.localdomain (dynamic-077-011-076-043.77.11.pool.telefonica.de. [77.11.76.43])
        by smtp.googlemail.com with ESMTPSA id k3sm3683517ejv.121.2021.02.02.00.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 00:45:37 -0800 (PST)
From:   Christoph Schemmel <christoph.schemmel@gmail.com>
To:     bjorn@mork.no, avem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        hans-christoph.schemmel@thalesgroup.com,
        Christoph Schemmel <christoph.schemmel@gmail.com>
Subject: [PATCH] NET: usb: qmi_wwan: Adding support for Cinterion MV31
Date:   Tue,  2 Feb 2021 09:45:23 +0100
Message-Id: <20210202084523.4371-1-christoph.schemmel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support for Cinterion MV31 with PID 0x00B7.

T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 11 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=ef(misc ) Sub=02 Prot=01 MxPS= 9 #Cfgs=  1
P:  Vendor=1e2d ProdID=00b7 Rev=04.14
S:  Manufacturer=Cinterion
S:  Product=Cinterion USB Mobile Broadband
S:  SerialNumber=b3246eed
C:  #Ifs= 4 Cfg#= 1 Atr=a0 MxPwr=896mA
I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
I:  If#=0x1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option

Signed-off-by: Christoph Schemmel <christoph.schemmel@gmail.com>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index cc4819282820..4edf94f1e880 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1309,6 +1309,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x1e2d, 0x0082, 5)},	/* Cinterion PHxx,PXxx (2 RmNet) */
 	{QMI_FIXED_INTF(0x1e2d, 0x0083, 4)},	/* Cinterion PHxx,PXxx (1 RmNet + USB Audio)*/
 	{QMI_QUIRK_SET_DTR(0x1e2d, 0x00b0, 4)},	/* Cinterion CLS8 */
+	{QMI_FIXED_INTF(0x1e2d, 0x00b7, 0)},	/* Cinterion MV31 RmNet */
 	{QMI_FIXED_INTF(0x413c, 0x81a2, 8)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card */
 	{QMI_FIXED_INTF(0x413c, 0x81a3, 8)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card */
 	{QMI_FIXED_INTF(0x413c, 0x81a4, 8)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card */
-- 
2.25.1

