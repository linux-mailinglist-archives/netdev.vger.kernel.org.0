Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142F3581C1C
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 00:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbiGZWbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 18:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiGZWbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 18:31:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A67B28E27;
        Tue, 26 Jul 2022 15:31:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7947616CB;
        Tue, 26 Jul 2022 22:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0C3C433D6;
        Tue, 26 Jul 2022 22:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658874702;
        bh=d4H5gQrtMKIK9qlJr8zIiMTxRgr6ssFnpb1lfTELUk8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nuEVd8I8oMqDpp9sdm91IbUlGm2mQ4Xi0iWPuTGrynByvutuFjXH50bUTtlE9cN1F
         qktPHml49KU8tWHuy+OddnLyTngU8IvAg7kZeSpSRjp3jvCa4SubthEIsXiizPJ4BA
         NkXrzGD2Ubvs0zl+aOPvfVC9t1vfSfdzRQSJfCg8KDyRZbovrUHp9ojLLFusetUedb
         XvzEz9QbhZqNOY2Ktp+8hfL+nL0SBgb3GDZbDKd1390+WNs5FjHZWaz33v9lUJQj3E
         /wCQqmMb3gyR83yM/r4RN0yQXxKWAG8jlBm1EQa/laY/TLIV4K5SlJqzDbc0NLs9Rl
         QmTPHZp0wLk/A==
Date:   Tue, 26 Jul 2022 15:31:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: pull request: bluetooth-next 2022-07-22
Message-ID: <20220726153140.7fefd4b4@kernel.org>
In-Reply-To: <CABBYNZ+74ndrzdx=4dGLE6oQbZ2w6SGnUGeS0OSqH6EnND4qJw@mail.gmail.com>
References: <20220722205400.847019-1-luiz.dentz@gmail.com>
        <20220722165510.191fad93@kernel.org>
        <CABBYNZLj2z_81p=q0iSxEBgVW_L3dw8UKGwQKOEDj9fgDLYJ0g@mail.gmail.com>
        <20220722171919.04493224@kernel.org>
        <CABBYNZJ5-yPzxd0mo4E+wXuEwo1my+iaiW8YOwYP05Uhmtd98Q@mail.gmail.com>
        <20220722175003.5d4ba0e0@kernel.org>
        <CABBYNZ+74ndrzdx=4dGLE6oQbZ2w6SGnUGeS0OSqH6EnND4qJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jul 2022 15:05:17 -0700 Luiz Augusto von Dentz wrote:
> > > Ive just fixup the original patch that introduced it, btw how do you
> > > run sparse to capture such errors?  
> >
> > We run builds with W=1 C=1 in the CI and then diff the outputs.
> > That's pretty noisy so we have a regex which counts number of
> > warnings per file, that makes it possible to locate the exact new
> > warning. At least most of the time...  
> 
> Hmm, is there any way to trigger net CI, either that or we need to
> duplicate the same test under our CI to avoid these last minute
> findings when we are attempting to merge something.

The code is at:

https://github.com/kuba-moo/nipa

But it hardcodes net and bpf tree maching in places. You may want
to steal just the build script, its in bash.

> > > So we don't need to rebase?  
> >
> > No, not usually. After we pull from you, you should pull back from us
> > (git pull --ff-only $net-or-net-next depending on the tree you
> > targeted), and that's it. The only patches that go into your tree then
> > are bluetooth patches, everything else is fed via pulling back from us.
> >  
> > > There were some patches already applied via bluetooth.git so at least
> > > I do it to remove them  
> >
> > Normally you'd not apply bluetooth fixes to bluetooth-next, apply
> > them to bluetooth and send us a PR. Then once a week we'll merge
> > net (containing your fixes) into net-next, at which point you can
> > send a bluetooth-next PR and get the fixes into bluetooth-next.
> > FWIW from our perspective there's no limit on how often you send PRs.  
> 
> Are you saying we should be using merge commits instead of rebase then?

Not sure what merge commits would mean in this case.

> > Alternatively you could apply the fixes into bluetooth and then
> > merge bluetooth into bluetooth-next. If you never rebase either tree,
> > git will be able to figure out that it's the same commit hash even if
> > it makes it to the tree twice (once thru direct merge and once via
> > net). That said, I believe Linus does not like cross tree merges, i.e.
> > merges which are not fast forwards to the downstream tree. So it's
> > better to take the long road via bt ->  net -> net-next -> bt-next.  
> 
> Well I got the impression that merge commits shall be avoided, but

There's many schools of thought, but upstream there's very little
rebasing of "official" branches (i.e. main/master branches, not 
testing or other unstable branches) AFAIK.

> rebase overwrites the committer, so the two option seem to have
> drawbacks, well we can just resign on rebase as well provided git
> doesn't duplicate Signed-off-by if I use something like exec="git
> commit -s --amend".

Sure, be careful tho because I think it doesn't check the signoff
history, IIRC just the most recent tag. So you may end up with multiple
signoffs from yourself and Marcel.

> > > and any possible conflicts if there were
> > > changes introduced to the bluetooth directories that can eventually
> > > come from some other tree.  
> >
> > Conflicts are not a worry, just let us know in the PR description how
> > to resolve them.  
> 
> Not really following, how can we anticipate a merge conflict if we
> don't rebase?

If your trees are hooked up to linux-next (I presume not 'cause Stephen
would probably scream at you for rebasing?) - Stephen will tell you
there's a conflict within a day or two.

Obviously sometimes you'll notice right away when applying patches that
two patches touch the same function.

> With merge strategy it seem that the one pulling needs
> to resolve the conflicts rather than the submitter which I think would
> lead to bad interaction between subsystems, expect if we do a merge
> [-> resolve conflict] -> pull request -> [resolve conflicts ->] merge
> which sounds a little too complicated since we have to resolve
> conflicts in both directions.

The pulling back should always be a fast-forward so there's no merge
commit or conflicts (git pull --ff-only). Only the actual downstream
tree (netdev) has to resolve conflicts, which is not all that bad
thanks for Stephen's advanced notices.

> In my opinion rebase strategy is cleaner and is what we recommend for
> possible clones of bluetooth-next and bluetooth trees including CI so
> possible conflicts are fixed in place rather on the time the trees are
> merged.

No strong preference here as long as we can keep the sign-offs etc in
control. Note that I'm not aware of any other tree we pull rebasing, 
tho, so you may run into unique issues.
