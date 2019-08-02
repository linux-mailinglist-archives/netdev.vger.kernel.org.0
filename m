Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED527FD35
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 17:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730830AbfHBPOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 11:14:48 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38351 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728719AbfHBPOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 11:14:47 -0400
Received: by mail-ed1-f67.google.com with SMTP id r12so37901371edo.5;
        Fri, 02 Aug 2019 08:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=txRNymCLa0F2sH7rm1U39uNCjUyxuuiLjvn3rhtof6o=;
        b=lO9QmjHP6O41ZCS8dtxftVcEU1ZMBi8DcpvUMY0blH5Qwqs9An8SwEtYIu4kI6xBqO
         ROSjy4jrgZxUHgj+PoMsKXXOnCBPtY5s3OefBgajHeizJfCRzEQMpfJZsxWfs2ziBXQr
         i8FM3V169K4mBiBVZU798HtbOMxk+zE0F74fIx/mFQP3tKcsbIYJQNMVfDCKLixaXC73
         nOlcLwXTCJweexIyOsfohKaVuLPfBukqQrOIEHK1aRxxDDXvRW34lsQSzs7tYjyBU7tI
         35VsEtCMIxfCasrfUvsocJfMQjs6gT5qlNs4oH7gbeoS5iNqtHQ+9CscZuIBYXg+ZC0P
         1jiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=txRNymCLa0F2sH7rm1U39uNCjUyxuuiLjvn3rhtof6o=;
        b=mUCERXEelUt/qhezWeh7jdYMOZdTzoMRelgkcaMdPwJ0EmaUKo7jy+IdYMSwC/fJ63
         abpvUSTxs9tzHw4DzyD1cdsyl7vTWSEFmK1gWkPer8bQFSd8z47DvO2rSdFP2w9QtWhk
         Hu3fRuuCdtcrRL3gomSvKrD0UF8oB97ZqVckSAODlZGAIAZrDuaf7tu28+A7Muwlz9Ap
         a6FpnEP87zwO8WJOHbx2qEk03jLUALu7EIll9BuBVLQxtfZanRlMPCDQU6vUc1NyD/yW
         R7pwlz/HjgqmBPG4TqugVXAInszF0JJgdMX5NKM5iBDPiovQG2HHxQNW6vqYvBIhPfxn
         oZvA==
X-Gm-Message-State: APjAAAU9wHdJWuLYjujLz+VKrfShtfsoivmv4stAKO1vICRY6LzxqZFg
        CsWeqc76Wtbfl76hP59pSK5yE/wAuGDaR7bFxf4=
X-Google-Smtp-Source: APXvYqzciECXl/Wx8kXkgux/UT3GuFE34O7YmYXV/Xzub/m93Yrtsl0lq1y+r+M8dslWjvKCZukCo7A1uiL7FM5xcDo=
X-Received: by 2002:a50:a53a:: with SMTP id y55mr122610228edb.147.1564758886126;
 Fri, 02 Aug 2019 08:14:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190802083541.12602-1-hslester96@gmail.com> <CA+FuTSc8WBx2PCUhn-sLtYHQR-OROXm2pUN9SDj7P-Bd8432UQ@mail.gmail.com>
 <CANhBUQ2TRr4RuSmjaRYPXHZpVw_-2awXvWNjjdvV_z1yoGdkXA@mail.gmail.com>
 <CAF=yD-+3tzufyOnK4suJnovrhX_=4sPqWOsjOcETGG3cA9+MdA@mail.gmail.com> <CANhBUQ2C3OfkC6qDL9=hhXq=C-OMHUwaL7EaMbagVRTt=rc00A@mail.gmail.com>
In-Reply-To: <CANhBUQ2C3OfkC6qDL9=hhXq=C-OMHUwaL7EaMbagVRTt=rc00A@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 2 Aug 2019 11:14:10 -0400
Message-ID: <CAF=yD-K1=4sDmLb0sUaxTHAbVmBXTy4McdBJyVtrZEJx95CqxA@mail.gmail.com>
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

On Fri, Aug 2, 2019 at 11:10 AM Chuhong Yuan <hslester96@gmail.com> wrote:
>
> Willem de Bruijn <willemdebruijn.kernel@gmail.com> =E4=BA=8E2019=E5=B9=B4=
8=E6=9C=882=E6=97=A5=E5=91=A8=E4=BA=94 =E4=B8=8B=E5=8D=8810:53=E5=86=99=E9=
=81=93=EF=BC=9A
> >
> > On Fri, Aug 2, 2019 at 10:27 AM Chuhong Yuan <hslester96@gmail.com> wro=
te:
> > >
> > > Willem de Bruijn <willemdebruijn.kernel@gmail.com> =E4=BA=8E2019=E5=
=B9=B48=E6=9C=882=E6=97=A5=E5=91=A8=E4=BA=94 =E4=B8=8B=E5=8D=889:40=E5=86=
=99=E9=81=93=EF=BC=9A
> > > >
> > > > On Fri, Aug 2, 2019 at 4:36 AM Chuhong Yuan <hslester96@gmail.com> =
wrote:
> > > > >
> > > > > refcount_t is better for reference counters since its
> > > > > implementation can prevent overflows.
> > > > > So convert atomic_t ref counters to refcount_t.
> > > > >
> > > > > Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> > > > > ---
> > > > > Changes in v2:
> > > > >   - Convert refcount from 0-base to 1-base.
> > > >
> > > > This changes the initial value from 0 to 1, but does not change the
> > > > release condition. So this introduces an accounting bug?
> > >
> > > I have noticed this problem and have checked other files which use re=
fcount_t.
> > > I find although the refcounts are 1-based, they still use
> > > refcount_dec_and_test()
> > > to check whether the resource should be released.
> > > One example is drivers/char/mspec.c.
> > > Therefore I think this is okay and do not change the release conditio=
n.
> >
> > Indeed it is fine to use refcount_t with a model where the initial
> > allocation already accounts for the first reference and thus
> > initializes with refcount_set(.., 1).
> >
> > But it is not correct to just change a previously zero initialization
> > to one. As now an extra refcount_dec will be needed to release state.
> > But the rest of the code has not changed, so this extra decrement will
> > not happen.
> >
> > For a correct conversion, see for instance commits
> >
> >   commit db5bce32fbe19f0c7482fb5a40a33178bbe7b11b
> >   net: prepare (struct ubuf_info)->refcnt conversion
> >
> > and
> >
> >   commit c1d1b437816f0afa99202be3cb650c9d174667bc
> >   net: convert (struct ubuf_info)->refcnt to refcount_t
> >
> > The second makes a search-and-replace style API change like your
> > patches (though also notice the additional required #include).
> >
>
> Thanks for your examples!
> I will fix the #include in those no base changed patches.
>
> > But the other patch is needed first to change both the initial
> > atomic_set *and* at least one atomic_inc, to maintain the same
> > reference count over the object's lifetime.
> >
> > That change requires understanding of the object's lifecycle, so I
> > suggest only making those changes when aware of that whole data path.
>
> I think I had better focus on the 1-based cases first.

Yes, sounds good. And please try a single driver first and get that
accepted, before moving on to multiple concurrent submissions.
