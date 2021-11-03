Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057B544473B
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 18:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhKCRgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 13:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbhKCRgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 13:36:32 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D72C061714;
        Wed,  3 Nov 2021 10:33:55 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id d3so4724610wrh.8;
        Wed, 03 Nov 2021 10:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0xLejg5cJdjHk58eyFUdnbex1c5m6lZMQcewkdVcoy4=;
        b=JksoZVPgXI5phyYck/llydetQUvt8OcZn1Nl/30zCFsLe1e96cbKp8+w1MuSh59rGY
         Vg1V+ySsj+afQGPoOhCHxGoRbHQFahTgnYPIr2LncnZbuYD2t7ZCYNmcxjfFsen6AviC
         q0SUplsgJ21MBWk2/celrQJfwVqjHBQs/aomBBsnhLkqTsYCXDIEG45eVurEVK1bq+ni
         JJhdAa5uIEWwd/YajjeEPlJnnDFraqk+PrRFgkM1QyHDHWfqla+f3uuJuj141DdUHyv1
         f0TKsubrU+llC/flRX5wJrRd0WaGrjPW9ZZ/cNDSKMoLTezkUhwQWLxVPkHBLqFKk3c3
         90HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0xLejg5cJdjHk58eyFUdnbex1c5m6lZMQcewkdVcoy4=;
        b=LJw0fWHhTEqX3morEMsxNlEdb24FedKlNrWcGalC0pnK2G97xkfFhtrZR2sR6vTPKL
         0A0oLkminyPnTiFCQWX1W9Ez0LLgIzB6rSP1YxvCG5I/1Q4+D13mBxUv+YBVp37MGXPg
         08BL7bzTq/cBaV7QqYok5LKxQ7IuAfxYzX/HPuSAONgTcSduRvSl/Z+VzD5kjSLlU69N
         XPp++zLwfWfsfQcQFBkY2Ovz5etUulb2wpm759cbWOIuD9rWEeB5q9EOxDQYA08qyoqF
         pOPcCW6QXXX/7kjNRwXfmrgTID/v1O8T48em9mYRyigY2R5WgyXi0ugT8FeidzKOzBN2
         jxfA==
X-Gm-Message-State: AOAM5326snv891IvMnmO37UVtUir0LHcCew0kPqVHnCGHAwmo2GArngA
        ZKbMwdaY4dVgDCoN/gDarFL9VhNgzsB7CyWNYtA=
X-Google-Smtp-Source: ABdhPJz5WDwKYzJWG2Hanzknur0b8RQVUU6sXAgM1LGPsCgwc1ra823BG72RvJFW+1B8YqTGQUV9MBNcO49F6kp2j6c=
X-Received: by 2002:a5d:47aa:: with SMTP id 10mr26585521wrb.50.1635960834028;
 Wed, 03 Nov 2021 10:33:54 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1635854268.git.lucien.xin@gmail.com> <cdca8eaca8a0ec5fe4aa58412a6096bb08c3c9bc.1635854268.git.lucien.xin@gmail.com>
 <CAFqZXNtJNnk+iwLnGq6mpdTKuWFmZ4W0PCTj4ira7G2HHPU1tA@mail.gmail.com>
In-Reply-To: <CAFqZXNtJNnk+iwLnGq6mpdTKuWFmZ4W0PCTj4ira7G2HHPU1tA@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 3 Nov 2021 13:33:41 -0400
Message-ID: <CADvbK_cDSKJ+eWeOdvURV_mDXEgEE+B3ZG3ASiKOm501NO9CqQ@mail.gmail.com>
Subject: Re: [PATCHv2 net 4/4] security: implement sctp_assoc_established hook
 in selinux
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     network dev <netdev@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        James Morris <jmorris@namei.org>,
        Paul Moore <paul@paul-moore.com>,
        Richard Haines <richard_c_haines@btinternet.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 3, 2021 at 12:40 PM Ondrej Mosnacek <omosnace@redhat.com> wrote:
>
> Hi Xin,
>
> On Tue, Nov 2, 2021 at 1:03 PM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > Different from selinux_inet_conn_established(), it also gives the
> > secid to asoc->peer_secid in selinux_sctp_assoc_established(),
> > as one UDP-type socket may have more than one asocs.
> >
> > Note that peer_secid in asoc will save the peer secid for this
> > asoc connection, and peer_sid in sksec will just keep the peer
> > secid for the latest connection. So the right use should be do
> > peeloff for UDP-type socket if there will be multiple asocs in
> > one socket, so that the peeloff socket has the right label for
> > its asoc.
> >
> > v1->v2:
> >   - call selinux_inet_conn_established() to reduce some code
> >     duplication in selinux_sctp_assoc_established(), as Ondrej
> >     suggested.
> >   - when doing peeloff, it calls sock_create() where it actually
> >     gets secid for socket from socket_sockcreate_sid(). So reuse
> >     SECSID_WILD to ensure the peeloff socket keeps using that
> >     secid after calling selinux_sctp_sk_clone() for client side.
>
> Interesting... I find strange that SCTP creates the peeloff socket
> using sock_create() rather than allocating it directly via
> sock_alloc() like the other callers of sctp_copy_sock() (which calls
> security_sctp_sk_clone()) do. Wouldn't it make more sense to avoid the
> sock_create() call and just rely on the security_sctp_sk_clone()
> semantic to set up the labels? Would anything break if
> sctp_do_peeloff() switched to plain sock_alloc()?
>
> I'd rather we avoid this SECSID_WILD hack to support the weird
> created-but-also-cloned socket hybrid and just make the peeloff socket
> behave the same as an accept()-ed socket (i.e. no
> security_socket_[post_]create() hook calls, just
> security_sctp_sk_clone()).

please check Paul's comment:

"""
 The initial SCTP client association would
need to take it's label from the parent process so perhaps that is the
right answer for all SCTP client associations[2].

[1] I would expect server side associations to follow the more
complicated selinux_conn_sid() labeling, just as we do for TCP/stream
connections today.

[2] I'm guessing the client associations might also want to follow the
setsockcreatecon(3) behavior, see selinux_sockcreate_sid() for more
info.
"""

That's what I got from it:
For client side, secid should be copied from its parent socket directly, but
get it from socket_sockcreate_sid().

and you?

>
> >
> > Fixes: 72e89f50084c ("security: Add support for SCTP security hooks")
> > Reported-by: Prashanth Prahlad <pprahlad@redhat.com>
> > Reviewed-by: Richard Haines <richard_c_haines@btinternet.com>
> > Tested-by: Richard Haines <richard_c_haines@btinternet.com>
>
> You made non-trivial changes since the last revision in this patch, so
> you should have also dropped the Reviewed-by and Tested-by here. Now
> David has merged the patches probably under the impression that they
> have been reviewed/approved from the SELinux side, which isn't
> completely true.
Oh, that's a mistake, I thought I didn't add it.
Will he be able to test this new patchset?

Thanks.

>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  security/selinux/hooks.c | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index a9977a2ae8ac..341cd5dccbf5 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -5519,7 +5519,8 @@ static void selinux_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk
> >         if (!selinux_policycap_extsockclass())
> >                 return selinux_sk_clone_security(sk, newsk);
> >
> > -       newsksec->sid = asoc->secid;
> > +       if (asoc->secid != SECSID_WILD)
> > +               newsksec->sid = asoc->secid;
> >         newsksec->peer_sid = asoc->peer_secid;
> >         newsksec->sclass = sksec->sclass;
> >         selinux_netlbl_sctp_sk_clone(sk, newsk);
> > @@ -5575,6 +5576,16 @@ static void selinux_inet_conn_established(struct sock *sk, struct sk_buff *skb)
> >         selinux_skb_peerlbl_sid(skb, family, &sksec->peer_sid);
> >  }
> >
> > +static void selinux_sctp_assoc_established(struct sctp_association *asoc,
> > +                                          struct sk_buff *skb)
> > +{
> > +       struct sk_security_struct *sksec = asoc->base.sk->sk_security;
> > +
> > +       selinux_inet_conn_established(asoc->base.sk, skb);
> > +       asoc->peer_secid = sksec->peer_sid;
> > +       asoc->secid = SECSID_WILD;
> > +}
> > +
> >  static int selinux_secmark_relabel_packet(u32 sid)
> >  {
> >         const struct task_security_struct *__tsec;
> > @@ -7290,6 +7301,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
> >         LSM_HOOK_INIT(sctp_assoc_request, selinux_sctp_assoc_request),
> >         LSM_HOOK_INIT(sctp_sk_clone, selinux_sctp_sk_clone),
> >         LSM_HOOK_INIT(sctp_bind_connect, selinux_sctp_bind_connect),
> > +       LSM_HOOK_INIT(sctp_assoc_established, selinux_sctp_assoc_established),
> >         LSM_HOOK_INIT(inet_conn_request, selinux_inet_conn_request),
> >         LSM_HOOK_INIT(inet_csk_clone, selinux_inet_csk_clone),
> >         LSM_HOOK_INIT(inet_conn_established, selinux_inet_conn_established),
> > --
> > 2.27.0
> >
>
> --
> Ondrej Mosnacek
> Software Engineer, Linux Security - SELinux kernel
> Red Hat, Inc.
>
