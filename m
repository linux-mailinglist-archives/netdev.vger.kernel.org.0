Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 377215F6B0D
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 17:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbiJFPxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 11:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbiJFPx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 11:53:28 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD8BA99C7
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 08:53:26 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z3so2470516edc.10
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 08:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UOqUP+mv6nUA4wXXm5fvF8ZtOdNCYt6lUYeN9A0Mqpc=;
        b=xU/yGRqfiOVOIiKyD6odc+RzlNuT1N9Zh9ZOdupc9f/dNfL3OSFRmLQhIecWj2VbZO
         pMQbRj7UPmlN4u7pkQxV66R2cgYz1tshuTa/DtyVxUBwAfLZ29pNGGqsaCUCwQqzcTel
         MT/O/3f6lBydt39N110pctaYRF/nooaRqpvrPUBlVdfWXS+Vb8rMjZGS5D6ja+Cw7jNl
         5LR1yXLkJ1LhZscvW35lU2qjeW3MGfc/2Lbsb/TOa6n/7zZ+0xB1HV5UgtD4nHW5K+/F
         +rM/iv2hhUt3Bi5qsagee7r69Pz8intdA5wRc/xpsAuB2Y4/NUeHnvMMfFf+UMhewZH3
         flYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UOqUP+mv6nUA4wXXm5fvF8ZtOdNCYt6lUYeN9A0Mqpc=;
        b=0VcCzKDdH1NnrwsoF4Rz22GopCptmBxsucD3t7fJeFl7RrP0PLtUXMu1+rGOz4yPwt
         J8rfzzjCVYzz2FNoAHkm1al39DpDEryTquiZOot8LwARL3UY2Dcbgk2vkvqdvAW2Rs0G
         HEqhXHgwyns2qnHKBcoEBmtEmlzTOetdbGZ6+ev8f0FPy6oI+WVTLsXMHSCEX6+2oV9F
         J4kFP3kfHMDw4doJgRzYSNOrEdope/1VRJSlKlzw+x8OvidPF+yR35AbfaTD1YMhGz3q
         UVNznRs0s83nZ4m8muYaKOR/OF94nnmDzj+KuTice/GTZkuHSTRi3VqFXwDH7jDtRrbO
         Incg==
X-Gm-Message-State: ACrzQf1k5Imdlipo9G5eKar5CroPFnKmiVK+6+aDkS4LGIrRLlG33oaZ
        rFZm7FxLcaOzYWNm7gIRU7VnAldUpYkYsVLiU2Q=
X-Google-Smtp-Source: AMsMyM5o+d/pywqq8jYJtr/Na73UYne9Z5AIM7WTluhbf36NmtyNiPllcX5P8vgWQLllDLNe2eduDw==
X-Received: by 2002:a05:6402:5192:b0:459:b6e8:b45c with SMTP id q18-20020a056402519200b00459b6e8b45cmr394935edd.233.1665071604991;
        Thu, 06 Oct 2022 08:53:24 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f4-20020a50fe04000000b00451319a43dasm6170302edt.2.2022.10.06.08.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 08:53:24 -0700 (PDT)
Date:   Thu, 6 Oct 2022 17:53:23 +0200
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
Message-ID: <Yz758wQfWAXADcpl@nanopsycho>
References: <20220926110938.2800005-1-jiri@resnulli.us>
 <6dd32faa-2651-31bf-da2e-e768b9966e36@amd.com>
 <Yz03Cm/OBMae5IVT@nanopsycho>
 <c85fb638-77d1-dbbd-51aa-e39b05652e75@amd.com>
 <Yz7NkPIWItRy0hkC@nanopsycho>
 <77e69cf1-ad8e-963e-97d0-effdd7c1453f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77e69cf1-ad8e-963e-97d0-effdd7c1453f@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Oct 06, 2022 at 03:45:48PM CEST, alejandro.lucero-palau@amd.com wrote:
>
>On 10/6/22 14:44, Jiri Pirko wrote:
>> Wed, Oct 05, 2022 at 10:18:29AM CEST, alejandro.lucero-palau@amd.com wrote:
>>> On 10/5/22 09:49, Jiri Pirko wrote:
>>>> Tue, Oct 04, 2022 at 05:31:10PM CEST, alejandro.lucero-palau@amd.com wrote:
>>>>> Hi Jiri,
>>>> I don't understand why you send this as a reply to this patchset. I
>>>> don't see the relation to it.
>>> I thought there was a relationship with ordering being the issue.
>>>
>>> Apologies if this is not the right way for rising my concern.
>>>
>>>
>>>>> I think we have another issue with devlink_unregister and related
>>>>> devlink_port_unregister. It is likely not an issue with current drivers
>>>>> because the devlink ports are managed by netdev register/unregister
>>>>> code, and with your patch that will be fine.
>>>>>
>>>>> But by definition, devlink does exist for those things not matching
>>>>> smoothly to netdevs, so it is expected devlink ports not related to
>>>>> existing netdevs at all. That is the case in a patch I'm working on for
>>>>> sfc ef100, where devlink ports are created at PF initialization, so
>>>>> related netdevs will not be there at that point, and they can not exist
>>>>> when the devlink ports are removed when the driver is removed.
>>>>>
>>>>> So the question in this case is, should the devlink ports unregister
>>>>> before or after their devlink unregisters?
>>>> Before. If devlink instance should be unregistered only after all other
>>>> related instances are gone.
>>>>
>>>> Also, the devlink ports come and go during the devlink lifetime. When
>>>> you add a VF, split a port for example. There are many other cases.
>>>>
>>>>
>>>>> Since the ports are in a list owned by the devlink struct, I think it
>>>>> seems logical to unregister the ports first, and that is what I did. It
>>>>> works but there exists a potential concurrency issue with devlink user
>>>> What concurrency issue are you talking about?
>>>>
>>> 1) devlink port function set ...
>>>
>>> 2) predoit inside devlink obtains devlink then the reference to devlink
>>> port. Code does a put on devlink but not on the devlink port.
>> devl_lock is taken here.
>
>This is embarrassing.
>
>Somehow I misread the code assuming the protection was only based on the 
>get operation, that the devlink lock was released there and not in the 
>post_doit.
>
>That goto unlock confused me, I guess, along with a bias looking for 
>ordering issues.
>
>Apologies.

Np :) Happy to help.

>
>Happy to see all is fine.
>
>Thank you.
>
>>
>>> 3) driver is removed. devlink port is removed. devlink is not because
>> devl_lock taken before port is removed and will block there.
>>
>> I don't see any problem. Did you actually encoutered any problem?
>>
>>
>>> the put.
>>>
>>> 4) devlink port reference is wrong.
>>>
>>>
>>>>> space operations. The devlink code takes care of race conditions involving the
>>>>> devlink struct with rcu plus get/put operations, but that is not the
>>>>> case for devlink ports.
>>>>>
>>>>> Interestingly, unregistering the devlink first, and doing so with the
>>>>> ports without touching/releasing the devlink struct would solve the
>>>>> problem, but not sure this is the right approach here. It does not seem
>>>> It is not. As I wrote above, the devlink ports come and go.
>>>>
>>>>
>>>>> clean, and it would require documenting the right unwinding order and
>>>>> to add a check for DEVLINK_REGISTERED in devlink_port_unregister.
>>>>>
>>>>> I think the right solution would be to add protection to devlink ports
>>>>> and likely other devlink objects with similar concurrency issues.
>>>>>
>>>>>
>>>>> Let me know what you think about it.
>>>>>
>>>>>
>>>>>
>>>>> On 9/26/22 13:09, Jiri Pirko wrote:
>>>>>> CAUTION: This message has originated from an External Source. Please use proper judgment and caution when opening attachments, clicking links, or responding to this email.
>>>>>>
>>>>>>
>>>>>> From: Jiri Pirko <jiri@nvidia.com>
>>>>>>
>>>>>> Some of the drivers use wrong order in registering devlink port and
>>>>>> netdev, registering netdev first. That was not intended as the devlink
>>>>>> port is some sort of parent for the netdev. Fix the ordering.
>>>>>>
>>>>>> Note that the follow-up patchset is going to make this ordering
>>>>>> mandatory.
>>>>>>
>>>>>> Jiri Pirko (3):
>>>>>>      funeth: unregister devlink port after netdevice unregister
>>>>>>      ice: reorder PF/representor devlink port register/unregister flows
>>>>>>      ionic: change order of devlink port register and netdev register
>>>>>>
>>>>>>     .../net/ethernet/fungible/funeth/funeth_main.c   |  2 +-
>>>>>>     drivers/net/ethernet/intel/ice/ice_lib.c         |  6 +++---
>>>>>>     drivers/net/ethernet/intel/ice/ice_main.c        | 12 ++++++------
>>>>>>     drivers/net/ethernet/intel/ice/ice_repr.c        |  2 +-
>>>>>>     .../net/ethernet/pensando/ionic/ionic_bus_pci.c  | 16 ++++++++--------
>>>>>>     5 files changed, 19 insertions(+), 19 deletions(-)
>>>>>>
>>>>>> --
>>>>>> 2.37.1
>>>>>>
>
