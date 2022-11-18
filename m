Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB7862ECEE
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 05:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240890AbiKREk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 23:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240496AbiKREkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 23:40:25 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DAEE97AAC
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 20:40:22 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-3938dc90ab0so19954057b3.4
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 20:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3Dr1Bit9E2xIsyjg35lmCOjqfBFsJ1wOMewib20+A9s=;
        b=S2m69yrwZynGvy8xNpigka4CC35Tdckv+IU7cZIjoPN/muy3Vk0cBC5wA0XMCBJ4sl
         IY3mgjEaTXF/Vk1pvaHePA7bFVIqAKsC/7M5c0wet6QSG03MTB/zprxTZqoKysZ1aOjy
         w7v5npbzpfrzy1ZaiQSFSKnVHdXrd+C5elFmmqxfjq7JnmMVAhFDZ09ySgVMXtM8nnPD
         CpyrXmRhbGHh0gDjdYFAh25WcEALsLUhwsTecG84NjHg9lu30VACF66fEiZT981A/dLl
         yRYp4dkopCCqwX2He7FLaZ64ZXW8KmN0O1eZ5i5kXsY0sTwjx7Hx7HNHnCS6p+9+wWPL
         aZEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3Dr1Bit9E2xIsyjg35lmCOjqfBFsJ1wOMewib20+A9s=;
        b=44j/Aum1y+MoXt2z8Hb8nvRTUTtwlhefKfcDG2YmRlNQFJFw2PIl/zF1zjAvt5aZ2h
         L30CoEeRzlsyjb8Kb0ihp6htjFKGdd8r9DeQQRi0aYRODZu1P6+ml76UONLUykGM76Rt
         cgYVtFvICCgqSRtn/SnKYWrMl3nZh5j4rNs8+d3Gxq/YikmmXxr6whO8PyFTNIm24ste
         c7nA4+fkBKJ5gEX3mybnHFPXx/ZwNKca4/8+/5awF1CLmBnwjJ5cxM2ZawRCxeqh81og
         91L7nO3cfDMOAzK6KotiRa8Vo9+Jqm/bp1Taf8JQd3sSsxbGKAfVbH4yv2AYxldAnq6r
         +UdA==
X-Gm-Message-State: ANoB5pmB/ZDU+WtMcB1kDk5hMGDV9Mr0Xt3/8ECiuvjYtL75+xBW2KqE
        lKguILhM3GJC9+2Z/DsRpTjpDpGyudccfHAfwySTag==
X-Google-Smtp-Source: AA0mqf446ZeH40Y49UBBftPkEOKX3UbeWSS1TwZfSCeFIZ5/4hKnGjwyW5mX4zidCRqlg92GBzKqZdjaq4oPJcl2jmw=
X-Received: by 2002:a81:5f04:0:b0:393:ab0b:5a31 with SMTP id
 t4-20020a815f04000000b00393ab0b5a31mr2980661ywb.55.1668746421116; Thu, 17 Nov
 2022 20:40:21 -0800 (PST)
MIME-Version: 1.0
References: <202211171422.7A7A7A9@keescook> <CANn89iLQcLNX+x_gJCMy5kD5GW3Xg8U4s0VGHtSuN8iegmhjxQ@mail.gmail.com>
 <202211171513.28D070E@keescook> <CANn89iKgMvhLbTi=SHn41R--rBQ8As=E52Hnecch6nOhXVYGrg@mail.gmail.com>
 <202211171624.963F44FCE@keescook> <CANn89iJ1ciQkv5nt5XgRXAXPVzEW6J=GdiUYvqrYgjUU440OtQ@mail.gmail.com>
 <202211171815.D076ED9C@keescook>
In-Reply-To: <202211171815.D076ED9C@keescook>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Nov 2022 20:40:09 -0800
Message-ID: <CANn89iK_uQzXx5ihDnbDCDmiJc3+2kLWTGTNC-+2PiiHfCHCjA@mail.gmail.com>
Subject: Re: Coverity: __sock_gen_cookie(): Error handling issues
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-next@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 6:16 PM Kees Cook <keescook@chromium.org> wrote:

>
> It looks like the existing code already works as intended, so no need to
> silence the warning. The comment and reload might be nice to add, just
> to clarify for anyone looking at it again in the future, though.


The current code in net-next is broken, because if we succeed to
change sk->sk_cookie,
we return 0 (instead of @new). So your report was not a false positive.

Thanks.
