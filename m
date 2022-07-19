Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832E5579F74
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238398AbiGSNUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243542AbiGSNTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:19:09 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AC39B66C;
        Tue, 19 Jul 2022 05:36:16 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id r1-20020a05600c35c100b003a326685e7cso435903wmq.1;
        Tue, 19 Jul 2022 05:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wXm5PogxfAB3Uzgf0gySFxeQewMM62LTtazb+hFvxl8=;
        b=EcpvWU1HEi6SZfcrOhOHBZCN3iGK1phT4LTIBsG430f1hA0JMCO0rIppkj2+TBb3Ez
         jGbhnlSviLvEjrUCGUjxdbM/1yzfIGL/qoYJhpsjo02Wkx+bfZhB465l1JBpxhYP0VOh
         iRXTNlL+88+G5ozRJMq/AWFbkSDAhK7CW7grOFDWB7/apkfUjY6C32OWN9XkyLSMHO4R
         UMAh8U9L5XukQDu/M47JLQmwGl3PekKZASwDBcncTaFhkJ4igbWKjKcTQ1nFutKr6SVD
         ewmpZVY11pj9c7o8po3AFtteJWZmD0GFzyHrj4h5fu0fWEfH3PHuAje0iCIYKvaWLT1i
         GEug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wXm5PogxfAB3Uzgf0gySFxeQewMM62LTtazb+hFvxl8=;
        b=tU1ZN7N9WlWn/RAOSBn30rh7iyY/wBn3ocImwDgEeLB8Zjrp2osqVsZlCKqzR8eX1K
         crFY2xXEzZ45MjxT4uboXvl6QbnBFBQpxvxr0GBwXnN8v6XfovWxgFrW+nx/AdwkCK+q
         nvx9e3Yf7ZIt4S/b7netB+2b+elMSSgmdxSvsKAz3/TrCsLWyP1dUb7R0UxuTSkFM9VY
         /LaLK5DxE6QzV31PFg55AVAKjwQ234Ucexd7EN0EWepeGfh6+I8mGU+8U3fok2mZxPya
         fqKPNyVVopTPvimjl+kiIkCtsiQk5NVq+nf8/pOElUG82K21HLHNvj55N8US8fck2X4k
         EmVw==
X-Gm-Message-State: AJIora9T2b4rMC25OL7wpEdNY/xozviXIHIlz3Nyi+MdGpBqYIaqA2eO
        +3jWOpqhWFBZo3pumWHjL3o=
X-Google-Smtp-Source: AGRyM1vidq7CvBtOwZBzLJPOQFjxQQN0RPIQdohz2Y86JsLsu52TG6arxAG5acuNORUbBvHU27Bkpg==
X-Received: by 2002:a05:600c:4e54:b0:3a0:4e07:ce with SMTP id e20-20020a05600c4e5400b003a04e0700cemr31494733wmq.37.1658234174504;
        Tue, 19 Jul 2022 05:36:14 -0700 (PDT)
Received: from baligh-ThinkCentre-M720q.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.googlemail.com with ESMTPSA id bp30-20020a5d5a9e000000b0021e297d6850sm3337522wrb.110.2022.07.19.05.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 05:36:14 -0700 (PDT)
From:   Baligh Gasmi <gasmibal@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Linus Lussing <linus.luessing@c0d3.blue>,
        Kalle Valo <kvalo@kernel.org>,
        Baligh Gasmi <gasmibal@gmail.com>
Subject: [RFC/RFT v5 0/4] expected throughput from AQL airtime
Date:   Tue, 19 Jul 2022 14:35:21 +0200
Message-Id: <20220719123525.3448926-1-gasmibal@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v5:
- add busy time percent in NL80211 interface

v4:
- fix compilation error
- Take into acount current channel busy time percent

v3:
- update to new MLO sta struct

v2:
- total size overflow, use u64 instead of u32

v1:
- make one div after at least 100ms rather than one div each skb


Baligh Gasmi (4):
  mac80211: use AQL airtime for expected throughput.
  mac80211: add periodic monitor for channel busy time
  mac80211: add busy time factor into expected throughput
  mac80211: extend channel info with average busy time.

 include/net/cfg80211.h       |  1 +
 include/uapi/linux/nl80211.h |  2 ++
 net/mac80211/cfg.c           |  8 +++++
 net/mac80211/driver-ops.h    |  2 ++
 net/mac80211/ieee80211_i.h   |  6 ++++
 net/mac80211/iface.c         | 65 ++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.c      | 46 +++++++++++++++++++++++++
 net/mac80211/sta_info.h      | 11 ++++++
 net/mac80211/status.c        |  2 ++
 net/mac80211/tx.c            |  8 ++++-
 net/wireless/nl80211.c       |  6 ++++
 11 files changed, 156 insertions(+), 1 deletion(-)

-- 
2.37.1

