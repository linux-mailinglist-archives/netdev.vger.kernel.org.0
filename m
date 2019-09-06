Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3373AB1E2
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 07:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392250AbfIFFKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 01:10:34 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:43880 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392246AbfIFFKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 01:10:34 -0400
Received: by mail-yw1-f66.google.com with SMTP id q7so1771357ywe.10
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 22:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=y6IeE+yO8WDFAoFSUo/oKcHKqaqbm5zUYVBFOzVC4ic=;
        b=kM7ldr89EPoHljBUoX1gFUV/VYpqer67DdDkVify+wP8n0m7PW9BM3V6dQlQB4B2Rl
         2AJ2maPjVXH1tVPl3Tcc68l7kh0hYlGIFZj2+qkUvdHvR2nEJ9eDjjXzZxY0VT6Jj8t0
         mSiXbq+YU6z/5E06A0ATZPMp3TEX80rSfNpzE5gVrRj9eX9ytA7lcMHzBZy4aR6O0Qva
         m9eCmatLMiZSRROyfqcrmKPahMN0YxWMYJMZjRbQXDXnViSMRHI6Tcnbs/ydmZbfg5iO
         4Lbmc6FJOGkxWQwyhF2ZmmofUPzLfRls6GQlkwtBzZbwO4ur+YWAK8cDcg7EWqsa7WAF
         pdqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=y6IeE+yO8WDFAoFSUo/oKcHKqaqbm5zUYVBFOzVC4ic=;
        b=HMD4fhhwxGN0+y8kjlD9QTh0mud1KscuCkZLAz82CLS4bRPQ92UfTrzOS6U2uYzzT8
         8iyAPe+Dq3yNcNnzoDyCQbnXBl5YQ1DHpnMi+WAYYoCq8FwjoLsQ5BS6wwD1P530pTih
         g0LUsgn/Cmi3mJbYSd3qkvwDVsBExIgc8dbyMQ3n4XzdQFwHWxhrXXlHMMZd8MFN3bfZ
         TsYY8snbqiJdBP/CJCTo95MdrP3Ar47tUMs7k53tjoMe+IHqnes6eEifLAhoJZoYNVUk
         6ghDAUtsNFi0F9jW1btvmJAW8trexzgKGGfb1o5T32lUvJviXWAdiiJBafyNVfcQlypd
         Sp8w==
X-Gm-Message-State: APjAAAVDcqujf4WaK1bi/7hsnrA036P0BW0RuFX6gdvxsNjxdMlmBWgQ
        hoYfomVl8WPi06//re3DugW1Jd+JGNco0mjLNjdBJw==
X-Google-Smtp-Source: APXvYqyftFpsadm5i6LQAo3apuiS4GGQIu09alkMX/uq7dLucYag2ggkme16co8rSkzNtCMEGXc5qoxmUhCM46yNxAw=
X-Received: by 2002:a0d:db56:: with SMTP id d83mr4878225ywe.135.1567746632573;
 Thu, 05 Sep 2019 22:10:32 -0700 (PDT)
MIME-Version: 1.0
References: <CANP3RGcbEP2N-CDQ6N649k0-cV4AhQeWqF-niz7EMPFOFpkU1w@mail.gmail.com>
 <20190906035637.47097-1-zenczykowski@gmail.com>
In-Reply-To: <20190906035637.47097-1-zenczykowski@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 6 Sep 2019 07:10:19 +0200
Message-ID: <CANn89iKieZm8B+cB=mjK6jumM2koS+0Ae64STw_h_GCKom2vYQ@mail.gmail.com>
Subject: Re: [PATCH] net-ipv6: addrconf_f6i_alloc - fix non-null pointer check
 to !IS_ERR()
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Lorenzo Colitti <lorenzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 6, 2019 at 5:56 AM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> From: Maciej =C5=BBenczykowski <maze@google.com>
>
> Fixes a stupid bug I recently introduced...
> ip6_route_info_create() returns an ERR_PTR(err) and not a NULL on error.
>
> Fixes: d55a2e374a94 ("net-ipv6: fix excessive RTF_ADDRCONF flag on ::1/12=
8 local route (and others)'")
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Lorenzo Colitti <lorenzo@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
> ---

Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>

Thanks.
