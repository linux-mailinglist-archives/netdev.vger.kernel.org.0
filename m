Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6000664E892
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 10:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiLPJXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 04:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiLPJXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 04:23:13 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE0B3F07A
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 01:23:11 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id k22-20020a05600c1c9600b003d1ee3a6289so1282085wms.2
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 01:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mayeu5y4kGJCmQuCfTdoYBg7yE+SQ6tN0YHnSLzrDYk=;
        b=Jd2TnZsAT9wm8qjQgWRHDgQizzhzKX4kcf/DeFwfXUfzzHV3omGzNUOgGhOg426wIB
         vnEwSncpRRpYrCk4WFvRwaznDmTWfZ5fnGXfMLXY+lLZUj5nsqPTU3FVq++LGb/Ga2hf
         kzKdSnznaO4IadiKZk5bygG9CdMBODw1Kl2tzLtOavR8VaRZJ+Kicvm/62j+1llLBGQ5
         AzMNdmY6HjU03Y4gV2M2d23tRDBe+ZUqTNjqumou8egV8FOSDXNtlOdfpH7/gzhuLeIw
         0pSve21ta444eqS+2Qo1pR4vCjXFIqjkJkB6obmVYuJc1a8bV8KbsaLVDV/SlT5qe2E7
         U4RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mayeu5y4kGJCmQuCfTdoYBg7yE+SQ6tN0YHnSLzrDYk=;
        b=MI/PDQNZIqY8tet4mRJlNx4+203+vrWABK8D65olT7c/d6HFQXOqKMdYaEe7bXIXHO
         +R+k+uvxQb26oxINT6EW38bYhU0j+1faoU1zV8XwuNbKuQL6O3l2I0u4n8oVQ+iWy/AV
         5ukKpOs0RxR2hUbqGWbtQQWmwtJHkgssn8ql3pFmYGK9ayndX3lqkF/8JLl/2RE30ByT
         FILMfQrQ4PLGSnEkpCHZHmB3xS1YKQOqQUie9a0jBbipSqNkicejt/2JuMEdHHjhSa59
         wwKcEkakwMp+fT2HRFEPUSrFFDZdphMyk9xXy2e1GfUq4vGfdhuc1yZhEHX6KfGgTZf+
         mSzA==
X-Gm-Message-State: ANoB5pl0VMo0W6zg4BC+VGoxXe+mNVwqViUTj+2Iw3VVM5a1Ccts1jDx
        8q9HksShXOAJKDRQFd4YJjxP8w==
X-Google-Smtp-Source: AA0mqf6yZQdF/Zp2zXo7jhBFB1yyEMv+gdWMSQswAhve9bHUTHj2QXiewGKPa5WL2RTFbwg7Ja/yKQ==
X-Received: by 2002:a05:600c:2049:b0:3d2:3831:e5c4 with SMTP id p9-20020a05600c204900b003d23831e5c4mr8778016wmg.40.1671182590174;
        Fri, 16 Dec 2022 01:23:10 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id y20-20020a7bcd94000000b003c6b70a4d69sm1892378wmj.42.2022.12.16.01.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 01:23:09 -0800 (PST)
Date:   Fri, 16 Dec 2022 10:23:08 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, leon@kernel.org
Subject: Re: [RFC net-next 14/15] devlink: add by-instance dump infra
Message-ID: <Y5w4/HH71W3O5EOC@nanopsycho>
References: <20221215020155.1619839-1-kuba@kernel.org>
 <20221215020155.1619839-15-kuba@kernel.org>
 <Y5rkpxKm/TdGlJHf@nanopsycho>
 <20221215114706.42be5299@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215114706.42be5299@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 15, 2022 at 08:47:06PM CET, kuba@kernel.org wrote:
>On Thu, 15 Dec 2022 10:11:03 +0100 Jiri Pirko wrote:
>> Instead of having this extra list of ops struct, woudn't it make sence
>> to rather implement this dumpit_one infra directly as a part of generic
>> netlink code?
>
>I was wondering about that, but none of the ideas were sufficiently
>neat to implement :( There's a lot of improvements that can be done
>in the core, starting with making more of the info structures shared
>between do and dump in genl :( 
>
>> Something like:
>> 
>>  	{
>>  		.cmd = DEVLINK_CMD_RATE_GET,
>>  		.doit = devlink_nl_cmd_rate_get_doit,
>> 		.dumpit_one = devlink_nl_cmd_rate_get_dumpit_one,
>> 		.dumpit_one_walk = devlink_nl_dumpit_one_walk,
>>  		.internal_flags = DEVLINK_NL_FLAG_NEED_RATE,
>>  		/* can be retrieved by unprivileged users */
>>  	},
>
>Growing the struct ops (especially the one called _small_) may be 
>a hard sale for a single user. For split ops, it's a different story,
>because we can possibly have a flag that changes the interpretation
>of the union. Maybe.
>
>I'd love to have a way of breaking down the ops so that we can factor
>out the filling of the message (the code that is shared between doit
>and dump). Just for the walk I don't think it's worth it.

Okay, that is something I thought about as well. Let me take a stab at
it.


>
>I went in the same direction as ethtool because if over time we arrive
>at a similar structure we can use that as a corner stone.
>
>All in all, I think this patch is a reasonable step forward. 

Yeah, could be always changed...


>But definitely agree that the genl infra is still painfully basic.

