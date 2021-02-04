Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC9330F51D
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 15:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236763AbhBDOfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 09:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236676AbhBDOeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 09:34:46 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E47C0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 06:34:04 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id e15so2458113qte.9
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 06:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=inhLUy8Ixei0FzDH6wnUpSWnJ1mURH6JQPNt9tTAugA=;
        b=VH+5D2LphtZtHICpcE9UDA40+ESP8UqFg9RUW1BzkacscehCwcmv+doWt6oJfzYEh/
         h/yxsaR3ruF0UjRZTBHpOI3jzWnFeRFtZw8/XpuL5+nXQt4tF1T+CZnXMR6hNFYQ2xQm
         l5WfBxWSIGTgK4ThBsGb6dmypdM4QG1R2LZ06qdfBJX+IH4PgsGQFlURy8JgKLI1G4tH
         DngDHC4FWl39xck2pnnnr08y46QkJ9/Xki59Sc9jGl4nmzQROrdaNYY/o47BWsX/Yih9
         HOhJId6aej6i9EdKZEJGX8MMWJrI+ehw7dVSx91AgTl9NWiIAeH/NfmTZoVVefsRxPL9
         8VFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=inhLUy8Ixei0FzDH6wnUpSWnJ1mURH6JQPNt9tTAugA=;
        b=elDriwTUHDLwi4GbUqr+S+83seCJjMnel4cIXPRQmXhg0EDlPaGX3wrty4DfjgrnNG
         fBYzr8Qu2w9IfIWjt+4cV/kuwqOLNpx5jV4m35SlhDCMKLI1CY3Mib62bvIgjmsGU4cc
         ot9LEnvcLeckvyZ7s86ES00yrZe5WL2MVeiEEZFmiyCQoCvy6S94F0Jo2fMhdlvO7FU3
         2On44Mibn85nLMT3O5qQHQLeaHsByjS0QPS2k9ll8TT7LCurvbnYqyA7/I7di7zafapu
         IMpLeJDdvPeQNptES6cterZa/vViLPg4KeFMcarFBEYVl5KG/nZWvGR1BgCIgNMTO7AR
         myHA==
X-Gm-Message-State: AOAM532QaNRNA/VMyQfI9hVpoWZc/JeBiIsbSpLOOSE3VtzfKsSDdpMz
        +1PlFxo9x1PjKMZWlQw3m4VatnBCnP8Cpw==
X-Google-Smtp-Source: ABdhPJxefH1fjsGeSbNNwADdsqaHtAPjbQCJGFKWeYZ3x4BiDOIMUqPMHmuoPQM9dzYLu952askN2g==
X-Received: by 2002:ac8:718a:: with SMTP id w10mr7497070qto.72.1612449243148;
        Thu, 04 Feb 2021 06:34:03 -0800 (PST)
Received: from [192.168.2.48] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id c81sm5187879qkb.88.2021.02.04.06.34.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 06:34:02 -0800 (PST)
Subject: Re: [iproute PATCH] tc: u32: Fix key folding in sample option
To:     Phil Sutter <phil@nwl.cc>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <20210202183051.21022-1-phil@nwl.cc>
 <6948a2a9-1ed2-ce8d-daeb-601c425e1258@mojatatu.com>
 <20210204140450.GS3158@orbyte.nwl.cc>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <0cab775c-cd3c-f3a0-7680-570cc92eb96e@mojatatu.com>
Date:   Thu, 4 Feb 2021 09:34:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210204140450.GS3158@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-04 9:04 a.m., Phil Sutter wrote:
> Jamal,
> 
> On Thu, Feb 04, 2021 at 08:19:55AM -0500, Jamal Hadi Salim wrote:
>> I couldnt tell by inspection if what used to work before continues to.
>> In particular the kernel version does consider the divisor when folding.
> 
> That's correct. And so does tc. What's the matter?
> 

tc assumes 256 when undefined. Maybe man page needs to be
updated to state we need divisor specified otherwise default
is 256.

>> Two examples that currently work, if you can try them:
> 
> Both lack information about the used hashkey and divisor.
> 
>> Most used scheme:
>> ---
>> tc filter add dev $DEV parent 999:0  protocol ip prio 10 u32 \
>> ht 2:: \
>> sample ip protocol 1 0xff match ip src 1.2.3.4/32 flowid 1:10 \
>> action ok
>> ----
> 
> htid before: 0x201000
> htid after: 0x201000
> 

Ok, this is the most common use-case. So we are good.

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>


cheers,
jamal
