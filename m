Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB9A84E2109
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 08:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344766AbiCUHRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 03:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245477AbiCUHRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 03:17:00 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FBF3EBAB;
        Mon, 21 Mar 2022 00:15:35 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d19so14675201pfv.7;
        Mon, 21 Mar 2022 00:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OUJOZBwGbollWrpdYQoZPkdenvguOm3D7K6hbDbX3PU=;
        b=hng2vQGxKUpbyul73fNVPi5UIZanX4aLXWj8pyRLyGYjb+VcYR1+gxxWnaJIb7MV5U
         AZn027iDkdKY9GXaRJy9A8rxuAF355IszIfGZcOiCz30PH/ZaojLpi08jJOXPVS3SZuR
         sZkoPZWPtm+PzwOP98hvIB7t/0xl5cxOCm/StZY4FyVMl4O3LhdfZY77DpqClbXvbWjn
         3V1xI4TxhxloTbtLlX8pHcwBQVpjuOv6PbGn7H0eyICCSpXq30j3I4+LIEhaK8wxSI1I
         AqplfshvYcKzyxF9S7w92w/1hqJE3qLSuuAJDLAP4sqceyAJ7PPTOtqHqMRuAl//h/uw
         or6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OUJOZBwGbollWrpdYQoZPkdenvguOm3D7K6hbDbX3PU=;
        b=rwSCbopFb+s5oZmD9ElWBzpzYb/4GQ6SB3+WkbTNg3WHbZk1nAsRjANA+0J+RSTWAq
         PBUluGqfx93DATIX9IpevR6MvdrZ3hCii9E1IKNVekgbHPn2G3AfwKn9d0r4FoVYwjy0
         ENRas8G9I7lNjVh2jX0XlZ4CfPyxpsApbBs/VZ0TqKAJt9LjiBjgxdQjSRyk3GW0AlD5
         cZ6II/zO+vhx/6c6G4WG+gBjn6jomt4EoiteCUmfHkcNMEBolck7JMZjFTXjaZCpuReF
         09TChukfFUYjkZkFO8dhzysQJmFwwfFzD/5dSpe7SQ9Kx8tXhVLAk1kW2Nq+kvXepsVs
         IakQ==
X-Gm-Message-State: AOAM531CiQo6n5cZZA6FDTv+K1XDGgAX//ut3U4TS91wKbSYRwEPvG5Y
        nNqSLvMdviKvDEdsnKbYMNI=
X-Google-Smtp-Source: ABdhPJzlRaJRgpY29vlVyh8Ywx8tQrnGEO3U7HoRjp0EoXBNvs47FPCiSsu9hD6zQzwfOhL1aNcHdA==
X-Received: by 2002:a05:6a00:1687:b0:4e1:45d:3ded with SMTP id k7-20020a056a00168700b004e1045d3dedmr22428890pfc.0.1647846934909;
        Mon, 21 Mar 2022 00:15:34 -0700 (PDT)
Received: from tong-desktop.local ([2600:1700:3ec7:421f:a425:dbce:b9cb:7c6f])
        by smtp.googlemail.com with ESMTPSA id 3-20020a630003000000b003828fc1455esm1333261pga.60.2022.03.21.00.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 00:15:34 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Karsten Keil <isdn@linux-pingi.de>, Sam Creasey <sammy@sammy.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pontus Fuchs <pontus.fuchs@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tong Zhang <ztong0001@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 0/4] fix typos: "to short" -> "too short"
Date:   Mon, 21 Mar 2022 00:13:50 -0700
Message-Id: <20220321071350.3476185-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

doing some code review and I found out there are a couple of places
where "too short" is misspelled as "to short".

Tong Zhang (4):
  ar5523: fix typo "to short" -> "too short"
  s390/ctcm: fix typo "length to short" -> "length too short"
  i825xx: fix typo "Frame to short" -> "Frame too short"
  mISDN: fix typo "frame to short" -> "frame too short"

 drivers/isdn/hardware/mISDN/mISDNipac.c  | 2 +-
 drivers/isdn/hardware/mISDN/mISDNisar.c  | 4 ++--
 drivers/net/ethernet/i825xx/sun3_82586.h | 2 +-
 drivers/net/wireless/ath/ar5523/ar5523.c | 2 +-
 drivers/s390/net/ctcm_fsms.c             | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.25.1

