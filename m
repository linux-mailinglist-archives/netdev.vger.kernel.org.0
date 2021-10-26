Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7008F43BB90
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 22:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239188AbhJZUcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 16:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbhJZUcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 16:32:51 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB59C061570
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 13:30:27 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id s1so1455282edd.3
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 13:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QxDBfmjXP4YqwxsO+6iS7FY8iQGJLFVCJVXK+8EOsBg=;
        b=RKFwvRvwD0sHEgLp5/JP2Pn/bmgSvqpkFt0UOxL7CSXOeehWPX/6PBaZ5st+hyD8CQ
         YuJX4wga4jqjTh0ckLFk1zznRzP3zcIk55trAAWCIHVo5vrzNnXjsubCvSNd1scpo3jJ
         klim90/2yWHehcKvdCTKyVNSbxyc2DzCmDWE8aPlX0YTZXO/vHDWHblkU/0gkKJgiRqf
         lZ/Jip+7SB+ny/F4NL57MfbAl+lZvKtKnb66J5bpR+me02K2gS9G0/+J49YxAS0Ftmsj
         CLlkxwKPV/PA5Qn2JIkrGvLI6WUYhIHWlLLzTSvUmcoawnSBy2mOpKIlNAaboGSHdrk+
         YFxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QxDBfmjXP4YqwxsO+6iS7FY8iQGJLFVCJVXK+8EOsBg=;
        b=1Lcj+sWCLmUj/hcS9jvSmMRPwp/pN8nZA5FTBf/6Z3r62LchA6y0Ec+4ou+ckmGCIE
         fyviYI4jQWLWRG9FSSAcwB3k3dDo899Ln/7p/qaUBZQ/omGsn8P+A1iMVTmj3XPOGG7O
         Kj+gd/tiK/6XeVtzrNTfaiPvw82WuCC8sWgegrkVqRm0nGOWccEzHFKBHhObY6lXl03r
         a5qpWKEBPpIAp45aCKkhQpjmYh6RR7g4Gq5Z/VkuKJVah7FAbQnjzt/n5oDKgKEvOnuM
         29gW4l/evdQKxUyJ2hRtVQazk04E6umRBvW9QWlLTEFoCzbBprzxDlzMlEAxMKF45/6H
         xR6A==
X-Gm-Message-State: AOAM532BKIxUnUfaANc3TOngwiGjFlDmnF/BYh01Uzdu7b1PQRIV3YeS
        94psswFbuCl5E+6TuKr4XzVucdfRMd+Mkmq/Fv+m
X-Google-Smtp-Source: ABdhPJyprHJsbis7NLS+TOyUm7gG4e8ssfPeoqPQw6DPFNzjiQmJ8qsFB3iOWeedSscDOBDWRoDKcJtiBcZ6xI93uR0=
X-Received: by 2002:a05:6402:5112:: with SMTP id m18mr38150360edd.101.1635280225664;
 Tue, 26 Oct 2021 13:30:25 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1634884487.git.lucien.xin@gmail.com> <53026dedd66beeaf18a4570437c4e6c9e760bb90.1634884487.git.lucien.xin@gmail.com>
 <CAFqZXNs89yGcoXumNwavLRQpYutfnLY-SM2qrHbvpjJxVtiniw@mail.gmail.com>
 <CADvbK_djVKxjfRaLS0EZRY2mkzWXTMnwvbe-b7cK-T3BR8jzKQ@mail.gmail.com>
 <CAFqZXNsnEwPcEXB-4O983bxGj5BfZVMB6sor7nZVkT-=uiZ2mw@mail.gmail.com>
 <CADvbK_eE9VhB2cWzHSk_LNm_VemEt9vm=FMMVYzo5eVH=zEhKw@mail.gmail.com>
 <CAHC9VhTfVmcLOG3NfgQ3Tjpe769XzPntG24fejzSCvnZt_XZ9A@mail.gmail.com> <CADvbK_dwLCOvS8YzFXcXoDF6F69_sc7voPbxn5Ov4ygBR_5FXw@mail.gmail.com>
In-Reply-To: <CADvbK_dwLCOvS8YzFXcXoDF6F69_sc7voPbxn5Ov4ygBR_5FXw@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 26 Oct 2021 16:30:14 -0400
Message-ID: <CAHC9VhREfztHQ8mqA_WM6NF=jKf0fTFTSRp_D5XhOVxckckwzw@mail.gmail.com>
Subject: Re: [PATCH net 4/4] security: implement sctp_assoc_established hook
 in selinux
To:     Xin Long <lucien.xin@gmail.com>
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

On Tue, Oct 26, 2021 at 12:47 AM Xin Long <lucien.xin@gmail.com> wrote:
> On Tue, Oct 26, 2021 at 5:51 AM Paul Moore <paul@paul-moore.com> wrote:
> > On Mon, Oct 25, 2021 at 10:11 AM Xin Long <lucien.xin@gmail.com> wrote:
> > > On Mon, Oct 25, 2021 at 8:08 PM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> > >> On Mon, Oct 25, 2021 at 12:51 PM Xin Long <lucien.xin@gmail.com> wrote:
> > >> > On Mon, Oct 25, 2021 at 4:17 PM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> > >> > > On Fri, Oct 22, 2021 at 8:36 AM Xin Long <lucien.xin@gmail.com> wrote:
> > >> > > > Different from selinux_inet_conn_established(), it also gives the
> > >> > > > secid to asoc->peer_secid in selinux_sctp_assoc_established(),
> > >> > > > as one UDP-type socket may have more than one asocs.
> > >> > > >
> > >> > > > Note that peer_secid in asoc will save the peer secid for this
> > >> > > > asoc connection, and peer_sid in sksec will just keep the peer
> > >> > > > secid for the latest connection. So the right use should be do
> > >> > > > peeloff for UDP-type socket if there will be multiple asocs in
> > >> > > > one socket, so that the peeloff socket has the right label for
> > >> > > > its asoc.
> > >> > >
> > >> > > Hm... this sounds like something we should also try to fix (if
> > >> > > possible). In access control we can't trust userspace to do the right
> > >> > > thing - receiving from multiple peers on one SOCK_SEQPACKET socket
> > >> > > shouldn't cause checking against the wrong peer_sid. But that can be
> > >> > > addressed separately. (And maybe it's even already accounted for
> > >> > > somehow - I didn't yet look at the code closely.)
> >
> > There are a couple of things we need to worry about here: the
> > per-packet access controls (e.g. can this packet be received by this
> > socket?) and the userspace peer label queries (e.g. SO_GETPEERSEC and
> > IP_CMSG_PASSSEC).
> >
> > The per-packet access controls work by checking the individual
> > packet's security label against the corresponding sock label on the
> > system (sk->sk_security->sid).  Because of this it is important that
> > the sock's label is correct.  For unconnected sockets this is fairly
> > straightforward as it follows the usual inherit-from-parent[1]
> > behavior we see in other areas of SELinux.  For connected stream
> > sockets this can be a bit more complicated.  However, since we are
> > only discussing the client side things aren't too bad with the
> > behavior essentially the same, inherit-from-parent, with the only
> > interesting piece worth noting being the sksec->peer_sid
> > (sk->sk_security->peer_sid) that we record from the packet passed to
> > the LSM/SELinux hook (using selinux_skb_peerlbl_sid()).  The
> > sksec->peer_sid is recorded primarily so that the kernel can correctly
> > respond to SO_GETPEERSEC requests from userspace; it shouldn't be used
> > in any access control decisions.
>
> Hi, Paul
>
> Understand now, the issue reported seems caused by when
> doing peel-off the peel-off socket gets the uninitialised sid
> from 'ep' on the client, though it should be "asoc".

Hi Xin Long,

Yes, that is my understanding.  I got the impression from the thread
that there was some confusion about the different labels and what they
were used for in SELinux, I was trying to provide some background in
the text above.  If you are already familiar with how things should
work you can disregard it :)

> > In the case of SCTP, I would expect things to behave similarly: the
> > sksec->peer_sid should match the packet label of the traffic which
> > acknowledged/accepted the new connection, e.g. the other end of the
> > connected socket.  You will have to forgive me some of the details,
> > it's been a while since I last looked at the SCTP bits, but I would
> > expect that if a client created a new connection and/or spun-off a new
> > socket the new socket's sksec->peer_sid would have the same property,
> > it would represent the security label of the other end of the
> > connection/association.
>
> In SCTP, a socket doesn't represent a peer connection, it's more an
> object binding some addresses and receiving incoming connecting
> request, then creates 'asoc' to represent the connection, so asoc->
> peer_secid represents the security label of the other end of the
> connection/association.

As mentioned previously the asoc->peer_secid *should* be the security
label of the remote end, so I think we are okay here.  My concern
remains the asoc->secid label as I don't believe it is being set to
the correct value (more on that below).

> After doing peel-off, it makes one asoc 'bind' to one new socket,
> and this socket is used for userspace to control this asoc (conection),
> so naturally we set sksec->peer_sid to asoc->secid for access control
> in socket.

The sksec->peer_sid represents the security label of the remote end so
it should be set to the asoc->peer_secid and *not* the asoc->secid
value.  Yes, they are presently the same value in your patches, but I
believe that is a mistake; I believe the asoc->secid value should be
set to that of the parent (see the prior inherit-from-parent
discussion) which in this case would likely be either the parent
association or the client process, I'm not entirely clear on which is
correct in the SCTP case.  The initial SCTP client association would
need to take it's label from the parent process so perhaps that is the
right answer for all SCTP client associations[2].

[1] I would expect server side associations to follow the more
complicated selinux_conn_sid() labeling, just as we do for TCP/stream
connections today.

[2] I'm guessing the client associations might also want to follow the
setsockcreatecon(3) behavior, see selinux_sockcreate_sid() for more
info.

-- 
paul moore
www.paul-moore.com
