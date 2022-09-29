Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D855EEE8C
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbiI2HNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235033AbiI2HNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:13:08 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09161323EB
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:13:02 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z2so748694edi.1
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=LSRZBCTmT0hL5snj+rYRmgRi1ZmoMU67Lr450OsGSWo=;
        b=8DPTl93vctSpYxcEPLkbc/lAT0wdrye4YLGpPYsp8w6VrFhfP0z9PG4rjqXLyrFC/R
         YnHFLfvlBWHHyHCFri0g9T4znBo+kSdUHiobtYStUWe84hmHICUIjU6QEr86lmiGyAtB
         SsK35YeR1tSc0gWEax4OTZgSi0BMXpg702pJTcyWV1p/1Yapz5BZIzyRamh4aZTComn/
         4iWF/dpGOqj7U2oknBABM4j8dytv4lXkH659oHOaoY5L85eGM9QcurH7NfhRclGVylG6
         8Qcfvp9qxjYNVcrqCO6Po3hA8tSb4Mssq6yMOeXMc0SMa5uzd2NOWtTJq2ULhy8z0wCR
         xJeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=LSRZBCTmT0hL5snj+rYRmgRi1ZmoMU67Lr450OsGSWo=;
        b=yIj0Kca/eslrSOzFjsQUIvEtX3dNc8XYRPDfub9nGZBZQ70ryaTn54GIyz+0xAwvRC
         sEReD0ovGybgxsMHkYK/X8UHTDVbk5NCat4sXrSSn3J8I81duHWRzOs7+Wk1Lp7YueNQ
         6aWLcK6NTPTb7GEKSgLwqgyauUk4Jqfwjd7SCs2W5uDFWQgVY5nrkeoXcJwNEn0WjfXt
         TTRrqfXxC3btbtulGMICHCQ98c1LxaFDlK1yMKVklCWQc/EE1EgXKO4NFRPDlAHQ+wPB
         iit8Ulayr6Pvn7hRMlvXnRbWbP0WZ1USxeoNuA60LJ04Xox195GRhHtVgjFyzatjCLOg
         k6mg==
X-Gm-Message-State: ACrzQf29Wx/BIIprcZwoigwUhjFizagsNHxK22Ne/eXTr0+glKV/WuZZ
        pgC97mnX7b9DTsTRIaYtTnqmrA==
X-Google-Smtp-Source: AMsMyM7XPSrfwzHFox0czvQ4aCnORhQ6GUP0JQlNW9t2t7mnZmZJ9pwtE4YqC8LCsGmim1hWOm/vHw==
X-Received: by 2002:a05:6402:3215:b0:451:4ce5:d7b8 with SMTP id g21-20020a056402321500b004514ce5d7b8mr1835592eda.223.1664435581314;
        Thu, 29 Sep 2022 00:13:01 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id x2-20020a1709060ee200b0073dde62713asm3531818eji.89.2022.09.29.00.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 00:13:00 -0700 (PDT)
Date:   Thu, 29 Sep 2022 09:12:59 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        alexandr.lobakin@intel.com, dchumak@nvidia.com, maximmi@nvidia.com,
        simon.horman@corigine.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com
Subject: Re: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api
 with queues and new parameters
Message-ID: <YzVFez0OXL98hyBt@nanopsycho>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
 <20220915134239.1935604-3-michal.wilczynski@intel.com>
 <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
 <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
 <YzGSPMx2yZT/W6Gw@nanopsycho>
 <0a201dd1-55bb-925f-ee95-75bb9451bb8c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0a201dd1-55bb-925f-ee95-75bb9451bb8c@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Sep 28, 2022 at 01:47:03PM CEST, michal.wilczynski@intel.com wrote:
>
>
>On 9/26/2022 1:51 PM, Jiri Pirko wrote:
>> Thu, Sep 15, 2022 at 08:41:52PM CEST, michal.wilczynski@intel.com wrote:
>> > 
>> > On 9/15/2022 5:31 PM, Edward Cree wrote:
>> > > On 15/09/2022 14:42, Michal Wilczynski wrote:
>> > > > Currently devlink-rate only have two types of objects: nodes and leafs.
>> > > > There is a need to extend this interface to account for a third type of
>> > > > scheduling elements - queues. In our use case customer is sending
>> > > > different types of traffic on each queue, which requires an ability to
>> > > > assign rate parameters to individual queues.
>> > > Is there a use-case for this queue scheduling in the absence of a netdevice?
>> > > If not, then I don't see how this belongs in devlink; the configuration
>> > >    should instead be done in two parts: devlink-rate to schedule between
>> > >    different netdevices (e.g. VFs) and tc qdiscs (or some other netdev-level
>> > >    API) to schedule different queues within each single netdevice.
>> > > Please explain why this existing separation does not support your use-case.
>> > > 
>> > > Also I would like to see some documentation as part of this patch.  It looks
>> > >    like there's no kernel document for devlink-rate unlike most other devlink
>> > >    objects; perhaps you could add one?
>> > > 
>> > > -ed
>> > Hi,
>> > Previously we discussed adding queues to devlink-rate in this thread:
>> > https://lore.kernel.org/netdev/20220704114513.2958937-1-michal.wilczynski@intel.com/T/#u
>> > In our use case we are trying to find a way to expose hardware Tx scheduler
>> > tree that is defined
>> > per port to user. Obviously if the tree is defined per physical port, all the
>> > scheduling nodes will reside
>> > on the same tree.
>> > 
>> > Our customer is trying to send different types of traffic that require
>> > different QoS levels on the same
>> Do I understand that correctly, that you are assigning traffic to queues
>> in VM, and you rate the queues on hypervisor? Is that the goal?
>
>Yes.

Why do you have this mismatch? If forces the hypervisor and VM admin to
somehow sync upon the configuration. That does not sound correct to me.


>
>> 
>> 
>> > VM, but on a different queues. This requires completely different rate setups
>> > for that queue - in the
>> > implementation that you're mentioning we wouldn't be able to arbitrarily
>> > reassign the queue to any node.
>> > Those queues would still need to share a single parent - their netdev. This
>> So that replies to Edward's note about having the queues maintained
>> within the single netdev/vport, correct?
>
> Correct ;)

Okay. So you don't really need any kind of sharing devlink might be able
to provide.

From what you say and how I see this, it's clear. You should handle the
per-queue shaping on the VM, on netdevice level, most probably by
offloading some of the TC qdisc.


>
>> 
>> 
>> > wouldn't allow us to fully take
>> > advantage of the HQoS and would introduce arbitrary limitations.
>> > 
>> > Also I would think that since there is only one vendor implementing this
>> > particular devlink-rate API, there is
>> > some room for flexibility.
>> > 
>> > Regarding the documentation,  sure. I just wanted to get all the feedback
>> >from the mailing list and arrive at the final
>> > solution before writing the docs.
>> > 
>> > BTW, I'm going to be out of office tomorrow, so will respond in this thread
>> > on Monday.
>> > BR,
>> > Michał
>> > 
>> > 
>
