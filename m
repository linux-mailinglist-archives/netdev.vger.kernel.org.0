Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5051D289CB3
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 02:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbgJJAYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 20:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728822AbgJJAXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 20:23:51 -0400
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36596C0613D5
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 17:23:51 -0700 (PDT)
Received: by mail-vk1-xa43.google.com with SMTP id a16so2539175vke.3
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 17:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=avBDTcm5gU0Af/+YPoKt2EvMb/tJEqNyS5fFLJ2/b0M=;
        b=Y/NhiiS+Zfn8VRdPyWWuSGBztlV2QZZ8b9SZ3Ndlma9YNNzdn6p4llK/RR1GQxHmzF
         1ZAiZl0NoZM/5+yZH4GDCMKNENX9/IqoSNEaohoXAizPxcESjgrZt6V92ekyuS72gR8d
         skP7cwBRzmU50ynTIlkWM9RiGssU0QSmV/wX/6Q64pLtFtn8R10Mz4O2zDGUhR3JOWBh
         33fbh1kzK5MPp/G68q3m+OHVoRkanTMMus0iU0oEBGzeBcPVaco871cSFPf1m62pIEpS
         1Huk2Whx1qDY7piCBqsG8qmOnkfPcbHnLXKexkTYQZos6o1WiwjAWhZdw9Sfv5WpWoid
         h+7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=avBDTcm5gU0Af/+YPoKt2EvMb/tJEqNyS5fFLJ2/b0M=;
        b=l9JMSSDQ0Pz7jdnmE038MpBWVjMYz8Nh6eE7aGrVWalwVrTk3/dghy7eBo7OxL6+5L
         0qpOVhUAtWp6tyW4iCJhND18SsfXIsK0kLuCQpsjm6cvbSuZVA96Q46NuwVkESLnv7KK
         Fw/GIuAtUUNuuOlg7NgGzR+xgAKczqjIfDqN54zDgPwNqcsYDeZACbaCjm10i7HIPDfZ
         MRRFrJTp3X5ZtmEjiy5X54NFDMQh9V8aUa6Oh8pNO/+gR85wViQ5zjeEioMYFw5MZ+83
         CkDWVwVj8b+dC/AxwGZXVxrBN2k/95Ga6yuEkZ7LnelteKO8FyWDXn5KILwneSPE/BOK
         l3uA==
X-Gm-Message-State: AOAM532uKOaI2D8vzP28o4BN4m1CMpldLhPm+0tqUMZmqIY+xlM4p5GV
        tLM8QkIyiJt96ce9yocRJLGAclzZOnE=
X-Google-Smtp-Source: ABdhPJwmHVrXboGAtmc2c7nszwqDGqZcuhURNyDelQsEkxtYtoZnFJ4d/op5v0zuyHQZtxlxANMvTQ==
X-Received: by 2002:a1f:9404:: with SMTP id w4mr9389077vkd.2.1602289429541;
        Fri, 09 Oct 2020 17:23:49 -0700 (PDT)
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com. [209.85.222.47])
        by smtp.gmail.com with ESMTPSA id r22sm1396533vke.5.2020.10.09.17.23.47
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 17:23:48 -0700 (PDT)
Received: by mail-ua1-f47.google.com with SMTP id j21so3648323uak.5
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 17:23:47 -0700 (PDT)
X-Received: by 2002:ab0:7718:: with SMTP id z24mr9365648uaq.92.1602289427332;
 Fri, 09 Oct 2020 17:23:47 -0700 (PDT)
MIME-Version: 1.0
References: <20201009103121.1004-1-ceggers@arri.de>
In-Reply-To: <20201009103121.1004-1-ceggers@arri.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 9 Oct 2020 20:23:10 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfkHkyBarmp-wi-zo-04fPWAOu_6fxwGPVAo7S5xP6c8w@mail.gmail.com>
Message-ID: <CA+FuTSfkHkyBarmp-wi-zo-04fPWAOu_6fxwGPVAo7S5xP6c8w@mail.gmail.com>
Subject: Re: [PATCH net 1/2] socket: fix option SO_TIMESTAMPING_NEW
To:     Christian Eggers <ceggers@arri.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 6:32 AM Christian Eggers <ceggers@arri.de> wrote:
>
> The comparison of optname with SO_TIMESTAMPING_NEW is wrong way around,
> so SOCK_TSTAMP_NEW will first be set and than reset again. Additionally
> move it out of the test for SOF_TIMESTAMPING_RX_SOFTWARE as this seems
> unrelated.
>
> This problem happens on 32 bit platforms were the libc has already
> switched to struct timespec64 (from SO_TIMExxx_OLD to SO_TIMExxx_NEW
> socket options). ptp4l complains with "missing timestamp on transmitted
> peer delay request" because the wrong format is received (and
> discarded).
>
> Fixes: 9718475e6908 ("socket: Add SO_TIMESTAMPING_NEW")
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---
>  net/core/sock.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 34a8d12e38d7..3926804702c1 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1024,16 +1024,15 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
>                 }
>
>                 sk->sk_tsflags = val;
> +               if (optname != SO_TIMESTAMPING_NEW)
> +                       sock_reset_flag(sk, SOCK_TSTAMP_NEW);
> +
>                 if (val & SOF_TIMESTAMPING_RX_SOFTWARE)
>                         sock_enable_timestamp(sk,
>                                               SOCK_TIMESTAMPING_RX_SOFTWARE);
> -               else {
> -                       if (optname == SO_TIMESTAMPING_NEW)
> -                               sock_reset_flag(sk, SOCK_TSTAMP_NEW);
> -

The idea is to select new vs old behavior depending on which of the
two setsockopts is called.

This suggested fix still sets and clears the flag if calling
SO_TIMESTAMPING_NEW to disable timestamping. Instead, how about

        case SO_TIMESTAMPING_NEW:
-               sock_set_flag(sk, SOCK_TSTAMP_NEW);
                fallthrough;
        case SO_TIMESTAMPING_OLD:
[..]
+               sock_valbool_flag(sk, SOCK_TSTAMP_NEW,
+                                 optname == SO_TIMESTAMPING_NEW);
+
                if (val & SOF_TIMESTAMPING_OPT_ID &&

That is a subtle behavioral change, because it now leaves
SOCK_TSTAMP_NEW set also when timestamping is turned off. But this is
harmless, as in that case the versioning does not matter. A more
pedantic version would be

+               sock_valbool_flag(sk, SOCK_TSTAMP_NEW,
+                                 optname == SO_TIMESTAMPING_NEW &&
+                                 val & SOF_TIMESTAMPING_TX_RECORD_MASK);
