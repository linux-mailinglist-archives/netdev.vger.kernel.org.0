Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592AD3F5945
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 09:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235503AbhHXHnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 03:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235453AbhHXHnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 03:43:31 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F8AC0611C6
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 00:41:56 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id w4so34471294ljh.13
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 00:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=ep/w39XchRrZtcy0God3rU74HbL93VNiVNfQKfK3Vh0=;
        b=VEj1WaaojettsIl3loo/KfVEHO8vig2nN3hX0Kt+YazBl7gOAiRlhBF/mvDT5R9MRq
         iWH0MHDnAw6SpZ6jAubjY1LcM9pYD1R3G4KPYiST/9W3Ud0LmRtcNxL4GGQUH0Rbut6X
         Gkd8NC/ns9YR0bc5mExIBuk755bzrxFPkJYLyEsasbFSWYTda30O1Eo+5y4WHGQ+WWFE
         JJqrZRhqhHAdi1DZC4cDpRYIGrHyRyxYT2Mfn0KHl7RpM9a7RwBwy4o5OPFgNZGZFrMQ
         0McJNB+UEyVZjn1Ger2k2Dfe2S0gg9a7qPDBhXFCSlxmfeDN20PL+mM0wRMGkj7cXt9Z
         akZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=ep/w39XchRrZtcy0God3rU74HbL93VNiVNfQKfK3Vh0=;
        b=i+ITe/vD09JvpjuG8eZmSGMpsjWN/wOor2VqHjsDLh9H46WIe2X7aC2hw4ElCpRX8d
         2aglCt7az/VB68qwjFvAD003jNMYXSR/Lc+VnCwQOPovujoqD+PfUKoIe6ALkGP4eHbD
         ywssmwjmel3cufhNcmKiGWQd3REQDCUyV8gycyQBFPyYSeIcpXdGVjZs0w7W/60dUymx
         3HpwMpdw1/rvyPG00NDSYU4xAIodHVXw/9RB89ZBl2DPg201rf8fnOoRks4AeKCQZNe6
         Ri+bMjC2Z0CLCkewcF3XTiUG4NCOu/pzo/60WiRX+Qh0azU7fof//qSJ+pFyhM2ySDET
         9uhg==
X-Gm-Message-State: AOAM532eVyu4sfEysb97gADWTF62dC8U1KM89DGZwalD2IqHyMckoH5s
        DRMWXYwrc/PibV8uCBjAioXhlrhjYzubHH3ZbkYGTfU6PTgXJA==
X-Google-Smtp-Source: ABdhPJwb6VuiSInL4u1L2u9qWDGVcxxXxI4qa9rELNicIiKhW+Rr5k1q5ol8qe22BL0ruLvBR727Gw7HfXx8Pb5vHi0=
X-Received: by 2002:a05:651c:11c7:: with SMTP id z7mr30519854ljo.87.1629790914471;
 Tue, 24 Aug 2021 00:41:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAGnHSEk-gxY3jr-2k8+NSB0uf9H94SDQyxJFVM1LH3A+Bs+5MA@mail.gmail.com>
 <CAGnHSEmeLTq6FsG18QDBmD_cHcNfTk2N6t7Nwrc53p9Ejnd5kg@mail.gmail.com> <CAGnHSEkBiJdLFb88U2d7EhgxvfwbE7DtOxp115SzoP8Cv_Jq4A@mail.gmail.com>
In-Reply-To: <CAGnHSEkBiJdLFb88U2d7EhgxvfwbE7DtOxp115SzoP8Cv_Jq4A@mail.gmail.com>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Tue, 24 Aug 2021 15:41:43 +0800
Message-ID: <CAGnHSEnBVGy3aj==RkYR2MCLdSZm3uy62esS-K8bD8pi1fqgCA@mail.gmail.com>
Subject: Re: Bridged passthru MACVLAN breaks IPv6 multicast?
To:     netdev@vger.kernel.org, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To be more precise, when the passthru MACVLAN is not bridged, I can see:

# tcpdump -eni any icmp6
tcpdump: data link type LINUX_SLL2
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on any, link-type LINUX_SLL2 (Linux cooked v2), snapshot
length 262144 bytes
15:30:50.865328 wlan0 M   ifindex 5 LAN_HOST_MAC ethertype IPv6
(0x86dd), length 92: LAN_HOST_LL > ff02::1:MEH:MEH: ICMP6, neighbor
solicitation, who has THIS_HOST_LL, length 32
15:30:50.865547 macvl0 M   ifindex 6 LAN_HOST_MAC ethertype IPv6
(0x86dd), length 92: LAN_HOST_LL > ff02::1:MEH:MEH: ICMP6, neighbor
solicitation, who has THIS_HOST_LL, length 32

followed by unicast neighbor advertisement "OUTs" from this host to
the LAN host.

But when the MACVLAN is bridged, I cannot see a similar capture at all
(i.e. it doesn't just "stop" before "walking across" the MACVLAN,
rather they appear to be blocked at "the outside" or so.)

On Tue, 24 Aug 2021 at 12:57, Tom Yan <tom.ty89@gmail.com> wrote:
>
> Never mind. I made a mistake. Turns out only Neighbor Solicitation
> from a LAN host does not "walk across" the MACVLAN. ping
> ff02::1%some_dev and Neighbor Solicitation from a bridge tap host
> actually do. (I forgot to change the ether saddr for them: the
> underlying link is a wireless NIC)
>
> Btw Neighbor Advertisement from a LAN host "walks across" the MACVLAN
> as well. I can see it on this host.
>
> I guess I can workaround the problem by re-enabling IPv6LL on the
> MACVLAN. Still wonder why that is broken though.
>
> On Tue, 24 Aug 2021 at 12:12, Tom Yan <tom.ty89@gmail.com> wrote:
> >
> > Hi,
> >
> > I've further investigated the problem:
> >
> > What "walk across":
> > ping ff02::1%bridge and Neighbor Solicitation from this host (tcpdump
> > multicast on a LAN host can see them)
> > ping ff02::1%some_dev from a LAN host (tcpdump multicast on this host
> > or a bridge tap host can see them)
> >
> > What do not "walk across":
> > Neighbor Solicitation from a LAN host (both tcpdump multicast on this
> > host and on a bridge tap host cannot see them)
> > ping ff02::1%some_dev and Neighbor Solicitation from a bridge tap host
> > (tcpdump multicast on this host can see them, but that on a LAN host
> > cannot)
> >
> > There is no problem with ARP (or IPv4 multicast, apparently).
> >
> > P.S. I've filed a bug report on:
> > https://bugzilla.kernel.org/show_bug.cgi?id=214153
> >
> > Regards,
> > Tom
> >
> > On Mon, 23 Aug 2021 at 02:07, Tom Yan <tom.ty89@gmail.com> wrote:
> > >
> > > Hi,
> > >
> > > Normally when a NIC is (directly) enslaved as a bridge port, the NIC
> > > itself does not need to have a IPv6 link-local address configured on
> > > it for IPv6 multicast / NDP to work properly (instead the address can
> > > simply be configured on the bridge like IPv4 addresses).
> > >
> > > Yet it appears that if the bridge port is instead a passthru mode
> > > MACVLAN, IPv6 multicast traffics from (the link/"side" of) it cannot
> > > reach the host (as in, cannot even be captured with tcpdump) unless
> > > either the MACVLAN or its underlying link has a/the[1] IPv6 link-local
> > > address configured.
> > >
> > > Is it an expected behavior? Or is it a bug?
> > >
> > > [1]: In my configuration, the bridge, the bridged passthru MACVLAN and
> > > its underlying link have the same MAC address and hence (at least by
> > > default) their IPv6 link-local addresses are identical.
> > >
> > > Regards,
> > > Tom
