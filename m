Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8209E1D8F22
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 07:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgESFTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 01:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbgESFTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 01:19:13 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65860C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 22:19:13 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id z4so1653772wmi.2
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 22:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pcHDjg+HOYIROAS36NtMZdtFRJI62FcrI/rUmEqAQ0c=;
        b=O1d8dfNRLjftx1gBOUEyIbSyAEzvLDqj4VesUfWMMXHOzh4Ptka+HApF4dCXtttwD0
         fpW2trtQl9LnEXbxHm55t+cnloK4RE9dwu/CJ8J6xPxHoty94dUTv7fTbt5GuhJaWtHt
         opUubgoCPbsklpxqbpY0qqTjh2G8m+K5xSNCSp/6bpG8cwXQkp3IQEIKkyeLEMbhxYhJ
         9sEy/hfxGQoppjRtAmR8UtGweO7KMs+yxfkMyv3jQQfVl0goc02agDEKXw9HwGiKwy1c
         r9YZu+WnZxoSKh90Bnl5ewAoXdV36b5H/lRPFaZLjvrFDsO5x7v0WmyvU1erLdxKQVDm
         tYrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pcHDjg+HOYIROAS36NtMZdtFRJI62FcrI/rUmEqAQ0c=;
        b=KItillFvF8eyzTM3Pll0yrIanCa6Ib5EHDllOB8lvqFSmaNGPy9BHj3PNv8GWvc+Mi
         BYG+hvPQzIQYSsV69h3pInWUvksusmchjCxVU/CC8rq4WqWmnDRdgQzSgRlaB8Iy0eMV
         5ee6OfvudEctT22wnKbc/Gf2MeqD7w6mtQBuWrO88tjfmUKh54knbGp+5zdaMma0IcFV
         lbIAQ5V2sIj6ReBsPn+7sA2nDVXwXZ+soko+LW3/ac9U1QnTdnQBQAVp0FyZbMcfC/Ra
         LL37SjLV6TZ/OQ1qrnaseOwdR5BBMwsvNqy1ewCEMk1p0A+BwnH6RHDoLyg16AauO9w1
         EqvQ==
X-Gm-Message-State: AOAM531YOg1Mms/t7zpjN0jsdOhsd/9WDro+ScgkzC1JZKHYvWJRtSHJ
        GVdhBEiK0oA9Y5TEyryLzm+JcA==
X-Google-Smtp-Source: ABdhPJzapb+q5gpKv30YdXgeA69G1JGoh/UUjwRujRTJIWT2Ouv6X6rBs6ajZPZXp/s3Gc7yvtADeg==
X-Received: by 2002:a1c:2e41:: with SMTP id u62mr3313983wmu.91.1589865552115;
        Mon, 18 May 2020 22:19:12 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 94sm19508818wrf.74.2020.05.18.22.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 22:19:11 -0700 (PDT)
Date:   Tue, 19 May 2020 07:19:10 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        parav@mellanox.com, yuvalav@mellanox.com, jgg@ziepe.ca,
        saeedm@mellanox.com, leon@kernel.org,
        andrew.gospodarek@broadcom.com, michael.chan@broadcom.com,
        moshe@mellanox.com, ayal@mellanox.com, eranbe@mellanox.com,
        vladbu@mellanox.com, kliteyn@mellanox.com, dchickles@marvell.com,
        sburla@marvell.com, fmanlunas@marvell.com, tariqt@mellanox.com,
        oss-drivers@netronome.com, snelson@pensando.io,
        drivers@pensando.io, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, grygorii.strashko@ti.com,
        mlxsw@mellanox.com, idosch@mellanox.com, markz@mellanox.com,
        valex@mellanox.com, linyunsheng@huawei.com, lihong.yang@intel.com,
        vikas.gupta@broadcom.com, sridhar.samudrala@intel.com
Subject: Re: [RFC v2] current devlink extension plan for NICs
Message-ID: <20200519051910.GA4655@nanopsycho>
References: <20200501091449.GA25211@nanopsycho.orion>
 <b0f75e76-e6cb-a069-b863-d09f77bc67f6@intel.com>
 <20200515093016.GE2676@nanopsycho>
 <e3aa20ec-a47e-0b91-d6d5-1ad2020eca28@intel.com>
 <20200518065207.GA2193@nanopsycho>
 <17405a27-cd38-03c6-5ee3-0c9f8b643bfc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17405a27-cd38-03c6-5ee3-0c9f8b643bfc@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, May 18, 2020 at 11:05:45PM CEST, jacob.e.keller@intel.com wrote:
>
>
>On 5/17/2020 11:52 PM, Jiri Pirko wrote:
>> Fri, May 15, 2020 at 11:36:19PM CEST, jacob.e.keller@intel.com wrote:
>>>
>>>
>>> On 5/15/2020 2:30 AM, Jiri Pirko wrote:
>>>> Fri, May 15, 2020 at 01:52:54AM CEST, jacob.e.keller@intel.com wrote:
>>>>>> $ devlink port add pci/0000.06.00.0/100 flavour pcisf pfnum 1 sfnum 10
>>>>>>
>>>>>
>>>>> Can you clarify what sfnum means here? and why is it different from the
>>>>> index? I get that the index is a unique number that identifies the port
>>>>> regardless of type, so sfnum must be some sort of hardware internal
>>>>> identifier?
>>>>
>>>> Basically pfnum, sfnum and vfnum could overlap. Index is unique within
>>>> all groups together.
>>>>
>>>
>>> Right. Index is just an identifier for which port this is.
>>>
>
>Ok, so whether or not a driver uses this internally is an implementation
>detail that doesn't matter to the interface.
>
>
>>>>
>>>>>
>>>>> When looking at this with colleagues, there was a lot of confusion about
>>>>> the difference between the index and the sfnum.
>>>>
>>>> No confusion about index and pfnum/vfnum? They behave the same.
>>>> Index is just a port handle.
>>>>
>>>
>>> I'm less confused about the difference between index and these "nums",
>>> and more so questioning what pfnum/vfnum/sfnum represent? Are they
>>> similar to the vf ID that we have in the legacy SRIOV functions? I.e. a
>>> hardware index?
>>>
>>> I don't think in general users necessarily care which "index" they get
>>> upfront. They obviously very much care about the index once it's
>>> selected. I do believe the interfaces should start with the capability
>>> for the index to be selected automatically at creation (with the
>>> optional capability to select a specific index if desired, as shown here).
>>>
>>> I do not think most users want to care about what to pick for this
>>> number. (Just as they would not want to pick a number for the port index
>>> either).
>> 
>> I see your point. However I don't think it is always the right
>> scenario. The "nums" are used for naming of the netdevices, both the
>> eswitch port representor and the actual SF (in case of SF).
>> 
>> I think that in lot of usecases is more convenient for user to select
>> the "num" on the cmdline.
>> 
>
>Agreed, based on the below statements. Basically "let users specify or
>get it automatically chosen", just like with the port identifier and
>with the region numbers now.
>
>
>Thanks for the explanations!
>
>>>
>>>>> Obviously this is a TODO, but how does this differ from the current
>>>>> port_split and port_unsplit?
>>>>
>>>> Does not have anything to do with port splitting. This is about creating
>>>> a "child PF" from the section above.
>>>>
>>>
>>> Hmm. Ok so this is about internal connections in the switch, then?
>> 
>> Yes. Take the smartnic as an example. On the smartnic cpu, the
>> eswitch management is being done. There's devlink instance with all
>> eswitch port visible as devlink ports. One PF-type devlink port per
>> host. That are the "child PFs".
>> 
>> Now from perspective of the host, there are 2 scenarios:
>> 1) have the "simple dumb" PF, which just exposes 1 netdev for host to
>>    run traffic over. smartnic cpu manages the VFs/SFs and sees the
>>    devlink ports for them. This is 1 level switch - merged switch
>> 
>> 2) PF manages a sub-switch/nested-switch. The devlink/devlink ports are
>>    created on the host and the devlink ports for SFs/VFs are created
>>    there. This is multi-level eswitch. Each "child PF" on a parent
>>    manages a nested switch. And could in theory have other PF child with
>>    another nested switch.
>> 
>
>Ok. So in the smart NIC CPU, we'd see the primary PF and some child PFs,
>and in the host system we'd see a "primary PF" that is the other end of
>the associated Child PF, and might be able to manage its own subswitch.
>
>Ok this is making more sense now.
>
>I think I had imagined that was what subfuntions were. But really
>subfunctions are a bit different, they're more similar to expanded VFs?

Yeah, they are basically VFs without separate pci BDF. They reside on a
BDF of the PF they are created on. Basically a lightweight VFs.


>
>Thanks,
>Jake
