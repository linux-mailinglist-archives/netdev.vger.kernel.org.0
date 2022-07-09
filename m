Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA1856C736
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 07:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiGIFOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 01:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGIFOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 01:14:37 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20B6255A1
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 22:14:34 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id j22so835901ejs.2
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 22:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4eNgXwLaF+rro8B9QvK28sHg2+M32IBHC73oydIgJFc=;
        b=MzsiBud+25mdunRkRztl6jBlxStRwycc3M9C4Lst8wIZtVDH48TTm3yASvWE2SBtHq
         208MrKVSVFm5JZDKgdL9aeG1iCI84FMCQA5SH9Yvhkey/OVAJmWEoATHTSLeMrtSdqcj
         y7d/0cO0bfVHFneCA8oRDR3kYIyLMO2eC7RQ/ny/lscKnaQ9Biws2lqY7e4xk1J6e+ub
         D6tf0spk3cJl189OxgnPhqbwaVOtVM4NPUPorqLbyQlce5/Byzd04wEJhQ0ksORq7RpM
         dRT92Gu9U+auCWstoaYwjmqOs0WKRf/j1nn8OCnOaUFdlbfiBNapBdN1wtxYAcnr/hIL
         LKig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4eNgXwLaF+rro8B9QvK28sHg2+M32IBHC73oydIgJFc=;
        b=GQQ5eL8GKXu6+ZaB44fD/P4W4ZDM/EBv4SxrG6AAD33hIR8eD7sXfb5lx9IjQwRqT5
         +XIZaEutqZETPjvDLb3WFV8uxqkodoTUP3NoIykY7Cx8Low+MQ9Fp65qtQ+tQ0l2cjBr
         yB5rLuxYIelMma8hMReeR+NDl9rTeDX6JWC2K3yKty0dfDdv9U6c0ie+YY6+JGvQQuw8
         emexZ1xD6uQ5/9fm4/jJt/dJbjIWoN9NpaYvn/ftPSQEv7kI0Fth95hurO+h3UEzEH4a
         +paqAaq4J47tCDsYGuKwEauEIgpI3+8RIlRK6ZY+76wmDnpVScQCSHbyOPEYNRJeautS
         9S7w==
X-Gm-Message-State: AJIora9iiSGh+MQrpynS90SUM+K44ukfh2zpC09aDvEQiXna8Q/vVJu/
        84X1ozNK/j6rdWVsg1Ge/PLF/A==
X-Google-Smtp-Source: AGRyM1tFIxORwPTVNRL//obBqhFLjo9vv9aO7trO0ry85ZPoFAZCBKS7jM+WOcCJNDnvqHjkvjnUYA==
X-Received: by 2002:a17:907:9488:b0:722:e5c8:c647 with SMTP id dm8-20020a170907948800b00722e5c8c647mr7016424ejc.291.1657343673225;
        Fri, 08 Jul 2022 22:14:33 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id h2-20020a17090619c200b0072b0d3ca423sm208258ejd.187.2022.07.08.22.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 22:14:32 -0700 (PDT)
Date:   Sat, 9 Jul 2022 07:14:31 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@nvidia.com>, Dima Chumak <dchumak@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: Re: [PATCH net-next 0/5] devlink rate police limiter
Message-ID: <YskOt0sbTI5DpFUu@nanopsycho>
References: <20220620152647.2498927-1-dchumak@nvidia.com>
 <20220620130426.00818cbf@kernel.org>
 <228ce203-b777-f21e-1f88-74447f2093ca@nvidia.com>
 <20220630111327.3a951e3b@kernel.org>
 <YsbBbBt+DNvBIU2E@nanopsycho>
 <20220707131649.7302a997@kernel.org>
 <YsfcUlF9KjFEGGVW@nanopsycho>
 <20220708110535.63a2b8e9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708110535.63a2b8e9@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jul 08, 2022 at 08:05:35PM CEST, kuba@kernel.org wrote:
>Adding Michal
>
>On Fri, 8 Jul 2022 09:27:14 +0200 Jiri Pirko wrote:
>> >> Configuring the TX/RX rate (including groupping) applies to all of
>> >> these.  
>> >
>> >I don't understand why the "side of the wire" matters when the patches
>> >target both Rx and Tx. Surely that covers both directions.  
>> 
>> Hmm, I believe it really does. We have objects which we configure. There
>> is a function object, which has some configuration (including this).
>> Making user to configure function object via another object (eswitch
>> port netdevice on the other side of the wire), is quite confusing and I
>> feel it is wrong. The only reason is to somehow fit TC interface for
>> which we don't have an anchor for port function.
>> 
>> What about another configuration? would it be ok to use eswitch port
>> netdev to configure port function too, if there is an interface for it?
>> I believe not, that is why we introduced port function.
>
>I resisted the port function aberration as long as I could. It's 

Why do you say "aberration"? It is a legitimate feature that is allowing
to solve legitimate issues. Maybe I'm missing something.


>a limitation of your design as far as I'm concerned.

What do you mean? This is not related to us only. The need to work with
port function (the other side of the wire) is definitelly nothing
specific to mlx5 driver.


>
>Switches use TC to configure egress queuing, that's our Linux model.
>Representor is the switch side, TC qdisc on it maps to the egress
>of the switch.

Sure.

>
>I don't understand where the disconnect between us is, you know that's
>what mlxsw does..

No disconnect. mlxsw works like that. However, there is no VF/SF in
mlxsw world. The other side of the wire is a different host.

However in case of VF/SF, we also need to configure the other side of
the wire, which we are orchestrating. That is the sole purpose of why we
have devlink port function. And once we have such object, why is it
incorrect to use it for the needed configuration?

Okay, if you really feel that we need to reuse TC interface for this
feature (however mismathing it might be), lets create a netdev for the
port function to hook this to. But do we want such a beast? But to hook
this to eswitch port representor seems to me plain wrong.


>
>> >> Putting the configuration on the eswitch representor does not fit:
>> >> 1) it is configuring the other side of the wire, the configuration
>> >>    should be of the eswitch port. Configuring the other side is
>> >>    confusing and misleading. For the purpose of configuring the
>> >>    "function" side, we introduced "port function" object in devlink.
>> >> 2) it is confuguring netdev/ethernet however the confuguration applies
>> >>    to all queues of the function.  
>> >
>> >If you think it's technically superior to put it in devlink that's fine.
>> >I'll repeat myself - what I'm asking for is convergence so that drivers
>> >don't have  to implement 3 different ways of configuring this. We have
>> >devlink rate for from-VF direction shaping, tc police for bi-dir
>> >policing and obviously legacy NDOs. None of them translate between each
>> >other so drivers and user space have to juggle interfaces.  
>> 
>> The legacy ndo is legacy. Drivers that implement switchdev mode do
>> not implement those, and should not.
>
>That's irrelevant - what I'm saying is that in practice drivers have to
>implement _all_ of these interfaces today. Just because they are not
>needed in eswitch mode doesn't mean the sales department won't find a
>customer who's happy with the non-switchdev mode and doesn't want to
>move.
