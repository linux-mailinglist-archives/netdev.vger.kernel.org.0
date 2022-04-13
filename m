Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E710D4FF2F1
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 11:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbiDMJJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 05:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiDMJJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 05:09:29 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B186443482
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 02:07:08 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id u15so2544169ejf.11
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 02:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mTMrX5+gjBvjgZqzOUKqAOBI2Taj/bLG+B+9MIfEki0=;
        b=gUfBXg+pYaJdsGFVJKfUJJ0RaMzNHXk35hLKdf8tf/RPw6fLLOqdbuD44MDcS1V6Y9
         5eDdOKs52pLVa+U5C8ANO0fM8/cjclXLkjBgttKSikjUSafwDIw2qFCLlDpPhzigA1aW
         9RHgKxKZgiPuII6ZujKjE7zpoPpG1IF9S8LZ7zwXAsmpAoRppIjkV7hHgR40X2c5HOgy
         WDb0DYbO1uRENU4Cie52L2lUJxgrOuqL7aZWYbC4ygu7jrttI6uP2Z2oWBvAHnJujr9u
         5EZgEX3G3QOS96jguckXxR/4Jr01WCfddMvog5cf6US7itu7RtyN24R+2Blp1ZBKB86W
         8TBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mTMrX5+gjBvjgZqzOUKqAOBI2Taj/bLG+B+9MIfEki0=;
        b=binj4VYBB5tBWsnfQ/yqw1Ffk5FdpQdXO2fyetStWNdgr520RTiPCQDqlhS8EOCVmt
         icRTPLtvkk18J0uKKE+C2Pb356x6n7jD6uYscRU9EX8XV6J3CKAFjsxCcCBcZ1j2mH2c
         2by9Oq6JUEd9r+u9zBheuu4mmD+q4xgKgt2j4nLfcNpuQzRoNqyNN2NHm//gM1PjZuIj
         GDdkOtZPtx7F2qLC1YzFkrTigsLz69f3dJDHR6OhSn9GWzMvCSEUUgF0WURVEPXIHHzH
         D4EXQ3aTVhvK0573wOJCLYPVgOJF4vcSd4AUz8J1UVOGINW6mI+t/Tn+cueIiHfTxZiR
         i7HQ==
X-Gm-Message-State: AOAM531fOSWu8Jv6gLKZsO3H/3ZcSPAk+Dx/OPRrmLANluEPxRubU1d3
        i6V1D+HnPOyWfr5cOG93Vgk=
X-Google-Smtp-Source: ABdhPJxp+oL++siikDaIM7VY5M+LcxAiXKd+7ppfrgq/l57+7lPHKTR7fGC3r/BdnrUAIfNoBlWyfw==
X-Received: by 2002:a17:906:7210:b0:6d6:7881:1483 with SMTP id m16-20020a170906721000b006d678811483mr37710116ejk.227.1649840827019;
        Wed, 13 Apr 2022 02:07:07 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id j2-20020a056402238200b0041f351a8b83sm652550eda.43.2022.04.13.02.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 02:07:06 -0700 (PDT)
Date:   Wed, 13 Apr 2022 12:07:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Baowen Zheng <baowen.zheng@corigine.com>
Cc:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@nvidia.com" <roid@nvidia.com>,
        "vladbu@nvidia.com" <vladbu@nvidia.com>,
        Eli Cohen <elic@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [RFC net-next] net: tc: flow indirect framework issue
Message-ID: <20220413090705.zkfrp2fjhejqdj6a@skbuf>
References: <20220413055248.1959073-1-mattias.forsblad@gmail.com>
 <DM5PR1301MB2172F573F9314D43F79D8F26E7EC9@DM5PR1301MB2172.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR1301MB2172F573F9314D43F79D8F26E7EC9@DM5PR1301MB2172.namprd13.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Baowen,

On Wed, Apr 13, 2022 at 07:05:39AM +0000, Baowen Zheng wrote:
> Hi Mattias, in my understand, your problem may because you register
> your callback here. I am not sure why you choose to register your hook
> here(after the interface is added to the bridge to just trigger the
> callback in necessary case.)

> Then your function is called and add your cb to the tcf_block. But
> since the matchall filter has been created so you can not get your
> callback triggered. 

The bridge device has a certain lifetime, and the physical port device
has a different and completely independent lifetime. So the port device
may join the bridge when the bridge already has some filters on its
ingress chain.

Even with the indirect flow block callback registered at module load
stage as you suggest, the port driver needs to have a reason to
intercept a tc filter on a certain bridge. And when the port isn't a
member (yet) of that bridge, it has no reason to.

Of course, you could make the port driver speculatively monitor all tc
filters installed on all bridges in the system (related or unrelated to
ports belonging to this driver), just to not miss callbacks which may be
needed later. But that is quite suboptimal.

Mattias' question comes from the fact that there is already some logic
in flow_indr_dev_register() to replay missed flow block binding events,
added by Eli Cohen in commit 74fc4f828769 ("net: Fix offloading indirect
devices dependency on qdisc order creation"). That logic works, but it
replays only the binding, not the actual filters, which again, would be
necessary.

> Maybe you can try to regist your callback in your module load stage I
> think your callback will be triggered, or change the command order as: 
> tc qdisc add dev br0 clsact
> ip link set dev swp0 master br0
> tc filter add dev br0 ingress pref 1 proto all matchall action drop
> I am not sure whether it will take effect.

I think the idea is to make the given command order work, not to change it.
