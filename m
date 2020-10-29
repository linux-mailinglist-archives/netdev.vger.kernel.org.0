Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B627429F490
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 20:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbgJ2TKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 15:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgJ2TKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 15:10:46 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0CCC0613D4
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 12:10:45 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id q1so4157001ilt.6
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 12:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/plCwIYTT4styzRPc67wMisz3tStYJJ6vRoHap8BJ0Y=;
        b=hzNQJbNZu2j8IGu5VLcLa4foUKAzc2fV/j1FxDcQGlhRGFRkalAKyVXRo9/1WWdjFU
         l/UaKidDjG7EoFK/P4BHY9DcRGErZY1WSjR1gbxhGwAH5FE3atRh87hX9VMcwv0Xz3xs
         /BD9Fuj5pVS1JgMQzZarlwX20sfsEMy5FJVsmhsUg4Py3Qz8Zw+MeF0212EZQeBndYeh
         +leQ/6UGTdlXUwYhPJS9LnEGCLclep6pfQymwUu54hSOwmqVbiIReLTsHlKlsezc/pKc
         WtLKm/ss4bNaL9uVBoYJR8XsCWRtFaEl18wy+7S5394k4yAP66P82dGYj8XXaF4Ao2Mv
         IfZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/plCwIYTT4styzRPc67wMisz3tStYJJ6vRoHap8BJ0Y=;
        b=DO25t9ytJ5OjBy5VHui7WTwbMj9HjkeoKGsJAMYYhpjsm+CTEwlTVJIHX9+byU4b5w
         Lzr9niw4GlpvzlyWG9XPyHUT+KZ0vTdT7Nk3IyMLnXKJI5A58VHTD/UIl1ff70Hc7Py4
         BISy+xJPjHRzUYKsr604vzi7sD0YSIjA5EpsWSFjBodftngLhDAAYMouYBIVfzdhREKH
         so2aCzXSK/a9ds/a7v7ZPORj1yGdFDN5h/2rVQcKxNaSKK9NCSPZbXdIXQeSXOiGvHFr
         u7ZkAH9gJ02gyAMjylk3avNmP0BkIVXEjPriNW7NB9KopDBpsENwZrrPYzJ41AUuoovx
         UAnQ==
X-Gm-Message-State: AOAM532CIy3pGJ2Dtf+VDt7HH9tyGgH7AFm8GMrzHIku5ZmXVhzAT8pc
        xbkAAfXBYw6lppEm0Z1rgdKcMSsLCA4wf5zJ/J0=
X-Google-Smtp-Source: ABdhPJwqbQ4WgbD1sUtDxAn5U83PixMqJ0u58jbIg6t9a10K+lMYoIxG1jtShjzr2oePS4bUR0LHEpFySjKI8B6/Sjk=
X-Received: by 2002:a92:28d:: with SMTP id 135mr4607456ilc.238.1603998645177;
 Thu, 29 Oct 2020 12:10:45 -0700 (PDT)
MIME-Version: 1.0
References: <9bede0ef7e66729034988f2d01681ca88a5c52d6.camel@infinera.com>
 <e09b367a58a0499f3bb0394596a9f87cc20eb5de.camel@infinera.com>
 <777947a9-1a05-c51b-81fc-4338aca3af26@gmail.com> <97730e024e7279d67f3eca7e0ef24395e9e08bff.camel@infinera.com>
In-Reply-To: <97730e024e7279d67f3eca7e0ef24395e9e08bff.camel@infinera.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 29 Oct 2020 12:10:33 -0700
Message-ID: <CAM_iQpX8=wege1toTsWpKHFMVAzM90HLQ51nzsn0LrDW=CEhiA@mail.gmail.com>
Subject: Re: arping stuck with ENOBUFS in 4.19.150
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 7:11 AM Joakim Tjernlund
<Joakim.Tjernlund@infinera.com> wrote:
>
> OK, bisecting (was a bit of a bother since we merge upstream releases into our tree, is there a way to just bisect that?)
>
> Result was commit "net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc"  (749cc0b0c7f3dcdfe5842f998c0274e54987384f)
>
> Reverting that commit on top of our tree made it work again. How to fix?

This is odd. The above commit touches the netdev reset path, did
your netdev get reset when you ran arping? You said your eth1 is UP,
is it always UP or flapping?

In the other thread, a bisect also points to the same commit on 5.4.
I guess there might be something missing in the backport.

Thanks.
