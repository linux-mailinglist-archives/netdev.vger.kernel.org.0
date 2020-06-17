Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297F61FD751
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 23:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgFQVd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 17:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbgFQVd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 17:33:28 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59379C0613EF
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 14:33:26 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id l12so4160017ejn.10
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 14:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=082ZDcJ58JiAJ5FQwZhCB4u9ixr0nyVZnt4fYABIR84=;
        b=TfwM4lavAZ4qLtd5wq6rQlVNKfmuRYQ43amsKkYVgFT+8SBxWmO9x5wsvBq940XKAg
         b7y6FNbnpN7VONhX+pNMmIsdCJV2FjiC9n3+Wds9hgiE4ZfZvYN7TCSi+l1RKQMVjc4H
         VTqR6pGcGhx/snMwZMlMlSTbYX/5tZcXbYQ2svqAQstq6/l7ixnZwU+LOMkPqqWbKemq
         DE2g2KY2Nej+5bcYigqtEWd1ECLF3ZomjpGrAbXdruDnwjJ6vnXStdMOI4InbA3xCd2M
         rE6umaqSA2gnDeoaV49w5DHVs/9DQHlZzxQYa0C0nK3iaVkh/+O/v2Rk4uIEfXXD7JS4
         YtMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=082ZDcJ58JiAJ5FQwZhCB4u9ixr0nyVZnt4fYABIR84=;
        b=ukZWgzIf4T6D6P5iErvf29+6WMRSY/UphWMuWOMsGYLxH9duDcfSJOYX8O7zf1Ze+W
         rASpcg59hfZy2rRpu+A+zNGHpwsHGJc5+1kQdUNpQZjrcinDT8k6/jo2+JTUd6gqpfO9
         4bCUxXwDFjC5MXwCO6KXw5CJH/qr2JBLTiFeSuFnYCGyu4imH/A44HiWpKksJCrXx6Xv
         uuRWpdoyk5ftyBSqpfYbNUH45nP0uWl/oa2DvIslWxVJpvyQw3/CdWp2SC07DrsDulM2
         GPzlpPzIlJJJL5Usg7yGPZE61CbLp1Uk4uunIGwnHlBxoNTQQm9O/aw8W3F4PdTHx04r
         +mig==
X-Gm-Message-State: AOAM530pDnikd9FkPySE9ByPCpqyql8AP5i7Gm8Zk0dMYoYR7Iy6GFS2
        Xb7i07od4Qrztlj1u0SShMDGv/MzzZ6C+ZzssbNL
X-Google-Smtp-Source: ABdhPJwGl2Yew0IZrhIcRIB+PA6D6jtLPBcAXq287JWVLoatXUiRC+F29j9ZkG+eUUYXUmHK2aSjHOoPf26wthrPENk=
X-Received: by 2002:a17:906:434f:: with SMTP id z15mr1080529ejm.178.1592429604473;
 Wed, 17 Jun 2020 14:33:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200330134705.jlrkoiqpgjh3rvoh@madcap2.tricolour.ca>
 <CAHC9VhQTsEMcYAF1CSHrrVn07DR450W9j6sFVfKAQZ0VpheOfw@mail.gmail.com>
 <20200330162156.mzh2tsnovngudlx2@madcap2.tricolour.ca> <CAHC9VhTRzZXJ6yUFL+xZWHNWZFTyiizBK12ntrcSwmgmySbkWw@mail.gmail.com>
 <20200330174937.xalrsiev7q3yxsx2@madcap2.tricolour.ca> <CAHC9VhR_bKSHDn2WAUgkquu+COwZUanc0RV3GRjMDvpoJ5krjQ@mail.gmail.com>
 <871ronf9x2.fsf@x220.int.ebiederm.org> <CAHC9VhR3gbmj5+5MY-whLtStKqDEHgvMRigU9hW0X1kpxF91ag@mail.gmail.com>
 <871rol7nw3.fsf@x220.int.ebiederm.org> <CAHC9VhQvhja=vUEbT3uJgQqpj-480HZzWV7b5oc2GWtzFN1qJw@mail.gmail.com>
 <20200608180330.z23hohfa2nclhxf5@madcap2.tricolour.ca>
In-Reply-To: <20200608180330.z23hohfa2nclhxf5@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 17 Jun 2020 17:33:13 -0400
Message-ID: <CAHC9VhQExpNcK-7H+tZg5ouCVts=YmnNiXrgk-ZYenj_zrr1GQ@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling
 the audit daemon
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>, nhorman@tuxdriver.com,
        linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        linux-audit@redhat.com, netfilter-devel@vger.kernel.org,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 8, 2020 at 2:04 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-04-22 13:24, Paul Moore wrote:
> > On Fri, Apr 17, 2020 at 6:26 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> > > Paul Moore <paul@paul-moore.com> writes:
> > > > On Thu, Apr 16, 2020 at 4:36 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> > > >> Paul Moore <paul@paul-moore.com> writes:
> > > >> > On Mon, Mar 30, 2020 at 1:49 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > >> >> On 2020-03-30 13:34, Paul Moore wrote:
> > > >> >> > On Mon, Mar 30, 2020 at 12:22 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > >> >> > > On 2020-03-30 10:26, Paul Moore wrote:
> > > >> >> > > > On Mon, Mar 30, 2020 at 9:47 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > >> >> > > > > On 2020-03-28 23:11, Paul Moore wrote:
> > > >> >> > > > > > On Tue, Mar 24, 2020 at 5:02 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > >> >> > > > > > > On 2020-03-23 20:16, Paul Moore wrote:
> > > >> >> > > > > > > > On Thu, Mar 19, 2020 at 6:03 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > >> >> > > > > > > > > On 2020-03-18 18:06, Paul Moore wrote:
> > > >> >
> > > >> > ...
> > > >> >
> > > >> >> > > Well, every time a record gets generated, *any* record gets generated,
> > > >> >> > > we'll need to check for which audit daemons this record is in scope and
> > > >> >> > > generate a different one for each depending on the content and whether
> > > >> >> > > or not the content is influenced by the scope.
> > > >> >> >
> > > >> >> > That's the problem right there - we don't want to have to generate a
> > > >> >> > unique record for *each* auditd on *every* record.  That is a recipe
> > > >> >> > for disaster.
> > > >> >> >
> > > >> >> > Solving this for all of the known audit records is not something we
> > > >> >> > need to worry about in depth at the moment (although giving it some
> > > >> >> > casual thought is not a bad thing), but solving this for the audit
> > > >> >> > container ID information *is* something we need to worry about right
> > > >> >> > now.
> > > >> >>
> > > >> >> If you think that a different nested contid value string per daemon is
> > > >> >> not acceptable, then we are back to issuing a record that has only *one*
> > > >> >> contid listed without any nesting information.  This brings us back to
> > > >> >> the original problem of keeping *all* audit log history since the boot
> > > >> >> of the machine to be able to track the nesting of any particular contid.
> > > >> >
> > > >> > I'm not ruling anything out, except for the "let's just completely
> > > >> > regenerate every record for each auditd instance".
> > > >>
> > > >> Paul I am a bit confused about what you are referring to when you say
> > > >> regenerate every record.
> > > >>
> > > >> Are you saying that you don't want to repeat the sequence:
> > > >>         audit_log_start(...);
> > > >>         audit_log_format(...);
> > > >>         audit_log_end(...);
> > > >> for every nested audit daemon?
> > > >
> > > > If it can be avoided yes.  Audit performance is already not-awesome,
> > > > this would make it even worse.
> > >
> > > As far as I can see not repeating sequences like that is fundamental
> > > for making this work at all.  Just because only the audit subsystem
> > > should know about one or multiple audit daemons.  Nothing else should
> > > care.
> >
> > Yes, exactly, this has been mentioned in the past.  Both the
> > performance hit and the code complication in the caller are things we
> > must avoid.
> >
> > > >> Or are you saying that you would like to literraly want to send the same
> > > >> skb to each of the nested audit daemons?
> > > >
> > > > Ideally we would reuse the generated audit messages as much as
> > > > possible.  Less work is better.  That's really my main concern here,
> > > > let's make sure we aren't going to totally tank performance when we
> > > > have a bunch of nested audit daemons.
> > >
> > > So I think there are two parts of this answer.  Assuming we are talking
> > > about nesting audit daemons in containers we will have different
> > > rulesets and I expect most of the events for a nested audit daemon won't
> > > be of interest to the outer audit daemon.
> >
> > Yes, this is another thing that Richard and I have discussed in the
> > past.  We will basically need to create per-daemon queues, rules,
> > tracking state, etc.; that is easy enough.  What will be slightly more
> > tricky is the part where we apply the filters to the individual
> > records and decide if that record is valid/desired for a given daemon.
> > I think it can be done without too much pain, and any changes to the
> > callers, but it will require a bit of work to make sure it is done
> > well and that records are needlessly duplicated in the kernel.
> >
> > > Beyond that it should be very straight forward to keep a pointer and
> > > leave the buffer as a scatter gather list until audit_log_end
> > > and translate pids, and rewrite ACIDs attributes in audit_log_end
> > > when we build the final packet.  Either through collaboration with
> > > audit_log_format or a special audit_log command that carefully sets
> > > up the handful of things that need that information.
> >
> > In order to maximize record re-use I think we will want to hold off on
> > assembling the final packet until it is sent to the daemons in the
> > kauditd thread.  We'll also likely need to create special
> > audit_log_XXX functions to capture fields which we know will need
> > translation, e.g. ACID information.  (the reason for the new
> > audit_log_XXX functions would be to mark the new sg element and ensure
> > the buffer is handled correctly)
> >
> > Regardless of the details, I think the scatter gather approach is the
> > key here - that seems like the best design idea I've seen thus far.
> > It enables us to replace portions of the record as needed ... and
> > possibly use the existing skb cow stuff ... it has been a while, but
> > does the skb cow functions handle scatter gather skbs or do they need
> > to be linear?
>
> How does the selection of this data management technique affect our
> choice of field format?

I'm not sure it affects the record string, but it might affect the
in-kernel API as we would likely want to have a special function for
logging the audit container ID that does the scatter-gather management
for the record.  There might also need to be some changes to how we
allocate the records.

However, since you're the one working on these patches I would expect
you to be the one to look into how this would work and what the
impacts might be to the code, record format, etc.

> Does this lock the field value to a fixed length?

I wouldn't think so.  In fact if it did it wouldn't really be a good solution.

Once again, this is something I would expect you to look into.

> Does the use of scatter/gather techniques or structures allow
> the use of different lengths of data for each destination (auditd)?

This is related to the above ... but yes, the reason why Eric and I
were discussing a scatter/gather approach is that it would presumably
allow one to break the single record string into pieces which could be
managed and manipulated much easier than the monolithic record string.

> I could see different target audit daemons triggering or switching to a
> different chunk of data and length.  This does raise a concern related
> to the previous sig_info2 discussion that the struct contobj that exists
> at the time of audit_log_exit called could have been reaped by the time
> the buffer is pulled from the queue for transmission to auditd, but we
> could hold a reference to it as is done for sig_info2.

Yes.

> Looking through the kernel scatter/gather possibilities, I see struct
> iovec which is used by the readv/writev/preadv/pwritev syscalls, but I'm
> understanding that this is a kernel implementation that will be not
> visible to user space.  So would the struct scatterlist be the right
> choice?

It has been so long since I've looked at the scatter-gather code that
I can't really say with any confidence at this point.  All I can say
is that the scatter-gather code really should just be an
implementation detail in the kernel and should not be visible to
userspace; userspace should get the same awful, improperly generated
netlink message it always has received from the kernel ;)

-- 
paul moore
www.paul-moore.com
