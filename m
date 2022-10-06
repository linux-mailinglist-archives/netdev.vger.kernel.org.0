Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750B75F664C
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 14:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiJFMoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 08:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiJFMoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 08:44:07 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381A6A0325
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 05:44:04 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id s30so2660205eds.1
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 05:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=sa+p9iKC6MhFVF2h2O7DR6ehE+4Kno8h2ziXDf040+Y=;
        b=oGfdj0bEF1Z8aNQya4o0OVMQSNNxmYu8fVvz7L/1LV27OlZyWB59q5iDUQ4jDZ1MO+
         BL2e0AYeflCi+JP5xuZQXiaCTv8Fok0+PKsJTqVQPLQ1Sv1PeoUuQerWDo+H9EccHpM1
         g9b//znFN1TILwrOVMU2HeSgDLNx8QSTML5ZyTlqulTVmnc3rRJcyKam3WEY88UGTTjo
         umEdLCBIjLx57W9fk+cwcs621O0TwN5mnqhyIY6ZWAjA5/DKUxvroFF6t4llQGyJ8SV8
         gKNFVCHY0LtwODuu2R0ljdc1hENRCZBWtG47K6Kyu7plnGcyc/5jfIRFFAtQOrkB1miA
         kP+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=sa+p9iKC6MhFVF2h2O7DR6ehE+4Kno8h2ziXDf040+Y=;
        b=7ozKBFgrrUWLsYTpLjezfGevR4V3FV6NQTMNZNOh08fejXqO24SbHUi3J3+XCC4NQ/
         u1RQCyST2Bl4q/F2uqXUbnPR81arN0cEfox5J91eK3v18xgiyS+xnAQ8VVpzMtrVc7nH
         dnuQfwQJZ7+0O2UU6YzBSwue0L708FoUQwCe0iRUFmC4fs5fy5johVXa0b8LIb5gbyin
         arSPw1ywY0df9ucUxx3yksa0RghDW6vxqM50h+gid/fN1M+mgTN4Z391L3xLwxZdRUfe
         wlBsq55LaQVdaIdspX3x2JkzZWzWW9a3y1MjOx3i2FDtq4LvhAdd5hxDZvPbEh5lJI5o
         LXtQ==
X-Gm-Message-State: ACrzQf1eGaRBo6LXdbCuKcoMEmJb0GIgA5+O4RjjxH2vhJYabEJAuZSk
        2wXUTGsTB0EX8mPPNbVP3xlPNQ==
X-Google-Smtp-Source: AMsMyM7Ml3v6bK0FU7By73Rb/HBl3ca6nX39Qfcg4Xt+yrtXANzcrVJFlpYqZOBUag7IqyhhS07iOw==
X-Received: by 2002:a05:6402:2793:b0:452:5e81:c624 with SMTP id b19-20020a056402279300b004525e81c624mr4573904ede.36.1665060242403;
        Thu, 06 Oct 2022 05:44:02 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id bm15-20020a170906c04f00b0073c80d008d5sm10134564ejb.122.2022.10.06.05.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 05:44:01 -0700 (PDT)
Date:   Thu, 6 Oct 2022 14:44:00 +0200
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
Message-ID: <Yz7NkPIWItRy0hkC@nanopsycho>
References: <20220926110938.2800005-1-jiri@resnulli.us>
 <6dd32faa-2651-31bf-da2e-e768b9966e36@amd.com>
 <Yz03Cm/OBMae5IVT@nanopsycho>
 <c85fb638-77d1-dbbd-51aa-e39b05652e75@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c85fb638-77d1-dbbd-51aa-e39b05652e75@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 05, 2022 at 10:18:29AM CEST, alejandro.lucero-palau@amd.com wrote:
>
>On 10/5/22 09:49, Jiri Pirko wrote:
>> Tue, Oct 04, 2022 at 05:31:10PM CEST, alejandro.lucero-palau@amd.com wrote:
>>> Hi Jiri,
>> I don't understand why you send this as a reply to this patchset. I
>> don't see the relation to it.
>
>I thought there was a relationship with ordering being the issue.
>
>Apologies if this is not the right way for rising my concern.
>
>
>>
>>> I think we have another issue with devlink_unregister and related
>>> devlink_port_unregister. It is likely not an issue with current drivers
>>> because the devlink ports are managed by netdev register/unregister
>>> code, and with your patch that will be fine.
>>>
>>> But by definition, devlink does exist for those things not matching
>>> smoothly to netdevs, so it is expected devlink ports not related to
>>> existing netdevs at all. That is the case in a patch I'm working on for
>>> sfc ef100, where devlink ports are created at PF initialization, so
>>> related netdevs will not be there at that point, and they can not exist
>>> when the devlink ports are removed when the driver is removed.
>>>
>>> So the question in this case is, should the devlink ports unregister
>>> before or after their devlink unregisters?
>> Before. If devlink instance should be unregistered only after all other
>> related instances are gone.
>>
>> Also, the devlink ports come and go during the devlink lifetime. When
>> you add a VF, split a port for example. There are many other cases.
>>
>>
>>> Since the ports are in a list owned by the devlink struct, I think it
>>> seems logical to unregister the ports first, and that is what I did. It
>>> works but there exists a potential concurrency issue with devlink user
>> What concurrency issue are you talking about?
>>
>1) devlink port function set ...
>
>2) predoit inside devlink obtains devlink then the reference to devlink 
>port. Code does a put on devlink but not on the devlink port.

devl_lock is taken here.


>
>3) driver is removed. devlink port is removed. devlink is not because 

devl_lock taken before port is removed and will block there.

I don't see any problem. Did you actually encoutered any problem?


>the put.
>
>4) devlink port reference is wrong.
>
>
>>> space operations. The devlink code takes care of race conditions involving the
>>> devlink struct with rcu plus get/put operations, but that is not the
>>> case for devlink ports.
>>>
>>> Interestingly, unregistering the devlink first, and doing so with the
>>> ports without touching/releasing the devlink struct would solve the
>>> problem, but not sure this is the right approach here. It does not seem
>> It is not. As I wrote above, the devlink ports come and go.
>>
>>
>>> clean, and it would require documenting the right unwinding order and
>>> to add a check for DEVLINK_REGISTERED in devlink_port_unregister.
>>>
>>> I think the right solution would be to add protection to devlink ports
>>> and likely other devlink objects with similar concurrency issues.
>>>
>>>
>>> Let me know what you think about it.
>>>
>>>
>>>
>>> On 9/26/22 13:09, Jiri Pirko wrote:
>>>> CAUTION: This message has originated from an External Source. Please use proper judgment and caution when opening attachments, clicking links, or responding to this email.
>>>>
>>>>
>>>> From: Jiri Pirko <jiri@nvidia.com>
>>>>
>>>> Some of the drivers use wrong order in registering devlink port and
>>>> netdev, registering netdev first. That was not intended as the devlink
>>>> port is some sort of parent for the netdev. Fix the ordering.
>>>>
>>>> Note that the follow-up patchset is going to make this ordering
>>>> mandatory.
>>>>
>>>> Jiri Pirko (3):
>>>>     funeth: unregister devlink port after netdevice unregister
>>>>     ice: reorder PF/representor devlink port register/unregister flows
>>>>     ionic: change order of devlink port register and netdev register
>>>>
>>>>    .../net/ethernet/fungible/funeth/funeth_main.c   |  2 +-
>>>>    drivers/net/ethernet/intel/ice/ice_lib.c         |  6 +++---
>>>>    drivers/net/ethernet/intel/ice/ice_main.c        | 12 ++++++------
>>>>    drivers/net/ethernet/intel/ice/ice_repr.c        |  2 +-
>>>>    .../net/ethernet/pensando/ionic/ionic_bus_pci.c  | 16 ++++++++--------
>>>>    5 files changed, 19 insertions(+), 19 deletions(-)
>>>>
>>>> --
>>>> 2.37.1
>>>>
>
