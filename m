Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF9D2E029E
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 23:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgLUWum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 17:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLUWul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 17:50:41 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403BAC0613D6
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 14:50:01 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id qw4so15654410ejb.12
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 14:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/hmLBcYgvXk/x1QAZ2dN9muAY4mPZk3wo3lefglzomQ=;
        b=m2lkABdNRFWgCF0kTj5BZWNL0Rc4i1eL8zJPrX3hcPsLfz0Quc+SSfK47kI3dxN0/c
         BpzvlzzzXcTdCpRXHaqu5jcPDWj3zp8O3Ikkh71CwRwslu4zBdQGnTsueG87GKyWmiPd
         kKnu03OEbS5rIk0ODvwacGLyJAis8/lzDDEsQr221koX6aJrJc2Upxyu+yDuvKlqMwDg
         2guRE156sk5EfAp5ADH15uDPeBRp/PzNnVl6g+H0vn6V1WKBBE7a3FdYgwAe6ywKWTzy
         pL700BDm4GW6KhuvwLWvW7NFQQpMv4nX9fIYwTsE5R961AzPlAO/oUotqX7r1bo7StsS
         vCQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/hmLBcYgvXk/x1QAZ2dN9muAY4mPZk3wo3lefglzomQ=;
        b=RbjITy4zYv6YMOPQdUo5hywEnhawm0cexq1B5uvn53o7szcH7k0YeD3tNdKtt+yO3K
         iaCTmlR6dkvvgDT6uL2HB3p6ZKou4dGMetNQbUiOCoFjRqqs2iskL6ihfSMgNNL91Zyc
         PNeC7djB+wIpww4VxpYGQDphy5rErNuQ5fyciQStPc84/Z+EpxW0AsuI/TIU94QqXZtp
         EvaZyk4cKyy2nj6VQV+IKguH6mUDgRRG1Iw2dZ54EjRha6D/u/yHWCKz5Tl/FS3bXd31
         8StIrY20p2QTrnI+4A07mtPlEATjHZ4YW7GmsOHoFRCdkbacBihL+c/uIdIQb8e6H9Hr
         Ujsg==
X-Gm-Message-State: AOAM532QhGgOeoWvA8+COESaBCBfKdOAsdWP/Vp1lEb/HRMcAKZccBJk
        ydbRWBeR9odRstgipgMxhvZ6OqEsvJNQGsyCRNg=
X-Google-Smtp-Source: ABdhPJxmefuwPRoZDrpPvJC9+uE3rnDPwK10MaE5CZD5KnWRCq91cueqEbd9TQLMPFrGF1cG96/MLP3gG1+EzkDY/Gw=
X-Received: by 2002:a17:906:52d9:: with SMTP id w25mr17050247ejn.504.1608591000044;
 Mon, 21 Dec 2020 14:50:00 -0800 (PST)
MIME-Version: 1.0
References: <20201218201633.2735367-1-jonathan.lemon@gmail.com>
 <20201218201633.2735367-4-jonathan.lemon@gmail.com> <CA+FuTSeaero7hwvDR=1M6z3SZgf_bm+KjQWVzqeS_a42hQ-91Q@mail.gmail.com>
 <20201221191835.ic3aln6ib5hbftlk@bsd-mbp>
In-Reply-To: <20201221191835.ic3aln6ib5hbftlk@bsd-mbp>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 21 Dec 2020 17:49:22 -0500
Message-ID: <CAF=yD-JGJYzyHOGpnmOFefZQby-E93hnhd4++WVnJ56zZCXxhA@mail.gmail.com>
Subject: Re: [PATCH 3/9 v1 RFC] skbuff: replace sock_zerocopy_put() with skb_zcopy_put()
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > All uargs should have a callback function, (unless nouarg
> > > is set), so push all special case logic handling down into
> > > the callbacks.  This slightly pessimizes the refcounted cases,
> >
> > What does this mean?
>
> The current zerocopy_put() code does:
>   1) if uarg, dec refcount, if refcount == 0:
>      if callback, run callback, else consume skb.
>
> This is called from the main TCP/UDP send path.  These would be called
> for the zctap case as well, so it should be made generic - not specific
> to the current zerocopy implementation.  The patch changes this into:
>
>   1) if uarg, run callback.
>
> Then, the msg_zerocopy code does:
>
>   1) save state,
>   2) dec refcount, run rest of callback on 0.
>
> Which is the same as before.  The !uarg case is never handled here.
> The zctap cases switch to their own callbacks.
>
>
> The current zerocopy clear code does:
>   1) if no_uarg, skip
>   2) if msg_zerocopy, save state, dec refcount, run callback when 0.
>   3) otherwise just run callback.
>   4) clear flags
>
> I would like to remove the msg_zerocopy specific logic from the function,
> so this becomes:
>
>   1) if uarg, run callback.
>   2) clear flags

That sounds fine. Especially since we can simplify the logic after the
commit I mentioned. I just didn't understand what you meant by
pessimize.

> > > -void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
> > > +static void __sock_zerocopy_callback(struct ubuf_info *uarg)
> > >  {
> > >         struct sk_buff *tail, *skb = skb_from_uarg(uarg);
> > >         struct sock_exterr_skb *serr;
> > > @@ -1222,7 +1222,7 @@ void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
> > >         serr->ee.ee_origin = SO_EE_ORIGIN_ZEROCOPY;
> > >         serr->ee.ee_data = hi;
> > >         serr->ee.ee_info = lo;
> > > -       if (!success)
> > > +       if (!uarg->zerocopy)
> > >                 serr->ee.ee_code |= SO_EE_CODE_ZEROCOPY_COPIED;
> > >
> > >         q = &sk->sk_error_queue;
> > > @@ -1241,18 +1241,15 @@ void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
> > >         consume_skb(skb);
> > >         sock_put(sk);
> > >  }
> > > -EXPORT_SYMBOL_GPL(sock_zerocopy_callback);
> > >
> > > -void sock_zerocopy_put(struct ubuf_info *uarg)
> > > +void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
> > >  {
> > > -       if (uarg && refcount_dec_and_test(&uarg->refcnt)) {
> > > -               if (uarg->callback)
> > > -                       uarg->callback(uarg, uarg->zerocopy);
> > > -               else
> > > -                       consume_skb(skb_from_uarg(uarg));
> >
> > I suppose this can be removed after commit 0a4a060bb204 ("sock: fix
> > zerocopy_success regression with msg_zerocopy"). Cleaning that up
> > would better be a separate patch that explains why the removal is
> > safe.
>
> I'll split the patches out.

Thanks. Yes, splitting that patch in two will help (me) follow it better.
>
> > It's also fine to bundle with moving refcount_dec_and_test into
> > sock_zerocopy_callback, which indeed follows from it.
> >
> > > -       }
> > > +       uarg->zerocopy = uarg->zerocopy & success;
> > > +
> > > +       if (refcount_dec_and_test(&uarg->refcnt))
> > > +               __sock_zerocopy_callback(uarg);
> >
> > This can be wrapped in existing sock_zerocopy_callback. No need for a
> > __sock_zerocopy_callback.
>
> The compiler will inline the helper anyway, since it's a single
> callsite.

True. I just don't think the wrapper adds much value here.
