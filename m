Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955B25EA85E
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 16:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbiIZO1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 10:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234703AbiIZO02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 10:26:28 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005A1356CF
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 05:39:02 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id d42so10708934lfv.0
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 05:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=z7dS3CIWBgL11uHlfCeHMPIMf4bhQCS7P8maB6njWFE=;
        b=NmA67P64ZW9GyTbfGEwEC8xRBXJVqErJp5K/GFqJ3GGPP0gc4AATfZR93/GaGe+hqG
         rYn0LfC3d87fMm/SWNPsL2fve5BCMLamkk3ABIxrmUL67rU+ljaY08es4I2uPCzz2rmb
         IHJYlN2C/x1/923UwdrdzKD0poSs0/AW5L16sjQsfN7f+nBPDZGm/v6h8SwESIZKjZlI
         OrlK8e6CduDL56QMnnI45zDCxd67AU7aWCj2uHLGtoH+cbHZmQR+bSQ4Gqjk1LAaG21F
         +QTs7+SWKNHgckrd5CQtJu4zx2HqUJWzeBEE+e5X5dGVr4CI4ETR2NXKR08cd6wVYPFZ
         8boA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=z7dS3CIWBgL11uHlfCeHMPIMf4bhQCS7P8maB6njWFE=;
        b=ilZWtwOXR98AD1h9fDf+qn4pSBflqHti4hAmtT57z7yQfZmUitnKw6Cb/YO2gB85Uq
         c/7bt54Tl297VYY1GttYuALXCgHq6RLwwk7Nbf9uambWNriY8uZvA8q00xhCTWcYpluQ
         9ae3154R/6GsCsYUiPg4srGZ2kFn0o2pO3lhKyCHfFUicnOEgSTZbGkcBB8LQ9PApaM1
         REmI6RUsPQCqFn2Ih4ND8KKkMRDSJGVtQz6FMpKW38IQBJUy11lSJx0zj3M5Jgv8Ojgi
         S5AvWefDx/fV08d/QrrFX1c2IJCkn82esGmtDlTHXhILepc5bFjMV/Hypfmlf8RHhhfk
         omGg==
X-Gm-Message-State: ACrzQf3XmtCC1J/TUZeFp9r1iElPe/VrjnyayFJXn/ASm7QCDtymRw/t
        FpHQLUy2l+bVfJutN8YN9kVDFdsqzpPq7KtLk9k=
X-Google-Smtp-Source: AMsMyM7woDeFZFHsQbEcFgLiaIEjzWVS98fIRrUozWqvfcTgzJrmYRgdQ1x/RfSRCJBvsw1W7UHL+Q==
X-Received: by 2002:a17:907:8a15:b0:782:e6da:f13d with SMTP id sc21-20020a1709078a1500b00782e6daf13dmr10127912ejc.152.1664193085963;
        Mon, 26 Sep 2022 04:51:25 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id a10-20020a50ff0a000000b00454546561cfsm11095057edu.82.2022.09.26.04.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 04:51:25 -0700 (PDT)
Date:   Mon, 26 Sep 2022 13:51:24 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        alexandr.lobakin@intel.com, dchumak@nvidia.com, maximmi@nvidia.com,
        simon.horman@corigine.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com
Subject: Re: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api
 with queues and new parameters
Message-ID: <YzGSPMx2yZT/W6Gw@nanopsycho>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
 <20220915134239.1935604-3-michal.wilczynski@intel.com>
 <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
 <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Sep 15, 2022 at 08:41:52PM CEST, michal.wilczynski@intel.com wrote:
>
>
>On 9/15/2022 5:31 PM, Edward Cree wrote:
>> On 15/09/2022 14:42, Michal Wilczynski wrote:
>> > Currently devlink-rate only have two types of objects: nodes and leafs.
>> > There is a need to extend this interface to account for a third type of
>> > scheduling elements - queues. In our use case customer is sending
>> > different types of traffic on each queue, which requires an ability to
>> > assign rate parameters to individual queues.
>> Is there a use-case for this queue scheduling in the absence of a netdevice?
>> If not, then I don't see how this belongs in devlink; the configuration
>>   should instead be done in two parts: devlink-rate to schedule between
>>   different netdevices (e.g. VFs) and tc qdiscs (or some other netdev-level
>>   API) to schedule different queues within each single netdevice.
>> Please explain why this existing separation does not support your use-case.
>> 
>> Also I would like to see some documentation as part of this patch.  It looks
>>   like there's no kernel document for devlink-rate unlike most other devlink
>>   objects; perhaps you could add one?
>> 
>> -ed
>
>Hi,
>Previously we discussed adding queues to devlink-rate in this thread:
>https://lore.kernel.org/netdev/20220704114513.2958937-1-michal.wilczynski@intel.com/T/#u
>In our use case we are trying to find a way to expose hardware Tx scheduler
>tree that is defined
>per port to user. Obviously if the tree is defined per physical port, all the
>scheduling nodes will reside
>on the same tree.
>
>Our customer is trying to send different types of traffic that require
>different QoS levels on the same

Do I understand that correctly, that you are assigning traffic to queues
in VM, and you rate the queues on hypervisor? Is that the goal?


>VM, but on a different queues. This requires completely different rate setups
>for that queue - in the
>implementation that you're mentioning we wouldn't be able to arbitrarily
>reassign the queue to any node.
>Those queues would still need to share a single parent - their netdev. This

So that replies to Edward's note about having the queues maintained
within the single netdev/vport, correct?


>wouldn't allow us to fully take
>advantage of the HQoS and would introduce arbitrary limitations.
>
>Also I would think that since there is only one vendor implementing this
>particular devlink-rate API, there is
>some room for flexibility.
>
>Regarding the documentation,  sure. I just wanted to get all the feedback
>from the mailing list and arrive at the final
>solution before writing the docs.
>
>BTW, I'm going to be out of office tomorrow, so will respond in this thread
>on Monday.
>BR,
>Michał
>
>
