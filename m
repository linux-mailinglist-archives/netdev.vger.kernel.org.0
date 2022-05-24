Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D996F532375
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 08:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbiEXGqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 02:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiEXGqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 02:46:45 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E3367D1E
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 23:46:43 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id er5so21741471edb.12
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 23:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aD2QKzn0n3/fi3HIeHhS7MyP9Kj1F8v+jusSQ5f3BvA=;
        b=xd3SOib+CoeepZ/WXUkyVcCMGJ0yzyF9jCySLQHuCmVIfK6RQmTVqx6A3v/76cvLWP
         rYYrIWQ1s/K8ehavQ0tHWCewTU/CokOt8PNTp3GAUJFEd8QVOCTdw0uKwQ9L2W+YEls4
         9o/UxEqnidaxc1ct4t2PyHWxPnNsCC49w6MQdQIsdSAjkG1aUWCuYZaMz9Z67jOkdX4O
         YNqGxQy0Y983035MsAxMKYtAUc2Hl5Xlfu25ZptEtKxUwMCcctaqEcs0r/GnRJDWlvXj
         197ZPimxkStpt7x1R0+szJjMgkPggocrRC++/caHCK385+1qqFY7B0TX/bFSrHbNuuw7
         4Llw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aD2QKzn0n3/fi3HIeHhS7MyP9Kj1F8v+jusSQ5f3BvA=;
        b=1+2VGzPw6kq7FceS/YsPwxOgq1nPUYbz2J0ZnfinpT67ZNMsl6rskbq1j7Jm0hCIj0
         7OPHWghesNiCTNqXpxPbD5b0+MrLz2b+V5zD6Y1QIWYYDN7F4/6XEVTXFWyjB587FhR+
         dvlBCJnJDLcaTNl+DzW3j4sfIRqPSjSvoxYPUUbydLMIGezCUKNf8OpQ5oONH6+HeQg1
         RsedTn+xY3apYfRhGCobJi66FSJX6VN2pvYY4qCWcWLMq4X4x564HPzjYFQkPhHEOmnD
         b6iOxbo2PHw57XbB0LmxOG3dMD5qM3kh/aYL+QGyYXr/Bb4WUyoKRs5zNykgVzLlZtAl
         dkRw==
X-Gm-Message-State: AOAM531yH0YNjVvoYJpUlz+iIjCxISzUhJ3W/+hMXlYedhRpE4GAadod
        50eABPoFdegze3QUYjkHIjitqw==
X-Google-Smtp-Source: ABdhPJwjJePRQ9qgj2Je/H8GQ4670aJwGx2U53EfyYBm+qEOHwZ318295bbmzR/9Ta/g7fbLmhp36Q==
X-Received: by 2002:aa7:d94b:0:b0:42a:b93b:c54f with SMTP id l11-20020aa7d94b000000b0042ab93bc54fmr27289748eds.246.1653374801635;
        Mon, 23 May 2022 23:46:41 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id st5-20020a170907c08500b006fedeb8b838sm2042221ejc.153.2022.05.23.23.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 23:46:39 -0700 (PDT)
Date:   Tue, 24 May 2022 08:46:38 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <Yox/TkxkTUtd0RMM@nanopsycho>
References: <YmjyRgYYRU/ZaF9X@nanopsycho>
 <20220427071447.69ec3e6f@kernel.org>
 <YmvRRSFeRqufKbO/@nanopsycho>
 <20220429114535.64794e94@kernel.org>
 <Ymw8jBoK3Vx8A/uq@nanopsycho>
 <20220429153845.5d833979@kernel.org>
 <YmzW12YL15hAFZRV@nanopsycho>
 <20220502073933.5699595c@kernel.org>
 <YotW74GJWt0glDnE@nanopsycho>
 <20220523105640.36d1e4b3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523105640.36d1e4b3@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, May 23, 2022 at 07:56:40PM CEST, kuba@kernel.org wrote:
>On Mon, 23 May 2022 11:42:07 +0200 Jiri Pirko wrote:
>> Mon, May 02, 2022 at 04:39:33PM CEST, kuba@kernel.org wrote:
>> >On Sat, 30 Apr 2022 08:27:35 +0200 Jiri Pirko wrote:  
>> >> Now I just want to use this component name to target individual line
>> >> cards. I see it is a nice fit. Don't you think?  
>> >
>> >Still on the fence.  
>> 
>> Why?
>
>IIRC my concern was mixing objects. We have component name coming from
>lc info, but then use it in dev flash.

Sure. I considered that. The thing is, even if you put the lc component
names to output of "devlink dev info", you would need to provide lc
objects as well (somehow) - to contain the versions.

But the component name is related to lc object listed in "devlink lc",
so "devlink lc info" sounds line the correct place to put it.

If you are concern about "devlink dev flash" using component name from
"devlink lc info", I would rather introduce "devlink lc flash" so you
have a match. But from what I see, I don't really see the necessity for
this match. Do you?


>
>> >> I see that the manpage is mentioning "the component names from devlink dev info"
>> >> which is not actually implemented, but exactly what I proposed.  
>> >
>> >How do you tie the line card to the component name? lc8_dev0 from 
>> >the flashing example is not present in the lc info output.  
>> 
>> Okay, I will move it there. Makes sense.
>
>FWIW I think I meant my comment as a way to underline that what you
>argue for is not what's implemented (assuming your "not actually
>implemented" referred to the flashing). I was trying to send you back 
>to the drawing board rather than break open a box of band-aides.

Sure, lets do this right, I don't want to band-aide anything...
