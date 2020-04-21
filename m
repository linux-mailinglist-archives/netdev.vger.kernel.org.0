Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A1B1B1BE2
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 04:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgDUC35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 22:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725829AbgDUC34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 22:29:56 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC92C061A0E;
        Mon, 20 Apr 2020 19:29:56 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id l5so6578621ybf.5;
        Mon, 20 Apr 2020 19:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ciqMYOZ6XZlVSQyI6y4r8cJk5afnaKUbe9fyNVTLy4E=;
        b=nskicTJK540KM6kUpMBHGIY79Scrkytk33f3ctgvzoNRv0IVgrN9FbpxZo338pKKKA
         dxIuxHw7RBGUbRoiqGjAjYWA18x2D3jDIuVIzE+z4oVzr6HVh1Am00169EbpDgEwdPYd
         pRzdCpwBS8wO49lvtS4xA+/NezVfob8lBCrdnQzr6TM4nJKx1PKViH5vUgZR2wLcm+hH
         BJlfJUVNWBYU6IhQbe9wx4izmJQOYRmg4JoaiOHXWH5XrPh7b+/nPthf7pIqlbk61q+9
         gMs0c04/nw8Vb8XgXULeNori93Te19o399FtO32zVOcz+yqBDY26SSCEiKh4OhEigwiT
         VvVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ciqMYOZ6XZlVSQyI6y4r8cJk5afnaKUbe9fyNVTLy4E=;
        b=HMZDbBviJ4fNy9dQJNImZTq4dxP4M8EOoLqjMjH+KkMfEc0BTOd//LvPbwgxPI54Os
         oLf5ewQj/XquiGicFYm7063jXJStXipUqqyWRIBDAsurA1+V8kGq+xVMpmO3R6ns9o+w
         JtD3WWXQ6dnay4dHCuD4Y2w0FmTmG2fgqPLIbfa4BUbeoZdD7vzVqt/2MEIYx37mvmsy
         WIG4Zudu7wPGwVG5ahsecqNrEdDQB1D9cjtCL0QCXxT1kUvXJYnliyXReLug5r+wKGeZ
         amaVag6hSQUrB4pZ5Xk3pYibILu1IEeeNnGLJcp+Skoa/cDW90AY4rqUhrKKrH6CQjV9
         xMHw==
X-Gm-Message-State: AGi0PuYTXeqnHIpLftKFAotGf1IYXLNr5gi5mIDpnv3WjxEHXFSIkYb6
        EPKy8RVYAEt1FD1NSfHBB76JZLK7P0Oh5Y8+u9w=
X-Google-Smtp-Source: APiQypJEyN++b8Zrn/RN2+wWJ9QpMpPqYddQf+U0oij1N2zwZqnREbkZdKwu5PYzQWVoGBjggaLlEfcGSBG6yNXVHdk=
X-Received: by 2002:a25:9cc2:: with SMTP id z2mr22838180ybo.375.1587436195667;
 Mon, 20 Apr 2020 19:29:55 -0700 (PDT)
MIME-Version: 1.0
References: <878siq587w.fsf@cjr.nz> <87imhvj7m6.fsf@cjr.nz>
 <CAH2r5mv5p=WJQu2SbTn53FeTsXyN6ke_CgEjVARQ3fX8QAtK_w@mail.gmail.com>
 <3865908.1586874010@warthog.procyon.org.uk> <927453.1587285472@warthog.procyon.org.uk>
 <1136024.1587388420@warthog.procyon.org.uk> <1986040.1587420879@warthog.procyon.org.uk>
 <93e1141d15e44a7490d756b0a00060660306fadc.camel@redhat.com>
In-Reply-To: <93e1141d15e44a7490d756b0a00060660306fadc.camel@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 20 Apr 2020 21:29:44 -0500
Message-ID: <CAH2r5msv0r1-bXJKdN-ansMnpay0+Aw9FP5us5zHrhp3adzV=Q@mail.gmail.com>
Subject: Re: cifs - Race between IP address change and sget()?
To:     Jeff Layton <jlayton@redhat.com>
Cc:     David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@cjr.nz>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org, keyrings@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Weimer <fweimer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 5:30 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Mon, 2020-04-20 at 23:14 +0100, David Howells wrote:
> > Paulo Alcantara <pc@cjr.nz> wrote:
> >
> > > > > > What happens if the IP address the superblock is going to changes, then
> > > > > > another mount is made back to the original IP address?  Does the second
> > > > > > mount just pick the original superblock?
> > > > >
> > > > > It is going to transparently reconnect to the new ip address, SMB share,
> > > > > and cifs superblock is kept unchanged.  We, however, update internal
> > > > > TCP_Server_Info structure to reflect new destination ip address.
> > > > >
> > > > > For the second mount, since the hostname (extracted out of the UNC path
> > > > > at mount time) resolves to a new ip address and that address was saved
> > > > > earlier in TCP_Server_Info structure during reconnect, we will end up
> > > > > reusing same cifs superblock as per fs/cifs/connect.c:cifs_match_super().
> > > >
> > > > Would that be a bug?
> > >
> > > Probably.
> > >
> > > I'm not sure how that code is supposed to work, TBH.
> >
> > Hmmm...  I think there may be a race here then - but I'm not sure it can be
> > avoided or if it matters.
> >
> > Since the address is part of the primary key to sget() for cifs, changing the
> > IP address will change the primary key.  Jeff tells me that this is governed
> > by a spinlock taken by cifs_match_super().  However, sget() may be busy
> > attaching a new mount to the old superblock under the sb_lock core vfs lock,
> > having already found a match.
> >
>
> Not exactly. Both places that match TCP_Server_Info objects by address
> hold the cifs_tcp_ses_lock. The address looks like it gets changed in
> reconn_set_ipaddr, and the lock is not currently taken there, AFAICT. I
> think it probably should be (at least around the cifs_convert_address
> call).
>
> > Should the change of parameters made by cifs be effected with sb_lock held to
> > try and avoid ending up using the wrong superblock?
> >
> > However, because the TCP_Server_Info is apparently updated, it looks like my
> > original concern is not actually a problem (the idea that if a mounted server
> > changes its IP address and then a new server comes online at the old IP
> > address, it might end up sharing superblocks because the IP address is part of
> > the key).
> >
>
> I'm not sure we should concern ourselves with much more than just not
> allowing addresses to change while matching/searching. If you're
> standing up new servers at old addresses while you still have clients
> are migrating, then you are probably Doing it Wrong.

Yes.   The most important thing is to support the reasonably
common scenario where the server's IP address changes (there are
fancier ways to handle this gracefully e.g. the "Witness Protocol" feature
of SMB3 mounts, but that is not always supported by servers and we
still need to add Witness protocol to clients - but current code allowing
SMB3 server IP address to change has helped some customers out)

-- 
Thanks,

Steve
