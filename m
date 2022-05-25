Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204AF5336B6
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 08:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244122AbiEYGVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 02:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244140AbiEYGUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 02:20:54 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2245B6F491
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 23:20:49 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id n10so39585353ejk.5
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 23:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0EDKrWpzvrOWkjOY33aNmSMQYDZ4ZeRwnI35m/ZLC7s=;
        b=k59OSPVxbgPvZi/BqtDyjuouwzvJxYlY3/0wsEdypknz6s3lpqop9odfwUl3leDV8+
         ho0LrYjoRz9NaiZTQQPbXh6Mo1VJhEX6ljJokXuUl54VMOTYn2TIq8g6Fy9aPTqTX2/p
         vPrC/LARAlhrZNgkdqEOkAhB2sZuIfKEQDQDre0MhszELJ3y/mrn8AKZVpLBX5AaPrHe
         RGp3WpP5+0MCgRag1dDgVQfq1cDBQl/LtOguuVSqkIJ9k0ycV5DMPH5eUy7hYuDaP/En
         u0px3gf1kahLznhduigsRolsTYMnt3Q3zCX75XjeWULhXAj4y/5e2jMDoZIm+4VJUTE1
         8aIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0EDKrWpzvrOWkjOY33aNmSMQYDZ4ZeRwnI35m/ZLC7s=;
        b=ONO0fnSuEx0HnfOfEB2PdYZm9u2yCZxB8A1LtJ4bBXpyTDnd/1itzh2U/9ckfZJvgx
         8yC4BALt+c/LhIdXiO5VhHp/T2wC33RrtxSApWXn4vV+q+fkJPc99HM9tcOc5ddX42Ap
         B1WXVdlY/Au2R/GNpsmmElKJPF4cS7Rvc9kCsTbOOs3YShd3aezjjAe/66sYai/nymK3
         GyPbdd33uegoTPNAETxzBzNYV2hqkohXQtaoH/7V9AvJ2azSpn/5cQiiceW7ikc0Cqxo
         Uw7PVWvDyON3zOdb4Adek+263CQHA4Fwkl4gUCbT4jViZBTNz/NyztBZNI4rtPcgGxOv
         +jUw==
X-Gm-Message-State: AOAM5312WHYzvkpF3SusufplnN52qEqIhjgSQoAWLaEDk6N46lkoFUiH
        TgKT857eVsjLWv82WWv8N9/LNQ==
X-Google-Smtp-Source: ABdhPJwCf9B0dv/xQbIVle9h1/KwVJDrCOYZ7vM+j8LU+SHhpVIERf0NO2Ef+twMkGnOi6yWpfYRHg==
X-Received: by 2002:a17:906:22ce:b0:6fe:9403:a4c0 with SMTP id q14-20020a17090622ce00b006fe9403a4c0mr27400383eja.528.1653459647540;
        Tue, 24 May 2022 23:20:47 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id eb22-20020a170907281600b006f4c557b7d2sm5513287ejc.203.2022.05.24.23.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 23:20:46 -0700 (PDT)
Date:   Wed, 25 May 2022 08:20:45 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <Yo3KvfgTVTFM/JHL@nanopsycho>
References: <20220429114535.64794e94@kernel.org>
 <Ymw8jBoK3Vx8A/uq@nanopsycho>
 <20220429153845.5d833979@kernel.org>
 <YmzW12YL15hAFZRV@nanopsycho>
 <20220502073933.5699595c@kernel.org>
 <YotW74GJWt0glDnE@nanopsycho>
 <20220523105640.36d1e4b3@kernel.org>
 <Yox/TkxkTUtd0RMM@nanopsycho>
 <YozsUWj8TQPi7OkM@nanopsycho>
 <20220524110057.38f3ca0d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524110057.38f3ca0d@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 24, 2022 at 08:00:57PM CEST, kuba@kernel.org wrote:
>On Tue, 24 May 2022 16:31:45 +0200 Jiri Pirko wrote:
>> >Sure. I considered that. The thing is, even if you put the lc component
>> >names to output of "devlink dev info", you would need to provide lc
>> >objects as well (somehow) - to contain the versions.
>> >
>> >But the component name is related to lc object listed in "devlink lc",
>> >so "devlink lc info" sounds line the correct place to put it.
>> >
>> >If you are concern about "devlink dev flash" using component name from
>> >"devlink lc info", I would rather introduce "devlink lc flash" so you
>> >have a match. But from what I see, I don't really see the necessity for
>> >this match. Do you?  
>> 
>> Okay, we can eventually avoid using component name at all for now,
>> considering one flash object per linecard (with possibility to extend by
>> component later on). This would look like:
>> 
>> $ devlink lc info pci/0000:01:00.0 lc 8
>> pci/0000:01:00.0:
>>   lc 8
>>     versions:
>>         fixed:
>>           hw.revision 0
>> 	  fw.psid MT_0000000749
>>         running:
>>           ini.version 4
>>           fw 19.2010.1310
>> 
>> $ devlink lc flash pci/0000:01:00.0 lc 8 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2
>> 
>> I have to admit I like this.
>> We would reuse the existing DEVLINK_CMD_FLASH_UPDATE cmd and when
>> DEVLINK_ATTR_LINECARD_INDEX attribute is present, we call the lc-flash
>> op. How does this sound?
>
>We talked about this earlier in the thread, I think. If you need both
>info and flash per LC just make them a separate devlink instance and
>let them have all the objects they need. Then just put the instance
>name under lc info.

I don't follow :/ What do you mean be "separate devlink instance" here?
Could you draw me an example?
