Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8580E2C48CF
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 21:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgKYUEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 15:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727458AbgKYUEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 15:04:12 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35573C0613D4
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 12:04:12 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id x25so4608966qkj.3
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 12:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jzAlOowt2xG0wPnV3mLaGL+Mx9do1jQHOJZV4RGSZmM=;
        b=aYLwC0XUC0u4zEXZUbvN83OiCjX7XyEPbIVkxW+e1loUHV1d4V4BAF6MR0VuC7fL1n
         wjq8vxpEVK/jlMY4QldC80sn66THcoClYuchn83q3q53I9VZyNqyzXZUzZO5MR/UY9GL
         bCVDPmqXCu58PV+i8xK+ApCUHgyOYpQm/2skjJH6duwcbnJon68vu+7UTecpPcT8TF/v
         00XGgJfyPuxVWV74749oBeJtEZ8oGkAPcgLvTNxoq2XAg7EfNtd6bTqjfw5TZEr439e/
         6dZ4YXAxXIQP/O/nLKHWoBqigI6AuEBYbVxvCYf5jZqee995ZsOkHU8NfIeCwHMsRhsE
         7dIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jzAlOowt2xG0wPnV3mLaGL+Mx9do1jQHOJZV4RGSZmM=;
        b=Zc46Y1cYy/OjkZgUjtaHb2z3pevLyW7mWx58XFvoXP7/SA5ym6UqCy+epp3HncjXcS
         rHXnIhU+x+OBUPMSpkZsKpatfWW2nAQ6AUOaC9UgY4CbdfTNsk9N8nn80Xnj7+QgmGIM
         tyLKgDJGaAWg+kHVBR/XdARI6xsO0zfCoUVB3jOigHWFtluKXXcy2N9oWtiHXgEfeoUE
         q0TtsTHs+/qdTG5W390y03u5F2LxpC6jctwsUE5sCmFWK6Q+aP0u4aVIsCW/0+yXWeTc
         1Y6A6W4SC9QTjjRhQeRgiiZmBDE8VPnQYyvgF714HiSebwGglimUkVwdU7hmqkMnnoAY
         xJVQ==
X-Gm-Message-State: AOAM531ajvPVdnfEu88B44MHNY0VIGRXWSUb56zqDPsWWUVt3ZepZ5VI
        d0XNlzgwjUQTjh0ppltaPbM=
X-Google-Smtp-Source: ABdhPJxbCAaPcBOGnRy88sCNvYz0fUCRZWJeHQyPJ+k+iea19pkpNR7wXD14ixVZGIVAB8a3Qdv0yg==
X-Received: by 2002:a37:500a:: with SMTP id e10mr638103qkb.60.1606334651253;
        Wed, 25 Nov 2020 12:04:11 -0800 (PST)
Received: from localhost.localdomain ([177.220.172.93])
        by smtp.gmail.com with ESMTPSA id l79sm412559qke.1.2020.11.25.12.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 12:04:10 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id B6C55C0E58; Wed, 25 Nov 2020 17:04:07 -0300 (-03)
Date:   Wed, 25 Nov 2020 17:04:07 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu@ucloud.cn
Cc:     kuba@kernel.org, jhs@mojatatu.com, netdev@vger.kernel.org,
        vladbu@nvidia.com, xiyou.wangcong@gmail.com
Subject: Re: [PATCH v4 net-next 3/3] net/sched: sch_frag: add generic packet
 fragment support.
Message-ID: <20201125200407.GB449907@localhost.localdomain>
References: <1606276883-6825-1-git-send-email-wenxu@ucloud.cn>
 <1606276883-6825-4-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1606276883-6825-4-git-send-email-wenxu@ucloud.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 12:01:23PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Currently kernel tc subsystem can do conntrack in cat_ct. But when several
                                               typo ^^^

> fragment packets go through the act_ct, function tcf_ct_handle_fragments
> will defrag the packets to a big one. But the last action will redirect
> mirred to a device which maybe lead the reassembly big packet over the mtu
> of target device.
> 
> This patch add support for a xmit hook to mirred, that gets executed before
> xmiting the packet. Then, when act_ct gets loaded, it configs that hook.
> The frag xmit hook maybe reused by other modules.

(I'm back from PTO)

This paragraph was kept from previous version and now although it can
match the current implementation, it's a somewhat forced
understanding. So what about:
"""
This patch adds support for a xmit hook to mirred, that gets executed
before xmiting the packet. Then, when act_ct gets loaded, it enables
such hook.
The hook may also be enabled by other modules.
"""

Rationale is to not give room for the understanding that the hook is
configurable (i.e., replaceable with something else), to cope with v4
changes.

> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
> v2: make act_frag just buildin for tc core but not a module
>     return an error code from tcf_fragment
>     depends on INET for ip_do_fragment
> v3: put the whole sch_frag.c under CONFIG_INET

I was reading on past discussions that led to this and I miss one
point of discussion. Cong had mentioned that as this is a must have
for act_ct, that we should get rid of user visible Kconfigs for it
(which makes sense).  v3 then removed the Kconfig entirely.
My question then is: shouldn't it have an *invisible* Kconfig instead?
As is, sch_frag will be always enabled, regardless of having act_ct
enabled or not.

I don't think it's worth tiying this to act_ct itself, as I think
other actions can do defrag later on or so. So I'm thinking act_ct
could select this other Kconfig, that depends on INET, and use it to
enable/disable building this code.

> v4: remove the abstraction for xmit_hook 

Other than this, LGTM.
