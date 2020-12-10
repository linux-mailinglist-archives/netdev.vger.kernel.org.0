Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C2C2D59A4
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 12:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgLJLuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 06:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728096AbgLJLtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 06:49:46 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF26C0613CF;
        Thu, 10 Dec 2020 03:49:06 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id r9so5201704ioo.7;
        Thu, 10 Dec 2020 03:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uHnLh3RxV8CC7Q4kxdfl/eSu3D4NGdwhj2py/jj4RS8=;
        b=BnM2rbZLFHMtxBFoqU9BlPxRJu2ESXxA61Dw8datybFNBVtDdSRSw+VFO+Urm8vf/R
         VGeND/g66Y7jtK2GOq7Z8ckuB5+QSeiM4jhSmTv2t6ZRxc6UMrj0/EHEBq/YF9pDx/Ud
         wotpk26QiruA6R/C3LxEek6aNH9yIS8KECWTkAm+yizRCtCy8eoA5IIDH6edbOuyBeHZ
         hB6UgGWO5oGnfutTZ4hAg6WKqYh0TLrTAmYKX+RiSxUW7qncKrw15MKT2XNu1z5BZHTe
         THjo7GfFCjk4W3gbZPCU8le2gLnet9IEuMWT7gXMqkGr8q7UqC6P+ll/RIapRe1cHjss
         DxOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uHnLh3RxV8CC7Q4kxdfl/eSu3D4NGdwhj2py/jj4RS8=;
        b=DOp8axp13ctJgTGuctzzIaauTC9mO8usjmNLcJR48jKyGemGiDSewchGHC0PsGPQeI
         r+ABy2P3kMm8GLN3hudIUP1+PNNXe4rpP+XroIqW2geJXBPFwLRDUzmR9k33wJ8uGlnw
         Fx41v4NpvxAXq6v2NqWkPG6H4m9h9+5E5SkfF2XKS17o1vKjc2Lg8w3q6yj58VUNPfpM
         counSljqAlGhf+eYTSZybXVQn0B6KcA+dvB4b0EdjOpQZ+7+5QE61hKKajPLJ6dnOFRb
         +vX5YAXcmG0NC/G8O+5AN6DiQSdKy3FIzsukDeawKzuF/UmnyowpJO0zO1JtanC8GaFE
         l/Qw==
X-Gm-Message-State: AOAM532+yfjYy+X5r7vyZS+oedK4bUAu+RB1PbsU3WgRvZJnjsXRVjFW
        T2aMUTrkulaYjAIdr7hruzN6nH+gZ1NhuU3cI7yPuF1BySk/DRSLgLk=
X-Google-Smtp-Source: ABdhPJxxMYBRUUxSC3cV2YOGczvbnMbPHP6hzRJICuNM+/zMYtUMVcd8SGHkBmFj4YVXc8RI1UZZYv5hEe0q37FYg+c=
X-Received: by 2002:a5e:a614:: with SMTP id q20mr8093353ioi.198.1607600945394;
 Thu, 10 Dec 2020 03:49:05 -0800 (PST)
MIME-Version: 1.0
References: <20201207134309.16762-1-phil@nwl.cc> <CAHsH6Gupw7o96e5hOmaLBCZtqgoV0LZ4L7h-Y+2oROtXSXvTxw@mail.gmail.com>
 <20201208185139.GZ4647@orbyte.nwl.cc> <CAHsH6GvT=Af-BAWK0z_CdrYWPn0qt+C=BRjy10MLRNhLWfH0rQ@mail.gmail.com>
 <9fc5cbb8-26c7-c1c2-2018-3c0cd8c805f4@6wind.com>
In-Reply-To: <9fc5cbb8-26c7-c1c2-2018-3c0cd8c805f4@6wind.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Thu, 10 Dec 2020 13:48:53 +0200
Message-ID: <CAHsH6GsoavW+435MOTKy33iznMc_-JZ-kndr+G=YxuW7DWLNPA@mail.gmail.com>
Subject: Re: [PATCH v2] xfrm: interface: Don't hide plain packets from netfilter
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Phil Sutter <phil@nwl.cc>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nicolas,

On Thu, Dec 10, 2020 at 1:10 PM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
> Le 09/12/2020 =C3=A0 15:40, Eyal Birger a =C3=A9crit :
> > Hi Phil,
> >
> > On Tue, Dec 8, 2020 at 8:51 PM Phil Sutter <phil@nwl.cc> wrote:
> >>
> >> Hi Eyal,
> >>
> >> On Tue, Dec 08, 2020 at 04:47:02PM +0200, Eyal Birger wrote:
> >>> On Mon, Dec 7, 2020 at 4:07 PM Phil Sutter <phil@nwl.cc> wrote:
> [snip]
> >>
> >> The packet appears twice being sent to eth1, the second time as ESP
> >> packet. I understand xfrm interface as a collector of to-be-xfrmed
> >> packets, dropping those which do not match a policy.
> >>
> >>>> Fix this by looping packets transmitted from xfrm_interface through
> >>>> NF_INET_LOCAL_OUT before passing them on to dst_output(), which make=
s
> >>>> behaviour consistent again from netfilter's point of view.
> >>>
> >>> When an XFRM interface is used when forwarding, why would it be corre=
ct
> >>> for NF_INET_LOCAL_OUT to observe the inner packet?
> I think it is valid because:
>  - it would be consistent with ip tunnels (see iptunnel_xmit())

Are you referring to the flow:
  iptunnel_xmit()
    ip_local_out()
      __ip_local_out()
        nf_hook(.., NF_INET_LOCAL_OUT, ...)

If I understand that flow correctly it operates on the outer packet
as it is called after all the header had been pushed already. no?
Or are you referring to a different flow?

>  - it would be consistent with the standard xfrm path see [1]

In the regular path as well I understand the OUTPUT hooks are called
after xfrm encoding in the forwarding case, so they can't see the inner
packet.

>  - from the POV of the forwarder, the packet is locally emitted, the src =
@ is
>    owned by the forwarder.

The inner IP source address is not owned by the forwarder to my understandi=
ng.

> >>
> >> A valid question, indeed. One could interpret packets being forwarded =
by
> >> those tunneling devices emit the packets one feeds them from the local
> >> host. I just checked and ip_vti behaves identical to xfrm_interface
> >> prior to my patch, so maybe my patch is crap and the inability to matc=
h
> >> on ipsec context data when using any of those devices is just by desig=
n.
> There was no real design for vti[6] interfaces, it's why xfrmi interfaces=
 have
> been added. But they should be consistent I think, so this patch should h=
andle
> xfrmi and vti[6] together.

I also think they should be consistent. But it'd still be confusing to me
to get an OUTPUT hook on the inner packet in the forwarding case.

Thanks,
Eyal.
