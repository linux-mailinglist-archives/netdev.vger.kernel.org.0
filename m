Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF6448E737
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 10:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbiANJPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 04:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbiANJPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 04:15:53 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B422FC061574
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 01:15:52 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id c71so32686080edf.6
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 01:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=quryO0qOfzGa/kbX1EtKqH7pIhdfFZ4gpD2/EBowmNU=;
        b=NcmehltNOwMqDD4FIm6JqVJrs2cJdPenUy1j3JpeRVnDIPifWelqqn7nh3pOo7TJzE
         dsaje2M/UClAMfqM67XPx/SVUonzK0cXDg0cIrOAV2ihOiYi6GeYxJWn4LOkGRcrN7Kj
         DZe6q18HeMNqJ6Ko+n1ofzCJth1ikgHvvw5c0+XTuhmmrbHyqYmf754lZRMVCKuWbKq2
         UM0VMtKTBGIwr0rqhfAUbMnXLwqMggPUmAwfl7xnaAP6wZyy0Wi0RBh/sdaHrvObU/C7
         4cujHCwH9KJD/DGv44Pfs4+pjBcr4anU6f0Y91NMOh2yc+L7fYTq0Of1fI+kC9vCOT9y
         QeYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=quryO0qOfzGa/kbX1EtKqH7pIhdfFZ4gpD2/EBowmNU=;
        b=tll1Oy4M9m+4bEErpbLecdm1zlSSpBCtvCkxe51Th1iPliedi75Dh4xmSw0juOIWwK
         X4DEC+aGhF+9ZoY5p5xiRZgq0zTbEO9h+BdkevZsuDYrJ4sdVoVdaPL2ARIeJ23Cgf/8
         HJU9qEuMFF8vM1KCFP+Mickc4HzUl1MYYS7g1p/QA3flAlnH8ZkhSsjUwP5EKRnlQ1S9
         D0iaofnLHR6zxMUD4M3ivDUxVLbaK+QKJjxAJQHxFTxpRU2hhieiDIlbc7N6Oq/EBrqw
         b3U8f9rQq7rJCwH6qYOjnKvgLOrOrzDk1cJWARlaIYWJvd3vsYIIGkaAdA3t8AeXgT1q
         GyoQ==
X-Gm-Message-State: AOAM531Pw+CJ7uZCY0zXZC5CxOKBuSd2VLhxvzu5Jf3P4f1S4Y1m6IPv
        7EPIYCWhotuAs3JmEO9oE1EZog==
X-Google-Smtp-Source: ABdhPJw+R4J3kKw7k7H1SSE3vDPJ4gH8TE5YpHwWkA6AjbWE/06mutrOaQPw/Oksb0afaaGoLkXjyQ==
X-Received: by 2002:a05:6402:40cf:: with SMTP id z15mr7848222edb.185.1642151751207;
        Fri, 14 Jan 2022 01:15:51 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id hs30sm1658263ejc.1.2022.01.14.01.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 01:15:50 -0800 (PST)
Date:   Fri, 14 Jan 2022 10:15:49 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Parav Pandit <parav@nvidia.com>,
        Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Message-ID: <YeE/RfKb0bxQmJOq@nanopsycho>
References: <5c4b51aecd1c5100bffdfab03bc76ef380c9799d.camel@nvidia.com>
 <20211202093110.2a3e69e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d0df87e28497a697cae6cd6f03c00d42bc24d764.camel@nvidia.com>
 <20211215112204.4ec7cf1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1da3385c7115c57fabd5c932033e893e5efc7e79.camel@nvidia.com>
 <20211215150430.2dd8cd15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <SN1PR12MB2574E418C1C6E1A2C0096964D4779@SN1PR12MB2574.namprd12.prod.outlook.com>
 <20211216082818.1fb2dff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR12MB54817CE7826A6E924AE50B9BDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220111102005.4f0fa3a0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111102005.4f0fa3a0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 11, 2022 at 07:20:05PM CET, kuba@kernel.org wrote:
>On Tue, 11 Jan 2022 16:57:54 +0000 Parav Pandit wrote:
>> > > What shortcomings do you see in the finer granular approach we want to
>> > > go to enable/disable On a per feature basis instead of global knob?  
>> > 
>> > I was replying to Saeed so I assumed some context which you probably lack.
>> > Granular approach is indeed better, what I was referring to when I said "prefer
>> > an API as created by this patch" was having an dedicated devlink op, instead of
>> > the use of devlink params.  
>> 
>> This discussed got paused in yet another year-end holidays. :)
>> Resuming now and refreshing everyone's cache.
>> 
>> We need to set/clear the capabilities of the function before deploying such function.
>> As you suggested we discussed the granular approach and at present we have following features to on/off.
>> 
>> Generic features:
>> 1. ipsec offload
>
>Why is ipsec offload a trusted feature?
>
>> 2. ptp device
>
>Makes sense.
>
>> Device specific:
>> 1. sw steering
>
>No idea what that is/entails.
>
>> 2. physical port counters query
>
>Still don't know why VF needs to know phy counters.
>
>> It was implicit that a driver API callback addition for both types of features is not good.
>> Devlink port function params enables to achieve both generic and device specific features.
>> Shall we proceed with port function params? What do you think?
>
>I already addressed this. I don't like devlink params. They muddy the
>water between vendor specific gunk and bona fide Linux uAPI. Build a
>normal dedicated API.

Well, that is indeed true. But on the other hand, what is the alternative
solution? There are still going to be things wich are generic and driver-
specific. Params or no params. Or do you say we need some new well
defined enum-based api for generic stuff and driver-speficic will just
go to params?

