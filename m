Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD395153B64
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 23:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbgBEWun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 17:50:43 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39325 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727646AbgBEWum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 17:50:42 -0500
Received: by mail-ed1-f67.google.com with SMTP id m13so3859967edb.6
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 14:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oCUytS6g641J3tcs63EguLa4i9YrPYhugF9NrBFVt0A=;
        b=LhqvsuRSA4VPD4eDBS98H9PdhUNvbEDjJfARIvTagB4Pbr7Lzl/Ujvqd9lE6I0E5rv
         iNWm5MfzRgUHzuyhXoD3jmVEMsKjR0F5FBC1ff7mI1h+gnmONlRlo4R93WJZsugNhiFo
         40eR5d65tbSMkjeLa9BQnToHh0xPmJw4SwneOPS0mCA7CKSI2GHWiUz1AzCTX2SldRVq
         rFVUD+N7RDAa5788OR/TzconMfWOwpK0QuAosgMQu6K/YeeRRFqgYwGjx2FGplWEyzmo
         tXdjMQcn4czk3so5X4miLpVFmxKiL2uQWRUQoRnBeQqFp1+7wnReIAJjDJcL68+UlFew
         8p+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oCUytS6g641J3tcs63EguLa4i9YrPYhugF9NrBFVt0A=;
        b=D+e+ZL6yJGYsHyYm6r94B1ShDk+YhnxZh+bjrB7kj60aZytdWZ8khb6dxTOosPuswH
         MkL3q9A6p4qjWM7N0opy5bmR5rLxEOd4RgNLz2AjgielItnSblg6NNAzQYLbQrQeXYcM
         V3Gk4fOH3ichT5uaOjmh5KlQfczd3jPFTqG2lY3S2rPQ8E5UO0D70+X/POO+XP+g6mRS
         6wFxZgSiNf1cfRAAXUixp9/Sc4/iNRSfWLZoOKN3Pf0ng+4NLPI/JNhQBFbSgWoyKUFo
         AveVxnwhYvYXDORH5tMeeNyco7o3lq4w10N8c4CWgrsfjUL5q840Mm42B7Wdpm+dYln3
         N5fw==
X-Gm-Message-State: APjAAAWn8BLSB5uumbdldtUVCcb5smaz9C1XmFprLeYw1DzFOzusMnC3
        CHrpId053ToDzCofwe4avUTAmLuIZYn0Mx3MCyKh
X-Google-Smtp-Source: APXvYqzArv8aqc17G9clMFHzJDgoR01sfKnB5zKeGqYBAG7/zDEtsAzGFNzwSV4GXWYxeN77WLmoVFV8Kzp5Z7nAVys=
X-Received: by 2002:a50:fd15:: with SMTP id i21mr422196eds.12.1580943039631;
 Wed, 05 Feb 2020 14:50:39 -0800 (PST)
MIME-Version: 1.0
References: <cover.1577736799.git.rgb@redhat.com> <7d7933d742fdf4a94c84b791906a450b16f2e81f.1577736799.git.rgb@redhat.com>
 <CAHC9VhSuwJGryfrBfzxG01zwb-O_7dbjS0x0a3w-XjcNuYSAcg@mail.gmail.com>
 <20200123162918.b3jbed7tbvr2sf2p@madcap2.tricolour.ca> <CAHC9VhTusiQoudB8G5jjDFyM9WxBUAjZ6_X35ywJ063Jb75dQA@mail.gmail.com>
 <20200123200412.j2aucdp3cvk57prw@madcap2.tricolour.ca> <CAHC9VhQ2_MQdGAT6Pda9FRe6s0y4JC1XUQenpr-VJiyq9M_CBw@mail.gmail.com>
 <20200204231454.oxa7pyvuxbj466fj@madcap2.tricolour.ca>
In-Reply-To: <20200204231454.oxa7pyvuxbj466fj@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 5 Feb 2020 17:50:28 -0500
Message-ID: <CAHC9VhQquokw+7UOU=G0SsD35UdgmfysVKCGCE87JVaoTkbisg@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling
 the audit daemon
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 4, 2020 at 6:15 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-01-23 16:35, Paul Moore wrote:
> > On Thu, Jan 23, 2020 at 3:04 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2020-01-23 12:09, Paul Moore wrote:
> > > > On Thu, Jan 23, 2020 at 11:29 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > On 2020-01-22 16:28, Paul Moore wrote:
> > > > > > On Tue, Dec 31, 2019 at 2:50 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > > >
> > > > > > > Add audit container identifier support to the action of signalling the
> > > > > > > audit daemon.
> > > > > > >
> > > > > > > Since this would need to add an element to the audit_sig_info struct,
> > > > > > > a new record type AUDIT_SIGNAL_INFO2 was created with a new
> > > > > > > audit_sig_info2 struct.  Corresponding support is required in the
> > > > > > > userspace code to reflect the new record request and reply type.
> > > > > > > An older userspace won't break since it won't know to request this
> > > > > > > record type.
> > > > > > >
> > > > > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > > > > ---
> > > > > > >  include/linux/audit.h       |  7 +++++++
> > > > > > >  include/uapi/linux/audit.h  |  1 +
> > > > > > >  kernel/audit.c              | 35 +++++++++++++++++++++++++++++++++++
> > > > > > >  kernel/audit.h              |  1 +
> > > > > > >  security/selinux/nlmsgtab.c |  1 +
> > > > > > >  5 files changed, 45 insertions(+)
> > > > > >
> > > > > > ...
> > > > > >
> > > > > > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > > > > > index 0871c3e5d6df..51159c94041c 100644
> > > > > > > --- a/kernel/audit.c
> > > > > > > +++ b/kernel/audit.c
> > > > > > > @@ -126,6 +126,14 @@ struct auditd_connection {
> > > > > > >  kuid_t         audit_sig_uid = INVALID_UID;
> > > > > > >  pid_t          audit_sig_pid = -1;
> > > > > > >  u32            audit_sig_sid = 0;
> > > > > > > +/* Since the signal information is stored in the record buffer at the
> > > > > > > + * time of the signal, but not retrieved until later, there is a chance
> > > > > > > + * that the last process in the container could terminate before the
> > > > > > > + * signal record is delivered.  In this circumstance, there is a chance
> > > > > > > + * the orchestrator could reuse the audit container identifier, causing
> > > > > > > + * an overlap of audit records that refer to the same audit container
> > > > > > > + * identifier, but a different container instance.  */
> > > > > > > +u64            audit_sig_cid = AUDIT_CID_UNSET;
> > > > > >
> > > > > > I believe we could prevent the case mentioned above by taking an
> > > > > > additional reference to the audit container ID object when the signal
> > > > > > information is collected, dropping it only after the signal
> > > > > > information is collected by userspace or another process signals the
> > > > > > audit daemon.  Yes, it would block that audit container ID from being
> > > > > > reused immediately, but since we are talking about one number out of
> > > > > > 2^64 that seems like a reasonable tradeoff.
> > > > >
> > > > > I had thought that through and should have been more explicit about that
> > > > > situation when I documented it.  We could do that, but then the syscall
> > > > > records would be connected with the call from auditd on shutdown to
> > > > > request that signal information, rather than the exit of that last
> > > > > process that was using that container.  This strikes me as misleading.
> > > > > Is that really what we want?
> > > >
> > > >  ???
> > > >
> > > > I think one of us is not understanding the other; maybe it's me, maybe
> > > > it's you, maybe it's both of us.
> > > >
> > > > Anyway, here is what I was trying to convey with my original comment
> > > > ... When we record the audit container ID in audit_signal_info() we
> > > > take an extra reference to the audit container ID object so that it
> > > > will not disappear (and get reused) until after we respond with an
> > > > AUDIT_SIGNAL_INFO2.  In audit_receive_msg() when we do the
> > > > AUDIT_SIGNAL_INFO2 processing we drop the extra reference we took in
> > > > audit_signal_info().  Unless I'm missing some other change you made,
> > > > this *shouldn't* affect the syscall records, all it does is preserve
> > > > the audit container ID object in the kernel's ACID store so it doesn't
> > > > get reused.
> > >
> > > This is exactly what I had understood.  I hadn't considered the extra
> > > details below in detail due to my original syscall concern, but they
> > > make sense.
> > >
> > > The syscall I refer to is the one connected with the drop of the
> > > audit container identifier by the last process that was in that
> > > container in patch 5/16.  The production of this record is contingent on
> > > the last ref in a contobj being dropped.  So if it is due to that ref
> > > being maintained by audit_signal_info() until the AUDIT_SIGNAL_INFO2
> > > record it fetched, then it will appear that the fetch action closed the
> > > container rather than the last process in the container to exit.
> > >
> > > Does this make sense?
> >
> > More so than your original reply, at least to me anyway.
> >
> > It makes sense that the audit container ID wouldn't be marked as
> > "dead" since it would still be very much alive and available for use
> > by the orchestrator, the question is if that is desirable or not.  I
> > think the answer to this comes down the preserving the correctness of
> > the audit log.
> >
> > If the audit container ID reported by AUDIT_SIGNAL_INFO2 has been
> > reused then I think there is a legitimate concern that the audit log
> > is not correct, and could be misleading.  If we solve that by grabbing
> > an extra reference, then there could also be some confusion as
> > userspace considers a container to be "dead" while the audit container
> > ID still exists in the kernel, and the kernel generated audit
> > container ID death record will not be generated until much later (and
> > possibly be associated with a different event, but that could be
> > solved by unassociating the container death record).
>
> How does syscall association of the death record with AUDIT_SIGNAL_INFO2
> possibly get associated with another event?  Or is the syscall
> association with the fetch for the AUDIT_SIGNAL_INFO2 the other event?

The issue is when does the audit container ID "die".  If it is when
the last task in the container exits, then the death record will be
associated when the task's exit.  If the audit container ID lives on
until the last reference of it in the audit logs, including the
SIGNAL_INFO2 message, the death record will be associated with the
related SIGNAL_INFO2 syscalls, or perhaps unassociated depending on
the details of the syscalls/netlink.

> Another idea might be to bump the refcount in audit_signal_info() but
> mark tht contid as dead so it can't be reused if we are concerned that
> the dead contid be reused?

Ooof.  Yes, maybe, but that would be ugly.

> There is still the problem later that the reported contid is incomplete
> compared to the rest of the contid reporting cycle wrt nesting since
> AUDIT_SIGNAL_INFO2 will need to be more complex w/2 variable length
> fields to accommodate a nested contid list.

Do we really care about the full nested audit container ID list in the
SIGNAL_INFO2 record?

> >  Of the two
> > approaches, I think the latter is safer in that it preserves the
> > correctness of the audit log, even though it could result in a delay
> > of the container death record.
>
> I prefer the former since it strongly indicates last task in the
> container.  The AUDIT_SIGNAL_INFO2 msg has the pid and other subject
> attributes and the contid to strongly link the responsible party.

Steve is the only one who really tracks the security certifications
that are relevant to audit, see what the certification requirements
have to say and we can revisit this.

-- 
paul moore
www.paul-moore.com
