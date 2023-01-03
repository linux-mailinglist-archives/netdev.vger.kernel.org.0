Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4A765C2FE
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 16:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbjACPaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 10:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbjACPaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 10:30:22 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BD310551
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 07:30:21 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id c124so33405480ybb.13
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 07:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YVqQnvRHkEImnayON2eQOiyFzcFBvBFrh3Hs1BKyiU4=;
        b=G0JO7XqYYPKHHjKysZbcpH2Gfh36Q/j66T1rMBi3z4Hvd/8DOFb/cdE2KZQusgrEvF
         MFe8sRngPLu66zUW7QhonYf6ZUxTjIuwYeQJG/UsZh0x/nSHmHR/LslXyqPPJMc6gSME
         esR4+Jm+DWWVlTu1lzRrAlI6HS7QW7yNz7s1iclLGXZXz37WGs9nk5NZUa4iuTJlpchI
         0nPY47NQtqVL/780B7glg6iwdH5YWYQiMy25aYW27OTobEPLiE7F5dj9kTGvl9oWARkL
         LQM2xByUknkzfaffUSG68jB18e3WF7hzl/wueawEKfCFQ7Em0vLO4CobKVWpPIbvUim7
         nCag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YVqQnvRHkEImnayON2eQOiyFzcFBvBFrh3Hs1BKyiU4=;
        b=ycgf5Pd92D8F3dFO9ORBmTrzGhFVcVInCrmoVH7ACGyMdLCHy67k50qJvoUUnFo9k7
         1rQWPTfKFcPFFvnPw+dsb6kdlVCjt1IYoDeBlS2nofWz+ezlHLc++EXH7Okkml4Yq8zb
         zYDQDL36G+4iTLQuq7CfOKuFIo7POew0JahIyAKI5yUkdEONW9cms3LmiZDPDWuu7Dvu
         AW2m4VCJod+ZGKKYjFYFS3jdLRHRmcXpgI+sk/rNBNGL0/EfkRe+9ZuEq6vgekYzOelg
         xGkQnkfI2L3AGNNOQ+iHtfLuYGA7dfwfcgrMAIu5y3i/L0Wxcg5d0cDxyJxqOI8Ssi/J
         l9/A==
X-Gm-Message-State: AFqh2kr1NIfV88arkHpkTGzJJf/9JJDeO6h7OgbwZLOdl0TSJm6+yPfW
        K5Kg7Ga/kzDweCCBMfbDjH8nz3oo1eK28FZbJIXAsA==
X-Google-Smtp-Source: AMrXdXt7b9gzIZIhZcReQwd4FrHqGi7VdF9KjZE6HuN4fhiImOImDvq3IQL68IEgoGTcBzNwP6RHM4FN3JUn9Pl596Y=
X-Received: by 2002:a25:4903:0:b0:770:d766:b5e8 with SMTP id
 w3-20020a254903000000b00770d766b5e8mr2568518yba.24.1672759820484; Tue, 03 Jan
 2023 07:30:20 -0800 (PST)
MIME-Version: 1.0
References: <C1ECCD2D-1961-47C8-BBBB-97152A209A57@hxcore.ol>
In-Reply-To: <C1ECCD2D-1961-47C8-BBBB-97152A209A57@hxcore.ol>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 3 Jan 2023 16:30:08 +0100
Message-ID: <CACRpkdakozbuQ6zaZqM7Lv7uZaw-zsU1=8cR9_KiZiYAYdtOow@mail.gmail.com>
Subject: Re: [PATCH net-next 0/6] IXP46x PTP Timer clean-up and DT
To:     Bryce <oliverwearzprada@gmail.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kaloz@openwrt.org" <kaloz@openwrt.org>,
        "khalasa@piap.pl" <khalasa@piap.pl>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 3, 2023 at 3:53 PM Bryce <oliverwearzprada@gmail.com> wrote:

> git send-email \
>     --in-reply-to=20210802090529.52bdbf4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com \
>     --to=kuba@kernel.org \
>     --cc=davem@davemloft.net \
>     --cc=kaloz@openwrt.org \
>     --cc=khalasa@piap.pl \
>     --cc=linus.walleij@linaro.org \
>     --cc=netdev@vger.kernel.org \
>     /path/to/YOUR_REPLY

Yeah that is how I do it too :D

I'm curious to see if you're using PTP with IXP4xx!

Yours,
Linus Walleij
