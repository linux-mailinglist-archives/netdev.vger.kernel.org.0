Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77A336864A
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 20:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236826AbhDVSBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 14:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236287AbhDVSA7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 14:00:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 662C3613F5;
        Thu, 22 Apr 2021 18:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619114424;
        bh=egWDsX0yqk96ieznqeLeCw1Tuzn2uxvCmXxvAmpHf9A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ggWHayk99M89Mxo3jOOpneGFS75RRjFQzo7TgFW0dR5vDE/aQmsKtO2bZvJvpCG2g
         1EziTt76QhbfLYUMp09PEPpbaR7BjuSEE5DMh9/5g1bKr6l0RjytIvsAANAXK+k88W
         dXl0ImA25oddOAgg8aE9+nXYVBANs8A2nGZQcolRNEWc9bjcJvAu8QcQIdonQb3o1r
         2aNjVhnlkQuNEvYf4hQKWaj+ihVP8k5fWnk8eCjCA86uqnkSkI8ObG4kb08XlgCNRc
         MG1Koxlsc9RUuvgf3y4tPJbBKKOEn9P4rV7yjfw8AM3pVTdJ1N7gM/ryfyv19gUnyq
         swFK3+5Ilj9yw==
Date:   Thu, 22 Apr 2021 21:00:20 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Marion et Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tj@kernel.org, jiangshanlai@gmail.com, saeedm@nvidia.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] workqueue: Have 'alloc_workqueue()' like macros
 accept a format specifier
Message-ID: <YIG5tLBIAledZetf@unreal>
References: <cover.1618780558.git.christophe.jaillet@wanadoo.fr>
 <ae88f6c2c613d17bc1a56692cfa4f960dbc723d2.1618780558.git.christophe.jaillet@wanadoo.fr>
 <042f5fff-5faf-f3c5-0819-b8c8d766ede6@acm.org>
 <1032428026.331.1618814178946.JavaMail.www@wwinf2229>
 <40c21bfe-e304-230d-b319-b98063347b8b@acm.org>
 <20210422122419.GF2047089@ziepe.ca>
 <782e329a-7c3f-a0da-5d2f-89871b0c4b9b@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <782e329a-7c3f-a0da-5d2f-89871b0c4b9b@acm.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 10:12:33AM -0700, Bart Van Assche wrote:
> On 4/22/21 5:24 AM, Jason Gunthorpe wrote:
> > On Mon, Apr 19, 2021 at 01:02:34PM -0700, Bart Van Assche wrote:
> >> On 4/18/21 11:36 PM, Marion et Christophe JAILLET wrote:
> >>> The list in To: is the one given by get_maintainer.pl. Usualy, I only
> >>> put the ML in Cc: I've run the script on the 2 patches of the serie
> >>> and merged the 2 lists. Everyone is in the To: of the cover letter
> >>> and of the 2 patches.
> >>>
> >>> If Théo is "Tejun Heo" (  (maintainer:WORKQUEUE) ), he is already in
> >>> the To: line.
> >> Linus wants to see a "Cc: ${maintainer}" tag in patches that he receives
> >> from a maintainer and that modify another subsystem than the subsystem
> >> maintained by that maintainer.
> > 
> > Really? Do you remember a lore link for this?
> 
> Last time I saw Linus mentioning this was a few months ago.
> Unfortunately I cannot find that message anymore.
> 
> > Generally I've been junking the CC lines (vs Andrew at the other
> > extreme that often has 10's of CC lines)
> 
> Most entries in the MAINTAINERS file have one to three email addresses
> so I'm surprised to read that Cc-ing maintainer(s) could result in tens
> of Cc lines?

git log mm/

commit 2b8305260fb37fc20e13f71e13073304d0a031c8
Author: Alexander Potapenko <glider@google.com>
Date:   Thu Feb 25 17:19:21 2021 -0800

    kfence, kasan: make KFENCE compatible with KASAN

    Make KFENCE compatible with KASAN. Currently this helps test KFENCE
    itself, where KASAN can catch potential corruptions to KFENCE state, or
    other corruptions that may be a result of freepointer corruptions in the
    main allocators.

    [akpm@linux-foundation.org: merge fixup]
    [andreyknvl@google.com: untag addresses for KFENCE]
      Link: https://lkml.kernel.org/r/9dc196006921b191d25d10f6e611316db7da2efc.1611946152.git.andreyknvl@google.com

    Link: https://lkml.kernel.org/r/20201103175841.3495947-7-elver@google.com
    Signed-off-by: Marco Elver <elver@google.com>
    Signed-off-by: Alexander Potapenko <glider@google.com>
    Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
    Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
    Reviewed-by: Jann Horn <jannh@google.com>
    Co-developed-by: Marco Elver <elver@google.com>
    Cc: Andrey Konovalov <andreyknvl@google.com>
    Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
    Cc: Andy Lutomirski <luto@kernel.org>
    Cc: Borislav Petkov <bp@alien8.de>
    Cc: Catalin Marinas <catalin.marinas@arm.com>
    Cc: Christopher Lameter <cl@linux.com>
    Cc: Dave Hansen <dave.hansen@linux.intel.com>
    Cc: David Rientjes <rientjes@google.com>
    Cc: Eric Dumazet <edumazet@google.com>
    Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Cc: Hillf Danton <hdanton@sina.com>
    Cc: "H. Peter Anvin" <hpa@zytor.com>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: Joern Engel <joern@purestorage.com>
    Cc: Jonathan Corbet <corbet@lwn.net>
    Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
    Cc: Kees Cook <keescook@chromium.org>
    Cc: Mark Rutland <mark.rutland@arm.com>
    Cc: Paul E. McKenney <paulmck@kernel.org>
    Cc: Pekka Enberg <penberg@kernel.org>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: SeongJae Park <sjpark@amazon.de>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Vlastimil Babka <vbabka@suse.cz>
    Cc: Will Deacon <will@kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


> 
> Thanks,
> 
> Bart.
