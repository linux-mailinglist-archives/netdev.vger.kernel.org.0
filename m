Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176A657EAB4
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 02:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiGWAuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 20:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiGWAuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 20:50:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7712EA;
        Fri, 22 Jul 2022 17:50:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1857E60F43;
        Sat, 23 Jul 2022 00:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E2CC341C7;
        Sat, 23 Jul 2022 00:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658537404;
        bh=TzrtCWbvp9xlhM+EhlokKXEC37achoIcSImr279ysMM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kPDidcSn/wHcSpgLdRQos1zChO8f/+gYyq/L6fXCopZgjnOGoC/Brlp9antc1ZUv0
         O89gJscnDkGcZqOmMCjxl4zuezT4mb80i8bPhm1JMh4ibhE+Fhln79831Go2NtGUEo
         jj1Wv35FZuF/z0PqYqGquCVBhSWQbUdD4TgleK52nYpgRPa/t8a1RGO4xBMdb5bJ/V
         CJ9rmj3JJJ1QV6B+oyQkE5CNu/lWY3+iAAMn3549tLhHwbbq5xcjMRrsqrCE7gNMMQ
         OMgzIfUO6G3h2/it81nV5JzvnJLgsTfcC5Dg24PL/nLxLsN9wC3cRrQ158cT5VoU6+
         RZt8vYV7M0Eiw==
Date:   Fri, 22 Jul 2022 17:50:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: pull request: bluetooth-next 2022-07-22
Message-ID: <20220722175003.5d4ba0e0@kernel.org>
In-Reply-To: <CABBYNZJ5-yPzxd0mo4E+wXuEwo1my+iaiW8YOwYP05Uhmtd98Q@mail.gmail.com>
References: <20220722205400.847019-1-luiz.dentz@gmail.com>
        <20220722165510.191fad93@kernel.org>
        <CABBYNZLj2z_81p=q0iSxEBgVW_L3dw8UKGwQKOEDj9fgDLYJ0g@mail.gmail.com>
        <20220722171919.04493224@kernel.org>
        <CABBYNZJ5-yPzxd0mo4E+wXuEwo1my+iaiW8YOwYP05Uhmtd98Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jul 2022 17:25:57 -0700 Luiz Augusto von Dentz wrote:
> > > Crap, let me fix them.  
> >
> > Do you mean i should hold off with pushing or you'll follow up?  
> 
> Ive just fixup the original patch that introduced it, btw how do you
> run sparse to capture such errors?

We run builds with W=1 C=1 in the CI and then diff the outputs.
That's pretty noisy so we have a regex which counts number of
warnings per file, that makes it possible to locate the exact new
warning. At least most of the time...

> > > Yep, that happens when I rebase on top of net-next so I would have to
> > > redo all the Signed-off-by lines if the patches were originally
> > > applied by Marcel, at least I don't know of any option to keep the
> > > original committer while rebasing?  
> >
> > I think the most common way is to avoid rebasing. Do you rebase to get
> > rid of revised patches or such?  
> 
> So we don't need to rebase?

No, not usually. After we pull from you, you should pull back from us 
(git pull --ff-only $net-or-net-next depending on the tree you
targeted), and that's it. The only patches that go into your tree then
are bluetooth patches, everything else is fed via pulling back from us.

> There were some patches already applied via bluetooth.git so at least
> I do it to remove them 

Normally you'd not apply bluetooth fixes to bluetooth-next, apply 
them to bluetooth and send us a PR. Then once a week we'll merge
net (containing your fixes) into net-next, at which point you can 
send a bluetooth-next PR and get the fixes into bluetooth-next.
FWIW from our perspective there's no limit on how often you send PRs.

Alternatively you could apply the fixes into bluetooth and then
merge bluetooth into bluetooth-next. If you never rebase either tree, 
git will be able to figure out that it's the same commit hash even if
it makes it to the tree twice (once thru direct merge and once via 
net). That said, I believe Linus does not like cross tree merges, i.e.
merges which are not fast forwards to the downstream tree. So it's
better to take the long road via bt ->  net -> net-next -> bt-next.

> and any possible conflicts if there were
> changes introduced to the bluetooth directories that can eventually
> come from some other tree.

Conflicts are not a worry, just let us know in the PR description how
to resolve them.
