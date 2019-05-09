Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A859418A70
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 15:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfEINRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 09:17:43 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34273 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfEINRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 09:17:43 -0400
Received: by mail-lj1-f195.google.com with SMTP id j24so1182338ljg.1
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 06:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UK57Qpg2zy+HIHqUbIlgo6gcv45uOIzqG7zicSDKtBQ=;
        b=r8LYnMZP+CKUWqlfrwW03XnQJjhoy8fJK4DqTxvggeq9uZxsQoqbo05OhI76LDbPJq
         ohjVdhpSmB6/2Wka7c3GYeHocpjRlo6sOqLOTJGDmT4ZIf6MUHnJ+6CgX4Vaq8j5EdbS
         ah8Koq5YBbHZMz/xUGjmPw3Z104UIxnVnlZfXQujMTKazRmwixWW9l3PU22jBlG/kCch
         xZjfB9It4yeaF6ynOTa36XYV0qX4qdLCFg7Yi9bSvWjME9VsZOZ+VYwyARLT07n0WpIu
         Abq8Wr1SHd4WmQFNR5kYlWMioVV0wN/ZfhvvmvRSSVCXion41zbAwCenVW8XuotSB6YN
         trPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UK57Qpg2zy+HIHqUbIlgo6gcv45uOIzqG7zicSDKtBQ=;
        b=MHmb7mgQUenGrgbCznxtd8RNJ8qAEMSbS7FV//uU86nUw4c3NhOVrfcYtPpLuGLOUB
         cqUeezSgFloVZ5PLdu1GYojoU6kOEbtS73XIY2+9CBGawyI3kj930VUfTbKrpDOq9n+0
         SYHawO7o12IQ/8BVAn/V8yIX6OXVZ6FSNn0I8xtY91YuC5iTekVEClqEAHFIUgUWKNyF
         PwpwdjzZZohIAldxcuuIXpEyHT8MX8cndZAyeyPVhwcGY699kXz3dWP+HuCvbG06sGau
         Xz9wAJgYwzMEDiX0qMjsx3KnvgT+TWJ2aifePXCTQ6kRxyRfL69zs52E5lT2xjBze29j
         mbmA==
X-Gm-Message-State: APjAAAU3UyzPATNLCtwqm0mOzk+z841bsumubUjf15sxHWy2XK0S9cqN
        sCbpCsapMOHmbbSEC6CmrRxEibt9/gHNekTQoKAz
X-Google-Smtp-Source: APXvYqwszAIEgdM6DVZFdOkZQsuXgGBf13AQBZrLVY/OG3of051x8GsXQinLx8o1yLJzSL/WJP/E7xd+TRQDBO7xY6s=
X-Received: by 2002:a2e:98c6:: with SMTP id s6mr2325854ljj.161.1557407860555;
 Thu, 09 May 2019 06:17:40 -0700 (PDT)
MIME-Version: 1.0
References: <7301017039d68c920cb9120c035a1a0df3e6b30d.1557322358.git.pabeni@redhat.com>
 <36e13dc4-be40-d1f6-0be5-32cd4fc38f6e@tycho.nsa.gov> <83b4adb4-9d8f-848f-d1cc-a4a1f30cee51@tycho.nsa.gov>
 <20190508182737.GK10916@localhost.localdomain> <0957f30f-07b8-5e2f-ac71-615f511a5eea@tycho.nsa.gov>
 <CAHC9VhTs+Q4oAiMGkK9QZBJ9G4yY28WFJkc2jjp05DEW1OAhYw@mail.gmail.com> <bcfa1b06f277357d89b746a4fced49c0617deef1.camel@redhat.com>
In-Reply-To: <bcfa1b06f277357d89b746a4fced49c0617deef1.camel@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 9 May 2019 09:17:28 -0400
Message-ID: <CAHC9VhRjWX5zyJ1F8U7m-=veMLrynUnYp9AW-Bjff-+V_DJ65g@mail.gmail.com>
Subject: Re: [PATCH net] selinux: do not report error on connect(AF_UNSPEC)
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     davem@davemloft.net, selinux@vger.kernel.org,
        netdev@vger.kernel.org, Tom Deseyn <tdeseyn@redhat.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 9, 2019 at 4:40 AM Paolo Abeni <pabeni@redhat.com> wrote:
> On Wed, 2019-05-08 at 17:17 -0400, Paul Moore wrote:
> > On Wed, May 8, 2019 at 2:55 PM Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > > On 5/8/19 2:27 PM, Marcelo Ricardo Leitner wrote:
> > > > On Wed, May 08, 2019 at 02:13:17PM -0400, Stephen Smalley wrote:
> > > > > On 5/8/19 2:12 PM, Stephen Smalley wrote:
> > > > > > On 5/8/19 9:32 AM, Paolo Abeni wrote:
> > > > > > > calling connect(AF_UNSPEC) on an already connected TCP socket is an
> > > > > > > established way to disconnect() such socket. After commit 68741a8adab9
> > > > > > > ("selinux: Fix ltp test connect-syscall failure") it no longer works
> > > > > > > and, in the above scenario connect() fails with EAFNOSUPPORT.
> > > > > > >
> > > > > > > Fix the above falling back to the generic/old code when the address
> > > > > > > family
> > > > > > > is not AF_INET{4,6}, but leave the SCTP code path untouched, as it has
> > > > > > > specific constraints.
> > > > > > >
> > > > > > > Fixes: 68741a8adab9 ("selinux: Fix ltp test connect-syscall failure")
> > > > > > > Reported-by: Tom Deseyn <tdeseyn@redhat.com>
> > > > > > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > > > > > ---
> > > > > > >    security/selinux/hooks.c | 8 ++++----
> > > > > > >    1 file changed, 4 insertions(+), 4 deletions(-)
> > > > > > >
> > > > > > > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > > > > > > index c61787b15f27..d82b87c16b0a 100644
> > > > > > > --- a/security/selinux/hooks.c
> > > > > > > +++ b/security/selinux/hooks.c
> > > > > > > @@ -4649,7 +4649,7 @@ static int
> > > > > > > selinux_socket_connect_helper(struct socket *sock,
> > > > > > >            struct lsm_network_audit net = {0,};
> > > > > > >            struct sockaddr_in *addr4 = NULL;
> > > > > > >            struct sockaddr_in6 *addr6 = NULL;
> > > > > > > -        unsigned short snum;
> > > > > > > +        unsigned short snum = 0;
> > > > > > >            u32 sid, perm;
> > > > > > >            /* sctp_connectx(3) calls via selinux_sctp_bind_connect()
> > > > > > > @@ -4674,12 +4674,12 @@ static int
> > > > > > > selinux_socket_connect_helper(struct socket *sock,
> > > > > > >                break;
> > > > > > >            default:
> > > > > > >                /* Note that SCTP services expect -EINVAL, whereas
> > > > > > > -             * others expect -EAFNOSUPPORT.
> > > > > > > +             * others must handle this at the protocol level:
> > > > > > > +             * connect(AF_UNSPEC) on a connected socket is
> > > > > > > +             * a documented way disconnect the socket.
> > > > > > >                 */
> > > > > > >                if (sksec->sclass == SECCLASS_SCTP_SOCKET)
> > > > > > >                    return -EINVAL;
> > > > > > > -            else
> > > > > > > -                return -EAFNOSUPPORT;
> > > > > >
> > > > > > I think we need to return 0 here.  Otherwise, we'll fall through with an
> > > > > > uninitialized snum, triggering a random/bogus permission check.
> > > > >
> > > > > Sorry, I see that you initialize snum above.  Nonetheless, I think the
> > > > > correct behavior here is to skip the check since this is a disconnect, not a
> > > > > connect.
> > > >
> > > > Skipping the check would make it less controllable. So should it
> > > > somehow re-use shutdown() stuff? It gets very confusing, and after
> > > > all, it still is, in essence, a connect() syscall.
> > >
> > > The function checks CONNECT permission on entry, before reaching this
> > > point.  This logic is only in preparation for a further check
> > > (NAME_CONNECT) on the port.  In this case, there is no further check to
> > > perform and we can just return.
> >
> > I agree with Stephen, in the connect(AF_UNSPEC) case the right thing
> > to do is to simply return with no error.
>
> The 'default:' case is catching any address family other than
> INET{4,6}, but I guess you argument still applies - selinux should not
> do name check for unknown protocols ?!?

If the code doesn't understand how to parse the port/"name" info it
can't really do a useful name_connect check, this is why we return
-EAFNOSUPPORT in the default case (or -EINVAL in the case of SCTP).
However, the connect/AF_UNSPEC case is a bit of a special case and as
such I probably needs special handling.

My initial thinking is that we should do the AF_UNSPEC check
immediately after the sock_has_perm() check in
selinux_socket_connect_helper():

       err = sock_has_perm(sk, SOCKET__CONNECT);
       if (err)
               return err;
       if (addrlen < offsetofend(struct sockaddr, sa_family))
               return -EINVAL;
       if (address->sa_family == AF_UNSPEC)
               return 0;

... we can then remove the addrlen check from inside the TCP/DCCP/SCTP
if-true block later in the function.  There is the downside the we are
now adding some additional code that executes for each connect() call
(as opposed to just TCP/DCCP/SCTP), but this seems much cleaner from a
conceptual point of view and I expect the overhead to be in the
"unmeasurable" range.

> > I would also suggest that since this patch only touches the SELinux
> > code it really should go in via the SELinux tree and not netdev; this
> > will help avoid merge conflicts in the linux-next tree and during the
> > merge window.  I think the right thing to do at this point is to
> > create a revert patch (or have DaveM do it, I'm not sure what he
> > prefers in situations like this) for this commit, make the adjustments
> > that Stephen mentioned and submit them for the SELinux tree.
>
> Sorry, my fault, I sent the email to both MLs for more awareness, I
> should have used a different subject prefix.

It's not a big deal for patches this small, but since you're going to
respin this patch anyway I figured it would be worth mentioning.
Also, I have no object to posting to multiple MLs when appropriate (it
seems appropriate here); I think the problem here was the "[PATCH
net]" which caused DaveM to pull it into his tree.

> @DaveM: if it's ok for you, I'll send a revert for this on netdev and
> I'll send a v2 via the selinux ML, please let me know!

-- 
paul moore
www.paul-moore.com
