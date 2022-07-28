Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A11C584069
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 15:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiG1NyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 09:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiG1NyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 09:54:15 -0400
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3966481E9
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 06:54:13 -0700 (PDT)
Received: by mail-vk1-xa31.google.com with SMTP id q125so869565vka.11
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 06:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EfelAleCItbP5SFIzGAFXMrQgk8BNU5F+/f0P4mObFw=;
        b=BoqIi5INSsFOhYmLKg7dsNBE2EAJRSskw3eN4R8pUco0jn5mSLBi9ZSkFeDDG+MBlS
         1tWScGMPzwGI5RmhsQGdA9I3K9YZfLt7R02n2jTwhhKmLjktIevnYfiBfF2BpbXxr8k7
         eMTaKrslgA5ZA3aVYEV9e1LE3+IhvW0LICNT+xVhDMqTDM3ovnM2Dh+N6eBGRNc/dHGS
         k0mYjeT2t6aTuKul3YVY43p8qMljMDPj+5E5QUKWt0J35+YOYDDuL8ZlGcEoL3I/cfrn
         ZA6adsYNPuTZamLrnMXqC7AIdPTcbaox8kbkUCA9+Ql9w4QW92yM0bkFK4RahprTVi8V
         uQVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EfelAleCItbP5SFIzGAFXMrQgk8BNU5F+/f0P4mObFw=;
        b=k9Pyi9cKl2xddtR/hvtheKtTLVbNk9G8/72lfVPF+6TG3XmOlodEsnwpJMZX6IM5by
         eh5i/x353+//lOqK4Y+ZmCtT57HrogJ4RPIqH2aqVvPkyZQsgUG+JgkI/0OcaaNq9M1w
         uX0ZgIsYVRbRPJQZn3VB6HVcJA/65ZehFnZ3yH7QMOIzCqvO5fXVXahyjycDjJVOAs82
         FfJd6Rr1DY+7NDGuNaTu+3CUWc37b17zXw1+VvKQ/zJ99zy5I2qXZ12aeGO3gC/DqmMf
         uEZyOg2VpalPx2tstuHQDNDp+RNkKUsOq+CW+UTCVFJhEBIVJtHh1o/40cUiNCL3213c
         z3PQ==
X-Gm-Message-State: AJIora/34LlMsm6e19yi7vYxlj6N1Zl2DAZx1EjCxV5twd2BGFBIEkQh
        6qK1i4oUmiViNWuhvAsZCXxpXYroGZKqwAwUSD8=
X-Google-Smtp-Source: AGRyM1tg5nFgeQt6mGa2oRDbCUcIiNmVVphPqSoUmkGBWF5hwPv4lN+tlybv63fnhASPn4TKXkLWGf+Py6a4GDHiS94=
X-Received: by 2002:a1f:ab85:0:b0:376:caf7:97a2 with SMTP id
 u127-20020a1fab85000000b00376caf797a2mr2304674vke.14.1659016452905; Thu, 28
 Jul 2022 06:54:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAJGXZLi_QCZ+4dHv8qtGeyEjdkP3wjoXge_b-zTZ0sgUcEZ8zw@mail.gmail.com>
 <20220622171929.77078c4d@kernel.org> <CAJGXZLiNo=G=5889sPyiCZVjRf65Ygov3=DWFgKmay+Dy3wCYw@mail.gmail.com>
 <20220623202602.650ed2e6@kernel.org> <CAJGXZLg9Z3O8w_bTLhyU1m7Oemfx561X0ji0MdYRZG8XKmxBpg@mail.gmail.com>
 <20220624101743.78d0ece7@kernel.org> <CAJGXZLhJd4xYQhvhb8r0QYhjSjNUCe6nmvi5TA_Ma6LO992KYw@mail.gmail.com>
 <20220701183151.1d623693@kernel.org> <20220701184222.34b75a77@kernel.org>
 <CAJGXZLj2pMki+88OO_fDf-KO1jehEKWg2m5yKTeB0K4yKuMmmg@mail.gmail.com> <20220707162319.49c25e90@kernel.org>
In-Reply-To: <20220707162319.49c25e90@kernel.org>
From:   Aleksey Shumnik <ashumnik9@gmail.com>
Date:   Thu, 28 Jul 2022 16:54:01 +0300
Message-ID: <CAJGXZLgtLLMGsgn4EXO1VNiO0KvVah_jPHCmYU_zNM-_XnEOOA@mail.gmail.com>
Subject: Re: [PATCH] net/ipv4/ip_gre.c net/ipv6/ip6_gre.c: ip and gre header
 are recorded twice
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, kuznet@ms2.inr.ac.ru,
        xeb@mail.ru
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 8, 2022 at 2:23 AM Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 7 Jul 2022 19:41:23 +0300 Aleksey Shumnik wrote:
>
> Yeah, I've added the neigh entries (although the v6 addresses had to
> be massaged a little for ip neigh to take them, the commands from the
> email don't work cause iproute2 doesn't support :: in lladdr, AFAICT).
>
> What I've seen in tracing was that I hit:
>
> ip6gre_tunnel_xmit() -> ip6_tnl_xmit_ctl() -> ip6_tnl_get_cap()
>
> that returns IP6_TNL_F_CAP_PER_PACKET
>
> so back to ip6gre_tunnel_xmit() -> goto tx_err -> error, drop
>
> packet never leaves the interface.

I skipped this check so that the packets wouldn't drop.
I compared the implementations of ip_gre.c and ip6_gre.c and I
concluded that in ip6_tnl_xmit_ctl() instead of tunnel params
(&ip6_tnl->parms.laddr and &ip6_tnl->parms.raddr) it is better to use
skb network header (ipv6_hdr(skb)->saddr and ipv6_hdr(skb)->daddr).
It is illogical to use the tunnel parameters, because if we have an
NBMA connection, the addresses will not be set in the tunnel
parameters and packets will always drop on ip6_tnl_xmit_ctl().

> Hm, so you did get v6 to repro? Not sure what I'm doing wrong, I'm
> trying to repro with a net namespace over veth but that can't be it...

Yes, just skip ip6_tnl_xmit_ctl().
