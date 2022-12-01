Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F46D63F051
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 13:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbiLAMUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 07:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiLAMUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 07:20:15 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE283AB029
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 04:20:13 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id e13so2097668edj.7
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 04:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fc+NfI1G82VXbsLpV9SBOH8Z0UVjn9b22k9eXKpSu+A=;
        b=igM/rfz9FSWsLH64YVJ1PC0OhgrpvQCOkLYY1HUrVb2ucZlbMZ0BJphPgmkkrAB3wc
         aM/1XgxEIaNUXgMCdEELmnD79mkw+wWWw8t8Gw7zQMj+4l12wEqfLP27U+4zhROMrywV
         +C0m2pNbEmSKnuieER2zmtC8EYTU4ECxO2FPlRWGV70blVU2nnxUZ29a8f5WmTU/Oc7W
         XpVSDMQU30lJMd/9CEEn7EBCxqYabzy9MR0RXjfoJd5tMFHxO8sZNQRPz9TupdrIjKkn
         A/tOxJ2kmphg16JYtfiMYRgbLyU/BkPfdzwiwJ2F6dmNHXmf7+MabNXrd8ERyvVwVFwD
         rnxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fc+NfI1G82VXbsLpV9SBOH8Z0UVjn9b22k9eXKpSu+A=;
        b=7gY8/PAjQY7OynnPEvqmL6TsfhHifQgQh7e2pJhH66dRHivIIvhdN5tqGazNeE4DLs
         qKbZXK1hZO68XJZ+EW7AqxHxrZnwU2w6205ShAMTtSUJxafy2Iz0tMsPjeTSKLmo77SG
         4eYhfXNAOdwPDOHKq28B+0EPGV/xwnLpExALucTDXNNIYtad5q7B9MnNc9j219jnAsCp
         L7cHmrjlQYTZB3gWD+iWFWa/9T5AxrUxBrkjf/G4/xERm1nydlAX9JUKgqr4fMSVwWlc
         D+6qKQbbfsNCzUSfEMDzQIIqwAOb2JvZ33pO8rpsH3vZn6j13GegMLG54JRoy/BbM5Rl
         hB8w==
X-Gm-Message-State: ANoB5pncLIjviIh2ylJndhPQqFSMWIqnrn2/XKB6QKUDlAtmd2b5bry9
        VnAFpJbfoK6fhIiwEXagxMbWyQ==
X-Google-Smtp-Source: AA0mqf6NGwJKbLZaHfx0Cq3Vv182k1Tl8AK+iaWeVXtUzggAgEjGzgGunEsofFJziwhM0QuJMQl6sg==
X-Received: by 2002:a05:6402:19a:b0:460:7413:5d46 with SMTP id r26-20020a056402019a00b0046074135d46mr59984984edv.47.1669897212128;
        Thu, 01 Dec 2022 04:20:12 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id gi20-20020a1709070c9400b0077d6f628e14sm1732893ejc.83.2022.12.01.04.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 04:20:10 -0800 (PST)
Date:   Thu, 1 Dec 2022 13:20:10 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        netdev@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <Y4ib+gOo50lpbEWS@nanopsycho>
References: <20221128102043.35c1b9c1@kernel.org>
 <Y4XDbEWmLRE3D1Bx@nanopsycho>
 <20221129181826.79cef64c@kernel.org>
 <Y4dBrx3GTl2TLIrJ@nanopsycho>
 <20221130084659.618a8d60@kernel.org>
 <Y4eMFUBWKuLLavGB@nanopsycho>
 <20221130092042.0c223a8c@kernel.org>
 <Y4etAg+vcnRCMWx9@unreal>
 <Y4hoYI/eidosRvHt@nanopsycho>
 <Y4h8cvsa+6LT/Yq+@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4h8cvsa+6LT/Yq+@unreal>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 01, 2022 at 11:05:38AM CET, leon@kernel.org wrote:
>On Thu, Dec 01, 2022 at 09:40:00AM +0100, Jiri Pirko wrote:
>> Wed, Nov 30, 2022 at 08:20:34PM CET, leon@kernel.org wrote:
>> >On Wed, Nov 30, 2022 at 09:20:42AM -0800, Jakub Kicinski wrote:
>> >> On Wed, 30 Nov 2022 18:00:05 +0100 Jiri Pirko wrote:
>> >> > Wed, Nov 30, 2022 at 05:46:59PM CET, kuba@kernel.org wrote:
>> >> > >On Wed, 30 Nov 2022 12:42:39 +0100 Jiri Pirko wrote:  
>> >> > >> **)
>> >> > >> I see. With the change I suggest, meaning doing
>> >> > >> devlink_port_register/unregister() and netdev_register/unregister only
>> >> > >> for registered devlink instance, you don't need this at all. When you
>> >> > >> hit this compat callback, the netdevice is there and therefore devlink
>> >> > >> instance is registered for sure.  
>> >> > >
>> >> > >If you move devlink registration up it has to be under the instance
>> >> > >lock, otherwise we're back to reload problems. That implies unregister
>> >> > >should be under the lock too. But then we can't wait for refs in
>> >> > >unregister. Perhaps I don't understand the suggestion.  
>> >> > 
>> >> > I unlock for register and for the rest of the init I lock again.
>> >> 
>> >> The moment you register that instance callbacks can start coming.
>> >> Leon move the register call last for a good reason - all drivers
>> >> we looked at had bugs in handling init.
>> >
>> >Plus we had very cozy lock->unlock->lock sequences during devlink
>> >command execution, which caused to races between devlink calls
>> >and driver initialization.
>> 
>> So? Why do you think it is a problem?
>
>We need to see the actual implementation. In general, once you unlock
>you can get other threads to change the state of your device.

Sure, I still don't understand, why it would be a problem.

>
>> 
>> >
>> >So I'm also interested to see what Jiri meant by saying "I unlock for
>> >register and for the rest of the init I lock again".
>> >
>> >Thanks
