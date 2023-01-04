Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5E665D876
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 17:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239896AbjADQPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 11:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239895AbjADQOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 11:14:45 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D1A42E1D
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 08:14:14 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id l26so24383570wme.5
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 08:14:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uTjf/6W4GhV8Irl4//iLBJvZ3uSMD2mcapAXLr0Opbg=;
        b=J7EGMUhgJvBFkWGV5lKmsLYJ8CY5xnugIWgJt2I2bTLoHwDy1ILZFkPpDC1aAJV3qY
         Lb871UUSYIGpfMCTZmheW7HnKqxfy+DqU4SV1zMk4Hjn94PiC+HaVfP1L0r27/PCVKW2
         3FD+vBC8c8yA9GD95E911IGjForztVTkvLoUPBGNR01++2rvSOUY83uL0mkGiKY+adR4
         1HbrdZ7cfQMvh4B5kdD8jXo2NJS1RJW6cuPXPcZWuVWzm/7grX4kL5bjkN4GRRH4rZLA
         gv9Hglycw5O4Ul94PyjpQwoD2NZ381EKDepkmSN1rK8zHFPSd81lrssRsGL6S0Qk3QAv
         UY9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uTjf/6W4GhV8Irl4//iLBJvZ3uSMD2mcapAXLr0Opbg=;
        b=TPGxHp+QA4AeMX/TyWuUE4ewGPZh64rTdYpO9d2vVCLrtXl8pWOi0iSBcLxF0bUJx7
         zua/yX2dHGW/1QF+RgNZyufjCimA12icpXSfPY7Zp5ikRU6wslZnLW6FTnk0Lc4mB17t
         b9ot0PPBekm0NhjXjpQlqjUdoGA0HUTefjfLE5vvnSP4zn4rQ3+aCw0maxklOpyyZC1R
         rKpCqUEVU1EWDifEiasyyvGKTOsM/f7hKqEkPshuEmR47q4rS6itzOPsOSceq8J8y/KP
         a82mc0LFTVBH22uAhYQ7VPfEZWHJtHw8XnB6PEPZx0xbAnlZb2/7N36e57DUXQxQUd5G
         zJ4Q==
X-Gm-Message-State: AFqh2kqzebFK2qc3h4gEo6mvniBcRb30/su502jjK/C7ia66GtwteY6I
        Pcg1ifLc7fFW4B2rUnYryewzcpV6lvoJqeOR/Cc=
X-Google-Smtp-Source: AMrXdXtztem5UTop5goAANvP3rjGDJuelcN6nLO70tNAXY5ulzv8UGlFQMp9nDgmrYddseLjBgXQkw==
X-Received: by 2002:a05:600c:3495:b0:3c6:e62e:2e74 with SMTP id a21-20020a05600c349500b003c6e62e2e74mr34609244wmq.15.1672848853130;
        Wed, 04 Jan 2023 08:14:13 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id v9-20020a05600c444900b003d997e5e679sm32472550wmn.14.2023.01.04.08.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 08:14:12 -0800 (PST)
Date:   Wed, 4 Jan 2023 17:14:11 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 04/10] devlink: always check if the devlink
 instance is registered
Message-ID: <Y7Wl021n/jSJYrWJ@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
 <20221217011953.152487-5-kuba@kernel.org>
 <Y7Li+GMB6BU+D/6W@nanopsycho>
 <20230102150514.6321d2ae@kernel.org>
 <Y7P0tE3+PyJSwaUC@nanopsycho>
 <20230103184959.621f4b9c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103184959.621f4b9c@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 04, 2023 at 03:49:59AM CET, kuba@kernel.org wrote:
>On Tue, 3 Jan 2023 10:26:12 +0100 Jiri Pirko wrote:
>> >> Why "alive"? To be consistent with the existing terminology, how about
>> >> to name it devl_is_registered()?  
>> >
>> >I dislike the similarity to device_is_registered() which has very
>> >different semantics. I prefer alive.  
>> 
>> Interesting. Didn't occur to me to look into device.h when reading
>> devlink.c code. I mean, is device_register() behaviour in sync with
>> devlink_register?
>> 
>> Your alive() helper is checking "register mark". It's an odd and unneded
>> inconsistency in newly added code :/
>
>Alright.
>
>> >> Also, "devl_" implicates that it should be called with devlink instance
>> >> lock held, so probably devlink_is_registered() would be better.  
>> >
>> >I'm guessing you realized this isn't correct later on.  
>> 
>> From what I see, no need to hold instance mutex for xa mark checking,
>> alhough I understand why you want the helper to be called with the lock.
>> Perhaps assert and a little comment would make this clear?
>
>I'll add the comment. The assert would have to OR holding the subobject
>locks. Is that what you had in mind?

Ah right, the subobject locks. That will go away I'm sure. Yes, that is
what I had in mind. After that, we can put assert here.

