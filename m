Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2544FB9C1
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 12:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345551AbiDKKeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 06:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239178AbiDKKeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 06:34:10 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87469434B6
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 03:31:56 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id u15so11254039ejf.11
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 03:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wr+jKWsRtTHCZ7oMQjtKY+IUQWMAqIQS/aRc2Laf/Yc=;
        b=2bKitP9RtoVhZ8biAVvFf5EBHQou7Og4vqbOK2djijBfQWD/4dlebz429sujJA5+vw
         LRJaO/ceeHg/cV5U0be8CkRavFEX3B2GjEpAD+G53VInHFrih5LTqNSln9+Uz6ChkH1l
         l7WvH+G99MJ0sZNVt4PK3jvYH7LdFHVvsCZjbojKM93xf8D/wBFooO2kL+9G7VJz+9Ze
         eARrptateiW5w8xqKDA0hKCcu0RU+CV02dCF3s4aZwVOm19nxBsSSSWMedhAhWMenkVU
         81rGYwbQWXwUKtjgGpfRfJ/0MX69UVinP04omM1BRdF+F3DFpUs5KuOwY4ucf8fjKraP
         9GPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wr+jKWsRtTHCZ7oMQjtKY+IUQWMAqIQS/aRc2Laf/Yc=;
        b=fvKZtrlV9tRiUWsz7r8c0EXGKlXJAeZhlNlNXf6NFNRvlRpovhon60WW9V+svpMtIX
         qYk+l0jXxC4OW7GWi5VGnqmSqEf6dNwnD1CKrd2Fem/kdK2vIaMN66mGqWAmfMCHb6R9
         TPvQ3Q67xiGV4U/BgUVd6etVs8JxTYvh30naTRV5vZFvPsjgsddeXnBJcEI565bz2pG/
         r3+OORP+Zp+3z9AZf5J9fF/rdQMcZakdN9inJs6ls6XymTUSklopXu8ERoCnr0LexI71
         TpNVYLfybsnyE8L9XRLIdnAoN1NoJLzsrUHvCmsKh0LQ+K00HxqbzGYrqZz2dmSmpwJV
         EN6Q==
X-Gm-Message-State: AOAM532Zy4vSlfKLXPuF7xU8cyUCzvbywBx8CQBWnWZuDcznAf+Q2KFO
        8ZCbvjunNyqrpOJkUGbUypsCWg==
X-Google-Smtp-Source: ABdhPJxPLBa14oEEejySJl96xd1Hu2s2JInLCxnJEkUCcJbTTAa3UcNXI8wAJ6tt2hR7mg7ztQZ3DQ==
X-Received: by 2002:a17:907:e91:b0:6e8:61d0:9e4d with SMTP id ho17-20020a1709070e9100b006e861d09e4dmr11788072ejc.507.1649673115153;
        Mon, 11 Apr 2022 03:31:55 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id w7-20020a05640234c700b0041d79333508sm2310816edc.77.2022.04.11.03.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 03:31:54 -0700 (PDT)
Date:   Mon, 11 Apr 2022 12:31:53 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Guralnik <michaelgur@nvidia.com>, netdev@vger.kernel.org,
        jiri@nvidia.com, ariela@nvidia.com, maorg@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com
Subject: Re: [RFC PATCH net-next 0/2] devlink: Add port stats
Message-ID: <YlQDmWEzhOyfhWev@nanopsycho>
References: <20220407084050.184989-1-michaelgur@nvidia.com>
 <20220407201638.46e109d1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407201638.46e109d1@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Apr 08, 2022 at 05:16:38AM CEST, kuba@kernel.org wrote:
>On Thu, 7 Apr 2022 11:40:48 +0300 Michael Guralnik wrote:
>> This patch set adds port statistics to the devlink port object.
>> It allows device drivers to dynamically attach and detach counters from a
>> devlink port object.
>
>The challenge in defining APIs for stats is not in how to wrap a free
>form string in a netlink message but how do define values that have
>clear semantics and are of value to the user.

Wait, does all stats have to be well-defined? I mean, look at the
ethtool stats. They are free-form strings too. Do you mean that in
devlink, we can only have well-defines enum-based stats?


>
>Start from that, discuss what you have with the customer who requested
>the feature. Then think about the API.
>
>I have said this multiple times to multiple people on your team.
>
>> The approach of adding object-attached statistics is already supported for trap
>> with traffic statistics and for the dev object with reload statistics.
>
>That's an entirely false comparison.
>
>> For the port object, this will allow the device driver to expose and dynamicly
>> control a set of metrics related to the port.
>> Currently we add support only for counters, but later API extensions can be made
>> to support histograms or configurable counters.
>> 
>> The statistics are exposed to the user with the port get command.
>> 
>> Example:
>> # devlink -s port show
>> pci/0000:00:0b.0/65535: type eth netdev eth1 flavour physical port 0 splittable false
>>   stats:
>>     counter1 235
>>     counter2 18
