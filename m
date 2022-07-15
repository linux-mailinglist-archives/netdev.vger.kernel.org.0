Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21AC575893
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 02:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241141AbiGOAQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 20:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbiGOAQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 20:16:28 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AAC7390A;
        Thu, 14 Jul 2022 17:16:27 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 89-20020a17090a09e200b001ef7638e536so10074392pjo.3;
        Thu, 14 Jul 2022 17:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ryMqKrFOWmulx+usQjaVLAbS6tanQBrcDmxZy2Wn8Ow=;
        b=WpJbgubDO1Up93xBl3imotvDec2cYsqi2W6eIoG/qvmrWL1zcf4mHFoJL/iIXVKe+2
         +37oClF7n4FZHAk568mhDexpYrLwgrIB0We8gqLxg/35+LLi0Lbz4/7T8QCuLO7myGtJ
         DZ0QOrJPB85/G3AEFaC5DnIX1RDEuvvXv+e0DwDkyPryTlr76AOD29sAkIvL9A0VymPu
         qUwWHandJ5H89xnNpbN2XbfJOTFixlDvfKsLfrsY/XliwjCbpUnvcO6VRt3RfOPGnSkD
         +QdSstiJeXqsDkQ/4jf8QL/m0lUQ5tatZxKaoehGowaA/zUEbThm5+GftI9Fl6LcuQbu
         1uCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ryMqKrFOWmulx+usQjaVLAbS6tanQBrcDmxZy2Wn8Ow=;
        b=HSyP0oqr8muUYYlW+NnV1WxBJRbedhHHtdiLwCR+6EzY4d+7THYq6YkAMMxm00Cv8x
         /0HT6CUDun/jXd4/AffhklOGlC7ZAzjz2gdPUyDFrzJMppVCmWKFwoUQRshUSPb0lksK
         u7YunEUgaOgEBvJLaFSGryOx+GaasZ8dKAA0fAxAnCllNcwVk3YTi0WL1GNOd/psTyIY
         DYLHLNZcUS7nIGXZjrP/I1xVwHhZBnpTByGXkIT+Lq7jhGqPZU79Z9F0aIffZ0KTUbEW
         E+p6KGklbOA8T9cw/qgPxHrDVaWKZYzBnxLwimn62urpNFCkGa07vQIwYvZFcv1V1CB5
         IlYQ==
X-Gm-Message-State: AJIora+6X+1EzLpYQ78fWovOWtA1epRhsVzMa53U3vNjij7v8FbTnjtl
        AWFHRrTj/alAeG49h+u2r1s=
X-Google-Smtp-Source: AGRyM1ttYQ73IjzLNZZlvdgQfNR0XtEKpWrB7+ld2YjGhtuyaTRH0c7yRUqyB+khHAyO8NTOIj1HYA==
X-Received: by 2002:a17:903:228d:b0:16c:56e4:8640 with SMTP id b13-20020a170903228d00b0016c56e48640mr10735069plh.90.1657844186994;
        Thu, 14 Jul 2022 17:16:26 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z9-20020a631909000000b0041992864d69sm1924222pgl.77.2022.07.14.17.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 17:16:26 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 14 Jul 2022 17:16:25 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Jeongik Cha <jeongik@google.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, adelva@google.com,
        kernel-team@android.com, jaeman@google.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] wifi: mac80211_hwsim: fix race condition in pending
 packet
Message-ID: <20220715001625.GA594816@roeck-us.net>
References: <20220704084354.3556326-1-jeongik@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704084354.3556326-1-jeongik@google.com>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 04, 2022 at 05:43:54PM +0900, Jeongik Cha wrote:
> A pending packet uses a cookie as an unique key, but it can be duplicated
> because it didn't use atomic operators.
> 
> And also, a pending packet can be null in hwsim_tx_info_frame_received_nl
> due to race condition with mac80211_hwsim_stop.
> 
> For this,
>  * Use an atomic type and operator for a cookie
>  * Add a lock around the loop for pending packets
> 
> Signed-off-by: Jeongik Cha <jeongik@google.com>

Building i386:allyesconfig ... failed
--------------
Error log:

drivers/net/wireless/mac80211_hwsim.c: In function 'mac80211_hwsim_tx_frame_nl':
drivers/net/wireless/mac80211_hwsim.c:1431:37: error: cast to pointer from integer of different size

Also seen in other 32-bit builds.

Bisect log attached.

Guenter

---
# bad: [37b355fdaf31ee18bda9a93c2a438dc1cbf57ec9] Add linux-next specific files for 20220714
# good: [32346491ddf24599decca06190ebca03ff9de7f8] Linux 5.19-rc6
git bisect start 'HEAD' 'v5.19-rc6'
# bad: [6d30dd0872599b7004e26330fc2e476ad900e7f6] Merge branch 'drm-next' of git://git.freedesktop.org/git/drm/drm.git
git bisect bad 6d30dd0872599b7004e26330fc2e476ad900e7f6
# good: [6134a5c4db991084f2f7c2da6c6cf400e42e3a99] Merge branch 'docs-next' of git://git.lwn.net/linux.git
git bisect good 6134a5c4db991084f2f7c2da6c6cf400e42e3a99
# bad: [f6268862d21dc3233ced91b848a55b6dfa8d438b] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
git bisect bad f6268862d21dc3233ced91b848a55b6dfa8d438b
# good: [6d1ce9c03880c28a4a48f94d4a2dcb2e57c1b88e] net: phylink: fix SGMII inband autoneg enable
git bisect good 6d1ce9c03880c28a4a48f94d4a2dcb2e57c1b88e
# good: [480e10a33cdb7282f9ec91065fb624c0cd2f758f] Merge branch 'devfreq-next' of git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/linux.git
git bisect good 480e10a33cdb7282f9ec91065fb624c0cd2f758f
# good: [cfc6c2fcb686afdaea5bbca6f3dbb27815a23878] Merge branch 'phy-mxl-gpy-version-fix-and-improvements'
git bisect good cfc6c2fcb686afdaea5bbca6f3dbb27815a23878
# good: [8bc65d38ee466897a264c9e336fe21058818b1b1] wifi: nl80211: retrieve EHT related elements in AP mode
git bisect good 8bc65d38ee466897a264c9e336fe21058818b1b1
# good: [8f8df82f9cc2e76b48ba7cec3d08f4295e8f6ebb] Merge branch 'thermal/linux-next' of git://git.kernel.org/pub/scm/linux/kernel/git/thermal/linux.git
git bisect good 8f8df82f9cc2e76b48ba7cec3d08f4295e8f6ebb
# good: [2635d2a8d4664b665bc12e15eee88e9b1b40ae7b] IB: Fix spelling of 'writable'
git bisect good 2635d2a8d4664b665bc12e15eee88e9b1b40ae7b
# good: [c18bd03474a070e80fee20f0628fd0a6728c2475] Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git
git bisect good c18bd03474a070e80fee20f0628fd0a6728c2475
# good: [3c512307de4097aaaab3f4741c7a98fe88afa469] wifi: nl80211: fix sending link ID info of associated BSS
git bisect good 3c512307de4097aaaab3f4741c7a98fe88afa469
# bad: [736002fb6a09861c2663596011371884a8b7c0dd] Merge tag 'wireless-next-2022-07-13' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
git bisect bad 736002fb6a09861c2663596011371884a8b7c0dd
# good: [37babce9127f3145366a8f36334f24afa9a5d196] wifi: mac80211: Use the bitmap API to allocate bitmaps
git bisect good 37babce9127f3145366a8f36334f24afa9a5d196
# bad: [58b6259d820d63c2adf1c7541b54cce5a2ae6073] wifi: mac80211_hwsim: add back erroneously removed cast
git bisect bad 58b6259d820d63c2adf1c7541b54cce5a2ae6073
# bad: [4ee186fa7e40ae06ebbfbad77e249e3746e14114] wifi: mac80211_hwsim: fix race condition in pending packet
git bisect bad 4ee186fa7e40ae06ebbfbad77e249e3746e14114
# first bad commit: [4ee186fa7e40ae06ebbfbad77e249e3746e14114] wifi: mac80211_hwsim: fix race condition in pending packet
