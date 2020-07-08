Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4ED217E91
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 06:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbgGHEvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 00:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgGHEvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 00:51:16 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB3AC061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 21:51:15 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id g6so1719559ybo.11
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 21:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/NEBnfjrAWHAq4ehCeb+vuRXUMH/QW/Cfmqsnvz+s4E=;
        b=gDhbTd+51Mpfk63X4f+GdNUVMxstI1LEUFrBpBFmGS97f5XmiV52pyM+ObLfBe56hY
         a7f5PgCdarmFbeu95+mjRGewucSeedQdnGymFk7+zb/RyC9pb3YCXgCtaItW/H70wFCx
         kp+uaWmeHN9tDcf9M5aJa8HUo+YOpFl1HRLFFLYCi2XTQfcYXqO9Uj7TlcUxbaJLUJfY
         g/hMoC+3pKL+cgNSuC/6SuOSFTssFjG0433Q55kLFC1S0ijd9Zj7Zn3Nx55XbvCm7VL/
         gJS/tngOX0CpcBGdDIc9aWN/DWLqjfVckBvsUWsX1Ll5ulAcyj5YR0g5jlXbG1Y73WbF
         09dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/NEBnfjrAWHAq4ehCeb+vuRXUMH/QW/Cfmqsnvz+s4E=;
        b=WJkklplbBv7uZ+q1LP12FR42z0h37GH4xOoRf7bSyFyAHqF9CIaS7huTgWu4xp82y/
         v1SpMvQFdCT8vvIO6SSeLgQWbOymHaWFMbCXy4jRie+Ot+CUtIqM46pCM2cWGpF5jbYc
         dPuTt9P0lWjCozGBmYqyLLmOFbOx20QLR6KIIDvE62rKKMl+dvl1TH9Lb0ZkTzexZT8p
         mcvQPotsREc1wc4RvCp/mapxpQ4hLoAtn3ZsMtL698GzSHIfaV+y/hckVHe/xcla8OSP
         JK+hMvufUIpyyRkrp5cG7RMq2o1osxYEoK22OZHKxaCiPxQt10rzTszJjCOeMXWBvJRy
         FSmQ==
X-Gm-Message-State: AOAM5300B48aL/YC5cF52M4VWt5F4t7L373awcJgzdjEZmjPrHyoZz19
        G6/2aNvlk0VsKFY5KHDJznFIlMPeTSDokz2bpoQZUQ==
X-Google-Smtp-Source: ABdhPJy58v+nLtkWVD5uJj4WAAmQ9sVEnzaUSBvg8P2773leMf92UmjGN7zq0vod4P53J4b9JhIhAxahIMFvpP8V1Wg=
X-Received: by 2002:a25:a121:: with SMTP id z30mr387607ybh.408.1594183875001;
 Tue, 07 Jul 2020 21:51:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200708041030.24375-1-cpaasch@apple.com> <CANn89iLZ1kDbpm81ftXkrtKBNx-NVHSYzP++_Jd0-xwy2J2Mpg@mail.gmail.com>
In-Reply-To: <CANn89iLZ1kDbpm81ftXkrtKBNx-NVHSYzP++_Jd0-xwy2J2Mpg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 7 Jul 2020 21:51:03 -0700
Message-ID: <CANn89i+mTjmvyd-=q=_tw7eYe6xAbto70YjsUrvn7TMT86qAdw@mail.gmail.com>
Subject: Re: [PATCH net] tcp: Initialize ca_priv when inheriting from listener
To:     Christoph Paasch <cpaasch@apple.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 9:43 PM Eric Dumazet <edumazet@google.com> wrote:
>

> Could this be done instead in tcp_disconnect() ?
>

Note this might need to extend one of the change done in commit 4d4d3d1e8807d6
("[TCP]: Congestion control initialization.")

diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index 3172e31987be4232af90e7b204742c5bb09ef6ca..62878cf26d9cc5c0ae44d5ecdadd0b7a5acf5365
100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -197,7 +197,7 @@ static void tcp_reinit_congestion_control(struct sock *sk,
        icsk->icsk_ca_setsockopt = 1;
        memset(icsk->icsk_ca_priv, 0, sizeof(icsk->icsk_ca_priv));

-       if (sk->sk_state != TCP_CLOSE)
+       if (!((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
                tcp_init_congestion_control(sk);
 }
