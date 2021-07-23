Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F44F3D383F
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 12:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbhGWJTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 05:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbhGWJTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 05:19:34 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0F5C061575;
        Fri, 23 Jul 2021 03:00:07 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id m24so997460edp.12;
        Fri, 23 Jul 2021 03:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZpV/vhONNALORyd7/Lzj0LakU5S+Xd5zMk4SZvs6RU4=;
        b=C3gTWjAIVXsJ4l7MrNGFHWpm+9NAtWTyOYv1gLDC2Is/bpbyYO31SXCbabv0iIItbv
         DWS6UpYh+hAYbrO+H2hp/7BxPtBtjX3CVJpBGNuBZsjNbZDlpOGoM1NEcjv0I6nlFUIk
         hh+eUrgUM+y6uEeLV9/Cwqv/TtZoqxrCD7KzzyAk7d5I31yGpkjPWAf0CSFBEBd5izHo
         gqr4dLVkDNskq6a40gGnSOVpvOcaM9zuCHvkQ7cYX0el5EL2tpYJlTSvBWnn5vTC3h4n
         kM+aVZJ6Qdf+j9TGk2iccKz5VWt4nbUbFLnqr3B1WxvHLrC3mv1VkCq3RlCf10ggCJb3
         IF5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZpV/vhONNALORyd7/Lzj0LakU5S+Xd5zMk4SZvs6RU4=;
        b=XNotwsh2TjhnPw5pRs4OlCRc7U74c4SjArTLH9FdJrWlLcIU1LZhaCcFNBjuAMLbTv
         26PBbKCp9AtKREWeEK6CYIA9sDbpfm37pIggZFmwFvA8CshITCofgHkF6Iv2VxEOuZj0
         NvdfFurVNfKMOxWXi1tFIwx/AbyIS8tSTNlSfLHJowLoV5pStOPCKLC5gzZGPsnTQWzc
         umqvHs/ucQaCd7I5s4zzYedxys47frb/f7MuV2EXaSSIcLUo6YABtxCD3VuL2abf7wSv
         FVzI6wXk4aOjIWgnGdD0mSYJ8GuZuCaN558VDbXfECUGAMIAWGnj0H53pOwdNOOuu2oQ
         Z6xw==
X-Gm-Message-State: AOAM533b5vojx+TCba3NTi6+qVp1z/2bWWSXMdrS0dvhbd2C1Ud/yh+Q
        oNowZEdGlbyr2KHzcpd3acy0/wne9TX0m7b1MdU=
X-Google-Smtp-Source: ABdhPJwmJ5S6cM321VniOs3i8XtSQTT+mmPx00cCX2ciWS4LDxVGR9JZeJeFJ8g6TDTiNcVVhr/9AYLYFdyrKl9UIvs=
X-Received: by 2002:a05:6402:2228:: with SMTP id cr8mr4644804edb.309.1627034405768;
 Fri, 23 Jul 2021 03:00:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210723050919.1910964-1-mudongliangabcd@gmail.com>
 <d2b0f847dbf6b6d1e585ef8de1d9d367f8d9fd3b.camel@sipsolutions.net>
 <CAD-N9QWDNvo_3bdB=8edyYWvEV=b-66Tx-P6_7JGgrSYshDh0A@mail.gmail.com>
 <11ba299b812212a07fe3631b7be0e8b8fd5fb569.camel@sipsolutions.net>
 <CAD-N9QWRNyZnnDQ3XTQ_SAWNEgiMCJV+5Z69eHtRVcxYtXcM+A@mail.gmail.com> <e549fbb09d7c618762996aca4242c2ae50f85a5c.camel@sipsolutions.net>
In-Reply-To: <e549fbb09d7c618762996aca4242c2ae50f85a5c.camel@sipsolutions.net>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Fri, 23 Jul 2021 17:59:39 +0800
Message-ID: <CAD-N9QV02fnr8LLSwxTuyevYgkL_2aicO2b_7uZ46s6BGKaTmw@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: free the object allocated in wiphy_apply_custom_regulatory
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        syzbot+1638e7c770eef6b6c0d0@syzkaller.appspotmail.com,
        linux-wireless@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 5:42 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> Hi,
>
> On Fri, 2021-07-23 at 17:30 +0800, Dongliang Mu wrote:
> > if zhao in the thread is right, we don't need to add this free
> > operation to wiphy_free().
>
> Actually, no, that statement is not true.
>
> All that zhao claimed was that the free happens correctly during
> unregister (or later), and that is indeed true, since it happens from
>
> ieee80211_unregister_hw()
>  -> wiphy_unregister()
>  -> wiphy_regulatory_deregister()
>

Thanks for your explanation. Now the situation is more clear.

>
> However, syzbot of course is also correct. Abstracting a bit and
> ignoring mac80211, the problem is that here we assign it before
> wiphy_register(), then wiphy_register() doesn't get called or fails, and
> therefore we don't call wiphy_unregister(), only wiphy_free().

Yes, you're right. In this case, wiphy_register is not called. We
should not call wiphy_unregister() to clean up anything.

>
> Hence the leak.
>
> But you can also easily see from that description that it's not related
> to hwsim - we should add a secondary round of cleanups in wiphy_free()
> or even move the call to wiphy_regulatory_deregister() into
> wiphy_free(), we need to look what else this does to see if we can move
> it or not.

I agree to move the cleanup operation of regd to wiphy_free API.
That's the partial functionability of this function.

>
> johannes
>
