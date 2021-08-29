Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080273FAB92
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 15:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235334AbhH2NNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 09:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235271AbhH2NNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 09:13:41 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDE5C061575
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 06:12:49 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id s3so20717640ljp.11
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 06:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=qk+BeOLzgsCodysyhanIGqG+JmDcZKcPbja0+FGRw/Q=;
        b=vR0WFtZiuUCjmXDf1W7raSvAwB8KDsFWZ2e8JBSV1BgbVi8Ts30DQbStz7sdk2hbzM
         TbNotbZ68sRQzN+KU/sG1af8G/mLSNDQ7C9RLsoB6eZjL2O8Jqqt/F3HiA4QqKAGuDnW
         WnzNik5zELazf7CjaqeGF/tsBgo0JyaCO0gb87ldMBiyZNw7LhDmZRKrnGm8fr0PAdCP
         wifld706EGTYXBwKlgqkmoENcdUfJaDhaVLZTKLga75imXSqR6c1kS9KPUNYcR9fidXR
         gaeSpmFiDwuAc8tDDwiWzICoTCFQ3R42YzHgcqsszVmvfCB7hVORnu+gEIjq9jwUwpRN
         dvqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=qk+BeOLzgsCodysyhanIGqG+JmDcZKcPbja0+FGRw/Q=;
        b=RuxFDQiRNWhWKVUomVzavFbhLUXLvuHrXY9ZZOoIJWGPl98QANrnKLmlxcKcbfChP0
         pHj/WKbcU+4lrLKE+j+JpcBekAxjVi6+sZZKCLuoN3qe6eNb65luchlaEHa1BG8O9jBF
         8aNbrrr5rZ47pGqFwaYOtuCUe2Tv7qByPjKhsK3DHIau8UrEbw+B1Xjdgf+Ly0w1Sv1e
         AQp6uQmiAUckWUsl+eyJXHhAfzwMDqi9ch7CRTDkF+73YuPgTTjIRSMfeyDMJT7I4p0/
         m7NalZZf155IDivkFAJQRd4cvm2fOPYSyYnFnSlg1IIHrQEyy1p5nFwIe8Dq9NjOZPhj
         uzZQ==
X-Gm-Message-State: AOAM533n/ALZ/xDvJXQ0GIpBC3CZXu3zLmUVEiw07civSmLZ34qYq9rs
        KS7UNFY46VjUNIZKSXogvpwTsBvi5AWyJUuDlLtUe7lJMJk=
X-Google-Smtp-Source: ABdhPJxjlpa2rSHeZ+VwvTpDhlNVkGPDJv+Pu+WHphI0cpbGPdMTQMXBUzraXoT2kWQC6HhyxX7Ap4IIBsfDGLPUNdU=
X-Received: by 2002:a05:651c:11c7:: with SMTP id z7mr16298814ljo.87.1630242766519;
 Sun, 29 Aug 2021 06:12:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAGnHSEk-gxY3jr-2k8+NSB0uf9H94SDQyxJFVM1LH3A+Bs+5MA@mail.gmail.com>
 <CAGnHSEmeLTq6FsG18QDBmD_cHcNfTk2N6t7Nwrc53p9Ejnd5kg@mail.gmail.com>
 <CAGnHSEkBiJdLFb88U2d7EhgxvfwbE7DtOxp115SzoP8Cv_Jq4A@mail.gmail.com> <CAGnHSEnBVGy3aj==RkYR2MCLdSZm3uy62esS-K8bD8pi1fqgCA@mail.gmail.com>
In-Reply-To: <CAGnHSEnBVGy3aj==RkYR2MCLdSZm3uy62esS-K8bD8pi1fqgCA@mail.gmail.com>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Sun, 29 Aug 2021 21:12:35 +0800
Message-ID: <CAGnHSEmu2iYnRzFfKA9iT585M1GnCHCxY3Riztu+oDZyb0whUA@mail.gmail.com>
Subject: Re: Bridged passthru MACVLAN breaks IPv6 multicast?
To:     netdev@vger.kernel.org, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hmm, interestingly, the problem occurs only when I am using the
permanent MAC address of the wireless NIC. If I change/randomize the
address (and of course, make the bridge use the result as its own
address as well), Neighbor Solicitations can come in without needing
the NIC and the MACVLAN to have IPv6LL.

On Tue, 24 Aug 2021 at 15:41, Tom Yan <tom.ty89@gmail.com> wrote:
>
> To be more precise, when the passthru MACVLAN is not bridged, I can see:
>
> # tcpdump -eni any icmp6
> tcpdump: data link type LINUX_SLL2
> tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
> listening on any, link-type LINUX_SLL2 (Linux cooked v2), snapshot
> length 262144 bytes
> 15:30:50.865328 wlan0 M   ifindex 5 LAN_HOST_MAC ethertype IPv6
> (0x86dd), length 92: LAN_HOST_LL > ff02::1:MEH:MEH: ICMP6, neighbor
> solicitation, who has THIS_HOST_LL, length 32
> 15:30:50.865547 macvl0 M   ifindex 6 LAN_HOST_MAC ethertype IPv6
> (0x86dd), length 92: LAN_HOST_LL > ff02::1:MEH:MEH: ICMP6, neighbor
> solicitation, who has THIS_HOST_LL, length 32
>
> followed by unicast neighbor advertisement "OUTs" from this host to
> the LAN host.
>
> But when the MACVLAN is bridged, I cannot see a similar capture at all
> (i.e. it doesn't just "stop" before "walking across" the MACVLAN,
> rather they appear to be blocked at "the outside" or so.)
>
> On Tue, 24 Aug 2021 at 12:57, Tom Yan <tom.ty89@gmail.com> wrote:
> >
> > Never mind. I made a mistake. Turns out only Neighbor Solicitation
> > from a LAN host does not "walk across" the MACVLAN. ping
> > ff02::1%some_dev and Neighbor Solicitation from a bridge tap host
> > actually do. (I forgot to change the ether saddr for them: the
> > underlying link is a wireless NIC)
> >
> > Btw Neighbor Advertisement from a LAN host "walks across" the MACVLAN
> > as well. I can see it on this host.
> >
> > I guess I can workaround the problem by re-enabling IPv6LL on the
> > MACVLAN. Still wonder why that is broken though.
> >
> > On Tue, 24 Aug 2021 at 12:12, Tom Yan <tom.ty89@gmail.com> wrote:
> > >
> > > Hi,
> > >
> > > I've further investigated the problem:
> > >
> > > What "walk across":
> > > ping ff02::1%bridge and Neighbor Solicitation from this host (tcpdump
> > > multicast on a LAN host can see them)
> > > ping ff02::1%some_dev from a LAN host (tcpdump multicast on this host
> > > or a bridge tap host can see them)
> > >
> > > What do not "walk across":
> > > Neighbor Solicitation from a LAN host (both tcpdump multicast on this
> > > host and on a bridge tap host cannot see them)
> > > ping ff02::1%some_dev and Neighbor Solicitation from a bridge tap host
> > > (tcpdump multicast on this host can see them, but that on a LAN host
> > > cannot)
> > >
> > > There is no problem with ARP (or IPv4 multicast, apparently).
> > >
> > > P.S. I've filed a bug report on:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=214153
> > >
> > > Regards,
> > > Tom
> > >
> > > On Mon, 23 Aug 2021 at 02:07, Tom Yan <tom.ty89@gmail.com> wrote:
> > > >
> > > > Hi,
> > > >
> > > > Normally when a NIC is (directly) enslaved as a bridge port, the NIC
> > > > itself does not need to have a IPv6 link-local address configured on
> > > > it for IPv6 multicast / NDP to work properly (instead the address can
> > > > simply be configured on the bridge like IPv4 addresses).
> > > >
> > > > Yet it appears that if the bridge port is instead a passthru mode
> > > > MACVLAN, IPv6 multicast traffics from (the link/"side" of) it cannot
> > > > reach the host (as in, cannot even be captured with tcpdump) unless
> > > > either the MACVLAN or its underlying link has a/the[1] IPv6 link-local
> > > > address configured.
> > > >
> > > > Is it an expected behavior? Or is it a bug?
> > > >
> > > > [1]: In my configuration, the bridge, the bridged passthru MACVLAN and
> > > > its underlying link have the same MAC address and hence (at least by
> > > > default) their IPv6 link-local addresses are identical.
> > > >
> > > > Regards,
> > > > Tom
