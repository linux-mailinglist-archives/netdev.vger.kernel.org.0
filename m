Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6059E47803A
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 23:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbhLPW73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 17:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbhLPW73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 17:59:29 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EB1C061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 14:59:28 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id o1so1085521uap.4
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 14:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wRN6ctqfJu07LFQgpR9yoDGI7H+H4potHhtu0qRWigo=;
        b=XawKOgSZQCZyyTEPVSOhJxt8nbh5TUWtM+LlLKX30HsdgaExKSnW8/FusXGiXfAb11
         ehoirax81rss5xB99wqoig137Jbe89I9YGaUE61ztK+s1EwW/preoc68B6SCUZ7g9NCR
         Ae9NM0XFaX9O0QoFH4SCGvnRa3B/2wGb69CCyilNJo+oBc+kfmCRz4VmYScI3nJAfzkS
         7w+vMFlIcec+zkBGrU69+4w8r4mmB7QE0TfWda1Nx4lEVQByC8VHXcOfbA69VWabcaxn
         boQA3F0tQbYokF6fJ9Pjms5x9FLgoc0Lt4Ct5MIBRSPFy4hY2ijEWo6wL8c/gUFK4v5w
         4TOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wRN6ctqfJu07LFQgpR9yoDGI7H+H4potHhtu0qRWigo=;
        b=BhSzYNRFqGH1Muo2sgUQP9NcqHkZF2Kub/wCEXKuiE/5bdMWRnHzURHcSlm3pGYDqj
         m9kmRvH2tGkHiPf0BGfjY3Wn4hHuybmwAJcG0u8riejoRhZAQWHZYb9yvs91NJQXzNEE
         lOzl0fa8XjC/7B0/5OBNrtUhkU2YGQtVrQocONF7miiJvh+uG5VfncnClHIDNjA7fE+q
         0MngzEMQea3rYf93MtJPh/trXARYxmvymyyr1MF+zSqYBrJmWuxtqW6oCwf0+9W0cq5P
         cgoV/7Qk1A20U5S4udbF7+g/3JxOmexIfpIrTGpzgDHTsy99gqs7MoNaHLOvvZlXUV7K
         tCDw==
X-Gm-Message-State: AOAM530WCuGIJmxxdkoiqkD5fQJ1vlACByx2E6QSLshudPJUg/U5ttKQ
        IL+mjFg2fCbccGDb9d4j9R9lePTS1Bk=
X-Google-Smtp-Source: ABdhPJwcplYKDF5Z16YATQUSIGzMa5hrM5dgsMY3aCH/FLrcz2M4tC2uzFvp+yzLNAKOSE1VkgJ/dQ==
X-Received: by 2002:a67:ed8e:: with SMTP id d14mr61614vsp.33.1639695567995;
        Thu, 16 Dec 2021 14:59:27 -0800 (PST)
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com. [209.85.222.42])
        by smtp.gmail.com with ESMTPSA id i62sm338144vke.33.2021.12.16.14.59.26
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 14:59:27 -0800 (PST)
Received: by mail-ua1-f42.google.com with SMTP id w23so1075053uao.5
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 14:59:26 -0800 (PST)
X-Received: by 2002:a05:6102:31b3:: with SMTP id d19mr60954vsh.79.1639695566536;
 Thu, 16 Dec 2021 14:59:26 -0800 (PST)
MIME-Version: 1.0
References: <20211215201158.271976-1-kafai@fb.com> <CA+FuTSdR0yPwXAZZjziGOeujJ_Ac19fX1DsqfRXX3Dsn1uFPAQ@mail.gmail.com>
 <20211216222332.fltkclu4x3udpomr@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20211216222332.fltkclu4x3udpomr@kafai-mbp.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 16 Dec 2021 17:58:49 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfsrMUAz-5Huf2j4f35ttqO5gpFKvsn4uJLXtRPqEaKEg@mail.gmail.com>
Message-ID: <CA+FuTSfsrMUAz-5Huf2j4f35ttqO5gpFKvsn4uJLXtRPqEaKEg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 net-next] net: Preserve skb delivery time during forward
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > @@ -530,7 +538,14 @@ struct skb_shared_info {
> > >         /* Warning: this field is not always filled in (UFO)! */
> > >         unsigned short  gso_segs;
> > >         struct sk_buff  *frag_list;
> > > -       struct skb_shared_hwtstamps hwtstamps;
> > > +       union {
> > > +               /* If SKBTX_DELIVERY_TSTAMP is set in tx_flags,
> > > +                * tx_delivery_tstamp is stored instead of
> > > +                * hwtstamps.
> > > +                */
> >
> > Should we just encode the timebase and/or type { timestamp,
> > delivery_time } in th lower bits of the timestamp field? Its
> > resolution is higher than actual clock precision.
> In skb->tstamp ?

Yes. Arguably a hack, but those bits are in the noise now, and it
avoids the clone issue with skb_shinfo (and scarcity of flag bits
there).

> >
> > is non-zero skb->tstamp test not sufficient, instead of
> > SKBTX_DELIVERY_TSTAMP_ALLOW_FWD.
> >
> > It is if only called on the egress path. Is bpf on ingress the only
> > reason for this?
> Ah. ic.  meaning testing non-zero skb->tstamp and then call
> skb_save_delivery_time() only during the veth-egress-path:
> somewhere in veth_xmit() => veth_forward_skb() but before
> skb->tstamp was reset to 0 in __dev_forward_skb().

Right. If delivery_time is the only use of skb->tstamp on egress, and
timestamp is the only use on ingress, then the only time the
delivery_time needs to be cached if when looping from egress to
ingress and this field is non-zero.

>
> Keep *_forward() and bpf_out_*() unchanged (i.e. keep skb->tstamp = 0)
> because the skb->tstamp could be stamped by net_timestamp_check().
>
> Then SKBTX_DELIVERY_TSTAMP_ALLOW_FWD is not needed.
>
> Did I understand your suggestion correctly?

I think so.

But the reality is complicated if something may be setting a delivery
time on ingress (a BPF filter?)
>
> However, we still need a bit to distinguish tx_delivery_tstamp
> from hwtstamps.
>
> >
> > > +{
> > > +       if (skb_shinfo(skb)->tx_flags & SKBTX_DELIVERY_TSTAMP_ALLOW_FWD) {
> > > +               skb_shinfo(skb)->tx_delivery_tstamp = skb->tstamp;
> > > +               skb_shinfo(skb)->tx_flags |= SKBTX_DELIVERY_TSTAMP;
> > > +               skb_shinfo(skb)->tx_flags &= ~SKBTX_DELIVERY_TSTAMP_ALLOW_FWD;
> > > +       }
> >
> > Is this only called when there are no clones/shares?
> No, I don't think so.  TCP clone it.  I also started thinking about
> this after noticing a mistake in the change in  __tcp_transmit_skb().
>
> There are other places that change tx_flags, e.g. tcp_offload.c.
> It is not shared at those places or there is some specific points
> in the stack that is safe to change ?

The packet probably is not yet shared. Until the TCP stack gives a
packet to the IP layer, it can treat it as exclusive.

Though it does seem that these fields are accessed in a possibly racy
manner. Drivers with hardware tx timestamp offload may set
skb_shinfo(orig_skb)->tx_flags & SKBTX_IN_PROGRESS without checking
whether the skb may be cloned.
