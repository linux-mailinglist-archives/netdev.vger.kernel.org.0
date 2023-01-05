Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46DA865E8AD
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 11:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbjAEKMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 05:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbjAEKMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 05:12:47 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F0932E9C
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 02:12:45 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso1542896pjp.4
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 02:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hTkgexCq4sc7c3j9vlahp8mVjt+/jki3Zd8lYnuZ/mg=;
        b=b7EHd0wVsGzJgKrX8UiYKLxnAuwRVTASn1EOSqyPsDwM49wgE+nES1Iwdrcbp7pXv0
         6jXbcYeGAjt68nqwNwmud7QVjo+trjnwEKI70Pl85D3Uh+j6exNd0pvuTegIDVL8zgte
         O8hZhsCwJk4+wQVgphTY+AyVaOM2mVHlc29IpZjRgyptgIx8JuaPfhZ/KVwvp/Rzee0w
         s6RY2eDZBWFb8mOVHv7zUw5IJ25OwYAmiGFDASHbtqW/zJGFR7g4yia9R+wmcHF/wm6r
         gzjCQh3y9J6pDPUY18JgBrLd1F2zL/R7RafusTYhmrBldWZj7ZeMojoT25lLiX8VjSVL
         CZwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hTkgexCq4sc7c3j9vlahp8mVjt+/jki3Zd8lYnuZ/mg=;
        b=bT/p0Cb2iVajCoHCb2LBFkGwyQUF7MQyfdN5niWXL/2WM8NnKaRmpEp/rMmPNIseLY
         5Uuw8H424CY9nu41Uu3s6X6huAObPyEL9HnApJ8bRSzx92/1bLC66O4sxM7uA1+rIYHd
         17qe05xPJtO+Slono0piZ8kZSlAt0hP9zuOtWsXLUFpw0qXNwq70zi1yn5dV4MwU23aN
         TH3pHM/4iIKxDUKBkEJTGcgtXeYgU9cy5Y3qkhOUX0VsuLQNF4VMnJLWwWZDf/Qaq0Gg
         d/z9BsYMxoVBMbqVCbgN/RyPisI7DYbarEaXiUqPFHf17z3lBtseBam+s0JklqOju9EH
         Uz7w==
X-Gm-Message-State: AFqh2kodiw8HCOy8HVCfAYBefxRf2nfD1Ve81Xc2sDyLJmfDTfqB9lC2
        nbFFOSUClxOIE+St5EeYiRs=
X-Google-Smtp-Source: AMrXdXtFheBbqbo/U89wjU9nGSen+XMffJNrfF2+IcxP+XIaDevAG09sIjOB54slwMjfVooo6qm4lw==
X-Received: by 2002:a17:903:2c5:b0:192:cf35:3fff with SMTP id s5-20020a17090302c500b00192cf353fffmr13257467plk.9.1672913565245;
        Thu, 05 Jan 2023 02:12:45 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id r10-20020a170902c60a00b001869b988d93sm25660474plr.187.2023.01.05.02.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 02:12:44 -0800 (PST)
Date:   Thu, 5 Jan 2023 18:12:39 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCHv3 net-next] sched: multicast sched extack messages
Message-ID: <Y7ail5Ta+OgMXCeh@Laptop-X1>
References: <20230104091608.1154183-1-liuhangbin@gmail.com>
 <20230104200113.08112895@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104200113.08112895@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 08:01:13PM -0800, Jakub Kicinski wrote:
> On Wed,  4 Jan 2023 17:16:08 +0800 Hangbin Liu wrote:
> > In commit 81c7288b170a ("sched: cls: enable verbose logging") Marcelo
> > made cls could log verbose info for offloading failures, which helps
> > improving Open vSwitch debuggability when using flower offloading.
> > 
> > It would also be helpful if userspace monitor tools, like "tc monitor",
> > could log this kind of message, as it doesn't require vswitchd log level
> > adjusment. Let's add a new function to report the extack message so the
> > monitor program could receive the failures. e.g.
> 
> If you repost this ever again please make sure you include my tag:
> 
> Nacked-by: Jakub Kicinski <kuba@kernel.org>
> 
> I explained to you at least twice why this is a terrible idea,
> and gave you multiple alternatives.

Hi Jakub,

I'm very sorry if this patch makes you feel disturbed. I switched the notification
to NLMSG_ERROR instead of NLMSG_DONE as you pointed out. I also made the
notification only in sched sub-system, not using netlink_ack() globally.
Oh, and forgot to reply to you, I use portid and seq in the notification as all
the tc notifies also use them.

In the last patch, I saw Jamal reply to you about the usability. So I thought
you might reconsider this feature. Now I will stop posting this patch unless
you agree to keep working on this.

Sorry again if I missed any other suggestions from you.

Best regards
Hangbin
