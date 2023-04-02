Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4EE6D369C
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 11:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjDBJnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 05:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjDBJnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 05:43:52 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033BECC
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 02:43:52 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id m8so4462151wmq.5
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 02:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680428630;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gP8Yw8If7PJz//2HBSqJndLiFu53MEZ3h/2dJA3kQFQ=;
        b=K9vw2FbFHrSmA9MNXR87uMgLOA1Rd47GFg9dtktZp1DGDC3Y/2YoOVBYOK8cwRYCo7
         9fQ1jPNJaVBkZThp12+2n5y/3al4uScvV+jVbeO4UqaO/ff/rCW8qcKMby48bHm1Xs7t
         wTZBdNHLtnRuCBsbl/yVeZKq10WaKI3JBnwPYWrRwTPUyLQL1zi8ZMbqKYPHkb2EZ0/s
         Ww+WiIkovFXUDVmJ7qjsujFQkw7dv/fHMnZOz8bg5JN6FDK5VLw2Oe5wFDPeBIrmS8WX
         NjK5JYa089YfDxsZ8jO4xJyXvCtTA5qhgE7JAk1qL+BKCaw0bx3k47nvpMTh2QbSFSn5
         wonQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680428630;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gP8Yw8If7PJz//2HBSqJndLiFu53MEZ3h/2dJA3kQFQ=;
        b=rOjGLfCxdBt0H5Od1VNcGAJ4j/RpOi1wA2X8h5qMsXj35paYOe7CmSobEB+Xs9ReQD
         HU49qwGgF3JBbSqayu9hTxaCxrbJ//YNWpxEY+9R4sjWKivMNhRmW7ShMCdB3dM5vogP
         AnZrpsn1zOwwMn3z028lVWttcC8d1EtHDt4SztybwXzt9P3P2NG0jlgptsqO+jvAUfI0
         ys5m56vOCGL+CJFl+RdYPpKR5az/Q6H9bitEvwb3mKXSrfeJnboSvXGHtm89ktl87ba2
         DNK2/Qhi4f9KrPvpktGqvt+d5cwFKZBEc5picnt86QAgjcLvpS3ZbkGNmWM8fBM160ut
         VaRQ==
X-Gm-Message-State: AAQBX9efjl3/a5LqW2yekJxnLnIQSztPL43d7ORj45NEYDNfm81UnZqQ
        4NzTGzxrdqDSTNIYfC6LXK8=
X-Google-Smtp-Source: AKy350aDouPTtT1Xl0YbDN+mMTIpMCxWsje5ROmYyPSR7bbsfJed3LfxBtTz4D6gqkQ6omfMVhFv1w==
X-Received: by 2002:a7b:c8d7:0:b0:3ef:67fc:fef1 with SMTP id f23-20020a7bc8d7000000b003ef67fcfef1mr19867702wml.26.1680428630310;
        Sun, 02 Apr 2023 02:43:50 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b85:6800:129:5577:2076:7bf8? (dynamic-2a01-0c22-7b85-6800-0129-5577-2076-7bf8.c22.pool.telefonica.de. [2a01:c22:7b85:6800:129:5577:2076:7bf8])
        by smtp.googlemail.com with ESMTPSA id y22-20020a7bcd96000000b003ee42696acesm8548944wmj.16.2023.04.02.02.43.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 02:43:49 -0700 (PDT)
Message-ID: <17fcccf5-8d81-298e-0671-d543340da105@gmail.com>
Date:   Sun, 2 Apr 2023 11:43:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/7] net: phy: smsc: add support for edpd tunable
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for the EDPD PHY tunable.
Per default EDPD is disabled in interrupt mode, the tunable can be used
to override this, e.g. if the link partner doesn't use EDPD.
The interval to check for energy can be chosen between 1000ms and
2000ms. Note that this value consists of the 1000ms phylib interval
for state machine runs plus the time to wait for energy being detected.

Heiner Kallweit (7):
  net: phy: smsc: rename flag energy_enable
  net: phy: smsc: add helper smsc_phy_config_edpd
  net: phy: smsc: clear edpd_enable if interrupt mode is used
  net: phy: smsc: add flag edpd_mode_set_by_user
  net: phy: smss: prepare for making edpd wait period configurable
  net: phy: smsc: add edpd tunable support
  net: phy: smsc: enable edpd tunable support

 drivers/net/phy/smsc.c  | 138 ++++++++++++++++++++++++++++++++++++----
 include/linux/smscphy.h |   4 ++
 2 files changed, 131 insertions(+), 11 deletions(-)

-- 
2.40.0

