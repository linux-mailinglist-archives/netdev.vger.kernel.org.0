Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3940164C467
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 08:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237443AbiLNHc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 02:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiLNHcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 02:32:25 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737BC13D01
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 23:32:23 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id i9so8410552edj.4
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 23:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y1iX53ofpqrzk0YZ6KNxGxfiNC7kqMLlKM8UTuzJUTY=;
        b=SqySALxQYMa1zWvs0VVjWBKFgrWM7hYJ6MjmSCsCJ0qS2z7Z5fL6KHXDZpKuD0TNd6
         vSH8b9osSg0RdIBSRmszn9lNPxxF78sdkQjSMs3ySnWa7FBBlBzrHXOc7r+k7wVIllZ9
         2MCRv/Hvy3qc6mKDv4bOPnAh3U0O5vispnqr4WYVuTaPlBAyRr+co+3DT82ca6m14wke
         rCsgnfs+TliA+eGtBqGVV8B4gLeSbaKzLLMTwXZnz+qLuwkI9QVZYwxfYGA3I49+ee9l
         rG7viLshSy8dbdy2whFJ+7mKkAHL2WW/EhZ5Q1nbUY0OwsRF2a3WTnsDt9brZwGhtRko
         qdpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y1iX53ofpqrzk0YZ6KNxGxfiNC7kqMLlKM8UTuzJUTY=;
        b=hL6hDPk23qQcuBxg3hMEssntml6F0ZEiEXui6OVjPT1lIPcNEZJBubjA8afppCrXh4
         3BBQuRnvGikxFTTroKsso/BUNcVLYvzFG9JQfOtRacf3wgfS8Wh2oM4dR2bxFCscHNW+
         hteJzQJAKA4Y+WY4yzuKN6QnD35+LBPVt3JJUkSIznHCe9TKeZuQMFAU9k8c5H7xb1z2
         hDn9EflGunW64OI4uopcNM/ipYDkfvnmn64NrEHITVygW6EUlGl45+L30niT5iwgf/RH
         x6MUfKWq1wgkp8Sn0WV5ifUf7kN0Zv527B9P5Wjsh03uQTcEDlu+2EshNH/mfYKpIeT+
         51Og==
X-Gm-Message-State: ANoB5pknAqhKwrmbSQmAS5HOaUscKS/RSDP8FNNBJeRozQaO8HdWwsxn
        ZJPmtXM4/CmJOM/KThlc89jVnY413EqG2lhKiXjdgQ==
X-Google-Smtp-Source: AA0mqf5E5OyQJdElpwGM8XN0xgmPjPP6McLdDoWBZvqHNWy+h8HvDmPxb/C3ceS4wUuqqDTX+FDZWw==
X-Received: by 2002:a05:6402:43ce:b0:46c:a43d:5e23 with SMTP id p14-20020a05640243ce00b0046ca43d5e23mr24265030edc.28.1671003141902;
        Tue, 13 Dec 2022 23:32:21 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id bf8-20020a0564021a4800b0045cf4f72b04sm5803587edb.94.2022.12.13.23.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 23:32:20 -0800 (PST)
Date:   Wed, 14 Dec 2022 08:32:19 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vadim Fedorenko <vadfed@fb.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [RFC PATCH v4 2/4] dpll: Add DPLL framework base functions
Message-ID: <Y5l8A+n5Vy5wRHXj@nanopsycho>
References: <Y5CQ0qddxuUQg8R8@nanopsycho>
 <20221207085941.3b56bc8c@kernel.org>
 <Y5Gc6E+mpWeVSBL7@nanopsycho>
 <20221208081955.335ca36c@kernel.org>
 <Y5IR2MzXfqgFXGHW@nanopsycho>
 <20221208090517.643277e8@kernel.org>
 <Y5MAEQ74trsNFQQc@nanopsycho>
 <20221209081942.565bc422@kernel.org>
 <Y5cucrZjsMgZcHDf@nanopsycho>
 <DM6PR11MB46577F9AB422103140778D529BE39@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB46577F9AB422103140778D529BE39@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Dec 13, 2022 at 07:08:13PM CET, arkadiusz.kubalewski@intel.com wrote:
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Monday, December 12, 2022 2:37 PM
>>To: Jakub Kicinski <kuba@kernel.org>
>>
>>Fri, Dec 09, 2022 at 05:19:42PM CET, kuba@kernel.org wrote:
>>>On Fri, 9 Dec 2022 10:29:53 +0100 Jiri Pirko wrote:
>>>> Thu, Dec 08, 2022 at 06:05:17PM CET, kuba@kernel.org wrote:
>>>> >On Thu, 8 Dec 2022 17:33:28 +0100 Jiri Pirko wrote:
>>>> >> For any synce pin manipulation over dpll netlink, we can use the
>>>> >> netns check of the linked netdev. This is the netns aware leg of
>>>> >> the dpll, it should be checked for.
>>>> >
>>>> >The OCP card is an atomic clock, it does not have any networking.
>>>>
>>>> Sure, so why it has to be netns aware if it has nothing to do with
>>>> networking?
>>>
>>>That's a larger question, IDK if broadening the scope of the discussion
>>>will help us reach a conclusion.
>>>
>>>The patchset as is uses network namespaces for permissions:
>>>
>>>+		.flags	= GENL_UNS_ADMIN_PERM,
>>
>>Yeah, I wonder if just GENL_ADMIN_PERM wuldn't be more suitable here...
>>
>>
>>>
>>>so that's what I'm commenting on - aligning visibility of objects with
>>>already used permissions.
>>>
>>>> >> I can't imagine practically havind the whole dpll instance netns
>>aware.
>>>> >> Omitting the fact that it really has no meaning for non-synce
>>>> >> pins, what would be the behaviour when for example pin 1 is in
>>>> >> netns a, pin 2 in netns b and dpll itself in netns c?
>>>> >
>>>> >To be clear I don't think it's a bad idea in general, I've done the
>>>> >same thing for my WIP PSP patches. But we already have one device
>>>> >without netdevs, hence I thought maybe devlink. So maybe we do the
>>>> >same thing with devlink? I mean - allow multiple devlink instances
>>>> >to be linked and require caps on any of them?
>>>>
>>>> I read this 5 times, I'm lost, don't understand what you mean :/
>>>
>>>Sorry I was replying to both paragraphs here, sorry.
>>>What I thought you suggested is we scope the DPLL to whatever the
>>>linked netdevs are scoped to? If netns has any of the netdevs attached
>>>to the DPLL then it can see the DPLL and control it as well.
>>
>>Okay, that would make sense.
>>GENL_UNS_ADMIN_PERM | GENL_UNS_ADMIN_PERM then.
>>
>
>I guess a typo here? Shall be: 'GENL_UNS_ADMIN_PERM | GENL_ADMIN_PERM'?

Yes, sure.

>Going to:
>- apply those bits for all the dpll netlink commands,
>- remove DPLLA_NETIFINDEX,
>- leave pin DPLLA_PIN_NETIFINDEX as is.
>
>Or I have missed something?

I believe it is ok.

>
>Thanks,
>Arkadiusz
>
>>>
>>>What I was saying is some DPLL have no netdevs. So we can do the same
>>>thing with devlinks. Let the driver link the DPLL to one or more
>>>devlink instances, and if any of the devlink instances is in current
>>>netns then you can see the DPLL.
>>
>>I don't think that would be needed to pull devlink into the picture.
>>If not netdev is linked to dpll, GENL_ADMIN_PERM would apply.
>
