Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14186D38A9
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 17:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbjDBPKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 11:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbjDBPKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 11:10:47 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C794CAD27
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 08:10:42 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id v1so26868392wrv.1
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 08:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680448241;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m/E3MMuBJ31rqT4BC24DDq4gunPAU/ZjmBbtSN50tKk=;
        b=D9W7Yszee8V7PN6F5i9kJh+1ToQxmgx972agrlznghxmvbcNRUcI8Bdh9atBoPpFhK
         u4DMloIJLkgxYECceDm62sckdSZlWrlkR8tdhGepJbVQxrBjkdUylkZBpDb2kDv6DrVW
         EwgADkUd96ZIb5PbXz33+Qd1VFQ2zXzZtrmmukdykgTmdILYsBOW4nC2s7VX4FtF5bcI
         XLIr/bK8OpL+ka4ujBANB3Cs9ptOe398tiLKA9xvB9a58W9lrGwxUEQJEjlVtjRdArUP
         tHCAVGRedHIPqovSXcd9H9DXX2BSPNOYc1bPnA90VjldMm/LdZ6ThNvFVCZmuMAl6YUv
         lZcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680448241;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=m/E3MMuBJ31rqT4BC24DDq4gunPAU/ZjmBbtSN50tKk=;
        b=XlYLBU9vdvoI9ZymoJ1m0LFv736QnvU2nfpbKHX2APy/j/l+j7VPum7HjYIfgUQCox
         fB8xow9KYK7s2JSOQwJdzheKeb1yWrdO72XHCt0c3gKG4KOMD6Bsaazmuck1M1ujp/FV
         TumIFSblHJHhBjJHK2KOcYBsLyWvjBxVGrqIi4yyFgCNSXYkhRnXpZi+GV8thiZ7QBh7
         ehONbyFqLjsfwcIh30hmMdRg0oiX1yN7AImgohjhD3dbq9uNcmJslboXmXEYyyfR8iu5
         XomKys09WBemu/BUuxNjY2FfznrQIqPelGkOBtNEXmT1Gil+SU0p7Z+5mxJiwEuc1v9S
         +I6Q==
X-Gm-Message-State: AAQBX9dU51ksb7AMRhpFS3vhKesCT2cHjckVd8cCFEV9k/lbxn5uxJ1J
        9I1S3VBe5kCjmm1E2hX5FUU=
X-Google-Smtp-Source: AKy350ZiK1XLTozeuBZCfnZ6JMyLa5m5hH7RCr23/69HfIcSVFWDBYbZI4uakAExz532ndysAuGrJg==
X-Received: by 2002:a5d:6585:0:b0:2ce:9a15:3724 with SMTP id q5-20020a5d6585000000b002ce9a153724mr21301287wru.3.1680448241043;
        Sun, 02 Apr 2023 08:10:41 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b85:6800:129:5577:2076:7bf8? (dynamic-2a01-0c22-7b85-6800-0129-5577-2076-7bf8.c22.pool.telefonica.de. [2a01:c22:7b85:6800:129:5577:2076:7bf8])
        by smtp.googlemail.com with ESMTPSA id p4-20020a056000018400b002c56013c07fsm7392234wrx.109.2023.04.02.08.10.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 08:10:40 -0700 (PDT)
Message-ID: <d0e999eb-d148-a5c1-df03-9b4522b9f2fd@gmail.com>
Date:   Sun, 2 Apr 2023 17:10:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Healy <cphealy@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v2 0/7] net: phy: smsc: add support for edpd tunable
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

v2:
- rename constant to EDPD_MAX_WAIT_DFLT_MS in patch 5
- consider that core locks phydev->lock in patch 6

Heiner Kallweit (7):
  net: phy: smsc: rename flag energy_enable
  net: phy: smsc: add helper smsc_phy_config_edpd
  net: phy: smsc: clear edpd_enable if interrupt mode is used
  net: phy: smsc: add flag edpd_mode_set_by_user
  net: phy: smsc: prepare for making edpd wait period configurable
  net: phy: smsc: add edpd tunable support
  net: phy: smsc: enable edpd tunable support

 drivers/net/phy/smsc.c  | 131 ++++++++++++++++++++++++++++++++++++----
 include/linux/smscphy.h |   4 ++
 2 files changed, 124 insertions(+), 11 deletions(-)

-- 
2.40.0

