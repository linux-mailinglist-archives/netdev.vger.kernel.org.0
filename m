Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17FA1146E76
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 17:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgAWQ3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 11:29:51 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48072 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728998AbgAWQ3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 11:29:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579796989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N4iGmEv+O+D46staOSzOI6kwETvpx6pYrLK3YZYNIsU=;
        b=cgGne5GxipwELNVexvqoRr3cs8bsANBpDidM8aeWFTOnoa+MXuex1uNFOVYaEwjfMHuPGc
        BENnu6LZEA2q87iHFx6rRxzs5G/PgTOLPTYssUgW0E/V83agCo+6aXDuNcNvHlEkvD+dRX
        C4pDVZJCM0RQY4mLvigtJv48iQ3jJHs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-diEMvO8mOZKZ-4-2FGH2sg-1; Thu, 23 Jan 2020 11:29:47 -0500
X-MC-Unique: diEMvO8mOZKZ-4-2FGH2sg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD965CF9BF;
        Thu, 23 Jan 2020 16:29:42 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-12.phx2.redhat.com [10.3.112.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A6D95DA60;
        Thu, 23 Jan 2020 16:29:20 +0000 (UTC)
Date:   Thu, 23 Jan 2020 11:29:18 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling
 the audit daemon
Message-ID: <20200123162918.b3jbed7tbvr2sf2p@madcap2.tricolour.ca>
References: <cover.1577736799.git.rgb@redhat.com>
 <7d7933d742fdf4a94c84b791906a450b16f2e81f.1577736799.git.rgb@redhat.com>
 <CAHC9VhSuwJGryfrBfzxG01zwb-O_7dbjS0x0a3w-XjcNuYSAcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSuwJGryfrBfzxG01zwb-O_7dbjS0x0a3w-XjcNuYSAcg@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-22 16:28, Paul Moore wrote:
> On Tue, Dec 31, 2019 at 2:50 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >
> > Add audit container identifier support to the action of signalling the
> > audit daemon.
> >
> > Since this would need to add an element to the audit_sig_info struct,
> > a new record type AUDIT_SIGNAL_INFO2 was created with a new
> > audit_sig_info2 struct.  Corresponding support is required in the
> > userspace code to reflect the new record request and reply type.
> > An older userspace won't break since it won't know to request this
> > record type.
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  include/linux/audit.h       |  7 +++++++
> >  include/uapi/linux/audit.h  |  1 +
> >  kernel/audit.c              | 35 +++++++++++++++++++++++++++++++++++
> >  kernel/audit.h              |  1 +
> >  security/selinux/nlmsgtab.c |  1 +
> >  5 files changed, 45 insertions(+)
> 
> ...
> 
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 0871c3e5d6df..51159c94041c 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -126,6 +126,14 @@ struct auditd_connection {
> >  kuid_t         audit_sig_uid = INVALID_UID;
> >  pid_t          audit_sig_pid = -1;
> >  u32            audit_sig_sid = 0;
> > +/* Since the signal information is stored in the record buffer at the
> > + * time of the signal, but not retrieved until later, there is a chance
> > + * that the last process in the container could terminate before the
> > + * signal record is delivered.  In this circumstance, there is a chance
> > + * the orchestrator could reuse the audit container identifier, causing
> > + * an overlap of audit records that refer to the same audit container
> > + * identifier, but a different container instance.  */
> > +u64            audit_sig_cid = AUDIT_CID_UNSET;
> 
> I believe we could prevent the case mentioned above by taking an
> additional reference to the audit container ID object when the signal
> information is collected, dropping it only after the signal
> information is collected by userspace or another process signals the
> audit daemon.  Yes, it would block that audit container ID from being
> reused immediately, but since we are talking about one number out of
> 2^64 that seems like a reasonable tradeoff.

I had thought that through and should have been more explicit about that
situation when I documented it.  We could do that, but then the syscall
records would be connected with the call from auditd on shutdown to
request that signal information, rather than the exit of that last
process that was using that container.  This strikes me as misleading.
Is that really what we want?

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

