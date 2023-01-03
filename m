Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D59C65BD20
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 10:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbjACJ0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 04:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbjACJ0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 04:26:18 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41DC25FD
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 01:26:16 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id j17so23446103wrr.7
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 01:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VlrZIWiKPKU8EIa8obi0s4xu7XouDrgxHg+8ro+SG3k=;
        b=4KFQHsXarwcjk4U6fF6ZfoPAPWb/KRSyDGnIL4vza7YZjDs6AebbuPpha/izJSuqGN
         UWTVwV5h0a3cEQweCnD0uV2V8Sx3631c0DfhGd4cQo7g/WG7ydqa0+aZkV7vkRcxP548
         K7VpYBQ/b7zC42yTEbezLBdCFB7Djl7FVwwjd9AObARPOfA470uEms+9G6GDEfFJi4P3
         NrF0jRW6OkNZz1GVhy/sMmzwYaKsOiFmSqaktcIbzPsUxjGGt8zqC5EdOw2U4zXtQice
         jvtob9LK50IT2AJqJRlOpr3JkXrZpXc4P4AVpHhM6w4OMwNhKA5YahQ39kuVzzYzYqjq
         Y+0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VlrZIWiKPKU8EIa8obi0s4xu7XouDrgxHg+8ro+SG3k=;
        b=fVa5aMqabaC1/6/pbV0HqGAjJmpzX0cowy6zlecBOLcL4O2/N5LPxuEwFeQ/U71K4M
         cyIezLWQOaPOWEiLv8qX1Obhsn7XnODLRVRXfXtTbclRxje3/7ZGreDxdsSgi1pAS/sV
         DXiqMeXZ3we3Qqi7USZfFdQxy2Omh3HIMZGUQsVpsOhAG0bGInfDMpQTz1iZ25JOXCux
         oax92oJlaGs5CsRz5kn2mM5Dsdek4CPeq0FtFygzG+gGC3PJ2OJKmjLULfq+18wUk3MM
         YWI9SSNDpzq7P7D4kl1ky3j+aIrJ6NJXQ8+XiWikSma9PD/Ey8MGaeJ8ksNU70gjfy6T
         hUgw==
X-Gm-Message-State: AFqh2kqTq0JoxgSuiKoJJmjGDnJnmuXiiV4iLh1yqa6yjvv9vHu1yr7+
        A43d3uoqMUwwhP1YyfzvNY/SsQ==
X-Google-Smtp-Source: AMrXdXuxHCgQeNrXBd7kyLDkOz/J5qZaYukQpLyfAwbQDCHwG0atVU5aMJersboEYdx4xLXvtj1vHw==
X-Received: by 2002:a5d:408c:0:b0:298:5b78:9e0a with SMTP id o12-20020a5d408c000000b002985b789e0amr4011952wrp.34.1672737975106;
        Tue, 03 Jan 2023 01:26:15 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id j1-20020adfff81000000b0024cb961b6aesm30034691wrr.104.2023.01.03.01.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 01:26:14 -0800 (PST)
Date:   Tue, 3 Jan 2023 10:26:12 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 04/10] devlink: always check if the devlink
 instance is registered
Message-ID: <Y7P0tE3+PyJSwaUC@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
 <20221217011953.152487-5-kuba@kernel.org>
 <Y7Li+GMB6BU+D/6W@nanopsycho>
 <20230102150514.6321d2ae@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102150514.6321d2ae@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 03, 2023 at 12:05:14AM CET, kuba@kernel.org wrote:
>On Mon, 2 Jan 2023 14:58:16 +0100 Jiri Pirko wrote:
>> Sat, Dec 17, 2022 at 02:19:47AM CET, kuba@kernel.org wrote:
>> >Always check under the instance lock whether the devlink instance
>> >is still / already registered.
>> >
>> >This is a no-op for the most part, as the unregistration path currently
>> >waits for all references. On the init path, however, we may temporarily
>> >open up a race with netdev code, if netdevs are registered before the
>> >devlink instance. This is temporary, the next change fixes it, and this
>> >commit has been split out for the ease of review.
>> >
>> >Note that in case of iterating over sub-objects which have their
>> >own lock (regions and line cards) we assume an implicit dependency
>> >between those objects existing and devlink unregistration.  
>> 
>> This would be probably very valuable to add as a comment inside the code
>> for the future reader mind sake.
>
>Where, tho?
>
>I'm strongly against the pointlessly fine-grained locking going forward
>so hopefully there won't be any more per-subobject locks added anyway.

Agreed. That is what I suggested in the other thread too.


>
>> >+bool devl_is_alive(struct devlink *devlink)  
>> 
>> Why "alive"? To be consistent with the existing terminology, how about
>> to name it devl_is_registered()?
>
>I dislike the similarity to device_is_registered() which has very
>different semantics. I prefer alive.

Interesting. Didn't occur to me to look into device.h when reading
devlink.c code. I mean, is device_register() behaviour in sync with
devlink_register?

Your alive() helper is checking "register mark". It's an odd and unneded
inconsistency in newly added code :/


>
>> Also, "devl_" implicates that it should be called with devlink instance
>> lock held, so probably devlink_is_registered() would be better.
>
>I'm guessing you realized this isn't correct later on.

From what I see, no need to hold instance mutex for xa mark checking,
alhough I understand why you want the helper to be called with the lock.
Perhaps assert and a little comment would make this clear?


>
>> >+{
>> >+	return xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
>> >+}
>> >+EXPORT_SYMBOL_GPL(devl_is_alive);
>> >+
>> >+/**
>> >+ * devlink_try_get() - try to obtain a reference on a devlink instance
>> >+ * @devlink: instance to reference
>> >+ *
>> >+ * Obtain a reference on a devlink instance. A reference on a devlink instance
>> >+ * only implies that it's safe to take the instance lock. It does not imply
>> >+ * that the instance is registered, use devl_is_alive() after taking
>> >+ * the instance lock to check registration status.
>> >+ */  
>> 
>> This comment is not related to the patch, should be added in a separate
>> one.
>
>The point of adding this comment is to say that one has to use
>devl_is_alive() after accessing an instance by reference.
>It is very much in the right patch.

Gotha! My mistake, sorry.


