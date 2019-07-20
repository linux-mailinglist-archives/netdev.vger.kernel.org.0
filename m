Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADD936ED47
	for <lists+netdev@lfdr.de>; Sat, 20 Jul 2019 04:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390227AbfGTCTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 22:19:17 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53056 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729002AbfGTCTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 22:19:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 05B218EE109;
        Fri, 19 Jul 2019 19:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1563589156;
        bh=z0BDlptRINl0TYz1Ruemp+2buxW+5SV0bIk9ZQ6n5e0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hDPi/0twr/uhtvTNMyW41cjDy7W3wq32Zf9pSLU3lECjSIsDguI7rTiCDZrgrS28m
         lJVANDcU0y1M4+leAVIPMJ+8rbzBxDw7n83ljBnIQEiQvjx8yBsF3UvSAREJ9zu5Vq
         UUevmjYH9qvOEvQy+Nm5iNu7sYVvL/L7LxuLb8Ek=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id KZKJBXWlIdD4; Fri, 19 Jul 2019 19:19:15 -0700 (PDT)
Received: from [192.168.11.4] (122x212x32x58.ap122.ftth.ucom.ne.jp [122.212.32.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id D14718EE0EF;
        Fri, 19 Jul 2019 19:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1563589155;
        bh=z0BDlptRINl0TYz1Ruemp+2buxW+5SV0bIk9ZQ6n5e0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IvmAdq30Jx7NUn/Uys0+laN2G3mJRyivOZxKsX/+9kpMDqTn9H0/HOpR23pEUnSfL
         FGNsM3KMGKfOX3Dsh35bsYWk65pp5kG957sswyp0TR81fAAzcWgitNASbXbPSXkR5n
         OF5kDPjqZ2XZh3bk4KWkKo7jsHgvE5qadhEHKV8A=
Message-ID: <1563589150.1602.21.camel@HansenPartnership.com>
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Paul Moore <paul@paul-moore.com>
Cc:     nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, omosnace@redhat.com,
        dhowells@redhat.com,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, simo@redhat.com,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>, sgrubb@redhat.com
Date:   Sat, 20 Jul 2019 11:19:10 +0900
In-Reply-To: <87muhadnfr.fsf@xmission.com>
References: <20190529153427.GB8959@cisco>
         <CAHC9VhSF3AjErX37+eeusJ7+XRw8yuPsmqBTRwc9EVoRBh_3Tw@mail.gmail.com>
         <20190529222835.GD8959@cisco>
         <CAHC9VhRS66VGtug3fq3RTGHDvfGmBJG6yRJ+iMxm3cxnNF-zJw@mail.gmail.com>
         <20190530170913.GA16722@mail.hallyn.com>
         <CAHC9VhThLiQzGYRUWmSuVfOC6QCDmA75BDB7Eg7V8HX4x7ymQg@mail.gmail.com>
         <20190708180558.5bar6ripag3sdadl@madcap2.tricolour.ca>
         <CAHC9VhRTT7JWqNnynvK04wKerjc-3UJ6R1uPtjCAPVr_tW-7MA@mail.gmail.com>
         <20190716220320.sotbfqplgdructg7@madcap2.tricolour.ca>
         <CAHC9VhScHizB2r5q3T5s0P3jkYdvzBPPudDksosYFp_TO7W9-Q@mail.gmail.com>
         <20190718005145.eshekqfr3navqqiy@madcap2.tricolour.ca>
         <CAHC9VhTYV02ws3QcezER5cY+Xt+tExcJEO-dumTDx=FXGFh3nw@mail.gmail.com>
         <87muhadnfr.fsf@xmission.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-07-19 at 11:00 -0500, Eric W. Biederman wrote:
> Paul Moore <paul@paul-moore.com> writes:
> 
> > On Wed, Jul 17, 2019 at 8:52 PM Richard Guy Briggs <rgb@redhat.com>
> > wrote:
> > > On 2019-07-16 19:30, Paul Moore wrote:
> > 
> > ...
> > 
> > > > We can trust capable(CAP_AUDIT_CONTROL) for enforcing audit
> > > > container ID policy, we can not trust
> > > > ns_capable(CAP_AUDIT_CONTROL).
> > > 
> > > Ok.  So does a process in a non-init user namespace have two (or
> > > more) sets of capabilities stored in creds, one in the
> > > init_user_ns, and one in current_user_ns?  Or does it get
> > > stripped of all its capabilities in init_user_ns once it has its
> > > own set in current_user_ns?  If the former, then we can use
> > > capable().  If the latter, we need another mechanism, as
> > > you have suggested might be needed.
> > 
> > Unfortunately I think the problem is that ultimately we need to
> > allow any container orchestrator that has been given privileges to
> > manage the audit container ID to also grant that privilege to any
> > of the child process/containers it manages.  I don't believe we can
> > do that with capabilities based on the code I've looked at, and the
> > discussions I've had, but if you find a way I would leave to hear
> > it.
> > > If some random unprivileged user wants to fire up a container
> > > orchestrator/engine in his own user namespace, then audit needs
> > > to be namespaced.  Can we safely discard this scenario for now?
> > 
> > I think the only time we want to allow a container orchestrator to
> > manage the audit container ID is if it has been granted that
> > privilege by someone who has that privilege already.  In the zero-
> > container, or single-level of containers, case this is relatively
> > easy, and we can accomplish it using CAP_AUDIT_CONTROL as the
> > privilege.  If we start nesting container orchestrators it becomes
> > more complicated as we need to be able to support granting and
> > inheriting this privilege in a manner; this is why I suggested a
> > new mechanism *may* be necessary.
> 
> 
> Let me segway a bit and see if I can get this conversation out of the
> rut it seems to have drifted into.
> 
> Unprivileged containers and nested containers exist today and are
> going to become increasingly common.  Let that be a given.

Agree fully.

> As I recall the interesting thing for audit to log is actions by
> privileged processes.  Audit can log more but generally configuring
> logging by of the actions of unprivileged users is effectively a self
> DOS.
> 
> So I think the initial implementation can safely ignore actions of
> nested containers and unprivileged containers because you don't care
> about their actions. 

I don't entirely agree here:  remember there might be two consumers for
the audit data: the physical system owner (checking up on the tenants)
and the tenant themselves who might be watching either their sub
tenants or their users (and who, obviously, won't get the full audit
stream).  In either case, the tenant may or may not be privileged, and
if they're privileged, it might be through the user_ns in which case
the physical system owner and the kernel would see them as "not
privileged".  So I think we are ultimately going to need the ability to
audit unprivileged containers.

I also think audit has a role to play in intrusion detection and
forensic analysis for fully unprivileged containers running external
services, but I don't think we have to solve that case immediately.

> If we start allow running audit in a container then we need to deal
> with all of the nesting issues but until then I don't think you folks
> care.
> 
> Or am I wrong.  Do the requirements for securely auditing things from
> the kernel care about the actions of unprivileged users?

I think ultimately we have to care, but it could be three phases: first
would be genuinely privileged containers (i.e. with real root inside,
being our most dangerous problem) the second would be user_ns
privileged containers (i.e. with both user_ns and an interior root
mapping) and the third would be unprivileged containers (with or
without user_ns but no interior root).

James

