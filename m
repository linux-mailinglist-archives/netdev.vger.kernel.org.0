Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9FF30C27A
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 15:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234830AbhBBOvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 09:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234842AbhBBOuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 09:50:25 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2B9C06174A
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 06:49:38 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id w124so22976111oia.6
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 06:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LmMtkLc07tNtP4mPC/mEBjxQBydUoyeDbjN2yatnjVU=;
        b=mw7EySKkc/Y3qX7k7/Aqiorr4Lt41YxZIRXhJN3IyzI0Dgu6Uyeid0/3mfoFYu+cWm
         BikWcJtY70nbZ1593dnp8R2wvJHSvnG64pQ3Kp/0hdsri0EEWwL1zCffR0E+5jxlGgXh
         kC0UCR58GiHmDGYMAw45CwkYQ+x0uro5TvCjn7etzSEG7vbmvxto0pKMnTGb6D2El/Ti
         gHu4gw07ISzZsjg/BYpVWuPHbegwGQbeFPXS7NJ01MJFULHcghPgAbQmmwFYgHhTvGs6
         ypwKzTMVnTpV2TRVD/JzqSzuGEcOBOjSJMfrFyOAs9KpOIgIe6G18q1Gt5eL94Cb57ww
         bxEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LmMtkLc07tNtP4mPC/mEBjxQBydUoyeDbjN2yatnjVU=;
        b=cgRdoezPeCoDxzfvJEUFWGZNsUjeflCEwswPw/+U6Rbv7aNMKpLz0C0jz8jsSiiVJw
         YWLcKbza17702I1Xshd4rq3fh7JU/x8znxLSgu0zCAOZiXSoKsevshmMM9UVxuerT3+D
         SvPcibkgyqCLgL3CBNt+gWNWXSIDX+uqoQxYHLT9EhiUiXETNf8kqS8o7ZjlJcmh6P/M
         miKuiF9zOwl0ht3YQpb1YHm2OBqd9T98CE/kkkaV8kh8m4X4HYobInDjkLABXdTUy8VJ
         qyNuJdjmF3r568eNkhrh/XbgXtFivfiBnKdwH4iwVNpBuAcRl3bKcRCF2Jwjz4keBfbk
         Q31A==
X-Gm-Message-State: AOAM530g06dU5jsQPHBd82Ldr8w6bUMzhHBLsgBGCpd9q1NawAiJ29BH
        cyAXBhVUeoHzSlaJK9THTyS77D2ETMQV9tO9tWqUgSRenyMe
X-Google-Smtp-Source: ABdhPJx1CH1kYJnhxFMpEoWx6fmi0WenEN2WQI8t07V2woJyeaNSQ6aoLW4r6OdoQzALCX+aZ5gBT52RYHPkM7Pn+Xs=
X-Received: by 2002:a05:6808:a91:: with SMTP id q17mr2750610oij.122.1612277378029;
 Tue, 02 Feb 2021 06:49:38 -0800 (PST)
MIME-Version: 1.0
References: <20210201140503.130625-1-george.mccollister@gmail.com>
 <20210201140503.130625-2-george.mccollister@gmail.com> <20210201145943.ajxecwnhsjslr2uf@skbuf>
 <CAFSKS=OR6dXWXdRTmYToH7NAnf6EiXsVbV_CpNkVr-z69vUz-g@mail.gmail.com> <20210202003729.oh224wtpqm6bcse3@skbuf>
In-Reply-To: <20210202003729.oh224wtpqm6bcse3@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Tue, 2 Feb 2021 08:49:25 -0600
Message-ID: <CAFSKS=MhuJtuXGDQHU_5w+AVf9DqdNh=zioJoZOuOYF5Jat-eQ@mail.gmail.com>
Subject: Re: [RESEND PATCH net-next 1/4] net: hsr: generate supervision frame
 without HSR tag
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 6:37 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Mon, Feb 01, 2021 at 01:43:43PM -0600, George McCollister wrote:
> > > > diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
> > > > index ab953a1a0d6c..161b8da6a21d 100644
> > > > --- a/net/hsr/hsr_device.c
> > > > +++ b/net/hsr/hsr_device.c
> > > > @@ -242,8 +242,7 @@ static struct sk_buff *hsr_init_skb(struct hsr_port *master, u16 proto)
> > > >        * being, for PRP it is a trailer and for HSR it is a
> > > >        * header
> > > >        */
> > > > -     skb = dev_alloc_skb(sizeof(struct hsr_tag) +
> > > > -                         sizeof(struct hsr_sup_tag) +
> > > > +     skb = dev_alloc_skb(sizeof(struct hsr_sup_tag) +
> > > >                           sizeof(struct hsr_sup_payload) + hlen + tlen);
> > >
> > > Question 1: why are you no longer allocating struct hsr_tag (or struct prp_rct,
> > > which has the same size)?
> >
> > Because the tag is no longer being included in the supervisory frame
> > here. If I understand correctly hsr_create_tagged_frame and
> > prp_create_tagged_frame will create a new skb with HSR_HLEN added
> > later.
>
> I'm mostly doing static analysis of the code, which makes everything
> more difficult and also my review more inaccurate. I'll try to give your
> patches more testing when reviewing further, but I just got stuck into
> trying to understand them first.

I don't blame you at all. I've spent hours (maybe an understatement)
looking at the hsr code. Reviewing this patch without already being
familiar with the code or the standard would be very daunting.

>
> So your change makes fill_frame_info classify supervision frames as
> skb_std instead of skb_hsr or skb_prp. The tag is added only in
> hsr_create_tagged_frame right before dispatch to the egress port.
>
> But that means that there are places like for example
> hsr_handle_sup_frame which clearly don't like that: it checks whether
> there's a tagged skb in either frame->skb_hsr or frame->skb_prp, but not
> in frame->skb_std, so it now does basically nothing.
>
> Don't we need hsr_handle_sup_frame?

This part of the hsr code is very confusing and gave me problems at
first. Everywhere in the hsr_forward_do loop port is the destination
port. When it checks port->type == HSR_PT_MASTER before calling
hsr_handle_sup_frame it is checking for supervisory frames going to
the master port not from it. That is to say hsr_handle_sup_frame is
only called on incoming supervisory frames. This patch only addresses
generation of supervisory frames, that is to say outgoing supervisory
frames.

I may need to address this in the next patch for the case when removal
of the hsr/prp tag is offloaded on incoming frames.

>
> > > In hsr->proto_ops->fill_frame_info in the call path above, the skb is
> > > still put either into frame->skb_hsr or into frame->skb_prp, but not
> > > into frame->skb_std, even if it does not contain a struct hsr_tag.
> >
> > Are you sure? My patch changes hsr_fill_frame_info and
> > prp_fill_frame_info not to do that if port->type is HSR_PT_MASTER
> > which I'm pretty certain it always is when sending supervisory frames
> > like this. If I've overlooked something let me know.
>
> You're right, I had figured it out myself in the comment below where I
> called it a kludge.
>
> > >
> > > Also, which code exactly will insert the hsr_tag later? I assume
> > > hsr_fill_tag via hsr->proto_ops->create_tagged_frame?
> >
> > Correct.
>
> I think it's too late, see above.

I'm not saying it's impossible I missed something but I did test this
code pretty well with HSR v1 with and without offload on a ring with a
Moxa PT-G503. I even inspected everything on the wire to make sure it
was correct. I tested PRP as well though now I can't remember if I
inspected it on the wire so I'll make sure to check it again before
sending the next patch version.

>
> > > > -     if (!hsr->prot_version)
> > > > -             proto = ETH_P_PRP;
> > > > -     else
> > > > -             proto = ETH_P_HSR;
> > > > -
> > > > -     skb = hsr_init_skb(master, proto);
> > > > +     skb = hsr_init_skb(master, ETH_P_PRP);
> > >
> > > Question 2: why is this correct, setting skb->protocol to ETH_P_PRP
> > > (HSR v0) regardless of prot_version? Also, why is the change necessary?
> >
> > This part is not intuitive and I don't have a copy of the documents
> > where v0 was defined. It's unfortunate this code even supports v0
> > because AFAIK no one else uses it; but it's in here so we have to keep
> > supporting it I guess.
> > In v1 the tag has an eth type of 0x892f and the encapsulated
> > supervisory frame has a type of 0x88fb. In v0 0x88fb is used for the
> > eth type and there is no encapsulation type. So... this is correct
> > however I compared supervisory frame generation before and after this
> > patch for v0 and I found a problem. My changes make it add 0x88fb
> > again later for v0 which it's not supposed to do. I'll have to fix
> > that part somehow.
>
> Step 1: Sign up for HSR maintainership, it's currently orphan
> Step 2: Delete HSRv0 support
> Step 3: See if anyone shouts, probably not
> Step 4: Profit.

not a bad idea however user space defaults to using v0 when doing:
ip link add name hsr0 type hsr slave1 eth0 slave2 eth1

To use v1 you need to append "version 1".

It seems like it might be a hard sell to break the userspace default
even if no one in their right mind is using it. Still think it's
possible?

>
> > >
> > > Why is it such a big deal if supervision frames have HSR/PRP tag or not?
> >
> > Because if the switch does automatic HSR/PRP tag insertion it will end
> > up in there twice. You simply can't send anything with an HSR/PRP tag
> > if this is offloaded.
>
> When exactly will your hardware push a second HSR tag when the incoming
> packet already contains one? Obviously for tagged packets coming from
> the ring it should not do that. It must be treating the CPU port special
> somehow, but I don't understand how.

From the datasheet I linked before:
"At input the HSR tag is always removed if the port is in HSR mode. At
output a HSR tag is added if the output port is in HSR mode."
I don't see a great description of what happens internally when it's
forwarding from one redundant port to the other when in HSR (not PRP)
but perhaps it strips off the tag information, saves it and reapplies
it as it's going out? The redundant ports are in HSR mode, the CPU
facing port is not. Anyway I can tell you from using it, it does add a
second HSR tag if the CPU port sends a frame with one and the frames
going between the ring redundancy ports are forwarded with their
single tag.
