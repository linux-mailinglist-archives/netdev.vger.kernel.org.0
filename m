Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46A176B136
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 23:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387928AbfGPVjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 17:39:33 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37946 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730444AbfGPVjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 17:39:33 -0400
Received: by mail-lf1-f66.google.com with SMTP id h28so14805599lfj.5
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 14:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UEoPNCG4kcJsbXvvedTVI/oUGPgfgDGC69R8YkpN0Ls=;
        b=E/8ikrwAfufbeGPzCfXxpn5EWxAfgLdy6LHVoRbFXYE9RhSrT+fCW/Ym0WBFnLVgpW
         6eknLnGyCQrub7C+oH2iB/3f89aqw/gEyuWoo9sMXXD1lgoKI/evg2UIhXk69H2wbB8W
         gBxoGQuij1gb1iyR95rQw/C8tqo7SbwCJcSPs2g6BA53k9qfo3IoqUoApxcsPMMsLYs+
         fbB5qmrjBhLFCO4IrMKKA++ei7tfjIrtjqwlLB9q9YGyuC3urVN/8I/CF1zxnWHvLmkT
         JHSkdhSFe+zled5GOpaKiAju6oSKwU0EPnFIWV879EhYNYZt26KZKzjjM+atv4cMxtPQ
         ZcJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UEoPNCG4kcJsbXvvedTVI/oUGPgfgDGC69R8YkpN0Ls=;
        b=QYyX9O8dSv0jQVdXrazKj/lHTkvceLSkoydkB57I0Eqctvrf88b6idHKUyidIQyzd+
         CiCpyVtOCVvYyp777ouxnDc3BuGkNXz/WInOMRSGF/d8lwh1/KvZgALaOCqN6b8PpG35
         nzSFSWG8UwM5dWrrsoDKIW/Qwxo/33uQaITmUpXQ6jao1vn8XIFNzAXs9eJqwbzMq8Yx
         HAtDghZtjpASjzBEuydukLG3NcaOZhP6GyLi1QeGu/BqT2KmYD/C+Ku0Pz3PQx2ecTaZ
         lcl4aclVzA/tVdD8B0d4MLNDBD+ZfLXHUMnFGlCbKvHq7mfBGVoLnkiiaZPAUSkGwR0E
         ZSzQ==
X-Gm-Message-State: APjAAAW/vEin0TMVU4NUnuDANkVZ0s6ECNf9znDoryDa5DBgTJ79xAgN
        SLaJaaebFilkjkmsUREEO/tb0veS5N6zzYNmpQ==
X-Google-Smtp-Source: APXvYqxVWwwG619v+YKQRDGT+YX+qm23m31n4KUpCUeLscpXJaA+UAUtNCEiDZTilTsw6kcSugeGwveeG28ePWlfYQw=
X-Received: by 2002:a19:8093:: with SMTP id b141mr16328818lfd.137.1563313170619;
 Tue, 16 Jul 2019 14:39:30 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <9edad39c40671fb53f28d76862304cc2647029c6.1554732921.git.rgb@redhat.com>
 <20190529145742.GA8959@cisco> <CAHC9VhR4fudQanvZGYWMvCf7k2CU3q7e7n1Pi7hzC3v_zpVEdw@mail.gmail.com>
 <20190708175105.7zb6mikjw2wmnwln@madcap2.tricolour.ca> <CAHC9VhRFeCFSCn=m6wgDK2tXBN1euc2+bw8o=CfNwptk8t=j7A@mail.gmail.com>
 <20190716193828.xvm67iv5jyypvvxp@madcap2.tricolour.ca>
In-Reply-To: <20190716193828.xvm67iv5jyypvvxp@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 16 Jul 2019 17:39:19 -0400
Message-ID: <CAHC9VhTFW44gMMey8NnJzAeVxObwKhTgXcnt09q-7DtkFUiMCA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Tycho Andersen <tycho@tycho.ws>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 3:38 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2019-07-15 16:38, Paul Moore wrote:
> > On Mon, Jul 8, 2019 at 1:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2019-05-29 11:29, Paul Moore wrote:
> >
> > ...
> >
> > > > The idea is that only container orchestrators should be able to
> > > > set/modify the audit container ID, and since setting the audit
> > > > container ID can have a significant effect on the records captured
> > > > (and their routing to multiple daemons when we get there) modifying
> > > > the audit container ID is akin to modifying the audit configuration
> > > > which is why it is gated by CAP_AUDIT_CONTROL.  The current thinking
> > > > is that you would only change the audit container ID from one
> > > > set/inherited value to another if you were nesting containers, in
> > > > which case the nested container orchestrator would need to be granted
> > > > CAP_AUDIT_CONTROL (which everyone to date seems to agree is a workable
> > > > compromise).  We did consider allowing for a chain of nested audit
> > > > container IDs, but the implications of doing so are significant
> > > > (implementation mess, runtime cost, etc.) so we are leaving that out
> > > > of this effort.
> > >
> > > We had previously discussed the idea of restricting
> > > orchestrators/engines from only being able to set the audit container
> > > identifier on their own descendants, but it was discarded.  I've added a
> > > check to ensure this is now enforced.
> >
> > When we weren't allowing nested orchestrators it wasn't necessary, but
> > with the move to support nesting I believe this will be a requirement.
> > We might also need/want to restrict audit container ID changes if a
> > descendant is acting as a container orchestrator and managing one or
> > more audit container IDs; although I'm less certain of the need for
> > this.
>
> I was of the opinion it was necessary before with single-layer parallel
> orchestrators/engines.

One of the many things we've disagreed on, but it doesn't really
matter at this point.

> > > I've also added a check to ensure that a process can't set its own audit
> > > container identifier ...
> >
> > What does this protect against, or what problem does this solve?
> > Considering how easy it is to fork/exec, it seems like this could be
> > trivially bypassed.
>
> Well, for starters, it would remove one layer of nesting.  It would
> separate the functional layers of processes.

This doesn't seem like something we need to protect against, what's
the harm?  My opinion at this point is that we should only add
restrictions to protect against problematic or dangerous situations; I
don't believe one extra layer of nesting counts as either.

Perhaps the container folks on the To/CC line can comment on this?  If
there is a valid reason for this restriction, great, let's do it,
otherwise it seems like an unnecessary hard coded policy to me.

> Other than that, it seems
> like a gut feeling that it is just wrong to allow it.  It seems like a
> layer violation that one container orchestrator/engine could set its own
> audit container identifier and then set its children as well.  It would
> be its own parent.

I suspect you are right that the current crop of container engines
won't do this, but who knows what we'll be doing with "containers" 5,
or even 10, years from now.  With that in mind, let me ask the
question again: is allowing an orchestrator the ability to set its own
audit container ID problematic and/or dangerous?

> It would make it harder to verify adherance to descendancy and inheritance rules.

The audit log should contain all the information needed to track that,
right?  If it doesn't, then I think we have a problem with the
information we are logging.  Right?

> > > ... and that if the identifier is already set, then the
> > > orchestrator/engine must be in a descendant user namespace from the
> > > orchestrator that set the previously inherited audit container
> > > identifier.
> >
> > You lost me here ... although I don't like the idea of relying on X
> > namespace inheritance for a hard coded policy on setting the audit
> > container ID; we've worked hard to keep this independent of any
> > definition of a "container" and it would sadden me greatly if we had
> > to go back on that.
>
> This would seem to be the one concession I'm reluctantly making to try
> to solve this nested container orchestrator/engine challenge.

As I said, you lost me on this - how does this help?  A more detailed
explanation of how this helps resolve the nesting problem would be
useful.

> Would backing off on that descendant user namespace requirement and only
> require that a nested audit container identifier only be permitted on a
> descendant task be sufficient?  It may for this use case, but I suspect
> not for additional audit daemons (we're not there yet) and message
> routing to those daemons.
>
> The one difference here is that it does not depend on this if the audit
> container identifier has not already been set.

-- 
paul moore
www.paul-moore.com
