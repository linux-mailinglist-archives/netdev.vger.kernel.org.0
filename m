Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14107C8910
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 14:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfJBMzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 08:55:16 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38028 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfJBMzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 08:55:16 -0400
Received: by mail-qt1-f196.google.com with SMTP id j31so26167068qta.5;
        Wed, 02 Oct 2019 05:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xr6PKO42DHw7TYqPNZ2dvCZRTSafDsIRJWxUomGoTGU=;
        b=S2zgY4dOLTdqsmX7zGgEHMvN814hW3hF0iRoqKgcizMMBj8N8EmCShGvO4+43kc5Ro
         6Mlmr6SL9g2e6Wrnl5JFVFw+AEqm9wClYEHxAWsAXZGbANFYoKJp0MZeCjfgUrsvZ2RD
         d5eWxttZYNKdHELjUp9DXOtej88OfCszVtk6v3b2U6yJ+MidlNGgntebSAnUGC/f6jqv
         0klxsh/dJ9SFsLvxzUEIC2TC1q2oLqdRqoQhUtyvS8VqpCDL+IHIMTG2GcHxknnnapM/
         BFIn4JRKccDRc+53XGHFl3sCZ+Tu7CJtXZV7pvhgjCfx7gyeH2647pzVZEVc3dnU2/W/
         YimQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xr6PKO42DHw7TYqPNZ2dvCZRTSafDsIRJWxUomGoTGU=;
        b=d3L/uua8E59bklA8L3pKQsT1yGRW88nZwSa8kfXoBbKywrWcje0jj8jXfZ1krEX3KL
         wE9NjKpkpY6gh6w44mcz8n7RnviE7Q128TstXyqFcIuc0KjrOj2tdnD4Ie8J9q8ETAub
         IavUi3nhAFTIls6+ueua8rtON05X+lVO+bXekHkBh9ifAKdlLMufxgFYPuXCFe6dRJVY
         BsLmZ+hHuvYM8KB8SnhfJdfhJgll/CqNo0nYqQ9dulwvrHhC3nac384p9TA/mAyEkOxA
         njULIYK7kGBkDQioeCCzB5cpq1By5CSTFkeMqhZY7EL8mvc6U2cCeKB/N88GECcErp9z
         DrUg==
X-Gm-Message-State: APjAAAWhv+0Ato5SfDZD7yP+1MDPAXsVRWdcRkfFNS+/G0Lz5jxRY0DT
        30fjexFJsfFbnq2QZS+LWkM=
X-Google-Smtp-Source: APXvYqy+4hZtousV2+BnbHRNFuD+Pi+5XbaYbhbkY4dPCuiIsgUhBuLU+BnpdGh5FOAtCCGl0H8YOQ==
X-Received: by 2002:a0c:cd89:: with SMTP id v9mr2800073qvm.205.1570020914847;
        Wed, 02 Oct 2019 05:55:14 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:43d:1f86:9ada:9b75:29f5])
        by smtp.gmail.com with ESMTPSA id c20sm7980818qkm.11.2019.10.02.05.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 05:55:14 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 8C77DC085B; Wed,  2 Oct 2019 09:55:11 -0300 (-03)
Date:   Wed, 2 Oct 2019 09:55:11 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net] sctp: set newsk sk_socket before processing
 listening sk backlog
Message-ID: <20191002125511.GH3499@localhost.localdomain>
References: <acd60f4797143dc6e9817b3dce38e1408caf65e5.1569849018.git.lucien.xin@gmail.com>
 <20191002010356.GG3499@localhost.localdomain>
 <CADvbK_ctLG+vnhmWwN=cWmZV7FgZreVRmoU+23PExdk=goF8cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_ctLG+vnhmWwN=cWmZV7FgZreVRmoU+23PExdk=goF8cQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 04:23:52PM +0800, Xin Long wrote:
> On Wed, Oct 2, 2019 at 9:04 AM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Mon, Sep 30, 2019 at 09:10:18PM +0800, Xin Long wrote:
> > > This patch is to fix a NULL-ptr deref crash in selinux_sctp_bind_connect:
> > >
> > >   [...] kasan: GPF could be caused by NULL-ptr deref or user memory access
> > >   [...] RIP: 0010:selinux_sctp_bind_connect+0x16a/0x230
> > >   [...] Call Trace:
> > >   [...]  security_sctp_bind_connect+0x58/0x90
> > >   [...]  sctp_process_asconf+0xa52/0xfd0 [sctp]
> > >   [...]  sctp_sf_do_asconf+0x782/0x980 [sctp]
> > >   [...]  sctp_do_sm+0x139/0x520 [sctp]
> > >   [...]  sctp_assoc_bh_rcv+0x284/0x5c0 [sctp]
> > >   [...]  sctp_backlog_rcv+0x45f/0x880 [sctp]
> > >   [...]  __release_sock+0x120/0x370
> > >   [...]  release_sock+0x4f/0x180
> > >   [...]  sctp_accept+0x3f9/0x5a0 [sctp]
> > >   [...]  inet_accept+0xe7/0x6f0
> > >
> > > It was caused by that the 'newsk' sk_socket was not set before going to
> > > security sctp hook when doing accept() on a tcp-type socket:
> > >
> > >   inet_accept()->
> > >     sctp_accept():
> > >       lock_sock():
> > >           lock listening 'sk'
> > >                                           do_softirq():
> > >                                             sctp_rcv():  <-- [1]
> > >                                                 asconf chunk arrived and
> > >                                                 enqueued in 'sk' backlog
> > >       sctp_sock_migrate():
> > >           set asoc's sk to 'newsk'
> > >       release_sock():
> > >           sctp_backlog_rcv():
> > >             lock 'newsk'
> > >             sctp_process_asconf()  <-- [2]
> > >             unlock 'newsk'
> > >     sock_graft():
> > >         set sk_socket  <-- [3]
> > >
> > > As it shows, at [1] the asconf chunk would be put into the listening 'sk'
> > > backlog, as accept() was holding its sock lock. Then at [2] asconf would
> > > get processed with 'newsk' as asoc's sk had been set to 'newsk'. However,
> > > 'newsk' sk_socket is not set until [3], while selinux_sctp_bind_connect()
> > > would deref it, then kernel crashed.
> >
> > Note that sctp will migrate such incoming chunks from sk to newsk in
> > sctp_rcv() if they arrived after the mass-migration performed at
> > sctp_sock_migrate().
> >
> > That said, did you explore changing inet_accept() so that
> > sk1->sk_prot->accept() would return sk2 still/already locked?
> > That would be enough to block [2] from happening as then it would be
> > queued on newsk backlog this time and avoid nearly duplicating
> > inet_accept(). (too bad for this chunk, hit 2 backlogs..)
> We don't have to bother inet_accept() for it. I had this one below,
> and I was just thinking the locks order doesn't look nice. Do you
> think this is more acceptable?
> 
> @@ -4963,15 +4963,19 @@ static struct sock *sctp_accept(struct sock
> *sk, int flags, int *err, bool kern)
>          * asoc to the newsk.
>          */
>         error = sctp_sock_migrate(sk, newsk, asoc, SCTP_SOCKET_TCP);
> -       if (error) {
> -               sk_common_release(newsk);
> -               newsk = NULL;
> +       if (!error) {
> +               lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
> +               release_sock(sk);

Interesting. It fixes the backlog processing, ok. Question:

> +               release_sock(newsk);

As newsk is hashed already and unlocked here to be locked again later
on inet_accept(), it could receive a packet in between (thus before
sock_graft() could have a chance to run), no?

> +               *err = error;
> +
> +               return newsk;
>         }
> 
>  out:
>         release_sock(sk);
>         *err = error;
> -       return newsk;
> +       return NULL;
>  }
> 
> >
> > AFAICT TCP code would be fine with such change. Didn't check other
> > protocols.
> >
> 
