Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03FFA6E14EB
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 21:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjDMTNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 15:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDMTNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 15:13:21 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BC9E0
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:13:18 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id v20-20020a05600c471400b003ed8826253aso4225470wmo.0
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681413197; x=1684005197;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c4Hp7KOZ0jHYR3Gp4UFG84z1/rzXwYSf4XxOfQWo9Ac=;
        b=EB4I4a/pJih/PMeOPGZX1K0SDaAjOguCRsnDF91Zl/hx0huakZ2m9vfmvJNh4/okjl
         DpH2k0vpzc7mYpEYEc6PSigZ0nbd0BobgZHNmX3jcmj2/ikO2eqOcKyYHTqBeVxOxH/r
         JKM9OlgtpsI8VpSvLGQd7rQCpSA67zpb1NzX7zSnPqrNgV636eEztMUqxbGgW7YCUTml
         iE9C/hEksSUqkle+4u5XG31cKuDxu3DN0TlcdrL1j9UaNEzvSErh1kB7lJ/YRAGSwXgY
         G0etYzWkPJPJPa8/jRPULZgUUoQB2Y/1QDdGcJvOSaa9+ZUNF8BidDg444MV7tckZKPj
         bfPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681413197; x=1684005197;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=c4Hp7KOZ0jHYR3Gp4UFG84z1/rzXwYSf4XxOfQWo9Ac=;
        b=TC2YL23WR2ExaBzTfv3LWcHu2ARgdR1aZblb4Ls+5bFsEX7ZnQG+YmQ4BiuAZ1Jn4J
         BioOw39vQuSCteh99AqBikjeqlx8QUYzSceFysrcc1jAv8moVfkWCkKKYXs44i1HmQuq
         jfA2GOzLx95G5ymKoc4XKQfZV0Qv1f4dSf8LR54cVseWl2w0zI1waeqk2hWCRFbmAmCp
         wuYeQqSEiG2U+Ukb4ss3tNJnkVwW/PvxMKXwEy6VFHRgBCMChQygcTOjNVMYISbdkOe+
         VXrlAlEC/i7AfC/oN/np4OYf4SLPgIrAzaoW0Q+hfI+/myr8PRxWA64935NMjo44EvcY
         0Z0w==
X-Gm-Message-State: AAQBX9e9RCMLxI4I1z9yDxm5UjkjKtuE6ilS5aN+RJczliPVmeL06khb
        HvU/YWMwQ436GLyuqip/PjPhIo2+fIY=
X-Google-Smtp-Source: AKy350Y1xRUuzfxB3t0Zda/dcJiIU8HcVNpbznbzewXrMach2JZ9p6t/xeD2KQjPbldZRDo3/Q0zuA==
X-Received: by 2002:a7b:c395:0:b0:3ee:4dc0:d4f6 with SMTP id s21-20020a7bc395000000b003ee4dc0d4f6mr2350784wmj.17.1681413197167;
        Thu, 13 Apr 2023 12:13:17 -0700 (PDT)
Received: from ?IPV6:2a01:c22:738e:4400:f580:be04:1a64:fc5e? (dynamic-2a01-0c22-738e-4400-f580-be04-1a64-fc5e.c22.pool.telefonica.de. [2a01:c22:738e:4400:f580:be04:1a64:fc5e])
        by smtp.googlemail.com with ESMTPSA id y25-20020a05600c365900b003f0aeac475esm511896wmq.44.2023.04.13.12.13.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 12:13:16 -0700 (PDT)
Message-ID: <32e7eaf4-7e1c-04ce-eee5-a190349b31f9@gmail.com>
Date:   Thu, 13 Apr 2023 21:13:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/3] r8169: use new macros from netdev_queues.h
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add one missing subqueue version of the macros, and use the new macros
in r8169 to simplify the code.

Heiner Kallweit (3):
  net: add macro netif_subqueue_completed_wake
  r8169: use new macro netif_subqueue_maybe_stop in rtl8169_start_xmit
  r8169: use new macro netif_subqueue_completed_wake in the tx cleanup path

 drivers/net/ethernet/realtek/r8169_main.c | 54 +++++++----------------
 include/net/netdev_queues.h               | 10 +++++
 2 files changed, 25 insertions(+), 39 deletions(-)

-- 
2.40.0

