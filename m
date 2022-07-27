Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C421F581CED
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 03:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbiG0BHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 21:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiG0BHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 21:07:02 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5934F1EADE;
        Tue, 26 Jul 2022 18:07:01 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id i13so10479983edj.11;
        Tue, 26 Jul 2022 18:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ekYNeHLDyYQ/qWETVipiFhBwDmDlj2s7iWCnbv0joSQ=;
        b=qx/+m0k4f3ZGmJLA/K7DiSmxbuGCa7FZvs4YpEDIWjQgGpVwCcX6hNmusb0FPYzRVa
         bNK6mLM2zR21tDGc4iRIJI+UnocjtXp6TLRrd6gUv3Y0DjFMglETbsJ968K82329S/uS
         SbW3gaoWGZ9lo/6CWZrLluvN+OIGebNRCQwvprsyMvvN4NVZ9squRaeDpwxktjxIEwvd
         8ChzJ8rQHi1UjrigsESPNSehWPIueqxPxxhP5sK+Q3/vlGQxX7v3/RcRDwMA5wuUtnPj
         mu4Nbpcmo1/dvP6NnPLSceqdi8GB6a8mPv3IEL+adAWBBpnm6Sn4LzidezjeQH7f0qTz
         drSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ekYNeHLDyYQ/qWETVipiFhBwDmDlj2s7iWCnbv0joSQ=;
        b=gI5kppHLfXdZKdF6VGqVn7RnCn+xIsk0ewhM1TgoJ6kRq/MnwaHzYTZYhMwuTa1YFZ
         PI6KH6pie6K8K+5UffyC+uv2kxSeodLMnYRrUTLrBZFaQurFxdQc+xpN5CrpbEToyhso
         3r2+zZc2wdCiPvAll0MP21WUGBzxYrkQKbZ7xF4O48oh+mUoosU5tJ4chDmdWYVcDFIf
         WlmLlWi55TZLcDX2MgkfUc9k8wRkCxX1B98YD92KXoTSFU2+9SsIetjGq1QfeCfSs6fB
         tXX9vBhbyrlT1Ppyxs3NBgmywxzT+PckkL3MCiMisd6R8GFY94ERBl+l0n/gs7hlmDNe
         2iSQ==
X-Gm-Message-State: AJIora8H9IAe2+7CSzHLdDrarPaUedfe/tr9Khsjs/fItPYyqAbMCxhG
        MyMEw+OGT5CrsqCXkaUZdM4b6/4SLTYb9Ep73Bi157zdFYA=
X-Google-Smtp-Source: AGRyM1vaoI29eWRvqUdfE7BBVkZaUWdpLMNwTFgIJzQqejC8dy3FWZLU/IJEWBHOoBqk2HFllrVTKdwwOGXGNuyBL8A=
X-Received: by 2002:a05:6402:2405:b0:43a:86c6:862 with SMTP id
 t5-20020a056402240500b0043a86c60862mr20484110eda.210.1658884019599; Tue, 26
 Jul 2022 18:06:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220722205400.847019-1-luiz.dentz@gmail.com> <20220722165510.191fad93@kernel.org>
 <CABBYNZLj2z_81p=q0iSxEBgVW_L3dw8UKGwQKOEDj9fgDLYJ0g@mail.gmail.com>
 <20220722171919.04493224@kernel.org> <CABBYNZJ5-yPzxd0mo4E+wXuEwo1my+iaiW8YOwYP05Uhmtd98Q@mail.gmail.com>
 <20220722175003.5d4ba0e0@kernel.org> <CABBYNZ+74ndrzdx=4dGLE6oQbZ2w6SGnUGeS0OSqH6EnND4qJw@mail.gmail.com>
 <20220726153140.7fefd4b4@kernel.org>
In-Reply-To: <20220726153140.7fefd4b4@kernel.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 26 Jul 2022 18:06:47 -0700
Message-ID: <CABBYNZJoAe+XDp_Zq4bfepizxpmUiB_Vo-ix1A2TyJXjzQVe+Q@mail.gmail.com>
Subject: Re: pull request: bluetooth-next 2022-07-22
To:     Jakub Kicinski <kuba@kernel.org>,
        Tedd Ho-Jeong An <hj.tedd.an@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, Jul 26, 2022 at 3:31 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 26 Jul 2022 15:05:17 -0700 Luiz Augusto von Dentz wrote:
> > > > Ive just fixup the original patch that introduced it, btw how do you
> > > > run sparse to capture such errors?
> > >
> > > We run builds with W=1 C=1 in the CI and then diff the outputs.
> > > That's pretty noisy so we have a regex which counts number of
> > > warnings per file, that makes it possible to locate the exact new
> > > warning. At least most of the time...
> >
> > Hmm, is there any way to trigger net CI, either that or we need to
> > duplicate the same test under our CI to avoid these last minute
> > findings when we are attempting to merge something.
>
> The code is at:
>
> https://github.com/kuba-moo/nipa
>
> But it hardcodes net and bpf tree maching in places. You may want
> to steal just the build script, its in bash.

We can either incorporate it on our own CI or start to consolidate
everything in one place since there are quite a few tests that apply
tree wide, though we would need to add support for subsystem specific
tests as well, anyway I leave for @Tedd Ho-Jeong An to comment on this
when he is back from vacation.

> > > > So we don't need to rebase?
> > >
> > > No, not usually. After we pull from you, you should pull back from us
> > > (git pull --ff-only $net-or-net-next depending on the tree you
> > > targeted), and that's it. The only patches that go into your tree then
> > > are bluetooth patches, everything else is fed via pulling back from us.
> > >
> > > > There were some patches already applied via bluetooth.git so at least
> > > > I do it to remove them
> > >
> > > Normally you'd not apply bluetooth fixes to bluetooth-next, apply
> > > them to bluetooth and send us a PR. Then once a week we'll merge
> > > net (containing your fixes) into net-next, at which point you can
> > > send a bluetooth-next PR and get the fixes into bluetooth-next.
> > > FWIW from our perspective there's no limit on how often you send PRs.
> >
> > Are you saying we should be using merge commits instead of rebase then?
>
> Not sure what merge commits would mean in this case.
>
> > > Alternatively you could apply the fixes into bluetooth and then
> > > merge bluetooth into bluetooth-next. If you never rebase either tree,
> > > git will be able to figure out that it's the same commit hash even if
> > > it makes it to the tree twice (once thru direct merge and once via
> > > net). That said, I believe Linus does not like cross tree merges, i.e.
> > > merges which are not fast forwards to the downstream tree. So it's
> > > better to take the long road via bt ->  net -> net-next -> bt-next.
> >
> > Well I got the impression that merge commits shall be avoided, but
>
> There's many schools of thought, but upstream there's very little
> rebasing of "official" branches (i.e. main/master branches, not
> testing or other unstable branches) AFAIK.
>
> > rebase overwrites the committer, so the two option seem to have
> > drawbacks, well we can just resign on rebase as well provided git
> > doesn't duplicate Signed-off-by if I use something like exec="git
> > commit -s --amend".
>
> Sure, be careful tho because I think it doesn't check the signoff
> history, IIRC just the most recent tag. So you may end up with multiple
> signoffs from yourself and Marcel.

Yep, I thought that was a bug though since I doubt there is any use
for duplicated signoffs.

> > > > and any possible conflicts if there were
> > > > changes introduced to the bluetooth directories that can eventually
> > > > come from some other tree.
> > >
> > > Conflicts are not a worry, just let us know in the PR description how
> > > to resolve them.
> >
> > Not really following, how can we anticipate a merge conflict if we
> > don't rebase?
>
> If your trees are hooked up to linux-next (I presume not 'cause Stephen
> would probably scream at you for rebasing?) - Stephen will tell you
> there's a conflict within a day or two.
>
> Obviously sometimes you'll notice right away when applying patches that
> two patches touch the same function.
>
> > With merge strategy it seem that the one pulling needs
> > to resolve the conflicts rather than the submitter which I think would
> > lead to bad interaction between subsystems, expect if we do a merge
> > [-> resolve conflict] -> pull request -> [resolve conflicts ->] merge
> > which sounds a little too complicated since we have to resolve
> > conflicts in both directions.
>
> The pulling back should always be a fast-forward so there's no merge
> commit or conflicts (git pull --ff-only). Only the actual downstream
> tree (netdev) has to resolve conflicts, which is not all that bad
> thanks for Stephen's advanced notices.
>
> > In my opinion rebase strategy is cleaner and is what we recommend for
> > possible clones of bluetooth-next and bluetooth trees including CI so
> > possible conflicts are fixed in place rather on the time the trees are
> > merged.
>
> No strong preference here as long as we can keep the sign-offs etc in
> control. Note that I'm not aware of any other tree we pull rebasing,
> tho, so you may run into unique issues.

Maybe I need to get in touch with other maintainers to know what they
are doing, but how about net-next, how does it gets updated? Is that
done via git merge or git pull alone is enough?

-- 
Luiz Augusto von Dentz
