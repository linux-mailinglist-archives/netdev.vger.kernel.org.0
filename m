Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D56C533E3E
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 07:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfFDFQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 01:16:51 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46872 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfFDFQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 01:16:50 -0400
Received: by mail-qk1-f193.google.com with SMTP id a132so2010445qkb.13;
        Mon, 03 Jun 2019 22:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cbfYUMzxaZOFuGJ3Lzln5k9gEE11tUSBe40g1/NG2Aw=;
        b=gV/LYSQJ7AIOHDgzgALWfFhIzCqE/BbW+C2M54Nbem0dCXBl2m0UABL4OtlDodljVo
         NqtF5S8zKbyse4nxDo+v3EfYk7BQlZfw8LQFDK5Uhz83pzECOLQ0UaiRaWyKu/LKBYq1
         ZBXAzWhbDfsUqiBY5/3CpteXQWTweqJN0ehXr+EGtVe2/q7vJHNvvxiwF+yJU8c91Alp
         47eMrSLAxHFopi7lhPOsBEpceN+XyA8u1s9v+7251pCIL37dItISa0mt7FnT1vxvKDOi
         yiDiRAda/Ea65Iosr4QAqegkxMef3dbUY8RC4I10TjzSLygrw+4kJvsCAF17kFx92qGk
         grvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cbfYUMzxaZOFuGJ3Lzln5k9gEE11tUSBe40g1/NG2Aw=;
        b=SIlC9+wh3322eXua2yr8/Cu1Vu+n+d+B0OPlwa04MTVBIdDXEPayQfT77njFDzivXD
         qQ+UYFtVUeCLC6k7AHPZVWbE5ic3lDyBVU2cQ5Q1FdRnGbUP93NdL77wO4AFECmSICbm
         lTh1datdnHRH5DIZb4Jdp4r/alS7NpQoW1zLXD+V0konGew4A+PTGwtECXOfKgAMA5vB
         cWMSh10Kl+WKMy7gcDs7wuIm5iChuM63gO4pbY51uM1MA4jRXVQgeMA+5F73E2Fx6P3C
         S0H3KT78lgwW7SauaBzlVLwkEH6ShW1tSg3GZTP8pvNwzUldT6BdY/hS0Rj3NNRmROlU
         EUZw==
X-Gm-Message-State: APjAAAWBbex7S6vV9RtyH1OoXqefL0NY0KhuiD7I5PCKNy1C7G5WH1cS
        iVuNiitR50FS1H3u59HJRV5l9ZDyZ763OWdduR7plXJzHTqAJw==
X-Google-Smtp-Source: APXvYqxrxiJL+ougbvu5jNkAWXUW3Dl5qoBSYLEubhv1HCvIeLqp2IeKEIbnhGxo3X8fKkVbzqgKNk0wbJCOop6/WZY=
X-Received: by 2002:a05:620a:158c:: with SMTP id d12mr24481066qkk.33.1559625409248;
 Mon, 03 Jun 2019 22:16:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190531094215.3729-1-bjorn.topel@gmail.com> <20190531094215.3729-2-bjorn.topel@gmail.com>
 <b0a9c3b198bdefd145c34e52aa89d33aa502aaf5.camel@mellanox.com>
 <20190601125717.28982f35@cakuba.netronome.com> <CAJ+HfNix+oa=9oMOg9pVMiVTiM5sZe5Tn6zTE_Bu6gV5M=B7kQ@mail.gmail.com>
 <20190603100321.56a6a6e4@cakuba.netronome.com>
In-Reply-To: <20190603100321.56a6a6e4@cakuba.netronome.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 4 Jun 2019 07:16:37 +0200
Message-ID: <CAJ+HfNgb4RPvnz-Nf5Wrd2NrT_jnEyOk-gJaVA3XJ4FAUa9jAw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW}
 to netdev
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "toke@redhat.com" <toke@redhat.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Jun 2019 at 19:03, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Mon, 3 Jun 2019 11:04:36 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> > On Sat, 1 Jun 2019 at 21:57, Jakub Kicinski
> > <jakub.kicinski@netronome.com> wrote:
> > >
> > > On Fri, 31 May 2019 19:18:17 +0000, Saeed Mahameed wrote:
> > > > > +   if (!bpf_op || flags & XDP_FLAGS_SKB_MODE)
> > > > > +           mode =3D XDP_FLAGS_SKB_MODE;
> > > > > +
> > > > > +   curr_mode =3D dev_xdp_current_mode(dev);
> > > > > +
> > > > > +   if (!offload && curr_mode && (mode ^ curr_mode) &
> > > > > +       (XDP_FLAGS_DRV_MODE | XDP_FLAGS_SKB_MODE)) {
> > > >
> > > > if i am reading this correctly this is equivalent to :
> > > >
> > > > if (!offload && (curre_mode !=3D mode))
> > > > offlad is false then curr_mode and mode must be DRV or GENERIC ..
> > >
> > > Naw, if curr_mode is not set, i.e. nothing installed now, we don't ca=
re
> > > about the diff.
> > >
> > > > better if you keep bitwise operations for actual bitmasks, mode and
> > > > curr_mode are not bitmask, they can hold one value each .. accordin=
g to
> > > > your logic..
> > >
> > > Well, they hold one bit each, whether one bit is a bitmap perhaps is
> > > disputable? :)
> > >
> > > I think the logic is fine.
> > >
> >
> > Hmm, but changing to:
> >
> >        if (!offload && curr_mode && mode !=3D curr_mode)
> >
> > is equal, and to Saeed's point, clearer. I'll go that route in a v3.
>
> Sorry, you're right, the flags get mangled before they get here, so
> yeah, this condition should work.  Confusingly.
>
> > > What happened to my request to move the change in behaviour for
> > > disabling to a separate patch, tho, Bjorn? :)
> >
> > Actually, I left that out completely. This patch doesn't change the
> > behavior. After I realized how the flags *should* be used, I don't
> > think my v1 change makes sense anymore. My v1 patch was to give an
> > error if you tried to disable, say generic if drv was enabled via
> > "auto detect/no flags". But this is catched by looking at the flags.
> >
> > What I did, however, was moving the flags check into change_fd so that
> > the driver doesn't have to do the check. E.g. the Intel drivers didn't
> > do correct checking of flags.
>
> Ugh.  Could you please rewrite the conditions to make the fd >=3D check
> consistently the outside if?  Also could you add extack to this:
>

The reason I moved the if-statement (checking if we're mixing
drv/skb), is because I'd like to catch the no-op (e.g. xdpdrv active
and calling xdpgeneric off) early (the return 0, under the if (fd >=3D
check).

> +       if (!offload && dev_xdp_query(dev, mode) &&
> +           !xdp_prog_flags_ok(dev->xdp_flags, flags, extack))
> +               return -EBUSY;
>
> It's unclear what it's doing.

This checks whether the flags have changed, pulling out the logic from
the drivers. xdp_prog_flags_ok adds to extack, resuing the flags_ok
function. The xdp_attachment_flags_ok OTOH is not necessary anymore,
and should be further cleaned up. I'll address this and make the this
clause more clear.


Bj=C3=B6rn
