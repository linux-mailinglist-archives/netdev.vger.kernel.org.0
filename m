Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97C8A15CD8E
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 22:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728738AbgBMVtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 16:49:52 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40321 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728138AbgBMVtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 16:49:52 -0500
Received: by mail-ed1-f67.google.com with SMTP id p3so8701799edx.7
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 13:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CIr8PnObM5ymwiwL1EiMYkctE0asXfoeHqvExzLeSc4=;
        b=FqFjEPBAWPA+rQxGxDZQVc/+KDC775ecwL3/+FaBoa2038OKUe3oN6g8shGj/YRVtO
         kRm/wFg1uwYyzuvE14fQXQ/6hccJfwRgO3aVKboiJnszaYINoRpEp4EArtkScaku61pv
         QZ6TB6Ttwea8tpsUi/cKCopeKQgLK3GqQTdzhfnRTdTRXeGrihMjkHplbG+dbDWPPg8u
         EotRIFc6D/ah43gjEO73ItC+Y45grJMPIZ36X9aHuxaoapr80EM/gJKOUsD9kMnu1vJr
         YN+eSSyvvyTL2Fyf5YZg/7zFE2QFdGsBJ87am0k5EsyuLu8LGmzWJZqAFQG8z9n1hf0k
         nCnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CIr8PnObM5ymwiwL1EiMYkctE0asXfoeHqvExzLeSc4=;
        b=Z60wK+1Qb5JgJae4Z6+PLFu7RsWaNYPGHkLQaEG4gNnTWqsFAbkSfd194EcLBJUnBN
         wCNCTOWkZY+JTmG2dGQHaA4oV4jODk/GGqxsP/eGSqA59ixp2F5pRwt8686wCARSSKr1
         OrwoQzAvrpvxIL7Gkrp+38aNToQfKYxXSIe7FK4WzLPEZaxLJ4mEBFNdM/X3KQULXUYw
         ne1kNeib8VMdo7FTNRs6XTkuAiq3Fn/yZSwWxJ5vihVMdMPjJZcrbHjnHKVRjZgtGEJM
         Wo4rNOKygBDAYA9BdM0KShZH8nm6qhnHwawA6teGTPnnFri1BJsbFnC3h1PZ4GFmiurW
         iq3w==
X-Gm-Message-State: APjAAAVMoF0AggDp4RWM/InLR7AqQn0BXgDw4VnWpTs5AN5GOnXoKLic
        KR63/S6WccFn5l8dgemp/eyD1gCCRbIEkVkFDr8k
X-Google-Smtp-Source: APXvYqzSQm4JJnSM2NwbsgUln1Ol3jVku13aQhiI2KX5XKlMiqINrDBjs9ZRBvvzwBRwGvS0GSsKMYn/KfzBkhIn7o0=
X-Received: by 2002:a17:906:9352:: with SMTP id p18mr17616846ejw.95.1581630589598;
 Thu, 13 Feb 2020 13:49:49 -0800 (PST)
MIME-Version: 1.0
References: <cover.1577736799.git.rgb@redhat.com> <6452955c1e038227a5cd169f689f3fd3db27513f.1577736799.git.rgb@redhat.com>
 <CAHC9VhRkH=YEjAY6dJJHSp934grHnf=O4RiqLu3U8DzdVQOZkg@mail.gmail.com>
 <20200130192753.n7jjrshbhrczjzoe@madcap2.tricolour.ca> <CAHC9VhSVN3mNb5enhLR1hY+ekiAyiYWbehrwd_zN7kz13dF=1w@mail.gmail.com>
 <20200205235056.e5365xtgz7rbese2@madcap2.tricolour.ca>
In-Reply-To: <20200205235056.e5365xtgz7rbese2@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 13 Feb 2020 16:49:38 -0500
Message-ID: <CAHC9VhTM6MDHLcBfwJ_9DCroG0VA-meO770ihjn1sVy6=0JrHw@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 13/16] audit: track container nesting
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

On Wed, Feb 5, 2020 at 6:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-02-05 18:05, Paul Moore wrote:
> > On Thu, Jan 30, 2020 at 2:28 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2020-01-22 16:29, Paul Moore wrote:
> > > > On Tue, Dec 31, 2019 at 2:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > >
> > > > > Track the parent container of a container to be able to filter and
> > > > > report nesting.
> > > > >
> > > > > Now that we have a way to track and check the parent container of a
> > > > > container, modify the contid field format to be able to report that
> > > > > nesting using a carrat ("^") separator to indicate nesting.  The
> > > > > original field format was "contid=<contid>" for task-associated records
> > > > > and "contid=<contid>[,<contid>[...]]" for network-namespace-associated
> > > > > records.  The new field format is
> > > > > "contid=<contid>[^<contid>[...]][,<contid>[...]]".
> > > >
> > > > Let's make sure we always use a comma as a separator, even when
> > > > recording the parent information, for example:
> > > > "contid=<contid>[,^<contid>[...]][,<contid>[...]]"
> > >
> > > The intent here is to clearly indicate and separate nesting from
> > > parallel use of several containers by one netns.  If we do away with
> > > that distinction, then we lose that inheritance accountability and
> > > should really run the list through a "uniq" function to remove the
> > > produced redundancies.  This clear inheritance is something Steve was
> > > looking for since tracking down individual events/records to show that
> > > inheritance was not aways feasible due to rolled logs or search effort.
> >
> > Perhaps my example wasn't clear.  I'm not opposed to the little
> > carat/hat character indicating a container's parent, I just think it
> > would be good to also include a comma *in*addition* to the carat/hat.
>
> Ah, ok.  Well, I'd offer that it would be slightly shorter, slightly
> less cluttered and having already written the parser in userspace, I
> think the parser would be slightly simpler.
>
> I must admit, I was a bit puzzled by your snippet of code that was used
> as a prefix to the next item rather than as a postfix to the given item.
>
> Can you say why you prefer the comma in addition?

Generally speaking, I believe that a single delimiter is both easier
for the eyes to parse, and easier/safer for machines to parse as well.
In this particular case I think of the comma as a delimiter and the
carat as a modifier, reusing the carat as a delimiter seems like a bad
idea to me.

> > > > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > > > index ef8e07524c46..68be59d1a89b 100644
> > > > > --- a/kernel/audit.c
> > > > > +++ b/kernel/audit.c
> > > >
> > > > > @@ -492,6 +493,7 @@ void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
> > > > >                 audit_netns_contid_add(new->net_ns, contid);
> > > > >  }
> > > > >
> > > > > +void audit_log_contid(struct audit_buffer *ab, u64 contid);
> > > >
> > > > If we need a forward declaration, might as well just move it up near
> > > > the top of the file with the rest of the declarations.
> > >
> > > Ok.
> > >
> > > > > +void audit_log_contid(struct audit_buffer *ab, u64 contid)
> > > > > +{
> > > > > +       struct audit_contobj *cont = NULL, *prcont = NULL;
> > > > > +       int h;
> > > >
> > > > It seems safer to pass the audit container ID object and not the u64.
> > >
> > > It would also be faster, but in some places it isn't available such as
> > > for ptrace and signal targets.  This also links back to the drop record
> > > refcounts to hold onto the contobj until process exit, or signal
> > > delivery.
> > >
> > > What we could do is to supply two potential parameters, a contobj and/or
> > > a contid, and have it use the contobj if it is valid, otherwise, use the
> > > contid, as is done for names and paths supplied to audit_log_name().
> >
> > Let's not do multiple parameters, that begs for misuse, let's take the
> > wrapper function route:
> >
> >  func a(int id) {
> >    // important stuff
> >  }
> >
> >  func ao(struct obj) {
> >    a(obj.id);
> >  }
> >
> > ... and we can add a comment that you *really* should be using the
> > variant that passes an object.
>
> I was already doing that where it available, and dereferencing the id
> for the call.  But I see an advantage to having both parameters supplied
> to the function, since it saves us the trouble of dereferencing it,
> searching for the id in the hash list and re-locating the object if the
> object is already available.

I strongly prefer we not do multiple parameters for the same "thing";
I would much rather do the wrapper approach as described above.  I
would also like to see us use the audit container ID object as much as
possible, using a bare integer should be a last resort.

-- 
paul moore
www.paul-moore.com
