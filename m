Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A1528B988
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 16:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390778AbgJLOB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 10:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731201AbgJLNia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 09:38:30 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EC6C0613D2
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 06:38:30 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id s15so9152949vsm.0
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 06:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qoV1BfVdJZsinq1maVaibHxEqbflhmKT48S5ZU728Qg=;
        b=tcYUB4C2mYNzgj9n3WDo4iGUsBORwa7h6zIm0OOVB4fwMOctooJ9mJqC8BtdPyFwOm
         xBWnw3tvq0FoOgptFSalZkv5U92OpM5O1sddNa/grvI9ICtJl9jzpCkZo7D8d2Wkeb9U
         KtU3NR/FMBMDN76/2JaIv+BZyYzsexaodydLqhkVrex9df59GtlGi7KtaFO7ut7bg2g4
         E68NhztWMBhL37VLiOtiqa2aIRZJxAaPL3RKBDBaHWZTUL/fHjZXMqmuUgiKByQTjHi0
         PuBS/tSEvM0NvyYkMON6TObgoVPU2KTKzljetrJob90XRyZ5a99yBbdPnn1y7a1cBrfA
         71DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qoV1BfVdJZsinq1maVaibHxEqbflhmKT48S5ZU728Qg=;
        b=G5C5kcEnDRqdovKgDwASY0n28E34aNkUKs/9YWjOOJy+6SVbXjn/yupNYEg/liS/pK
         PiYTpd1hoaGpXWsEq0qAh/RRiK+6qt8xSMf05YkIPjv2wK31QGLWoa1IhixmzQiY6RY4
         EPQyEp+/hRT2VTvXMsK18dNXMDOv+A2hHlqLGiTDBnNt4RVTX5Acsw5hchamsdmzosD5
         dM/qe0RinCgmjRR5+81FXlS7O+wp1Baut1fk2hZUge95+EH5VBPPwI6aQjmruc6Fr6pj
         rU6skRxP2ttBFnbilkWZAxiiWCIlc1YFg04ttZPoDamqmudBd7jP+Js4BRKXAbrSEmAX
         +6Bw==
X-Gm-Message-State: AOAM531TxMeIKqIvI6BiGHmqY3on38E39wvQ1b16spDzfKGL5qKcvr9u
        I90PhmbZXHKBdekhsjQj0D/UfBlpJWI=
X-Google-Smtp-Source: ABdhPJycBRKqbPGTtEKas6cGMVu0qCIUHBS1EEmiXwFImEHNlKOTOv6zCkxYEwCdhSjyInNqYcq89A==
X-Received: by 2002:a67:de18:: with SMTP id q24mr318367vsk.54.1602509908343;
        Mon, 12 Oct 2020 06:38:28 -0700 (PDT)
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com. [209.85.221.171])
        by smtp.gmail.com with ESMTPSA id v18sm2320642vkn.20.2020.10.12.06.38.26
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 06:38:27 -0700 (PDT)
Received: by mail-vk1-f171.google.com with SMTP id n189so829047vkb.3
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 06:38:26 -0700 (PDT)
X-Received: by 2002:a1f:6dc2:: with SMTP id i185mr13578365vkc.3.1602509906266;
 Mon, 12 Oct 2020 06:38:26 -0700 (PDT)
MIME-Version: 1.0
References: <20201012093542.15504-1-ceggers@arri.de>
In-Reply-To: <20201012093542.15504-1-ceggers@arri.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 12 Oct 2020 09:37:49 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfkBHtKqjppMmqudj9GwZBidSqvOP6WCzoxLGihqiz5Qw@mail.gmail.com>
Message-ID: <CA+FuTSfkBHtKqjppMmqudj9GwZBidSqvOP6WCzoxLGihqiz5Qw@mail.gmail.com>
Subject: Re: [PATCH net v2 1/2] socket: fix option SO_TIMESTAMPING_NEW
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

On Mon, Oct 12, 2020 at 5:36 AM Christian Eggers <ceggers@arri.de> wrote:
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
> Reviewed-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Reviewed-by: Deepa Dinamani <deepa.kernel@gmail.com>

We have not yet reviewed this second patch. Please do not add such
tags on behalf of other people.

That said, I now have and do agree with the change, so

Acked-by: Willem de Bruijn <willemb@google.com>

> ---
> v2:
> -----
> - integrated proposal from Willem de Bruijn
> - added Reviewed-by: from Willem and Deepa
>
>
> On Saturday, 10 October 2020, 02:23:10 CEST, Willem de Bruijn wrote:
> > This suggested fix still sets and clears the flag if calling
> > SO_TIMESTAMPING_NEW to disable timestamping.
> where is it cleared?
>
> > Instead, how about
> >
> >         case SO_TIMESTAMPING_NEW:
> > -               sock_set_flag(sk, SOCK_TSTAMP_NEW);
> >                 fallthrough;
> >         case SO_TIMESTAMPING_OLD:
> > [..]
> > +               sock_valbool_flag(sk, SOCK_TSTAMP_NEW,
> > +                                 optname == SO_TIMESTAMPING_NEW);
> > +
> using you version looks clearer
>
> >                 if (val & SOF_TIMESTAMPING_OPT_ID &&
> >
> I would like to keep this below the "ret = -FOO; break" statements. IMHO the
> setsockopt() call should either completely fail or succeed.

Agreed.


>  net/core/sock.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 34a8d12e38d7..669cf9b8bb44 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -994,8 +994,6 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
>                 __sock_set_timestamps(sk, valbool, true, true);
>                 break;
>         case SO_TIMESTAMPING_NEW:
> -               sock_set_flag(sk, SOCK_TSTAMP_NEW);
> -               fallthrough;
>         case SO_TIMESTAMPING_OLD:
>                 if (val & ~SOF_TIMESTAMPING_MASK) {
>                         ret = -EINVAL;
> @@ -1024,16 +1022,14 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
>                 }
>
>                 sk->sk_tsflags = val;
> +               sock_valbool_flag(sk, SOCK_TSTAMP_NEW, optname == SO_TIMESTAMPING_NEW);
> +
>                 if (val & SOF_TIMESTAMPING_RX_SOFTWARE)
>                         sock_enable_timestamp(sk,
>                                               SOCK_TIMESTAMPING_RX_SOFTWARE);
> -               else {
> -                       if (optname == SO_TIMESTAMPING_NEW)
> -                               sock_reset_flag(sk, SOCK_TSTAMP_NEW);
> -
> +               else
>                         sock_disable_timestamp(sk,
>                                                (1UL << SOCK_TIMESTAMPING_RX_SOFTWARE));
> -               }
>                 break;
>
>         case SO_RCVLOWAT:
> --
> Christian Eggers
> Embedded software developer
>
> Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
> Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
> Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
> Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
> Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler
>
