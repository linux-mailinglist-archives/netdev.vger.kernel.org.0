Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A7630B210
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 22:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbhBAV0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 16:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbhBAV0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 16:26:12 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5E9C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 13:25:31 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id x19so2424565ooj.10
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 13:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UkzplcoaLhtHyb2dvY1rgTTegbOFHFwEFuM2jiWnrw0=;
        b=CBLbZEiBALVJYdNkkGU5m7be7y3ikUymoEQCMdrBHW6iwBCs/MX0tt9xPRuaWjc+5x
         nBV/Q/a5uvGAtSjpvZUbXklnZgzn/JnkRZxH2dSCwSqTIOhG34ZyrYu9mO31JI6z9b8j
         uQbrzp905mU70bP4awugu+7IYhO1ZicRXnaqsurAv8llBHoJ9rpsZXiSSEaVgm9RMAwB
         kcLozXO4sHxRmz9XERVNGLRhSBRb3uBynofhxOxhR28HRd47Fb4kuaOWe4gRPw4MzIHN
         vFBgfC//Vim086/P0Nv9mDJ6GNRm9tPhkyObKL6vGErKnmoTlQkEPNbGYL9lHHaMI9Z8
         a6tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UkzplcoaLhtHyb2dvY1rgTTegbOFHFwEFuM2jiWnrw0=;
        b=UqCcuEILkxEUVr3dIk/BDycE1o7x5FiAWIl0gS+tY5oME91XmZ3bP+vZvh0H/KZ211
         eDcv6yBihgJqokq0dXi9QBLcZtTigiIkl5NcYKtlW2jBqUu0N2+VXJ6+Vr09pyVUUJPQ
         2d4HyFX/GaHFoqISoJjtvp7Bfgl6ZNKlRntI4xQ6hRtUdi5/n38QVlMP9+DFbD51DHtS
         t+vuK0cJsHp8uxshTd6Mu3dKDEyvm0JIuLEngvoeeD7CBeovJe/oyciPKC2/wHHA7sha
         pNY0FqSN+OuAkzyc1n84iMHnvpsBt7ilMz5+G/MGzujMX3zIbXR/ekgECCRyAKK0nebE
         7Ztw==
X-Gm-Message-State: AOAM5334nkcm8H9N7R+131vWpeS0zA9hQa419/FqDNcxn92IBX/CSUNc
        n9XkgRXCCjbDRWn61zZO4F3i3Ersy2SvIue+xg==
X-Google-Smtp-Source: ABdhPJxDRcWL6S8UgYOx3hS1MGjqJM3QyCV7d96LCLYWzMCjDzNNKu70c0J/fqCj4T0QRLiybHfKxs4jiyQt6sMDzBg=
X-Received: by 2002:a4a:450b:: with SMTP id y11mr13152895ooa.36.1612214731256;
 Mon, 01 Feb 2021 13:25:31 -0800 (PST)
MIME-Version: 1.0
References: <20210201140503.130625-1-george.mccollister@gmail.com>
 <20210201140503.130625-5-george.mccollister@gmail.com> <20210201152913.khrvofpnkghrsba2@skbuf>
In-Reply-To: <20210201152913.khrvofpnkghrsba2@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 1 Feb 2021 15:25:19 -0600
Message-ID: <CAFSKS=PKnhfTVb6Wv+bP-Gs6fNq6EVOXo6Ws9sh-bqaG=8sCxg@mail.gmail.com>
Subject: Re: [RESEND PATCH net-next 4/4] net: dsa: xrs700x: add HSR offloading support
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 9:29 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Mon, Feb 01, 2021 at 08:05:03AM -0600, George McCollister wrote:
> > Add offloading for HSR/PRP (IEC 62439-3) tag insertion, tag removal
> > forwarding and duplication supported by the xrs7000 series switches.
> >
> > Only HSR v1 and PRP v1 are supported by the xrs7000 series switches (HS=
R
> > v0 is not).
> >
> > Signed-off-by: George McCollister <george.mccollister@gmail.com>
> > ---
>
> Does this switch discard duplicates or does it not? If it does, what
> algorithm does it use? Does it not need some sort of runtime
> communication with the hsr master, like for the nodes table?
> How many streams can it keep track of? What happens when the ring is
> larger than the switch can keep track of in its internal Link Redundancy
> Entity?

It does discard duplicates.

The datasheet says:
"For HSR frames received from a HSR port, it is first checked if the
source MAC address exists in the MAC address table and if the source
node is located in non-HSR/PRP port. The duplicate detection is then
done by first looking at the stored HSR sequence numbers for the other
HSR redundant port: if one matches with the incoming frame=E2=80=99s HSR Ta=
g=E2=80=99s
sequence number, we have a duplicate. Additionally, it is checked
whether a frame with this same sequence number and source MAC address,
that in from this same port has already been forwarded, in which case
the frame is circulating in the ring/network and has to be deleted. If
the frame is neither duplicate nor circulating, it is forwarded
towards its destination(s)."

The datasheet is publicly available here:
https://www.flexibilis.com/downloads/xrs/SpeedChip_XRS7000_3000_User_Manual=
.pdf

The IEC 62439-3:2016 spec makes it sound like it's the responsibility
of the network designer to make sure it's not possible :
"The maximum time t skewMax between two copies is a network property,
estimated by the
network designer based on the number of bridges and the traffic for a
particular application, e.g. 12 ms."

I don't see how large the table is in the switch. It shows a per model
"HSR proxy node table size" in the datasheet but I think that is just
the table used for the RedBox use case. It also says "Recommended HSR
network size" is up to 512 hops.

The switch does let you change ProxyNodeTableForgetTime (RedBox use
case only I think) and EntryForgetTime in the ADDRESS_AGING register.
The Linux software HSR implementation currently has all of this sort
of thing hardcoded and doesn't implement EntryForgetTime according to
the spec. In the future I can see adding support for this in software
HSR and then later in hardware as well.
