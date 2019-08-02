Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBEF7FCDC
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 16:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404402AbfHBOxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 10:53:07 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41369 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389271AbfHBOxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 10:53:06 -0400
Received: by mail-ed1-f66.google.com with SMTP id p15so72587665eds.8;
        Fri, 02 Aug 2019 07:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QIu6AOZDQPSwSkKbdFHn0frmIgLwRCOuURVK8auyHQM=;
        b=NyHt/M5L29n1iQkZndWNpPNswdOq91izgxSejynGG86Ffu7elIHzHSlKgPuQNqoVGw
         6TWYkMAY8w2NG/K8sjl9HWM9MrWhJZHSw+zTLXe2JQIRJCgVMediiUnBxpx2mwenF+9E
         WqqjvlNs8qlZ6XO7aqhGqRoCIyDBi6l+ECO5MKp+M9haRgr8QejI+G5r+17tc09e1iwG
         vzkvktdFS/zdRD/56pMqmuZyBdbhCBDwVuIgTNhhJtIKqctqp2t6iftLk5mw/7rZu2yT
         /pB4qh+ydaR+xSk1CYaYdu1qC1N0oGvEHfe+k8e8LT048FU8yjpDw1U49BHXhZkgSe3D
         btvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QIu6AOZDQPSwSkKbdFHn0frmIgLwRCOuURVK8auyHQM=;
        b=aeh7pVaUYSK4JCOakRlq2fBvCB47//UNdWsV5ONkaC7Yn7c8jC3tmPdSYJz34L7t2P
         6kA/NNNwGDkDaWOkXdW9W77UpniPqXFyuKH/jsfIdrY2CNqtu+rfttBsvpgtoCPSBgW1
         yWyeiJLh1cTU5q4Wp/q+BsJ40UWlxqb/H928WrlZTt1TA0pd4spZsxAhrxP0h0up4U6O
         wDqLyf3I5DYtIPGlHSC6Qpv1vpQoOfMjFsqB3M7fKVUloZOChjkBQxy6+qLuTEvRivGU
         srEGeuchHWJ14F7v+/5RaMUHXYLo+tiZG8Rz293eyB5kl12MkY7go7Yl7gVqlOT5QdJv
         Etrw==
X-Gm-Message-State: APjAAAWztuA6hH1c7i9zUb3xU0ynyQundN4Lnl5wfzFmFiFak3w9bvty
        eGHQfDHOb/Qz9gkf4S59Ij+URugXXdDoqIl7IK8nLA==
X-Google-Smtp-Source: APXvYqxb+xzmh1F/T6KvvrZWb0KfigpV7UQwtcfFojlVTxGQvTgo+nz6TccuBiWaJHGvk7omKf/GeTXYvYHsUm8ijn4=
X-Received: by 2002:a17:906:6492:: with SMTP id e18mr59313520ejm.133.1564757584890;
 Fri, 02 Aug 2019 07:53:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190802083541.12602-1-hslester96@gmail.com> <CA+FuTSc8WBx2PCUhn-sLtYHQR-OROXm2pUN9SDj7P-Bd8432UQ@mail.gmail.com>
 <CANhBUQ2TRr4RuSmjaRYPXHZpVw_-2awXvWNjjdvV_z1yoGdkXA@mail.gmail.com>
In-Reply-To: <CANhBUQ2TRr4RuSmjaRYPXHZpVw_-2awXvWNjjdvV_z1yoGdkXA@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 2 Aug 2019 10:52:28 -0400
Message-ID: <CAF=yD-+3tzufyOnK4suJnovrhX_=4sPqWOsjOcETGG3cA9+MdA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] cxgb4: sched: Use refcount_t for refcount
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     Vishal Kulkarni <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 2, 2019 at 10:27 AM Chuhong Yuan <hslester96@gmail.com> wrote:
>
> Willem de Bruijn <willemdebruijn.kernel@gmail.com> =E4=BA=8E2019=E5=B9=B4=
8=E6=9C=882=E6=97=A5=E5=91=A8=E4=BA=94 =E4=B8=8B=E5=8D=889:40=E5=86=99=E9=
=81=93=EF=BC=9A
> >
> > On Fri, Aug 2, 2019 at 4:36 AM Chuhong Yuan <hslester96@gmail.com> wrot=
e:
> > >
> > > refcount_t is better for reference counters since its
> > > implementation can prevent overflows.
> > > So convert atomic_t ref counters to refcount_t.
> > >
> > > Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> > > ---
> > > Changes in v2:
> > >   - Convert refcount from 0-base to 1-base.
> >
> > This changes the initial value from 0 to 1, but does not change the
> > release condition. So this introduces an accounting bug?
>
> I have noticed this problem and have checked other files which use refcou=
nt_t.
> I find although the refcounts are 1-based, they still use
> refcount_dec_and_test()
> to check whether the resource should be released.
> One example is drivers/char/mspec.c.
> Therefore I think this is okay and do not change the release condition.

Indeed it is fine to use refcount_t with a model where the initial
allocation already accounts for the first reference and thus
initializes with refcount_set(.., 1).

But it is not correct to just change a previously zero initialization
to one. As now an extra refcount_dec will be needed to release state.
But the rest of the code has not changed, so this extra decrement will
not happen.

For a correct conversion, see for instance commits

  commit db5bce32fbe19f0c7482fb5a40a33178bbe7b11b
  net: prepare (struct ubuf_info)->refcnt conversion

and

  commit c1d1b437816f0afa99202be3cb650c9d174667bc
  net: convert (struct ubuf_info)->refcnt to refcount_t

The second makes a search-and-replace style API change like your
patches (though also notice the additional required #include).

But the other patch is needed first to change both the initial
atomic_set *and* at least one atomic_inc, to maintain the same
reference count over the object's lifetime.

That change requires understanding of the object's lifecycle, so I
suggest only making those changes when aware of that whole data path.
