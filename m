Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6EF665FD3B
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 10:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjAFI7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 03:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232810AbjAFI7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 03:59:38 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22E26879E
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 00:59:33 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d9so1055898pll.9
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 00:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sw3sp6r9vymtrtgrofpxGouclnST4oSk5PXU3tJTd6Y=;
        b=fEvFxUg8GYOJa5qJZ8gZCANmM3YuhFXrU4NnnXsREOu3m1c8OaCaM/6ssQxLOwgoK5
         r8UQc6j8mQhCSGzV0STazkt6O5AzmysmQ7hK8IVlxTE2zu+GXspNpLdHD3h1fGqBb6e9
         agqieBcSA/UbciWj+RtRbyU0lsFAgbhTDVGQbSkxb2Kt5hpm7PjMQHhzn/zDHFQd49Gc
         a85feNnPMABviCjD7uFCX2tH02nG88RF4+BWBl6OEJkX4MdOvKkUKeGiDT4slbvAre0F
         fK6QThd1ufF/cKApY8EGlxhv+vWhtr3zn6P0i77ENAzRezQWRARErgvLlwyFDiGvWZ6x
         gBFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sw3sp6r9vymtrtgrofpxGouclnST4oSk5PXU3tJTd6Y=;
        b=PIwU4y0ymEAcbmVe+t4vXsX7R4cN0vHmrRkUaWDfLnl/vSBlCzQ+kqPlj1bUYeBSVe
         +/RCW4ukspg9QQO8m/i8VDGywlIo+B7bN2KSPzaLlMsUbZY0HKUFQ3+KeyUsMnt5UlVw
         9It7BWHslNbmZpZxNmKN6//m9cn11bBiTsff/vBGLdwWlYr8ImnZjBn9rGEFWfTLUbLI
         F6eLNxLxmhN4jmgiamVmpdYqiYhXnbeSA9meH2bTlWotVUKGdx69HHZdr8FJQ7kppRMJ
         669d+Q9jgi1HGQVqHPNFmEbckX755sdzkf7/DwXGOJCC1ROHSQu5xcj8zQDBg3Fy6Em0
         gScQ==
X-Gm-Message-State: AFqh2kq/orwoueqzc5ngg7UI6EPeJCHqzABbXGdVpG5pLr+FUalM2d40
        sd0AmJ2KZSsO2ibipzZ+UqFhVQ==
X-Google-Smtp-Source: AMrXdXtq3+fsLo7FMkYY7uu9qDJmuVDMnySF4v8cHZ+msLX8d5uIZ3VVGVMotNrHKuBxRwOWgo3CMw==
X-Received: by 2002:a17:90a:5503:b0:219:6bf0:9861 with SMTP id b3-20020a17090a550300b002196bf09861mr57341302pji.10.1672995573519;
        Fri, 06 Jan 2023 00:59:33 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id m2-20020a17090a5a4200b00219220edf0dsm510070pji.48.2023.01.06.00.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 00:59:33 -0800 (PST)
Date:   Fri, 6 Jan 2023 09:59:30 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next v2 14/15] devlink: add by-instance dump infra
Message-ID: <Y7fi8tIYTlQp1PWo@nanopsycho>
References: <20230105040531.353563-1-kuba@kernel.org>
 <20230105040531.353563-15-kuba@kernel.org>
 <Y7aXXQUraJl6So2V@nanopsycho>
 <e460c958-625e-a7e7-6552-d3ce5334654f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e460c958-625e-a7e7-6552-d3ce5334654f@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 06, 2023 at 01:16:05AM CET, jacob.e.keller@intel.com wrote:
>
>
>On 1/5/2023 1:24 AM, Jiri Pirko wrote:
>> Thu, Jan 05, 2023 at 05:05:30AM CET, kuba@kernel.org wrote:
>>> Most dumpit implementations walk the devlink instances.
>>> This requires careful lock taking and reference dropping.
>>> Factor the loop out and provide just a callback to handle
>>> a single instance dump.
>>>
>>> Convert one user as an example, other users converted
>>> in the next change.
>>>
>>> Slightly inspired by ethtool netlink code.
>>>
>>> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>>> ---
>>> net/devlink/devl_internal.h | 10 +++++++
>>> net/devlink/leftover.c      | 55 ++++++++++++++++---------------------
>>> net/devlink/netlink.c       | 34 +++++++++++++++++++++++
>>> 3 files changed, 68 insertions(+), 31 deletions(-)
>>>
>>> diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
>>> index 15149b0a68af..734553beccde 100644
>>> --- a/net/devlink/devl_internal.h
>>> +++ b/net/devlink/devl_internal.h
>>> @@ -122,6 +122,11 @@ struct devlink_nl_dump_state {
>>> 	};
>>> };
>>>
>>> +struct devlink_gen_cmd {
>> 
>> As I wrote in reply to v1, could this be "genl"?
>> 
>
>Except Kuba already said this wasn't about "generic netlink" but
>"generic devlink command" vs "complicated command that can't use the new

Okay, that confuses me. What is supposed to be "generic devlink
command"? I don't see anything "generic" about these.


>iterator for whatever reason", so genl feels misleading.
>
>I guess gen is also kind of misleading but I can't think of anything better.
>
>> 
>>> +	int (*dump_one)(struct sk_buff *msg, struct devlink *devlink,
>>> +			struct netlink_callback *cb);
>>> +};
>>> +
>>> /* Iterate over registered devlink instances for devlink dump.
>>>  * devlink_put() needs to be called for each iterated devlink pointer
>>>  * in loop body in order to release the reference.
>> 
>> [...]
>> 
>> 
>>> @@ -9130,7 +9123,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
>>> 	{
>>> 		.cmd = DEVLINK_CMD_RATE_GET,
>>> 		.doit = devlink_nl_cmd_rate_get_doit,
>>> -		.dumpit = devlink_nl_cmd_rate_get_dumpit,
>>> +		.dumpit = devlink_nl_instance_iter_dump,
>> 
>> devlink_nl_instance_iter_dumpit to match ".dumpit".
>> 
>> 
>>> 		.internal_flags = DEVLINK_NL_FLAG_NEED_RATE,
>>> 		/* can be retrieved by unprivileged users */
>>> 	},
>> 
>> [...]
