Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE9A44519E
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 11:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhKDKnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 06:43:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31889 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229809AbhKDKnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 06:43:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636022435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d85cq3e+gY+RFYzObrRjB95nMqlpdlXGq+udehhKLTU=;
        b=fKLTsR7VSCkcATGfsKF39Y1SmpjG+FiTEv7jt3iDrPc95SP9RNbkLMc5B6Kxf/wfYonZ8M
        NI95DBYtNfviMLYhBZqffX+dMhvX7dYEsS7NT5YEgtnOY0lDhT7m+evo08SFeUbX18MUwl
        /GhluZrdOfnzDknaTB3Z5n/hTF5DOTc=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-3YvT1K4AMzOgwuRjpiQxHw-1; Thu, 04 Nov 2021 06:40:35 -0400
X-MC-Unique: 3YvT1K4AMzOgwuRjpiQxHw-1
Received: by mail-yb1-f197.google.com with SMTP id s189-20020a252cc6000000b005c1f206d91eso8079578ybs.14
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 03:40:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d85cq3e+gY+RFYzObrRjB95nMqlpdlXGq+udehhKLTU=;
        b=wOe0b5mHBJNYA3zWvbnqcgqSL+XuZkSSfs3chA0XzPjoes/GLx8YN2/ib4iXKjPjv6
         kvBYXEqimf7rm/U5YrWcNk3aZcO3sGtjx2fwQtzwVUKeMa0AbIXYGNObowTUfMOqef8I
         0PSIUIxzNXINevyfjvi8XiLxJd6DBN98GXehH71RSAoXgxxCYxoOSA4tS4STFXa8q3HY
         DDU8lYgaCwQ2xQtia1p5z8V+I/iRMP3xs3vJvK/D1o3ReLEE9h2JRrg3YKmWWMHx0oJT
         LIjGXeL6kiAEDJwiiwOdihXnBQ7uzQJdm9WkKALPGgUPeOMjJUJezVz4IiBWAR8fpAEK
         GoWA==
X-Gm-Message-State: AOAM5337Tt2GvrySvHtO9XIPgy2iY5o0t4MqxX88iAK2OkVzu6Kbd7ow
        8z53jDyZGdOY5nxwMg0NZLD99MmPCmWp2Hd6u5+JM57aeLry+u2hjO5GAgbb8NSOlCOFo/XK9NL
        rbcA6+P/esTpY38dhVrqhg0IDPJ/PXs/W
X-Received: by 2002:a25:8205:: with SMTP id q5mr41500771ybk.256.1636022434283;
        Thu, 04 Nov 2021 03:40:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxe8DH5G7BKS+RoTciQRrRmoZzMj+563HC+blRzICyrBk8D02cJvZaSvtQyhkfRBx0tupfTWVGs60moeAUe/Hw=
X-Received: by 2002:a25:8205:: with SMTP id q5mr41500743ybk.256.1636022433959;
 Thu, 04 Nov 2021 03:40:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1635854268.git.lucien.xin@gmail.com> <cdca8eaca8a0ec5fe4aa58412a6096bb08c3c9bc.1635854268.git.lucien.xin@gmail.com>
 <CAFqZXNtJNnk+iwLnGq6mpdTKuWFmZ4W0PCTj4ira7G2HHPU1tA@mail.gmail.com>
 <CADvbK_cDSKJ+eWeOdvURV_mDXEgEE+B3ZG3ASiKOm501NO9CqQ@mail.gmail.com>
 <CADvbK_ddKB_N=Bj8vtTF_aufmgkqmoQGz+-t7e2nZgoBrDWk8Q@mail.gmail.com>
 <CAHC9VhRQ3wGRTL1UXEnnhATGA_zKASVJJ6y4cbWYoA19CZyLbA@mail.gmail.com>
 <CADvbK_fVENGZhyUXKqpQ7mpva5PYJk2_o=jWKbY1jR_1c-4S-Q@mail.gmail.com> <CAHC9VhSjPVotYVb8-ABescHmnNnDL=9B3M0J=txiDOuyJNoYuw@mail.gmail.com>
In-Reply-To: <CAHC9VhSjPVotYVb8-ABescHmnNnDL=9B3M0J=txiDOuyJNoYuw@mail.gmail.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Thu, 4 Nov 2021 11:40:25 +0100
Message-ID: <CAFqZXNv3eRYTEJprKr0FD7i2DcZ8ZygkVqsAQY4=e484-3cPeA@mail.gmail.com>
Subject: Re: [PATCHv2 net 4/4] security: implement sctp_assoc_established hook
 in selinux
To:     Paul Moore <paul@paul-moore.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        James Morris <jmorris@namei.org>,
        Richard Haines <richard_c_haines@btinternet.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 4, 2021 at 4:17 AM Paul Moore <paul@paul-moore.com> wrote:
> On Wed, Nov 3, 2021 at 9:46 PM Xin Long <lucien.xin@gmail.com> wrote:
> > On Wed, Nov 3, 2021 at 6:01 PM Paul Moore <paul@paul-moore.com> wrote:
> > > On Wed, Nov 3, 2021 at 1:36 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > > On Wed, Nov 3, 2021 at 1:33 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > > > On Wed, Nov 3, 2021 at 12:40 PM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> > > > > > On Tue, Nov 2, 2021 at 1:03 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > > > > >
> > > > > > > Different from selinux_inet_conn_established(), it also gives the
> > > > > > > secid to asoc->peer_secid in selinux_sctp_assoc_established(),
> > > > > > > as one UDP-type socket may have more than one asocs.
> > > > > > >
> > > > > > > Note that peer_secid in asoc will save the peer secid for this
> > > > > > > asoc connection, and peer_sid in sksec will just keep the peer
> > > > > > > secid for the latest connection. So the right use should be do
> > > > > > > peeloff for UDP-type socket if there will be multiple asocs in
> > > > > > > one socket, so that the peeloff socket has the right label for
> > > > > > > its asoc.
> > > > > > >
> > > > > > > v1->v2:
> > > > > > >   - call selinux_inet_conn_established() to reduce some code
> > > > > > >     duplication in selinux_sctp_assoc_established(), as Ondrej
> > > > > > >     suggested.
> > > > > > >   - when doing peeloff, it calls sock_create() where it actually
> > > > > > >     gets secid for socket from socket_sockcreate_sid(). So reuse
> > > > > > >     SECSID_WILD to ensure the peeloff socket keeps using that
> > > > > > >     secid after calling selinux_sctp_sk_clone() for client side.
> > > > > >
> > > > > > Interesting... I find strange that SCTP creates the peeloff socket
> > > > > > using sock_create() rather than allocating it directly via
> > > > > > sock_alloc() like the other callers of sctp_copy_sock() (which calls
> > > > > > security_sctp_sk_clone()) do. Wouldn't it make more sense to avoid the
> > > > > > sock_create() call and just rely on the security_sctp_sk_clone()
> > > > > > semantic to set up the labels? Would anything break if
> > > > > > sctp_do_peeloff() switched to plain sock_alloc()?
> > > > > >
> > > > > > I'd rather we avoid this SECSID_WILD hack to support the weird
> > > > > > created-but-also-cloned socket hybrid and just make the peeloff socket
> > > > > > behave the same as an accept()-ed socket (i.e. no
> > > > > > security_socket_[post_]create() hook calls, just
> > > > > > security_sctp_sk_clone()).
> > >
> > > I believe the important part is that sctp_do_peeloff() eventually
> > > calls security_sctp_sk_clone() via way of sctp_copy_sock().  Assuming
> > > we have security_sctp_sk_clone() working properly I would expect that
> > > the new socket would be setup properly when sctp_do_peeloff() returns
> > > on success.
> > >
> > > ... and yes, that SECSID_WILD approach is *not* something we want to do.
> >
> > SECSID_WILD is used to avoid client's new socket's sid overwritten by
> > old socket's.
>
> In the case of security_sctp_sk_clone() the new client socket (the
> cloned socket) should inherit the label/sid from the original socket
> (the "parent" in the inherit-from-parent label inheritance behavior
> discussed earlier).  The selinux_sctp_assoc_established() function
> should not change the socket's label/sid at all, only the peer label.
>
> > If I understand correctly, new socket's should keep using its original
> > sid, namely,
> > the one set from security_socket_[post_]create() on client side. I
> > AGREE with that.
> > Now I want to *confirm* this with you, as it's different from the last version's
> > 'inherit from parent socket' that Richard and Ondrej reviewed.
>
> Unfortunately I think we are struggling to communicate because you are
> not familiar with SELinux concepts and I'm not as well versed in SCTP
> as you are.  As things currently stand, I am getting a disconnect
> between your explanations and the code you have submitted; they simply
> aren't consistent from my perspective.
>
> In an effort to help provide something that is hopefully a bit more
> clear, here are the selinux_sctp_sk_clone() and
> selinux_sctp_assoc_established() functions which I believe we need.
> If you feel these are incorrect, please explain and/or provide edits:
>
>   static void selinux_sctp_sk_clone(struct sctp_association *asoc,
>                                     struct sock *sk, struct sock *newsk)
>   {
>     struct sk_security_struct *sksec = sk->sk_security;
>     struct sk_security_struct *newsksec = newsk->sk_security;
>
>     /* If policy does not support SECCLASS_SCTP_SOCKET then call
>      * the non-sctp clone version.
>      */
>     if (!selinux_policycap_extsockclass())
>       return selinux_sk_clone_security(sk, newsk);
>
>     newsksec->secid = sksec->secid;
>     newsksec->peer_sid = asoc->peer_secid;
>     newsksec->sclass = sksec->sclass;
>     selinux_netlbl_sctp_sk_clone(sk, newsk);
>   }
>
>   static void selinux_sctp_assoc_established(struct sctp_association *asoc,
>                                              struct sk_buff *skb)
>   {
>     struct sk_security_struct *sksec = asoc->base.sk->sk_security;
>
>     selinux_inet_conn_established(asoc->base.sk, skb);
>     asoc->peer_secid = sksec->peer_sid;
>   }

This code would be functionally equivalent to the v1 patchset for the
client side, but on server side you want to set newsksec->secid to
asoc->secid, as this contains the "connection secid" computed by
selinux_conn_sid() in selinux_sctp_assoc_request(). This is supposed
to mirror what selinux_inet_conn_request() -> selinux_inet_csk_clone()
does for non-SCTP sockets. So I think we should rather go back to the
v1 patchset variant, where the parent socket's sid is stashed in
asoc->secid to be picked up by selinux_sctp_sk_clone().

As for the sctp_do_peeloff-calls-sock_create problem - I was oblivious
about the difference between the sock vs. socket structs, so this
would be a bit more difficult to fix than replacing one function call.
But if we end up just overwriting the label assigned in
selinux_socket_post_create() as it is now, then the only difference is
an unexpected SCTP_SOCKET__CREATE permission check and a pointless
computation of socket_sockcreate_sid(), so it can be addressed
separately. I'll try to suggest a patch and then we can discuss
whether it makes sense or not.

--
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

