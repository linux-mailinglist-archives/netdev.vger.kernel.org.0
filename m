Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4EC5184CCA
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 17:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgCMQru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 12:47:50 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:46685 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgCMQru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 12:47:50 -0400
Received: by mail-ed1-f65.google.com with SMTP id ca19so12654221edb.13
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 09:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CgoM3beKoYI/5+BkvNF0e0zNF8rAhCT7BQOep064wDk=;
        b=LGYXmthHZQmVeL3ORXAKlyXPn1vaS3e9UjtSB+15SH4QeWbUDxHZTA0wy6LXXSzU/y
         AReDf/yNrW9KPOCuIFvFj8Lfr3Di/5qM1MMnxAfvmosg3+zMlQ0sG1h+tbIuzRJZnPGO
         swdDQJLr7xPNoDTfBhEVjMDfsrwKTQJV4bSWXD9bugamcRKUt7zf8ITOeN7sc3ZoTK9J
         32u0WLMxZ0xZ9QOW0Ub2cm8b85Yb1sMclPYCpKfHE8DO4V6pq5xMAVki0Yt1ISvmXyI7
         iokKMBnrf8sn27LHEqKQc/RQ9QkZnxS3FLoraxrwV596hqsYFM7i92OTGeE+0NDjlzoO
         dEow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CgoM3beKoYI/5+BkvNF0e0zNF8rAhCT7BQOep064wDk=;
        b=di1iZnqVE8Ge68txrY1iAK6wOilDiHzMl3VdVFWMXPGNZTo2ndgGvN17XoSyz190BW
         lEbTA+7smgkLjOryYQwpj3o/g2f73+ncHEQTuWO00GoM3T5uZgoA+kXVH7zh1qHWnLza
         3neaE0EwjQ7mDEK/VkAJNizsKnnF21Kjd8Bh74JHEmRL91eyZuUbgVfbGTQn+3x/3zlg
         mC46DDFbP5seWVGFNsDQZrivvktgQAzLDwv0j2gmFTwmVNulU074SUJVwVBri6Yfxn4/
         k8o6qWPqDv2/Km6zwkyQ2/NBX5gS4REesp/ahHx2OgZRwyu5wDgRS/KRu+UllabzrSca
         wZFw==
X-Gm-Message-State: ANhLgQ1Sh5mmYtuQ0iS6/dhQoZ9fH+6o741Odbx5hrwHrCiMzQSE4T/e
        R8m88fQDh/WZd+EPvNubgVindjAwzl2xsCoWotPZ
X-Google-Smtp-Source: ADFU+vs1EpKcsGEO9GGNfp34//T93kL6R9Gi6RqejfY1jY1yluK7L7lRWoiZjwp6ZdPwGaa0kzHD5f4noecjshH23Kg=
X-Received: by 2002:a17:907:271a:: with SMTP id w26mr130507ejk.271.1584118065825;
 Fri, 13 Mar 2020 09:47:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1577736799.git.rgb@redhat.com> <6452955c1e038227a5cd169f689f3fd3db27513f.1577736799.git.rgb@redhat.com>
 <CAHC9VhRkH=YEjAY6dJJHSp934grHnf=O4RiqLu3U8DzdVQOZkg@mail.gmail.com>
 <20200130192753.n7jjrshbhrczjzoe@madcap2.tricolour.ca> <CAHC9VhSVN3mNb5enhLR1hY+ekiAyiYWbehrwd_zN7kz13dF=1w@mail.gmail.com>
 <20200205235056.e5365xtgz7rbese2@madcap2.tricolour.ca> <CAHC9VhTM6MDHLcBfwJ_9DCroG0VA-meO770ihjn1sVy6=0JrHw@mail.gmail.com>
 <20200312205147.plxs4czjeuu4davj@madcap2.tricolour.ca>
In-Reply-To: <20200312205147.plxs4czjeuu4davj@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 13 Mar 2020 12:47:34 -0400
Message-ID: <CAHC9VhTqWdXMsbSbsWJzRRvVbSaaFBmnFFsVutM7XSx5NT_FJA@mail.gmail.com>
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

On Thu, Mar 12, 2020 at 4:52 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-02-13 16:49, Paul Moore wrote:
> > On Wed, Feb 5, 2020 at 6:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2020-02-05 18:05, Paul Moore wrote:
> > > > On Thu, Jan 30, 2020 at 2:28 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > On 2020-01-22 16:29, Paul Moore wrote:
> > > > > > On Tue, Dec 31, 2019 at 2:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > > >
> > > > > > > Track the parent container of a container to be able to filter and
> > > > > > > report nesting.
> > > > > > >
> > > > > > > Now that we have a way to track and check the parent container of a
> > > > > > > container, modify the contid field format to be able to report that
> > > > > > > nesting using a carrat ("^") separator to indicate nesting.  The
> > > > > > > original field format was "contid=<contid>" for task-associated records
> > > > > > > and "contid=<contid>[,<contid>[...]]" for network-namespace-associated
> > > > > > > records.  The new field format is
> > > > > > > "contid=<contid>[^<contid>[...]][,<contid>[...]]".
> > > > > >
> > > > > > Let's make sure we always use a comma as a separator, even when
> > > > > > recording the parent information, for example:
> > > > > > "contid=<contid>[,^<contid>[...]][,<contid>[...]]"
> > > > >
> > > > > The intent here is to clearly indicate and separate nesting from
> > > > > parallel use of several containers by one netns.  If we do away with
> > > > > that distinction, then we lose that inheritance accountability and
> > > > > should really run the list through a "uniq" function to remove the
> > > > > produced redundancies.  This clear inheritance is something Steve was
> > > > > looking for since tracking down individual events/records to show that
> > > > > inheritance was not aways feasible due to rolled logs or search effort.
> > > >
> > > > Perhaps my example wasn't clear.  I'm not opposed to the little
> > > > carat/hat character indicating a container's parent, I just think it
> > > > would be good to also include a comma *in*addition* to the carat/hat.
> > >
> > > Ah, ok.  Well, I'd offer that it would be slightly shorter, slightly
> > > less cluttered and having already written the parser in userspace, I
> > > think the parser would be slightly simpler.
> > >
> > > I must admit, I was a bit puzzled by your snippet of code that was used
> > > as a prefix to the next item rather than as a postfix to the given item.
> > >
> > > Can you say why you prefer the comma in addition?
> >
> > Generally speaking, I believe that a single delimiter is both easier
> > for the eyes to parse, and easier/safer for machines to parse as well.
> > In this particular case I think of the comma as a delimiter and the
> > carat as a modifier, reusing the carat as a delimiter seems like a bad
> > idea to me.
>
> I'm not crazy about this idea, but I'll have a look at how much work it
> is to recode the userspace search tools.  It also adds extra characters
> and noise into the string format that seems counterproductive.

If anything the parser should be *easier* (although both parsers
should fall into the "trivial" category).  The comma is the one and
only delimiter, and if the ACID starts with a carat then it is a
parent of the preceding ACID.

> > > > > > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > > > > > index ef8e07524c46..68be59d1a89b 100644
> > > > > > > --- a/kernel/audit.c
> > > > > > > +++ b/kernel/audit.c
> > > > > >
> > > > > > > @@ -492,6 +493,7 @@ void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
> > > > > > >                 audit_netns_contid_add(new->net_ns, contid);
> > > > > > >  }
> > > > > > >
> > > > > > > +void audit_log_contid(struct audit_buffer *ab, u64 contid);
> > > > > >
> > > > > > If we need a forward declaration, might as well just move it up near
> > > > > > the top of the file with the rest of the declarations.
> > > > >
> > > > > Ok.
> > > > >
> > > > > > > +void audit_log_contid(struct audit_buffer *ab, u64 contid)
> > > > > > > +{
> > > > > > > +       struct audit_contobj *cont = NULL, *prcont = NULL;
> > > > > > > +       int h;
> > > > > >
> > > > > > It seems safer to pass the audit container ID object and not the u64.
> > > > >
> > > > > It would also be faster, but in some places it isn't available such as
> > > > > for ptrace and signal targets.  This also links back to the drop record
> > > > > refcounts to hold onto the contobj until process exit, or signal
> > > > > delivery.
> > > > >
> > > > > What we could do is to supply two potential parameters, a contobj and/or
> > > > > a contid, and have it use the contobj if it is valid, otherwise, use the
> > > > > contid, as is done for names and paths supplied to audit_log_name().
> > > >
> > > > Let's not do multiple parameters, that begs for misuse, let's take the
> > > > wrapper function route:
> > > >
> > > >  func a(int id) {
> > > >    // important stuff
> > > >  }
> > > >
> > > >  func ao(struct obj) {
> > > >    a(obj.id);
> > > >  }
> > > >
> > > > ... and we can add a comment that you *really* should be using the
> > > > variant that passes an object.
> > >
> > > I was already doing that where it available, and dereferencing the id
> > > for the call.  But I see an advantage to having both parameters supplied
> > > to the function, since it saves us the trouble of dereferencing it,
> > > searching for the id in the hash list and re-locating the object if the
> > > object is already available.
> >
> > I strongly prefer we not do multiple parameters for the same "thing";
>
> So do I, ideally.  However...
>
> > I would much rather do the wrapper approach as described above.  I
> > would also like to see us use the audit container ID object as much as
> > possible, using a bare integer should be a last resort.
>
> It is not clear to me that you understood what I wrote above.  I can't
> use the object pointer where preferable because there are a few cases
> where only the ID is available.  If only the ID is available, I would
> have to make a best effort to look up the object pointer and am not
> guaranteed to find it (invalid, stale, signal info...).  If I am forced
> to use only one, it becomes the ID that is used, and I no longer have
> the benefit of already having the object pointer for certainty and
> saving work.  For all cases where I have the object pointer, which is
> most cases, and most frequently used cases, I will have to dereference
> the object pointer to an ID, then go through the work again to re-locate
> the object pointer.  This is less certain, and more work.  Reluctantly,
> the only practical solution I see here is to supply both, favouring the
> object pointer if it is valid, then falling back on the ID from the next
> parameter.

It has been a while since I last looked at the patchset, but my
concern over the prefered use of the ACID number vs the ACID object is
that the number offers no reuse protection where the object does.  I
really would like us to use the object everywhere it is possible.

-- 
paul moore
www.paul-moore.com
