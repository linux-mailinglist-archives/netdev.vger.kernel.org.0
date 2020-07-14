Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B795021E4B5
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgGNApN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbgGNApM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 20:45:12 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE36CC08C5DD
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 17:45:10 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id d18so15397108edv.6
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 17:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bmkyDT2Ok5AKFPTzejs90EKhv0LPiFP9AWMW7s63JrQ=;
        b=Jg0UAal5+4ko6u58hgMcHJj+uPsQ3LKmIcb61aCtyM4jaS3QWcAOCy0OObnsCpkXUU
         ISOHXxoeLc2wCXHvajiQfNFdrMJ7CZz0MIzF+f971d/Gfu7vDxvayh7mhP2svb+qf2K1
         YjCKpJmEeHMPjbQgTcGGPjMJ2K/Bh+qYoKC+z1uXDQYgcZeKcEhWagYje7djbIKDgWYJ
         AYe/bLL7xIkCn1F4CcRszKPFnDbSkFF4fiY64ouwJMLevX6CoCQo+zUsKxKywrzWL6JY
         EIXB9J4+THNCUiMEJXbr8YqqIliuE2LBwznBkdqqenwgZ5vW4MfNPwXn4hh3McNhiyp1
         6Lpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bmkyDT2Ok5AKFPTzejs90EKhv0LPiFP9AWMW7s63JrQ=;
        b=uK7PcudnigSzGA9khRgEV4tOcN0WQAKiJMlpOW6qPBOjVy08CFttxgXoOH8dHixjt/
         U5lQEbBKsZyD2U/q+asGtyxZeGdoQelTwnjmXAaXYuGYwSAnhoQ2LB16fZuFZf8Ra2ub
         e0QYgbdz/rXvqXvrabYDW914CrnfRcuqtt2q7IpwN9hcZNfeH5pzLxtHAliCef1cTo1D
         zaqRJfg9gmS6TXjFvZgEmQe6Qzq8xcQdwlq0lexo3ziC6sk9BZFcqBLzpM/yx184yf39
         qxr/+530E5DA8rG7iuCz1leESiH7vy7fHeozKfJbH3XCjPHT6KlpUG5jkcAVBTeuEAGU
         GmEw==
X-Gm-Message-State: AOAM5325k2dqvyafS6Cp9Wqlxxj9eHKRkvszbus0ZV7ZMOl4SsUhmbZ+
        4m4wfcQweP8fPxXiSPfE/GETEyfWoYUWCWvr5TIY
X-Google-Smtp-Source: ABdhPJxFM46eZkco0XOaaCsFFTHlrOfIfbbkJNmhbdNiqdLTCYkgzE1EAejSD/O9P/+a7qjfCVbCzfrxVpEC0f0mWgE=
X-Received: by 2002:a05:6402:1d89:: with SMTP id dk9mr1958150edb.31.1594687509148;
 Mon, 13 Jul 2020 17:45:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593198710.git.rgb@redhat.com> <6abeb26e64489fc29b00c86b60b501c8b7316424.1593198710.git.rgb@redhat.com>
 <CAHC9VhTx=4879F1MSXg4=Xd1i5rhEtyam6CakQhy=_ZjGtTaMA@mail.gmail.com>
 <20200707025014.x33eyxbankw2fbww@madcap2.tricolour.ca> <CAHC9VhTTGLf9MPS_FgL1ibUVoH+YzMtPK6+2dp_j8a5o9fzftA@mail.gmail.com>
 <20200713202906.iiz435vjeedljcwf@madcap2.tricolour.ca>
In-Reply-To: <20200713202906.iiz435vjeedljcwf@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 13 Jul 2020 20:44:57 -0400
Message-ID: <CAHC9VhScQAMeEXssDhDeAo+za9f-doqcM-yutDmFBuwqZVpa3A@mail.gmail.com>
Subject: Re: [PATCH ghak90 V9 01/13] audit: collect audit task parameters
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

On Mon, Jul 13, 2020 at 4:30 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-07-07 21:42, Paul Moore wrote:
> > On Mon, Jul 6, 2020 at 10:50 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2020-07-05 11:09, Paul Moore wrote:
> > > > On Sat, Jun 27, 2020 at 9:21 AM Richard Guy Briggs <rgb@redhat.com> wrote:

...

> > > > In the early days of this patchset we talked a lot about how to handle
> > > > the task_struct and the changes that would be necessary, ultimately
> > > > deciding that encapsulating all of the audit fields into an
> > > > audit_task_info struct.  However, what is puzzling me a bit at this
> > > > moment is why we are only including audit_task_info in task_info by
> > > > reference *and* making it a build time conditional (via CONFIG_AUDIT).
> > > >
> > > > If audit is enabled at build time it would seem that we are always
> > > > going to allocate an audit_task_info struct, so I have to wonder why
> > > > we don't simply embed it inside the task_info struct (similar to the
> > > > seccomp struct in the snippet above?  Of course the audit_context
> > > > struct needs to remain as is, I'm talking only about the
> > > > task_info/audit_task_info struct.
> > >
> > > I agree that including the audit_task_info struct in the struct
> > > task_struct would have been preferred to simplify allocation and free,
> > > but the reason it was included by reference instead was to make the
> > > task_struct size independent of audit so that future changes would not
> > > cause as many kABI challenges.  This first change will cause kABI
> > > challenges regardless, but it was future ones that we were trying to
> > > ease.
> > >
> > > Does that match with your recollection?
> >
> > I guess, sure.  I suppose what I was really asking was if we had a
> > "good" reason for not embedding the audit_task_info struct.
> > Regardless, thanks for the explanation, that was helpful.
>
> Making it dynamic was actually your idea back in the spring of 2018:
>         https://lkml.org/lkml/2018/4/18/759

If you read my comments from 2018 carefully, or even not so carefully
I think, you'll notice that my primary motivation for using a pointer
was to "hide" the audit_task_info struct contents so that they
couldn't be abused by other kernel subsystems looking for a general
container identifier inside the kernel.  As we've discussed many times
before, this patchset is not a general purpose container identifier,
this is an ***audit*** container ID; limiting the scope and usage of
this identifier is what has allowed us to gain the begrudging
acceptance we've had thus far and I believe it is the key to success.

For whatever it is worth, this patchset doesn't hide the
audit_task_struct definition in a kernel/audit*.c file, it lives in a
header file which is easily accessed by other subsystems.

In my opinion we should pick one of two options: leave it as a pointer
reference and "hide" the struct definition, or just embed the struct
and simplify the code.  I see little value in openly defining the
audit_task_info struct and using a pointer reference; if you believe
you have a valid argument for why this makes sense I'm open to hearing
it, but your comments thus far have been unconvincing.

> > > > Richard, I'm sure you can answer this off the top of your head, but
> > > > I'd have to go digging through the archives to pull out the relevant
> > > > discussions so I figured I would just ask you for a reminder ... ?  I
> > > > imagine it's also possible things have changed a bit since those early
> > > > discussions and the solution we arrived at then no longer makes as
> > > > much sense as it did before.
> > >
> > > Agreed, it doesn't make as much sense now as it did when proposed, but
> > > will make more sense in the future depending on when this change gets
> > > accepted upstream.  This is why I wanted this patch to go through as
> > > part of ghak81 at the time the rest of it did so that future kABI issues
> > > would be easier to handle, but that ship has long sailed.
> >
> > To be clear, kABI issues with task_struct really aren't an issue with
> > the upstream kernel.  I know that you know all of this already
> > Richard, I'm mostly talking to everyone else on the To/CC line in case
> > they are casually watching this discussion.
>
> kABI issues may not as much of an upstream issue, but part of the goal
> here was upstream kernel issues, isolating the kernel audit changes
> to its own subsystem and affect struct task_struct as little as possible
> in the future and to protect it from "abuse" (as you had expressed
> serious concerns) from the rest of the kernel.  include/linux/sched.h
> will need to know more about struct audit_task_info if it is embedded,
> making it more suceptible to abuse.

I define "abuse" in this context as other kernel subsystems inspecting
the contents of the audit_task_struct, most likely to try and
approximate a general container identifier.

Better separation between the audit subsystem and the task_struct,
while conceptually nice, isn't critical and is easily changed upstream
with each kernel release as it isn't part of the kernel/userspace API.
Regardless, a basic conceptual separation is achieved by the
audit_task_struct regardless of if it is embedded into the task_struct
or included by a pointer reference.

> > While I'm sympathetic to long-lifetime enterprise distros such as
> > RHEL, my responsibility is to ensure the upstream kernel is as good as
> > we can make it, and in this case I believe that means embedding
> > audit_task_info into the task_struct.
>
> Keeping audit_task_info dynamic will also make embedding struct
> audit_context as a zero-length array at the end of it possible in the
> future as an internal audit subsystem optimization whereas largely
> preclude that if it were embedded.

Predicting the future is hard, but I would be comfortable giving up on
a variable length audit_task_info struct.  Besides, if we *really* had
to do that in the future we could, it's not part of the
kernel/userspace API.

> This method has been well exercised over the last two years of
> development, testing and rebases, so I'm not particularly concerned
> about its dynamic nature any more.  It works well.  At this point this
> change seems to be more gratuitously disruptive than helpful.

It may not seem like it, but at this point in this patchset's life I
do try to limit my comments to only those things which I feel are
substantive.  In the cases where I think something is borderline I'll
mention that in my comments.  The trivial cases I'll generally call
out as "nitpicks".  I assure you my comments are not gratuitous.

I look forward to reviewing another round of this patchset about as
much as I expect you look forward to writing, testing, and submitting
it.

> > > > > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > > > > index 468a23390457..f00c1da587ea 100644
> > > > > --- a/kernel/auditsc.c
> > > > > +++ b/kernel/auditsc.c
> > > > > @@ -1612,7 +1615,6 @@ void __audit_free(struct task_struct *tsk)
> > > > >                 if (context->current_state == AUDIT_RECORD_CONTEXT)
> > > > >                         audit_log_exit();
> > > > >         }
> > > > > -
> > > > >         audit_set_context(tsk, NULL);
> > > > >         audit_free_context(context);
> > > > >  }
> > > >
> > > > This nitpick is barely worth the time it is taking me to write this,
> > > > but the whitespace change above isn't strictly necessary.
> > >
> > > Sure, it is a harmless but noisy cleanup when the function was being
> > > cleaned up and renamed.  It wasn't an accident, but a style preference.
> > > Do you prefer a vertical space before cleanup actions at the end of
> > > functions and more versus less vertical whitespace in general?
> >
> > As I mentioned above, this really was barely worth mentioning, but I
> > made the comment simply because I feel this patchset is going to draw
> > a lot of attention once it is merged and I feel keeping the patchset
> > as small, and as focused, as possible is a good thing.
>
> Is this concern also affecting the perspective on the change from
> pointer to embedded above?

Keeping this particular patchset small and focused has always been a
goal; I know we talked about this at least once, likely more than
that, while I was still at RH and we were talking offline.

If something is going to be contentious, it is better to be small and
focused on the contention.

-- 
paul moore
www.paul-moore.com
