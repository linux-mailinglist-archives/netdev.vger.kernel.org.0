Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCF8483AD2
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 04:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbiADDJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 22:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbiADDJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 22:09:50 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01252C061761;
        Mon,  3 Jan 2022 19:09:50 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id be32so57492407oib.11;
        Mon, 03 Jan 2022 19:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NaZf+kSXFTjrTdBpOaBqKJ2yFsGrVDlyMX7zyq9CnJs=;
        b=G0HHUxtfU0KxEz9cgtAA3n8rNTnfKR3slaPzNRbpm1xcl6+YudkZHF0fMaMYN3BN1h
         SBZFLkaFhh7xrIzLo9cJk44chz2kciFbBYznxHUT0znGagQQADxFHQLNzA9FG+RwBXJs
         p2Vcva7LzHZx8EJEbHoJKUFt0n+BQ07ngsYQMIIE+kNr/FGmkrEACWvZ/QP0LgFn9LKj
         9jQ2lkFuUt+rV1o3PAn9XZncae6CS9dX1oVGW3HWgWGebMjfYAQ5rk/8v7qjsHHl4JVv
         ckeZC23twMye835UvzVbkMORmid061RN0p38FNOIkWrG/X3cv9SkQKewHrCG1R13FJES
         J1XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NaZf+kSXFTjrTdBpOaBqKJ2yFsGrVDlyMX7zyq9CnJs=;
        b=PZPrC+ox6d+rnmHS+lT+/H0jtRbVsusbzlN290rP4LcjHCQBOYb9gFGUFlk2Z8IT0g
         N+DB/AtxrS/TzK99lq+fhReRYCwJ44QtWuW3P9h/O1Ps/NECIsVYSFBpV2h0UdR0jkMS
         oi5jakUVZN5CvqqyGPf3U7Cj4cO2t9yHyPofkVH/0OnaiK77rc0GTxxEpfFj3M9gZd/r
         KuI/+6exktn0Y4Pvb7aa/ofcxQKBq0AX1YfJlMZ8wgc9ST+oa6gyzFlWnoc6zq2xaQa3
         SfM80EyOfEvskVmTJYIb/jBDDcPI1cKAUpsbx6jZimMbTVxLuRLRufD4BMe+rI5Oil6Y
         JwLw==
X-Gm-Message-State: AOAM5338dJnoRntVxNcJxzgo1UtEFvHgv/O1i0lUFuxczjDLcXTAStuE
        708K9CX/wGo9/napldrnRBI=
X-Google-Smtp-Source: ABdhPJzAL07timg0XtB505O7zZQZY37pyYq+zO+I9Xu5IEQJzpwbVJTJ1jJV24I0947J9D/76bFFVQ==
X-Received: by 2002:a05:6808:23cb:: with SMTP id bq11mr36621412oib.2.1641265789379;
        Mon, 03 Jan 2022 19:09:49 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:2a10:e4bf:56c0:9f7])
        by smtp.gmail.com with ESMTPSA id e15sm7879768oth.24.2022.01.03.19.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 19:09:49 -0800 (PST)
Date:   Mon, 3 Jan 2022 19:09:48 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     menglong8.dong@gmail.com, rostedt@goodmis.org, dsahern@kernel.org,
        mingo@redhat.com, davem@davemloft.net, kuba@kernel.org,
        nhorman@tuxdriver.com, edumazet@google.com,
        yoshfuji@linux-ipv6.org, jonathan.lemon@gmail.com, alobakin@pm.me,
        keescook@chromium.org, pabeni@redhat.com, talalahmad@google.com,
        haokexin@gmail.com, imagedong@tencent.com, atenart@kernel.org,
        bigeasy@linutronix.de, weiwan@google.com, arnd@arndb.de,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        mengensun@tencent.com, mungerjiang@tencent.com
Subject: Re: [PATCH v2 net-next 0/3] net: skb: introduce
 kfree_skb_with_reason() and use it for tcp and udp
Message-ID: <YdO6fL24CpHs6ByL@pop-os.localdomain>
References: <20211230093240.1125937-1-imagedong@tencent.com>
 <YdOnTcSBq8z961da@pop-os.localdomain>
 <810dd93c-c6a2-6f8b-beb9-a2119c1876fb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <810dd93c-c6a2-6f8b-beb9-a2119c1876fb@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 03, 2022 at 07:01:30PM -0700, David Ahern wrote:
> On 1/3/22 6:47 PM, Cong Wang wrote:
> > On Thu, Dec 30, 2021 at 05:32:37PM +0800, menglong8.dong@gmail.com wrote:
> >> From: Menglong Dong <imagedong@tencent.com>
> >>
> >> In this series patch, the interface kfree_skb_with_reason() is
> >> introduced(), which is used to collect skb drop reason, and pass
> >> it to 'kfree_skb' tracepoint. Therefor, 'drop_monitor' or eBPF is
> >> able to monitor abnormal skb with detail reason.
> >>
> > 
> > We already something close, __dev_kfree_skb_any(). Can't we unify
> > all of these?
> 
> Specifically?
> 
> The 'reason' passed around by those is either SKB_REASON_CONSUMED or
> SKB_REASON_DROPPED and is used to call kfree_skb vs consume_skb. i.e.,
> this is unrelated to this patch set and goal.

What prevents you extending it?

> 
> > 
> > 
> >> In fact, this series patches are out of the intelligence of David
> >> and Steve, I'm just a truck man :/
> >>
> > 
> > I think there was another discussion before yours, which I got involved
> > as well.
> > 
> >> Previous discussion is here:
> >>
> >> https://lore.kernel.org/netdev/20211118105752.1d46e990@gandalf.local.home/
> >> https://lore.kernel.org/netdev/67b36bd8-2477-88ac-83a0-35a1eeaf40c9@gmail.com/
> >>
> >> In the first patch, kfree_skb_with_reason() is introduced and
> >> the 'reason' field is added to 'kfree_skb' tracepoint. In the
> >> second patch, 'kfree_skb()' in replaced with 'kfree_skb_with_reason()'
> >> in tcp_v4_rcv(). In the third patch, 'kfree_skb_with_reason()' is
> >> used in __udp4_lib_rcv().
> >>
> > 
> > I don't follow all the discussions here, but IIRC it would be nice
> > if we can provide the SNMP stat code (for instance, TCP_MIB_CSUMERRORS) to
> > user-space, because those stats are already exposed to user-space, so
> > you don't have to invent new ones.
> 
> Those SNMP macros are not unique and can not be fed into a generic
> kfree_skb_reason function.

Sure, you also have the skb itself, particularly skb protocol, with
these combined, it should be unique.

Thanks.
