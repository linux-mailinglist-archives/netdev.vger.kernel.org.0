Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBC602FBF2
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 15:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfE3NIT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 30 May 2019 09:08:19 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45001 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfE3NIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 09:08:18 -0400
Received: by mail-oi1-f193.google.com with SMTP id z65so4840079oia.11
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 06:08:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qS3Q/hz5cO93oEIRYjaW7Sr8hav+cFNgiudkzNoMj8w=;
        b=dxt4N3hFsd4lE8a6hEjavRPxCbjG/FHC86k2oWFfOtrOJuC+SAl8uv8CqOeY03nNgk
         OafajFNZtnosS0DN049kP2c1H8zl4DPQoECVpB8TINKQt6iRr7cJJDQytXBBXDR7UcNB
         +6Gh+QOBWdYP12pqgp4bElujFFm6pOx8P8caApVDy8QJVwfGLP4KUmn54X4wY0D+9EcX
         1yicJLOC05YcfYY/9zuKvErBqkNeVJSXuteJAdNaHA1agAi5t37Eu8dIthGQNj1hN4Sw
         nSaLnPWuosymDDwGq8k+a/mldkTe4gTUzFneGaW9igXc8585q6r9qGOrY0FV6NGj4M+u
         5m0A==
X-Gm-Message-State: APjAAAW7u6Dc/zrdGdn1FBcyh9Q0VewqPcJecVdUgw8pqt+GehJ4diDU
        GKbarLtWEtJ9+od2aoobMOVZtIZ8K4ktG6IIiKPdcw==
X-Google-Smtp-Source: APXvYqxRNQdu8FXZJDPynHtWRxoDcqnlrWbPcgP874hkqSkQlayP5hnOUfRLSzP0TLiIV+sPYeCjXTJG6BZ8bL0SPWw=
X-Received: by 2002:aca:300d:: with SMTP id w13mr2391467oiw.26.1559221697952;
 Thu, 30 May 2019 06:08:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <f4a49f7c949e5df80c339a3fe5c4c2303b12bf23.1554732921.git.rgb@redhat.com>
 <CAHC9VhRfQp-avV2rcEOvLCAXEz-MDZMp91UxU+BtvPkvWny9fQ@mail.gmail.com>
In-Reply-To: <CAHC9VhRfQp-avV2rcEOvLCAXEz-MDZMp91UxU+BtvPkvWny9fQ@mail.gmail.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Thu, 30 May 2019 15:08:07 +0200
Message-ID: <CAFqZXNsK6M_L_0dFzkEgh_QVP-fyb+fE0MMRsJ2kXxtKM3VUKA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 04/10] audit: log container info of syscalls
To:     Paul Moore <paul@paul-moore.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Steve Grubb <sgrubb@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Simo Sorce <simo@redhat.com>,
        Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Neil Horman <nhorman@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 12:16 AM Paul Moore <paul@paul-moore.com> wrote:
> On Mon, Apr 8, 2019 at 11:40 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >
> > Create a new audit record AUDIT_CONTAINER_ID to document the audit
> > container identifier of a process if it is present.
> >
> > Called from audit_log_exit(), syscalls are covered.
> >
> > A sample raw event:
> > type=SYSCALL msg=audit(1519924845.499:257): arch=c000003e syscall=257 success=yes exit=3 a0=ffffff9c a1=56374e1cef30 a2=241 a3=1b6 items=2 ppid=606 pid=635 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=3 comm="bash" exe="/usr/bin/bash" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key="tmpcontainerid"
> > type=CWD msg=audit(1519924845.499:257): cwd="/root"
> > type=PATH msg=audit(1519924845.499:257): item=0 name="/tmp/" inode=13863 dev=00:27 mode=041777 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:tmp_t:s0 nametype= PARENT cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0
> > type=PATH msg=audit(1519924845.499:257): item=1 name="/tmp/tmpcontainerid" inode=17729 dev=00:27 mode=0100644 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:user_tmp_t:s0 nametype=CREATE cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0
> > type=PROCTITLE msg=audit(1519924845.499:257): proctitle=62617368002D6300736C65657020313B206563686F2074657374203E202F746D702F746D70636F6E7461696E65726964
> > type=CONTAINER_ID msg=audit(1519924845.499:257): contid=123458
> >
> > Please see the github audit kernel issue for the main feature:
> >   https://github.com/linux-audit/audit-kernel/issues/90
> > Please see the github audit userspace issue for supporting additions:
> >   https://github.com/linux-audit/audit-userspace/issues/51
> > Please see the github audit testsuiite issue for the test case:
> >   https://github.com/linux-audit/audit-testsuite/issues/64
> > Please see the github audit wiki for the feature overview:
> >   https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > Acked-by: Serge Hallyn <serge@hallyn.com>
> > Acked-by: Steve Grubb <sgrubb@redhat.com>
> > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> > ---
> >  include/linux/audit.h      |  5 +++++
> >  include/uapi/linux/audit.h |  1 +
> >  kernel/audit.c             | 20 ++++++++++++++++++++
> >  kernel/auditsc.c           | 20 ++++++++++++++------
> >  4 files changed, 40 insertions(+), 6 deletions(-)
>
> ...
>
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 182b0f2c183d..3e0af53f3c4d 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -2127,6 +2127,26 @@ void audit_log_session_info(struct audit_buffer *ab)
> >         audit_log_format(ab, "auid=%u ses=%u", auid, sessionid);
> >  }
> >
> > +/*
> > + * audit_log_contid - report container info
> > + * @context: task or local context for record
> > + * @contid: container ID to report
> > + */
> > +void audit_log_contid(struct audit_context *context, u64 contid)
> > +{
> > +       struct audit_buffer *ab;
> > +
> > +       if (!audit_contid_valid(contid))
> > +               return;
> > +       /* Generate AUDIT_CONTAINER_ID record with container ID */
> > +       ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER_ID);
> > +       if (!ab)
> > +               return;
> > +       audit_log_format(ab, "contid=%llu", (unsigned long long)contid);
>
> We have a consistency problem regarding how to output the u64 contid
> values; this function uses an explicit cast, others do not.  According
> to Documentation/core-api/printk-formats.rst the recommendation for
> u64 is %llu (or %llx, if you want hex).  Looking quickly through the
> printk code this appears to still be correct.  I suggest we get rid of
> the cast (like it was in v5).

IIRC it was me who suggested to add the casts. I didn't realize that
the kernel actually guarantees that "%llu" will always work with u64.
Taking that into account I rescind my request to add the cast. Sorry
for the false alarm.

>
> > +       audit_log_end(ab);
> > +}
> > +EXPORT_SYMBOL(audit_log_contid);
>
> --
> paul moore
> www.paul-moore.com

--
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.
