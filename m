Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8862AA763
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 19:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgKGSQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 13:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbgKGSQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 13:16:52 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7CCC0613CF;
        Sat,  7 Nov 2020 10:16:50 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id v144so6453809lfa.13;
        Sat, 07 Nov 2020 10:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2LwqPjMniJ2bHWhYS+H6mmpx9vI82/bTwD9mpgG2kIc=;
        b=fme4JUJVSfEiDvUNK1tsOGLhCEr8WIpvvKHZzARmRasGQ8nIFEJARvYZg/MjG/ps1T
         szb/6Bh86gGgjZkwqnHyCepUCdaC1/ocueYJGfKU4cI1uvgprfWf+pokCMIgschYnn1X
         pSyMc4yDDI22nfaEM222OXZP3dfbfF7jWJ3bdejbr32LHnX169sY3hm1Tc7E1xIyiHpu
         8TK4bg7S8iWmrxbvfa/jIUFTLshWKuIFI3h7Wto9pLSsdUKg8udu/2XssE0t2aBy/aOf
         A2IrsK7y64pXOSPnNCt3KW8LIw/LEPe/pjbPq1gUzhwxJw9DSIU4GJeKKSAAqu+IIZqX
         8Vuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2LwqPjMniJ2bHWhYS+H6mmpx9vI82/bTwD9mpgG2kIc=;
        b=IkyFvDKRnHJ5o1gMnxiwiBd6hxYeozycAvXYhsvEl9fxQU0f/vBBd7zGQoRIZ7WKjw
         3kOE2RhgvnaiBGi9hgIUPzpyb6HQLrUcuhY+SgN6BLhIf+gVCqYsN8dHw5dUEsz1FdRk
         79iERzRxW7WdLZIHDU2UbP7l8qhkoRvCOFuRqBdB6YLJ7ACe8cWiS60uyuzezMB+h3Yr
         13THtlMN4TsVHHL9ObpClFHAWnxVGev8vXRNA2E8u9Us3jL79CXuLWM+v+/Cdnbu5mFv
         yMVjJ4ZuQCG3sb85dMIEPbFsLT6Gnae0HBjO0sAOjqq09xvao21bu0Wjalw/AJhdOKqY
         tC8w==
X-Gm-Message-State: AOAM530YhZVNowCeLbLmhsFLVKSpwmPXHB08lr7hVK6hUWnBLpm3T9Tz
        Ahy7Sfydai9JsXVHQznWV3ZCH/dq/W7vR/2E8o8=
X-Google-Smtp-Source: ABdhPJzpf1N1aAxilU+Bqa1H1z/PRlW8XyEItapPopXnFACuXlVupfppOd7pM0FTTKXb6dkMhNHm/EZncUmY7fFHbNo=
X-Received: by 2002:ac2:5e23:: with SMTP id o3mr691432lfg.52.1604773008794;
 Sat, 07 Nov 2020 10:16:48 -0800 (PST)
MIME-Version: 1.0
References: <20201107172152.828-1-ap420073@gmail.com> <20201107172152.828-18-ap420073@gmail.com>
 <175a3cc2738.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <175a3cc2738.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sun, 8 Nov 2020 03:16:37 +0900
Message-ID: <CAMArcTVgw3hN=ffb88hYrOy5jD1W+V1XKDtd_Rs2mkoOSGj5Vw@mail.gmail.com>
Subject: Re: [PATCH net v2 17/21] brcmfmac: set .owner to THIS_MODULE
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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
        jukka.rissanen@linux.intel.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chung-hsien.hsu@infineon.com,
        wright.feng@infineon.com, chi-hsien.lin@infineon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 8 Nov 2020 at 02:41, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
>

Hi Arend,
Thank you for the review!

> On November 7, 2020 6:25:15 PM Taehee Yoo <ap420073@gmail.com> wrote:
>
> > If THIS_MODULE is not set, the module would be removed while debugfs is
> > being used.
> > It eventually makes kernel panic.
>
> Is this really a valid concern in the context of debugs? I tend to say it
> is not. Whenever I am using debugs to debug my driver I make sure to avoid
> removing it.

I think getting rid of every scenario of the kernel panic is the
first priority thing.
So I'm sure that trying to avoid kernel panic is always valid even
in the debugging context.

Thanks a lot!
Taehee Yoo
