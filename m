Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0452C6A2E
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 17:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732007AbgK0QvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 11:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731977AbgK0QvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 11:51:15 -0500
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840A8C0613D1
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 08:51:15 -0800 (PST)
Received: by mail-vs1-xe44.google.com with SMTP id u133so2839479vsu.12
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 08:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X7jtzNs0NbYHlVVmlLsP7b2/FUYkvw9tqQfhdc87EyE=;
        b=r7N5PALFBkMVMurrPrTyIWvenPdAmItRtcw/fq7VdG/Lmay5Gng1oWK0qXANy6S+tt
         NCHXnAci/9v1VUarKydxLMEOj7yjlJ8X+EdUoZvLCg8bKqjyvrrfbJ3gKdt09gu1LWbf
         s2O04IakYss1f17gOqG0NgUvL3lhSXMbKSmCd/8nPD82Ue3fvgcUmHiZ9cK9vGgi2LYV
         Ca68HvMxWcglGqLXp8mCNjVqoxMa4SnJ33UD84nS4AyTlkP8Yp/PW2T+IY6j6Bi1w9R0
         Zwg/549g3eVRVfL+X+xY1iz2odmNfd6W44KcyMlEWKItU+42UkW1rl0WxlhhcPLfthwt
         nK3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X7jtzNs0NbYHlVVmlLsP7b2/FUYkvw9tqQfhdc87EyE=;
        b=Pu1xU3s0NcwLnKXJcQFqspystSOOlynT0M3+wDMiwcVyH+xMLxHsvA2isguwh+D0Oc
         eFIRNpcWUzXuRM1nVGmcc5WMzaPJv9+6goeh7rBvusjkke6zWKYmhLujutKpJKJP3S6D
         xssxd31QxH2wqPEn92QJNWilsgeNmZPFh5xXR6MK+Mtz7Jfc62w/udTEOfAiYo4Col9+
         MfeMXPb5ndWsXonYgoH6ohg9o9BmgZRrqy944DIVDoj8GWtmVPGvgKxDEgPEzbIe6eTU
         QIvVEcosnVprTXatQbw6ri863242mVf5nyMp6OjzSnt/nxqx3xl2q+cZDAVwaH8Ml4Q8
         PKWQ==
X-Gm-Message-State: AOAM5304RiaiTPCAEf4f1Es2DhV6S5azpbLfGgoEl0dGseWaLSc9djkJ
        itWLaq0SyYOgqauRJSVFJ+sPJzm4q24=
X-Google-Smtp-Source: ABdhPJy06Zwq44e+5d19YVJWSuwcDj7LO4M5DdSiwp8p5jCEjewCnSgtaDdpvkTETtXb7FIn0u1L1g==
X-Received: by 2002:a67:df8b:: with SMTP id x11mr6657890vsk.37.1606495873715;
        Fri, 27 Nov 2020 08:51:13 -0800 (PST)
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com. [209.85.217.41])
        by smtp.gmail.com with ESMTPSA id f25sm565147vkm.41.2020.11.27.08.51.11
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2020 08:51:12 -0800 (PST)
Received: by mail-vs1-f41.google.com with SMTP id r5so2858405vsp.7
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 08:51:11 -0800 (PST)
X-Received: by 2002:a05:6102:1173:: with SMTP id k19mr6628798vsg.51.1606495871475;
 Fri, 27 Nov 2020 08:51:11 -0800 (PST)
MIME-Version: 1.0
References: <20201125173436.1894624-1-elver@google.com> <20201125124313.593fc2b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANpmjNP_=Awx0-eZisMXzgXxKqf7hcrZYCYzFXuebPcwZtkoLw@mail.gmail.com>
 <CAF=yD-JtRUjmy+12kTL=YY8Cfi_c92GVbHZ647smWmasLYiNMg@mail.gmail.com> <CANpmjNO8H9OJDTcKhg4PRVEV04Gxnb56mJY2cB9j4cH+4nznhQ@mail.gmail.com>
In-Reply-To: <CANpmjNO8H9OJDTcKhg4PRVEV04Gxnb56mJY2cB9j4cH+4nznhQ@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 27 Nov 2020 11:50:34 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfCSZFC2Bz5WpnaoU__jrd8sSwsDqN1TNar3yeGNbVeQQ@mail.gmail.com>
Message-ID: <CA+FuTSfCSZFC2Bz5WpnaoU__jrd8sSwsDqN1TNar3yeGNbVeQQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: switch to storing KCOV handle directly in sk_buff
To:     Marco Elver <elver@google.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Aleksandr Nogikh <a.nogikh@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 27, 2020 at 7:26 AM Marco Elver <elver@google.com> wrote:
>
> On Thu, 26 Nov 2020 at 17:35, Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> > On Thu, Nov 26, 2020 at 3:19 AM Marco Elver <elver@google.com> wrote:
> [...]
> > > Will send v2.
> >
> > Does it make more sense to revert the patch that added the extensions
> > and the follow-on fixes and add a separate new patch instead?
>
> That doesn't work, because then we'll end up with a build-broken
> commit in between the reverts and the new version, because mac80211
> uses skb_get_kcov_handle().
>
> > If adding a new field to the skb, even if only in debug builds,
> > please check with pahole how it affects struct layout if you
> > haven't yet.
>
> Without KCOV:
>
>         /* size: 224, cachelines: 4, members: 72 */
>         /* sum members: 217, holes: 1, sum holes: 2 */
>         /* sum bitfield members: 36 bits, bit holes: 2, sum bit holes: 4 bits */
>         /* forced alignments: 2 */
>         /* last cacheline: 32 bytes */
>
> With KCOV:
>
>         /* size: 232, cachelines: 4, members: 73 */
>         /* sum members: 225, holes: 1, sum holes: 2 */
>         /* sum bitfield members: 36 bits, bit holes: 2, sum bit holes: 4 bits */
>         /* forced alignments: 2 */
>         /* last cacheline: 40 bytes */

Thanks. defconfig leaves some symbols disabled, but manually enabling
them just fills a hole, so 232 is indeed the worst case allocation.

I recall a firm edict against growing skb, but I don't know of a
hard limit at exactly 224.

There is a limit at 2048 - sizeof(struct skb_shared_data) == 1728B
when using pages for two ETH_FRAME_LEN (1514) allocations.

This would leave 1728 - 1514 == 214B if also squeezing the skb itself
in with the same allocation.

But I have no idea if this is used anywhere. Certainly have no example
ready. And as you show, the previous default already is at 224.

If no one else knows of a hard limit at 224 or below, I suppose the
next technical limit is just 256 for kmem cache purposes.

My understanding was that skb_extensions was supposed to solve this
problem of extending the skb without growing the main structure. Not
for this patch, but I wonder if we can resolve the issues exposed here
and make usable in more conditions.
