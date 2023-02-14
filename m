Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5006A6964D0
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbjBNNi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbjBNNi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:38:56 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E56274BD
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 05:38:54 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id eq11so17379894edb.6
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 05:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GcKHkdVn/R+uEWBHrUrcj7e7RVQAoA9uI1tOMORYalo=;
        b=DGkNSX3kYs6Uwp2fotTXC4UEwysYYL6Gv4+NjHqt+ZVN2K2NNizSD8RQdbXAOJHNbz
         qY2ObEW4S6rnaBUMAc6gs3pGoc0Tx2ldNEHVQ6qd4pJ2e+m9mB5uGk3UdM0KunEEHcBl
         3eucWAG8T2LtzQmW6/w9ECrfFmvoIwwz0quG2nKogXpPfMGWzD6/AvrWw1E77r/GfmPc
         KnNt6kOsQBEF2PKXbAJpmOD5xvnpt8khnk40tf2j7SNDGr9Cq/0kYZgztTEIxXDafSvz
         qrOWI+HeS4DB8ZO55L0kpvYFksFfCRpCymMo2KodSZmTuXASLm5OOffHCzP7PDpockl5
         oOZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GcKHkdVn/R+uEWBHrUrcj7e7RVQAoA9uI1tOMORYalo=;
        b=z7XmDlcEqUd0exIHWTzI9hM9QZyjn8sWoAo9sgr2NU2PClDDfFTlUdhqHaADFz3FhG
         uGu7By+9xU/6GalGith7K/SB/cEYNmq9n9npB9Sj4GkmGAxaAl2tCd6/c1wIr5GrHYrT
         vh8mMfyaTeKjyuRaA8trkipAvNPrjS5ys/uLcj/y6wdoyy9g6ji9CMBmEHkyKN3K8GL7
         XlH7Gb8Dri0K9b6dbmaYCJ0EuqDO6bByIPLwxUKnRH+yXYDv40vbE6BQmnjbwE5VqY43
         ShEAlPrhtBPZ+D0XEQNt1iAhfePI6op8//H54pZh8XLoCczPTJM4qo3ujznvXGpRLnOn
         T0xA==
X-Gm-Message-State: AO0yUKUgMZdULie3pJ1c3M/JATSmcg7v+PB5kt5wGVXjwj1vv2jcge5/
        usksV2nqhhfg/xbJpy/ZUfSL8Q==
X-Google-Smtp-Source: AK7set9/BsGFBPudI+2xJRM4m68kikvL1pvPQBUHwsAMoCyHFkQHA1YLCQCPG+624gx6is6PfDFnBw==
X-Received: by 2002:a50:cd59:0:b0:4aa:da7c:4c5c with SMTP id d25-20020a50cd59000000b004aada7c4c5cmr2383173edj.34.1676381932966;
        Tue, 14 Feb 2023 05:38:52 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r10-20020a50c00a000000b004acd14ab4dfsm1940557edb.41.2023.02.14.05.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 05:38:52 -0800 (PST)
Date:   Tue, 14 Feb 2023 14:38:50 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: Re: [net-next 01/15] net/mlx5: Lag, Let user configure multiport
 eswitch
Message-ID: <Y+uO6m6flqC85Isn@nanopsycho>
References: <20230210221821.271571-1-saeed@kernel.org>
 <20230210221821.271571-2-saeed@kernel.org>
 <20230210200329.604e485e@kernel.org>
 <db85436e-67a3-4236-dcb5-590cf3c9eafa@nvidia.com>
 <20230213180246.06ae4acd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213180246.06ae4acd@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 14, 2023 at 03:02:46AM CET, kuba@kernel.org wrote:
>On Mon, 13 Feb 2023 21:00:16 +0200 Mark Bloch wrote:
>> I agree with you this definitely should be the default. That was
>> the plan in the beginning. Testing uncovered that making it the default
>> breaks users. It changes the look and feel of the driver when in switchdev
>> mode, the customers we've talked with are very afraid
>> it will break their software and actually, we've seen real breakages
>> and I fully expect more to pop up once this feature goes live.
>
>Real breakages as in bugs that are subsequently addressed or inherent
>differences which customers may need to adjust their code for?
>Either way we need the expectation captured in the docs - 
>an "experimental" warning or examples of cases which behave differently.
>
>> We've started reaching out to customers and working with them on updating
>> their software but such a change takes time and honestly, we would like to
>> push this change out as soon as possible and start building
>> on top of this new mode. Once more features that are only possible in this
>> new mode are added it will be an even bigger incentive to move to it.
>> 
>> We believe this parameter will allow customers to transition to the new
>> mode faster as we know this is a big change, let's start the transition
>> as soon as possible as we know delaying it will only make things worse.
>> Add a flag so we can control it and in the future, once all the software
>> is updated switch the flag to be the default and keep it for legacy
>> software where updating the logic isn't possible.
>
>Oh, the "legacy software where updating the logic isn't possible"
>sounds concerning. Do we know what those cases are? Can we perhaps
>constrain them to run on a specific version of HW (say starting with
>CX8 the param will no longer be there and only the right behavior will
>be supported upstream)?
>
>I'm speaking under assumption that the document+deprecate plan is okay
>with Jiri.

I just talked with Mark. Makes sense to properly document and deprecate
as soon as possible. I don't see any other way. I can't wait when it is
done :)

so +1

Thanks!
