Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A1C647461
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiLHQdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:33:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiLHQdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:33:35 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E03278B8D
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 08:33:32 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id m18so5322027eji.5
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 08:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yhbNyPOuSCL+eOhWqCHG2jF3hhtQ8hMilmeaJX3NeuQ=;
        b=wJoMZ12ql5XRyQ6imrHkXsS0EhUG1xqSGHS9Yz6sej0c681knXUR9eOdVmR/bdlDGU
         dUbU52yF8DmOXekGI8+Rm9DVZwa499RaXk/KHYFgU2pYCC4wlB4SGsokhb8851cqjF98
         GJWsWDOKVKtaZZ/zKhkIw4WGeweqjlnnLPKV43rE2o/nYI4ek7iqM6VjpYbRC4s7dXaV
         FycNX6hieyRMLrl20geKvqoIo3/xcHspRU4QjhUkTRrU72gx+NxJv3G9UFOKtw64P5O7
         LzXJwPD3d0oQhnjGnG2oafAnWizXHaZgqHVPh22XieRV314ZzEWv4tstfQ8K2mUaY1Zh
         +yhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yhbNyPOuSCL+eOhWqCHG2jF3hhtQ8hMilmeaJX3NeuQ=;
        b=zCYMbeaXu1PuwO3gXQYYABkNubzTDjp1liC7JZrq0eJBcvC/gXaF3g27fIHUAm556R
         iIJ6cCObrv4F9BXz8/3+wVSyOH//X8gHhqxPO7ECEig6WZuYxGvzmIc91tgxKKkAn2/8
         Zj8aeUyfjnkW8Vb3GE9i9NuN2vZWLowwBuwqqlTTVdqlwu3MJR59E2dkE5BGEMk5yLbS
         50vjqymJ5aJLts1CO16stQcUFSfu8lSJQXJT6o1bO5utBEW7ugBw52NdXcyrpiRQ+l5g
         eEnvcQegtXjVyMV5XsmErOMFG2dPQ6PnI0ngq5P6TsGmvs/z6KhJ8D+A72kTTnfrJhF3
         32/g==
X-Gm-Message-State: ANoB5plql1oS0Zn2kyzTNYuybbAW2/xZvNqyWJTbqCVvcQBFnPZVtMxT
        uTSt0pVpcBi+mZDu9xbCXPQdPA==
X-Google-Smtp-Source: AA0mqf7/4lyR1JsE7IWetTnzdSSkURvlNoAPColT8k7GHxfHvnOsazhfqx0gseI5N7B3zFN0mpbzwQ==
X-Received: by 2002:a17:906:7254:b0:7b9:a74b:f0d1 with SMTP id n20-20020a170906725400b007b9a74bf0d1mr2157358ejk.38.1670517210993;
        Thu, 08 Dec 2022 08:33:30 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id zh6-20020a170906880600b007c136bb8160sm68566ejb.71.2022.12.08.08.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 08:33:29 -0800 (PST)
Date:   Thu, 8 Dec 2022 17:33:28 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vadim Fedorenko <vadfed@fb.com>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [RFC PATCH v4 2/4] dpll: Add DPLL framework base functions
Message-ID: <Y5IR2MzXfqgFXGHW@nanopsycho>
References: <Y4okm5TrBj+JAJrV@nanopsycho>
 <20221202212206.3619bd5f@kernel.org>
 <Y43IpIQ3C0vGzHQW@nanopsycho>
 <20221205161933.663ea611@kernel.org>
 <Y48CS98KYCMJS9uM@nanopsycho>
 <20221206092705.108ded86@kernel.org>
 <Y5CQ0qddxuUQg8R8@nanopsycho>
 <20221207085941.3b56bc8c@kernel.org>
 <Y5Gc6E+mpWeVSBL7@nanopsycho>
 <20221208081955.335ca36c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208081955.335ca36c@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 08, 2022 at 05:19:55PM CET, kuba@kernel.org wrote:
>On Thu, 8 Dec 2022 09:14:32 +0100 Jiri Pirko wrote:
>> >Running DPLL control in a namespace / container.
>> >
>> >I mean - I generally think netns is overused, but yes, it's what
>> >containers use, so I think someone may want to develop their
>> >timer controller SW in as a container?  
>> 
>> The netdevices to control are already in the container. Isn't that
>> enough?
>
>For DPLL config we need to delegate the permission.
>So we'd need a "is net admin in namespace X" check, no?

See below.


>
>> >> Thinking about it a bit more, DPLL itself has no network notion. The
>> >> special case is SyncE pin, which is linked to netdevice. Just a small
>> >> part of dpll device. And the netdevice already has notion of netns.
>> >> Isn't that enough?  
>> >
>> >So we can't use devlink or netdev. Hm. So what do we do?
>> >Make DPLLs only visible in init_net? And require init_net admin?
>> >And when someone comes asking we add an explicit "move to netns"
>> >command to DPLL?  
>> 
>> Well, as I wrote. The only part needed to be network namespaced are the
>> netdev related pins. And netdevices have netns support. So my question
>> again, why is that not enough?
>
>For config which goes thru rtnl, yes, but we also need a caps check for:
>
>+	DPLL_CMD_DEVICE_SET,
>+	DPLL_CMD_PIN_SET,

For any synce pin manipulation over dpll netlink, we can use the netns
check of the linked netdev. This is the netns aware leg of the dpll,
it should be checked for.

I can't imagine practically havind the whole dpll instance netns aware.
Omitting the fact that it really has no meaning for non-synce pins, what
would be the behaviour when for example pin 1 is in netns a, pin 2 in
netns b and dpll itself in netns c?
