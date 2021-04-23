Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D527369450
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 16:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhDWODI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 10:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhDWODG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 10:03:06 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD1FC061574
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 07:02:29 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id w4so44814477wrt.5
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 07:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=mqDAI2Eo0AiEBMj+7YqhB+/EfKK7wEdKmdXLdRdTOaw=;
        b=PcB4NGYzuRZfIQCklsDEhiVsnNkUPaGQDpaJWtwroqJaTW5plTBA+wjkIKfKDkxwZ6
         xU/1Rm894k7ruc2jCU5Syg239Uc5QDMokzbD7CNnG4G6j6GpIQegviH8dySyJI+p9xti
         uSPcxDix+2yCqVELTmFsbybyYHZKJJfkSY/PqCCQwrB5rqN5v860ewnFzHu7JNeLjCGy
         Ytr1QXVS8RT1QZKRwvFls5lO3rXmt/NpghkyAdFbpyF3tHLByDrWcaPZsEAEVNEsxIfA
         Rz6vQcpl+UHoeIGDrZg1koY5RRt4SRsniACz5udYvR3UH5+UAGO39IpGB23DXdJGBZBk
         13yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=mqDAI2Eo0AiEBMj+7YqhB+/EfKK7wEdKmdXLdRdTOaw=;
        b=s6mF3G4GuDd9n2J81eCkL8yIfEMP9bB+EPp+1h3H/TJhReuy00hmHXGsRAo38egshb
         zez8pXWf5Qdk2NlaSarz6ADt9IwkHKY4RO8KPSWlBwPp3CIK80lMSs953PNAnkSeBANN
         c3TUcwywcB8U1wTPBKLkfis3wyZzdApqD5svVapznElqbfgI8BX7YMb6wUApBTEhDHRA
         SoEQij7tsc8Xi8z0k0crpjeYz6Nc9XpR9N2E3o+lKOqnvwZsDEZfUp+LCQP+DMzJHgaM
         yiuvN7TpJWt0/tBzF+07LlEb+czB18l9y2PWQ7dU3cwJdXmygQ0vPOi59mtutFpo5FMv
         hLZw==
X-Gm-Message-State: AOAM531DdY+X5kUVdxW0NpL4j4SZP0jHWvR5KFLsYsMJKoL3ihsLVrkK
        lEwWLAaGvZXXfrjx3SzeDbuRcQ==
X-Google-Smtp-Source: ABdhPJz4lBAWRredHV50729J0WuYpflBIWpdZIt5fX8mmVLMQZwVCqN6/75zTpHENIY+al7Yf6HlWg==
X-Received: by 2002:a05:6000:18ae:: with SMTP id b14mr4943822wri.211.1619186548117;
        Fri, 23 Apr 2021 07:02:28 -0700 (PDT)
Received: from elver.google.com ([2a00:79e0:15:13:d1f:43f2:c472:9b8])
        by smtp.gmail.com with ESMTPSA id z15sm8890560wrv.39.2021.04.23.07.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 07:02:27 -0700 (PDT)
Date:   Fri, 23 Apr 2021 16:02:21 +0200
From:   Marco Elver <elver@google.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Marion et Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tj@kernel.org, jiangshanlai@gmail.com, saeedm@nvidia.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] workqueue: Have 'alloc_workqueue()' like macros
 accept a format specifier
Message-ID: <YILTbVnxBJVYa3jT@elver.google.com>
References: <cover.1618780558.git.christophe.jaillet@wanadoo.fr>
 <ae88f6c2c613d17bc1a56692cfa4f960dbc723d2.1618780558.git.christophe.jaillet@wanadoo.fr>
 <042f5fff-5faf-f3c5-0819-b8c8d766ede6@acm.org>
 <1032428026.331.1618814178946.JavaMail.www@wwinf2229>
 <40c21bfe-e304-230d-b319-b98063347b8b@acm.org>
 <20210422122419.GF2047089@ziepe.ca>
 <782e329a-7c3f-a0da-5d2f-89871b0c4b9b@acm.org>
 <YIG5tLBIAledZetf@unreal>
 <53b2ef14-1b8a-43b1-ef53-e314e2649ea0@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53b2ef14-1b8a-43b1-ef53-e314e2649ea0@acm.org>
User-Agent: Mutt/2.0.5 (2021-01-21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 01:30PM -0700, Bart Van Assche wrote:
> On 4/22/21 11:00 AM, Leon Romanovsky wrote:
> > On Thu, Apr 22, 2021 at 10:12:33AM -0700, Bart Van Assche wrote:
> > > On 4/22/21 5:24 AM, Jason Gunthorpe wrote:
> > > > On Mon, Apr 19, 2021 at 01:02:34PM -0700, Bart Van Assche wrote:
> > > > > On 4/18/21 11:36 PM, Marion et Christophe JAILLET wrote:
> > > > > > The list in To: is the one given by get_maintainer.pl. Usualy, I only
> > > > > > put the ML in Cc: I've run the script on the 2 patches of the serie
> > > > > > and merged the 2 lists. Everyone is in the To: of the cover letter
> > > > > > and of the 2 patches.
> > > > > > 
> > > > > > If Théo is "Tejun Heo" (  (maintainer:WORKQUEUE) ), he is already in
> > > > > > the To: line.
> > > > > Linus wants to see a "Cc: ${maintainer}" tag in patches that he receives
> > > > > from a maintainer and that modify another subsystem than the subsystem
> > > > > maintained by that maintainer.
> > > > 
> > > > Really? Do you remember a lore link for this?
> > > 
> > > Last time I saw Linus mentioning this was a few months ago.
> > > Unfortunately I cannot find that message anymore.
> > > 
> > > > Generally I've been junking the CC lines (vs Andrew at the other
> > > > extreme that often has 10's of CC lines)
> > > 
> > > Most entries in the MAINTAINERS file have one to three email addresses
> > > so I'm surprised to read that Cc-ing maintainer(s) could result in tens
> > > of Cc lines?
> > 
> > git log mm/
> > 
> > commit 2b8305260fb37fc20e13f71e13073304d0a031c8
> > Author: Alexander Potapenko <glider@google.com>
> > Date:   Thu Feb 25 17:19:21 2021 -0800
> > 
> >      kfence, kasan: make KFENCE compatible with KASAN
> > 
> >      Make KFENCE compatible with KASAN. Currently this helps test KFENCE
> >      itself, where KASAN can catch potential corruptions to KFENCE state, or
> >      other corruptions that may be a result of freepointer corruptions in the
> >      main allocators.
> > 
> >      [akpm@linux-foundation.org: merge fixup]
> >      [andreyknvl@google.com: untag addresses for KFENCE]
> >        Link: https://lkml.kernel.org/r/9dc196006921b191d25d10f6e611316db7da2efc.1611946152.git.andreyknvl@google.com
> > 
> >      Link: https://lkml.kernel.org/r/20201103175841.3495947-7-elver@google.com
> >      Signed-off-by: Marco Elver <elver@google.com>
> >      Signed-off-by: Alexander Potapenko <glider@google.com>
> >      Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> >      Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
> >      Reviewed-by: Jann Horn <jannh@google.com>
> >      Co-developed-by: Marco Elver <elver@google.com>
> >      Cc: Andrey Konovalov <andreyknvl@google.com>
> >      Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
> >      Cc: Andy Lutomirski <luto@kernel.org>
> >      Cc: Borislav Petkov <bp@alien8.de>
> >      Cc: Catalin Marinas <catalin.marinas@arm.com>
> >      Cc: Christopher Lameter <cl@linux.com>
> >      Cc: Dave Hansen <dave.hansen@linux.intel.com>
> >      Cc: David Rientjes <rientjes@google.com>
> >      Cc: Eric Dumazet <edumazet@google.com>
> >      Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >      Cc: Hillf Danton <hdanton@sina.com>
> >      Cc: "H. Peter Anvin" <hpa@zytor.com>
> >      Cc: Ingo Molnar <mingo@redhat.com>
> >      Cc: Joern Engel <joern@purestorage.com>
> >      Cc: Jonathan Corbet <corbet@lwn.net>
> >      Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >      Cc: Kees Cook <keescook@chromium.org>
> >      Cc: Mark Rutland <mark.rutland@arm.com>
> >      Cc: Paul E. McKenney <paulmck@kernel.org>
> >      Cc: Pekka Enberg <penberg@kernel.org>
> >      Cc: Peter Zijlstra <peterz@infradead.org>
> >      Cc: SeongJae Park <sjpark@amazon.de>
> >      Cc: Thomas Gleixner <tglx@linutronix.de>
> >      Cc: Vlastimil Babka <vbabka@suse.cz>
> >      Cc: Will Deacon <will@kernel.org>
> >      Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >      Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

This is a special case probably as KFENCE touched various subsystems and
architectures.

That Cc list is from the original

	https://lkml.kernel.org/r/20201103175841.3495947-7-elver@google.com

It was determined based on the full series, mostly from a
get_maintainer.pl of 'reviewer' and 'maintainer' lists of the full
series diff, minus a some false positives to avoid spamming people, and
plus a few people get_maintainer.pl missed that had provided or could
provide useful input. So the list above is mostly maintainers+reviewers
of mm/, mm/kasan, arch/x86, and arch/arm64.

> But where does that Cc-list come from? If I extract that patch and run the
> get_maintainer.pl script, the following output appears:
> 
> $ git format-patch -1 2b8305260fb37fc20e13f71e13073304d0a031c8
> 0001-kfence-kasan-make-KFENCE-compatible-with-KASAN.patch
> $ scripts/get_maintainer.pl
> 0001-kfence-kasan-make-KFENCE-compatible-with-KASAN.patch
> Alexander Potapenko <glider@google.com> (maintainer:KFENCE)
> Marco Elver <elver@google.com> (maintainer:KFENCE)

KFENCE did not yet exist when the patch the above series was part of was
posted... so chicken and egg situation here. ;-)

> Dmitry Vyukov <dvyukov@google.com> (reviewer:KFENCE)
> Andrey Ryabinin <ryabinin.a.a@gmail.com> (maintainer:KASAN)
> Andrey Konovalov <andreyknvl@gmail.com> (reviewer:KASAN)
> Andrew Morton <akpm@linux-foundation.org> (maintainer:MEMORY MANAGEMENT)
> kasan-dev@googlegroups.com (open list:KFENCE)
> linux-kernel@vger.kernel.org (open list)
> linux-mm@kvack.org (open list:MEMORY MANAGEMENT)

Thanks,
-- Marco
