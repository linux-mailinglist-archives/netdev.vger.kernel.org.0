Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C145B64B4
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 02:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiIMA53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 20:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiIMA51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 20:57:27 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB38D2CE04;
        Mon, 12 Sep 2022 17:57:26 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id b17so5481120ilh.0;
        Mon, 12 Sep 2022 17:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=3FYZZ9kIkwc/JXTwVRSMlvQxtVggGrYH2HuC/wMgOdI=;
        b=NYFdQ/VJ7Ustan9+kh9NBj5xKkAcAprM+EvkVz+OEu9s2jc6odB1P1d9eCn3LB1BSF
         HVwiHNCWN9cjxHJmBFkuGDtng69dDzlhKuC2jwgo4GQZxAVPJBs8HWj0t+V1LaxAxs0h
         fFzq8E+L/Iwynedl8mokiGkDK8GhKaqxYO4+06Qzopn3UqEYs4e3QSLI98/TP93vRhnH
         p/3tjR4/o30yQRI+pgkK66f9TPe2ty2CUVfUKB9vVPaN12bYG5fpQzr1r6zU60mkOa4r
         tHT7faSnWb7dT6wgasw41T4hZHlyYGkxCRjjtSc6R2brP983LSm90ZpydP1mFqjapNg4
         x0lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=3FYZZ9kIkwc/JXTwVRSMlvQxtVggGrYH2HuC/wMgOdI=;
        b=TSMflBuMmn150lkQlQHIDJnawJu4ZhFFGLiV8f42iLWdclDGrHBuqftznKXyhyyQkN
         A1JBkiW5/IUuMiIX4ZYji8n8pLWjOh5qqsoDoMe+Xs3GyzksCxEatKwzGD4E3J1TCJdZ
         a5nNBMTKevuC7mjmkveJ184uQvTaz4fbLDvEEN30tMGZbwm4erEuViGWaVbfzc08RX4Z
         iQ6U5IVX6Fjg5dWmPw1rLGpDizBXj8xy04Kr6JYB8HNm+OabvLpcKX88wGTTS2DDKtIS
         yzEgA7EGxFjTQaM3z2sMhSMcgWA9TgYnWYX2oION8UodnzI6qQk4OppDBVPxTdI1D+mw
         p/XQ==
X-Gm-Message-State: ACgBeo0fEzwA8ZLsKel3MoJaC9/nYsQwgvHf0AR7S+uYspGWvitkMEgh
        v2dsvN2et4KXXjVg9NGp+iHJnDag9BE0enaNw/4=
X-Google-Smtp-Source: AA6agR6SJcFGOPeHNpTXOJTMM+Xw4YyKLch0Jy65glm5EtFs0KwR0qKARwrTjxI1ZMWWuta6h3Fz3P1HYwtmdRzoY7o=
X-Received: by 2002:a92:ca0b:0:b0:2f1:da1d:c229 with SMTP id
 j11-20020a92ca0b000000b002f1da1dc229mr12079489ils.145.1663030646372; Mon, 12
 Sep 2022 17:57:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220912214510.929070-1-nhuck@google.com>
In-Reply-To: <20220912214510.929070-1-nhuck@google.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 13 Sep 2022 03:57:17 +0300
Message-ID: <CAHNKnsQFdd6uuqYfYcwLRY_RViOFWoT_mSK7v6sb02LeNvY5WQ@mail.gmail.com>
Subject: Re: [PATCH] net: wwan: t7xx: Fix return type of t7xx_ccmni_start_xmit
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@linux.intel.com>,
        Liu Haijun <haijun.liu@mediatek.com>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 13, 2022 at 12:45 AM Nathan Huckleberry <nhuck@google.com> wrote:
> The ndo_start_xmit field in net_device_ops is expected to be of type
> netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).
>
> The mismatched return type breaks forward edge kCFI since the underlying
> function definition does not match the function hook definition.
>
> The return type of t7xx_ccmni_start_xmit should be changed from int to
> netdev_tx_t.
>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1703
> Cc: llvm@lists.linux.dev
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>

Acked-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
