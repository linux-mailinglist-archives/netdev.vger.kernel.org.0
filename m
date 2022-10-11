Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A615FB469
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 16:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiJKOSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 10:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiJKOSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 10:18:02 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DB994108
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 07:18:00 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id q9so27183570ejd.0
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 07:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9pYd0ajdV4UoEYzGRm2RyhM3NangO07YKa8YosWFJxc=;
        b=qOO14G1jWialOMk3rAO6mJnx71Xgh55AevrMUfCho/rBhgGB7hbLZZ53IyK+vfj/yu
         YPYuplsjDRobcHe7hzn6HB7lXAAJ7iBsbqZYtONCKkSJdOTtIS1s+C8IJSohGi/oXH2M
         NlDKuoEuQ8DekcTe0X3qQT6qYN8R5d2VIp8MLL2J2h4ChhanyzSj0yKSIlNM0nhvLRcG
         6WN6kPbSMHI59jYXmlK8Ioo5fdAlVgsRYC4a++2epAN9M7zJ+F+x9B1U6S3c5ipT2vZD
         6n1462VEgvUjwGvi9fMPk8KPnfBSbVA2TRg+ph/TLAZofn+Dl+HpGheycMFPlQOx3c+5
         Kyiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9pYd0ajdV4UoEYzGRm2RyhM3NangO07YKa8YosWFJxc=;
        b=NJ/5kOR2p1OnmU9a8KLLDsAJJkjO2hjjPCbEsye58FB1ywbt3HhD2xL086GV55cZz5
         wJserQ/lSsCkOMNM7rBY2TcDVYXTnJC4I0anh9hPlJt2m1c9cWOVjDroNkHPZtHWqK7q
         pYwCrkmKYID6hCu1Vx5qZqX1nfwEdovzGxI0VId7glUOVD7WLb+ecsGTCledJsKHpmxQ
         EWXRm02D/RQKuS6k1bd8YI4ZwfYmvMelsnM9DGkoTA9JzfA0KKYvi5TAbr67ETu1rbkv
         pkARnwdoOssmMmSob0stR+Ovr3eOHtKsZJJXeLrO6aoFWjuXK/3OxsAtp0/omPCTztNE
         0H7A==
X-Gm-Message-State: ACrzQf2KdXSB4rDlsNBZcCLkMb3WrPmk0KhPE0iZ36p+V138UUpJ+XpC
        EdSD7aA8qjVVf2bsucOw9opBdA==
X-Google-Smtp-Source: AMsMyM6WcBbE8YSQzTdFGQDgrcq/ZHwj6fwENxr8/ar7aKWcAfyyVr8WuJrymOhF0pue1JFuFn2bgA==
X-Received: by 2002:a17:906:1350:b0:77f:76a7:a0f with SMTP id x16-20020a170906135000b0077f76a70a0fmr18740289ejb.503.1665497878769;
        Tue, 11 Oct 2022 07:17:58 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id b18-20020a17090636d200b007417041fb2bsm6979662ejc.116.2022.10.11.07.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 07:17:57 -0700 (PDT)
Date:   Tue, 11 Oct 2022 16:17:55 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        alexandr.lobakin@intel.com, dchumak@nvidia.com, maximmi@nvidia.com,
        simon.horman@corigine.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api
 with queues and new parameters
Message-ID: <Y0V7E4UVPTH5tMSz@nanopsycho>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
 <20220915134239.1935604-3-michal.wilczynski@intel.com>
 <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
 <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
 <YzGSPMx2yZT/W6Gw@nanopsycho>
 <0a201dd1-55bb-925f-ee95-75bb9451bb8c@intel.com>
 <YzVFez0OXL98hyBt@nanopsycho>
 <3ff10647-f766-5164-a815-82010c738e12@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3ff10647-f766-5164-a815-82010c738e12@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Oct 11, 2022 at 03:28:38PM CEST, michal.wilczynski@intel.com wrote:
>
>
>On 9/29/2022 9:12 AM, Jiri Pirko wrote:
>> Wed, Sep 28, 2022 at 01:47:03PM CEST, michal.wilczynski@intel.com wrote:
>> > 
>> > On 9/26/2022 1:51 PM, Jiri Pirko wrote:
>> > > Thu, Sep 15, 2022 at 08:41:52PM CEST, michal.wilczynski@intel.com wrote:
>> > > > On 9/15/2022 5:31 PM, Edward Cree wrote:
>> > > > > On 15/09/2022 14:42, Michal Wilczynski wrote:
>> > > > > > Currently devlink-rate only have two types of objects: nodes and leafs.
>> > > > > > There is a need to extend this interface to account for a third type of
>> > > > > > scheduling elements - queues. In our use case customer is sending
>> > > > > > different types of traffic on each queue, which requires an ability to
>> > > > > > assign rate parameters to individual queues.
>> > > > > Is there a use-case for this queue scheduling in the absence of a netdevice?
>> > > > > If not, then I don't see how this belongs in devlink; the configuration
>> > > > >     should instead be done in two parts: devlink-rate to schedule between
>> > > > >     different netdevices (e.g. VFs) and tc qdiscs (or some other netdev-level
>> > > > >     API) to schedule different queues within each single netdevice.
>> > > > > Please explain why this existing separation does not support your use-case.
>> > > > > 
>> > > > > Also I would like to see some documentation as part of this patch.  It looks
>> > > > >     like there's no kernel document for devlink-rate unlike most other devlink
>> > > > >     objects; perhaps you could add one?
>> > > > > 
>> > > > > -ed
>> > > > Hi,
>> > > > Previously we discussed adding queues to devlink-rate in this thread:
>> > > > https://lore.kernel.org/netdev/20220704114513.2958937-1-michal.wilczynski@intel.com/T/#u
>> > > > In our use case we are trying to find a way to expose hardware Tx scheduler
>> > > > tree that is defined
>> > > > per port to user. Obviously if the tree is defined per physical port, all the
>> > > > scheduling nodes will reside
>> > > > on the same tree.
>> > > > 
>> > > > Our customer is trying to send different types of traffic that require
>> > > > different QoS levels on the same
>> > > Do I understand that correctly, that you are assigning traffic to queues
>> > > in VM, and you rate the queues on hypervisor? Is that the goal?
>> > Yes.
>> Why do you have this mismatch? If forces the hypervisor and VM admin to
>> somehow sync upon the configuration. That does not sound correct to me.
>
>Thanks for a feedback, this is going to be changed
>
>> 
>> 
>> > > 
>> > > > VM, but on a different queues. This requires completely different rate setups
>> > > > for that queue - in the
>> > > > implementation that you're mentioning we wouldn't be able to arbitrarily
>> > > > reassign the queue to any node.
>> > > > Those queues would still need to share a single parent - their netdev. This
>> > > So that replies to Edward's note about having the queues maintained
>> > > within the single netdev/vport, correct?
>> >   Correct ;)
>> Okay. So you don't really need any kind of sharing devlink might be able
>> to provide.
>> 
>>  From what you say and how I see this, it's clear. You should handle the
>> per-queue shaping on the VM, on netdevice level, most probably by
>> offloading some of the TC qdisc.
>
>I talked with architect, and this is how the solution will end up looking
>like,
>I'm not sure however whether creating a hardware-only qdisc is allowed ?

Nope.


>
>
>
>Btw, thanks everyone for valuable feedback, I've resend the patch
>without the queue support,
>https://lore.kernel.org/netdev/20221011090113.445485-1-michal.wilczynski@intel.com/
>
>
>BR,
>Michał
>> 
>> > > 
>> > > > wouldn't allow us to fully take
>> > > > advantage of the HQoS and would introduce arbitrary limitations.
>> > > > 
>> > > > Also I would think that since there is only one vendor implementing this
>> > > > particular devlink-rate API, there is
>> > > > some room for flexibility.
>> > > > 
>> > > > Regarding the documentation,  sure. I just wanted to get all the feedback
>> > > >from the mailing list and arrive at the final
>> > > > solution before writing the docs.
>> > > > 
>> > > > BTW, I'm going to be out of office tomorrow, so will respond in this thread
>> > > > on Monday.
>> > > > BR,
>> > > > Michał
>> > > > 
>> > > > 
>
