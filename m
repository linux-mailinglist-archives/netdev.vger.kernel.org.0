Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF8526E6E4
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgIQUqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgIQUqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 16:46:48 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDF0C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:46:48 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d6so1970531pfn.9
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=xWhnebk2Zji4DVsO997HiI2ve8oCqaWo0riu24p6KMA=;
        b=LkBweATCXEXBEk6VY8Y4IqlWMdP5n7sKPC4fQyelM2YI2JGHQtxZC2Da47vlk2V0js
         aQZuvBaGWsDgVt2qHP8ECW+qJD7rjm6Uj9F9lO1wFVa6YxXtQvdJ183dq3nugR8ryAYB
         vbF7kLK9wNYhdmj2QPxlABLZJ+yjWXXG/Syg4m1xwdZ5MlG1+u8FNOoO2NbysfHZTPWX
         duLqi7QLeBNwHt6vZq30SNBp8W1Rprjf4go8X2Bk/lXa9rrwfo+PqWBPF9mesLm15/X1
         0DG0zdpRdqG9Kk6r9gP2do1hZtt3GbdevsUiLEyf8sEZfe0p97rPRMHWNqNevFy32/5f
         BL6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=xWhnebk2Zji4DVsO997HiI2ve8oCqaWo0riu24p6KMA=;
        b=cMWizDBk0hZ6uw0sRJHnMBxtZCWrp/lOVnXin9NWHDLa7Ad3PRg+C2Auh4zAi0mq/p
         tI/aIkdp4L05KnBC7eFyU7a7zhRj0cesa4hEMLT7aj1DRpgXxA1spwU7c67snIwFCHjP
         N+tOOMK9J5KmDyAu4J4PSdmcYiutuyvKr4sMv+zQFzNzCZemLeKztbUZV66J2EANQHlE
         rDW9oGrTc81dyC9PFnrYD8GU/kZU1O5Q1hXLjOGtyjHO2ZichIZqfemx2Aw0j4M8q+52
         Q5p1p8h5XZSMm27KNzlK5iS3+LhOnpN1cN0AoP95Zk14C1zQX4sOq/E1t2G/J19M6cjC
         eViA==
X-Gm-Message-State: AOAM53232t13rwMcAmcga2ldHcu6Go49PPl1kyEn9FTD0Aq+zzQhJAVG
        5aPgJpvF6tAeFG6RkPPG1aVr5p7DdhiToQ==
X-Google-Smtp-Source: ABdhPJzT6eyaAmQVmyNmXcXmfGrBDO0KGDqpM7SYWdWoP6Y1wdOFSzMTObx8DI4NW9QoO56WZxFmhg==
X-Received: by 2002:aa7:9f4e:0:b029:142:2501:39f1 with SMTP id h14-20020aa79f4e0000b0290142250139f1mr12829920pfr.64.1600375608293;
        Thu, 17 Sep 2020 13:46:48 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id j14sm523972pjz.21.2020.09.17.13.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 13:46:47 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 2/5] devlink: collect flash notify params into
 a struct
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200917030204.50098-1-snelson@pensando.io>
 <20200917030204.50098-3-snelson@pensando.io>
 <20200917124753.7bc1d2a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <1e78f7c7-e1c9-01c7-c4a6-6936a3499398@pensando.io>
Date:   Thu, 17 Sep 2020 13:46:46 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200917124753.7bc1d2a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/20 12:47 PM, Jakub Kicinski wrote:
> On Wed, 16 Sep 2020 20:02:01 -0700 Shannon Nelson wrote:
>> The dev flash status notify function parameter lists are getting
>> rather long, so add a struct to be filled and passed rather than
>> continuously changing the function signatures.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   include/net/devlink.h | 21 ++++++++++++
>>   net/core/devlink.c    | 80 +++++++++++++++++++++++--------------------
>>   2 files changed, 63 insertions(+), 38 deletions(-)
>>
>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>> index f206accf80ad..9ab2014885cb 100644
>> --- a/include/net/devlink.h
>> +++ b/include/net/devlink.h
>> @@ -391,6 +391,27 @@ struct devlink_param_gset_ctx {
>>   	enum devlink_param_cmode cmode;
>>   };
>>   
>> +/**
>> + * struct devlink_flash_notify - devlink dev flash notify data
>> + * @cmd: devlink notify command code
>> + * @status_msg: current status string
>> + * @component: firmware component being updated
>> + * @done: amount of work completed of total amount
>> + * @total: amount of work expected to be done
>> + * @timeout: expected max timeout in seconds
>> + *
>> + * These are values to be given to userland to be displayed in order
>> + * to show current activity in a firmware update process.
>> + */
>> +struct devlink_flash_notify {
>> +	enum devlink_command cmd;
> I'd leave out cmd out of the params structure, otherwise I'll be
> slightly awkward for drivers to fill in given the current helpers
> are per cmd.

Sure.  I wavered back and forth on that, no problem to change it.

sln

