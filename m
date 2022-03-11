Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465C84D5E2A
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 10:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346808AbiCKJQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 04:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347295AbiCKJQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 04:16:37 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707AA1BBF68
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 01:15:33 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id b24so10089061edu.10
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 01:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MdWoUb+aD1fIo0KMkLy5nsm7umLLjKo8mlMCxpH0tL0=;
        b=INkhULeia1a3x9O2iW0uiwAxpxbX8wEk5NjmffE1xiux0HoluasVHC9RefrQno/wzu
         QjgY2kD02AGSIq0B/SdZBGDBT3Njn75GAC6rMj5wskbh90uImA7KMqA+0BZpu+3LczFl
         A+vnwf8riFBV28t26qozVwv2lcRIL7rFyxv8LTowHBFPsuEZ5rxVmhBi3usxcjsW+yyY
         SDDrntg9JbMMjvbpB0YUuB4XciP1gq74E2Ig9apXlgqr1WgkSPiwx6viVJeA/45JEuG0
         7EERrWG8MKxbcpFB6sp3VidorVfZOzrvpfrgBd4wmCeRHWIgjyUa8BPKcafu08G3zR+y
         jw4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MdWoUb+aD1fIo0KMkLy5nsm7umLLjKo8mlMCxpH0tL0=;
        b=m0b77bPnBJgYe2+IKL4hDnvhS0FIAvNTcgOr0uePO9b1UF0ceu9c36tmiSddWD2+Iq
         BgDYX/guAnHl7cZvqqZZP+l5CEjP4M0N2qgdbjQwj1Hybb+Uc5Wv8LejYXv6jKUZ+6Th
         KG2Fl0ra5LkKOU3UZO3/BcL8SoUQLeoYpS/SBLggSLb5PLOdYa0UYGYm7PHv2Bg+dwFa
         Vv4HPto1WcGZToT3cJkHP4DBAgvqoDocrlCVaX/c/1RLHSfm3WxXsZ8iQHHANGJog9a4
         iPkCP3VbPz8cOw7QCVSnfZcpiz3VdRh7dDDsxC4DfcurybgQ3MWmDZsdlH4V/+7UWOk9
         8VqA==
X-Gm-Message-State: AOAM531+QXH71seotvGRlja5hOBGeq5YSZwxERzRUs5GDJqQ7gKOPuKd
        Q5QZcH+gU41eZMQuw6kGYu4xhg==
X-Google-Smtp-Source: ABdhPJzICL9wW685TbJhiRsF3WeAsNaSbI02KJEeAtfB05jT3p/7JNAccU3i15mLg2cLbs6mD2OfdA==
X-Received: by 2002:a05:6402:209:b0:416:5211:841f with SMTP id t9-20020a056402020900b004165211841fmr8061394edv.59.1646990131829;
        Fri, 11 Mar 2022 01:15:31 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id n25-20020aa7db59000000b00415965e9727sm2981746edt.18.2022.03.11.01.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 01:15:31 -0800 (PST)
Date:   Fri, 11 Mar 2022 10:15:30 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        netdev@vger.kernel.org, leonro@nvidia.com
Subject: Re: [RFT net-next 1/6] devlink: expose instance locking and add
 locked port registering
Message-ID: <YisTMpcWif02S1VC@nanopsycho>
References: <20220310001632.470337-1-kuba@kernel.org>
 <20220310001632.470337-2-kuba@kernel.org>
 <YinBchYsWd/x8kiu@nanopsycho>
 <20220310120624.4c445129@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310120624.4c445129@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 10, 2022 at 09:06:24PM CET, kuba@kernel.org wrote:
>On Thu, 10 Mar 2022 10:14:26 +0100 Jiri Pirko wrote:
>> It is kind of confusing to have:
>> devlink_* - locked api
>> devl_* - unlocked api
>> 
>> And not really, because by this division, devl_lock() should be called
>> devlink_lock(). So it is oddly mixed..
>> 
>> I believe that "_" or "__" prefix is prefered here and everyone knows
>> with away what it it is good for.
>> 
>> If you find "__devlink_port_register" as "too much typing" (I don't),
>> why don't we have all devlink api shortened to:
>> devl_*
>> and then the unlocked api could be called:
>> __devl_*
>> ?
>
>The goal is for that API to be the main one, we can rename the devlink_
>to something else at the end. The parts of it which are not completely
>removed.

Okay. So please have it as:
devl_* - normal
__devl_* - unlocked

Thanks!


>
>> >+bool devl_lock_is_held(struct devlink *devlink)
>> >+{
>> >+	/* We have to check this at runtime because struct devlink
>> >+	 * is now private. Normally lock_is_held() should be eliminated  
>> 
>> "is now private" belong more to the patch description, not to the actual
>> code I believe.
>
>Alright. The comment started as a warning not to use this for anything
>but lockdep but I couldn't resist taking a dig at hiding the structure.
