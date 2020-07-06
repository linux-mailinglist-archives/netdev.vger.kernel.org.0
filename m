Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53682153EE
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 10:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbgGFIYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 04:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgGFIYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 04:24:11 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544D4C061794
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 01:24:11 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id f139so40925882wmf.5
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 01:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vPOtMPLX0FQjyWQURSr+T40yVxoGzANFZyUTps234PE=;
        b=MYhgcHNk7TQrhzjTpr4sRtE37e7A/Lti3eyP9For23pWYDlN8DBUGCP2wjz0m6jxph
         ZXIm3hjh+u0+uV3bEGBjrLELpaiHUzjMB0IeIHMWPT7bqvcnusMDtISFYUxarcxFNoae
         5nptyemrG417d6gSHQPQ5m9lYaRZj0pf2cQTLzS+SG7AsBNhqeOgJw8Ct2ECCKZg7Arr
         ZI87F7fIUlnlH3vxV70ruhYqOlx6DmhT/klb25rEW9X54Bre6q/gARcDAyEhVAq+SL/C
         NAtd0Zf/r8YIv7SLIvDfOh7ChKpT1hrPOnHM5hRlinyPxRQAg5RxJGGFlOM+05QGIwTI
         n1Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vPOtMPLX0FQjyWQURSr+T40yVxoGzANFZyUTps234PE=;
        b=qe/jwCYqBj63fPVgLyYly82/noaxwjGojQTAcNrJzGkO5E2mZ76bp7QlFNEK+V+AkC
         /7rVZhuTJj0tZvUqJBCAT5aaQEnFYrEQCKD02dK+ROAzJeE7aX2WBjiE9gVLuO31RH/n
         TkBpjtlWhhg7I1yFTfMJFDqenfdmhG766NjnUiHmE70ToazXdbZTX9QGUXqQ3VFbqD1g
         lPK7rGZfcZZJPQI89thhoE03/M0afktHxLlgVnkwF0dMuxk5tl8YajCQinhRgvDKV7oB
         sTmX/BBF9O9ucn4XfZ5C0De7FLMXMNuVNH//8kOKtqQ0pPAJ5g4Ozq3dsDxYt/gX6ide
         RQOQ==
X-Gm-Message-State: AOAM531dVSxOOhKxlIxaxAdrOQZLRYdLOHBYCzHSW66OPtP8F/YkofjH
        +qfEVegfllaNd4iuXeCCX33WEyEqa42NiNJndJPIUjJ6Vvc=
X-Google-Smtp-Source: ABdhPJyHsMduSf4w1qC22QDmq8Wjvf9fWsSHOWO6DI6HI6JWE0IasttDlOjQjVl2X/69uvJU4eM2rW/JvbeCO7XO3KI=
X-Received: by 2002:a1c:6006:: with SMTP id u6mr47233658wmb.111.1594023850038;
 Mon, 06 Jul 2020 01:24:10 -0700 (PDT)
MIME-Version: 1.0
References: <4aaead9f8306859eb652b90582f23295792e9d15.1593497708.git.lucien.xin@gmail.com>
 <d510d172-c605-725d-e6bc-e6462a3718ab@strongswan.org>
In-Reply-To: <d510d172-c605-725d-e6bc-e6462a3718ab@strongswan.org>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 6 Jul 2020 16:33:53 +0800
Message-ID: <CADvbK_cQBbFwYj_CYTm69LP8a7R3PsS=nr0MyfRjAcASVz=dhQ@mail.gmail.com>
Subject: Re: [PATCH ipsec] xfrm: state: match with both mark and mask on user interfaces
To:     Tobias Brunner <tobias@strongswan.org>
Cc:     network dev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
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

Hi, Tobias

Sorry for late.

On Tue, Jun 30, 2020 at 5:08 PM Tobias Brunner <tobias@strongswan.org> wrote:
>
> Hi Xin,
>
> > Similar to commit 4f47e8ab6ab79 ("xfrm: policy: match with both mark and
> > mask on user interfaces"), this patch is to match both mark and mask for
> > state on these user interfaces:
> >
> >   xfrm_state_lookup_byaddr_user
> >   xfrm_state_lookup_user
> >   xfrm_state_update
> >   xfrm_state_find
> >   xfrm_state_add
> >       __xfrm_state_lookup_byaddr(struct xfrm_mark)
> >       __xfrm_state_lookup(struct xfrm_mark)
> >   xfrm_find_acq_byseq
> >   xfrm_stateonly_find
> >
> >           mark.v == x->mark.v && mark.m == x->mark.m
>
> I generally agree with matching marks/masks exactly for operations from
> userland, and it doesn't introduce any issues in our test suite.
> However, xfrm_state_find() is used to find an outbound state based on
> the templates in a policy and the marks on both, so it's not directly
> userland-facing.  Before this change, the mask configured on the state
> was a applied to the policy's mark/mask and then compared to the state's
> mark.  Now, the mark and mask both must match exactly:
Good catch.

>
> > @@ -1051,7 +1061,6 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> >       int acquire_in_progress = 0;
> >       int error = 0;
> >       struct xfrm_state *best = NULL;
> > -     u32 mark = pol->mark.v & pol->mark.m;
> >       unsigned short encap_family = tmpl->encap_family;
> >       unsigned int sequence;
> >       struct km_event c;
> > @@ -1065,7 +1074,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> >       hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h, bydst) {
> >               if (x->props.family == encap_family &&
> >                   x->props.reqid == tmpl->reqid &&
> > -                 (mark & x->mark.m) == x->mark.v &&
> > +                 (pol->mark.v == x->mark.v && pol->mark.m == x->mark.m) &&
> >                   x->if_id == if_id &&
> >                   !(x->props.flags & XFRM_STATE_WILDRECV) &&
> >                   xfrm_state_addr_check(x, daddr, saddr, encap_family) &&
> > @@ -1082,7 +1091,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> >       hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h_wildcard, bydst) {
> >               if (x->props.family == encap_family &&
> >                   x->props.reqid == tmpl->reqid &&
> > -                 (mark & x->mark.m) == x->mark.v &&
> > +                 (pol->mark.v == x->mark.v && pol->mark.m == x->mark.m) &&
> >                   x->if_id == if_id &&
> >                   !(x->props.flags & XFRM_STATE_WILDRECV) &&
> >                   xfrm_addr_equal(&x->id.daddr, daddr, encap_family) &&
>
> While this should usually not be a problem for strongSwan, as we set the
> same mark/value on both states and corresponding policies (although the
> latter can be disabled as users may want to install policies themselves
> or via another daemon e.g. for MIPv6), it might be a limitation for some
> use cases.  The current code allows sharing states with multiple
> policies whose mark/mask doesn't match exactly (i.e. depended on the
> masks of both).  I wonder if anybody uses it like this, and how others
> think about it.
IMHO, the non-exact match "(mark & x->mark.m) == x->mark.v" should be only
for packet flow. "sharing states with multiple policies" should not be the
purpose of xfrm_mark. (Add Jamal to the CC list)

"(((pol->mark.v & pol->mark.m) & x->mark.m) == x->mark.v)" is just strange.
We could do either:
 (pol->mark.v == x->mark.v && pol->mark.m == x->mark.m), like this patch.
Or use fl->flowi_mark in xfrm_state_find():
 (fl->flowi_mark & x->mark.m) == x->mark.v)

The 1st one will require userland to configure policy and state with the
same xfrm_mark, like strongswan.

The 2nd one will match state with tx packet flow's mark, it's more like
rx packet flow path.

But you're right, either of these may cause slight differences, let's see
how other userland cases use it. (also Add Libreswan's developer, Paul Wouters)
