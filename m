Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C365A8905
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 00:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbiHaWcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 18:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbiHaWcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 18:32:22 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6778D74CEF
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 15:32:21 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id p7so10777523lfu.3
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 15:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=dTwAMPh/9V/Am+K9PM8dwE1AGq+3RYvXPgc7SOQjnXU=;
        b=AwCm+X3GWpKn0gfiVI5YDWhY7Hf+771k/0DlcRP6gYXp2EXsCGfghmTJ4IKa/KFpIS
         ndqIV2Ht4wC63q6JXp0jzti09VE2ztBngbuRXiGlzbegYrDG7GLZ5jjxBI9UU8gUbaG8
         R+7dCpnkZoa4bYVwZoIQJk9HwWhKNr68vv3LA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=dTwAMPh/9V/Am+K9PM8dwE1AGq+3RYvXPgc7SOQjnXU=;
        b=Zl3c7d1qcert6mxDPjEJhCI9teAKrxCPZxCrkon+LQzp43E6xoCQY3JawkLCGUMBw7
         W+8KlwZcO1boHvzS50V9qlFrBdbkye+vE0NVQrb0o6Nu8D12aQ+x7FZR8YYxlNpkx2Ul
         urvuEjD4X+D7zU+QWV/xrHkV7SzDbp8xsZfQmG7U9jbSkeakgg5tkhsbHbxx34hfrQme
         2xjfrx0bBopwgncoxlvkTPYZmjA6S5VHYJtobhXQpbhwN/ySEp9abYKzBZDR4TfrwjPz
         1F0OYm1Fi33Fy+qYyDMxrmFhyVkm1nKQScKIe0YRcXih7m7otLpnSfvF5HvpF3X+7IKs
         KCdg==
X-Gm-Message-State: ACgBeo11i1dJmejEZQlYMOs8MIYDJ45koXrVzqyG7bY4yL1FS3hwUvvD
        YlS8q/AHiNe6/g1cQQvJriEhiIXxiJdLeJuhALSQDw==
X-Google-Smtp-Source: AA6agR69w+RepP760fxnlu03RE5qBGFOQtu+j9+wYxau+pFkCQzBU/VUmTKGwO9WllApgUbwqxoj9Q==
X-Received: by 2002:a19:3808:0:b0:494:772d:161 with SMTP id f8-20020a193808000000b00494772d0161mr3191366lfa.308.1661985139515;
        Wed, 31 Aug 2022 15:32:19 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id e20-20020a196914000000b0048b17852938sm1659683lfc.162.2022.08.31.15.32.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Aug 2022 15:32:14 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id v26so11678554lfd.10
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 15:32:12 -0700 (PDT)
X-Received: by 2002:a05:6512:23a1:b0:48a:fde8:ce8c with SMTP id
 c33-20020a05651223a100b0048afde8ce8cmr10438685lfv.393.1661985132356; Wed, 31
 Aug 2022 15:32:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220830045923.net-next.v1.1.I4fee0ac057083d4f848caf0fa3a9fd466fc374a0@changeid>
 <166198321700.20200.2886724035407277786.git-patchwork-notify@kernel.org>
In-Reply-To: <166198321700.20200.2886724035407277786.git-patchwork-notify@kernel.org>
From:   Sven van Ashbrook <svenva@chromium.org>
Date:   Wed, 31 Aug 2022 15:32:00 -0700
X-Gmail-Original-Message-ID: <CAM7w-FWjcQBOsRa=EK8CAiS_1WvFAjUVktzWx_3ksL5Vs2jGfg@mail.gmail.com>
Message-ID: <CAM7w-FWjcQBOsRa=EK8CAiS_1WvFAjUVktzWx_3ksL5Vs2jGfg@mail.gmail.com>
Subject: Re: [PATCH net-next v1] r8152: allow userland to disable multicast
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     linux-kernel@vger.kernel.org, levinale@google.com,
        chithraa@google.com, frankgor@google.com, aaron.ma@canonical.com,
        dober6023@gmail.com, davem@davemloft.net, edumazet@google.com,
        chenhao288@hisilicon.com, hayeswang@realtek.com, kuba@kernel.org,
        jflf_kernel@gmx.com, pabeni@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you Hayes and Jakub for taking this upstream.
