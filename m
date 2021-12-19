Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA0F47A244
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 22:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbhLSVU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 16:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhLSVU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 16:20:57 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D27DC061574;
        Sun, 19 Dec 2021 13:20:57 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id 7so12899999oip.12;
        Sun, 19 Dec 2021 13:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=z3zIo1BvdwoRAMOZ8KYLz/FcfKXj95eywc0B461CDjs=;
        b=aH0Vx5ltWY+N//xW2dwnL9g1Pm92lrskHsfsUHqDDX6FRBwgITXKiY71kB4YYyP30q
         RZqrVzSSNhKieW0esd9Fkp1dVlL6eydBM0b+dAdC/HNgWvqcqEzvYLkozPg2dY2XlTb6
         9H7FP6NPiwyKmDxxyH1iI/4u8U/kBHWkOjaCorbtwelXEs1rDewXeDHNZQLBebuNiEWX
         s2nO1gQmBD68OHxRk3hmISnl+Ckxh7n0BkxVOynp/KgNj2Wfh/OGQLypP8DL2yae11d6
         BHivv0CqnB5o29ti+hr67KYfs86icFJvYUSkfKzasa0bx6I1DDp/yu6Pl+zc2++Lm546
         OnDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=z3zIo1BvdwoRAMOZ8KYLz/FcfKXj95eywc0B461CDjs=;
        b=SkEtqGj6oqruGKj3Q4ZKtrqnJE8ic/+Z0m1FButYDAn/J94JrVU1kMZv9/hsUvi840
         U7KnjOWQHVtE7HH6wOXtL+c35YUkHYqwzb17hmTmDXZk4eySsVOWQlyQiNHO3zjL5UQO
         BEsjfQ/Lzj20fx/jn1jzG1WfDcY2cIQe44UIVWm6nVB+71mRJL+yVIbl6VX2Sl99X2pt
         0Hhqr1WGIDKzKxvQ5XdBvHraIuDYrcYllcBW9Hd0r82OwMpnw5MY2eL+0oaBwjJE/pJW
         zGphpRY76JRtoKgcZ9iDaEDY0RlNfDpeL+09yGS/QrmnLFQgPyeg9YJXCfYnqS8GA3sZ
         2N0Q==
X-Gm-Message-State: AOAM533AnywkJbK+cqD0q9wswsTzJg+IgQAMbRGLy991Rl/DLpfE4AQL
        VHkWpmUIOZICcAiPNERin1e2QuDF5uEKovpneo/eTYDk
X-Google-Smtp-Source: ABdhPJz+SzllFAWKYg3CHSrRkziogeBkR2fpGstGmhs1olMOtOQXQhf1wD+qvJSTUiVhGokLJAeayFpaYzHhQxNDDBk=
X-Received: by 2002:a05:6808:150d:: with SMTP id u13mr9789575oiw.155.1639948856493;
 Sun, 19 Dec 2021 13:20:56 -0800 (PST)
MIME-Version: 1.0
References: <20211214215732.1507504-1-lee.jones@linaro.org>
 <20211214215732.1507504-2-lee.jones@linaro.org> <20211215174818.65f3af5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADvbK_emZsHVsBvNFk9B5kCZjmAQkMBAx1MtwusDJ-+vt0ukPA@mail.gmail.com>
 <Ybtrs56tSBbmyt5c@google.com> <CADvbK_cBBDkGt8XLJo6N5TX2YQATS+udVWm8_=8f96=0B9tnTA@mail.gmail.com>
 <Ybtzr5ZmD/IKjycz@google.com> <Ybtz/0gflbkG5Q/0@google.com>
 <CADvbK_cexKiVATn=dPrWqoS0qM-bM0UcSkx8Xqz5ibEKQizDVg@mail.gmail.com>
 <CADvbK_cxMbYwkuN_ZUvHY-7ahc9ff+jbuPkKn6CA=yqMk=SKVw@mail.gmail.com> <YbuNZtV/pjDszTad@google.com>
In-Reply-To: <YbuNZtV/pjDszTad@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sun, 19 Dec 2021 16:20:45 -0500
Message-ID: <CADvbK_f7wY_tknw5wTo369-2aRSvhhkETwmdu9tRbgfeyyTQng@mail.gmail.com>
Subject: Re: [RESEND 2/2] sctp: hold cached endpoints to prevent possible UAF
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        lksctp developers <linux-sctp@vger.kernel.org>,
        "H.P. Yarroll" <piggy@acm.org>,
        Karl Knutson <karl@athena.chicago.il.us>,
        Jon Grimm <jgrimm@us.ibm.com>,
        Xingang Guo <xingang.guo@intel.com>,
        Hui Huang <hui.huang@nokia.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        Daisy Chang <daisyc@us.ibm.com>,
        Ryan Layer <rmlayer@us.ibm.com>,
        Kevin Gao <kevin.gao@intel.com>,
        network dev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 2:03 PM Lee Jones <lee.jones@linaro.org> wrote:
>
> On Thu, 16 Dec 2021, Xin Long wrote:
>
> > (
> >
> > On Thu, Dec 16, 2021 at 1:12 PM Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > On Thu, Dec 16, 2021 at 12:14 PM Lee Jones <lee.jones@linaro.org> wro=
te:
> > > >
> > > > On Thu, 16 Dec 2021, Lee Jones wrote:
> > > >
> > > > > On Thu, 16 Dec 2021, Xin Long wrote:
> > > > >
> > > > > > On Thu, Dec 16, 2021 at 11:39 AM Lee Jones <lee.jones@linaro.or=
g> wrote:
> > > > > > >
> > > > > > > On Thu, 16 Dec 2021, Xin Long wrote:
> > > > > > >
> > > > > > > > On Wed, Dec 15, 2021 at 8:48 PM Jakub Kicinski <kuba@kernel=
.org> wrote:
> > > > > > > > >
> > > > > > > > > On Tue, 14 Dec 2021 21:57:32 +0000 Lee Jones wrote:
> > > > > > > > > > The cause of the resultant dump_stack() reported below =
is a
> > > > > > > > > > dereference of a freed pointer to 'struct sctp_endpoint=
' in
> > > > > > > > > > sctp_sock_dump().
> > > > > > > > > >
> > > > > > > > > > This race condition occurs when a transport is cached i=
nto its
> > > > > > > > > > associated hash table followed by an endpoint/sock migr=
ation to a new
> > > > > > > > > > association in sctp_assoc_migrate() prior to their subs=
equent use in
> > > > > > > > > > sctp_diag_dump() which uses sctp_for_each_transport() t=
o walk the hash
> > > > > > > > > > table calling into sctp_sock_dump() where the dereferen=
ce occurs.
> > > > > > >
> > > > > > > > in sctp_sock_dump():
> > > > > > > >         struct sock *sk =3D ep->base.sk;
> > > > > > > >         ... <--[1]
> > > > > > > >         lock_sock(sk);
> > > > > > > >
> > > > > > > > Do you mean in [1], the sk is peeled off and gets freed els=
ewhere?
> > > > > > >
> > > > > > > 'ep' and 'sk' are both switched out for new ones in sctp_sock=
_migrate().
> > > > > > >
> > > > > > > > if that's true, it's still late to do sock_hold(sk) in your=
 this patch.
> > > > > > >
> > > > > > > No, that's not right.
> > > > > > >
> > > > > > > The schedule happens *inside* the lock_sock() call.
> > > > > > Sorry, I don't follow this.
> > > > > > We can't expect when the schedule happens, why do you think thi=
s
> > > > > > can never be scheduled before the lock_sock() call?
> > > > >
> > > > > True, but I've had this running for hours and it hasn't reproduce=
d.
> > > I understand, but it's a crash, we shouldn't take any risk that it
> > > will never happen.
> > > you may try to add a usleep() before the lock_sock call to reproduce =
it.
> > >
> > > > >
> > > > > Without this patch, I can reproduce this in around 2 seconds.
> > > > >
> > > > > The C-repro for this is pretty intense!
> > > > >
> > > > > If you want to be *sure* that a schedule will never happen, we ca=
n
> > > > > take a reference directly with:
> > > > >
> > > > >      ep =3D sctp_endpoint_hold(tsp->asoc->ep);
> > > > >      sk =3D sock_hold(ep->base.sk);
> > > > >
> > > > > Which was my original plan before I soak tested this submitted pa=
tch
> > > > > for hours without any sign of reproducing the issue.
> > > we tried to not export sctp_obj_hold/put(), that's why we had
> > > sctp_for_each_transport().
> > >
> > > ep itself holds a reference of sk when it's alive, so it's weird to d=
o
> > > these 2 together.
> > >
> > > > >
> > > > > > If the sock is peeled off or is being freed, we shouldn't dump =
this sock,
> > > > > > and it's better to skip it.
> > > > >
> > > > > I guess we can do that too.
> > > > >
> > > > > Are you suggesting sctp_sock_migrate() as the call site?
> > > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > > index 85ac2e901ffc..56ea7a0e2add 100644
> > > --- a/net/sctp/socket.c
> > > +++ b/net/sctp/socket.c
> > > @@ -9868,6 +9868,7 @@ static int sctp_sock_migrate(struct sock *oldsk=
,
> > > struct sock *newsk,
> > >                 inet_sk_set_state(newsk, SCTP_SS_ESTABLISHED);
> > >         }
> > >
> > > +       sock_set_flag(oldsk, SOCK_RCU_FREE);
> > >         release_sock(newsk);
> > >
> > >         return 0;
> > >
> > > SOCK_RCU_FREE is set to the previous sk, so that this sk will not
> > > be freed between rcu_read_lock() and rcu_read_unlock().
> > >
> > > >
> > > > Also, when are you planning on testing the flag?
> > > SOCK_RCU_FREE flag is used when freeing sk in sk_destruct(),
> > > and if it's set, it will be freed in the next grace period of RCU.
> > >
> > > >
> > > > Won't that suffer with the same issue(s)?
> > > diff --git a/net/sctp/diag.c b/net/sctp/diag.c
> > > index 7970d786c4a2..b4c4acd9e67e 100644
> > > --- a/net/sctp/diag.c
> > > +++ b/net/sctp/diag.c
> > > @@ -309,16 +309,21 @@ static int sctp_tsp_dump_one(struct
> > > sctp_transport *tsp, void *p)
> > >
> > >  static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
> > >  {
> > > -       struct sctp_endpoint *ep =3D tsp->asoc->ep;
> > >         struct sctp_comm_param *commp =3D p;
> > > -       struct sock *sk =3D ep->base.sk;
> > >         struct sk_buff *skb =3D commp->skb;
> > >         struct netlink_callback *cb =3D commp->cb;
> > >         const struct inet_diag_req_v2 *r =3D commp->r;
> > >         struct sctp_association *assoc;
> > > +       struct sctp_endpoint *ep;
> > > +       struct sock *sk;
> > >         int err =3D 0;
> > >
> > > +       rcu_read_lock();
> > > +       ep =3D tsp->asoc->ep;
> > > +       sk =3D ep->base.sk;
> > >         lock_sock(sk);
> > Unfortunately, this isn't going to work, as lock_sock() may sleep,
> > and is not allowed to be called understand rcu_read_lock() :(
>
> Ah!
>
> How about my original solution of taking:
>
>   tsp->asoc->ep
>
> ... directly?
>
> If it already holds the sk, we should be golden?
Both ep and sk could be destroyed at this moment.
you can't try to hold an object that has already been destroyed.
It holds the sk only when ep is still alive.

I don't see a way to get this fix with the current transport hashtable.
I will change to use port hashtable to dump sock/asocs for this.

Thanks.
>
> --
> Lee Jones [=E6=9D=8E=E7=90=BC=E6=96=AF]
> Senior Technical Lead - Developer Services
> Linaro.org =E2=94=82 Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog
