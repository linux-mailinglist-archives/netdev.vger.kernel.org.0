Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD18217224
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 17:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730247AbgGGP3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 11:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730052AbgGGP3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 11:29:20 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928D0C061755;
        Tue,  7 Jul 2020 08:29:19 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id t25so45801430lji.12;
        Tue, 07 Jul 2020 08:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=aOe0/CpihO2VIfvM8hUlVWaFQmkSk5Jbw/jxFFeo+2o=;
        b=kReXtNmNceWx33PM1PSiLuGzG2FrbrwPIO/v5cj1LeAKGBuzqmz96bUOGQYV9XbC7X
         U6gYu+y86H9ysG7L55OKcem11J5zWyaJLVptbSUBaIq1A1qr5q3VVY3+oPxCYeNu1i5e
         ydNCqlPOzR0OEuobS5kRqKrkkZMOSHHEW0usvIIXJ71INAIQVAxBy7BbppSo2Ic1RLVu
         pVKFPtEhhdpeYhbaMnyNxqwOsr3Okm503mSBffbx8xRoCwk3bfgdGKI/ntwPruDftN2q
         rIDKn8kQQOWHhlwPA9dy/HTwVvPYG0+7a5dlkMV8CV1yN5Jt7hNf0I7MarACYbF+dpHH
         pySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=aOe0/CpihO2VIfvM8hUlVWaFQmkSk5Jbw/jxFFeo+2o=;
        b=okBuhvRdOANV5QO7lDg8inTa5CJVaOB/rzI3fKoOHovE56Jp+OsQ8Otg9uDxB1IpDK
         2cX4I7KESBY+uEjFfySpwt+6My+RubWb7RFUjGEQBAYdiWuth4Zqs+y9DDbu6IzxEILw
         Gs/9gqLt/b9DswcyVZTYn9WBEIDumUonnpequq3WdcEA0BRm6KyCXB1r5ZeQAvwY4pTg
         ZJn9TjkPL8MHniQQn54jNpBpZuNYSvzK10f33KDoCeenXx1IafUC3sVRpwwabnsBQsep
         +ZJVJEuMazo0Nw3phOeBbBymdmgB1+YIUraS1zZe5Oql8hm5Bx/tqQ3k9/mj0UvcQToH
         SSNw==
X-Gm-Message-State: AOAM532lON4XqyV2vE8BQWhYAGwUPKrRTxby//RAV6mZwvkUmLvyV1dn
        LDryEmrEoQXUiG7Y4PZ7/5Y=
X-Google-Smtp-Source: ABdhPJwv1tAgI6rbclWsOjFbxi3JDULa6B+l7yukn8Wrt3EHS1QlktEbGpLyDRjab+9ZtbCOWa+TxA==
X-Received: by 2002:a2e:97d7:: with SMTP id m23mr19667067ljj.103.1594135758018;
        Tue, 07 Jul 2020 08:29:18 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id 24sm9612947lfy.59.2020.07.07.08.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 08:29:16 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, andrew@lunn.ch
Subject: Re: [PATCH  1/5] net: fec: properly support external PTP PHY for
 hardware time stamping
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200706142616.25192-2-sorganov@gmail.com>
        <20200706150814.kba7dh2dsz4mpiuc@skbuf> <87zh8cu0rs.fsf@osv.gnss.ru>
        <20200706154728.lfywhchrtaeeda4g@skbuf> <87zh8cqyrp.fsf@osv.gnss.ru>
        <20200707070437.gyfoulyezi6ubmdv@skbuf>
Date:   Tue, 07 Jul 2020 18:29:14 +0300
In-Reply-To: <20200707070437.gyfoulyezi6ubmdv@skbuf> (Vladimir Oltean's
        message of "Tue, 7 Jul 2020 10:04:37 +0300")
Message-ID: <87pn978hth.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> On Mon, Jul 06, 2020 at 09:33:30PM +0300, Sergey Organov wrote:

[...]

>
>> I'll then make these 2 changes separate in v2 indeed, though I'm not
>> aware about Fixes: tag and if I should do something about it. Any clues?
>> 
>
> Add these 2 lines to your .gitconfig file:
>
> [pretty]
> 	fixes = Fixes: %h (\"%s\")
>
> Then use $(git blame) to find the commit which introduced the bad
> behavior. I was able to go down back to this commit, which I then tagged
> as follows:
>
> git show 6605b730c061f67c44113391e5af5125d0672e99 --pretty=fixes
>
> Then you copy the first line of the generated output to the patch, right
> above your Signed-off-by: tag. Like this:
>
> Fixes: 6605b730c061 ("FEC: Add time stamping code and a PTP hardware clock")
>
> Note that the offending commit has been obscured, in the meantime, by
> refactoring commit ff43da86c69d ("NET: FEC: dynamtic check DMA desc buff
> type"). That doesn't mean that the Fixes: tag should point to the newest
> commit touching the code though. In case where the refactoring is recent
> though (not this case), Greg will send an email that backporting failed,
> and you can send him a follow-up with a patch adjusted for each
> individual stable tree where adjustments need to be made. You can also
> ignore Greg's email, if you don't care about old stable trees.
>
> In this particular case, the original offending commit and the one
> obscuring it were included first in the following kernel tags:
>
> $(git tag --contains 6605b730c061): v3.8
> $(git tag --contains ff43da86c69d): v3.9
>
> But, if you look at https://www.kernel.org/, the oldest stable tree
> being actively maintained should be 3.16, so v3.8 vs v3.9 shouldn't make
> any difference because nobody will try to apply your fix patch to a tree
> older than 3.9 anyway.
>
> When sending a bugfix patch, there are 2 options:
>
> - You send the patch to the linux-stable mailing list directly. For
>   networking fixes, however, David doesn't prefer this. See below.
>
> - You send the patch to the netdev list (the same list where you sent
>   this one), but with --subject-prefix "PATCH net" so that it gets
>   applied to a different tree (this one:
>   https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git as
>   opposed to this one:
>   https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git).
>   The "net" tree is periodically merged into "net-next". Because your
>   patch series will have to be split, there are 2 options: either you
>   send your bugfix patches first, wait for them to be merged, and then
>   for "net" to be merged into "net-next", or try somehow to make sure
>   that the patches for "net" and for "net-next" can be applied in
>   parallel without interfering and creating merge conflicts. I think you
>   can do the latter.
>
> Whatever you do, however, please be sure to copy Richard Cochran to
> PTP-related patches, he tends to have a broader picture of the 1588 work
> that is being done throughout the kernel, and can provide more
> feedback.

Thanks a lot for thorough explanations and for finding the offensive
commit for me!

I'll then start with sending that separate patch as bug-fix with "PATCH net"
subject prefix, and then will re-send v2 of the series to net-next (with
just "PATCH v2") later, as soon as I collect all the feedback. I expect
no merge conflicts indeed.

Sounds like a plan!

Thanks again,
-- Sergey
