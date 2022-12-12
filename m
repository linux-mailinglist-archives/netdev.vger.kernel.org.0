Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA7864A146
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 14:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbiLLNh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 08:37:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbiLLNh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 08:37:27 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D8F5F5E
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 05:36:54 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id h16so3150731wrz.12
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 05:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ItHz6t2ewO4AnHbrSJqvbUyq3yTnXlKp1R0Fb2eFkds=;
        b=N2O18U/7ySTvucEf23cqiCiMoo6yymhxiOdfsLFpMIFgk6WLdQebVN7kWzeF92iPPx
         qS1jbp91dpwVJU9qD7lWfOdvnyB1Z9zXgzFeQCbFVAwa8Scx0qeyPKmgO9sRQRrafypm
         9bd628nG3AkihVYcVcrYySalHBoPwgESBSq+r7CHOl7nnjd165JNugNl17u+Fd0HISHI
         Tzf79Tl4ehrOCy36xXKEBwdVfGdLXMUjC3riORtfKG6FOQTIzvIJr7MXYF/9lrkw4d8C
         5zXT6F4eEFMMsjRaPXfnA4RZsZBNDfvJbnc3GDaIyGLUbQtJG0U30JoNbigkqVmC0lpp
         okXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ItHz6t2ewO4AnHbrSJqvbUyq3yTnXlKp1R0Fb2eFkds=;
        b=YOizsM6GkhZShkU04hoLV8B5QPXEYWHcbJOjO6UbcGhCODI+Lmylj6HSITTiOI5iOZ
         VR9aG/LsEdo18WJLdFoYW78QO3RUwW/mDBGkqxXhwGh0jWVNVKx0/WZ4YD3Qhy0yagAZ
         LS1a4MRjDosm1W060BU2sNbMwqLKz6otvjkCInSapDUngXgreg9Ef/TKHK5yYwRvGpVD
         9Z3hpc3eZf+I7Bw0Lc06ZoNpETZskwWekh61zGQjqCwZxIgWUlu6ayyDPJtY1XJYI175
         nh6qx6HYm+ypKJNYp9BeRoG93S3npyKZblIEQViu+g6fGijuc+6q6jBuEi09YNxoVF7x
         biiQ==
X-Gm-Message-State: ANoB5pkCKwRXDkZ1yqO9+Nm13MUKOeilu0fYgulI6WFHT21T51Lzy+ag
        La6MA93uCPT+Vp8dyXGMohdHPQ==
X-Google-Smtp-Source: AA0mqf5ntngcCwZ7wE+zvEqGbMy3mZDegjmfiiJz2eOr5l/VJzQ14Lcfn8R1BgC9kCYQO1pZ9DbrMQ==
X-Received: by 2002:a5d:4888:0:b0:232:be5c:ec7e with SMTP id g8-20020a5d4888000000b00232be5cec7emr10190798wrq.58.1670852212799;
        Mon, 12 Dec 2022 05:36:52 -0800 (PST)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id z5-20020adff1c5000000b002258235bda3sm8944377wro.61.2022.12.12.05.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 05:36:51 -0800 (PST)
Date:   Mon, 12 Dec 2022 14:36:50 +0100
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
Message-ID: <Y5cucrZjsMgZcHDf@nanopsycho>
References: <Y48CS98KYCMJS9uM@nanopsycho>
 <20221206092705.108ded86@kernel.org>
 <Y5CQ0qddxuUQg8R8@nanopsycho>
 <20221207085941.3b56bc8c@kernel.org>
 <Y5Gc6E+mpWeVSBL7@nanopsycho>
 <20221208081955.335ca36c@kernel.org>
 <Y5IR2MzXfqgFXGHW@nanopsycho>
 <20221208090517.643277e8@kernel.org>
 <Y5MAEQ74trsNFQQc@nanopsycho>
 <20221209081942.565bc422@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209081942.565bc422@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Dec 09, 2022 at 05:19:42PM CET, kuba@kernel.org wrote:
>On Fri, 9 Dec 2022 10:29:53 +0100 Jiri Pirko wrote:
>> Thu, Dec 08, 2022 at 06:05:17PM CET, kuba@kernel.org wrote:
>> >On Thu, 8 Dec 2022 17:33:28 +0100 Jiri Pirko wrote:  
>> >> For any synce pin manipulation over dpll netlink, we can use the netns
>> >> check of the linked netdev. This is the netns aware leg of the dpll,
>> >> it should be checked for.  
>> >
>> >The OCP card is an atomic clock, it does not have any networking.  
>> 
>> Sure, so why it has to be netns aware if it has nothing to do with
>> networking?
>
>That's a larger question, IDK if broadening the scope of the discussion
>will help us reach a conclusion. 
>
>The patchset as is uses network namespaces for permissions:
>
>+		.flags	= GENL_UNS_ADMIN_PERM,

Yeah, I wonder if just GENL_ADMIN_PERM wuldn't be more suitable here...


>
>so that's what I'm commenting on - aligning visibility of objects with
>already used permissions.
>
>> >> I can't imagine practically havind the whole dpll instance netns aware.
>> >> Omitting the fact that it really has no meaning for non-synce pins, what
>> >> would be the behaviour when for example pin 1 is in netns a, pin 2 in
>> >> netns b and dpll itself in netns c?  
>> >
>> >To be clear I don't think it's a bad idea in general, I've done 
>> >the same thing for my WIP PSP patches. But we already have one
>> >device without netdevs, hence I thought maybe devlink. So maybe
>> >we do the same thing with devlink? I mean - allow multiple devlink
>> >instances to be linked and require caps on any of them?  
>> 
>> I read this 5 times, I'm lost, don't understand what you mean :/
>
>Sorry I was replying to both paragraphs here, sorry.
>What I thought you suggested is we scope the DPLL to whatever the
>linked netdevs are scoped to? If netns has any of the netdevs attached
>to the DPLL then it can see the DPLL and control it as well.

Okay, that would make sense.
GENL_UNS_ADMIN_PERM | GENL_UNS_ADMIN_PERM
then.

>
>What I was saying is some DPLL have no netdevs. So we can do the same
>thing with devlinks. Let the driver link the DPLL to one or more
>devlink instances, and if any of the devlink instances is in current
>netns then you can see the DPLL.

I don't think that would be needed to pull devlink into the picture.
If not netdev is linked to dpll, GENL_ADMIN_PERM would apply.

