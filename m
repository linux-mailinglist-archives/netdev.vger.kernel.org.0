Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA1A37B0A3
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 23:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhEKVRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 17:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhEKVRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 17:17:54 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E9AC061574;
        Tue, 11 May 2021 14:16:46 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id m11so14232857lfg.3;
        Tue, 11 May 2021 14:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HoRbP8bMNRAMwrSttIv6A0hR3UMPnaiNX2rizRlD5KQ=;
        b=e9Rm8umSvdZceUTGJxFSdgg9uoVJwQn1vxJKVUTVSTwDlEnGrTNc+YTaYBVsapveb8
         2ZthPW00n7lS/ngbOzbvT3eCVvSPlxYImW0/zzgpeSnRjQJ/pIOauwXM+lGMML1tkMn3
         Jdz82xmEM5CGElwmHbJXZd3qRd6/CUMRiiNASc/jwTLZIm2WkxB0koq6qkg9PetvgW1D
         +nAvbuC2eDa+UGaOTF19iY1qEtUPu5UBqVf/1MhL5Fk+uuTWygXURiBTSwIBuSTZ+wq+
         DtTev7+GUOzIkLD9snNj0hR994oABuQFMdHP0HcV9mob1ZSff6TH+TYY+yRhnXwYpDvg
         +PiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HoRbP8bMNRAMwrSttIv6A0hR3UMPnaiNX2rizRlD5KQ=;
        b=KieWAzJv2COsBsagnjVoQ8e59GYT0g047Ih6ZZQ20PgOQSXbMDoeAzDb4WYnOloSqy
         mrFkD/LIK6+ccE4AWQ3LY9Qasf4F8Qil7596C2VNLVmSilVjFXQjA2zCzw9GOQ6HMMr7
         JfqimBkauabUa9dJqTPNPYya5cRJvkQi0H99iDAqYi44f5AjFNTwH12NN8Alv5HH6I7o
         xxLhG+f0NdlLxKDz9xBOh56cmRdAdPIJS3c4tRRhcYyW+F/x6tiPdzTBVAsV/crUTDH3
         QQDtggciDoW1f92mJPycbTgrXrWeEVGEGbp10nYTLhM5y0EIUQsxnu2GwRlJlx2/d7Xs
         Getg==
X-Gm-Message-State: AOAM53397ZIJZpzi8ytS+VquPFUcJsIiWxiU0QTOLpbkrpt9o/xXtTZH
        2oU72h4Q+6a4NpemBqM7pjyebyYsVdU=
X-Google-Smtp-Source: ABdhPJzDWx/gzX+4FKoJ+MTI5x0Wv9eSBFHHuB69RqaHmAtnwQX9z68lrTCVdQIzFM1PS6JEfU0W3Q==
X-Received: by 2002:a19:c518:: with SMTP id w24mr22873333lfe.104.1620767804833;
        Tue, 11 May 2021 14:16:44 -0700 (PDT)
Received: from localhost.localdomain (109-252-193-91.dynamic.spd-mgts.ru. [109.252.193.91])
        by smtp.gmail.com with ESMTPSA id a20sm3882527ljn.94.2021.05.11.14.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 14:16:44 -0700 (PDT)
From:   Dmitry Osipenko <digetx@gmail.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] cfg80211: Add wiphy_info_once()
Date:   Wed, 12 May 2021 00:15:48 +0300
Message-Id: <20210511211549.30571-1-digetx@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add wiphy_info_once() helper that prints info message only once.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---

Changelog:

v2: - New patch added in v2.

 include/net/cfg80211.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5224f885a99a..3b19e03509b3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -8154,6 +8154,8 @@ bool cfg80211_iftype_allowed(struct wiphy *wiphy, enum nl80211_iftype iftype,
 	dev_notice(&(wiphy)->dev, format, ##args)
 #define wiphy_info(wiphy, format, args...)			\
 	dev_info(&(wiphy)->dev, format, ##args)
+#define wiphy_info_once(wiphy, format, args...)			\
+	dev_info_once(&(wiphy)->dev, format, ##args)
 
 #define wiphy_err_ratelimited(wiphy, format, args...)		\
 	dev_err_ratelimited(&(wiphy)->dev, format, ##args)
-- 
2.30.2

