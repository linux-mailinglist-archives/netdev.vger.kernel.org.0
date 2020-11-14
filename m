Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E302B3072
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 21:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgKNT7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 14:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgKNT7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 14:59:21 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D85C0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 11:59:20 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id f11so19133513lfs.3
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 11:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:to:cc:subject:date:message-id
         :in-reply-to;
        bh=fabp/yAyNMk85oXnTKXiRTuO/5iVjinSWzZEPbk4WI0=;
        b=GNCaYwXjcSz8XSoLcI2YEdcBKWJpjk13JEIiOIIkxHTMRPlIH/n1zjH9e+frdBvYF0
         ezn92QH5tE02w6SxQ+JbA6lktGQSM9wiKPBr/91O3SiWhutrQKNwLOE/VTQdZyNcdHbi
         CT/10mCkwSdJbK1dm+kkTv4oPmWc+1ftccWkE2NnKtnu1p2Otm6YMvmmLablkiyxE1Ld
         I7KZ3qsWYdrnFKSmcpKViQC3qEWs83W6VzcovHWhhN8utKqFJO8E9VMouQ0AWPPu9Yot
         fyf0930h9hR1NyQ420eSY+zRB7+7xYnzo/txHr8WecgxcHNZk+DJayr6LN2UMixNcQJt
         +fyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:to:cc:subject
         :date:message-id:in-reply-to;
        bh=fabp/yAyNMk85oXnTKXiRTuO/5iVjinSWzZEPbk4WI0=;
        b=mY4j96uPnipJRaiQGpkXE05jRhjphzX04nHobYNRYTm/OqNzGpCg5lzUIkGMjxPfbL
         W/x4oYWjRQZrfESDRnS2A285mmmJqBCHszMkQJCp8g8HUDmMKy/xYxDtRX5yjhqjmFBV
         LScw0OzUqXG/8KZj1t58mO3g+d51Fh7MK9sGIJyQXxXkTaF6qBVgBU4BTgE8RqxGDBJ/
         Qq88pkTU8TZCaTBBT/8W7/x/ci76wzOVDRzgUI6IA1hhJf5MoC3h3MX01sjDPBfvpNwp
         OYjW3NEi20QUo8ZLS8TjuxvbZCOdeIqAITLjkBQYif9iOKdXUoYlKk/KPMPayh9VCdbg
         +U1A==
X-Gm-Message-State: AOAM531pf4XoJsxqd60M79dFZIDQUYHNtZcNbBjir9PzHs6j+Wwbq89C
        dVKAKnVTk2Ao6M+Prc8af1Hoap0C85BVRvJB
X-Google-Smtp-Source: ABdhPJwdNAgjaM3i2oI1mkEdx6khJ23yh7S7pkpYKQQwCw9r+mIicuixW4coJ7Smf1YQKWs/En/BMg==
X-Received: by 2002:a05:6512:3211:: with SMTP id d17mr2762199lfe.375.1605383958985;
        Sat, 14 Nov 2020 11:59:18 -0800 (PST)
Received: from localhost (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id q13sm2073196lfk.147.2020.11.14.11.59.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2020 11:59:18 -0800 (PST)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     "Andrew Lunn" <andrew@lunn.ch>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <olteanv@gmail.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 1/2] net: dsa: tag_dsa: Unify regular and
 ethertype DSA taggers
Date:   Sat, 14 Nov 2020 20:55:42 +0100
Message-Id: <C7391HRJGAV2.28OAVQBIGDRAT@wkz-x280>
In-Reply-To: <20201114154456.GY1480543@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat Nov 14, 2020 at 5:44 PM CET, Andrew Lunn wrote:
> > > > + *
> > > > + * A 3-bit code is used to relay why a particular frame was sent t=
o
> > > > + * the CPU. We only use this to determine if the packet was mirror=
ed
> > > > + * or trapped, i.e. whether the packet has been forwarded by hardw=
are
> > > > + * or not.
> > >
> > > Maybe add that, not all generations support all codes.
> >=20
> > Not sure I have that information.
>
> I'm not asking you list per code which switches support it. I'm just
> think we should add a warning, it cannot be assumed all switches
> support all codes. I just looked at the 6161 for example, and it is
> missing 5 from its list.

I see, yeah sure I can do that.

> > That leaves us with DSA_CODE_IGMP_MLD_TRAP. Here is the problem:
> >=20
> > Currenly, tag_dsa.c will set skb->offload_fwd_mark for IGMP/MLD
> > packets, whereas tag_edsa.c will exempt them. So we can not unify the
> > two without changing the behavior of one.
>
> I'm not saying that this change is wrong. I'm just afraid as a
> behaviour change, it might break something. If something does break,
> it will be easier to track down, if it is a change on its own. So
> please look if we can add a simple patch to tag_dsa.c which removes
> the marking of such frames. And then the next patch can combine the
> two into one driver. If it does break, git bisect will then tell us
> which patch broke it.

Ahh, I think I see what you are saying now. So I would copy the
IGMP/MLD exemption from tag_edsa.c to tag_dsa.c first, and then apply
the unify patch. Yeah that makes alot of sense, will do!


