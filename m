Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774094AA29F
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 22:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244478AbiBDVwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 16:52:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243006AbiBDVwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 16:52:10 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506A4C061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 13:52:10 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id g26so8198621ybj.7
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 13:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=81eiD2zntShrND8v4j/mYo2Sb0UkGl0y5Lj/9n9IFWo=;
        b=YgOjphKC/YmMVJ0/0MPoQj2x15EhBP3WebPNdBsKedS2R4z7jpsuHu/yF1rhQILJnd
         vKgEU7RihV74a52QQwtjZsWDbhfv4kCd+1lmoAh60D0UbBQwJJAs8Mo0AZHItwZemWt4
         u9Xu+AR5aZyjnXeonWEUykZcGcLYnRqtWTc8dZeoJYPlsv0qQq1tkWSrx8aSuv8C5wl8
         /lui3Hawrfrw9D8EqI9I+H/KH99z0S4VxSIjt94/T/sqUL03fYxHaFDm9OIno+hfm8ds
         jBgalg0IYElEtwnBtRurgh/50kiFx+7moyf85APmLOMyJtyhJYJiWeOQR5SfWyvC+RbQ
         wyCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=81eiD2zntShrND8v4j/mYo2Sb0UkGl0y5Lj/9n9IFWo=;
        b=V6x1Tu2j6KHaACSOlL6Kyo971TLrIGR/SghwnUSLxTtWWODFkfcaR+kw9ANkGJAxcL
         UawMSlj1lI/nHdvOX8rkII6KRL4iS9V9WzwDwWmBZBio4qq2iAvkJSGLc+Foj7xhbRLn
         yXj4G7ZT3x+wQmClvF5EQy+ZaXFc/Z7lPebGiGnLosu7HjnxXf/5d0ATzpusZXz1Vxcz
         8QI4misjwQSm73uyBUxoGxj4m0dj4Ejsf9+tdM415RLy9zgjQThSTPW6F7pLloe+Z81t
         SU5ljVHGbPNWcwEnS1+20wbn/4L7DHxguZCyL7IeWZmcehEtvqNzxcgZUK5BUdrb9vTY
         FXwQ==
X-Gm-Message-State: AOAM532kRhplmtTm7ZCq4hRX2d5dIhJi6/iKH41j31NfAB1HznVSZZIC
        h5mPBZ/wY3vOuiOhLuieWYLrBstUxeR6nlpvwrU8KSxKnDdQCUKx
X-Google-Smtp-Source: ABdhPJxCql3S3KKLsm5zLVITgbUmIw0LdnbLsn6us3iiblz0JteCUWCK/KjCI7+lGMYmw/0I97w1adWm20mcuLWqBwg=
X-Received: by 2002:a81:1704:: with SMTP id 4mr1075321ywx.32.1644011529169;
 Fri, 04 Feb 2022 13:52:09 -0800 (PST)
MIME-Version: 1.0
References: <20220204183630.2376998-1-eric.dumazet@gmail.com>
In-Reply-To: <20220204183630.2376998-1-eric.dumazet@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 4 Feb 2022 13:51:58 -0800
Message-ID: <CANn89iKp2jY-Yr1PX_Ug+6izpYjYzZPBNaYN63T16Wz=3AJ16Q@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] net: device tracking improvements
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 4, 2022 at 10:36 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Main goal of this series is to be able to detect the following case
> which apparently is still haunting us.
>
> dev_hold_track(dev, tracker_1, GFP_ATOMIC);
>     dev_hold(dev);
>     dev_put(dev);
>     dev_put(dev);              // Should complain loudly here.
> dev_put_track(dev, tracker_1); // instead of here (as before this series)


Please do not merge.

I have missed some warnings in my tests, it seems I need to refine
things a bit more.
