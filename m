Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E0646B1F8
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 05:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbhLGEpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 23:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236121AbhLGEpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 23:45:00 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3539CC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 20:41:31 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id v203so37441680ybe.6
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 20:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gQmS1eZXMjFXQ6CRp24Vvh1/l5Pgkji8KwOC/o5Ish0=;
        b=QFnWlF6VB5Ml8jvWN2Q2x4ccDws39CVa9cX6KtOO+DpU52rmSozjk9sKppgK1o7ZyR
         5Avl2WxOs39ZQozFwc+Z20b5TSIuFczjCeaZ+Ms5wFenPsHPL607p8N4c4DCvIACg5Od
         azm/vexT1UfXMSPrSYi041nKNd+ohG5UrrDpal4G1z5g+NtQLkylwLKDN0ZaKTCmmQM6
         syol8Cv/v7NROQ+GeOQOtCrZkK8v326qxdL9dCd/z+oO0X6/8/Lwf/yI3OcwypHFNK4D
         GFf6Bb/g5QXy+ZoQxPR2TTa3ewhTHsmqFF/VW+xTyHs6U+ArF3g4jJOmUhnBegLGhOnO
         w2hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gQmS1eZXMjFXQ6CRp24Vvh1/l5Pgkji8KwOC/o5Ish0=;
        b=7lT3GkcukR48/tJ90o0KK/JCwfE4qEGEVr798zPAuVadaaVWmDLrC9u9L5/j/WoS3y
         FsKk3YXNMl+/o9fSLSyEg3iHztykupcpPoHZKtQO4HmgLVsAmDmuR2f5+MqB6+5di2Bh
         8yb3TZ6nObmtP0nGrRqfCzqR6WOxNm+dMs4Uqe1u4Kpti8i93uN/q8Be+qxIlv5sczJ1
         7qojx/kwq90zK8dpUuKEnvNIt0kSYpP+5rBSIhKnIm3NnFmTpwAAF2w1hcS3yKRsGttl
         70KPfbix/dt2mgcNez7hJ4HsQIV9piytLJMN5KkFaf3I44fs+n9Eh3e0kMYY7sOfxr8w
         o60A==
X-Gm-Message-State: AOAM532Th5z2SqLqWskZnUWikjbdUKG1Tl6XBOdrwNZlD888b5QVBpBI
        jwmoYJdvgwux0PuPLsnwGoaMQx9TxVszOsg5M+RqzBV0bs0hXw==
X-Google-Smtp-Source: ABdhPJyml5B5lQI5oOqGpORBjyAehSlWSqR0NaFNADztHOwuK1NV2AAoyJ7E3cuTvFrERnLIrjBts+heIv+Bl7+DQCk=
X-Received: by 2002:a5b:5c3:: with SMTP id w3mr28812154ybp.293.1638852089522;
 Mon, 06 Dec 2021 20:41:29 -0800 (PST)
MIME-Version: 1.0
References: <cover.1638849511.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1638849511.git.lucien.xin@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 6 Dec 2021 20:41:18 -0800
Message-ID: <CANn89iJyiDbGdvm-oNKBBk5r3-0+3h+3ui1pL3rOTrz2BOztmA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] net: add refcnt tracking for some common objects
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 6, 2021 at 8:02 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> This patchset provides a simple lib(obj_cnt) to count the operatings on any
> objects, and saves them into a gobal hashtable. Each node in this hashtable
> can be identified with a calltrace and an object pointer. A calltrace could
> be a function called from somewhere, like dev_hold() called by:
>
>     inetdev_init+0xff/0x1c0
>     inetdev_event+0x4b7/0x600
>     raw_notifier_call_chain+0x41/0x50
>     register_netdevice+0x481/0x580
>
> and an object pointer would be the dev that this function is accessing:
>
>     dev_hold(dev).
>
> When this call comes to this object, a node including calltrace + object +
> counter will be created if it doesn't exist, and the counter in this node
> will increment if it already exists. Pretty simple.
>
> So naturally this lib can be used to track the refcnt of any objects, all
> it has to do is put obj_cnt_track() to the place where this object is
> held or put. It will count how many times this call has operated this
> object after checking if this object and this type(hold/put) accessing
> are being tracked.
>
> After the 1st lib patch, the other patches add the refcnt tracking for
> netdev, dst, in6_dev and xfrm_state, and each has example how to use
> in the changelog. The common use is:
>
>     # sysctl -w obj_cnt.control="clear" # clear the old result
>
>     # sysctl -w obj_cnt.type=0x1     # track type 0x1 operating
>     # sysctl -w obj_cnt.name=test    # match name == test or
>     # sysctl -w obj_cnt.index=1      # match index == 1
>     # sysctl -w obj_cnt.nr_entries=4 # save 4 frames' calltrace
>
>     ... (reproduce the issue)
>
>     # sysctl -w obj_cnt.control="scan"  # print the new result
>
> Note that after seeing Eric's another patchset for refcnt tracking I
> decided to post this patchset. As in this implemenation, it has some
> benefits which I think worth sharing:
>

How can your code coexist with ref_tracker ?

>   - it runs fast:
>     1. it doesn't create nodes for the repeatitive calls to the same
>        objects, and it saves memory and time.
>     2. the depth of the calltrace to record is configurable, at most
>        time small calltrace also saves memory and time, but will not
>        affect the analysis.
>     3. kmem_cache used also contributes to the performance.

Points 2/3 can be implemented right away in the ref_tracker infra,
please send patches.

Quite frankly using a global hash table seems wrong, stack_depot
already has this logic, why reimplement it ?
stack_depot is damn fast (no spinlock in fast path)

Seeing that your patches add chunks in lib/obj_cnt.c, I do not see how
you can claim this is generic code.

I don't know, it seems very strange to send this patch series now I
have done about 60 patches on these issues.

And by doing this work, I found already two bugs in our stack.

You can be sure syzbot will send us many reports, most syzbot repros
use a very limited number of objects.

About performance : You use a single spinlock to protect your hash table.
In my implementation, there is a spinlock per 'directory (eg one
spinlock per struct net_device, one spinlock per struct net), it is
more scalable.

My tests have not shown a significant cost of the ref_tracker
(the major cost comes from stack_trace_save() which you also use)
