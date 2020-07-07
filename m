Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763072168B2
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 10:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbgGGI7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 04:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgGGI7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 04:59:13 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409B7C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 01:59:13 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z2so22028472wrp.2
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 01:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cVIGLxF0sjz3zGAJOajLRy+1JXOiAneaa75awUx2Ts0=;
        b=k9z/Tel/dQS6Kl0Qn8stq7Sitlj3b0TJIqDT6gskcbS4a8Ay6/QMBP8v2JrZyyu7Ef
         sg78EIAsqWL+HMhFfCmnu+0DblQX4FdIACBqLQNFU1N+M76J1u9hvC/xRv9jhQ56ZOhP
         ZgxwthUtznMntjzl8WwN55xfKr5BnTFC91gp8kgq9fan/YgKHgqOqNu5f1lGVYVd4IYB
         5KtngENmqdYmuBCLdrZkM+PPV/QoTHN+Ur23nGAQdSeDnrb0YVoijGrC1Wv+1kGs+mov
         2aQC5PoiyixO02VxOv3C5Nqrn3Ib1gAcNNHc/cos1sGtLH0l8FUD0kLhZ1HWlq2buhHR
         eYRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cVIGLxF0sjz3zGAJOajLRy+1JXOiAneaa75awUx2Ts0=;
        b=Z0E4MKVQzw4foq9e5hnJMcf1SS5V9NUeHydSsdkUlbe6pZShUd3Ru6z1hxmwP1MYbo
         d2d3aHi/NEZ6o2SktTF+RlNqFEoMCGNXl3KksR4DoyQ9xpeVJEj56YK1cVC7w8x+CQeV
         Pp6A1tkwis8s+OPN+sBdxHup2IhNw2p27ZzY/mvS08afLQFQKRx5h99YS2qet7Xqs6xw
         WJKICBPmVwNY9rzKhrfvWtePvJlCLVhNgbCal1oJntdH9sUN1ou1Mf6BPLIz8gl1dL0A
         ScbOtpEeteqzAXuQjYEPMx4eprFpdlZbuLEQ4jGf9/LW/nX3UxO5yiJpvrpvJYYtD80+
         Vtbw==
X-Gm-Message-State: AOAM533WVIG1oK8uApu01zg1DBu3C6ne9QX93bdwp2IiFjU/LbqQJjar
        vBD/7/Q3tbZDtLBbbyCp0q+VbssZPVxI44Rix8s=
X-Google-Smtp-Source: ABdhPJwtHjBXN5yfp6YuxOvXIfk6E9YKF00LcL9SnrBYS8g+c8WDfxAJc1hqkNw9xZ3HaxBh0Y4xl98pj/PDbl9lLHY=
X-Received: by 2002:adf:ec88:: with SMTP id z8mr52683810wrn.395.1594112351964;
 Tue, 07 Jul 2020 01:59:11 -0700 (PDT)
MIME-Version: 1.0
References: <4aaead9f8306859eb652b90582f23295792e9d15.1593497708.git.lucien.xin@gmail.com>
 <d510d172-c605-725d-e6bc-e6462a3718ab@strongswan.org> <CADvbK_cQBbFwYj_CYTm69LP8a7R3PsS=nr0MyfRjAcASVz=dhQ@mail.gmail.com>
 <20200707061719.GV19286@gauss3.secunet.de>
In-Reply-To: <20200707061719.GV19286@gauss3.secunet.de>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 7 Jul 2020 17:09:00 +0800
Message-ID: <CADvbK_fvH7uAO3OWS5tQTOEF0hP+o+g45KKKn=6oDtWvKuZmNQ@mail.gmail.com>
Subject: Re: [PATCH ipsec] xfrm: state: match with both mark and mask on user interfaces
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Tobias Brunner <tobias@strongswan.org>,
        network dev <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <hadi@cyberus.ca>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>, pwouters@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 2:17 PM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Mon, Jul 06, 2020 at 04:33:53PM +0800, Xin Long wrote:
> > >
> > > > @@ -1051,7 +1061,6 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> > > >       int acquire_in_progress = 0;
> > > >       int error = 0;
> > > >       struct xfrm_state *best = NULL;
> > > > -     u32 mark = pol->mark.v & pol->mark.m;
> > > >       unsigned short encap_family = tmpl->encap_family;
> > > >       unsigned int sequence;
> > > >       struct km_event c;
> > > > @@ -1065,7 +1074,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> > > >       hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h, bydst) {
> > > >               if (x->props.family == encap_family &&
> > > >                   x->props.reqid == tmpl->reqid &&
> > > > -                 (mark & x->mark.m) == x->mark.v &&
> > > > +                 (pol->mark.v == x->mark.v && pol->mark.m == x->mark.m) &&
> > > >                   x->if_id == if_id &&
> > > >                   !(x->props.flags & XFRM_STATE_WILDRECV) &&
> > > >                   xfrm_state_addr_check(x, daddr, saddr, encap_family) &&
> > > > @@ -1082,7 +1091,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> > > >       hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h_wildcard, bydst) {
> > > >               if (x->props.family == encap_family &&
> > > >                   x->props.reqid == tmpl->reqid &&
> > > > -                 (mark & x->mark.m) == x->mark.v &&
> > > > +                 (pol->mark.v == x->mark.v && pol->mark.m == x->mark.m) &&
> > > >                   x->if_id == if_id &&
> > > >                   !(x->props.flags & XFRM_STATE_WILDRECV) &&
> > > >                   xfrm_addr_equal(&x->id.daddr, daddr, encap_family) &&
> > >
> > > While this should usually not be a problem for strongSwan, as we set the
> > > same mark/value on both states and corresponding policies (although the
> > > latter can be disabled as users may want to install policies themselves
> > > or via another daemon e.g. for MIPv6), it might be a limitation for some
> > > use cases.  The current code allows sharing states with multiple
> > > policies whose mark/mask doesn't match exactly (i.e. depended on the
> > > masks of both).  I wonder if anybody uses it like this, and how others
> > > think about it.
> > IMHO, the non-exact match "(mark & x->mark.m) == x->mark.v" should be only
> > for packet flow. "sharing states with multiple policies" should not be the
> > purpose of xfrm_mark. (Add Jamal to the CC list)
> >
> > "(((pol->mark.v & pol->mark.m) & x->mark.m) == x->mark.v)" is just strange.
> > We could do either:
> >  (pol->mark.v == x->mark.v && pol->mark.m == x->mark.m), like this patch.
> > Or use fl->flowi_mark in xfrm_state_find():
> >  (fl->flowi_mark & x->mark.m) == x->mark.v)
> >
> > The 1st one will require userland to configure policy and state with the
> > same xfrm_mark, like strongswan.
> >
> > The 2nd one will match state with tx packet flow's mark, it's more like
> > rx packet flow path.
> >
> > But you're right, either of these may cause slight differences, let's see
> > how other userland cases use it. (also Add Libreswan's developer, Paul Wouters)
>
> We should care that everything that worked before, will still work after
> this change. Otherwise we might break someones usecase, even if the
> usecase seems to be odd and nobody complains now.
Hi, Steffen, You're right.

But what if the current one may cause problems?

policyA: mark(value: 0x11, mask: 0xff)
stateA: mark(value: 0x1, mask: 0xf)
stateB: mark(value: 0x11, mask: 0xff)

stateA is added later than stateB, and ahead of stateB in the list.

So one packet flow with mask 0x11, will get stateA through policyA, like on tx.
But one packet flow with mask 0x11, will get stateB by
xfrm_state_lookup(), like on rx.

I'm not sure if this may be an inconsistency issue.
