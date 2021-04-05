Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE3E354239
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 15:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbhDENCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 09:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhDENCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 09:02:21 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D64C061756
        for <netdev@vger.kernel.org>; Mon,  5 Apr 2021 06:02:13 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id k25so4966174iob.6
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 06:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=C/wEzvBut+12wjAyDnTHbSbbqL+Etwy+l5r7Xnp8jg4=;
        b=IG935/wZfB5k0eIoIT8KxRbuzQ1eFGt9nRwxqCtDtuLDxpGF2Krvvw2H43fstxAWBz
         pbeIBp8DuJknQ3hP2/andnxgMxYqg3o+IwZMYIn1iT/4l/p6+ansEynzr8UBhRYdi6FQ
         aNedcl1fsWEsWHXPJTbNO6ZZYSOy6vtGjI6uNqAeFpzZea8RaPSobbwkQE0cjQaQ22Ww
         vGKNFScL44ZcsgtfMF1YFv63UWxZ1AUfukCG6CbNmScCk4wRkDaFY73WSc7+DBsui003
         lwKs16pymoBhiDpLDszrJs5B2Sd2cwtZA5+nFoifzvRoQV66fV4+pcG9M5EerowRsmGt
         kHWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=C/wEzvBut+12wjAyDnTHbSbbqL+Etwy+l5r7Xnp8jg4=;
        b=kQBoTVTkUXBVhGuSbIE6kcW+rFGNzWCUwaYWwEQV4/SV3uFCAL538DiGufhWuncstW
         rgUV8f32WeKCvyOHZ3giy7IncWxISrANjZvDS021OkJvxkcxnMubfQXR4pQixtqWBvEo
         0+sHdgw/WsOAnLR8RD2eF66l/Uzfmyp9/Jlv8KQU36dQwbpccWr4pOj5U7435123ugoF
         PiS+SVyN7H4dRwNU/fFwY9k7WQJDzaiZ/PoXq3azKy4BkRfCUylLQwEVZMMCQqgyj8Qt
         OHT8QhkDwbMv9OVltZCQT0S/UNmW14eMnHC+/ySNbEyck1oim4j4QR6zw56fmjvwx5LK
         qATw==
X-Gm-Message-State: AOAM5324C//cLaLNrU2ZivethnZfL0iQfs6CNsOCo/iVnRdhZVU2U0u2
        8xn2TI9giQrftEASgQxlHiFAhAR3iugWkZ+cXRouVA==
X-Google-Smtp-Source: ABdhPJwbFihDHfDOM98UHeL1FyCMKiymnoTSDnjhFd2IQ9as4iPY055CByZ0j0KJY7EzLmRnQZQ8+rRpr8gtNEfohz8=
X-Received: by 2002:a02:7f0e:: with SMTP id r14mr23592305jac.112.1617627732127;
 Mon, 05 Apr 2021 06:02:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210405070652.2447152-1-zenczykowski@gmail.com>
In-Reply-To: <20210405070652.2447152-1-zenczykowski@gmail.com>
From:   Lorenzo Colitti <lorenzo@google.com>
Date:   Mon, 5 Apr 2021 22:01:59 +0900
Message-ID: <CAKD1Yr3NgUKE+eVmGQkFq1o4RoWpwfDuvmnbT+hh+UCRpuQs1w@mail.gmail.com>
Subject: Re: [PATCH] net-ipv6: bugfix - raw & sctp - switch to ipv6_can_nonlocal_bind()
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 5, 2021 at 4:07 PM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
> The helper is defined as:
>   static inline bool ipv6_can_nonlocal_bind(struct net *net, struct inet_=
sock *inet) {
>     return net->ipv6.sysctl.ip_nonlocal_bind || inet->freebind || inet->t=
ransparent;
>   }
> so this change only widens the accepted opt-outs and is thus a clean bugf=
ix.

Reviewed-By: Lorenzo Colitti <lorenzo@google.com>
