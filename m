Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741806E43F6
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 11:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjDQJfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 05:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjDQJfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 05:35:34 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3742155BE
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 02:34:58 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id dx24so18382709ejb.11
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 02:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681724089; x=1684316089;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2T63HqTIdIpI8EbXzb2o6w76lMsZPUq2tIpTHrclYCA=;
        b=QqJfAK/LJug31d+ALT7H9SXVPo0G+7SJXSG8s36uOhcZqGJq2zz5k6i4Mu0TvHlj5Y
         bYGCP/Gr+jLXPnT2Y6HdMnNBklOv17tFFAYneG1Cc6d7hIOT0BZmGJ5D9YyvYW0m54GB
         K/wdyKEz0bwDDH90bZID6ktHbxkfQAltwj/ezBmK2G/jdwb2enOPYvTZbZWiTMx0qD23
         D/GlbERDMMKq+aUCKOCUgyaH9i/T/G/FHAYsO9XPePBy/eOaDeFH8CUczCqu27j0/ang
         fWOAF+oYL+Ucoop7VtQsTSRIKGuTlg6IxITQR88Rqw7w01arVoCvxBG7BL7cSzQlQhoH
         quZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681724089; x=1684316089;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2T63HqTIdIpI8EbXzb2o6w76lMsZPUq2tIpTHrclYCA=;
        b=CA1Rgb82wJ5iUG7X0TTkldoi3+ajo2h7pzi/QyZ7ZOJdcKE9BQPjVDy1Zt8WNbHlim
         dGxjSskdOmkeczfWXZFWGh0vTgkQOlyOZkVyFWLhTX5mF9QXFo4dat8KBa/7/KZpKN1+
         ayvB0j7kzGfyVdHDRqfVGG4ty+JqQ7gP0CcnG80hS+cAtwyVnVBxOKZ2JkXM8vgRzqK/
         9a80P/EQlkWTxU8ydvMCK+wh15kn9FEpCgpaUa9CLNiQyIHMYXw1Pt7agVvgNUOxy/wh
         q4BO46zLeo2mB8zBSszKnK8jq8SMimg1PderM3cSTDEYF9MYMawEEY8HkaFXRN/XdTaT
         /fmg==
X-Gm-Message-State: AAQBX9cHk8IvXsM0ptx/M3piLL2grDmYp2Awa4yHnF+0PXfcw36jXdIF
        DC0x0gprjBIsaV5MqwDJ7GaD8xVjbXE=
X-Google-Smtp-Source: AKy350Zp/JWwHvO/GKyRI/z778qk3ihObtlUOa7V/Bo2c7sSvhJ0oQdYrxfh7cbOLESgKDDhdAke7g==
X-Received: by 2002:a17:906:8442:b0:94e:d37d:a3b5 with SMTP id e2-20020a170906844200b0094ed37da3b5mr6056669ejy.24.1681724088561;
        Mon, 17 Apr 2023 02:34:48 -0700 (PDT)
Received: from ?IPV6:2a01:c22:770d:1c00:59f1:1548:39fc:ccd5? (dynamic-2a01-0c22-770d-1c00-59f1-1548-39fc-ccd5.c22.pool.telefonica.de. [2a01:c22:770d:1c00:59f1:1548:39fc:ccd5])
        by smtp.googlemail.com with ESMTPSA id nd23-20020a170907629700b0094e9f87c6d4sm6258811ejc.192.2023.04.17.02.34.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 02:34:48 -0700 (PDT)
Message-ID: <7147a001-3d9c-a48d-d398-a94c666aa65b@gmail.com>
Date:   Mon, 17 Apr 2023 11:34:41 +0200
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
Subject: [PATCH net-next v3 0/3] r8169: use new macros from netdev_queues.h
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
v3:
- patch 2: remove change log from commit message

 drivers/net/ethernet/realtek/r8169_main.c | 51 ++++++-----------------
 include/net/netdev_queues.h               | 10 +++++
 2 files changed, 23 insertions(+), 38 deletions(-)

-- 
2.40.0

