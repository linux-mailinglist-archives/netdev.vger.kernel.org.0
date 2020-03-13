Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 931F7184CB5
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 17:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgCMQme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 12:42:34 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45263 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbgCMQm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 12:42:29 -0400
Received: by mail-ed1-f68.google.com with SMTP id h62so12612022edd.12
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 09:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fseESP4/6eZrF7SBqCWgCJDujjfpWUfHCgGZ1kuRd5o=;
        b=zd1ZH/AlS3TbSHvxUOfMYsYI7xGqfmX3YTyuPQ1nLeVvN62DN60VE/0MZPOeFwoJVk
         vKbMjXdNH1YZ9LEPveYDl3w6dEbe2QZFfSJNtkhBOdijeul1fW2Q5xn7GfT6FkU98cFj
         AJGSch48gB3wXyq9Wj0AdQHp3mhCIgPDqgq862XSsUuwmzHEIgW67/as6V1UFglv6SaT
         luDC9ysdgV/i3bryHrcWEP/p0RjyduXHlH8tfJa/jmgmn4AAFPo4KhdDz1IPZGM3My1Q
         ZeyQmGcoTLmTlKWfRdjMYrZ/kvK8l0vD7VH1fn7Lovnr+DE5MzKr8g3iKvzEAkRUSby6
         IABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fseESP4/6eZrF7SBqCWgCJDujjfpWUfHCgGZ1kuRd5o=;
        b=Vcog/FIJrFlPJI9twDig7gSQMoXiVagO5E6CDfU5fPBoB63aHQ+oGmmZAm93U451ve
         cWkRpXUMrkqTx0l2oN4fyDfbjWNp6FjAT56WxLCK7kr4OBTeZhAy02lpjZ2vlLd6EJmN
         5SUSqBS9rbzKfapt5mw970dLrdD07by4w1tB7DZ+ShwAYQcP227Kvcz1g1YpqUpGoppN
         2Q7CGiXJsAL1OR01VSoTC9SD+wWDXo6Bsw7V9Y5KMsfeDzpF+3Yxi7RUPQe/+2hvfsPY
         5KCWq+HWUCH8wu09pJKy5+S344iwBJSxaPZsD0ViZJE6Z07JBIrperSfaCy8HoIMKgIQ
         feZg==
X-Gm-Message-State: ANhLgQ2MlRpy1LS6e/uKCrgDLpQ3fxyepeBXwH0YH7kU+RpTek3G3JgM
        XCzw+OejbFkAHHXMFvDnsdqBFUbP7Lw1Yc0nZjPn
X-Google-Smtp-Source: ADFU+vvajfe7FzM5cQGzdQfpTe9TTE6KHC11fzbM1Zr68GNq3W7wdl0w72wFAg4JVruBDmd8wgIyHiHnlGFU1+4TGp0=
X-Received: by 2002:a50:e108:: with SMTP id h8mr13582550edl.196.1584117746924;
 Fri, 13 Mar 2020 09:42:26 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1577736799.git.rgb@redhat.com> <20200204231454.oxa7pyvuxbj466fj@madcap2.tricolour.ca>
 <CAHC9VhQquokw+7UOU=G0SsD35UdgmfysVKCGCE87JVaoTkbisg@mail.gmail.com>
 <3142237.YMNxv0uec1@x2> <CAHC9VhTiCHQbp2SwK0Xb1QgpUZxOQ26JKKPsVGT0ZvMqx28oPQ@mail.gmail.com>
 <20200312202733.7kli64zsnqc4mrd2@madcap2.tricolour.ca>
In-Reply-To: <20200312202733.7kli64zsnqc4mrd2@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 13 Mar 2020 12:42:15 -0400
Message-ID: <CAHC9VhS9DtxJ4gvOfMRnzoo6ccGJVKL+uZYe6qqH+SPqD8r01Q@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling
 the audit daemon
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Steve Grubb <sgrubb@redhat.com>, linux-audit@redhat.com,
        nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 4:27 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-02-12 19:09, Paul Moore wrote:
> > On Wed, Feb 12, 2020 at 5:39 PM Steve Grubb <sgrubb@redhat.com> wrote:
> > > On Wednesday, February 5, 2020 5:50:28 PM EST Paul Moore wrote:
> > > > > > > > ... When we record the audit container ID in audit_signal_info() we
> > > > > > > > take an extra reference to the audit container ID object so that it
> > > > > > > > will not disappear (and get reused) until after we respond with an
> > > > > > > > AUDIT_SIGNAL_INFO2.  In audit_receive_msg() when we do the
> > > > > > > > AUDIT_SIGNAL_INFO2 processing we drop the extra reference we took
> > > > > > > > in
> > > > > > > > audit_signal_info().  Unless I'm missing some other change you
> > > > > > > > made,
> > > > > > > > this *shouldn't* affect the syscall records, all it does is
> > > > > > > > preserve
> > > > > > > > the audit container ID object in the kernel's ACID store so it
> > > > > > > > doesn't
> > > > > > > > get reused.
> > > > > > >
> > > > > > > This is exactly what I had understood.  I hadn't considered the extra
> > > > > > > details below in detail due to my original syscall concern, but they
> > > > > > > make sense.
> > > > > > >
> > > > > > > The syscall I refer to is the one connected with the drop of the
> > > > > > > audit container identifier by the last process that was in that
> > > > > > > container in patch 5/16.  The production of this record is contingent
> > > > > > > on
> > > > > > > the last ref in a contobj being dropped.  So if it is due to that ref
> > > > > > > being maintained by audit_signal_info() until the AUDIT_SIGNAL_INFO2
> > > > > > > record it fetched, then it will appear that the fetch action closed
> > > > > > > the
> > > > > > > container rather than the last process in the container to exit.
> > > > > > >
> > > > > > > Does this make sense?
> > > > > >
> > > > > > More so than your original reply, at least to me anyway.
> > > > > >
> > > > > > It makes sense that the audit container ID wouldn't be marked as
> > > > > > "dead" since it would still be very much alive and available for use
> > > > > > by the orchestrator, the question is if that is desirable or not.  I
> > > > > > think the answer to this comes down the preserving the correctness of
> > > > > > the audit log.
> > > > > >
> > > > > > If the audit container ID reported by AUDIT_SIGNAL_INFO2 has been
> > > > > > reused then I think there is a legitimate concern that the audit log
> > > > > > is not correct, and could be misleading.  If we solve that by grabbing
> > > > > > an extra reference, then there could also be some confusion as
> > > > > > userspace considers a container to be "dead" while the audit container
> > > > > > ID still exists in the kernel, and the kernel generated audit
> > > > > > container ID death record will not be generated until much later (and
> > > > > > possibly be associated with a different event, but that could be
> > > > > > solved by unassociating the container death record).
> > > > >
> > > > > How does syscall association of the death record with AUDIT_SIGNAL_INFO2
> > > > > possibly get associated with another event?  Or is the syscall
> > > > > association with the fetch for the AUDIT_SIGNAL_INFO2 the other event?
> > > >
> > > > The issue is when does the audit container ID "die".  If it is when
> > > > the last task in the container exits, then the death record will be
> > > > associated when the task's exit.  If the audit container ID lives on
> > > > until the last reference of it in the audit logs, including the
> > > > SIGNAL_INFO2 message, the death record will be associated with the
> > > > related SIGNAL_INFO2 syscalls, or perhaps unassociated depending on
> > > > the details of the syscalls/netlink.
> > > >
> > > > > Another idea might be to bump the refcount in audit_signal_info() but
> > > > > mark tht contid as dead so it can't be reused if we are concerned that
> > > > > the dead contid be reused?
> > > >
> > > > Ooof.  Yes, maybe, but that would be ugly.
> > > >
> > > > > There is still the problem later that the reported contid is incomplete
> > > > > compared to the rest of the contid reporting cycle wrt nesting since
> > > > > AUDIT_SIGNAL_INFO2 will need to be more complex w/2 variable length
> > > > > fields to accommodate a nested contid list.
> > > >
> > > > Do we really care about the full nested audit container ID list in the
> > > > SIGNAL_INFO2 record?
>
> I'm inclined to hand-wave it away as inconvenient that can be looked up
> more carefully if it is really needed.  Maybe the block above would be
> safer and more complete even though it is ugly.
>
> > > > > > Of the two
> > > > > > approaches, I think the latter is safer in that it preserves the
> > > > > > correctness of the audit log, even though it could result in a delay
> > > > > > of the container death record.
> > > > >
> > > > > I prefer the former since it strongly indicates last task in the
> > > > > container.  The AUDIT_SIGNAL_INFO2 msg has the pid and other subject
> > > > > attributes and the contid to strongly link the responsible party.
> > > >
> > > > Steve is the only one who really tracks the security certifications
> > > > that are relevant to audit, see what the certification requirements
> > > > have to say and we can revisit this.
> > >
> > > Sever Virtualization Protection Profile is the closest applicable standard
> > >
> > > https://www.niap-ccevs.org/Profile/Info.cfm?PPID=408&id=408
> > >
> > > It is silent on audit requirements for the lifecycle of a VM. I assume that
> > > all that is needed is what the orchestrator says its doing at the high level.
> > > So, if an orchestrator wants to shutdown a container, the orchestrator must
> > > log that intent and its results. In a similar fashion, systemd logs that it's
> > > killing a service and we don't actually hook the exit syscall of the service
> > > to record that.
> > >
> > > Now, if a container was being used as a VPS, and it had a fully functioning
> > > userspace, it's own services, and its very own audit daemon, then in this
> > > case it would care who sent a signal to its auditd. The tenant of that
> > > container may have to comply with PCI-DSS or something else. It would log the
> > > audit service is being terminated and systemd would record that its tearing
> > > down the environment. The OS doesn't need to do anything.
> >
> > This latter case is the case of interest here, since the host auditd
> > should only be killed from a process on the host itself, not a process
> > running in a container.  If we work under the assumption (and this may
> > be a break in our approach to not defining "container") that an auditd
> > instance is only ever signaled by a process with the same audit
> > container ID (ACID), is this really even an issue?  Right now it isn't
> > as even with this patchset we will still really only support one
> > auditd instance, presumably on the host, so this isn't a significant
> > concern.  Moving forward, once we add support for multiple auditd
> > instances we will likely need to move the signal info into
> > (potentially) s per-ACID struct, a struct whose lifetime would match
> > that of the associated container by definition; as the auditd
> > container died, the struct would die, the refcounts dropped, and any
> > ACID held only the signal info refcount would be dropped/killed.
>
> Any process could signal auditd if it can see it based on namespace
> relationships, nevermind container placement.  Some container
> architectures would not have a namespace configuration that would block
> this (combination of PID/user/IPC?).
>
> > However, making this assumption would mean that we are expecting a
> > "container" to provide some level of isolation such that processes
> > with a different audit container ID do not signal each other.  From a
> > practical perspective I think that fits with the most (all?)
> > definitions of "container", but I can't say that for certain.  In
> > those cases where the assumption is not correct and processes can
> > signal each other across audit container ID boundaries, perhaps it is
> > enough to explain that an audit container ID may not fully disappear
> > until it has been fetched with a SIGNAL_INFO2 message.
>
> I think more and more, that more complete isolation is being done,
> taking advantage of each type of namespace as they become available, but
> I know a nuber of them didn't find it important yet to use IPC, PID or
> user namespaces which would be the only namespaces I can think of that
> would provide that isolation.
>
> It isn't entirely clear to me which side you fall on this issue, Paul.

That's mostly because I was hoping for some clarification in the
discussion, especially the relevant certification requirements, but it
looks like there is still plenty of room for interpretation there (as
usual).  I'd much rather us arrive at decisions based on requirements
and not gut feelings, which is where I think we are at right now.

> Can you pronounce on your strong preference one way or the other if the
> death of a container coincide with the exit of the last process in that
> namespace, or the fetch of any signal info related to it?

"pronounce on your strong preference"?  I've seen you use "pronounce"
a few times now, and suggest a different word in the future; the
connotation is not well received on my end.

> I have a bias
> to the former since the code already does that and I feel the exit of
> the last process is much more relevant supported by the syscall record,
> but could change it to the latter if you feel strongly enough about it
> to block upstream acceptance.

At this point in time I believe the right thing to do is to preserve
the audit container ID as "dead but still in existence" so that there
is no confusion (due to reuse) if/when it finally reappears in the
audit record stream.

The thread has had a lot of starts/stops, so I may be repeating a
previous suggestion, but one idea would be to still emit a "death
record" when the final task in the audit container ID does die, but
block the particular audit container ID from reuse until it the
SIGNAL2 info has been reported.  This gives us the timely ACID death
notification while still preventing confusion and ambiguity caused by
potentially reusing the ACID before the SIGNAL2 record has been sent;
there is a small nit about the ACID being present in the SIGNAL2
*after* its death, but I think that can be easily explained and
understood by admins.

-- 
paul moore
www.paul-moore.com
