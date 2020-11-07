Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBCE42AA7C9
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 20:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgKGTxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 14:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgKGTxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 14:53:08 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D505DC0613CF;
        Sat,  7 Nov 2020 11:53:07 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id l10so5252744lji.4;
        Sat, 07 Nov 2020 11:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1o9pISsOLKLuLtURoN/jnEm2wPXUEDDs1LQ4SBnuv20=;
        b=El52qMHlK3MmWAXIrGCcZHxQIfc1q81rwO6le4QwHD/xXbmWA8U0PntusgytJgiQad
         scRDACJ6mc66sDWyvvoEN7Ah1YmiYAV4SwLvD7JYXr+HMNiiQ4EkUnBnQFSo7J1nZOao
         5K+3WJyNDWCYlsqmHYru5tGxf4iZdzzYgBtXpZz3qwtl9L/scIfAtrBvrbHrM14Rl53K
         ayBmny8yHgNN4sDnlE3eJQvXHY3etdCunef3XnC9czygFjss3XpjLYZFzaAj5YEtuzic
         woD8c3uL0M/z2/5pA57b3UnJ2SLPsMFRCnyUkw5DYLoxggRFLQ03u/SGTRiWQiAw7Qn4
         XaWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1o9pISsOLKLuLtURoN/jnEm2wPXUEDDs1LQ4SBnuv20=;
        b=Y0I3FCJjSRPPH5WA6qa3xmuPKeh2eGyarVvePGOfHvU0qSqUwbD44tlrjzbCr0zJoR
         MQI3XwgV3Qh55B/08TjNYY7JngIa75a1m+73l0pbyD0LBxZUwKsnICGjNXW7NLy4du1W
         Ii2zQdxv/zJxgpyTdpGuxobKovGbz7aAIFHBf60kFy5AVeT6zhkiFqRij2uj9whH/Bgs
         D2jdsvA+S08twyipjDzVkf5Au4CDYdESoJySQ2Ytnyadd+2NGkgvlBMvFH5NyjKSCFiB
         ugV/mgINTVwvwBt5nbP3z6O2CZvoTPQYiCqdYypFu/RhDw6SgNXdqIqrlDXFVwbTa92+
         LBdQ==
X-Gm-Message-State: AOAM530bPWQ4GKIVsql5xW5tX7tl2v96rBMPU+7dxYCN4RZnjGGSECcy
        EToUB/xIo1Jc59By71ijFFm0ilRlwj7n0ZYOVkM=
X-Google-Smtp-Source: ABdhPJxlXh7cBfmapt5+aqZfn7Dpu+wE522gccaU0uquXhqKfkUeizFG7DF6WiiH9k5gzcJ2mgmwSRJYM89qyMT2N3g=
X-Received: by 2002:a2e:8110:: with SMTP id d16mr2715059ljg.280.1604778786156;
 Sat, 07 Nov 2020 11:53:06 -0800 (PST)
MIME-Version: 1.0
References: <20201107172152.828-1-ap420073@gmail.com> <20201107110522.2a796f1d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107110522.2a796f1d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sun, 8 Nov 2020 04:52:55 +0900
Message-ID: <CAMArcTXNMpjEnVA8sz82CTTnCofqEK+hUSSq27mvjqV6QCiAOQ@mail.gmail.com>
Subject: Re: [PATCH net v2 00/21] net: avoid to remove module when its debugfs
 is being used
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Nicolai Stange <nstange@suse.de>, derosier@gmail.com,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        b43-dev@lists.infradead.org, linux-bluetooth@vger.kernel.org,
        michael.hennerich@analog.com, linux-wpan@vger.kernel.org,
        stefan@datenfreihafen.org, inaky.perez-gonzalez@intel.com,
        linux-wimax@intel.com, emmanuel.grumbach@intel.com,
        Luciano Coelho <luciano.coelho@intel.com>, stf_xl@wp.pl,
        pkshih@realtek.com, ath11k@lists.infradead.org,
        ath10k@lists.infradead.org, wcn36xx@lists.infradead.org,
        merez@codeaurora.org, pizza@shaftnet.org,
        Larry Finger <Larry.Finger@lwfinger.net>, amitkarwar@gmail.com,
        ganapathi.bhat@nxp.com, huxinming820@gmail.com,
        marcel@holtmann.org, johan.hedberg@gmail.com, alex.aring@gmail.com,
        jukka.rissanen@linux.intel.com,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chung-hsien.hsu@infineon.com, wright.feng@infineon.com,
        chi-hsien.lin@infineon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 8 Nov 2020 at 04:05, Jakub Kicinski <kuba@kernel.org> wrote:
>

Hi Jakub,
Thank you for the review!

> On Sat,  7 Nov 2020 17:21:31 +0000 Taehee Yoo wrote:
> > When debugfs file is opened, its module should not be removed until
> > it's closed.
> > Because debugfs internally uses the module's data.
> > So, it could access freed memory.
> >
> > In order to avoid panic, it just sets .owner to THIS_MODULE.
> > So that all modules will be held when its debugfs file is opened.
>
> Hm, looks like some of the patches need to be revised because
> .owner is already set in the ops, and a warning gets generated.

Thanks, I found my mistake via patchwork.
I will fix this problem.

>
> Also it'd be good to mention why Johannes's approach was abandoned.

I'm sorry about skipping the explanation of the situation,
Johannes sent RFC[1], which fixes this problem in the debugfs core logic.
I tested it and it actually avoids this problem well.
And I think there would be more discussion.
So, I thought this series' approach is reasonable right now.
I think setting .owner to THIS_MODULE is a common behavior and it
doesn't hurt our logic even if Johannes's approach is merged.
I'm expecting that both approaches of this series and Johannes are
doing separately.

[1] https://www.spinics.net/lists/linux-wireless/msg204171.html

>
> When you repost please separate out all the patches for
> drivers/net/wireless/ and send that to Kalle's wireless drivers tree.
> Patch 1 needs to be split in two. Patches 2 and 3 would go via Johannes.
> The wimax patch needs to go to staging (wimax code has been moved).
> The remaining patches can be posted individually, not as a series.

Okay, I will do this.

Thanks a lot!
Taehee Yoo
