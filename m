Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91C5BF52E4
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 18:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbfKHRtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 12:49:39 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39206 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730722AbfKHRti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 12:49:38 -0500
Received: by mail-lj1-f195.google.com with SMTP id p18so7115242ljc.6
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 09:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UVAbz2qNISBamKJ8aYyWKPdYYFUtEofFZoGab/xVx6Q=;
        b=jVdpzmol350RlxFDs+MLHaRNphUMUP4OvQ5IAPmY8hbKQPQsDF4LD+P6ahIMsJ6Rpl
         pUMnnGgEWZthCUvXmMqrer+tYk1QstqZ5L0VsSYXs5AIM8mttK7vKXNfkyoZk7SM78xu
         uJTmzg7POCfLqH9zCG0s8CXDWcSswJF62aIKCvOlPVqevsasjpkz/5ZlbLdOMn0zCJ2j
         C+dzIMZdnOFJ/mIbpTFmYjSGcDA/erk2dg8nzNoUV87zX7xBouMWtvkTjVmXM1YMpm38
         Yi5lTSuQ/2AQzOGEB52mqbr8QWFQ7v6EjkHjKgKiTdFpkCcRJpUQpeBRrW2MOz6NXS1x
         /4EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UVAbz2qNISBamKJ8aYyWKPdYYFUtEofFZoGab/xVx6Q=;
        b=AEXIxWY4GGBliqaA+ISCx9yM91KJ1dYhbTt0Ga91agjdaFm8luTpRyJDonf18DUQmg
         aiwVNd5gEELEIOmn2lNaZYn+Z4BZdxats2JAD7htj91eyjxT4Up9GD2299EVqiSL8oqz
         WVWjEruzhed6A4TswnYm+r86SnYvRxwMhDD2eq3qUAezDsXS04/vyWOQbGnmFEyzivoG
         0VzqaiHCbhmHOBhb7543bVpL8EuBCoV/BQwjHYA9RI+VwDxkasSnFIRrm2+RdSMPRpjJ
         xWyd6vy9GG7KLIz1YWK7Q7i9Amh+BUpZzU7rrfgccCig2nj/Ly8PXYJQrCMnnhp5G7sv
         ZFIQ==
X-Gm-Message-State: APjAAAWSDByRoKs2djKGcKMzZ2+LYEGxP19FtioCnaJJGP4tLA72gqiB
        5Vm6sVjRFmlyIvdt3YZ3KFf7wJvs4CI5qqvTrH+I
X-Google-Smtp-Source: APXvYqwXdfG4GypAr+j8sH3slLDDTCL7KQFTcRwsFnuUnnR/MbQkn3eAVhzXbnZTJXwiGsLyrFAGgJuGlFt1dlMpA3Q=
X-Received: by 2002:a2e:898d:: with SMTP id c13mr7895602lji.54.1573235374890;
 Fri, 08 Nov 2019 09:49:34 -0800 (PST)
MIME-Version: 1.0
References: <cover.1568834524.git.rgb@redhat.com> <230e91cd3e50a3d8015daac135c24c4c58cf0a21.1568834524.git.rgb@redhat.com>
 <20190927125142.GA25764@hmswarspite.think-freely.org> <CAHC9VhRbSUCB0OZorC4+y+5uJDR5uMXdRn2LOTYGu2gcFJSrcA@mail.gmail.com>
 <20191024212335.y4ou7g4tsxnotvnk@madcap2.tricolour.ca>
In-Reply-To: <20191024212335.y4ou7g4tsxnotvnk@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 8 Nov 2019 12:49:23 -0500
Message-ID: <CAHC9VhTrKVQNvTPoX5xdx-TUX_ukpMv2tNFFqLa2Njs17GuQMg@mail.gmail.com>
Subject: Re: [PATCH ghak90 V7 06/21] audit: contid limit of 32k imposed to
 avoid DoS
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 5:23 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2019-10-10 20:38, Paul Moore wrote:
> > On Fri, Sep 27, 2019 at 8:52 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> > > On Wed, Sep 18, 2019 at 09:22:23PM -0400, Richard Guy Briggs wrote:
> > > > Set an arbitrary limit on the number of audit container identifiers to
> > > > limit abuse.
> > > >
> > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > ---
> > > >  kernel/audit.c | 8 ++++++++
> > > >  kernel/audit.h | 4 ++++
> > > >  2 files changed, 12 insertions(+)
> > > >
> > > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > > index 53d13d638c63..329916534dd2 100644
> > > > --- a/kernel/audit.c
> > > > +++ b/kernel/audit.c
> >
> > ...
> >
> > > > @@ -2465,6 +2472,7 @@ int audit_set_contid(struct task_struct *task, u64 contid)
> > > >                               newcont->owner = current;
> > > >                               refcount_set(&newcont->refcount, 1);
> > > >                               list_add_rcu(&newcont->list, &audit_contid_hash[h]);
> > > > +                             audit_contid_count++;
> > > >                       } else {
> > > >                               rc = -ENOMEM;
> > > >                               goto conterror;
> > > > diff --git a/kernel/audit.h b/kernel/audit.h
> > > > index 162de8366b32..543f1334ba47 100644
> > > > --- a/kernel/audit.h
> > > > +++ b/kernel/audit.h
> > > > @@ -219,6 +219,10 @@ static inline int audit_hash_contid(u64 contid)
> > > >       return (contid & (AUDIT_CONTID_BUCKETS-1));
> > > >  }
> > > >
> > > > +extern int audit_contid_count;
> > > > +
> > > > +#define AUDIT_CONTID_COUNT   1 << 16
> > > > +
> > >
> > > Just to ask the question, since it wasn't clear in the changelog, what
> > > abuse are you avoiding here?  Ostensibly you should be able to create as
> > > many container ids as you have space for, and the simple creation of
> > > container ids doesn't seem like the resource strain I would be concerned
> > > about here, given that an orchestrator can still create as many
> > > containers as the system will otherwise allow, which will consume
> > > significantly more ram/disk/etc.
> >
> > I've got a similar question.  Up to this point in the patchset, there
> > is a potential issue of hash bucket chain lengths and traversing them
> > with a spinlock held, but it seems like we shouldn't be putting an
> > arbitrary limit on audit container IDs unless we have a good reason
> > for it.  If for some reason we do want to enforce a limit, it should
> > probably be a tunable value like a sysctl, or similar.
>
> Can you separate and clarify the concerns here?

"Why are you doing this?" is about as simple as I can pose the question.

> I plan to move this patch to the end of the patchset and make it
> optional, possibly adding a tuning mechanism.  Like the migration from
> /proc to netlink for loginuid/sessionid/contid/capcontid, this was Eric
> Biederman's concern and suggested mitigation.

Okay, let's just drop it.  I *really* don't like this approach of
tossing questionable stuff at the end of the patchset; I get why you
are doing it, but I think we really need to focus on keeping this
changeset small.  If the number of ACIDs (heh) become unwieldy the
right solution is to improve the algorithms/structures, if we can't do
that for some reason, *then* we can fall back to a limiting knob in a
latter release.

> As for the first issue of the bucket chain length traversal while
> holding the list spin-lock, would you prefer to use the rcu lock to
> traverse the list and then only hold the spin-lock when modifying the
> list, and possibly even make the spin-lock more fine-grained per list?

Until we have a better idea of how this is going to be used, I think
it's okay for now.  It's also internal to the kernel so we can change
it at any time.  My comments about the locking/structs was only to try
and think of some reason why one might want to limit the number of
ACIDs since neither you or Eric provided any reasoning that I could
see.

-- 
paul moore
www.paul-moore.com
