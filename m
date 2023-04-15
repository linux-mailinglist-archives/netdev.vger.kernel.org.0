Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188026E2F6E
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 09:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjDOHSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 03:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjDOHSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 03:18:48 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCB759E6
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 00:18:47 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id dx24so7114689ejb.11
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 00:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681543126; x=1684135126;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G9tHPxg5ARQ7Py1YbDuvv3IWOHfzSNBUVuD39czple0=;
        b=pwTcrYUxocJ2IjTzU4ajGUfNzyqt2NQYxj8A6c2vOg6vIpjIZQX5DJMgygp+58YKO2
         h4sGZwpVMgR6j3DymmebdF246WRY7Yin3clF30xXTTZqVANGNKxQIOmnd7y/r/fZzLrm
         BkPDEF6LJdAtVnnukuIS4NIXK477DN0Xxi+Hw0zO91qFRyv/Gc0BATOfvQizTx4eBFM4
         zU+9cZGSXHqJ5bFf3h3NQAMlPnCFeflc1o7r+gKUgwBnK2mhZcKrzK6PocUBltuXXtMK
         wmI0VobqhxFbVedmumg61Nr5RkQJ/xm0I5EaTtNFUZC0ocP5A4d2jZDKbqsJsI3s3ChH
         N0ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681543126; x=1684135126;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=G9tHPxg5ARQ7Py1YbDuvv3IWOHfzSNBUVuD39czple0=;
        b=f4tkk/KW4B4yMRVZo7XiRD/rLFjFG667VZVCP4ttSlcDX6hyi73uDHO4HwtzsaDseb
         FjnvFxOlnPQr5sZDbzjrrWU6XehTvw7o/wRSG1HToZf1vB3UeoYgp+T8PFJlHJHnp0Gs
         6bS5Imj7U5VHo1YYJalnyeQJdfxxCU3tFK5GPObWWInFK5xf2G2STHNNFZ/Qf4ZpQ5px
         TEYJZlUAmIE8HyrDIa8HQX5aQhOjJjvbPYOfsWCbMtKd9xwH167pWmaZvfb1gW4jtB5E
         7WIjOS6/+ub7y84+0nq9MkH27QrMl5BdRDOqa226nlB9GYR/cohXcpKntNBcPAW8tfXl
         FScQ==
X-Gm-Message-State: AAQBX9dVZCQb+Ni1BUwaQouAc2682FypNiJGGyctjc9pZzujVS6v2k2g
        vR8bB930cGRExXWNWRDt0XA=
X-Google-Smtp-Source: AKy350Yg/1UNpq2ay/36NURV7ztT9q1z55bzvU+DTK1IzFP7Vmj57peNEJJuYIzsk3UHyr+IsJaK0w==
X-Received: by 2002:a17:906:3c19:b0:8b1:7de3:cfaa with SMTP id h25-20020a1709063c1900b008b17de3cfaamr1258734ejg.3.1681543126220;
        Sat, 15 Apr 2023 00:18:46 -0700 (PDT)
Received: from ?IPV6:2a01:c22:76c9:5300:c449:604e:39a7:3bce? (dynamic-2a01-0c22-76c9-5300-c449-604e-39a7-3bce.c22.pool.telefonica.de. [2a01:c22:76c9:5300:c449:604e:39a7:3bce])
        by smtp.googlemail.com with ESMTPSA id 23-20020a508e17000000b0050692cfc24asm310937edw.16.2023.04.15.00.18.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Apr 2023 00:18:45 -0700 (PDT)
Message-ID: <f07fd01b-b431-6d8d-bd14-d447dffd8e64@gmail.com>
Date:   Sat, 15 Apr 2023 09:18:44 +0200
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
Subject: [PATCH net-next v2 0/3] r8169: use new macros from netdev_queues.h
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

v2:
- patch 2: ring doorbell if queue was stopped

 drivers/net/ethernet/realtek/r8169_main.c | 51 ++++++-----------------
 include/net/netdev_queues.h               | 10 +++++
 2 files changed, 23 insertions(+), 38 deletions(-)

-- 
2.40.0

