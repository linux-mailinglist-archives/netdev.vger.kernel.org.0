Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32DEF69D3C
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 23:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732348AbfGOVEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 17:04:44 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40244 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729640AbfGOVEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 17:04:43 -0400
Received: by mail-lj1-f195.google.com with SMTP id m8so17686110lji.7
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 14:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nMdAH6nTLDrGvTqGSOAbQkcOJz7RylQFzwai+/2x5Kg=;
        b=C00/OWh9vq2MRiQn1E4VUuP+O+05mZjNiBnTBYE91LA3zA6l01Y3ZAFqD2sa2HJkYA
         h5J92fYmst8NEM4kbY7z9ANwjGbMbqg3KDgovAqdXLcZH01wV9eGew+ThGgGmvphgmAD
         MxCVdar45y7UYA1DDtDoQVv8dYq4cWtZjZQ6/WT8LjTbkRr544wt+KFFducPNhPYqfvf
         wvewvBAHmtMQ3UdggObhYJdHU1TEreaMfaoyjsOy6hYFNOwCZ9YqhCLMTU3973yjiSJE
         Yi+PlsVJ+lpWQCfj+ktNFR7xMaZJmXQJhqz9OR+Yp0H3xtV8sPxtgsA5H5qa8lTtOAmU
         09Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nMdAH6nTLDrGvTqGSOAbQkcOJz7RylQFzwai+/2x5Kg=;
        b=ins9fzM3wgicX509twArfAhlrT5W6r4LcBlYkWJdlMyFN6ZTTVajQ27JOPFUUhP1qf
         OESUgDmHRFe05tCEF3ruwQcpUhnziR0LZShYOWe/klDh6Tb1m51/I0xNAsrRlURc+AOC
         Cie2IU5PbLOCHrYYfSe8QPE89vmRkv3qo3PcOzy7UXv/DsfUfDNZaozrz6Zl++2ut0IT
         hFDfnRsvFg+JUEaJT7qc8pwmW2Fji2RMPGi+Z4H9Uo/OyYrTX07gaOpsXyuTMXewJvri
         XkgZ2fbM2yGWEaZ063v1RrOssLl1VlA09MW0yUWsqGaCsq3Zbu4TSYAnTHuC5aPxmUTL
         JCxA==
X-Gm-Message-State: APjAAAV+RNs2CZVT2bGVFNMHUE/1ILvoMYjUWUayfMhRP9MbXAIEsei9
        988UblxaLIS04nll0feeRsUjPyIvZLuP09siUw==
X-Google-Smtp-Source: APXvYqx7xtowySesa4+9lw6Ozl7JVLEqOjJfTZIHvPqefLlVsTXkwA71CsctPNus3iiABl3+IN2es94OlE7TcFEpzio=
X-Received: by 2002:a2e:5bdd:: with SMTP id m90mr14605368lje.46.1563224680729;
 Mon, 15 Jul 2019 14:04:40 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <9edad39c40671fb53f28d76862304cc2647029c6.1554732921.git.rgb@redhat.com>
 <20190529145742.GA8959@cisco> <CAHC9VhR4fudQanvZGYWMvCf7k2CU3q7e7n1Pi7hzC3v_zpVEdw@mail.gmail.com>
 <20190529153427.GB8959@cisco> <CAHC9VhSF3AjErX37+eeusJ7+XRw8yuPsmqBTRwc9EVoRBh_3Tw@mail.gmail.com>
 <20190529222835.GD8959@cisco> <CAHC9VhRS66VGtug3fq3RTGHDvfGmBJG6yRJ+iMxm3cxnNF-zJw@mail.gmail.com>
 <20190530170913.GA16722@mail.hallyn.com> <CAHC9VhThLiQzGYRUWmSuVfOC6QCDmA75BDB7Eg7V8HX4x7ymQg@mail.gmail.com>
 <20190708180558.5bar6ripag3sdadl@madcap2.tricolour.ca>
In-Reply-To: <20190708180558.5bar6ripag3sdadl@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 15 Jul 2019 17:04:29 -0400
Message-ID: <CAHC9VhRTT7JWqNnynvK04wKerjc-3UJ6R1uPtjCAPVr_tW-7MA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     "Serge E. Hallyn" <serge@hallyn.com>,
        Tycho Andersen <tycho@tycho.ws>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        ebiederm@xmission.com, nhorman@tuxdriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 8, 2019 at 2:06 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2019-05-30 15:29, Paul Moore wrote:

...

> > [REMINDER: It is an "*audit* container ID" and not a general
> > "container ID" ;)  Smiley aside, I'm not kidding about that part.]
> >
> > I'm not interested in supporting/merging something that isn't useful;
> > if this doesn't work for your use case then we need to figure out what
> > would work.  It sounds like nested containers are much more common in
> > the lxc world, can you elaborate a bit more on this?
> >
> > As far as the possible solutions you mention above, I'm not sure I
> > like the per-userns audit container IDs, I'd much rather just emit the
> > necessary tracking information via the audit record stream and let the
> > log analysis tools figure it out.  However, the bigger question is how
> > to limit (re)setting the audit container ID when you are in a non-init
> > userns.  For reasons already mentioned, using capable() is a non
> > starter for everything but the initial userns, and using ns_capable()
> > is equally poor as it essentially allows any userns the ability to
> > munge it's audit container ID (obviously not good).  It appears we
> > need a different method for controlling access to the audit container
> > ID.
>
> We're not quite ready yet for multiple audit daemons and possibly not
> yet for audit namespaces, but this is starting to look a lot like the
> latter.

A few quick comments on audit namespaces: the audit container ID is
not envisioned as a new namespace (even in nested form) and neither do
I consider running multiple audit daemons to be a new namespace.

From my perspective we create namespaces to allow us to redefine a
global resource for some subset of the system, e.g. providing a unique
/tmp for some number of processes on the system.  While it may be
tempting to think of the audit container ID as something we could
"namespace", especially when multiple audit daemons are concerned, in
some ways this would be counter productive; the audit container ID is
intended to be a global ID that can be used to associate audit event
records with a "container" where the "container" is defined by an
orchestrator outside the audit subsystem.  The global nature of the
audit container ID allows us to maintain a sane(ish) view of the
system in the audit log, if we were to "namespace" the audit container
ID such that the value was no longer guaranteed to be unique
throughout the system, we would need to additionally track the audit
namespace along with the audit container ID which starts to border on
insanity IMHO.

> If we can't trust ns_capable() then why are we passing on
> CAP_AUDIT_CONTROL?  It is being passed down and not stripped purposely
> by the orchestrator/engine.  If ns_capable() isn't inherited how is it
> gained otherwise?  Can it be inserted by cotainer image?  I think the
> answer is "no".  Either we trust ns_capable() or we have audit
> namespaces (recommend based on user namespace) (or both).

My thinking is that since ns_capable() checks the credentials with
respect to the current user namespace we can't rely on it to control
access since it would be possible for a privileged process running
inside an unprivileged container to manipulate the audit container ID
(containerized process has CAP_AUDIT_CONTROL, e.g. running as root in
the container, while the container itself does not).

> At this point I would say we are at an impasse unless we trust
> ns_capable() or we implement audit namespaces.

I'm not sure how we can trust ns_capable(), but if you can think of a
way I would love to hear it.  I'm also not sure how namespacing audit
is helpful (see my above comments), but if you think it is please
explain.

> I don't think another mechanism to trust nested orchestrators/engines
> will buy us anything.
>
> Am I missing something?

Based on your questions/comments above it looks like your
understanding of ns_capable() does not match mine; if I'm thinking
about ns_capable() incorrectly, please educate me.

-- 
paul moore
www.paul-moore.com
