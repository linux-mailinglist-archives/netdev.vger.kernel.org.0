Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2A2477B6B
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 19:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240585AbhLPSWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 13:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbhLPSWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 13:22:17 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD06C061574;
        Thu, 16 Dec 2021 10:22:17 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id bf8so111112oib.6;
        Thu, 16 Dec 2021 10:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+/y/44R+5YxgMSzOe/nu0eMT5/71CNxaGar8eA8Nm/g=;
        b=Gu6Yjm9T9BlEUP1BozNFLGnraX0pNby3F9uUxdR3PMpZcpViSdV1XmUsEcGJQu+L8V
         o//pVimMeEGMMqYJ1QiXqK2p30al9ng6mdoR2lhbtmyuLQWx7bXxDw9SkTzqnuyzd0zD
         J2UrUKTrRoQWde5x7va5rQa99Z5eF1Jl6LDJk2fd9h6+wJ/uYk+9yEKi3E1aAD7Xvmrv
         2XleZY+b6XQ36wQr+CPMI/oi5GeWjfA0ltH1hFQ7chQGgRN5rwfXBkGVaGyYN5SRVGI+
         OD3Rfvzjg2mMhjOwuOPS5CHdQ9pwBdLOz07TRXlqBwK7JOxi0SZyap4x53ntoGA2DOU0
         YcLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+/y/44R+5YxgMSzOe/nu0eMT5/71CNxaGar8eA8Nm/g=;
        b=phkNKUswFIgK2Bz8krezsZSryX/6l5ALOpZYeJF8ssBlTK5AMJXeSlShMzKViZl06v
         jGv6AtWObxJKhv9Sgdv+VE/37OJj10+y3Ozs4IYED696Dx/vjfPn4H8O2qz7djhVIJzM
         gOmRT/v5anOLg39UDUEfjCKCM3RxrNgdGfJY8LbFwxbUQFRf280CbipOlGFUn3vu7i/v
         8zqhi+RSX3ot1ltiTYsnlcBgkWIPVYGjBPaGGZVnZ/KlYZ9u9x+39mIo+vIRSbt6QzRL
         KUA4W/wLkaYlZMukYszqB3f4FMsd0fldyLJoUWzP8+HSNoTjXOiTaKcbkmuVD9mFutFB
         P1qQ==
X-Gm-Message-State: AOAM531oroWEhq1fhXGyb6kg3pT9IyQ/3kra5O99i6czv6qt/lIW2Dy7
        klKGqvFDh8kPngjwIOkyIhGW6tWSgZKImUmUorg=
X-Google-Smtp-Source: ABdhPJyuqku/PJcEaFhoUbjY9eGQTzngMM1pszlWG5TdzymHX4wb5mzqbyT6CsEgCbAiA68p93W8U2yrhA/LLntNcKE=
X-Received: by 2002:a05:6808:10c9:: with SMTP id s9mr5031186ois.23.1639678936900;
 Thu, 16 Dec 2021 10:22:16 -0800 (PST)
MIME-Version: 1.0
References: <20211214215732.1507504-1-lee.jones@linaro.org>
 <20211214215732.1507504-2-lee.jones@linaro.org> <20211215174818.65f3af5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADvbK_emZsHVsBvNFk9B5kCZjmAQkMBAx1MtwusDJ-+vt0ukPA@mail.gmail.com>
 <Ybtrs56tSBbmyt5c@google.com> <CADvbK_cBBDkGt8XLJo6N5TX2YQATS+udVWm8_=8f96=0B9tnTA@mail.gmail.com>
 <Ybtzr5ZmD/IKjycz@google.com> <Ybtz/0gflbkG5Q/0@google.com> <CADvbK_cexKiVATn=dPrWqoS0qM-bM0UcSkx8Xqz5ibEKQizDVg@mail.gmail.com>
In-Reply-To: <CADvbK_cexKiVATn=dPrWqoS0qM-bM0UcSkx8Xqz5ibEKQizDVg@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 16 Dec 2021 13:22:05 -0500
Message-ID: <CADvbK_cxMbYwkuN_ZUvHY-7ahc9ff+jbuPkKn6CA=yqMk=SKVw@mail.gmail.com>
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

(

On Thu, Dec 16, 2021 at 1:12 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Thu, Dec 16, 2021 at 12:14 PM Lee Jones <lee.jones@linaro.org> wrote:
> >
> > On Thu, 16 Dec 2021, Lee Jones wrote:
> >
> > > On Thu, 16 Dec 2021, Xin Long wrote:
> > >
> > > > On Thu, Dec 16, 2021 at 11:39 AM Lee Jones <lee.jones@linaro.org> w=
rote:
> > > > >
> > > > > On Thu, 16 Dec 2021, Xin Long wrote:
> > > > >
> > > > > > On Wed, Dec 15, 2021 at 8:48 PM Jakub Kicinski <kuba@kernel.org=
> wrote:
> > > > > > >
> > > > > > > On Tue, 14 Dec 2021 21:57:32 +0000 Lee Jones wrote:
> > > > > > > > The cause of the resultant dump_stack() reported below is a
> > > > > > > > dereference of a freed pointer to 'struct sctp_endpoint' in
> > > > > > > > sctp_sock_dump().
> > > > > > > >
> > > > > > > > This race condition occurs when a transport is cached into =
its
> > > > > > > > associated hash table followed by an endpoint/sock migratio=
n to a new
> > > > > > > > association in sctp_assoc_migrate() prior to their subseque=
nt use in
> > > > > > > > sctp_diag_dump() which uses sctp_for_each_transport() to wa=
lk the hash
> > > > > > > > table calling into sctp_sock_dump() where the dereference o=
ccurs.
> > > > >
> > > > > > in sctp_sock_dump():
> > > > > >         struct sock *sk =3D ep->base.sk;
> > > > > >         ... <--[1]
> > > > > >         lock_sock(sk);
> > > > > >
> > > > > > Do you mean in [1], the sk is peeled off and gets freed elsewhe=
re?
> > > > >
> > > > > 'ep' and 'sk' are both switched out for new ones in sctp_sock_mig=
rate().
> > > > >
> > > > > > if that's true, it's still late to do sock_hold(sk) in your thi=
s patch.
> > > > >
> > > > > No, that's not right.
> > > > >
> > > > > The schedule happens *inside* the lock_sock() call.
> > > > Sorry, I don't follow this.
> > > > We can't expect when the schedule happens, why do you think this
> > > > can never be scheduled before the lock_sock() call?
> > >
> > > True, but I've had this running for hours and it hasn't reproduced.
> I understand, but it's a crash, we shouldn't take any risk that it
> will never happen.
> you may try to add a usleep() before the lock_sock call to reproduce it.
>
> > >
> > > Without this patch, I can reproduce this in around 2 seconds.
> > >
> > > The C-repro for this is pretty intense!
> > >
> > > If you want to be *sure* that a schedule will never happen, we can
> > > take a reference directly with:
> > >
> > >      ep =3D sctp_endpoint_hold(tsp->asoc->ep);
> > >      sk =3D sock_hold(ep->base.sk);
> > >
> > > Which was my original plan before I soak tested this submitted patch
> > > for hours without any sign of reproducing the issue.
> we tried to not export sctp_obj_hold/put(), that's why we had
> sctp_for_each_transport().
>
> ep itself holds a reference of sk when it's alive, so it's weird to do
> these 2 together.
>
> > >
> > > > If the sock is peeled off or is being freed, we shouldn't dump this=
 sock,
> > > > and it's better to skip it.
> > >
> > > I guess we can do that too.
> > >
> > > Are you suggesting sctp_sock_migrate() as the call site?
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 85ac2e901ffc..56ea7a0e2add 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -9868,6 +9868,7 @@ static int sctp_sock_migrate(struct sock *oldsk,
> struct sock *newsk,
>                 inet_sk_set_state(newsk, SCTP_SS_ESTABLISHED);
>         }
>
> +       sock_set_flag(oldsk, SOCK_RCU_FREE);
>         release_sock(newsk);
>
>         return 0;
>
> SOCK_RCU_FREE is set to the previous sk, so that this sk will not
> be freed between rcu_read_lock() and rcu_read_unlock().
>
> >
> > Also, when are you planning on testing the flag?
> SOCK_RCU_FREE flag is used when freeing sk in sk_destruct(),
> and if it's set, it will be freed in the next grace period of RCU.
>
> >
> > Won't that suffer with the same issue(s)?
> diff --git a/net/sctp/diag.c b/net/sctp/diag.c
> index 7970d786c4a2..b4c4acd9e67e 100644
> --- a/net/sctp/diag.c
> +++ b/net/sctp/diag.c
> @@ -309,16 +309,21 @@ static int sctp_tsp_dump_one(struct
> sctp_transport *tsp, void *p)
>
>  static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
>  {
> -       struct sctp_endpoint *ep =3D tsp->asoc->ep;
>         struct sctp_comm_param *commp =3D p;
> -       struct sock *sk =3D ep->base.sk;
>         struct sk_buff *skb =3D commp->skb;
>         struct netlink_callback *cb =3D commp->cb;
>         const struct inet_diag_req_v2 *r =3D commp->r;
>         struct sctp_association *assoc;
> +       struct sctp_endpoint *ep;
> +       struct sock *sk;
>         int err =3D 0;
>
> +       rcu_read_lock();
> +       ep =3D tsp->asoc->ep;
> +       sk =3D ep->base.sk;
>         lock_sock(sk);
Unfortunately, this isn't going to work, as lock_sock() may sleep,
and is not allowed to be called understand rcu_read_lock() :(

> +       if (tsp->asoc->ep !=3D ep)
> +               goto release;
>         list_for_each_entry(assoc, &ep->asocs, asocs) {
>                 if (cb->args[4] < cb->args[1])
>                         goto next;
> @@ -358,6 +363,7 @@ static int sctp_sock_dump(struct sctp_transport
> *tsp, void *p)
>         cb->args[4] =3D 0;
>  release:
>         release_sock(sk);
> +       rcu_read_unlock();
>         return err;
>  }
>
> rcu_read_lock() will make sure sk from tsp->asoc->ep->base.sk will not
> be freed until rcu_read_unlock().
>
> That's all I have. Do you see any other way to fix this?
>
> Thanks.
>
> >
> > --
> > Lee Jones [=E6=9D=8E=E7=90=BC=E6=96=AF]
> > Senior Technical Lead - Developer Services
> > Linaro.org =E2=94=82 Open source software for Arm SoCs
> > Follow Linaro: Facebook | Twitter | Blog
