Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD0847811B
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 01:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbhLQAJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 19:09:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38392 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbhLQAJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 19:09:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E13261FCC;
        Fri, 17 Dec 2021 00:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65693C36AE2;
        Fri, 17 Dec 2021 00:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639699780;
        bh=C5x7dlzYqlBa9tkMwFYliVXcGc8Zs8qwaD1LORO8Sq4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qTlQcZ93/PlxEkGzuJ48NDWvWjhP6fyey/QnfGCB2/IBB2Evw+7/cAw9BFhLs0WVY
         Eg79NVI1Fyju6VRpwHcd3SU79jNP0rGTth80nvRQHmyF3lyg69PMI662U978oSAsmr
         HW1zKWqo/tRuSZFGYd8Wq2xWEgbIa/KwZ+tpmgLkAFpE/odRjdzZMMrEbdSCXsmWO7
         mMf0CIfH83NwehGY3sNK1SKEmhkeFKI7qHPodwlVbcgRLyPsS8mX/zff03CFrje7ei
         7lR1hUwWQoryej1adPRMUC/S71I+WB92LSGvRbZg6DGcgUFTLs16EJ2NrUHMmYeJlG
         HYzD4754Jn8WQ==
Date:   Thu, 16 Dec 2021 16:09:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [GIT PULL] Networking for 5.16-rc6
Message-ID: <20211216160939.41e8a2d2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAHk-=wi6GaYPTHHAaNEUtg6m=L6L0qjmJoPiKA5gOWKtdcOt-A@mail.gmail.com>
References: <20211216213207.839017-1-kuba@kernel.org>
        <CAHk-=whayMx6-Z7j7H1eAquy0Svv93Tyt7Wq6Efaogw8W+WpoQ@mail.gmail.com>
        <20211216154324.5adcd94d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAHk-=wi6GaYPTHHAaNEUtg6m=L6L0qjmJoPiKA5gOWKtdcOt-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Dec 2021 15:59:40 -0800 Linus Torvalds wrote:
> On Thu, Dec 16, 2021 at 3:43 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Very strange, I didn't fix it up, redo or anything, push the tree,
> > tag, push the tag, git request-pull >> email. And request-pull did
> > not complain about anything.  
> 
> You hadn't pushed the previous case by any chance? 'git request-pull'
> does actually end up going off to check the remote end, and maybe it
> saw a stale state (because the mirroring to the public side isn't
> immediate)?

Ah! I know.. I forgot to fetch your tree and used FETCH_HEAD 
in git request-pull which was at bpf :/

Sorry about that!

> > While I have you - I see that you drop my SoB at the end of the merge
> > message, usually. Should I not put it there?  I put it there because
> > of something I read in Documentation/process/...  
> 
> No, I actually like seeing the sign-off from remote pulls -
> particularly in the signed tags where they get saved in the git tree
> anyway (you won't _see_ them with a normal 'git log', but you can see
> how it's saved off if you do
> 
>     git cat-file commit 180f3bcfe3622bb78307dcc4fe1f8f4a717ee0ba
> 
> to see the raw commit data).
> 
> But I edit them out from the merge message because we haven't
> standardized on a format for them, and I end up trying to make my
> merges look fairly consistent (I edit just about all merge messages
> for whitespace and formatting, as you've probably noticed).
> 
> Maybe we should standardize on sign-off messages for merges too, but
> they really don't have much practical use.
> 
> For a patch, the sign-off chain is really important for when some
> patch trouble happens, so that we can cc all the people involved in
> merging the patch. And there's obviously the actual copyright part of
> the sign-off too.
> 
> For a merge? Neither of those are really issues. The merge itself
> doesn't add any new code - the sign-offs should be on the individual
> commits that do. And if there is a merge problem, the blame for the
> merge is solidly with the person who merged it, not some kind of
> "merge chain".
> 
> So all the real meat is in the history, and the merge commit is about
> explaining the high-level "what's going on".
> 
> End result: unlike a regular commit, there's not a lot of point for
> posterity to have a sign-off chain (which would always be just the two
> ends of the merge anyway). End result: I don't see much real reason to
> keep the sign-offs in the merge log.
> 
> But I _do_ like seeing them in the pull request, because there it's
> kind of the "super-sign-off" for the commits that I pull, if you see
> what I mean...
> 
> Logical? I don't know. But hopefully the above explains my thinking.

Yup, makes sense, thanks for explaining!
