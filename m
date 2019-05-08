Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF4D1818E
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 23:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbfEHVRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 17:17:49 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40357 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfEHVRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 17:17:48 -0400
Received: by mail-lf1-f67.google.com with SMTP id h13so448045lfc.7
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 14:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EQ5IFoTFe0ngosMYfQyJVw4dpGT8ZrB0KM0wT8+Kzr0=;
        b=XJcO/LEJae4Gbcl2TqXef1yabr8UobIFlV7TYerAB4UcR6VXmiftV4QBnmlzeOFJzF
         4qnBR+xdrh5nYIxJa1aXptI8HPLHuoixwFXbj1KRvsRgve7+02iZzwr7S58t+l5nZ60Y
         7EAQHFayq+4VELU1xWt1S03qtzPq7kOvTKNvXMMZTSSPEn7dnc8vw3PzUYG4wza6UjjR
         aGgqODhai0MbcyBMKMvrfItkwuw0uokoxbgGwUFTB/wzM5laqg/EOehu8dK9QMCSfphi
         br0gknF/uKVzmjOGP5RebqTRfA7TCxhwtsUEdEillWtCqWBiqhieBpEbPNa3MQGsa3GS
         L8Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EQ5IFoTFe0ngosMYfQyJVw4dpGT8ZrB0KM0wT8+Kzr0=;
        b=EgItsT3gSymYZA7ytFgkEbh43BUAE8Ar4ODK0P8yJq5Zr72n9ylwXD1mP614Hi75J+
         5XYufuxgJHjqgWnqmqJTwLTw+2z6Mi+k+8FGZi4Ad4uzWby7cYgB1rgMJoioHg0KbApu
         6SkxOhtQJw9aJLJxgu9lkZ4kEMsHCASO7iolaryPcIeH34m1Nx6F5DvYMzdYDMRlR72F
         YADlpWjOkUYVI0JHXhk0uMGddNjg6CzTcep1enpvDQ8BPlJTiDKUwVPzJ8PvuBbJYqfF
         3vGuibhg/JGFId8xqi4CWbUUPMwrKSrhLoL1PnFiH+Kg6/M0C2m52eNcRc6mHMPYUCRG
         C1YQ==
X-Gm-Message-State: APjAAAXU+IT5drPNIcnwnmNsGm+fARU50YoV9DiLUKsphdTK4nbgX+Xm
        KZ0g1YuJbpOhuOsC6tzrelvVnU1mZUitnC/5Y2jx
X-Google-Smtp-Source: APXvYqxEpS4DBYeWOtbm96Foz71NIYtDNHlgw1P5hxRDyAV5SF1VtDq8ds3optFa57DAqUU1MtHNd7oDR4ZVSEHQSaE=
X-Received: by 2002:a19:9e47:: with SMTP id h68mr128675lfe.91.1557350265386;
 Wed, 08 May 2019 14:17:45 -0700 (PDT)
MIME-Version: 1.0
References: <7301017039d68c920cb9120c035a1a0df3e6b30d.1557322358.git.pabeni@redhat.com>
 <36e13dc4-be40-d1f6-0be5-32cd4fc38f6e@tycho.nsa.gov> <83b4adb4-9d8f-848f-d1cc-a4a1f30cee51@tycho.nsa.gov>
 <20190508182737.GK10916@localhost.localdomain> <0957f30f-07b8-5e2f-ac71-615f511a5eea@tycho.nsa.gov>
In-Reply-To: <0957f30f-07b8-5e2f-ac71-615f511a5eea@tycho.nsa.gov>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 8 May 2019 17:17:34 -0400
Message-ID: <CAHC9VhTs+Q4oAiMGkK9QZBJ9G4yY28WFJkc2jjp05DEW1OAhYw@mail.gmail.com>
Subject: Re: [PATCH net] selinux: do not report error on connect(AF_UNSPEC)
To:     Stephen Smalley <sds@tycho.nsa.gov>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     selinux@vger.kernel.org, netdev@vger.kernel.org,
        Tom Deseyn <tdeseyn@redhat.com>,
        Richard Haines <richard_c_haines@btinternet.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 8, 2019 at 2:55 PM Stephen Smalley <sds@tycho.nsa.gov> wrote:
> On 5/8/19 2:27 PM, Marcelo Ricardo Leitner wrote:
> > On Wed, May 08, 2019 at 02:13:17PM -0400, Stephen Smalley wrote:
> >> On 5/8/19 2:12 PM, Stephen Smalley wrote:
> >>> On 5/8/19 9:32 AM, Paolo Abeni wrote:
> >>>> calling connect(AF_UNSPEC) on an already connected TCP socket is an
> >>>> established way to disconnect() such socket. After commit 68741a8adab9
> >>>> ("selinux: Fix ltp test connect-syscall failure") it no longer works
> >>>> and, in the above scenario connect() fails with EAFNOSUPPORT.
> >>>>
> >>>> Fix the above falling back to the generic/old code when the address
> >>>> family
> >>>> is not AF_INET{4,6}, but leave the SCTP code path untouched, as it has
> >>>> specific constraints.
> >>>>
> >>>> Fixes: 68741a8adab9 ("selinux: Fix ltp test connect-syscall failure")
> >>>> Reported-by: Tom Deseyn <tdeseyn@redhat.com>
> >>>> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> >>>> ---
> >>>>    security/selinux/hooks.c | 8 ++++----
> >>>>    1 file changed, 4 insertions(+), 4 deletions(-)
> >>>>
> >>>> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> >>>> index c61787b15f27..d82b87c16b0a 100644
> >>>> --- a/security/selinux/hooks.c
> >>>> +++ b/security/selinux/hooks.c
> >>>> @@ -4649,7 +4649,7 @@ static int
> >>>> selinux_socket_connect_helper(struct socket *sock,
> >>>>            struct lsm_network_audit net = {0,};
> >>>>            struct sockaddr_in *addr4 = NULL;
> >>>>            struct sockaddr_in6 *addr6 = NULL;
> >>>> -        unsigned short snum;
> >>>> +        unsigned short snum = 0;
> >>>>            u32 sid, perm;
> >>>>            /* sctp_connectx(3) calls via selinux_sctp_bind_connect()
> >>>> @@ -4674,12 +4674,12 @@ static int
> >>>> selinux_socket_connect_helper(struct socket *sock,
> >>>>                break;
> >>>>            default:
> >>>>                /* Note that SCTP services expect -EINVAL, whereas
> >>>> -             * others expect -EAFNOSUPPORT.
> >>>> +             * others must handle this at the protocol level:
> >>>> +             * connect(AF_UNSPEC) on a connected socket is
> >>>> +             * a documented way disconnect the socket.
> >>>>                 */
> >>>>                if (sksec->sclass == SECCLASS_SCTP_SOCKET)
> >>>>                    return -EINVAL;
> >>>> -            else
> >>>> -                return -EAFNOSUPPORT;
> >>>
> >>> I think we need to return 0 here.  Otherwise, we'll fall through with an
> >>> uninitialized snum, triggering a random/bogus permission check.
> >>
> >> Sorry, I see that you initialize snum above.  Nonetheless, I think the
> >> correct behavior here is to skip the check since this is a disconnect, not a
> >> connect.
> >
> > Skipping the check would make it less controllable. So should it
> > somehow re-use shutdown() stuff? It gets very confusing, and after
> > all, it still is, in essence, a connect() syscall.
>
> The function checks CONNECT permission on entry, before reaching this
> point.  This logic is only in preparation for a further check
> (NAME_CONNECT) on the port.  In this case, there is no further check to
> perform and we can just return.

I agree with Stephen, in the connect(AF_UNSPEC) case the right thing
to do is to simply return with no error.

I would also suggest that since this patch only touches the SELinux
code it really should go in via the SELinux tree and not netdev; this
will help avoid merge conflicts in the linux-next tree and during the
merge window.  I think the right thing to do at this point is to
create a revert patch (or have DaveM do it, I'm not sure what he
prefers in situations like this) for this commit, make the adjustments
that Stephen mentioned and submit them for the SELinux tree.

Otherwise, thanks for catching this and submitting a fix :)

-- 
paul moore
www.paul-moore.com
