Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A92E143ECF
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732138AbfFMPxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:53:15 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:32831 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731622AbfFMJE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 05:04:57 -0400
Received: by mail-qt1-f195.google.com with SMTP id x2so20771957qtr.0;
        Thu, 13 Jun 2019 02:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nzBa57T0OIAyCAQ1O9RvCN6xb/3FwMwRN6SvgCLPgNg=;
        b=j0ffML8CyknDu3KfnBFj/WQMQZZFynuLeLWDGUeLp6l3FicB/MW5OIR7Ud0yBDHFa/
         ZxexagDVif9zNpvQgeWsmdi/sFzZjfB0Eyl2hkiSxKHZYha8CIiLJUWGSboBqVfCZ2ZS
         O9sh40jRtvswNq/GPJZPyagSPZGGook8X72ixU7ay+tyMHQSTTvm2VqTlkoXrelZBMfL
         ozfwmIo9AUfUsGBvgDInOJoUB+E3sMgXhU2HsIwe5OrMUzspt/u8Csi3DFNmtQz1vbFC
         6c/s+OmLUO0GIr8oOh9OAIa4J+IhtV/+0mkVETGvXy1Zt4hl+fiCkzZknnBcx5R1/73n
         FXOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nzBa57T0OIAyCAQ1O9RvCN6xb/3FwMwRN6SvgCLPgNg=;
        b=FGQoD3CgXKclRSC1QE100CNDAxV8IpXYUBOHnFtQOpBzIG3QhiWFWIaw+SdzyaBiWk
         tLPZzJptan0au0df1FxxkOuTb15iZfB7gOofxdQ4vRGGmx0vDQzu9sSPtTj1OO0Q7hhU
         ahKXOdyCx3A8xNBOuTopCdbZT/f6QMNOOkvqkLdL/j76W0f2Dq+QXd7cdJuWTLBJBQaB
         hqZOAnUrrPswH+uRHeI40uyO2pTyzNKEpMTSVyLV9VIFeNN2UnpgM7C79EHzuLPvw8k1
         wv6gcs+ZSE751njb6W+DsuiQ9fIowfxcvKdRCj71rVdiM0j5CU2MQtjvxtvDTp9uEasa
         6nTQ==
X-Gm-Message-State: APjAAAXsZuuGGJpxGDsKfem+xhxT2oj8GlrW1xDhoHgTbxSmjTCBd8pD
        jgDK9wltr3MmwzKbPghARm67Z91/pqjnPlAgi+Y=
X-Google-Smtp-Source: APXvYqwk0F13xjccym5Gt178pFDO4lYhoTFYCOIlHvKPia2bX3aSKEJFLdRHwBQlOO2fKzcJK9Aid1F2KKXkkvWckwE=
X-Received: by 2002:ac8:4442:: with SMTP id m2mr52640121qtn.107.1560416696641;
 Thu, 13 Jun 2019 02:04:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190612161405.24064-1-maximmi@mellanox.com> <20190612141506.7900e952@cakuba.netronome.com>
In-Reply-To: <20190612141506.7900e952@cakuba.netronome.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 13 Jun 2019 11:04:45 +0200
Message-ID: <CAJ+HfNg8C+teCywDDjKY6_gdPsg_dzm1cMNFhj7gLps6RYMAJQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] net: Don't uninstall an XDP program when none is installed
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jun 2019 at 23:15, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Wed, 12 Jun 2019 16:14:18 +0000, Maxim Mikityanskiy wrote:
> > dev_change_xdp_fd doesn't perform any checks in case it uninstalls an
> > XDP program. It means that the driver's ndo_bpf can be called with
> > XDP_SETUP_PROG asking to set it to NULL even if it's already NULL. This
> > case happens if the user runs `ip link set eth0 xdp off` when there is
> > no XDP program attached.
> >
> > The drivers typically perform some heavy operations on XDP_SETUP_PROG,
> > so they all have to handle this case internally to return early if it
> > happens. This patch puts this check into the kernel code, so that all
> > drivers will benefit from it.
> >
> > Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> > ---
> > Bj=C3=B6rn, please take a look at this, Saeed told me you were doing
> > something related, but I couldn't find it. If this fix is already
> > covered by your work, please tell about that.
> >
> >  net/core/dev.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 66f7508825bd..68b3e3320ceb 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -8089,6 +8089,9 @@ int dev_change_xdp_fd(struct net_device *dev, str=
uct netlink_ext_ack *extack,
> >                       bpf_prog_put(prog);
> >                       return -EINVAL;
> >               }
> > +     } else {
> > +             if (!__dev_xdp_query(dev, bpf_op, query))
> > +                     return 0;
>
> This will mask the error if program is installed with different flags.
>

Hmm, probably missing something, but I fail to see how the error is
being masked? This is to catch the NULL-to-NULL case early.

> You driver should do nothing is program installation state did not
> change.  I.e.:
>
>         if (!!prog =3D=3D !!oldprog)
>
> You can't remove the active -> active check anyway, this change should
> make no difference.
>
> >       }
> >
> >       err =3D dev_xdp_install(dev, bpf_op, extack, flags, prog);
