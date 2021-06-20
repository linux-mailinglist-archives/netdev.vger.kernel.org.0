Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0543ADF84
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 18:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbhFTQzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 12:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhFTQzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 12:55:39 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BE8C061760
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 09:53:24 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id w23-20020a9d5a970000b02903d0ef989477so15196657oth.9
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 09:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KBSK5BDIsCMNz9bc8GLKLdo+Ap/vnD5AogXOfbro2gw=;
        b=EY15S+S88uvaAi0Mar9WDE/7G62lxZDb2y/9YiX6OJ+KMwYxgsazUvD0D2T7b7oFUz
         LMBdDsjxp9gSl7QVYUi9jTFUpL2CLBg1bmXxDSePW5Sc7DXM9UtfEdIYW3TOS+AU6rgG
         4+rTM25LJihtk/qLrL2mLoHJlDAIzL8M1E71wLgSqDBOKjIyJ01THIWOmGgbNcBcxpAu
         9pqeYLsfMgfombvcMlK9X4+3evh3FaXQ5Bpd8n5hyFvZdLl5LKUrAI5SSdYGlvxfxv0z
         qQaHZNiTQofYm0JCIfVGCfEga3TH5NZIvPB1RnQOGCEAQlL+354stqGov4BCQBjJN3Vr
         82yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KBSK5BDIsCMNz9bc8GLKLdo+Ap/vnD5AogXOfbro2gw=;
        b=LVaL6AE0n++OTxWFPD7UQhF4bA4XcpqFEB9b0aAqqeX38pLQgf2a06vSf+Kh/ZBK9b
         XpLb/Zs/XnOEDyjSZVVbxtF5+B06eRnK2zTMHnmtZ9o/2L4OHJOlT4+K8zfrHolWslbu
         Dx2Yu7RFqcqJ4CPPxFcB/buwLzd/9WZbMvg8wCCALaPOiEE6CnsBSMb3hfJmpLHWSmJK
         4GySkhjg2gH8QN4MmTpf8oYGnGu6+6H97Lb0Ocquarhkvj7gM1Z7EyZYOP+6vlcVg2bC
         6PdXO6e4/RC76T5oLjCzn82bbYtn2zQLQv3vMoBbl8S50eii50lUyvvP2gtdfUBDFoxh
         yDMA==
X-Gm-Message-State: AOAM533eTV+mb5XmYV8YewZV3bHdx9AeTWyJZ+n61GzTB4RCj2rFgnI4
        THUW1FERNVmL3JWWcuV06qSNpi84Sk7JRZpfrUY=
X-Google-Smtp-Source: ABdhPJxjuViMX9qpgCGp1l9NnFwnznDqdYFwMthoZwNc9RguBP191U1pRFKYBhveYRV1AjbKVUMsMVkYYHV8BfJsNks=
X-Received: by 2002:a05:6830:1f0a:: with SMTP id u10mr17795390otg.181.1624208003935;
 Sun, 20 Jun 2021 09:53:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210615003016.477-1-ryazanov.s.a@gmail.com> <20210615003016.477-7-ryazanov.s.a@gmail.com>
 <CAHNKnsR5X8Axttk_YX=fpi5h6iV191fLJ6MZqrLvhZvPe==mXA@mail.gmail.com> <1d31c18cebf74ff29b5e388c4cd26361@intel.com>
In-Reply-To: <1d31c18cebf74ff29b5e388c4cd26361@intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sun, 20 Jun 2021 19:53:16 +0300
Message-ID: <CAHNKnsTd6e2Ydh5axNVanYCLsRbqoE4kLJFvGiGcH9SYKcu9fg@mail.gmail.com>
Subject: Re: [PATCH net-next 06/10] net: iosm: drop custom netdev(s) removing
To:     "Kumar, M Chetan" <m.chetan.kumar@intel.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linuxwwan <linuxwwan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 20, 2021 at 6:42 PM Kumar, M Chetan
<m.chetan.kumar@intel.com> wrote:
>> On Tue, Jun 15, 2021 at 3:30 AM Sergey Ryazanov
>> <ryazanov.s.a@gmail.com> wrote:
>>> Since the last commit, the WWAN core will remove all our network
>>> interfaces for us at the time of the WWAN netdev ops unregistering.
>>> Therefore, we can safely drop the custom code that cleaning the list
>>> of created netdevs. Anyway it no longer removes any netdev, since all
>>> netdevs were removed earlier in the wwan_unregister_ops() call.
>>
>> Are you Ok with this change? I plan to submit a next version of the series. If
>> you have any objections, I can address them in V2.
>
> Changes looks fine.
>
>> BTW, if IOSM modems have a default data channel, I can add a separate
>> patch to the series to create a default network interface for IOSM if you tell
>> me which link id is used for the default data channel.
>
> Link id 1 is always associated as default data channel.

Thank you, will add default interface creation with this Id in the V2 series.

> Thanks,
> Reviewed-by: M Chetan Kumar <m.chetan.kumar@intel.com>

-- 
Sergey
