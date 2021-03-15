Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30BF133C3AC
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 18:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbhCORLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 13:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235620AbhCORKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 13:10:46 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF41C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 10:10:46 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id o3so2329484pfh.11
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 10:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+k7XtnCMD3SUvU41u0ZGJrVxaxncWRvjSQ/PkymY1DQ=;
        b=SXgAiRJYDI8Xa7Zr34LrxrUV9fe2U4ztDrrK1yXNGL7CbkgG3MoXQJ5AfuT4zOWtsP
         k/amhODaanVJ0lYgbv2Sn1pQHHTHNW+ee6OHsLDBZD74kMDOETf805m49r5Y2pOU6ATN
         0WQ67l44m5XBFdHdGYdcBirmI1N7olxQj/FpHCvOtQlcaL2NLDacIIOCMU68ky1+ZA2b
         Ewr7qv73e812fTLTnpsJK/Rskk+Vdk/4uUyPG9PDdAS1AlkYgyxrioSVe35OtPPi8Sbc
         o+SQDPCFoiBpwP4tlG4brc1nKdIO247PS3Gk+hE0+xXilqPiphwWw9n9KtTBjAA17uJP
         KI5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+k7XtnCMD3SUvU41u0ZGJrVxaxncWRvjSQ/PkymY1DQ=;
        b=NOhwhVWj5/yYtpQnXWqARbCDk6F9uEhb7YufTLj/Z3buYKBTtimL5GgzGwKqirQkRm
         WbqMK3tIaS7BSjGdfeOaHfy1jGtZnoykNv3qqpQHPSwK6gCLyBKZsjksLjOzoZjSAcPc
         cg04YLRsfmu35a7R651O7cppR2TSwvBfqAFodKhxKKuvaVaPsklGRNjtNj24hgh2aNMd
         K5xVK2WExfdXqTr1jWYLJE9MpDPf5ubR7k+8ZeyeuARCZHfjJ6wrXeUpS02eL6bzdKSw
         SvW1BjwyYLsrV58MLFqcozIEZqu8ali4tEKrn+GK74fsidlXR4K+/0FwWpKpvH3hlxBz
         DZ2A==
X-Gm-Message-State: AOAM531oXvMlhzIUnpsit7fxM8oV1oraOHNLLxBNKk5+Uq+ebR5ddzil
        XidPcjbifSqkjjdWmtRSNmtuoZEZKMZ635Bpv3duwfuXre4ORA==
X-Google-Smtp-Source: ABdhPJwGEJ/FpBhjtjwWdJjI3ecVKlSEfjJk3LicdurnrU8XbzQHC+95FpEJPMnRC7rChu6Zbied6o7JKB3nVVqFJhg=
X-Received: by 2002:a63:4421:: with SMTP id r33mr103683pga.247.1615828246023;
 Mon, 15 Mar 2021 10:10:46 -0700 (PDT)
MIME-Version: 1.0
References: <CADbyt64e2cmQzZTEg3VoY6py=1pAqkLDRw+mniRdr9Rua5XtgQ@mail.gmail.com>
 <5b2595ed-bf5b-2775-405c-bb5031fd2095@gmail.com> <CADbyt66Ujtn5D+asPndkgBEDBWJiMScqicGVoNBVpNyR3iQ6PQ@mail.gmail.com>
 <CADbyt64HpzGf6A_=wrouL+vT73DBndww34gMPSH9jDOiGEysvQ@mail.gmail.com> <5f673241-9cb1-eb36-be9a-a82b0174bd9c@gmail.com>
In-Reply-To: <5f673241-9cb1-eb36-be9a-a82b0174bd9c@gmail.com>
From:   Greesha Mikhalkin <grigoriymikhalkin@gmail.com>
Date:   Mon, 15 Mar 2021 18:10:34 +0100
Message-ID: <CADbyt6542624xAVzWXM6KEfk=zAOmB_SHbN=nzC_oib_+eXB1Q@mail.gmail.com>
Subject: Re: VRF leaking doesn't work
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> That's the way the source address selection works -- it takes the fib
> lookup result and finds the best source address match for it.
>
> Try adding 'src a.b.c.d' to the leaked route. e.g.,
>     ip ro add 172.16.1.0/24 dev red vrf blue src 172.16.2.1
>
> where red and blue are VRFs, 172.16.2.1 is a valid source address in VRF
> blue and VRF red has the reverse route installed.

Tried to do that. Added reverse route to vrf red like that:
    ip ro add vrf red 172.16.2.1/32 dev blue

172.16.2.1 is selected as source address when i ping. But now, when i
look at `tcpdump icmp` i only see requests:
    172.16.2.1 > 172.16.1.3: ICMP echo request, id 9, seq 10, length 64

And no replies and anything else. If i look into tcpdump on machine
that's pinged -- it doesn't receive anything.

So it looks like it's not using nexthops from vrf red in that case.
Maybe it has something to do with how address is setup. In routing
table it looks like:
    local 172.16.2.1 dev vlanblue proto kernel scope host src 172.16.2.1
