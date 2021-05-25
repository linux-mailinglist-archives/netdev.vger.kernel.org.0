Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D02390BCB
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 23:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbhEYVul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 17:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhEYVuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 17:50:37 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF08C061574
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 14:49:07 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id v12so17059228plo.10
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 14:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6svW/oDWDLT98MDexEuspJdEoNNdZul4DrRipuY5RVQ=;
        b=atSYYtWL0AUCDt/27/JfGmlkbqLnUdSUO5IF0zy8iRkxpZtupXcBGE4Nq7UxCfCz9W
         m2chTy5lm9j4Sqtk1UDQt5D5xw3hWmtIbg0b2i7p4LwBPCrg5HYT0Mm5bn6D1IFip/61
         hGLbR+NSchDeWb268LedSnYoQ+g/5HHPOXTdyhURrbkPUwS0uZFCUDJ9qeYvV9M6ozpe
         h7lCtufR28Et5wesDt1SPcxgeUrBt3zm4W+G8nfEbCaJlVNTFG4NgJnWPuuqt64bmJfR
         6YggqK+5FZn7u52qW+cyjswlkrXmPzzq0S4SVlBRufTnqgi8obBKvufKRhdu6UKf0XMc
         wKtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6svW/oDWDLT98MDexEuspJdEoNNdZul4DrRipuY5RVQ=;
        b=iXbWvlyuWkgdSSNsEaIgP8HAb9BvOFSP43mI49n2lUBmCocCUGyK8CFn3w8W6Grpni
         hSQWuDFKvS7DwZa5rfQHYaJ8mquCZHWAPoU4eLV205gdtZ/wYhTodbWMFyhhCXQkYGqC
         ZWYK/rVP/6k6pczAUO7HIqai8ixwyOcjchCJu71HiqnhjgQC/mWJEeGEFhdaHE7nn+Wp
         kzsAt6tju1R/IMWlFdBee8OIGzz/XU6K6HfxSxTZrYgy7wNJJtIMQtHyB8YLrOk3CBHA
         /4QyxfV5Bha1Mexko0C9JqWl9P4/a/aRg52EKy8jRRuDjGdvSvFzjm5MH5bo/a+p6htS
         igEg==
X-Gm-Message-State: AOAM5329C1bmfEab/qaFdcmMKR85kzBy1RPUABHWed8A30gEqpSEb6dq
        chdiMBVjCPvPjXKwZsPRJ0+cbrQY8tE2/GKSZOCbq4Uixr0/RQ==
X-Google-Smtp-Source: ABdhPJyOPqPO+N91L9xZk5aue8Z3SjnR7AFuwI34gLOl65u5EdLCUP/FZWIZkNy9F1oftDZeFzewpcddpKzjmc9pbEo=
X-Received: by 2002:a17:902:a60a:b029:f0:ad94:70bf with SMTP id
 u10-20020a170902a60ab02900f0ad9470bfmr32612502plq.31.1621979346580; Tue, 25
 May 2021 14:49:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210525132152.2589420-1-vladbu@nvidia.com>
In-Reply-To: <20210525132152.2589420-1-vladbu@nvidia.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 25 May 2021 14:48:55 -0700
Message-ID: <CAM_iQpUtGw5MO0DAWkVuHP7PU-iSkmEsBWa+SkCqiZtB3eeSoQ@mail.gmail.com>
Subject: Re: [PATCH net v2] net: zero-initialize tc skb extension on allocation
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Florian Westphal <fw@strlen.de>, wenxu <wenxu@ucloud.cn>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 6:22 AM Vlad Buslov <vladbu@nvidia.com> wrote:
>
> Function skb_ext_add() doesn't initialize created skb extension with any
> value and leaves it up to the user. However, since extension of type
> TC_SKB_EXT originally contained only single value tc_skb_ext->chain its
> users used to just assign the chain value without setting whole extension
> memory to zero first. This assumption changed when TC_SKB_EXT extension was
> extended with additional fields but not all users were updated to
> initialize the new fields which leads to use of uninitialized memory
> afterwards. UBSAN log:

Hm, I thought the memset() in __skb_ext_alloc() does the job, clearly
I was wrong.

[...]
>
> Fix the issue by providing new function tc_skb_ext_alloc() that allocates
> tc skb extension and initializes its memory to 0 before returning it to the
> caller. Change all existing users to use new API instead of calling
> skb_ext_add() directly.

Just a note: struct tc_skb_ext is currently only 8-byte long, so memset()
it should not be a problem for performance.

>
> Fixes: 038ebb1a713d ("net/sched: act_ct: fix miss set mru for ovs after defrag in act_ct")
> Fixes: d29334c15d33 ("net/sched: act_api: fix miss set post_ct for ovs after do conntrack in act_ct")
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>

Acked-by: Cong Wang <cong.wang@bytedance.com>

Thanks.
