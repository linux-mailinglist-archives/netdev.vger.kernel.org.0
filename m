Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E79F216813
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 10:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgGGIOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 04:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgGGIOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 04:14:48 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F34C061755;
        Tue,  7 Jul 2020 01:14:48 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d10so16449043pls.5;
        Tue, 07 Jul 2020 01:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0C0wcrNGaktDjuYvX7l+qcJPA3Xk9qtFSM1cNlh6Gqw=;
        b=MHVP5Ibh0HfJIKkVSxQSJqtyapKe7AmeX3KHnvylIYdLmkrFdK+BdWnLHlnA6xX0wO
         olcwcJxLWCZ+G9sSZ5n51OjJUvX0MT95bQeWi7ndH0ZDenKaIga4mFRwOlzEsTw4Q5BV
         K6TkhASmK++WOvxa+gmi30ZuR6c2c8hFGS3xC4waI/0c3l5eWwM4018gJmHsqOrBOx0y
         9GdKpXvIVj6hcXvGYMZf9t4mtO634XsEsFayB4WviwtpQkX6mVG6O5AGzl8+E+8CHMMu
         TapQFobQonVp/XH4BjQgbvmdajDWK/QnmWsWIqdlk8kpwiNg8/HnvVXubdySHmpCFLYE
         kCIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=0C0wcrNGaktDjuYvX7l+qcJPA3Xk9qtFSM1cNlh6Gqw=;
        b=F++R2zlwwvz/6UJvOKX1jQTapJC8cbBlTomUup/WQT1peKtEDHW2LlxgBBfQ81f0dc
         cImVKDcRMykArL7D5PdGjpKXz0H5jjkjdB2kzmw/Mzq41tFd8nAUie7ecEopFKpKvSlx
         ktVUz0fxOQmy9Jrd+Ve3KTdqQayf6tbUWheY7i0dc6qGvu8CECx+KRHL/KA9gzZUGbjl
         dSwgQFfBG8H7UyoNFmY1BUtx1jYEY1xG4oLoCnCjT6RIG2uzsylWBDtxYEnpoznO+sjc
         Nxekh2yTEPLgPOWpipaYhjfnIp8jYgYP5/bFuJzK2JXxAkIp5fnPtzkauO4icKiuruqq
         c2hg==
X-Gm-Message-State: AOAM5339Ct/U+JOE7CZOqa53Lep7e9Fy5QFjHjjPitz2aQrdPW4NTziT
        CfkO4RISOYVdPr4EueR4+nlxZ8985Xc=
X-Google-Smtp-Source: ABdhPJzH5j0mGQivJNGvT6+qUs8TD2MzZMPQcNhcl+65cjsduM7sELqERvmAeUCCagK7ZJVhlZ9ytA==
X-Received: by 2002:a17:90a:ad8e:: with SMTP id s14mr3331658pjq.36.1594109687736;
        Tue, 07 Jul 2020 01:14:47 -0700 (PDT)
Received: from localhost (61-220-137-37.HINET-IP.hinet.net. [61.220.137.37])
        by smtp.gmail.com with ESMTPSA id n137sm21997748pfd.194.2020.07.07.01.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 01:14:47 -0700 (PDT)
From:   AceLan Kao <acelan.kao@canonical.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: usb: qmi_wwan: add support for Quectel EG95 LTE modem
Date:   Tue,  7 Jul 2020 16:14:45 +0800
Message-Id: <20200707081445.1064346-1-acelan.kao@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for Quectel Wireless Solutions Co., Ltd. EG95 LTE modem

T:  Bus=01 Lev=01 Prnt=01 Port=02 Cnt=02 Dev#=  5 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=2c7c ProdID=0195 Rev=03.18
S:  Manufacturer=Android
S:  Product=Android
C:  #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#=0x1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 31b1d4b959f6..07c42c0719f5 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1370,6 +1370,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x1e0e, 0x9001, 5)},	/* SIMCom 7100E, 7230E, 7600E ++ */
 	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0121, 4)},	/* Quectel EC21 Mini PCIe */
 	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0191, 4)},	/* Quectel EG91 */
+	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0195, 4)},	/* Quectel EG95 */
 	{QMI_FIXED_INTF(0x2c7c, 0x0296, 4)},	/* Quectel BG96 */
 	{QMI_QUIRK_SET_DTR(0x2cb7, 0x0104, 4)},	/* Fibocom NL678 series */
 	{QMI_FIXED_INTF(0x0489, 0xe0b4, 0)},	/* Foxconn T77W968 LTE */
-- 
2.25.1

