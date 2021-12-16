Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1C24779C0
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 17:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239791AbhLPQxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 11:53:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbhLPQxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 11:53:09 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2388C061574;
        Thu, 16 Dec 2021 08:53:08 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id 35-20020a9d08a6000000b00579cd5e605eso29744950otf.0;
        Thu, 16 Dec 2021 08:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ESW+fyyPKtN2+hRv2JlFfHZRMNp/L4FEaXwWBR/URdc=;
        b=Ya2sF/SjbUo0wNjPPwnaiYggPnzjkEIc233B5sPbF362nkVYACtL+5yq4NuruoLuz4
         1U3g9bLSkz749Cvngw15phKKbLSS8pF7pqaZY0IovDWOdZUFWzwnRPihGOZrMXg70m6z
         R+Iwp7HAJ1XM1po/pEaDj/vsSfiPv6JtabYrWEvB9rs/dbRHM3MQvijbySq2AMWu9jpH
         yysS2EsR1H9l/JBl91i5P23D97ZCTy1p/zGc0imxzwpqIo/8USs2EXRtasbngxmgwQs2
         Xum/tx2uY4sEm0l6nW/kr1NVoxsIkUBxxo9I6zuZ6S8HCgEwP28Rjky6b6+aIik0wxzr
         zhTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ESW+fyyPKtN2+hRv2JlFfHZRMNp/L4FEaXwWBR/URdc=;
        b=M34QbCgdWbislf4Ff0364efl3LFAu07B3nu2KfAjg+tostQMqeRHM8dBZKYgOF2E+H
         JRrL3PkJ3PIuMm9hcnzvtk8phCw12oHnVuoO8isHXBpIqUUVB0fG/ylb/l02USQizFxJ
         VqXf+c4lRGDu1AUsCOHeKCAHLcL6C7ET9ROCWv7JXlecX0LkBLpiXdF3CyypEKT/3Nfk
         rxHyi4HZXa0vfzcBdexPSti8fFPc1ByxVpc0eQQKctaEgFeG99vwg5uM1b7hK0qgtJQw
         WGjJ73IwStRPqKS2bCGqBrNlemG5Y6kZo9VhVg2O1dFVg/fOcvXjLYw7fyEJyoBkF4dV
         dYew==
X-Gm-Message-State: AOAM53095bDvcqBE6vZPSV7MMUGzGTMpFAYSRkulH7ptCFE8QjpEn1Z3
        e7cjXgIQOiDvz9T+yaSb5j+fhpQ5B1bRl0r56xU=
X-Google-Smtp-Source: ABdhPJwSp9X3NlRm0o15b6v1xFrbUPS+Abaq6YgqH2Dor5+Ois9kCBAsoZH0qFJXE8Osdhwu31U9UrXSMTsbzw774PI=
X-Received: by 2002:a05:6830:2082:: with SMTP id y2mr13076446otq.15.1639673588155;
 Thu, 16 Dec 2021 08:53:08 -0800 (PST)
MIME-Version: 1.0
References: <20211214215732.1507504-1-lee.jones@linaro.org>
 <20211214215732.1507504-2-lee.jones@linaro.org> <20211215174818.65f3af5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADvbK_emZsHVsBvNFk9B5kCZjmAQkMBAx1MtwusDJ-+vt0ukPA@mail.gmail.com> <Ybtrs56tSBbmyt5c@google.com>
In-Reply-To: <Ybtrs56tSBbmyt5c@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 16 Dec 2021 11:52:56 -0500
Message-ID: <CADvbK_cBBDkGt8XLJo6N5TX2YQATS+udVWm8_=8f96=0B9tnTA@mail.gmail.com>
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

On Thu, Dec 16, 2021 at 11:39 AM Lee Jones <lee.jones@linaro.org> wrote:
>
> On Thu, 16 Dec 2021, Xin Long wrote:
>
> > On Wed, Dec 15, 2021 at 8:48 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Tue, 14 Dec 2021 21:57:32 +0000 Lee Jones wrote:
> > > > The cause of the resultant dump_stack() reported below is a
> > > > dereference of a freed pointer to 'struct sctp_endpoint' in
> > > > sctp_sock_dump().
> > > >
> > > > This race condition occurs when a transport is cached into its
> > > > associated hash table followed by an endpoint/sock migration to a n=
ew
> > > > association in sctp_assoc_migrate() prior to their subsequent use i=
n
> > > > sctp_diag_dump() which uses sctp_for_each_transport() to walk the h=
ash
> > > > table calling into sctp_sock_dump() where the dereference occurs.
>
> > in sctp_sock_dump():
> >         struct sock *sk =3D ep->base.sk;
> >         ... <--[1]
> >         lock_sock(sk);
> >
> > Do you mean in [1], the sk is peeled off and gets freed elsewhere?
>
> 'ep' and 'sk' are both switched out for new ones in sctp_sock_migrate().
>
> > if that's true, it's still late to do sock_hold(sk) in your this patch.
>
> No, that's not right.
>
> The schedule happens *inside* the lock_sock() call.
Sorry, I don't follow this.
We can't expect when the schedule happens, why do you think this
can never be scheduled before the lock_sock() call?

If the sock is peeled off or is being freed, we shouldn't dump this sock,
and it's better to skip it.

>
> So if you take the reference before it, you're good.
>
> > I talked with Marcelo about this before, if the possible UAF in [1] exi=
sts,
> > the problem also exists in the main RX path sctp_rcv().
> >
> > > >
> > > >   BUG: KASAN: use-after-free in sctp_sock_dump+0xa8/0x438 [sctp_dia=
g]
> > > >   Call trace:
> > > >    dump_backtrace+0x0/0x2dc
> > > >    show_stack+0x20/0x2c
> > > >    dump_stack+0x120/0x144
> > > >    print_address_description+0x80/0x2f4
> > > >    __kasan_report+0x174/0x194
> > > >    kasan_report+0x10/0x18
> > > >    __asan_load8+0x84/0x8c
> > > >    sctp_sock_dump+0xa8/0x438 [sctp_diag]
> > > >    sctp_for_each_transport+0x1e0/0x26c [sctp]
> > > >    sctp_diag_dump+0x180/0x1f0 [sctp_diag]
> > > >    inet_diag_dump+0x12c/0x168
> > > >    netlink_dump+0x24c/0x5b8
> > > >    __netlink_dump_start+0x274/0x2a8
> > > >    inet_diag_handler_cmd+0x224/0x274
> > > >    sock_diag_rcv_msg+0x21c/0x230
> > > >    netlink_rcv_skb+0xe0/0x1bc
> > > >    sock_diag_rcv+0x34/0x48
> > > >    netlink_unicast+0x3b4/0x430
> > > >    netlink_sendmsg+0x4f0/0x574
> > > >    sock_write_iter+0x18c/0x1f0
> > > >    do_iter_readv_writev+0x230/0x2a8
> > > >    do_iter_write+0xc8/0x2b4
> > > >    vfs_writev+0xf8/0x184
> > > >    do_writev+0xb0/0x1a8
> > > >    __arm64_sys_writev+0x4c/0x5c
> > > >    el0_svc_common+0x118/0x250
> > > >    el0_svc_handler+0x3c/0x9c
> > > >    el0_svc+0x8/0xc
> > > >
> > > > To prevent this from happening we need to take a references to the
> > > > to-be-used/dereferenced 'struct sock' and 'struct sctp_endpoint's
> > > > until such a time when we know it can be safely released.
> > > >
> > > > When KASAN is not enabled, a similar, but slightly different NULL
> > > > pointer derefernce crash occurs later along the thread of execution=
 in
> > > > inet_sctp_diag_fill() this time.
> > Are you able to reproduce this issue?
>
> Yes 100% of the time without this patch.
>
> 0% of the time with it applied.
>
> > What I'm thinking is to fix it by freeing sk in call_rcu() by
> > sock_set_flag(sock->sk, SOCK_RCU_FREE),
> > and add rcu_read_lock() in sctp_sock_dump().
> >
> > Thanks.
> >
> > >
> > > Are you able to identify where the bug was introduced? Fixes tag woul=
d
> > > be good to have here.
>
> It's probably been there since the code was introduced.
>
> I'll see how far back we have to go.
>
> > > You should squash the two patches together.
>
> I generally like patches to encapsulate functional changes.
>
> This one depends on the other, but they are not functionally related.
>
> You're the boss though - I'll squash them if you insist.
>
> > > > diff --git a/net/sctp/diag.c b/net/sctp/diag.c
> > > > index 760b367644c12..2029b240b6f24 100644
> > > > --- a/net/sctp/diag.c
> > > > +++ b/net/sctp/diag.c
> > > > @@ -301,6 +301,8 @@ static int sctp_sock_dump(struct sctp_transport=
 *tsp, void *p)
> > > >       struct sctp_association *assoc;
> > > >       int err =3D 0;
> > > >
> > > > +     sctp_endpoint_hold(ep);
> > > > +     sock_hold(sk);
> > > >       lock_sock(sk);
> > > >       list_for_each_entry(assoc, &ep->asocs, asocs) {
> > > >               if (cb->args[4] < cb->args[1])
> > > > @@ -341,6 +343,8 @@ static int sctp_sock_dump(struct sctp_transport=
 *tsp, void *p)
> > > >       cb->args[4] =3D 0;
> > > >  release:
> > > >       release_sock(sk);
> > > > +     sock_put(sk);
> > > > +     sctp_endpoint_put(ep);
> > > >       return err;
> > > >  }
> > > >
> > >
>
> --
> Lee Jones [=E6=9D=8E=E7=90=BC=E6=96=AF]
> Senior Technical Lead - Developer Services
> Linaro.org =E2=94=82 Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog
