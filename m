Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2604F4FDBC6
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 12:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239415AbiDLKHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387057AbiDLJFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 05:05:22 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D24205D0
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 01:16:30 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id t25so8737360edt.9
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 01:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3bS4Gs/OS8HMvvyJihorAJUzGOwxeGRo4DL+JHlr85E=;
        b=PhuJSi5tFR0F3r57lG+0ijQfdmeE9cw+wwbAknuD+yLI3HvuSYCSRaKC/fHYX2NHfL
         QaU0JX0C9eE0fBWI2YX3Ty3nHxiXaU6JhnaCIoXQiAoWHLWoexdJYX+f9P6VPbJ1VdlL
         H7ZiX0ZNDBZ0fSIfdy0qtzcrMqxr+kXRy0yPqedBNbkRSDxE9LltU347T7UThrYbwGML
         i91A2799Svdyw9NjLHDPZftpxVTYmiG0omjED2iod0nMrT7sCSI0nUjqu1TnWhs3XZzn
         gRFiBbmsw/s71finW81e2Z0fdjzOwNk03XDCpmzZLmjEnnEYTM9u/oHBRhIVdQt8P9cw
         RDKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3bS4Gs/OS8HMvvyJihorAJUzGOwxeGRo4DL+JHlr85E=;
        b=arY8HPBLYicEWrhoXCRlKnTZCOiXdZaukoxTgS9jFeLTP4NA2TXTIDJbvxW7/UY75S
         RZ29BauVt7llhzeJuRWzB4pFloc5VcrGDvaa4Z4a2Rjj0/nc8GsQIQJAnLAl4nM18yBr
         rreKP0ARrmttRo9ZezXnUGmBk+ITP620cUnAj5erQfi65PUaHmCramc0jcSmburVNm2K
         Y84SNYMe3jRp59+mtz1TsDi164RqnhVhBEbMO1BaVnixenkGSTHa+HE6Pg1Eiq74DgnQ
         JIXgvjZ+ytcjBgrBIakR9SpLkIg2SzlqIP/cGjKWyDQkYrIxBALZzwKG6Jg/h8HoL+ge
         miww==
X-Gm-Message-State: AOAM531o+6rS7jjFTkSi2hDpFnzAjpV3N7UvwEzNaZX8QOEzPvGi4yMX
        1+t5SGfaWbCYnUg3+6aBBnQQrQ==
X-Google-Smtp-Source: ABdhPJyrTn4wWLX14fAQCzbhVGwdjYX1qTB12cHa6FBYCM6kcCS4kkOiUpEX0wwpzuzQXNmxksEFpw==
X-Received: by 2002:a05:6402:5211:b0:419:583d:bb58 with SMTP id s17-20020a056402521100b00419583dbb58mr37278455edd.198.1649751388511;
        Tue, 12 Apr 2022 01:16:28 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id a18-20020a170906671200b006e05929e66csm12869532ejp.20.2022.04.12.01.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 01:16:27 -0700 (PDT)
Date:   Tue, 12 Apr 2022 10:16:26 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Guralnik <michaelgur@nvidia.com>, netdev@vger.kernel.org,
        jiri@nvidia.com, ariela@nvidia.com, maorg@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com
Subject: Re: [RFC PATCH net-next 0/2] devlink: Add port stats
Message-ID: <YlU1Wrn0zPbYN6pE@nanopsycho>
References: <20220407084050.184989-1-michaelgur@nvidia.com>
 <20220407201638.46e109d1@kernel.org>
 <YlQDmWEzhOyfhWev@nanopsycho>
 <20220411110157.7fcecc4b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411110157.7fcecc4b@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 11, 2022 at 08:01:57PM CEST, kuba@kernel.org wrote:
>On Mon, 11 Apr 2022 12:31:53 +0200 Jiri Pirko wrote:
>> Fri, Apr 08, 2022 at 05:16:38AM CEST, kuba@kernel.org wrote:
>> >On Thu, 7 Apr 2022 11:40:48 +0300 Michael Guralnik wrote:  
>> >> This patch set adds port statistics to the devlink port object.
>> >> It allows device drivers to dynamically attach and detach counters from a
>> >> devlink port object.  
>> >
>> >The challenge in defining APIs for stats is not in how to wrap a free
>> >form string in a netlink message but how do define values that have
>> >clear semantics and are of value to the user.  
>> 
>> Wait, does all stats have to be well-defined? I mean, look at the
>> ethtool stats. They are free-form strings too. Do you mean that in
>> devlink, we can only have well-defines enum-based stats?
>
>That's my strong preference, yes.
>
>First, and obvious argument is that it make lazy coding less likely
>(see devlink params).
>
>More importantly, tho, if your stats are not well defined - users don't
>need to seem them. Really! If I can't draw a line between a statistic
>and device behavior then keep that stat in the register dump, debugfs 

During the DaveM's-only era, there was quite strict policy against any
debugfs usage. As far as I remember the claim was, find of define the
proper api or do your debug things out-of-tree.

Does that changed? I just want to make sure that we are now free to use
debugfs for exposuse of debugging info as "odd vendor stats".
Personally, I think it is good idea. I think that the rest of the kernel
actually uses debugfs like that.

Thanks!

>or /dev/null.
>
>That's why it's important that we talk about _what_ you're trying to
>expose.

Basically a mixture of quite generic things and very obscure device
specific items.
