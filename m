Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D973A17FCE
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 20:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbfEHS1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 14:27:42 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46615 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728456AbfEHS1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 14:27:41 -0400
Received: by mail-qk1-f196.google.com with SMTP id a132so12934390qkb.13;
        Wed, 08 May 2019 11:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=8jGJorXThkEyc36o8Lb0HjptDmlvFY01AR+K0+3EJZ0=;
        b=hvNCGwrBzdl6wzIOwf3lZLLjBDEjdsqIVZCpcZnFBaZtuCLwz2554i+dLt+2kn5n9e
         CDNGQQraVypPiq+YaBKU1w4xHnE+sOqq/yxkHIjWzIdEdLuSNyETkPgRzMoZOuHZ3izd
         2ClW9EJF7yr+fEGWv3K8iH2OA2JluzWWXjt27uZWtQE0qLvXd3JJ7/3T2KUgP3NijYu1
         AQLCosDpc3AeO15hh5TLJ+OnyBhfyb0BKP4nOjLcEKdPi3I1ixNOBMgOFC6ZUgu5q0GT
         c1AKMdefmKlom3VQOjkiHYrBK7iXPGBs0BIS6Atav8y4In9ubQBgbLcWMOBSKuXvCbb4
         CPAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=8jGJorXThkEyc36o8Lb0HjptDmlvFY01AR+K0+3EJZ0=;
        b=Y5BTbuKKh1YUCFEkaZuoPxt6Kx/o9AtyctGoPpNh0ykNLUKDhi6fruoFIiR8Kv8lmN
         RmhRkInWHqzJrgAFqt5asKzii3QolRYZJnYXfUz3dzgLa0eLXTt2BtsTUv9IqWMT2kXE
         +F8OGxUzvslZYhXi6uwUjPUI8AzlW+U7DQbZeuSKLBQCygGIkxG04t4fDLxlF9GxmwRB
         Lgx2Fa1dzzTQe8rkZZl37osqCNQ3E8KUQjHt8Y89dnPIwSeMaIFLCUvROvL69MZEbqBN
         lI+FVxfy2/VUlbMVlhNPwf9G8mZqv59RWCwoaLYR6vMVfOsucSaWGl4AhfIivmXQslCP
         DzUg==
X-Gm-Message-State: APjAAAVy756+lvtz3iBuOTAuI2KcOACGgPO41YPT9sRV/QlyehPzRWSb
        Nh5VsFw+ZgdUrSAQtVgjHcU=
X-Google-Smtp-Source: APXvYqzRAX1ObJ6tjB0bM5gAg3FFLWWgIWgQ6iHmKAvW8k3J9hIzyHEptjsSFSn1KOXiBtOUFN6JVA==
X-Received: by 2002:a05:620a:1449:: with SMTP id i9mr8765895qkl.4.1557340060486;
        Wed, 08 May 2019 11:27:40 -0700 (PDT)
Received: from localhost.localdomain ([168.181.49.3])
        by smtp.gmail.com with ESMTPSA id x3sm12636871qtk.75.2019.05.08.11.27.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 May 2019 11:27:39 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 1F030180C25; Wed,  8 May 2019 15:27:37 -0300 (-03)
Date:   Wed, 8 May 2019 15:27:37 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>
Cc:     Paolo Abeni <pabeni@redhat.com>, Paul Moore <paul@paul-moore.com>,
        selinux@vger.kernel.org, netdev@vger.kernel.org,
        Tom Deseyn <tdeseyn@redhat.com>,
        Richard Haines <richard_c_haines@btinternet.com>
Subject: Re: [PATCH net] selinux: do not report error on connect(AF_UNSPEC)
Message-ID: <20190508182737.GK10916@localhost.localdomain>
References: <7301017039d68c920cb9120c035a1a0df3e6b30d.1557322358.git.pabeni@redhat.com>
 <36e13dc4-be40-d1f6-0be5-32cd4fc38f6e@tycho.nsa.gov>
 <83b4adb4-9d8f-848f-d1cc-a4a1f30cee51@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <83b4adb4-9d8f-848f-d1cc-a4a1f30cee51@tycho.nsa.gov>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 08, 2019 at 02:13:17PM -0400, Stephen Smalley wrote:
> On 5/8/19 2:12 PM, Stephen Smalley wrote:
> > On 5/8/19 9:32 AM, Paolo Abeni wrote:
> > > calling connect(AF_UNSPEC) on an already connected TCP socket is an
> > > established way to disconnect() such socket. After commit 68741a8adab9
> > > ("selinux: Fix ltp test connect-syscall failure") it no longer works
> > > and, in the above scenario connect() fails with EAFNOSUPPORT.
> > > 
> > > Fix the above falling back to the generic/old code when the address
> > > family
> > > is not AF_INET{4,6}, but leave the SCTP code path untouched, as it has
> > > specific constraints.
> > > 
> > > Fixes: 68741a8adab9 ("selinux: Fix ltp test connect-syscall failure")
> > > Reported-by: Tom Deseyn <tdeseyn@redhat.com>
> > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > ---
> > >   security/selinux/hooks.c | 8 ++++----
> > >   1 file changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > > index c61787b15f27..d82b87c16b0a 100644
> > > --- a/security/selinux/hooks.c
> > > +++ b/security/selinux/hooks.c
> > > @@ -4649,7 +4649,7 @@ static int
> > > selinux_socket_connect_helper(struct socket *sock,
> > >           struct lsm_network_audit net = {0,};
> > >           struct sockaddr_in *addr4 = NULL;
> > >           struct sockaddr_in6 *addr6 = NULL;
> > > -        unsigned short snum;
> > > +        unsigned short snum = 0;
> > >           u32 sid, perm;
> > >           /* sctp_connectx(3) calls via selinux_sctp_bind_connect()
> > > @@ -4674,12 +4674,12 @@ static int
> > > selinux_socket_connect_helper(struct socket *sock,
> > >               break;
> > >           default:
> > >               /* Note that SCTP services expect -EINVAL, whereas
> > > -             * others expect -EAFNOSUPPORT.
> > > +             * others must handle this at the protocol level:
> > > +             * connect(AF_UNSPEC) on a connected socket is
> > > +             * a documented way disconnect the socket.
> > >                */
> > >               if (sksec->sclass == SECCLASS_SCTP_SOCKET)
> > >                   return -EINVAL;
> > > -            else
> > > -                return -EAFNOSUPPORT;
> > 
> > I think we need to return 0 here.  Otherwise, we'll fall through with an
> > uninitialized snum, triggering a random/bogus permission check.
> 
> Sorry, I see that you initialize snum above.  Nonetheless, I think the
> correct behavior here is to skip the check since this is a disconnect, not a
> connect.

Skipping the check would make it less controllable. So should it
somehow re-use shutdown() stuff? It gets very confusing, and after
all, it still is, in essence, a connect() syscall.

> 
> > 
> > >           }
> > >           err = sel_netport_sid(sk->sk_protocol, snum, &sid);
> > > 
> > 
> 
