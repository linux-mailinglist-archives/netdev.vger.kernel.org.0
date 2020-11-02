Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5115F2A23BB
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 05:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbgKBEI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 23:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727461AbgKBEI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 23:08:28 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D711DC061A04
        for <netdev@vger.kernel.org>; Sun,  1 Nov 2020 20:08:26 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id n142so10600308ybf.7
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 20:08:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LwCqBfz/Y22tP+YuC1T++cKp6qmSNMH46Zmcr0s1r/M=;
        b=ADE/wXoyzbGZ6X+b3akmxd7gm0LDq07hdeXmVwDvYWH0e1WSiMVQdl2LonhvVl/ubu
         ozqHQTI00q6jtfyyOl66WjvYIN1jNJlXfhB1fEaygGtDW6iixVUuwzWknLDVEXiAxEpQ
         5K6imofDqrwyWaPNWcRDjYIMNwgrC5cCwQkxeJo+82ER4oJLWyDGLLuvSm7ADG8+IN6c
         uogsab963+EFOBj36DbMjmZDO2HFz+4Ys2JCy23L3W+Jbw5Hki0h25sxp0IFGuLjFzQq
         0SD2NJhtJgEjVOFceE9oCNNlBJcUogeqKm7iKmq2be1dooAOFzYYYm4f+qI8G7rb1qbT
         kmig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LwCqBfz/Y22tP+YuC1T++cKp6qmSNMH46Zmcr0s1r/M=;
        b=Ge4ob1i4iyXHHZh0kQFEQvPB+IUTrWeSrEfsOVyOpoti5pljPvEBWcrSo4xHjAQpIt
         PD9p/5GbSErMl1ALozhAsW4sZvG+OmDm/QixsWZFwklLqssah/U85/aMyZyugKjyec1V
         jGO7EXfp8HmI9qoGcFrYazFtzwdjwVA31TJXwkLt+OBXgb5+IUROGH17KZYz0N1QltwJ
         JhglJWHIUbgtf3HuqPWvWSLKHoxgWtuA0bPPJZZjGxZWw/XoQyH/AtJtWUY2E+iLfJR0
         HRQiQN22MHCOtq3joTTvk6sJkeXM+QRlbA7p96jcHbNYMZ9hEZEKTCtrKqLs64dqX/oF
         VBAA==
X-Gm-Message-State: AOAM531/jzOoa8GF8Wqd7vartVNrhwroMy/tQpIr/Z4ZKZbNW7dF0z3g
        pLSjGvrX5yM5ZBOeZ/QMlo5Ltwj0jUUX1WEOHWDAew==
X-Google-Smtp-Source: ABdhPJyPXcr1jTPB1wavZcXpiD6Okp5/6sZTctT9kOFYwx19KO65LtrSvPqJgI0LhghhZ2Vuzqi6foOBwNnfCHFY4jE=
X-Received: by 2002:a25:b8a:: with SMTP id 132mr18438278ybl.88.1604290105857;
 Sun, 01 Nov 2020 20:08:25 -0800 (PST)
MIME-Version: 1.0
References: <20201101220845.2391858-1-adelva@google.com> <20201102033848.GA1861@gondor.apana.org.au>
In-Reply-To: <20201102033848.GA1861@gondor.apana.org.au>
From:   Alistair Delva <adelva@google.com>
Date:   Sun, 1 Nov 2020 20:08:14 -0800
Message-ID: <CANDihLEjyuDD6aKVweoB4=CtUYCgiZqT8HHG1yY1VgUp74CPRQ@mail.gmail.com>
Subject: Re: [PATCH] xfrm/compat: Remove use of kmalloc_track_caller
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, kernel-team@android.com,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 1, 2020 at 7:39 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> On Sun, Nov 01, 2020 at 02:08:45PM -0800, Alistair Delva wrote:
> > The __kmalloc_track_caller symbol is not exported if SLUB/SLOB are
> > enabled instead of SLAB, which breaks the build on such configs when
> > CONFIG_XFRM_USER_COMPAT=m.
> >
> > ERROR: "__kmalloc_track_caller" [net/xfrm/xfrm_compat.ko] undefined!
>
> Is this with a recent kernel? Because they should be exported:
>
> commit fd7cb5753ef49964ea9db5121c3fc9a4ec21ed8e
> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> Date:   Mon Mar 23 15:49:00 2020 +0100
>
>     mm/sl[uo]b: export __kmalloc_track(_node)_caller

Whoops, you're right - I confused two allmodconfig issues when
backporting. Sorry for the noise.

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
