Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F1347C7CB
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 20:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241914AbhLUTwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 14:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbhLUTwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 14:52:37 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC397C061574;
        Tue, 21 Dec 2021 11:52:36 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id bk14so394350oib.7;
        Tue, 21 Dec 2021 11:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=G8xwXNs0/A4OcQxmIObsZEJvT3yBUuKYO/Na1Gfo+IE=;
        b=i4iaNxxgQ5957L++RTush1h/d2j8s0RCoDpYBVwKE4Eo1Lisva6Mkb/6ijUqa7SXTY
         Hh+nIk5+iIqSN88OMMbb7OOAxotfqSeAOHStq5eFmnlJBSnVSGPpPEnCZKqgmWP6OSm8
         +NhQKa0ett9iidBvhuFYcm0IjJXbxyOJyMN51bGnjUHTmm+Ey/g5p+V0k/2Ysyr1gWS9
         IgtZFDRy5bD6yFua1SErYIJ2JlERYt4J1VqkjX+hGZUT317QLRQ2TwaS1NDeCd7neJdr
         n919dad/WbTfsnyaJ8HOnzQA4WyuGhbL31AbDF9FOZvfhKnPF09RfcF/gCcX5iuv5Op4
         ahBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=G8xwXNs0/A4OcQxmIObsZEJvT3yBUuKYO/Na1Gfo+IE=;
        b=hlVp11kyXZUAvrAsGDzxap5AEZ3ak5OCQ7W7a8m3Ms/6sHFJ5PooegEdxa1uSdn4x2
         Bb+Q1uHtn+9JDjTw7pdq03cbzKNltPcbDnhfDY9l2ofYVACYRPpCnR/FRJcb2GGPItJX
         Nv3alzb3E5FzTE9hsFbGzahIG3qcKkjJi/46ZsBSB6rX8orIxCk+crFG+HmftqIX6P1o
         U/xeWL9ZveMfMZuoXmyUOGNR48RBDk/NgOMRq7XTFzun0ImB4LeENJb15LFMOUDai3Xn
         /UaMvATkSnfV5Dgyvzv2QDkGsM6CqX5UuoY1Fc7rYGl5poQUjqpMpDr3xlxRsCl4kTJJ
         0q7Q==
X-Gm-Message-State: AOAM533yOi9+0NukeSt0VlfQ67AeuDFBk4Re2llgZfUt0batnXjQ8r9g
        37C/lOJ47cXA9h9ePpIT7CoTD8Gv0ap0QpYeFwo=
X-Google-Smtp-Source: ABdhPJz9v9lcv80djuxVUaYbEIuNjEIWYVy+nW+16fjTwvNdkNKCi7KGIPZKat8fMEtKoaCJJFpBnEuWLUXqCMDGncA=
X-Received: by 2002:aca:ea55:: with SMTP id i82mr25609oih.96.1640116356248;
 Tue, 21 Dec 2021 11:52:36 -0800 (PST)
MIME-Version: 1.0
References: <20211215174818.65f3af5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADvbK_emZsHVsBvNFk9B5kCZjmAQkMBAx1MtwusDJ-+vt0ukPA@mail.gmail.com>
 <Ybtrs56tSBbmyt5c@google.com> <CADvbK_cBBDkGt8XLJo6N5TX2YQATS+udVWm8_=8f96=0B9tnTA@mail.gmail.com>
 <Ybtzr5ZmD/IKjycz@google.com> <Ybtz/0gflbkG5Q/0@google.com>
 <CADvbK_cexKiVATn=dPrWqoS0qM-bM0UcSkx8Xqz5ibEKQizDVg@mail.gmail.com>
 <CADvbK_cxMbYwkuN_ZUvHY-7ahc9ff+jbuPkKn6CA=yqMk=SKVw@mail.gmail.com>
 <YbuNZtV/pjDszTad@google.com> <CADvbK_f7wY_tknw5wTo369-2aRSvhhkETwmdu9tRbgfeyyTQng@mail.gmail.com>
 <YcBFSo/4WsMOls8Y@google.com>
In-Reply-To: <YcBFSo/4WsMOls8Y@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 21 Dec 2021 14:52:24 -0500
Message-ID: <CADvbK_dF-+3J5HOGsmmvA4by=STNLEaWszZjNOOAdEkrstpYEQ@mail.gmail.com>
Subject: Re: [RESEND 2/2] sctp: hold cached endpoints to prevent possible UAF
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        lksctp developers <linux-sctp@vger.kernel.org>,
        "H.P. Yarroll" <piggy@acm.org>, Hui Huang <hui.huang@nokia.com>,
        network dev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 20, 2021 at 3:56 AM Lee Jones <lee.jones@linaro.org> wrote:
>
> On Sun, 19 Dec 2021, Xin Long wrote:
>
> > On Thu, Dec 16, 2021 at 2:03 PM Lee Jones <lee.jones@linaro.org> wrote:
> > >
> > > On Thu, 16 Dec 2021, Xin Long wrote:
> > >
> > > > (
> > > >
> > > > On Thu, Dec 16, 2021 at 1:12 PM Xin Long <lucien.xin@gmail.com> wro=
te:
> > > > >
> > > > > On Thu, Dec 16, 2021 at 12:14 PM Lee Jones <lee.jones@linaro.org>=
 wrote:
> > > > > >
> > > > > > On Thu, 16 Dec 2021, Lee Jones wrote:
> > > > > >
> > > > > > > On Thu, 16 Dec 2021, Xin Long wrote:
> > > > > > >
> > > > > > > > On Thu, Dec 16, 2021 at 11:39 AM Lee Jones <lee.jones@linar=
o.org> wrote:
> > > > > > > > >
> > > > > > > > > On Thu, 16 Dec 2021, Xin Long wrote:
> > > > > > > > >
> > > > > > > > > > On Wed, Dec 15, 2021 at 8:48 PM Jakub Kicinski <kuba@ke=
rnel.org> wrote:
> > > > > > > > > > >
> > > > > > > > > > > On Tue, 14 Dec 2021 21:57:32 +0000 Lee Jones wrote:
> > > > > > > > > > > > The cause of the resultant dump_stack() reported be=
low is a
> > > > > > > > > > > > dereference of a freed pointer to 'struct sctp_endp=
oint' in
> > > > > > > > > > > > sctp_sock_dump().
> > > > > > > > > > > >
> > > > > > > > > > > > This race condition occurs when a transport is cach=
ed into its
> > > > > > > > > > > > associated hash table followed by an endpoint/sock =
migration to a new
> > > > > > > > > > > > association in sctp_assoc_migrate() prior to their =
subsequent use in
> > > > > > > > > > > > sctp_diag_dump() which uses sctp_for_each_transport=
() to walk the hash
> > > > > > > > > > > > table calling into sctp_sock_dump() where the deref=
erence occurs.
> > > > > > > > >
> > > > > > > > > > in sctp_sock_dump():
> > > > > > > > > >         struct sock *sk =3D ep->base.sk;
> > > > > > > > > >         ... <--[1]
> > > > > > > > > >         lock_sock(sk);
> > > > > > > > > >
> > > > > > > > > > Do you mean in [1], the sk is peeled off and gets freed=
 elsewhere?
> > > > > > > > >
> > > > > > > > > 'ep' and 'sk' are both switched out for new ones in sctp_=
sock_migrate().
> > > > > > > > >
> > > > > > > > > > if that's true, it's still late to do sock_hold(sk) in =
your this patch.
> > > > > > > > >
> > > > > > > > > No, that's not right.
> > > > > > > > >
> > > > > > > > > The schedule happens *inside* the lock_sock() call.
> > > > > > > > Sorry, I don't follow this.
> > > > > > > > We can't expect when the schedule happens, why do you think=
 this
> > > > > > > > can never be scheduled before the lock_sock() call?
> > > > > > >
> > > > > > > True, but I've had this running for hours and it hasn't repro=
duced.
> > > > > I understand, but it's a crash, we shouldn't take any risk that i=
t
> > > > > will never happen.
> > > > > you may try to add a usleep() before the lock_sock call to reprod=
uce it.
> > > > >
> > > > > > >
> > > > > > > Without this patch, I can reproduce this in around 2 seconds.
> > > > > > >
> > > > > > > The C-repro for this is pretty intense!
> > > > > > >
> > > > > > > If you want to be *sure* that a schedule will never happen, w=
e can
> > > > > > > take a reference directly with:
> > > > > > >
> > > > > > >      ep =3D sctp_endpoint_hold(tsp->asoc->ep);
> > > > > > >      sk =3D sock_hold(ep->base.sk);
> > > > > > >
> > > > > > > Which was my original plan before I soak tested this submitte=
d patch
> > > > > > > for hours without any sign of reproducing the issue.
> > > > > we tried to not export sctp_obj_hold/put(), that's why we had
> > > > > sctp_for_each_transport().
> > > > >
> > > > > ep itself holds a reference of sk when it's alive, so it's weird =
to do
> > > > > these 2 together.
> > > > >
> > > > > > >
> > > > > > > > If the sock is peeled off or is being freed, we shouldn't d=
ump this sock,
> > > > > > > > and it's better to skip it.
> > > > > > >
> > > > > > > I guess we can do that too.
> > > > > > >
> > > > > > > Are you suggesting sctp_sock_migrate() as the call site?
> > > > > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > > > > index 85ac2e901ffc..56ea7a0e2add 100644
> > > > > --- a/net/sctp/socket.c
> > > > > +++ b/net/sctp/socket.c
> > > > > @@ -9868,6 +9868,7 @@ static int sctp_sock_migrate(struct sock *o=
ldsk,
> > > > > struct sock *newsk,
> > > > >                 inet_sk_set_state(newsk, SCTP_SS_ESTABLISHED);
> > > > >         }
> > > > >
> > > > > +       sock_set_flag(oldsk, SOCK_RCU_FREE);
> > > > >         release_sock(newsk);
> > > > >
> > > > >         return 0;
> > > > >
> > > > > SOCK_RCU_FREE is set to the previous sk, so that this sk will not
> > > > > be freed between rcu_read_lock() and rcu_read_unlock().
> > > > >
> > > > > >
> > > > > > Also, when are you planning on testing the flag?
> > > > > SOCK_RCU_FREE flag is used when freeing sk in sk_destruct(),
> > > > > and if it's set, it will be freed in the next grace period of RCU=
.
> > > > >
> > > > > >
> > > > > > Won't that suffer with the same issue(s)?
> > > > > diff --git a/net/sctp/diag.c b/net/sctp/diag.c
> > > > > index 7970d786c4a2..b4c4acd9e67e 100644
> > > > > --- a/net/sctp/diag.c
> > > > > +++ b/net/sctp/diag.c
> > > > > @@ -309,16 +309,21 @@ static int sctp_tsp_dump_one(struct
> > > > > sctp_transport *tsp, void *p)
> > > > >
> > > > >  static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
> > > > >  {
> > > > > -       struct sctp_endpoint *ep =3D tsp->asoc->ep;
> > > > >         struct sctp_comm_param *commp =3D p;
> > > > > -       struct sock *sk =3D ep->base.sk;
> > > > >         struct sk_buff *skb =3D commp->skb;
> > > > >         struct netlink_callback *cb =3D commp->cb;
> > > > >         const struct inet_diag_req_v2 *r =3D commp->r;
> > > > >         struct sctp_association *assoc;
> > > > > +       struct sctp_endpoint *ep;
> > > > > +       struct sock *sk;
> > > > >         int err =3D 0;
> > > > >
> > > > > +       rcu_read_lock();
> > > > > +       ep =3D tsp->asoc->ep;
> > > > > +       sk =3D ep->base.sk;
> > > > >         lock_sock(sk);
> > > > Unfortunately, this isn't going to work, as lock_sock() may sleep,
> > > > and is not allowed to be called understand rcu_read_lock() :(
> > >
> > > Ah!
> > >
> > > How about my original solution of taking:
> > >
> > >   tsp->asoc->ep
> > >
> > > ... directly?
> > >
> > > If it already holds the sk, we should be golden?
> > Both ep and sk could be destroyed at this moment.
> > you can't try to hold an object that has already been destroyed.
> > It holds the sk only when ep is still alive.
> >
> > I don't see a way to get this fix with the current transport hashtable.
> > I will change to use port hashtable to dump sock/asocs for this.
>
> Right.  Cache invalidation is hard!
>
> Sure, if there is a better way, please go ahead.
Hi, Jones,

Port hashtable doesn't work either as lock_sock can not be called
under spin_lock().

I posted another patch where this issue can be fixed by moving ep free
to call_rcu().
It will be great if you are able to test it.

Thanks.

>
> Thanks.
>
> --
> Lee Jones [=E6=9D=8E=E7=90=BC=E6=96=AF]
> Senior Technical Lead - Developer Services
> Linaro.org =E2=94=82 Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog
