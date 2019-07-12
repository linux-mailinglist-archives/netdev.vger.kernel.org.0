Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3C06754D
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 21:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfGLTPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 15:15:44 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40825 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbfGLTPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 15:15:44 -0400
Received: by mail-pf1-f196.google.com with SMTP id p184so4706310pfp.7;
        Fri, 12 Jul 2019 12:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=oXYsDtz7/0DubJTDGGvFVnh+Lg24n8uWzauVA7FWOTQ=;
        b=Nr7am8SxXXYpG5t0e+1t+Av/Yh6G80yJqo/ksdWDOvMe3qqHa6cJoGyVzD5kTgSzFK
         EbacLSDUPdziFExsgVl7789UjRU3jmdIMp+rfJnmcfDPWBrubbVcGbpcumtJYSa3L5gh
         HkOt41cRAFHWciYXEPDgg5QiW17ByJrq2OFQjWfMNwNz6M75CMQ4nm4u1cKp8DRvDgbf
         MI7dFcmeLuE3pOARp57eWs93iYXlX+KupflRTesY6DS+yrPMWwMByAVm5sMftSxl89Fv
         d6z1LVc+EZHjNr9+FHaIt36QV65OzSF298ZySScn3iDUN4bVvaCfH60TeeRzjun8vFMB
         eJIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=oXYsDtz7/0DubJTDGGvFVnh+Lg24n8uWzauVA7FWOTQ=;
        b=t6VMgTZPBpYEuceAgG02Ag1H2Ks6hrQEeJa/vmz3aM428CUSlDx4xVN3wgHtHGSeee
         vGPeJNFBr0uaeWjZVtyUrIp41alkh8wEALaEdKmAvNEZIz3CY/wArR+rjBuu6H+8ImAv
         k7N5T5ufG5C37oR9WFPa5PK0UQ0WkY8itArmBoC6zK+NBNSm+6GVXGNV66L6bvojGtNv
         LIGmRhgMw54ZNaeOYkVkotf7zfKDuFf4e8CmoV09y5/YHN3YyFbPNNfaP2KQonRxL3+f
         JQ9VrgyEX5QpugVs96iPHgUlLs92siqbaVR59EmzS4jt0+0NnhXyxsnHWYGZg74yovyM
         3cjA==
X-Gm-Message-State: APjAAAU6dGts91Uv07BsyuNrxw0/NipDP64STsAxWGkmbSXafpJOuyiQ
        oJc1a4OR0hRb4OXV9gCStGg=
X-Google-Smtp-Source: APXvYqxj66wwvzMcXiXJCH8ccqM4G3d2MZ/6yh7ZJDckx9t13ZbV/TUTv0MDFeKCE1Yk71acBv5l2Q==
X-Received: by 2002:a17:90a:23a4:: with SMTP id g33mr14339109pje.115.1562958943763;
        Fri, 12 Jul 2019 12:15:43 -0700 (PDT)
Received: from hari-Inspiron-1545 ([183.83.86.126])
        by smtp.gmail.com with ESMTPSA id l44sm8835523pje.29.2019.07.12.12.15.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 12:15:42 -0700 (PDT)
Date:   Sat, 13 Jul 2019 00:45:35 +0530
From:   Hariprasad Kelam <hariprasad.kelam@gmail.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>,
        Hariprasad Kelam <hariprasad.kelam@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Nathan Chancellor <natechancellor@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: btcoex: fix issue possible condition with no effect
 (if == else)
Message-ID: <20190712191535.GA4215@hari-Inspiron-1545>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix below issue reported by coccicheck
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:514:1-3:
WARNING: possible condition with no effect (if == else)

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 152242a..191dafd0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -509,13 +509,7 @@ static u32 halbtc_get_wifi_link_status(struct btc_coexist *btcoexist)
 
 static s32 halbtc_get_wifi_rssi(struct rtl_priv *rtlpriv)
 {
-	int undec_sm_pwdb = 0;
-
-	if (rtlpriv->mac80211.link_state >= MAC80211_LINKED)
-		undec_sm_pwdb = rtlpriv->dm.undec_sm_pwdb;
-	else /* associated entry pwdb */
-		undec_sm_pwdb = rtlpriv->dm.undec_sm_pwdb;
-	return undec_sm_pwdb;
+	return rtlpriv->dm.undec_sm_pwdb;
 }
 
 static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
-- 
2.7.4

