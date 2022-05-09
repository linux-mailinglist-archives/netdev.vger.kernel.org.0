Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9995204FC
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 21:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240426AbiEITMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 15:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240401AbiEITMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 15:12:53 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D7E2BD21B
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 12:08:55 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id m12so1011511plb.4
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 12:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pXa65HSOekWaeyzVWpCjR2cUTwoVlIGMwmqZrezGgpM=;
        b=RciZSc0HZxxQu4Ns7GyvMmsGXouKEOXJo78Y4IoQyEc+9iFCqFi1YulIn6iqyTcoPs
         Q+HrwtVXnmPGUEl08j5yaePhPc/xPz1Orq+2FXWlTwA1CVPI3uDbVwe+f04tQ9tP1d1d
         YJd/HwqCD+aXkgel96UnBrWtVhadGx6Din/X9mtr29vTIwPe2El6oczEk2R9iFjJ6diw
         ERjRsSZVfCRraE4xy75OgBQ8YGey7/OvHeCK8UZ+sXYYhxrEOR6RKWgItDeOD+UVJKcx
         x54+pmiyRW0NOmc3dJP7kdUVN4JeN58FouHQUW7/4PZpiDUBkJNcj7w7jIkQUYTmQwgd
         rCiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pXa65HSOekWaeyzVWpCjR2cUTwoVlIGMwmqZrezGgpM=;
        b=OzEMU5XH0VOeHpvsj+uSYMjMJxiR8GDm3c/t9w0vzjrRj+U5A7o/e365eYQpzNwBh4
         oVirTX6Zsv+AT3MaVtuvtvGm/FDKf7405B8OV5iQuMLgzbcEAKVX05bdX6SCrlQdSKal
         KdY5jukE8LnHka74fo+VImX7/TDtJuqjm/hbav1XuXgMzMnHfkNZpTVsi9b6w4s7FW8T
         HAPoOKOebZSBhFDkxFevvcsNN9uX3Hg/1OLrdoik+3FLDrYWdkTbPMeWWHZNdp3beDL2
         goNHFWlB4eh8SntUFhmI4xV7GY0XnO5CjVLk5MuDH5I0DH+m/RH8OoN+tvdtMztbJpCW
         T2xg==
X-Gm-Message-State: AOAM530CPh2Vip7g19tnsfQkU34Y+6A9arRg4C7aiVniRvb1NsVIEwTS
        GS6ulqOWbsouLIX7+vuPlhwLzLRrSKk=
X-Google-Smtp-Source: ABdhPJzO5dC4tea8be3e3ecp8gDIPzKL13qae6RQsBHqjYFh7UADf/YE/TCQ21DFTCtG+wh85QTBoA==
X-Received: by 2002:a17:903:14a:b0:15c:f657:62d0 with SMTP id r10-20020a170903014a00b0015cf65762d0mr17661198plc.81.1652123335254;
        Mon, 09 May 2022 12:08:55 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id a6-20020aa79706000000b0050dc7628174sm9032631pfg.78.2022.05.09.12.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 12:08:54 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/4] net: CONFIG_DEBUG_NET and friends
Date:   Mon,  9 May 2022 12:08:47 -0700
Message-Id: <20220509190851.1107955-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This patch series is inspired by some syzbot reports
hinting that skb transport_header might be not set
in places we expect it being set.

Add a new CONFIG_DEBUG_NET option
and DEBUG_NET_WARN_ON_ONCE() helper, so that we can start
adding more sanity checks in the future.

Replace two BUG() in skb_checksum_help()
with less risky code.

Eric Dumazet (4):
  net: add include/net/net_debug.h
  net: add CONFIG_DEBUG_NET
  net: warn if transport header was not set
  net: remove two BUG() from skb_checksum_help()

 include/linux/netdevice.h | 154 +----------------------------------
 include/linux/skbuff.h    |   2 +
 include/net/net_debug.h   | 165 ++++++++++++++++++++++++++++++++++++++
 net/Kconfig.debug         |   7 ++
 net/core/dev.c            |   8 +-
 5 files changed, 181 insertions(+), 155 deletions(-)
 create mode 100644 include/net/net_debug.h

-- 
2.36.0.512.ge40c2bad7a-goog

