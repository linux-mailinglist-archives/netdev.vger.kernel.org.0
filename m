Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA015F5072
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 09:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiJEHtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 03:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiJEHtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 03:49:39 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A9E12B
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 00:49:34 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g27so4991268edf.11
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 00:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=VB1K2xZrEAa0KS/bxWhoWxuoqmtiVFFd81ldQtI5u2Q=;
        b=54K4moh0kljI67nDlrOW0OWxHRWrv6aT8onWn3HlZHhUBKPzU+dW31AOYZrSpIgdtd
         hNzfeAbYxRPZbUH234Qksqc0dKVDaiMFjXTral0qa8+4TmNqAK5tK+cyfz5Xsq7HvcEJ
         X5Q7UCw4TSnGc+L5UvBTMlr6yBzyXwfjozkllLNrKZDPNRDFFCPdyq56h8vgALdBrbde
         NfvnG235hmZcJeSBvMeSQx80HFDac82IMmpfN/pVbFYosVz2b4eYtu6uxRnQSE0iz9Hp
         B1oMQBthcWss5hYRVZZJDyZt3p0y/yt7uvatJBA46UHbs+g6WATJEbJOfWyp21A/ENyk
         Wk/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=VB1K2xZrEAa0KS/bxWhoWxuoqmtiVFFd81ldQtI5u2Q=;
        b=BGmVIzkk6RAEE10O+26ZpPm9rxQsSR/sRn2tI7uO1FmibJfGF931QGAeh6l4B73DlL
         S2NBsJ2QcR8PRVUccxAdIqeqC1uvk4UIdMwNt1S3KOz5ScV/Es/BYFwI6A6jQ29xby2E
         nfPmhbYFJUNS2mJZDfRFeMMKBOlbX3SzaYUVN+kgT8RoxpikSxG8ZnpYc+FaxY5WgFkh
         m9WCIqg9fN77jd5/fomNTwzBuJ5OvPiit4Nnt0T8hK5npkyeQf9wI+vu6vllNVJBInnk
         nFJyMV39NygY7gjxqx2F0f5SqbcoGtx9iSQeZ/WzUm+CkFfgRmL44G98Tlfzy7sEdjkq
         jckw==
X-Gm-Message-State: ACrzQf3KRDWrlsPgeghE4OVFmTi9lFfTBSUaVT+Vk7BIkclBHqmN7wJW
        e9sEJFJtUlf7DWdUqgzWzq7OpA==
X-Google-Smtp-Source: AMsMyM5jcmQRXJacaSJr/24Cym1qRCmUvP2XgnZHJI2N//jQUb+D/1Erc1pkJ9y7lEU+peiiuZAiwg==
X-Received: by 2002:a05:6402:450c:b0:443:6279:774f with SMTP id ez12-20020a056402450c00b004436279774fmr27757226edb.11.1664956172865;
        Wed, 05 Oct 2022 00:49:32 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id kz20-20020a17090777d400b00780982d77d1sm8219636ejc.154.2022.10.05.00.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 00:49:31 -0700 (PDT)
Date:   Wed, 5 Oct 2022 09:49:30 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "dmichail@fungible.com" <dmichail@fungible.com>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>
Subject: Re: [patch net-next 0/3] devlink: fix order of port and netdev
 register in drivers
Message-ID: <Yz03Cm/OBMae5IVT@nanopsycho>
References: <20220926110938.2800005-1-jiri@resnulli.us>
 <6dd32faa-2651-31bf-da2e-e768b9966e36@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6dd32faa-2651-31bf-da2e-e768b9966e36@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Oct 04, 2022 at 05:31:10PM CEST, alejandro.lucero-palau@amd.com wrote:
>Hi Jiri,

I don't understand why you send this as a reply to this patchset. I
don't see the relation to it.


>
>I think we have another issue with devlink_unregister and related 
>devlink_port_unregister. It is likely not an issue with current drivers 
>because the devlink ports are managed by netdev register/unregister 
>code, and with your patch that will be fine.
>
>But by definition, devlink does exist for those things not matching 
>smoothly to netdevs, so it is expected devlink ports not related to 
>existing netdevs at all. That is the case in a patch I'm working on for 
>sfc ef100, where devlink ports are created at PF initialization, so 
>related netdevs will not be there at that point, and they can not exist 
>when the devlink ports are removed when the driver is removed.
>
>So the question in this case is, should the devlink ports unregister 
>before or after their devlink unregisters?

Before. If devlink instance should be unregistered only after all other
related instances are gone.

Also, the devlink ports come and go during the devlink lifetime. When
you add a VF, split a port for example. There are many other cases.


>
>Since the ports are in a list owned by the devlink struct, I think it 
>seems logical to unregister the ports first, and that is what I did. It 
>works but there exists a potential concurrency issue with devlink user 

What concurrency issue are you talking about?


>space operations. The devlink code takes care of race conditions involving the 
>devlink struct with rcu plus get/put operations, but that is not the 
>case for devlink ports.
>
>Interestingly, unregistering the devlink first, and doing so with the 
>ports without touching/releasing the devlink struct would solve the 
>problem, but not sure this is the right approach here. It does not seem 

It is not. As I wrote above, the devlink ports come and go.


>clean, and it would require documenting the right unwinding order and 
>to add a check for DEVLINK_REGISTERED in devlink_port_unregister.
>
>I think the right solution would be to add protection to devlink ports 
>and likely other devlink objects with similar concurrency issues.
>
>
>Let me know what you think about it.
>
>
>
>On 9/26/22 13:09, Jiri Pirko wrote:
>> CAUTION: This message has originated from an External Source. Please use proper judgment and caution when opening attachments, clicking links, or responding to this email.
>>
>>
>> From: Jiri Pirko <jiri@nvidia.com>
>>
>> Some of the drivers use wrong order in registering devlink port and
>> netdev, registering netdev first. That was not intended as the devlink
>> port is some sort of parent for the netdev. Fix the ordering.
>>
>> Note that the follow-up patchset is going to make this ordering
>> mandatory.
>>
>> Jiri Pirko (3):
>>    funeth: unregister devlink port after netdevice unregister
>>    ice: reorder PF/representor devlink port register/unregister flows
>>    ionic: change order of devlink port register and netdev register
>>
>>   .../net/ethernet/fungible/funeth/funeth_main.c   |  2 +-
>>   drivers/net/ethernet/intel/ice/ice_lib.c         |  6 +++---
>>   drivers/net/ethernet/intel/ice/ice_main.c        | 12 ++++++------
>>   drivers/net/ethernet/intel/ice/ice_repr.c        |  2 +-
>>   .../net/ethernet/pensando/ionic/ionic_bus_pci.c  | 16 ++++++++--------
>>   5 files changed, 19 insertions(+), 19 deletions(-)
>>
>> --
>> 2.37.1
>>
>
