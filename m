Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A40361A2D9
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 22:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiKDVCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 17:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiKDVCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 17:02:16 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F259DCE16;
        Fri,  4 Nov 2022 14:02:14 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ud5so16409545ejc.4;
        Fri, 04 Nov 2022 14:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jMMCwFfTxUtBQaCUbLmnNnqsjOA3xWkr6/3sJqrERGE=;
        b=P0qso1SEWqyR6Gb/nY5BSJ5jDixsr08PQv31Qucdbq51IRLqUX7wLc8RsJN2mGxBfZ
         rZvuOqnZK3fJ0GFh7IijoDG+c568ip+/ip56V9CiXP497W/lABw0VsaLfZLIEaJ9IoYK
         Erf+d4amFAsK9ft91+UiiXDLb1AtKP+1f9W/nnE9/vfzjsieltv+vT2TpmbkPp+pYBC8
         u+tJw0ikR3QGU5uYTxfHep2MxV3OZI2yQ+pXE1y6E0TdFBd7WYfkQ7F8nJEIqqMEnA/Y
         N7s4iv619vMEMKXvVIgvf/5XqgE7SReg9IBgmUoE2e0ZikHA9ooosrmTYQYORPQoKWu1
         Z9Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jMMCwFfTxUtBQaCUbLmnNnqsjOA3xWkr6/3sJqrERGE=;
        b=re4F2ijZ/RMiqj/6CaDuFdiuTCIZSG3HVNw/H6FN5HEr8Yof7PuOpH4gJl0kmta7v0
         45uwOYmhvjONZNEtKKFGZngeEOD7bvRzs5EzvtJ9jcwng5Xeykq5UUu771oAS4c1Pp81
         cVZ++ZeUGW+AXZQttxEf00jU7NnPoGjY0huERaQd2BQAWGST57w4SPPxJz/F0XvTIkfk
         T00RU+6C6hVFBysWmVov5OkWPuRrPHm9V2GiAdaWjL2crSEQm93Yb7xPGv69PyD9zXw4
         h2jna/IJvqxMvQ9dwUJ9YjI20V7hh4c2iFfcENZODDbr8mVugepHSY9fdt5j3lGcMM0D
         Z9Dw==
X-Gm-Message-State: ACrzQf2XpBrud7fZ+u0b+Q603SnSKt+HlRP+Hh+hA02vFZU2ioPiLJh/
        UQbSkRJfPH0QL7+gRdOpqAraRmmR+LYdAESrvJo=
X-Google-Smtp-Source: AMsMyM7UMjB3EEzyFqfqDtbdIdwBVEJYEZVr4B6LZIVGlg8vWCazEPAAPdxKEklEGQUlTMWPjbPDoZAfyge/cDQ2PxE=
X-Received: by 2002:a17:906:cc4e:b0:7ae:3f78:c8b8 with SMTP id
 mm14-20020a170906cc4e00b007ae3f78c8b8mr3186651ejb.394.1667595733317; Fri, 04
 Nov 2022 14:02:13 -0700 (PDT)
MIME-Version: 1.0
References: <20221104083004.2212520-1-linux@rasmusvillemoes.dk>
In-Reply-To: <20221104083004.2212520-1-linux@rasmusvillemoes.dk>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Fri, 4 Nov 2022 22:02:02 +0100
Message-ID: <CAFBinCBiTgV5uC2Dq3Lowj5WXFk7U0XuY07717oAMGc+jH15hg@mail.gmail.com>
Subject: Re: [PATCH] net: stmmac: dwmac-meson8b: fix meson8b_devm_clk_prepare_enable()
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Rasmus,

Thanks for your patch!
It would be great if you could Cc linux-amlogic@lists.infradead.org in
v2 of this patch, so other Amlogic SoC maintainers can also provide
their feedback.

On Fri, Nov 4, 2022 at 9:30 AM Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
>
> There are two problems with meson8b_devm_clk_prepare_enable(),
> introduced in a54dc4a49045 (net: stmmac: dwmac-meson8b: Make the clock
> enabling code re-usable):
>
> - It doesn't pass the clk argument, but instead always the
>   rgmii_tx_clk of the device.
Indeed, this is a problem - thanks for fixing this!

> - It silently ignores the return value of devm_add_action_or_reset().
This second part is not so easy.
The thought process back when this code was implemented was: let's
continue loading of the driver even if devm_add_action_or_reset()
fails as this just means during shutdown/rmmod we don't disable all
clocks.
If we want to propagate the error code returned by
devm_add_action_or_reset() then we also need to do the clean up within
meson8b_devm_clk_prepare_enable(), meaning we need to call
clk_disable_unprepare() in case devm_add_action_or_reset() failed.
Your change just propagates the error code without disabling and
unpreparing the clock.

[...]
> The latter means the callers could
> end up with the clock not actually prepared/enabled.
In my opinion this statement is not correct: even if
devm_add_action_or_reset() fails the clock will be prepared and
enabled (by clk_prepare_enable() right before).

Personally I would just change the clk argument and keep the return 0.
What do you think?


Best regards,
Martin
