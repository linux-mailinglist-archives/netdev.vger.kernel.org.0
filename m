Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E4222C537
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 14:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgGXMdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 08:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgGXMdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 08:33:46 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E5AC0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 05:33:45 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id k18so6704221qtm.10
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 05:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pTp/cuCsagszdqbpptuGZ3gObA/aUaemxF5Ly/911xo=;
        b=oOpEOWF+S2RqhU7UiSOwmUQDmrq9JS+oN/0oUqaENhEX9rf6F4b+Oc/QvG/nocud0I
         u7VMANpZokPnRekykjJnHITCQeXETT60ozdMtT+Jcrw8BCs16zybc2muumO6Yywqj9hB
         4EJ5aeppwN+jcpGOvNtjog8MQ/Gz4bns3Qj77KDfHm5o7fT+r28FZIfOTHbsK5T2qhGW
         OaKQPpnCEupj2qjQpyaNC7ZxDUAyGBblUZwop3bNugREngxI6GkNVkFzyv/DvCfc83nx
         ju8hVvnEUXs/tv8JXjvLTO0ttUCOHhLvvbqtJ44eBhBrF28pnMA02gT7zPxnBsfDA+Ao
         wTUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pTp/cuCsagszdqbpptuGZ3gObA/aUaemxF5Ly/911xo=;
        b=ualFZ6UNQQqBB3j6hTLfvq1i28F7NImWkOpAUYf0yMpDWWummzFMM9EJtAK2uKJtM2
         E4sxiTtPizi5OIAzVIuqPx655GfI6CR9sNlk7Csm7ktZDn2VhMwmC+7wmxgRgp74Yt2A
         2+D+4rpy3IfVkt9mv7rUsTYMEEvZeESIDHcNiVITno8tDXeBB09AK03URbznskQt8aHK
         4GR7e9DwcHAxROfvmRulL/2Zjrq7mWLWQOvyfDp/bc9qdrqToHFS6xW8bUrBFQoCQ2vQ
         1ka3InWSwBw8TSkbSksf71/DeSYo1Id6FWziIwCRnRSBj0RghlmGbqGe7HAJNqsiDKU4
         1c7Q==
X-Gm-Message-State: AOAM530bDo1vmJupdWTyYQOokq/yPt43hD+aUuR3+VoIdGnVfvvhlgzP
        VilNqnG+1nQWvyqJMTagz78aOu+77fbds5SznCc=
X-Google-Smtp-Source: ABdhPJxxSq7Ndm/EZKzIketFr1RXGWh6ZgV36mdzW07TmLiW21wbSUqwVFUOv3tADGEIefahwUo49rStDxeYRwHqftw=
X-Received: by 2002:aed:2ca5:: with SMTP id g34mr8991357qtd.337.1595594024790;
 Fri, 24 Jul 2020 05:33:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAA85sZvKNXCo5bB5a6kKmsOUAiw+_daAVaSYqNW6QbSBJ0TcyQ@mail.gmail.com>
 <CAA85sZua6Q8UR7TfCGO0bV=VU0gKtqj-8o_mqH38RpKrwYZGtg@mail.gmail.com>
 <20200715133136.5f63360c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAA85sZu09Z4gydJ8rAO_Ey0zqx-8Lg28=fBJ=FxFnp6cetNd3g@mail.gmail.com>
 <CAA85sZtjCW2Yg+tXPgYyoFA5BKAVZC8kVKG=6SiR64c8ur8UcQ@mail.gmail.com>
 <20200715144017.47d06941@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAA85sZvnytPzpia_ROnkmJoZC8n4vUsrwTQh2UBs6u6g2Fgqxw@mail.gmail.com>
 <CAKgT0UdwsmE=ygE2KObzM0z-0KgrPcr59JZzVk41F6-iqsSL+Q@mail.gmail.com>
 <CAA85sZturDN7uOHMDhUnntM43PHjop=TNDb4qvEA2L=jdRa1MA@mail.gmail.com>
 <CAKgT0Uf42EhnM+zPSb-oL1R8hmo0vEdssGztptbkWKoHXS7ygw@mail.gmail.com>
 <CAA85sZtHNkocj840i0ohMVekh0B4byuojU02UunK_bR+LB1WiQ@mail.gmail.com>
 <CAKgT0UdDjabvShwDv0qiume=Q2RKGkm3JhPMZ+f8v5yO37ZLxA@mail.gmail.com>
 <CAA85sZt6B+rG8pUfRoNVOH=VqHn=rT-+2kHpFDzW+eBwvODxJA@mail.gmail.com>
 <CAKgT0UfhMjZ6kZSkfpEVHBbQ+4eHQqWRbXk5Sm4nLQD6sSrj0A@mail.gmail.com>
 <CAA85sZs5D_ReOhsEv1SVbE5D8q77utNBZ=Uv34PVof9gHs9QWw@mail.gmail.com> <CAA85sZvi4x1zc_21a6zPJw0rELOY=RCV4W7Fi4fvcSXfy-6m4g@mail.gmail.com>
In-Reply-To: <CAA85sZvi4x1zc_21a6zPJw0rELOY=RCV4W7Fi4fvcSXfy-6m4g@mail.gmail.com>
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Fri, 24 Jul 2020 14:33:33 +0200
Message-ID: <CAA85sZvMjcRnuECtFBDKKAG3q2MGeytsxPx8RR-M4hSxruj5Vw@mail.gmail.com>
Subject: Re: [Intel-wired-lan] NAT performance issue 944mbit -> ~40mbit
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 2:01 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:
>
> On Fri, Jul 17, 2020 at 3:45 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:

[--8<--]

> As a side note, would something like this fix it - not even compile tested
>
>
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c
> b/drivers/net/ethernet/intel/igb/igb_main.c
> index 8bb3db2cbd41..1a7240aae85c 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -3396,6 +3396,13 @@ static int igb_probe(struct pci_dev *pdev,
> const struct pci_device_id *ent)
>                           "Width x2" :
>                           (hw->bus.width == e1000_bus_width_pcie_x1) ?
>                           "Width x1" : "unknown"), netdev->dev_addr);
> +               /* quirk */
> +#ifdef CONFIG_PCIEASPM
> +               if (hw->bus.width == e1000_bus_width_pcie_x1) {
> +                       /* single lane pcie causes problems with ASPM */
> +                       pdev->pcie_link_state->aspm_enabled = 0;
> +               }
> +#endif
>         }
>
>         if ((hw->mac.type >= e1000_i210 ||
>
> I don't know where the right place to put a quirk would be...

Ok so that was a real brainfart... turns out that there is a lack of
good ways to get to that but it was more intended to
know where the quirk should go...

Due to the lack of api:s i started wondering if this will apply to
more devices than just network cards - potentially we could
be a little bit more selective and only not enable it in one direction but...

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index b17e5ffd31b1..96a3c6837124 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -584,15 +584,16 @@ static void pcie_aspm_cap_init(struct
pcie_link_state *link, int blacklist)
         * given link unless components on both sides of the link each
         * support L0s.
         */
-       if (dwreg.support & upreg.support & PCIE_LINK_STATE_L0S)
-               link->aspm_support |= ASPM_STATE_L0S;
-       if (dwreg.enabled & PCIE_LINK_STATE_L0S)
-               link->aspm_enabled |= ASPM_STATE_L0S_UP;
-       if (upreg.enabled & PCIE_LINK_STATE_L0S)
-               link->aspm_enabled |= ASPM_STATE_L0S_DW;
-       link->latency_up.l0s = calc_l0s_latency(upreg.latency_encoding_l0s);
-       link->latency_dw.l0s = calc_l0s_latency(dwreg.latency_encoding_l0s);
-
+       if (pcie_get_width_cap(child) != PCIE_LNK_X1) {
+               if (dwreg.support & upreg.support & PCIE_LINK_STATE_L0S)
+                       link->aspm_support |= ASPM_STATE_L0S;
+               if (dwreg.enabled & PCIE_LINK_STATE_L0S)
+                       link->aspm_enabled |= ASPM_STATE_L0S_UP;
+               if (upreg.enabled & PCIE_LINK_STATE_L0S)
+                       link->aspm_enabled |= ASPM_STATE_L0S_DW;
+               link->latency_up.l0s =
calc_l0s_latency(upreg.latency_encoding_l0s);
+               link->latency_dw.l0s =
calc_l0s_latency(dwreg.latency_encoding_l0s);
+       }

this time it's compile tested...

It could also be  if (pcie_get_width_cap(child) > PCIE_LNK_X1) {

I assume that ASPM is not enabled for: PCIE_LNK_WIDTH_RESRV ;)
