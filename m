Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74A855CFAD
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239067AbiF0Sjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 14:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240496AbiF0SjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 14:39:17 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33FE2B97
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 11:38:54 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id r66so9900640pgr.2
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 11:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gDblWCAvDlKgLwLY9Q0P+YP2o0aDddFgja9o6tYpPSk=;
        b=L28XYRrsvfQtmHwGMk3tSBEwuAISIKkckpXWeJ5eqtklYbWpyQTv+jlwoG8EyPPZ63
         CR+PeCkl4K7Z75A091nw89JwoVU0T3NKflMSSDCrbeNIWx2a75c9ZjPll5DZDURq3J/C
         ivFRH0qUaJb0MguVcxhtb6lqUAQi+BTYEFppkeZ7Sb4Mja4ZlLeOIV8273OACI0WNN/i
         eC2BZu5RNzXR298CDFQQhoIJOVpa5GAHgbqefceCmB1ec0q3RbCrinBL2naQgEc1gjsF
         PlZwEX4ufIIxf2pT+OVolWGpVkk6AE7oU5P7lZKK/VEJsXGCoOk3/b2U9w5yZ2br8dJX
         w3Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gDblWCAvDlKgLwLY9Q0P+YP2o0aDddFgja9o6tYpPSk=;
        b=IQt/DWAU0S0aAIAwZ4ZeJ0FbLVaFQjCbOkDzYQiMtbIxZKRh/gE4u0ifRyYhQy1bwy
         uIH3VhD41M/lUEyvy/RQD6K+pICVLE9WSuWLWVF5ww1g82QTOV1OckefGvSRnhAy+1xx
         MSZNxGJ14aklYcZP/+/PHdfh6CQHi3TORQfe4eBNxPyXpOzMWmW4JNWegQmjoIsI/3GK
         keAUYIgEUKv+nNQTSSBs7a6c6+1wXCIY+C/LuAWPAcx9YKokE7Zo8ViEheF6ngvJ+Fqm
         QHP0iZCAbicmGuGXUIoYQy+pWQKDuj9Dg8OiBSCABeCWS31lA8JBC4BzEubz4EJlRmM8
         dQ1g==
X-Gm-Message-State: AJIora+FaOEEHsh+L0iZD2uyIsfKiFxj6Y6VbDcmFGk+r/7eDLFodYc2
        SHTMqTImNJNSsyLArDuwI1rIiw==
X-Google-Smtp-Source: AGRyM1tK/97sSEZUkW4e7KSJE9lJvjN05gLlBIxvlaLdQA8WdYllAsb/2sSXXOfoRuxqJkzkG1f0jA==
X-Received: by 2002:a63:9d41:0:b0:40c:67af:1fed with SMTP id i62-20020a639d41000000b0040c67af1fedmr13587414pgd.185.1656355133678;
        Mon, 27 Jun 2022 11:38:53 -0700 (PDT)
Received: from [192.168.0.3] ([50.53.169.105])
        by smtp.gmail.com with ESMTPSA id nk15-20020a17090b194f00b001ec9d45776bsm9925420pjb.42.2022.06.27.11.38.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 11:38:53 -0700 (PDT)
Message-ID: <ccd0e04c-5241-16da-929f-18059caee428@pensando.io>
Date:   Mon, 27 Jun 2022 11:38:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [patch net-next 00/11] mlxsw: Implement dev info and dev flash
 for line cards
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, mlxsw@nvidia.com
References: <20220614123326.69745-1-jiri@resnulli.us>
 <Yqmiv2+C1AXa6BY3@shredder> <YqoZkqwBPoX5lGrR@nanopsycho>
 <fbaca11c-c706-b993-fa0d-ec7a1ba34203@pensando.io>
 <Yrltpz0wXW35xmgd@nanopsycho>
From:   Shannon Nelson <snelson@pensando.io>
In-Reply-To: <Yrltpz0wXW35xmgd@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/27/22 1:43 AM, Jiri Pirko wrote:
> Sat, Jun 18, 2022 at 08:12:20AM CEST, snelson@pensando.io wrote:
>>
>>
>> On 6/15/22 10:40 AM, Jiri Pirko wrote:
>>> Wed, Jun 15, 2022 at 11:13:35AM CEST, idosch@nvidia.com wrote:
>>>> On Tue, Jun 14, 2022 at 02:33:15PM +0200, Jiri Pirko wrote:
>>>>> From: Jiri Pirko <jiri@nvidia.com>
>>>>>
>>>>> This patchset implements two features:
>>>>> 1) "devlink dev info" is exposed for line card (patches 3-8)
>>>>> 2) "devlink dev flash" is implemented for line card gearbox
>>>>>      flashing (patch 9)
>>>>>
>>>>> For every line card, "a nested" auxiliary device is created which
>>>>> allows to bind the features mentioned above (patch 2).
>>>>
>> [...]>>
>>>>>
>>>>> The relationship between line card and its auxiliary dev devlink
>>>>> is carried over extra line card netlink attribute (patches 1 and 3).
>>>>>
>>>>> Examples:
>>>>>
>>>>> $ devlink lc show pci/0000:01:00.0 lc 1
>>>>> pci/0000:01:00.0:
>>>>>     lc 1 state active type 16x100G nested_devlink auxiliary/mlxsw_core.lc.0
>>>>
>>>> Can we try to use the index of the line card as the identifier of the
>>>> auxiliary device?
>>>
>>> Not really. We would have a collision if there are 2 mlxsw instances.
>>>
>>
>> Can you encode the base device's PCI info into the auxiliary device's id
> 
> Would look odd to he PCI BDF in auxdev addsess, wouldn't it?

Sure, it looks a little odd to see something like mycore.app.1281, but 
it does afford the auxiliary driver, and any other observer, a way to 
figure out which device it is representing.  This also works nicely when 
trying to associate an auxiliary driver instance for a VF with the 
matching VF PCI driver instance.

sln

