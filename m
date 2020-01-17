Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1F41414EB
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 00:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730283AbgAQXwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 18:52:53 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43495 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730117AbgAQXww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 18:52:52 -0500
Received: by mail-qt1-f193.google.com with SMTP id d18so23147511qtj.10
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 15:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QthNx8KbmTlZ51acrPOpick8ZYbHkWRyumhJSeC8cnc=;
        b=dXvYXyFxYFhV2SKtHJ+ExlvFHt/x7tmzkEGJt9P3h+ZNUjv80iBzanZYL1E0eW3CWu
         uJaFUGSmI6oeqTCT2zyZrC6jo4aZ11iqM0/ddCYfGpG5sqRQQTbiXv3/yocD6xLbTxy4
         U+oxwj0fi50ropq7BMszxR5VjCI4s1NNoaLZD6iku1dRgNP04kUewLQ5cXxYU+t6voVg
         CPkXttfsSgMqqNcNEwFQnrvaTcuUEGo+nXXk8A1Lac6Z0xcXt1Ud+/D2rZ1nSJo4+5l9
         bbnLrewyL6YGBzWgLsf32VxrxVj71yiQdooTWOqLvP594/IW09kQ+s3U2l81KW8vPpLV
         9m3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QthNx8KbmTlZ51acrPOpick8ZYbHkWRyumhJSeC8cnc=;
        b=WPKiKk3n+oN3BNhII3UkMr2/KCaBXs424nybqXpKzxXJAGogEQptPOdEV5WtFLUM9S
         I53zeX7lOa2INIyms7svRoeKGtwuaEhLzYVfIdqpiTXYiF/a8+EIdFvDRF7M5oKH18dN
         oUV/17Rtp19vGsRnmFv3v5ggsd7r74nH47YZumRZ6z51D+hscJKUQeAwTNXrB/8ECw77
         KF1YIVYK+QrdKbW1xOsoqH57Ivwr+TtwIjqNJgocvNiV3yC6UAyQrJ0aUecHIOshca0l
         vknsszlifSZeGko6aYWGgEPiK8pqzUrXhmTIgaLB6bKzIHunoV9GhZMyp7z8fe26sVW1
         nZUw==
X-Gm-Message-State: APjAAAVrOUeBwX9oI5Tto5uY46+AjcsQ8lAh8XrNVwd7NCOYAWcbPVO2
        n0HF/yM1XPA6WO1fR3suIoZzc5E6lfrTQfpe2J8=
X-Google-Smtp-Source: APXvYqxvD2TUduIftzlwpyF0oImsTU8nJt+PG/gJN/d9IxejNu+z+KGmCsG4WbVUHnoBF+QSMzGPtLbr/Gc3a0TRI9U=
X-Received: by 2002:ac8:5197:: with SMTP id c23mr9246396qtn.212.1579305171777;
 Fri, 17 Jan 2020 15:52:51 -0800 (PST)
MIME-Version: 1.0
References: <20200116094327.11747-1-niko.kortstrom@nokia.com>
 <8c5be34b-c201-108e-9701-e51fc31fa3de@6wind.com> <6465a655-2319-c6e6-d3ca-3cf5ba27640f@nokia.com>
 <0b180112-5931-36b4-670d-192fd714a14e@6wind.com>
In-Reply-To: <0b180112-5931-36b4-670d-192fd714a14e@6wind.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 17 Jan 2020 15:52:15 -0800
Message-ID: <CALDO+SZppBa6Wm+yi-UfQohzH3We3jWHZk5Ge8fTutH6VJHg7Q@mail.gmail.com>
Subject: Re: [PATCH] net: ip6_gre: fix moving ip6gre between namespaces
To:     nicolas.dichtel@6wind.com
Cc:     kortstro <niko.kortstrom@nokia.com>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 8:00 AM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
> + William Tu
>
> Le 16/01/2020 =C3=A0 15:43, kortstro a =C3=A9crit :
> > On 1/16/20 4:02 PM, Nicolas Dichtel wrote:
> >> Le 16/01/2020 =C3=A0 10:43, Niko Kortstrom a =C3=A9crit :
> >>> Support for moving IPv4 GRE tunnels between namespaces was added in
> >>> commit b57708add314 ("gre: add x-netns support"). The respective chan=
ge
> >>> for IPv6 tunnels, commit 22f08069e8b4 ("ip6gre: add x-netns support")
> >>> did not drop NETIF_F_NETNS_LOCAL flag so moving them from one netns t=
o
> >>> another is still denied in IPv6 case. Drop NETIF_F_NETNS_LOCAL flag f=
rom
> >>> ip6gre tunnels to allow moving ip6gre tunnel endpoints between networ=
k
> >>> namespaces.
> >>>
> >>> Signed-off-by: Niko Kortstrom <niko.kortstrom@nokia.com>
> >> LGTM.
> >> Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Hi Nicolas,

I did not test moving between namespaces at that time.
Your change looks good to me.

Acked-by: William Tu <u9012063@gmail.com>

Thanks
William

> >>
> >> Did you test real x-vrf cases with the three kinds of gre interfaces
> >> (gre/collect_md, gretap and erspan)?
> > This was only verified in real use with ip6gretap.
> William, did you set this flag on collect_md interfaces because you did n=
ot test
> this feature or was it another reason?
>
> Note: the flag was added here: 6712abc168eb ("ip6_gre: add ip6 gre and gr=
etap
> collect_md mode").
>
> Regards,
> Nicolas
