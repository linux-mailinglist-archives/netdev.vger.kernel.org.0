Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B24439406
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 12:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbhJYKyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 06:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhJYKyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 06:54:14 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54946C061767;
        Mon, 25 Oct 2021 03:51:52 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id z14so10908272wrg.6;
        Mon, 25 Oct 2021 03:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fh1fskkoF+jbku1xwBzK/HJ9EIlnED/P2zBAFD05Eb4=;
        b=mO2rULLueV03iI7NZs4iNK1yo+JOaZCgwBtgOnVX0vygPTUVPCCfC2EQlLIbyEga3F
         MpYH1OC1tU3qcT35GS12Gx+kDK5BqOHFnc3ARfGtWaLazxIKCa555Xqgmm6CN99FKIlV
         259Zrp8zP8az34TrT0+1pOGHbuGdvSO6+8iUbiU6NMl9QlJa+3ENHkW9iO2SAf9RGVl+
         CyPP/34bei2QQP27AK1f0gGpFU68TEJe4oDVkKslqed8H+WrzYHpsUonYHPTm1ZCCl6L
         WLUw3+4oAhvA7I8PJtE3fQy9+f0oG+AKZvp+Faqmtdlr+L7qtDmcEdt2TjMjXHkeXNU6
         HvRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fh1fskkoF+jbku1xwBzK/HJ9EIlnED/P2zBAFD05Eb4=;
        b=ffjNURja0k4rhzJXue95Pi4zJWnaEz35z/HV+NUeBsJ1aBByRTYA1Xf09lVwLZGf5x
         XB9Sf9mrgLqvIq+O4bf//ADXK43/uZOLt1TZvR7oOT84ctO/L2F7byl9z6hqmzzuD/KE
         2x2zGCjy0CZbAARGrKL8ODPqbkda2DoZzOyImWVV03AlV2ts6ke0WhdKaIteas+1HP28
         xX5qVRRO1iHvI9/Byzy8Urrv8XhJNjFEov9noR13Xur78L4wOraDGB6UTXRpAU1yby5V
         rYiFQn8jGMd0u7tqHwKBH3GYrQsbEGZYFO0DXu6M2Zzo9V+muJylYOdmf9DWCDjYzsIS
         W+8g==
X-Gm-Message-State: AOAM531SnH8j/DrrDl5kkf1yJ6n7kPbIiufndDeDquvkqywpRInKG0u+
        br+rjTnqvKgZV5ikARniBWdm1W/BpAyknW3rnMei7bdxuxNJbQ==
X-Google-Smtp-Source: ABdhPJwcoY13AU0737YJZ+99jKh5D/yfJy0+okbk+X1AN8QXzTeaO+4LrSd6TmeUnmxZfXSKxkDmA95w+NsZB/hPdJk=
X-Received: by 2002:a5d:4210:: with SMTP id n16mr8039454wrq.426.1635159110928;
 Mon, 25 Oct 2021 03:51:50 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1634884487.git.lucien.xin@gmail.com> <53026dedd66beeaf18a4570437c4e6c9e760bb90.1634884487.git.lucien.xin@gmail.com>
 <CAFqZXNs89yGcoXumNwavLRQpYutfnLY-SM2qrHbvpjJxVtiniw@mail.gmail.com>
In-Reply-To: <CAFqZXNs89yGcoXumNwavLRQpYutfnLY-SM2qrHbvpjJxVtiniw@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 25 Oct 2021 18:51:39 +0800
Message-ID: <CADvbK_djVKxjfRaLS0EZRY2mkzWXTMnwvbe-b7cK-T3BR8jzKQ@mail.gmail.com>
Subject: Re: [PATCH net 4/4] security: implement sctp_assoc_established hook
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

On Mon, Oct 25, 2021 at 4:17 PM Ondrej Mosnacek <omosnace@redhat.com> wrote:
>
> On Fri, Oct 22, 2021 at 8:36 AM Xin Long <lucien.xin@gmail.com> wrote:
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
>
> Hm... this sounds like something we should also try to fix (if
> possible). In access control we can't trust userspace to do the right
> thing - receiving from multiple peers on one SOCK_SEQPACKET socket
> shouldn't cause checking against the wrong peer_sid. But that can be
> addressed separately. (And maybe it's even already accounted for
> somehow - I didn't yet look at the code closely.)
>
> >
> > Fixes: 72e89f50084c ("security: Add support for SCTP security hooks")
> > Reported-by: Prashanth Prahlad <pprahlad@redhat.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  security/selinux/hooks.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> >
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index f025fc00421b..793fdcbc68bd 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -5525,6 +5525,21 @@ static void selinux_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk
> >         selinux_netlbl_sctp_sk_clone(sk, newsk);
> >  }
> >
> > +static void selinux_sctp_assoc_established(struct sctp_association *asoc,
> > +                                          struct sk_buff *skb)
> > +{
> > +       struct sk_security_struct *sksec = asoc->base.sk->sk_security;
> > +       u16 family = asoc->base.sk->sk_family;
> > +
> > +       /* handle mapped IPv4 packets arriving via IPv6 sockets */
> > +       if (family == PF_INET6 && skb->protocol == htons(ETH_P_IP))
> > +               family = PF_INET;
> > +
> > +       selinux_skb_peerlbl_sid(skb, family, &sksec->peer_sid);
>
> You could replace the above with
> `selinux_inet_conn_established(asoc->base.sk, skb);` to reduce code
> duplication.
Hi Ondrej,

will do, thanks!

>
> > +       asoc->secid = sksec->sid;
> > +       asoc->peer_secid = sksec->peer_sid;
> > +}
> > +
Now I'm thinking: 'peer_sid' should be correct here.

BUT 'sid' is copied from its parent socket. Later when doing peel-off,
asoc->secid will be set back to the peel-off socket's sksec->sid.

Do you think this is okay? or should the peel-off socket have its own
sksec->sid, which might be different from the parent socket's?
(Note the socket's sid initially was set in selinux_socket_post_create())


> >  static int selinux_inet_conn_request(const struct sock *sk, struct sk_buff *skb,
> >                                      struct request_sock *req)
> >  {
> > @@ -7290,6 +7305,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
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
