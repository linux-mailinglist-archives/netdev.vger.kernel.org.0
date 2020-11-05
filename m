Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAD52A78A2
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 09:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgKEIOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 03:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgKEIOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 03:14:49 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3078C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 00:14:48 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id 12so457349qkl.8
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 00:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sRLQZLV5AAEJdg5z+nUEGt1aueBHFzjXY3h/fPZa42w=;
        b=JGCjpAc1JOHbHGhb5m1lBWu6D/+2KzLvKo/FPpnLPss2q8WgnxywPKenahv8G/uuaP
         rRn02yu79mCibjblo+W5zKS83/EB3R1G2cWN75g/BViatHX+9qqyVsO9tAJzjPK32DDz
         0Gu+2VRrqc7X5dqv7bvR/fXCceWtQMhe7J7WOsfSqpTcaRc0WXk2rAkFUVCQMD769leO
         JXiC9qJmsVXBF5mm6Debite3iTRBcxr471QiGpAnTVvMVKM9wAbuIOdg6czRYGCsiXpL
         a2NWj4RI+Gy4LRvbFPmR5nnaCvs0yGWDnEhCwwW9wCUM1A6nS7/Kmfj1rcywC44OSCnY
         jlEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sRLQZLV5AAEJdg5z+nUEGt1aueBHFzjXY3h/fPZa42w=;
        b=lMmOCspHb9oAqF54zksw1D0uWzfE4vOVMHWrjo6RGmzYcsf/qJqqaWgilayiVxS6ma
         HZ9xqhr7pa6BIOkyoI6dqqIImql1b+QvigSGFUHRwcfmGrLgzlcCw3X8DUCnCiKExp7r
         q8mC7pGjMX4L5CJx+iNwAH3x3ZF9yCgyyNHLiAhVx1yjbjwFpL9ChuVCa3ZCxxvY3gon
         s+UgTVA3YTHBVkd8WnJYRjEt+p23KID/TYASC9ECQFojrJy36Ex6//rPZlgFOMfdOzzS
         kTq9/0JedDxpOOlZHytLXcWfDF+s7+p5aDNvNfAtfszfq3946rWFVlI2msUhpLnBWhJd
         Kdbg==
X-Gm-Message-State: AOAM531Ik+qVRt1e3jq7VcYXT3sAl6G/9BgidZlmM301PFBcyCaH280z
        in/RceNjS2jr3hm7fcom+wXToyNuIR+Tzg==
X-Google-Smtp-Source: ABdhPJz50sxAS/uzdTPpwMGyHdrNMXBNEwe1NE6l7DQU8GxFKVW2wrcuL5hYUWEl3yRUz1H9kptakg==
X-Received: by 2002:ae9:c012:: with SMTP id u18mr1020418qkk.248.1604564088255;
        Thu, 05 Nov 2020 00:14:48 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f016:78d6:ae13:4668:2f4c:ca7a])
        by smtp.gmail.com with ESMTPSA id 129sm569116qkf.62.2020.11.05.00.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 00:14:47 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 5A8D8C639F; Thu,  5 Nov 2020 05:14:45 -0300 (-03)
Date:   Thu, 5 Nov 2020 05:14:45 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu@ucloud.cn
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/2] net/sched: act_frag: add implict packet
 fragment support.
Message-ID: <20201105081445.GQ3837@localhost.localdomain>
References: <1604562747-14802-1-git-send-email-wenxu@ucloud.cn>
 <1604562747-14802-2-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604562747-14802-2-git-send-email-wenxu@ucloud.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 03:52:27PM +0800, wenxu@ucloud.cn wrote:

We cross-posted :)
I think my comments on the v1 still applies, btw.

...
> This patch add support for a xmit hook to mirred, that gets executed before
> xmiting the packet. Then, when act_ct gets loaded, it configs that hook.
> The frag xmit hook maybe reused by other modules.
...
> --- a/include/net/act_api.h
> +++ b/include/net/act_api.h
> @@ -239,6 +239,29 @@ int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
>  			     struct netlink_ext_ack *newchain);
>  struct tcf_chain *tcf_action_set_ctrlact(struct tc_action *a, int action,
>  					 struct tcf_chain *newchain);
> +
> +#if IS_ENABLED(CONFIG_NET_ACT_FRAG)
> +int tcf_exec_frag_xmit_hook(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb));
> +void tcf_set_frag_xmit_hook(void);
> +void tcf_clear_frag_xmit_hook(void);
> +bool tcf_frag_xmit_hook_enabled(void);

Now it's naming the hook after frag action, but it's meant to be
generic. It got confusing on what is local to act_frag or not due to
that.

