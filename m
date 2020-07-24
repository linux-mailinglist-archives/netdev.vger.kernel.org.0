Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60D722C894
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 16:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgGXO5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 10:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgGXO5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 10:57:11 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50103C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 07:57:11 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id d18so10094775ion.0
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 07:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9Is/bQU4jwdWiMgDyl2swKgH/chVCW6A8VnlLnJKb7Q=;
        b=WbKKW8VaBguWRdFxe/2VttlkaMH2yFn4VgV/GpD1Egi/0Xpwf9BnkLalbA2cMYna+e
         B4OGR9+pRPWfAu7GoJeE414mJRjZVOZ1FP/9GjPMIiILDXxeoJn8zuP7CdZASYmudOsu
         0SOL6mnXGRU4+IPGkcsb1buH4MLKey8bn9GX/srV5fZ+W/AFaGIitjBPFUkwo194u7F/
         dRvF4XuHGvvslW0OBJ9JFcIR8MqdPf+lSCpfhhbjoQ9Vw5VXkAB3t+r780hmSXCEb7pt
         3/xDDO0ovv1M+hHz6nWEJQ7Se1vwCUkbCvQa8Rh4lQ9vDIvdF/6V0ri8rQ2o/pG7U5pN
         iCRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9Is/bQU4jwdWiMgDyl2swKgH/chVCW6A8VnlLnJKb7Q=;
        b=izoh87Lt9leSoaZvB5Gx45W+xvGQRq8/Y4/KHycAhCeIwT+lTfzV5kjuHbDf3QYkZD
         7cjS3Cs8/uNB/nOWfSJfEDDN2E5I6aUi+8AIBuW1uvIZqQiVHbNDGc9YRFe7aMAo4Tg4
         rN0CNPbsCT6gym2yq5B2JnG16hvjMJ4r2xuNQLH9mCA2suQ6I477jrlb8FGkftznyaVg
         Og68qoMp45WR30EUYI6WjYZ8a/41t4GLLa6pNVyZq0/qw6YK8bpBjF92Po41ew+M/ym6
         GvcspAqDIXkd5IgV3vVjHi38Z/6jLBeszWCrMMCW2G0rqdNQoxjGSd01I/L44w6StXRW
         P6XQ==
X-Gm-Message-State: AOAM531Bf25Zo3QYu51/CmSI0EK/x/T6ieaOOjsyqWw/9xGOpDXvKYba
        l/ruQkbrlbty7dFBVP6S0AoK3v8RXmkKgtGhJpE=
X-Google-Smtp-Source: ABdhPJyjlNDt7uExZF2t7cXDl7epsmq1nThUX3pQoXUTrc2q3q8iP/DVvi8nH77f+uffLnoy3pn4Y8fksH8sQQWxcd8=
X-Received: by 2002:a5d:8d04:: with SMTP id p4mr10853314ioj.187.1595602630451;
 Fri, 24 Jul 2020 07:57:10 -0700 (PDT)
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
 <CAA85sZs5D_ReOhsEv1SVbE5D8q77utNBZ=Uv34PVof9gHs9QWw@mail.gmail.com>
 <CAA85sZvi4x1zc_21a6zPJw0rELOY=RCV4W7Fi4fvcSXfy-6m4g@mail.gmail.com> <CAA85sZvMjcRnuECtFBDKKAG3q2MGeytsxPx8RR-M4hSxruj5Vw@mail.gmail.com>
In-Reply-To: <CAA85sZvMjcRnuECtFBDKKAG3q2MGeytsxPx8RR-M4hSxruj5Vw@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 24 Jul 2020 07:56:59 -0700
Message-ID: <CAKgT0UfcPfNJCP=nT59t4RRwL3T8cQ5dnXeEgW1QXBG24fo-Cg@mail.gmail.com>
Subject: Re: [Intel-wired-lan] NAT performance issue 944mbit -> ~40mbit
To:     Ian Kumlien <ian.kumlien@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 5:33 AM Ian Kumlien <ian.kumlien@gmail.com> wrote:
>
> On Fri, Jul 24, 2020 at 2:01 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:
> >
> > On Fri, Jul 17, 2020 at 3:45 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:
>
> [--8<--]
>
> > As a side note, would something like this fix it - not even compile tested
> >
> >
> > diff --git a/drivers/net/ethernet/intel/igb/igb_main.c
> > b/drivers/net/ethernet/intel/igb/igb_main.c
> > index 8bb3db2cbd41..1a7240aae85c 100644
> > --- a/drivers/net/ethernet/intel/igb/igb_main.c
> > +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> > @@ -3396,6 +3396,13 @@ static int igb_probe(struct pci_dev *pdev,
> > const struct pci_device_id *ent)
> >                           "Width x2" :
> >                           (hw->bus.width == e1000_bus_width_pcie_x1) ?
> >                           "Width x1" : "unknown"), netdev->dev_addr);
> > +               /* quirk */
> > +#ifdef CONFIG_PCIEASPM
> > +               if (hw->bus.width == e1000_bus_width_pcie_x1) {
> > +                       /* single lane pcie causes problems with ASPM */
> > +                       pdev->pcie_link_state->aspm_enabled = 0;
> > +               }
> > +#endif
> >         }
> >
> >         if ((hw->mac.type >= e1000_i210 ||
> >
> > I don't know where the right place to put a quirk would be...
>
> Ok so that was a real brainfart... turns out that there is a lack of
> good ways to get to that but it was more intended to
> know where the quirk should go...
>
> Due to the lack of api:s i started wondering if this will apply to
> more devices than just network cards - potentially we could
> be a little bit more selective and only not enable it in one direction but...
>
> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> index b17e5ffd31b1..96a3c6837124 100644
> --- a/drivers/pci/pcie/aspm.c
> +++ b/drivers/pci/pcie/aspm.c
> @@ -584,15 +584,16 @@ static void pcie_aspm_cap_init(struct
> pcie_link_state *link, int blacklist)
>          * given link unless components on both sides of the link each
>          * support L0s.
>          */
> -       if (dwreg.support & upreg.support & PCIE_LINK_STATE_L0S)
> -               link->aspm_support |= ASPM_STATE_L0S;
> -       if (dwreg.enabled & PCIE_LINK_STATE_L0S)
> -               link->aspm_enabled |= ASPM_STATE_L0S_UP;
> -       if (upreg.enabled & PCIE_LINK_STATE_L0S)
> -               link->aspm_enabled |= ASPM_STATE_L0S_DW;
> -       link->latency_up.l0s = calc_l0s_latency(upreg.latency_encoding_l0s);
> -       link->latency_dw.l0s = calc_l0s_latency(dwreg.latency_encoding_l0s);
> -
> +       if (pcie_get_width_cap(child) != PCIE_LNK_X1) {
> +               if (dwreg.support & upreg.support & PCIE_LINK_STATE_L0S)
> +                       link->aspm_support |= ASPM_STATE_L0S;
> +               if (dwreg.enabled & PCIE_LINK_STATE_L0S)
> +                       link->aspm_enabled |= ASPM_STATE_L0S_UP;
> +               if (upreg.enabled & PCIE_LINK_STATE_L0S)
> +                       link->aspm_enabled |= ASPM_STATE_L0S_DW;
> +               link->latency_up.l0s =
> calc_l0s_latency(upreg.latency_encoding_l0s);
> +               link->latency_dw.l0s =
> calc_l0s_latency(dwreg.latency_encoding_l0s);
> +       }
>
> this time it's compile tested...
>
> It could also be  if (pcie_get_width_cap(child) > PCIE_LNK_X1) {
>
> I assume that ASPM is not enabled for: PCIE_LNK_WIDTH_RESRV ;)

This is probably a bit too broad of a scope to be used generically
since this will disable ASPM for all devices that have a x1 link
width.

It might make more sense to look at something such as
e1000e_disable_aspm as an example of how to approach this.

As far as what triggers it we would need to get more details about the
setup. I'd be curious if we have an "lspci -vvv" for the system
available. The assumption is that the ASPM exit latency is high on
this system and that in turn is causing the bandwidth issues as you
start entering L1. If I am not mistaken the device should advertise
about 16us for the exit latency. I'd be curious if we have a device
somewhere between the NIC and the root port that might be increasing
the delay in exiting L1, and then if we could identify that we could
add a PCIe quirk for that.

Thanks.

- Alex
