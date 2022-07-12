Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17A4571215
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 08:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiGLGDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 02:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGLGDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 02:03:47 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2CB2B63D
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 23:03:43 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id r18so8754941edb.9
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 23:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yDg4aQWiW5PC39Zrei9VabNIyFmpRsiN0B34CISRO5s=;
        b=VYXSK/aFyD0NLFq5R3tFCbvSm1YBEirrp8R5jJfzLgNRC5Ze5K9D2FIJgwAFWqJivY
         +d4tZW6zC8cRjwgs0VdiTnIopfWYf1dScCpzQiziqKWR0R/0vduA29mpSjs6+yBM6852
         CErSGK0EZTrIUQsCQo843s3Rdua++39gvmqDzESm/I5GGPFlndK8qrbMiJtrqAw0aKFV
         3U4KYOoWPfoOwVKM/Do7PZipdp3Jev9lEX1o9w6s91NxfD2JEwtLYhwYycQoGMHMkgYD
         pVJIAHhJKF4U/SvQSbflwojO4V+DzJkub8L0eHvqmlMevLv+/fkM1V63rkmNBVKpfKDb
         yeVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yDg4aQWiW5PC39Zrei9VabNIyFmpRsiN0B34CISRO5s=;
        b=3Z8TzI4NSuyhqjRTDzKVM2mlIp1+JxrQLP/G3Thrgrmuvo0vbn2fzZNTqRaV1GLexP
         EcES28VhBGLFAyTIZBS1HEZnr+MDy6vHbhuqp1z0UcXjExH45p3dihvXu9rYzZY3TVWm
         Td5MdEabZOwtldmmILS0rWoqmHYanWJnG8cv8vO5gCydcT4CdTiVVmd8CS8AAX7choCN
         qfb6ok/hf1SevK1L1Enrddir5jfAT545POzfmAk0SYPcP7ay6hP2ycjydkWrwS+8ETlJ
         d2Rs3FdQ6ZcPl3LrvJkUcILA857eoMC1//+aVok/fQB089Qsc9YXZlIFKTVNQJCv0dnt
         HdXQ==
X-Gm-Message-State: AJIora8s6+rfDJzIhpWMSJHFgaGrci3fjJXQfSxq407x/hHaNVQqNL5i
        89E+dJGQjVrvJZ/fbpmX+WnrSw==
X-Google-Smtp-Source: AGRyM1sBR5g094kkjnHW9krP3xKKtHGUzrFAYZtdehBkW9hfVrHSjZTOb7CmKuiK2UFyRUIwwvMDJw==
X-Received: by 2002:a05:6402:1941:b0:435:5972:7811 with SMTP id f1-20020a056402194100b0043559727811mr29380631edz.234.1657605822524;
        Mon, 11 Jul 2022 23:03:42 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id d26-20020a170906345a00b00726e51b6d7dsm3407987ejb.195.2022.07.11.23.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 23:03:41 -0700 (PDT)
Date:   Tue, 12 Jul 2022 08:03:40 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@nvidia.com>, Dima Chumak <dchumak@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: Re: [PATCH net-next 0/5] devlink rate police limiter
Message-ID: <Ys0OvOtwVz7Aden9@nanopsycho>
References: <20220620152647.2498927-1-dchumak@nvidia.com>
 <20220620130426.00818cbf@kernel.org>
 <228ce203-b777-f21e-1f88-74447f2093ca@nvidia.com>
 <20220630111327.3a951e3b@kernel.org>
 <YsbBbBt+DNvBIU2E@nanopsycho>
 <20220707131649.7302a997@kernel.org>
 <YsfcUlF9KjFEGGVW@nanopsycho>
 <20220708110535.63a2b8e9@kernel.org>
 <YskOt0sbTI5DpFUu@nanopsycho>
 <20220711102957.0b278c12@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711102957.0b278c12@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 11, 2022 at 07:29:57PM CEST, kuba@kernel.org wrote:
>On Sat, 9 Jul 2022 07:14:31 +0200 Jiri Pirko wrote:
>> >I resisted the port function aberration as long as I could. It's   
>> 
>> Why do you say "aberration"? It is a legitimate feature that is allowing
>> to solve legitimate issues. Maybe I'm missing something.
>
>From netdev perspective it's an implementation detail irrelevant 
>to the user. The netdev model is complete without it.

Well it is a configuration of a device part out of the scope of netdev.
So yes, netdev model is complete without it. But does does not mean we
don't need such configuration. I may be missing your point.


>
>> >a limitation of your design as far as I'm concerned.  
>> 
>> What do you mean? This is not related to us only. The need to work with
>> port function (the other side of the wire) is definitelly nothing
>> specific to mlx5 driver.
>>
>> >Switches use TC to configure egress queuing, that's our Linux model.
>> >Representor is the switch side, TC qdisc on it maps to the egress
>> >of the switch.  
>> 
>> Sure.
>>
>> >I don't understand where the disconnect between us is, you know that's
>> >what mlxsw does..  
>> 
>> No disconnect. mlxsw works like that. However, there is no VF/SF in
>> mlxsw world. The other side of the wire is a different host.
>> 
>> However in case of VF/SF, we also need to configure the other side of
>> the wire, which we are orchestrating. That is the sole purpose of why we
>> have devlink port function. And once we have such object, why is it
>> incorrect to use it for the needed configuration?
>
>So the function conversation _is_ relevant here, eh? Sad but it is what
>it is.

I'm not sure I follow what "function conversation" you mean. :/


>
>> Okay, if you really feel that we need to reuse TC interface for this
>> feature (however mismathing it might be),
>
>Not what I said, I'm not gonna say it the fourth time.

Okay, sorry for being slow, but I still don't understand your point :/


>
>> lets create a netdev for the port function to hook this to. But do we
>> want such a beast? But to hook this to eswitch port representor seems
>> to me plain wrong.
>
>I presume you're being facetious. Extra netdev is gonna help nothing. 

I'm somewhat am, yes.


>
>AFAIU the problem is that you want to control endpoints which are not
>ndevs with this API. Is that the main or only reason? Can we agree that
>it's legitimate but will result in muddying the netdev model (which in
>itself is good and complete)?

I don't think this has anything to do with netdev model. It is actually
out of the scope of it, therefore there cannot be any mudding of it.


