Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4D72B84FD
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 20:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgKRTg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 14:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgKRTg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 14:36:29 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D70C0613D4;
        Wed, 18 Nov 2020 11:36:29 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id m9so3280495iox.10;
        Wed, 18 Nov 2020 11:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NFxIz4DFF3gZxGeuDXZ4yoOt17ZqxeXR60fCHkT4skI=;
        b=RMPan1xWTHuhyPAXBRZZwRayvHftLGVdRvFdzCIbKr/3wsIWxjSxx4js8nnkBLkMus
         O7Lax3ZoVS/2h6XlYcOifD1TwJaeGK5FjeDc9gWi9Im1hShb/iVr0/wKCG1cZs9tu2k5
         LC2XdoNjLJacvUGC2CWIsLkypi7LIjIAlc/j5HPcLeq5+v7E4nE1Ku0fiVqAV4hUSOQI
         ouQfUU+HZRMVuMMw/F/UtzzSFrJ9Wz1L2iknEheRLwtierERAsgeIjKbHWuybx422YWy
         Y+kmp19YYGaIASsgfYo8MN3cMHjUCj4dh/yqkzDNl4DAVpQILvJ3CyfYjsONPdzfWqto
         dONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NFxIz4DFF3gZxGeuDXZ4yoOt17ZqxeXR60fCHkT4skI=;
        b=mLQ89kzGcie/d3y6yXZOcbrbFxeUyWvyg+Nq4Lyg5XBsHrpld04YMhG7ikIcBugObq
         EcQUIBRl+Ko14WR7bmZ9uIrYpL3/lJd59nXg9M3hQ74mMVl77hxwSUXgOdnrbCTXCmKC
         I+G8Jen37v8Bd1tCGHTZnNlacS6oqj+0ge1tsez0te4DEh9qCqs9h8Tv/4wMb04/0cnX
         vEWNl5+fy5DHl8zbcLymYCRHD/VBHQafcUMRHk3BdkENhzKnrnsMYChvqgVjFrYhu4zX
         AHthOZvwQ3oJGidkMmdGyrQsM5/GWzunwIps10NLIOey6THZe34J83s+HnMo8RS40WhJ
         3p3A==
X-Gm-Message-State: AOAM533ilMjxyW9WvDsEjPCkRFf+sacej0VnD859shBRhydLQsQ8b/xI
        6scQ/lrhbPFjtBxgTyUqdvY=
X-Google-Smtp-Source: ABdhPJzOXL6/coAWf02etIo97MIRzLRQ6shkVnZ/UFzz/5u5dBKVAAXroIC+BP2noA7iy+7WqIlDDQ==
X-Received: by 2002:a5d:964a:: with SMTP id d10mr12770766ios.5.1605728188448;
        Wed, 18 Nov 2020 11:36:28 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:70e6:174c:7aed:1d19])
        by smtp.googlemail.com with ESMTPSA id c8sm12910992ioq.40.2020.11.18.11.36.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 11:36:27 -0800 (PST)
Subject: Re: [PATCH net-next 03/13] devlink: Support add and delete devlink
 port
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vu Pham <vuhuong@nvidia.com>
References: <20201112192424.2742-1-parav@nvidia.com>
 <20201112192424.2742-4-parav@nvidia.com>
 <e7b2b21f-b7d0-edd5-1af0-a52e2fc542ce@gmail.com>
 <BY5PR12MB43222AB94ED279AF9B710FF1DCE10@BY5PR12MB4322.namprd12.prod.outlook.com>
 <b34d8427-51c0-0bbd-471e-1af30375c702@gmail.com>
 <20201118183830.GA917484@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ac0c5a69-06e4-3809-c778-b27d6e437ed5@gmail.com>
Date:   Wed, 18 Nov 2020 12:36:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118183830.GA917484@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/20 11:38 AM, Jason Gunthorpe wrote:
> On Wed, Nov 18, 2020 at 11:03:24AM -0700, David Ahern wrote:
> 
>> With Connectx-4 Lx for example the netdev can have at most 63 queues
> 
> What netdev calls a queue is really a "can the device deliver
> interrupts and packets to a given per-CPU queue" and covers a whole
> spectrum of smaller limits like RSS scheme, # of available interrupts,
> ability of the device to create queues, etc.
> 
> CX4Lx can create a huge number of queues, but hits one of these limits
> that mean netdev's specific usage can't scale up. Other stuff like
> RDMA doesn't have the same limits, and has tonnes of queues.
> 
> What seems to be needed is a resource controller concept like cgroup
> has for processes. The system is really organized into a tree:
> 
>            physical device
>               mlx5_core
>         /      |      \      \                        (aux bus)
>      netdev   rdma    vdpa   SF  etc
>                              |                        (aux bus)
>                            mlx5_core
>                           /      \                    (aux bus)
>                        netdev   vdpa
> 
> And it does make a lot of sense to start to talk about limits at each
> tree level.
> 
> eg the top of the tree may have 128 physical interrupts. With 128 CPU
> cores that isn't enough interrupts to support all of those things
> concurrently.
> 
> So the user may want to configure:
>  - The first level netdev only gets 64,
>  - 3rd level mlx5_core gets 32 
>  - Final level vdpa gets 8
> 
> Other stuff has to fight it out with the remaining shared interrupts.
> 
> In netdev land # of interrupts governs # of queues
> 
> For RDMA # of interrupts limits the CPU affinities for queues
> 
> VPDA limits the # of VMs that can use VT-d
> 
> The same story repeats for other less general resources, mlx5 also
> has consumption of limited BAR space, and consumption of some limited
> memory elements. These numbers are much bigger and may not need
> explicit governing, but the general concept holds.
> 
> It would be very nice if the limit could be injected when the aux
> device is created but before the driver is bound. I'm not sure how to
> manage that though..
> 
> I assume other devices will be different, maybe some devices have a
> limit on the number of total queues, or a limit on the number of
> VDPA or RDMA devices.
> 
> Jason
> 

A lot of low level resource details that need to be summarized into a
nicer user / config perspective to specify limits / allocations.

Thanks for the detailed response.
