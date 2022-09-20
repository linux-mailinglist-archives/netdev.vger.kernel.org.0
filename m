Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD9C5BEA53
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbiITPg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbiITPgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:36:25 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321B15E64D
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:36:24 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id p1-20020a17090a2d8100b0020040a3f75eso2825569pjd.4
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=7M61hDYKY5XeCNz126yDIpx4CT/4LPBJy2NRK2doCbE=;
        b=fNiY5RdvkBEcaBkPPwQLgWhv4oysRqafAsZ0KVPcfzw7mXk+BRiTIANp9bRH36VBgg
         /7A1uUwe05B4sQMnkq5C7UrN9qbaduUlS7q9Vcnf42eXXtkXbKTs+K0afIVHamMhiXzI
         Po33b3tZTGRXvUklcPu8Hl4Sit3iKgaKkba07K4qmBknkXqKPPR8k30E4aPubOG5ZiHr
         Edo2hm5urPrpqKHsb6x48W6So9khn16aICigILGINuPdnfk8dpuE4Z+RTWp92DmaDonU
         +iur9tnKIrcbdMrtkKySQhh+NE9rc89Untl0c6xM4vi1Lu4kxh2v8Ejr39L/HZ20+Koi
         Zhbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=7M61hDYKY5XeCNz126yDIpx4CT/4LPBJy2NRK2doCbE=;
        b=loWpmxwWYjGdroaTlr0F77w5+ysCxm2EZneGG+8JX/cgc0uJHu7I0AXbcRY6K5DDNk
         RBjsye+vWsOdLE6RDS9ZCi2IVk8PeojEW/a77+1DYDevxKxYxz/fuTY6x63ufFaJ11b1
         XfYqajVSo+x//7VUgSgKxAcyAtGKQE59UMMQAhi+zou4vprBAdaoECVwcXKCuUb73kxB
         D/StPsICC6hH7O57YQ+0Cxk5xp0K7N4cl0majOIJ3Ksm/uuHKxCmi+cHrFyfn5pq+J6q
         g9ssw2T/Q7Mv/QQpj2rS6K8JVBpfI8L+Gp8Ju/iSFhe1AOtz0u11E2P66BA5IO7ixWfx
         UY1Q==
X-Gm-Message-State: ACrzQf0VgBGqMvXBJqs3bs1s9+MbLFWtMVq/QeOUiTOTGbqRo68DNlKD
        TUALVoWRDD1gLUeCea2Axmpy+A==
X-Google-Smtp-Source: AMsMyM6CbBb3+pObS6HicqiM0AbINpQ65XiG94EUhlTbkaIwhEmeaN8kZqaVVlVwspNnsjFoKv2rEw==
X-Received: by 2002:a17:902:c94f:b0:178:4423:af05 with SMTP id i15-20020a170902c94f00b001784423af05mr250714pla.147.1663688183592;
        Tue, 20 Sep 2022 08:36:23 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id u89-20020a17090a51e200b001eee8998f2esm61343pjh.17.2022.09.20.08.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 08:36:23 -0700 (PDT)
Date:   Tue, 20 Sep 2022 08:36:21 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        Patrick Rohr <prohr@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, Lorenzo Colitti <lorenzo@google.com>
Subject: Re: [PATCH] tun: support not enabling carrier in TUNSETIFF
Message-ID: <20220920083621.18219c3d@hermes.local>
In-Reply-To: <CACGkMEu6zBeduw9F==NWhz01FphYjkhT0Qmp+06vq6=kCx+bvA@mail.gmail.com>
References: <20220916234552.3388360-1-prohr@google.com>
        <20220919101802.4f4d1a86@hermes.local>
        <CANP3RGdMEJMDcB8X_YD-PM7X6pqypvSn7_q4x=B8rzLd+CAqXA@mail.gmail.com>
        <CACGkMEu6zBeduw9F==NWhz01FphYjkhT0Qmp+06vq6=kCx+bvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Sep 2022 09:44:45 +0800
Jason Wang <jasowang@redhat.com> wrote:

> On Tue, Sep 20, 2022 at 8:01 AM Maciej =C5=BBenczykowski <maze@google.com=
> wrote:
> >
> > On Mon, Sep 19, 2022 at 10:18 AM Stephen Hemminger
> > <stephen@networkplumber.org> wrote: =20
> > > On Fri, 16 Sep 2022 16:45:52 -0700
> > > Patrick Rohr <prohr@google.com> wrote: =20
> > > >  #define IFF_DETACH_QUEUE 0x0400
> > > > +/* Used in TUNSETIFF to bring up tun/tap without carrier */
> > > > +#define IFF_NO_CARRIER IFF_DETACH_QUEUE =20
> > >
> > > Overloading a flag in existing user API is likely to break
> > > some application somewhere... =20
> >
> > We could of course burn a bit (0x0040 and 0x0080 are both currently
> > utterly unused)... but that just seemed wasteful...
> > Do you think that would be better?
> >
> > I find it exceedingly unlikely that any application is specifying this
> > flag to TUNSETIFF currently.
> >
> > This flag has barely any hits in the code base, indeed ignoring the
> > Documentation, tests, and #define's we have:
> >
> > $ git grep IFF_DETACH_QUEUE
> > drivers/net/tap.c:928:  else if (flags & IFF_DETACH_QUEUE)
> > drivers/net/tun.c:2954: } else if (ifr->ifr_flags & IFF_DETACH_QUEUE) {
> > drivers/net/tun.c:3115:                 ifr.ifr_flags |=3D IFF_DETACH_Q=
UEUE;
> >
> > The first two implement ioctl(TUNSETQUEUE) -- that's the only spot
> > where IFF_DETACH_QUEUE is currently supposed to be used.
> >
> > The third one is the most interesting, see drivers/net/tun.c:3111
> >
> >  case TUNGETIFF:
> >          tun_get_iff(tun, &ifr);
> >          if (tfile->detached)
> >                  ifr.ifr_flags |=3D IFF_DETACH_QUEUE;
> >          if (!tfile->socket.sk->sk_filter)
> >                  ifr.ifr_flags |=3D IFF_NOFILTER;
> >
> > This means TUNGETIFF can return this flag for a detached queue.  Howeve=
r:
> >
> > (a) multiqueue tun/tap is pretty niche, and detached queues are even mo=
re niche.
> >
> > (b) the TUNGETIFF returned ifr_flags field already cannot be safely
> > used as input to TUNSETIFF, =20
>=20
> Yes, but it could be used by userspace to recover the multiqueue state
> via TUNSETQUEUE for a feature like checkpoint.
>=20
> > because IFF_NOFILTER =3D=3D IFF_NO_PI =3D=3D
> > 0x1000
> >
> > (this overlap of IFF_NO_PI and IFF_NOFILTER is why we thought it'd be
> > ok to overlap here as well)
> >
> > (c) if this actually turns out to be a problem it shouldn't be that
> > hard to fix the 1 or 2 userspace programs to mask out the flag
> > and not pass in garbage... Do we really want / need to maintain
> > compatibility with extremely badly written userspace? =20
>=20
> Not sure, but instead of trying to answer this hard question, having a
> new flag seems to be easier.
>=20
> > It's really hard to even imagine how such code would come into existenc=
e...
> >
> > Arguably the TUNSETIFF api should have always returned an error for
> > invalid flags... should we make that change now? =20
>=20
> Probably too late to do that.

There have been several other cases where Linus has said
ABI compatability includes not breaking buggy userspace applications.
Look at the history around new syscalls that add a flag argument
and forget to check that it is zero in the first version.
