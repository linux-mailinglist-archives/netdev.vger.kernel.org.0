Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1CEB63EB48
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 09:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiLAIkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 03:40:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiLAIkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 03:40:04 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F388567A
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 00:40:03 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id e27so2426421ejc.12
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 00:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RYNS/NztJ+ZZV+g89QNmeI2ha5ebwWLgf5AVmBqc2dg=;
        b=dAmjoZcDVxU9LEABRXEdXbE9c+dNRnmyqKDu/zEXjaAeGR6F/QNyxR1HLGoJICfMJT
         iU3Y4mhQjfRnk8qbdzFlnIGQ4tPbM+PAE9BxM2U3ES0X8SKh0ViERXmUrLjaLhCiAbVc
         kHzNRBb/0rgq0WGcUfi9q3fJUURtmfEhvrsbiAWbUqiHsMBAwFe3ayTi+YyxNVdG36zs
         sfhPIBuDglkSA7V/+h8SxjlZQqCA+61tzPibSC7HvgZawQGTYg5LshWZAp5HuvZOHAZ1
         AFLNTRt0+DxVb0szqNCjH6wd8HP5rVDmuye0prt2FAq4MnmwRXmqqetWoN6PPx8SZyQm
         nF2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RYNS/NztJ+ZZV+g89QNmeI2ha5ebwWLgf5AVmBqc2dg=;
        b=mpS8GvaK4YLtBWCpgvXrc+Ruqm2yOhW2EEtRsmxOyc4D1H+cp6EMjZMn9/8bsjoL00
         1KD/8oRAd8D1eox9c0ZCFOnga+2Nd/2gObNcMqJxdRIAl63UMSPxpoyQXDOs8NE8GoHO
         Jt0mJXeC9s09S032MfLnpMIZJrE7RmSmGCUXTaAsDf3vySTS0bEPUUHruC1ZH2zvF4H5
         P3kRw/0KFBKRqYOq5FUVThMjBEAxBYMTKTGW+f1fhl4gkrO/O86WS2mE9/gcjKh9ShY4
         9ZkMjjLdlIMku5RucWE6Tjf0OzU5oI/CSR7MyXDXYMudwFNFyG05zyAMQWHr5GpzZMRt
         FnXA==
X-Gm-Message-State: ANoB5pkRUzadrMH+pHBM0YZqlLJ3wpuVxSdUUuCETfrYxk1dNGBHjRkw
        SwZuILkMi7blicUpzKD77v/w6Q==
X-Google-Smtp-Source: AA0mqf7/S9UzML9SqVZ78U0XMGj2AqoHkUWXzkH9uBXLaPOX1Kdlf99SQ4HCaRjZYExWtBq5OVbvXQ==
X-Received: by 2002:a17:906:d295:b0:7c0:aff1:f1b6 with SMTP id ay21-20020a170906d29500b007c0aff1f1b6mr1429772ejb.418.1669884001679;
        Thu, 01 Dec 2022 00:40:01 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id i9-20020a170906698900b007bff9fb211fsm1522207ejr.57.2022.12.01.00.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 00:40:01 -0800 (PST)
Date:   Thu, 1 Dec 2022 09:40:00 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        netdev@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <Y4hoYI/eidosRvHt@nanopsycho>
References: <Y4R9dT4QXgybUzdO@shredder>
 <Y4SGYr6VBkIMTEpj@nanopsycho>
 <20221128102043.35c1b9c1@kernel.org>
 <Y4XDbEWmLRE3D1Bx@nanopsycho>
 <20221129181826.79cef64c@kernel.org>
 <Y4dBrx3GTl2TLIrJ@nanopsycho>
 <20221130084659.618a8d60@kernel.org>
 <Y4eMFUBWKuLLavGB@nanopsycho>
 <20221130092042.0c223a8c@kernel.org>
 <Y4etAg+vcnRCMWx9@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4etAg+vcnRCMWx9@unreal>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 30, 2022 at 08:20:34PM CET, leon@kernel.org wrote:
>On Wed, Nov 30, 2022 at 09:20:42AM -0800, Jakub Kicinski wrote:
>> On Wed, 30 Nov 2022 18:00:05 +0100 Jiri Pirko wrote:
>> > Wed, Nov 30, 2022 at 05:46:59PM CET, kuba@kernel.org wrote:
>> > >On Wed, 30 Nov 2022 12:42:39 +0100 Jiri Pirko wrote:  
>> > >> **)
>> > >> I see. With the change I suggest, meaning doing
>> > >> devlink_port_register/unregister() and netdev_register/unregister only
>> > >> for registered devlink instance, you don't need this at all. When you
>> > >> hit this compat callback, the netdevice is there and therefore devlink
>> > >> instance is registered for sure.  
>> > >
>> > >If you move devlink registration up it has to be under the instance
>> > >lock, otherwise we're back to reload problems. That implies unregister
>> > >should be under the lock too. But then we can't wait for refs in
>> > >unregister. Perhaps I don't understand the suggestion.  
>> > 
>> > I unlock for register and for the rest of the init I lock again.
>> 
>> The moment you register that instance callbacks can start coming.
>> Leon move the register call last for a good reason - all drivers
>> we looked at had bugs in handling init.
>
>Plus we had very cozy lock->unlock->lock sequences during devlink
>command execution, which caused to races between devlink calls
>and driver initialization.

So? Why do you think it is a problem?

>
>So I'm also interested to see what Jiri meant by saying "I unlock for
>register and for the rest of the init I lock again".
>
>Thanks
