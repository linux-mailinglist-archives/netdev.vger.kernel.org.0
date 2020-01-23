Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6CD146F36
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbgAWRJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 12:09:18 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46591 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729224AbgAWRJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 12:09:18 -0500
Received: by mail-lj1-f195.google.com with SMTP id m26so4306234ljc.13
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 09:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EoI0l4kaWTQec4tn5Ld9ZCvI5RqFAqp9PrVGXBLYlGE=;
        b=fVFhxuuC85CKWEXjWPZjUwe+E2ZvU24vSAIadJBa+Ft9IRArNmW35Swl+jhyL4SbSw
         Q9y1gY0sctni33PC0OvsTEp15m3qeF+Ox4KoeaR1j1bfiGK/un6S52NDn4Mmp7JZyTWN
         T4+GcR/uluwB+tQB+fNDYzVWf25RKz6Wf9cz/hgquK9Jxf67xA/gq61Jlji6pBo0BW1h
         pphNci+Itjc9Hy6EK728qegKSUWTqi4toMGOqpiG4FTi4ZVSa3Pyo+WL4giv/emjl4KZ
         N+8QV2duNaLjezM2vWW4tbJ2IqC9/1zcehqsTVQU1Cz0GaYOg/ae7LEcFoRy5LtZ74Xo
         fKgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EoI0l4kaWTQec4tn5Ld9ZCvI5RqFAqp9PrVGXBLYlGE=;
        b=DR4GZUybkE+hw7D8st7XIZjU0vmpDpU4FcvG+9+5nvNXVr5eFQYJl584ob6LSeWk6c
         i3CGYRqAVrbxhxTQv/we2VCC4j6t7BiL7cP4UYSHqGbxt5p6/K8QYtmEZYY016Z+yjRj
         ExWPHC6n/fiidVlFgrnLKnb2C131sEpiCdl2j1/Oom8yCZ21oi1LOJGC8KFlLZ9Q6CwN
         wFHrzksFQwrHST7SApVj8MkergCacwxTXERIziA2kOeBtC0SeFQts8AGtSEA55VJUFI2
         OiU88dpb1+RtCPaLB+EdXuaHmZaeW/RFx7mTXC+d2Qq1Ex6GtRmZqpke/dZkPenGKBuE
         MkjA==
X-Gm-Message-State: APjAAAUbRgYsZO4Lm4ahW6DyL9BVxVCsserCHUvFf5tjVVqlE4aeRt3w
        MWlKRK5smfgDlYfH3OosZ4MwQ46dq9Yf8uvhnjzE
X-Google-Smtp-Source: APXvYqw/G8F1wO9xDPIULnMv336Q7Ztb/ejMkG/Wfe5XISfozmjQXVeq7xRRyREbIKTpRE6MgbiXKL2eAyaswTaX414=
X-Received: by 2002:a2e:9f52:: with SMTP id v18mr23988656ljk.30.1579799355718;
 Thu, 23 Jan 2020 09:09:15 -0800 (PST)
MIME-Version: 1.0
References: <cover.1577736799.git.rgb@redhat.com> <7d7933d742fdf4a94c84b791906a450b16f2e81f.1577736799.git.rgb@redhat.com>
 <CAHC9VhSuwJGryfrBfzxG01zwb-O_7dbjS0x0a3w-XjcNuYSAcg@mail.gmail.com> <20200123162918.b3jbed7tbvr2sf2p@madcap2.tricolour.ca>
In-Reply-To: <20200123162918.b3jbed7tbvr2sf2p@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 23 Jan 2020 12:09:04 -0500
Message-ID: <CAHC9VhTusiQoudB8G5jjDFyM9WxBUAjZ6_X35ywJ063Jb75dQA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling
 the audit daemon
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 11:29 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-01-22 16:28, Paul Moore wrote:
> > On Tue, Dec 31, 2019 at 2:50 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >
> > > Add audit container identifier support to the action of signalling the
> > > audit daemon.
> > >
> > > Since this would need to add an element to the audit_sig_info struct,
> > > a new record type AUDIT_SIGNAL_INFO2 was created with a new
> > > audit_sig_info2 struct.  Corresponding support is required in the
> > > userspace code to reflect the new record request and reply type.
> > > An older userspace won't break since it won't know to request this
> > > record type.
> > >
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > >  include/linux/audit.h       |  7 +++++++
> > >  include/uapi/linux/audit.h  |  1 +
> > >  kernel/audit.c              | 35 +++++++++++++++++++++++++++++++++++
> > >  kernel/audit.h              |  1 +
> > >  security/selinux/nlmsgtab.c |  1 +
> > >  5 files changed, 45 insertions(+)
> >
> > ...
> >
> > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > index 0871c3e5d6df..51159c94041c 100644
> > > --- a/kernel/audit.c
> > > +++ b/kernel/audit.c
> > > @@ -126,6 +126,14 @@ struct auditd_connection {
> > >  kuid_t         audit_sig_uid = INVALID_UID;
> > >  pid_t          audit_sig_pid = -1;
> > >  u32            audit_sig_sid = 0;
> > > +/* Since the signal information is stored in the record buffer at the
> > > + * time of the signal, but not retrieved until later, there is a chance
> > > + * that the last process in the container could terminate before the
> > > + * signal record is delivered.  In this circumstance, there is a chance
> > > + * the orchestrator could reuse the audit container identifier, causing
> > > + * an overlap of audit records that refer to the same audit container
> > > + * identifier, but a different container instance.  */
> > > +u64            audit_sig_cid = AUDIT_CID_UNSET;
> >
> > I believe we could prevent the case mentioned above by taking an
> > additional reference to the audit container ID object when the signal
> > information is collected, dropping it only after the signal
> > information is collected by userspace or another process signals the
> > audit daemon.  Yes, it would block that audit container ID from being
> > reused immediately, but since we are talking about one number out of
> > 2^64 that seems like a reasonable tradeoff.
>
> I had thought that through and should have been more explicit about that
> situation when I documented it.  We could do that, but then the syscall
> records would be connected with the call from auditd on shutdown to
> request that signal information, rather than the exit of that last
> process that was using that container.  This strikes me as misleading.
> Is that really what we want?

 ???

I think one of us is not understanding the other; maybe it's me, maybe
it's you, maybe it's both of us.

Anyway, here is what I was trying to convey with my original comment
... When we record the audit container ID in audit_signal_info() we
take an extra reference to the audit container ID object so that it
will not disappear (and get reused) until after we respond with an
AUDIT_SIGNAL_INFO2.  In audit_receive_msg() when we do the
AUDIT_SIGNAL_INFO2 processing we drop the extra reference we took in
audit_signal_info().  Unless I'm missing some other change you made,
this *shouldn't* affect the syscall records, all it does is preserve
the audit container ID object in the kernel's ACID store so it doesn't
get reused.

(We do need to do some extra housekeeping in audit_signal_info() to
deal with the case where nobody asks for AUDIT_SIGNAL_INFO2 -
basically if audit_sig_cid is not NULL we should drop a reference
before assigning it a new object pointer, and of course we would need
to set audit_sig_cid to NULL in audit_receive_msg() after sending it
up to userspace and dropping the extra ref.)

-- 
paul moore
www.paul-moore.com
