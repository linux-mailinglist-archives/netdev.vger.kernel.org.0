Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1CBA792C
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 05:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbfIDDRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 23:17:20 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43319 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727374AbfIDDRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 23:17:20 -0400
Received: by mail-wr1-f68.google.com with SMTP id y8so19503203wrn.10
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 20:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BrgwymPhAq6tKy24kZbgc2QdZO/ydGEXOgtKV4P8w7U=;
        b=Co7t+RmHXwdYPu4vOmMA+pMq1IWwTSZkrsEHc8WvSTS9h07zE8pgJnTlW/j08MAHCR
         URC5PNPVic/0FTdEOZdlVOiDHNntXIbAg5nO1efXhQOQEWNMjes+5YpdV0+xmQhu7N9E
         2TNKiLLkHOBR3qgmvjh1JgQAwM2kt8WEq2Dq1SirMTfvnJ8Xo5RrBchTKPbQFsztB7M0
         cNRTD3qQqg5EHFT3/THjx6xbQaEjgWhqi9VMnafy//bQWD0RJnPalGyuwggt0rVXYq0p
         WZM8KHS1VWjt7xNxDK+scXY2Pxvu0D6XOavcMXhdnjN2VzK5oeHSPB7e3FZurTpfJJ/u
         HVpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BrgwymPhAq6tKy24kZbgc2QdZO/ydGEXOgtKV4P8w7U=;
        b=XDztiXb6htwobVZg4W4BbN8rVFQBt0Wz4+mN/WqKgc36cnYB+ck272hu7jgGYEq9Y4
         P4l1tNSRNmhB1xvTRHlGwIX300ZG42Wl/xX1daCNZRnfo/riceIND5UQLJIkWPt47c1N
         h0HOLpzL6+iAvXdk1cj93ZhPcFZ5dm5G+TerPD2Hmsj9xQhLyTHz8A3usL/jEKB0IxnE
         kA4uayRup47lMIeZT6I1BQjGS5RorK2hFxvb5qois+UvB7jpTae1hCHr09vx+ywjXCBu
         mBiH0wxLglETp0xV2QyDV/wt1NCgU6YXUv4wbILovJGbhrUYqxcjNGVdMNjf4W8ckARQ
         aHXg==
X-Gm-Message-State: APjAAAUbJhO2RyfiUAfBffKBj+oB7t2eYpd639d/0SBHO3n2vE+puTsb
        Q8aI94pk4YBMKgxa6t5J9tPAx38MikUkE23RB8uVgA==
X-Google-Smtp-Source: APXvYqzcemKe7fRZg4zeFGnqj4R5ii2LKbIUkSKcrpe+3RGhjzqDPqDjlyIMEocmDwWeOMNAAS5vUdy53EyXYBAe2hY=
X-Received: by 2002:adf:e603:: with SMTP id p3mr15211517wrm.102.1567567037805;
 Tue, 03 Sep 2019 20:17:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190901174759.257032-1-zenczykowski@gmail.com>
 <CAHo-Ooy_g-7eZvBSbKR2eaQW3_Bk+fik5YaYAgN60GjmAU=ADA@mail.gmail.com>
 <CAKD1Yr2tcRiiLwGdTB3TwpxoAH0+R=dgfCDh6TpZ2fHTE2rC9w@mail.gmail.com>
 <cd6b7a9b-59a7-143a-0d5f-e73069d9295d@gmail.com> <CAKD1Yr2ykCyEiUyY4R+hYoZ+eWGjbE78wtSf2=_ZjLpCyp0n-Q@mail.gmail.com>
 <CAHo-OoyQzJptNDcLe93o3-G10oRN+93ZZ35jKkLudSanvgn-2Q@mail.gmail.com> <60b98521-cf3a-1130-896d-2947fc4d5290@gmail.com>
In-Reply-To: <60b98521-cf3a-1130-896d-2947fc4d5290@gmail.com>
From:   Lorenzo Colitti <lorenzo@google.com>
Date:   Wed, 4 Sep 2019 12:17:05 +0900
Message-ID: <CAKD1Yr3ZS8o09k=zFMhuwJueotJ5JzK-BPadm+B3_usDA7d6Og@mail.gmail.com>
Subject: Re: [PATCH] net-ipv6: fix excessive RTF_ADDRCONF flag on ::1/128
 local route (and others)
To:     David Ahern <dsahern@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 4, 2019 at 4:45 AM David Ahern <dsahern@gmail.com> wrote:
>
> exactly. It was shortsighted of me to add the ADDRCONF flag and removing
> it reverts back to the previous behavior.
>
> When I enable radvd, I do see the flag set when it should be and not for
> other addresses. I believe the patch is correct.

Ah, wait, I was confused. Sorry.

What I was saying is that RTF_ADDRCONF flag should be set on the local
table /128 route for the IPv6 addresses configured by RAs. The way
those are configured is ndisc_router_discovery -> addrconf_prefix_rcv
-> addrconf_prefix_rcv_add_addr -> ipv6_add_addr ->
addrconf_f6i_alloc. Because in this patch, addrconf_f6i_alloc
unconditionally clears RTF_ADDRCONF, I didn't see how the flag could
be set. But I now realize that that was not happening before David's
commit, either: in 5.1 those routes were not created with RTF_ADDRCONF
either.

In other words: before 5.1, the /128 routes in the local table to IPv6
addresses created by SLAAC did not have RTF_ADDRCONF. After David's
commit, they did, because *all* /128 routes to IPv6 addresses had
RTF_ADDRCONF (correct for SLAAC adresses, but definitely incorrect for
manual addresses, loopback, etc.). If this commit is applied, we'll go
back to the 5.1 state. In the future it would be good to ensure that
at least the /128 routes created by SLAAC do have RTF_ADDRCONF, but no
need to do so in this commit.
