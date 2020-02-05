Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85D54153B69
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 23:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbgBEWvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 17:51:43 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42860 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727591AbgBEWvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 17:51:42 -0500
Received: by mail-ed1-f67.google.com with SMTP id e10so3832551edv.9
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 14:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KkJqADdzREDp4wpCa3aAuBXzYy2a7dWtxmQqACuBiLA=;
        b=tlFhwg7fuSsr9lDMyg/hJyhV9/r+SA/pNtn3GhTpEFeVNqw8D7oPmYV55YrajcvhPi
         6USVBo6kXicLmvv6Bg2Y0ha0tk2Nay7mXyPilZSuO9GsGXq5p9msM1TW1ThqpEKIk6TO
         4/OQyO/ulzcMerTQGaeD0VryqdPshEHuhKpG+unQcWhv6sPRbnKksfprLCn66VInLREd
         Je6wlsaG5QsXqkI7MrdKq8b444s9J9M4EeNMgElcAD+QNFZ/daBRaPIp/Nv+OU/SgL9L
         aTwx//Ff6J7OlQ/9BFdzCkZlg1MXq+nUXXnJiTXBCnSxNct/pUB8o87OQuSAcShpAQtW
         d60Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KkJqADdzREDp4wpCa3aAuBXzYy2a7dWtxmQqACuBiLA=;
        b=VIZEROp3tTTrCsNGoegd2MLR5MOrAm2J2BEqllsP+Ej35w7daOAIo9d0SrpbSxbZwz
         1yCWT0Qad1wDZWa7068nG0KxXuGNT/OurW060f7NuH0tjSOUgwGgJ4vilZ4nJUpqAOT8
         sQ1yjY7WHX56Y0ohttMkN0x2AmFZMyGF37wEK9tdiyUNczwZp1TX7/ltzL/AlIb4GMcI
         8mr03kSh0ULS1x1xGJmvJxJXFjhGAaIKTSlJuSTquQRfNwOKC/FvZKIS73lOu87tPKFl
         l8EqV/KROKNUKaJgLd5XgF39zZoiC53SPKPU/jYAd/TR9kMGyzt8fQKGQRMmb5LdrNAL
         stUA==
X-Gm-Message-State: APjAAAVlGR/BAQPR4kmW3S07eZEMBorN7VP9iLBArjn+SqiozO+E3U9o
        Quxzal9aGMlD4rFoqpTb8o1LXMH7FUATQvvIXANo
X-Google-Smtp-Source: APXvYqz2aK9JflWz0zHltcgH6zygcn9lbVHxrjU8/1oDrOSsvKKPYicMl7ZrYmjGxJ5ErI7H2IQMPuhpOBJ/wakZNE8=
X-Received: by 2002:a50:e108:: with SMTP id h8mr394067edl.196.1580943101124;
 Wed, 05 Feb 2020 14:51:41 -0800 (PST)
MIME-Version: 1.0
References: <cover.1577736799.git.rgb@redhat.com> <2954ed671a7622ddf3abdb8854dbba2ad13e9f33.1577736799.git.rgb@redhat.com>
 <CAHC9VhRw3Fj9-hi+Vj8JJb_GXM4B9N5hRXa9H6aQkuuFqJJ15w@mail.gmail.com> <20200204234258.uwaqk3s3c42fxews@madcap2.tricolour.ca>
In-Reply-To: <20200204234258.uwaqk3s3c42fxews@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 5 Feb 2020 17:51:30 -0500
Message-ID: <CAHC9VhT0NELsrEeTmX15GaZ1SE-qZiQmz9-WweRGWRPcGN5EmA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 11/16] audit: add support for containerid to
 network namespaces
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

On Tue, Feb 4, 2020 at 6:43 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-01-22 16:28, Paul Moore wrote:
> > On Tue, Dec 31, 2019 at 2:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >
> > > This also adds support to qualify NETFILTER_PKT records.
> > >
> > > Audit events could happen in a network namespace outside of a task
> > > context due to packets received from the net that trigger an auditing
> > > rule prior to being associated with a running task.  The network
> > > namespace could be in use by multiple containers by association to the
> > > tasks in that network namespace.  We still want a way to attribute
> > > these events to any potential containers.  Keep a list per network
> > > namespace to track these audit container identifiiers.
> > >
> > > Add/increment the audit container identifier on:
> > > - initial setting of the audit container identifier via /proc
> > > - clone/fork call that inherits an audit container identifier
> > > - unshare call that inherits an audit container identifier
> > > - setns call that inherits an audit container identifier
> > > Delete/decrement the audit container identifier on:
> > > - an inherited audit container identifier dropped when child set
> > > - process exit
> > > - unshare call that drops a net namespace
> > > - setns call that drops a net namespace
> > >
> > > Add audit container identifier auxiliary record(s) to NETFILTER_PKT
> > > event standalone records.  Iterate through all potential audit container
> > > identifiers associated with a network namespace.
> > >
> > > Please see the github audit kernel issue for contid net support:
> > >   https://github.com/linux-audit/audit-kernel/issues/92
> > > Please see the github audit testsuiite issue for the test case:
> > >   https://github.com/linux-audit/audit-testsuite/issues/64
> > > Please see the github audit wiki for the feature overview:
> > >   https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> > > ---
> > >  include/linux/audit.h    |  24 +++++++++
> > >  kernel/audit.c           | 132 ++++++++++++++++++++++++++++++++++++++++++++++-
> > >  kernel/nsproxy.c         |   4 ++
> > >  net/netfilter/nft_log.c  |  11 +++-
> > >  net/netfilter/xt_AUDIT.c |  11 +++-
> > >  5 files changed, 176 insertions(+), 6 deletions(-)
> >
> > ...
> >
> > > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > > index 5531d37a4226..ed8d5b74758d 100644
> > > --- a/include/linux/audit.h
> > > +++ b/include/linux/audit.h
> > > @@ -12,6 +12,7 @@
> > >  #include <linux/sched.h>
> > >  #include <linux/ptrace.h>
> > >  #include <uapi/linux/audit.h>
> > > +#include <linux/refcount.h>
> > >
> > >  #define AUDIT_INO_UNSET ((unsigned long)-1)
> > >  #define AUDIT_DEV_UNSET ((dev_t)-1)
> > > @@ -121,6 +122,13 @@ struct audit_task_info {
> > >
> > >  extern struct audit_task_info init_struct_audit;
> > >
> > > +struct audit_contobj_netns {
> > > +       struct list_head        list;
> > > +       u64                     id;
> >
> > Since we now track audit container IDs in their own structure, why not
> > link directly to the audit container ID object (and bump the
> > refcount)?
>
> Ok, I've done this but at first I had doubts about the complexity.

Yes, it will be more complex, but it should be much safer.

-- 
paul moore
www.paul-moore.com
