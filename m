Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 305D610AA5A
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 06:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfK0FoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 00:44:06 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:34645 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfK0FoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 00:44:05 -0500
Received: by mail-pj1-f68.google.com with SMTP id bo14so9405988pjb.1;
        Tue, 26 Nov 2019 21:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=FMYyAGSOjqa1kmojeILRKOUaJMyqkQLJBPPeC/R8Edo=;
        b=b1fnJGn86jAG/ZPmG53NNoajx+cmxK3BUnbWlOW4Zi1CaI/OXkeHUlnlMlGhvGc5aN
         pr/kIdNjbmKvLNuknW7LlOTP2p9mOhpmVMSgoR4jYGsNNqdR798mAirFTR2/hTGTDDuP
         VaE3PUKVxHF3ph/HKDghAWMHjXcixW8k9auUFrjV95RmUf8mijG3dp6ePBs9tbTUuOYc
         7x+NnM8aqm+fcy9KM+2NduZzqOW3AYHu2UrlFdrveyMnNRn28DhSBg+IjXrpJoN25Sk8
         /wdQxFDtJGLj+vo289WrFF3AtTDqX4qAyqCKErPqdLGIsLo6NJVOOekfYuAo0kIjCU2Z
         oQiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=FMYyAGSOjqa1kmojeILRKOUaJMyqkQLJBPPeC/R8Edo=;
        b=TxUqVdZ5YnVp3skmYNiXe/q0SyR8jxCXo8lytyAbOFDjDDZiq4esVac277jyoBG6d5
         05jivEEv/Zo5MstyJTYsf7Io3z4Y8i2SpjFIs2GJBjbbqAVe1oEHv7XLxehvfwA4f5R/
         Md1fBAU84rhlNf+cW0ih4tqLkWn4q59l6JdLQyCXWdi1EaZfIA1oqUyBPSIz3Mu8tQxZ
         Ou9zDcM98q9YWj4C2YTnH7sUGLqheb7+QX5qI2E3XIwsxVOBYkNstpAQWanEDPXoNPfO
         AGbeFj8sevvJ74gLMUjuii0jUzLDW/0FwhCd34LlhISMG3v75hyc0wg3/zwhtSpZsgfl
         Jn/g==
X-Gm-Message-State: APjAAAXlrM983SCMVPVVcnbLaotQGcHo52mi0w9l4MlQ6kaW1qOVI/g+
        BlytcxrkrOBRyYQQwIIB11g=
X-Google-Smtp-Source: APXvYqxVT3gXIupAJuzGIwIijzKKKPfT5lpthnrI6M//XlmgwynelR+d0M3wjTDKZyeNZN0SyXUXpg==
X-Received: by 2002:a17:90a:77c3:: with SMTP id e3mr3894028pjs.14.1574833444724;
        Tue, 26 Nov 2019 21:44:04 -0800 (PST)
Received: from LGEARND20B15 ([27.122.242.75])
        by smtp.gmail.com with ESMTPSA id s18sm14883829pfs.20.2019.11.26.21.44.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Nov 2019 21:44:04 -0800 (PST)
Date:   Wed, 27 Nov 2019 14:43:58 +0900
From:   Austin Kim <austindh.kim@gmail.com>
To:     arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, austindh.kim@gmail.com
Subject: [PATCH] brcmsmac: Remove always false 'channel < 0' statement
Message-ID: <20191127054358.GA59549@LGEARND20B15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As 'channel' is declared as u16, the following statement is always false.
   channel < 0

So we can remove unnecessary 'always false' statement.

Signed-off-by: Austin Kim <austindh.kim@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
index 3f09d89..7f2c15c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
@@ -5408,7 +5408,7 @@ int brcms_c_set_channel(struct brcms_c_info *wlc, u16 channel)
 {
 	u16 chspec = ch20mhz_chspec(channel);
 
-	if (channel < 0 || channel > MAXCHANNEL)
+	if (channel > MAXCHANNEL)
 		return -EINVAL;
 
 	if (!brcms_c_valid_chanspec_db(wlc->cmi, chspec))
-- 
2.6.2

