Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92275478107
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 01:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhLQAAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 19:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbhLPX77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 18:59:59 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38349C061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 15:59:59 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id y12so1339417eda.12
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 15:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tMmdLqelQfDN42AiWuSsuO5C5WxV1INjNhnA3TXmgXs=;
        b=D2bVxUtgCXf3EO+5SZJTPlrFwTIPjBvYHWyaJpZVktccybzd2cbdmNVcqd5D1CqltC
         36mF98z811mqhITWlSu7Y7cpuL5ZAZhdTVt6nB9O3K9PsoLX6tmFCOVOvczsorTaFUZx
         nDDPByXFcEFcGlNs3+jszwoFf771ZpToNAcS8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tMmdLqelQfDN42AiWuSsuO5C5WxV1INjNhnA3TXmgXs=;
        b=2MEYXfRaUK+QmBt4xhH9XlpUvvcpNNksyykZCW98IQyagesGvvmkNTOM23YGth+pGi
         N2YCentq1oU+lZdBY15yOvPTjWf0EX4Yht+slX9GO9JUbayiVUguLuezIDVo2X5YDpTG
         DrLNdn7GhSgE/a+ciydCZEW7Tb8JZGg2qucT0AEnGUchbALp7Qf5CKPt6R0JZHeK5Zz9
         ZDlVcnyStQq92MAkjGnfC6ekAVtDFHSOniMCiJsKfYfH2r8HXijCHivAZFoeHZwcWYw2
         T59eHdNEawrxXoI3UnzdXcUrqkZvL0KJ76p3x/quTXcKepvlDs3mh/h+niIKSYPc3QhC
         K0pw==
X-Gm-Message-State: AOAM533UKInb/hG4tEwQjiHOqyjqrrxq2zDRrAAmGUVtEMEJcBOArO0G
        KOFWtaLSmRFAEXdlzGFqXvHZ7X6Hx3tNgCVV9Us=
X-Google-Smtp-Source: ABdhPJzJWtllnHol0E2ltpfbENdGNuM+KRtKwVx4dUal0nYrnNmNWdQvdATuGIN3zYP7paA0RPZM7Q==
X-Received: by 2002:a17:906:c9d2:: with SMTP id hk18mr371749ejb.523.1639699197634;
        Thu, 16 Dec 2021 15:59:57 -0800 (PST)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com. [209.85.128.53])
        by smtp.gmail.com with ESMTPSA id hq37sm2312876ejc.116.2021.12.16.15.59.57
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 15:59:57 -0800 (PST)
Received: by mail-wm1-f53.google.com with SMTP id z206so515483wmc.1
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 15:59:57 -0800 (PST)
X-Received: by 2002:a05:600c:4e07:: with SMTP id b7mr7190294wmq.8.1639699196732;
 Thu, 16 Dec 2021 15:59:56 -0800 (PST)
MIME-Version: 1.0
References: <20211216213207.839017-1-kuba@kernel.org> <CAHk-=whayMx6-Z7j7H1eAquy0Svv93Tyt7Wq6Efaogw8W+WpoQ@mail.gmail.com>
 <20211216154324.5adcd94d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211216154324.5adcd94d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 16 Dec 2021 15:59:40 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi6GaYPTHHAaNEUtg6m=L6L0qjmJoPiKA5gOWKtdcOt-A@mail.gmail.com>
Message-ID: <CAHk-=wi6GaYPTHHAaNEUtg6m=L6L0qjmJoPiKA5gOWKtdcOt-A@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for 5.16-rc6
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 3:43 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Very strange, I didn't fix it up, redo or anything, push the tree,
> tag, push the tag, git request-pull >> email. And request-pull did
> not complain about anything.

You hadn't pushed the previous case by any chance? 'git request-pull'
does actually end up going off to check the remote end, and maybe it
saw a stale state (because the mirroring to the public side isn't
immediate)?

> While I have you - I see that you drop my SoB at the end of the merge
> message, usually. Should I not put it there?  I put it there because
> of something I read in Documentation/process/...

No, I actually like seeing the sign-off from remote pulls -
particularly in the signed tags where they get saved in the git tree
anyway (you won't _see_ them with a normal 'git log', but you can see
how it's saved off if you do

    git cat-file commit 180f3bcfe3622bb78307dcc4fe1f8f4a717ee0ba

to see the raw commit data).

But I edit them out from the merge message because we haven't
standardized on a format for them, and I end up trying to make my
merges look fairly consistent (I edit just about all merge messages
for whitespace and formatting, as you've probably noticed).

Maybe we should standardize on sign-off messages for merges too, but
they really don't have much practical use.

For a patch, the sign-off chain is really important for when some
patch trouble happens, so that we can cc all the people involved in
merging the patch. And there's obviously the actual copyright part of
the sign-off too.

For a merge? Neither of those are really issues. The merge itself
doesn't add any new code - the sign-offs should be on the individual
commits that do. And if there is a merge problem, the blame for the
merge is solidly with the person who merged it, not some kind of
"merge chain".

So all the real meat is in the history, and the merge commit is about
explaining the high-level "what's going on".

End result: unlike a regular commit, there's not a lot of point for
posterity to have a sign-off chain (which would always be just the two
ends of the merge anyway). End result: I don't see much real reason to
keep the sign-offs in the merge log.

But I _do_ like seeing them in the pull request, because there it's
kind of the "super-sign-off" for the commits that I pull, if you see
what I mean...

Logical? I don't know. But hopefully the above explains my thinking.

                   Linus
