Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D8056B379
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 09:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237555AbiGHH1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 03:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237559AbiGHH1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 03:27:20 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB637C192
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 00:27:18 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id n185so11902569wmn.4
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 00:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8DURBo4GQga4NcDJVloavSC6hm1vUmWuuzMDQLCG1Bg=;
        b=BIOaVCcxNNP2ut05OIoQJX6J9PP6UXoD3kNw0oSzA3uvUD3xucrWkYiEBuVEkXMSA2
         WN11el0D2juqpOdroh3PQ3zicWVt60ky9PQCLXEDPbolh7xRqWym7zwm6CSz2tHLDE9B
         eWExwE1XDDnKQdQEcSe9b3NH4uSbKxN7jDA4UBGjmFY8LA97LLmwOfuN2JbXyKsf5+PW
         8yS5R8yO/uTHwmDb5E69i8d4Xi6dtyMKl616h2KuuN5KD8CBPi66mpHBY0Inf/8brBME
         QoEIYwhpHPidUl4rn8GUm47DOTCUh6+gdQGoJTWc/tiqsfmXK2eTAPTRtqEdKbRu8+7Y
         NawQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8DURBo4GQga4NcDJVloavSC6hm1vUmWuuzMDQLCG1Bg=;
        b=7lc9Ie3YeDnNBuBpaTAnCnrrwedp2LUJb/G+Rqthq63u0wRRfDKsA3XmIkuHLWBXmw
         xzm8jN3ldXO88hylucCCcSc4X55J+Paqc7McfEc8j1D2obReB8CN7wvGrxdLOJXeTZDf
         r4A6G2xMJsmW/5FdtgOU7VB17Lz9Vr1s21O4aBlVgxclwD/qRHDvYxNuYix3zp4kevWj
         /v4783ATQFGgR9DaR2Rl4caTy7WaihFIdmGupiAyes7BaVNKl1OTartJD30EvkDo1OtA
         azVxoCoGBJPNt7DkW6I5E24RJbQROWV/nreXPmQFfHMM+g002tnrchH21Rvg/eLtMZCN
         e6yw==
X-Gm-Message-State: AJIora9CTmJZUBME+VuU+A8jeKJUYJuZQ5Fb0cMGUjztEfY5XMdM01be
        PLSNIkpTEZuTzyuLweBeUJbHjzqjzWJxaN62
X-Google-Smtp-Source: AGRyM1uw3PL9WArLODDFm9xWUwaT5ERmCA3OdSkmXOEGQjYBuyII8Mw0hsfY//0GxoPtW1T16tdhXg==
X-Received: by 2002:a7b:ca49:0:b0:3a2:d80d:5b32 with SMTP id m9-20020a7bca49000000b003a2d80d5b32mr3161586wml.124.1657265236468;
        Fri, 08 Jul 2022 00:27:16 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id o19-20020a05600c339300b0039c4506bd25sm1463153wmp.14.2022.07.08.00.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 00:27:15 -0700 (PDT)
Date:   Fri, 8 Jul 2022 09:27:14 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@nvidia.com>, Dima Chumak <dchumak@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH net-next 0/5] devlink rate police limiter
Message-ID: <YsfcUlF9KjFEGGVW@nanopsycho>
References: <20220620152647.2498927-1-dchumak@nvidia.com>
 <20220620130426.00818cbf@kernel.org>
 <228ce203-b777-f21e-1f88-74447f2093ca@nvidia.com>
 <20220630111327.3a951e3b@kernel.org>
 <YsbBbBt+DNvBIU2E@nanopsycho>
 <20220707131649.7302a997@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707131649.7302a997@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 07, 2022 at 10:16:49PM CEST, kuba@kernel.org wrote:
>On Thu, 7 Jul 2022 13:20:12 +0200 Jiri Pirko wrote:
>> Wait. Lets draw the basic picture of "the wire":
>> 
>> --------------------------+                +--------------------------
>> eswitch representor netdev|=====thewire====|function (vf/sf/whatever
>> --------------------------+                +-------------------------
>> 
>> Now the rate setting Dima is talking about, it is the configuration of
>> the "function" side. Setting the rate is limitting the "function" TX/RX
>> Note that this function could be of any type - netdev, rdma, vdpa, nvme.
>
>The patches add policing, are you saying we're gonna drop RDMA or NVMe
>I/O?

Well, there is some limit to the rate of VF anyway, so at some point,
the packets need to be dropped, with or without policing.
Not really sure how that is handled in rdma and nvme.


>
>> Configuring the TX/RX rate (including groupping) applies to all of
>> these.
>
>I don't understand why the "side of the wire" matters when the patches
>target both Rx and Tx. Surely that covers both directions.

Hmm, I believe it really does. We have objects which we configure. There
is a function object, which has some configuration (including this).
Making user to configure function object via another object (eswitch
port netdevice on the other side of the wire), is quite confusing and I
feel it is wrong. The only reason is to somehow fit TC interface for
which we don't have an anchor for port function.

What about another configuration? would it be ok to use eswitch port
netdev to configure port function too, if there is an interface for it?
I believe not, that is why we introduced port function.


>
>> Putting the configuration on the eswitch representor does not fit:
>> 1) it is configuring the other side of the wire, the configuration
>>    should be of the eswitch port. Configuring the other side is
>>    confusing and misleading. For the purpose of configuring the
>>    "function" side, we introduced "port function" object in devlink.
>> 2) it is confuguring netdev/ethernet however the confuguration applies
>>    to all queues of the function.
>
>If you think it's technically superior to put it in devlink that's fine.
>I'll repeat myself - what I'm asking for is convergence so that drivers
>don't have  to implement 3 different ways of configuring this. We have
>devlink rate for from-VF direction shaping, tc police for bi-dir
>policing and obviously legacy NDOs. None of them translate between each
>other so drivers and user space have to juggle interfaces.

The legacy ndo is legacy. Drivers that implement switchdev mode do
not implement those, and should not.
