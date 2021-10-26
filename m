Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA5743AB74
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 06:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbhJZEuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 00:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbhJZEuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 00:50:22 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148BCC061745;
        Mon, 25 Oct 2021 21:47:59 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id j35-20020a05600c1c2300b0032caeca81b7so392613wms.0;
        Mon, 25 Oct 2021 21:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ogj4eBeAfTKK8WIOyg9YWchm0dOp9i9W9v/NbD+SjQg=;
        b=QW7P8Gy29glpN04+9FL04HkTHc7LcJr7A0CwspjFBMjerDAfpKK0R6YxEXsQhP8C5R
         jZBAsgPFLzY8OaCzJzA6vqP1PNoz19kdSdQe74Q8EoR4CgNdZRlJwjCNZ+LhXZhaHsCp
         xOKg/7WBW0mMUSlz08/L6Rp6FXlXu1QMZGeP+C6gbwZYo+bMPw7ktMueUEgCbLrrjbdv
         1Qre+0wSya0HAuk9u1iKqUXfqSJLkn+HQfngQ8qIKWEP6NvaDtN5vXtxSHibsoHUFxx1
         erzvYWw/5pJeeAvIWK3JJEW+5OTH6EvUjNPzDcP9FYI+f8zbvZyQLplRB2Csn50kUPY8
         c1dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ogj4eBeAfTKK8WIOyg9YWchm0dOp9i9W9v/NbD+SjQg=;
        b=nTVe0hQW4teS9rL8NOWOvH3Ci/BijxXwuDZIybaEWIKbibdBj+I3bpafW/lvy4BO3H
         jFYuWxNQ3h47Et5fLjZhyxlf86pWMC09hpH7kxGggjeb485PhXwj4R03518jubULGz95
         rUP7YiTPEnIxzMifcgNMggZqVWGuU171OdTGzNR+9KD5tm2ioRoSeUuiSGc7qM6+za1h
         ov6UtJ1dTeyXCL2ruCskK6ScRkTyhuXRkqy5AV2+8GI9UTdpmlRcNAws/MfyinibIOU2
         Oq3nn4i6evN/+DUmH+KOWeTRk1dHHRpFpXWNYaMcdWZisjgN6s94eCOlXgREfO20Q2fu
         VZVQ==
X-Gm-Message-State: AOAM532Q20XVNSytVnLChqBNKPaiDfRgRNqm19GI9kZ5oNfegTWcBij0
        EuZntYfgHJpv2yzEpEWLYkWIADQ/QNaeVGkyw14=
X-Google-Smtp-Source: ABdhPJzFh0xsUUTR7xru4f1MDrUuQqtdz1qjNfW4XgRTMTyeZhv5Bxtk6q/1HP9uVLsdba7na40COkSn9Y4LDepV51Q=
X-Received: by 2002:a1c:7dcb:: with SMTP id y194mr25593547wmc.8.1635223677613;
 Mon, 25 Oct 2021 21:47:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1634884487.git.lucien.xin@gmail.com> <53026dedd66beeaf18a4570437c4e6c9e760bb90.1634884487.git.lucien.xin@gmail.com>
 <CAFqZXNs89yGcoXumNwavLRQpYutfnLY-SM2qrHbvpjJxVtiniw@mail.gmail.com>
 <CADvbK_djVKxjfRaLS0EZRY2mkzWXTMnwvbe-b7cK-T3BR8jzKQ@mail.gmail.com>
 <CAFqZXNsnEwPcEXB-4O983bxGj5BfZVMB6sor7nZVkT-=uiZ2mw@mail.gmail.com>
 <CADvbK_eE9VhB2cWzHSk_LNm_VemEt9vm=FMMVYzo5eVH=zEhKw@mail.gmail.com> <CAHC9VhTfVmcLOG3NfgQ3Tjpe769XzPntG24fejzSCvnZt_XZ9A@mail.gmail.com>
In-Reply-To: <CAHC9VhTfVmcLOG3NfgQ3Tjpe769XzPntG24fejzSCvnZt_XZ9A@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 26 Oct 2021 12:47:46 +0800
Message-ID: <CADvbK_dwLCOvS8YzFXcXoDF6F69_sc7voPbxn5Ov4ygBR_5FXw@mail.gmail.com>
Subject: Re: [PATCH net 4/4] security: implement sctp_assoc_established hook
 in selinux
To:     Paul Moore <paul@paul-moore.com>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        James Morris <jmorris@namei.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        SElinux list <selinux@vger.kernel.org>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 5:51 AM Paul Moore <paul@paul-moore.com> wrote:
>
> On Mon, Oct 25, 2021 at 10:11 AM Xin Long <lucien.xin@gmail.com> wrote:
> > On Mon, Oct 25, 2021 at 8:08 PM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> >> On Mon, Oct 25, 2021 at 12:51 PM Xin Long <lucien.xin@gmail.com> wrote:
> >> > On Mon, Oct 25, 2021 at 4:17 PM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> >> > > On Fri, Oct 22, 2021 at 8:36 AM Xin Long <lucien.xin@gmail.com> wrote:
> >> > > > Different from selinux_inet_conn_established(), it also gives the
> >> > > > secid to asoc->peer_secid in selinux_sctp_assoc_established(),
> >> > > > as one UDP-type socket may have more than one asocs.
> >> > > >
> >> > > > Note that peer_secid in asoc will save the peer secid for this
> >> > > > asoc connection, and peer_sid in sksec will just keep the peer
> >> > > > secid for the latest connection. So the right use should be do
> >> > > > peeloff for UDP-type socket if there will be multiple asocs in
> >> > > > one socket, so that the peeloff socket has the right label for
> >> > > > its asoc.
> >> > >
> >> > > Hm... this sounds like something we should also try to fix (if
> >> > > possible). In access control we can't trust userspace to do the right
> >> > > thing - receiving from multiple peers on one SOCK_SEQPACKET socket
> >> > > shouldn't cause checking against the wrong peer_sid. But that can be
> >> > > addressed separately. (And maybe it's even already accounted for
> >> > > somehow - I didn't yet look at the code closely.)
>
> There are a couple of things we need to worry about here: the
> per-packet access controls (e.g. can this packet be received by this
> socket?) and the userspace peer label queries (e.g. SO_GETPEERSEC and
> IP_CMSG_PASSSEC).
>
> The per-packet access controls work by checking the individual
> packet's security label against the corresponding sock label on the
> system (sk->sk_security->sid).  Because of this it is important that
> the sock's label is correct.  For unconnected sockets this is fairly
> straightforward as it follows the usual inherit-from-parent[1]
> behavior we see in other areas of SELinux.  For connected stream
> sockets this can be a bit more complicated.  However, since we are
> only discussing the client side things aren't too bad with the
> behavior essentially the same, inherit-from-parent, with the only
> interesting piece worth noting being the sksec->peer_sid
> (sk->sk_security->peer_sid) that we record from the packet passed to
> the LSM/SELinux hook (using selinux_skb_peerlbl_sid()).  The
> sksec->peer_sid is recorded primarily so that the kernel can correctly
> respond to SO_GETPEERSEC requests from userspace; it shouldn't be used
> in any access control decisions.
Hi, Paul

Understand now, the issue reported seems caused by when
doing peel-off the peel-off socket gets the uninitialised sid
from 'ep' on the client, though it should be "asoc".

Thanks!

>
> In the case of SCTP, I would expect things to behave similarly: the
> sksec->peer_sid should match the packet label of the traffic which
> acknowledged/accepted the new connection, e.g. the other end of the
> connected socket.  You will have to forgive me some of the details,
> it's been a while since I last looked at the SCTP bits, but I would
> expect that if a client created a new connection and/or spun-off a new
> socket the new socket's sksec->peer_sid would have the same property,
> it would represent the security label of the other end of the
> connection/association.
In SCTP, a socket doesn't represent a peer connection, it's more an
object binding some addresses and receiving incoming connecting
request, then creates 'asoc' to represent the connection, so asoc->
peer_secid represents the security label of the other end of the
connection/association.

After doing peel-off, it makes one asoc 'bind' to one new socket,
and this socket is used for userspace to control this asoc (conection),
so naturally we set sksec->peer_sid to asoc->secid for access control
in socket. As for the 'parent' sk/ep, we can't use it to record
peer_scid, as when there are multiple connections, the later one
will overwrite the older one.

>
> [1] Yes, there is setsockcreatecon(), but that isn't important for
> this discussion.
>
> >> > > > Fixes: 72e89f50084c ("security: Add support for SCTP security hooks")
> >> > > > Reported-by: Prashanth Prahlad <pprahlad@redhat.com>
> >> > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> >> > > > ---
> >> > > >  security/selinux/hooks.c | 16 ++++++++++++++++
> >> > > >  1 file changed, 16 insertions(+)
> >> > > >
> >> > > > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> >> > > > index f025fc00421b..793fdcbc68bd 100644
> >> > > > --- a/security/selinux/hooks.c
> >> > > > +++ b/security/selinux/hooks.c
> >> > > > @@ -5525,6 +5525,21 @@ static void selinux_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk
> >> > > >         selinux_netlbl_sctp_sk_clone(sk, newsk);
> >> > > >  }
> >> > > >
> >> > > > +static void selinux_sctp_assoc_established(struct sctp_association *asoc,
> >> > > > +                                          struct sk_buff *skb)
> >> > > > +{
> >> > > > +       struct sk_security_struct *sksec = asoc->base.sk->sk_security;
> >> > > > +       u16 family = asoc->base.sk->sk_family;
> >> > > > +
> >> > > > +       /* handle mapped IPv4 packets arriving via IPv6 sockets */
> >> > > > +       if (family == PF_INET6 && skb->protocol == htons(ETH_P_IP))
> >> > > > +               family = PF_INET;
> >> > > > +
> >> > > > +       selinux_skb_peerlbl_sid(skb, family, &sksec->peer_sid);
> >> > >
> >> > > You could replace the above with
> >> > > `selinux_inet_conn_established(asoc->base.sk, skb);` to reduce code
> >> > > duplication.
> >> > Hi Ondrej,
> >> >
> >> > will do, thanks!
> >> >
> >> > >
> >> > > > +       asoc->secid = sksec->sid;
> >> > > > +       asoc->peer_secid = sksec->peer_sid;
> >> > > > +}
> >> > > > +
> >> > Now I'm thinking: 'peer_sid' should be correct here.
> >> >
> >> > BUT 'sid' is copied from its parent socket. Later when doing peel-off,
> >> > asoc->secid will be set back to the peel-off socket's sksec->sid.
> >>
> >> Hi,
> >>
> >> I'm not sure I follow... When doing peel-off, security_sctp_sk_clone()
> >> should be called, which sets the peel-off socket's sksec->sid to
> >> asoc->secid, not the other way around. (Are we hitting the language
> >> barrier here? :)
> >
> > Right, sorry.
> >
> > Set the peel-off socket's sksec->sid to asoc->secid, I meant :D
>
> For the sake of clarity, let's scribble down some pseudo code to
> discuss :)  Taking into account the feedback above, I arrived at the
> code below (corrections are welcome if I misunderstood what you wanted
> to convey) with my comments after:
>
>   static void selinux_sctp_assoc_established(asoc, skb)
>   {
>     struct sock *sk = asoc->base.sk;
>     struct sk_security_struct *sksec = sk->sk_security;
>
>     selinux_inet_conn_established(sk, skb);
>     asoc->secid = sksec->peer_sid;
>     asoc->peer_secid = sksec->peer_sid;
>   }
>
> My only concern with the above code is the 'asoc->secid =
> sksec->peer_sid' assignment.  As this particular association is a
> client side association I would expect it to follow the normal
> inherit-from-parent behavior as described above and not take the label
> of remote peer, however I could be misunderstanding some of the SCTP
selinux_sctp_assoc_established() is the first place to set
sksec->peer_sid for this connection on client, so sksec->peer_sid
is the 'parent' socket's peer_sid to this asoc.

> specifics here.  My initial reaction is that we need to adjust the
> LSM/SELinux hook as well as the call site in sctp_sf_do_5_1D_ce() to
> pass both 'new_asoc' as well 'asoc' and set 'new_asoc->secid' to
> 'asoc->secid' to better mirror the existing stream/TCP behavior on the
> client side.
Sorry, there's something about SCTP that I should've made clear:

sctp_sf_do_5_1D_ce() is normally called when no existing asoc
(in most cases) or the existing asoc's state is CLOSE.

#define TYPE_SCTP_COOKIE_ECHO { \
        /* SCTP_STATE_CLOSED */ \ <---- (also include asoc is NULL)
        TYPE_SCTP_FUNC(sctp_sf_do_5_1D_ce), \

and for the existing asoc case, SCTP doesn't use anything from it
for the new asoc, but just ignores it. IF these are conflicts when
inserting transports for the new asoc with the existing asoc,
sctp_process_init() will handle it and return errors.

Just note that the existing asoc is NOT the one created when
processing INIT chunk, and that INIT one is a temporary asoc
and is deleted right after finishing processing INIT.

But if you mean the hooks in sctp_sf_do_5_2_4_dupcook()
where it's processing a duplicate COOKIE_ECHO and copying
things from the existing asoc, maybe it should do such things,
we can make another thread for this corner case.

>
> Does that make sense?  If not, what am I missing :)
>
> --
> paul moore
> www.paul-moore.com
