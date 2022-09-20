Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 172905BE420
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 13:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiITLJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 07:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiITLJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 07:09:07 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F676FA04
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 04:09:07 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id ay7-20020a05600c1e0700b003b49861bf48so835635wmb.0
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 04:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date;
        bh=11IUZm6qmIKooYOtJYLU0NuwmiSK3KsVQvIlnAYmJc4=;
        b=jvAlUXYxkwilHPb7ZD+bmibAh6dwsBBZ8IbHEqhZk9eyFgX3T4x/JY0SbOySInr2TI
         29T3kwz0PTXZ18f2Y+N6c4P5aFqGFvkAusEf+fEtkfUL/9jhxwYJFE2w2iXi3l/kXiWI
         9YV4qCloz8c5ODZvEENWDjJvXpHbcMpOnm/amFGspN47b8CfnkjG0+4jJi56XM5uvfET
         gaMPXgDvjlHG/zgq3IvMgIRSVa8FASE0WhJ/lDkPcTLmE3nsyuElqPYDugKUZrbQQSRb
         j5vr7fN7YWa8RvFnTVOlToXKFM/sOLS/Ikdsjza0V+G9rTpBczUaABbFRILI5nuKmqgJ
         naMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date;
        bh=11IUZm6qmIKooYOtJYLU0NuwmiSK3KsVQvIlnAYmJc4=;
        b=1F+fycqDL0BX1NXtyeyaF16F6+nujwyr4lKXeAEb035a4w83K0EhRppBBOIIECEAWH
         PbVK4yKoB+PAilpgrrITYlsEnuHZZmU82gIYD3y5Bv89UXVcZ+K5UJOm29pBKDm+o4dL
         9e6EXb67jkQpzrSMw1Sg9dgG8gwS28XchEMpnMRgFTw/hSX1IQWTxA4h4nHyNCSk780y
         SrwWIwWRrpMKDIQwtHTov5BcWS2QEH3iG3WMZRV5OBpK8hkvrsKRFm2ysNJMhR6fLvpK
         02Cy2wKo5DIlsBq/18h1kC6RqOO1Eoy4KpgYsKu51y7rgGQXp5m5psjppWouLQ8ln8rr
         noOQ==
X-Gm-Message-State: ACrzQf0/TUNlKo+Lpmgf8UGT8oigk4eAlzy3DYcjUvG/nhCT4sv5MVTh
        4nzBoWRAvO/XQoB1kU3zkO8=
X-Google-Smtp-Source: AMsMyM5WA2D1wH5XhXecatdKEVdp73v42IOFz+u0NSIzjr++EmRvL7NEIBURob/5HsynDIrNTUc1jA==
X-Received: by 2002:a05:600c:6015:b0:3b4:a4cb:72f7 with SMTP id az21-20020a05600c601500b003b4a4cb72f7mr1895569wmb.14.1663672145470;
        Tue, 20 Sep 2022 04:09:05 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id l26-20020a1c791a000000b003a3170a7af9sm1647423wme.4.2022.09.20.04.09.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 04:09:05 -0700 (PDT)
Subject: Re: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api with
 queues and new parameters
To:     "Wilczynski, Michal" <michal.wilczynski@intel.com>,
        netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, dchumak@nvidia.com, maximmi@nvidia.com,
        jiri@resnulli.us, simon.horman@corigine.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
 <20220915134239.1935604-3-michal.wilczynski@intel.com>
 <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
 <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
 <df4cd224-fc1b-dcd0-b7d4-22b80e6c1821@gmail.com>
 <7ce70b9f-23dc-03c9-f83a-4b620cdc8a7d@intel.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <24690f01-5a4b-840b-52b7-bdc0e6b9376a@gmail.com>
Date:   Tue, 20 Sep 2022 12:09:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <7ce70b9f-23dc-03c9-f83a-4b620cdc8a7d@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/09/2022 14:12, Wilczynski, Michal wrote:
> Maybe a switchdev case would be a good parallel here. When you enable switchdev, you get port representors on
> the host for each VF that is already attached to the VM. Something that gives the host power to configure
> netdev that it doesn't 'own'. So it seems to me like giving user more power to configure things from the host
> is acceptable.

Right that's the thing though: I instinctively Want this to be done
 through representors somehow, because it _looks_ like it ought to
 be scoped to a single netdev; but that forces the hierarchy to
 respect netdev boundaries which as we've discussed is an unwelcome
 limitation.

> In my mind this is a device-wide configuration, since the ice driver registers each port as a separate pci device.
> And each of this devices have their own hardware Tx Scheduler tree global to that port. Queues that we're
> discussing are actually hardware queues, and are identified by hardware assigned txq_id.

In general, hardware being a single unit at the device level does
 not necessarily mean its configuration should be device-wide.
For instance, in many NICs each port has a single hardware v-switch,
 but we do not have some kind of "devlink filter" API to program it
 directly.  Instead we attach TC rules to _many_ netdevs, and driver
 code transforms and combines these to program the unitary device.
"device-wide configuration" originally meant things like firmware
 version or operating mode (legacy vs. switchdev) that do not relate
 directly to netdevs.

But I agree with you that your approach is the "least evil method";
 if properly explained and documented then I don't have any
 remaining objection to your patch, despite that I'm continuing to
 take the opportunity to proselytise for "reprs >> devlink" ;)

-ed
