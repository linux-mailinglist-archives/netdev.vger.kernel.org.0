Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 377521DBB0D
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 19:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgETRTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 13:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgETRTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 13:19:36 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF942C061A0E;
        Wed, 20 May 2020 10:19:35 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id w64so3703969wmg.4;
        Wed, 20 May 2020 10:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=y8yUyVm1iQo/mod3v/ZorgdMr0NOkedItsaMzyWnI3k=;
        b=i+sEwVLCyBecdxxNGXrvdzLG4bFDyxadl2RsVH2OklScUeAFcJ9HmNEdo6usZqYSIy
         OkaJGdMvq5MGmNBCLM0I892EhrkWR0r8Kxht1UfRb9OvZISLphzQuvaYumVsGiPcbqBm
         Gko9HPAXaxEGlmID966izg0FhQP+H0i6UlLxnjlak/SrJAmpHHVCI5qTLon1Fc979Auy
         iuGWPuTyx04O+in+Y4Q5MqoqCS+YCMh8m+ublZtIdGJkN1vPnExkbAU72JA62MDvIezw
         Pz5GcZ6oYsSVF+gtV6TpuVYtqBT3no0m/zRGod5s+h8QUzQeSaKAPohpL/Y8YbnPy90U
         ndEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=y8yUyVm1iQo/mod3v/ZorgdMr0NOkedItsaMzyWnI3k=;
        b=ZEb7Ek3qFktgO1FMpjRMqyqkE+heAC54t35DNPqmPpnyyPaNwN839Xl2qqiy/nkNUU
         5Y6XpXOlfWcTn8RdWHRvye9S4qLI3jEIYpB5q9FQq0vp8SmuvqvCWMWlWtzGbeqgE9XT
         C7kutdOow1p33VcL1a5jh1EtVaF+FM5zbtfARzNytq37kNkEKiFXaW/50m2Ma7ZTFRug
         PGhUFPvfOIG0fGAlXQ/6Vu0Nl2scNdn59AoI2W+9Z+NT+TRwdSSmHC44Zhc0nX9nu10e
         fwXpDVIJq8Qta9/QHpihCpxPmzkuuAtAe8qnJeWY30mvdvF2kpHTr0CtqpE/z1ePzA3F
         iueQ==
X-Gm-Message-State: AOAM533l3nwDyu4iJLzE0JPqsOx00wHx3P0jgkAiNEDuJ0xdDDyNNiLn
        cj9Qetz7hhoU4wmtg4qeU5YFxB48pqTIU0rdo+E=
X-Google-Smtp-Source: ABdhPJyHqLx5nZUFccD6mBIJZ0Sj6jqebi2SOcGJxSylM31RSSLDJaUMgq5UtSHHT/NBLm7NS0684QV+bsyGj9eIhLY=
X-Received: by 2002:a1c:3281:: with SMTP id y123mr5449288wmy.30.1589995174436;
 Wed, 20 May 2020 10:19:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200520094742.337678-1-bjorn.topel@gmail.com>
 <20200520094742.337678-8-bjorn.topel@gmail.com> <20200520100218.56e4ee2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200520100218.56e4ee2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 20 May 2020 19:19:22 +0200
Message-ID: <CAJ+HfNgE5TTFfGa-XNS7_=ukcNJ=jMUoBLmmA_c=iVY3C_DXZA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 07/15] i40e: separate kernel allocated rx_bi
 rings from AF_XDP rings
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 at 19:02, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 20 May 2020 11:47:34 +0200 Bj=C3=B6rn T=C3=B6pel wrote:
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > Continuing the path to support MEM_TYPE_XSK_BUFF_POOL, the AF_XDP
> > zero-copy/sk_buff rx_bi rings are now separate. Functions to properly
> > allocate the different rings are added as well.
> >
> > v3->v4: Made i40e_fd_handle_status() static. (kbuild test robot)
> >
> > Cc: intel-wired-lan@lists.osuosl.org
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> There is a new warning here, at least one. But i40e has so many
> existing warnings with W=3D1, I can't figure out which one is new :(
>
> You most likely forgot to adjust kdoc somewhere after adding or
> removing a function parameter.

Hmm, yes. A lot of warnings there. I'll see if I can find it. Thanks!
