Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D4961D915
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 10:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiKEJ0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 05:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKEJ0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 05:26:38 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552552D1D0
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 02:26:36 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id x2so10758587edd.2
        for <netdev@vger.kernel.org>; Sat, 05 Nov 2022 02:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RitYSYEqtOBOy6lgyvQrikThdwZoAMafvlSwu7zwMCw=;
        b=kW4st08NDNHd2fgbhYn7UbY3srTcAgSdrQvIPmzfZLfmRzMsaVWNuvYYaEfLddmrsC
         sihNS8GQe7Q8PO8CSVYxhxLQCVr/4uY9oQR4ghPOCn+Q1EO8schLF27KIATYzcA+fOT2
         WQIp/451KyQJFpQqpe3WOLKfJawD11gtybJXG0nPLApYT303Ie7Fk0iQgh4K3qY1aaDL
         BfHNzK0oIJfVzXEz8GCf+bgVU6SkrTbdkxnd9gY0wc+2jjq42qR6n+M38q6Szl9AHdgW
         a76Zx/4jHE7UTA4sGHpQkn/NyC3tV5l+YWhOPxd3Cm3nVLnMAckqW2KozIzqOUWWRff6
         htPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RitYSYEqtOBOy6lgyvQrikThdwZoAMafvlSwu7zwMCw=;
        b=60FY/ji82jvw8dDi2M8Z3fMgieJEBmfAqvJ67H+v/2Lu9K/9YmXXSIaapBuHQJdFZb
         p+2dl2wEGNTgjmpw1zmuk6t6cMs3z1Q/rPNr5v8lfkWFWpMMcC1TlAn1/yA4OY+viX7g
         DT9WDigWbVg9YG1ZczVfgK6VV8ovQuQyVkpTzxEk8xKIEA3jKBOd3Ox3HooBXWrxq/nJ
         7FlhLBWHIZb8G47rEnqsXii8esKADDx0UyTjl9n+BRnI1J3lUYYtw3FnNXKNXXajIi6j
         teo4EoZicnodfJBsBN0RENr0DTiUbIurmTJ8EWVUNdn8BpzJ4wn/upv6Fz2WkEV5sW4x
         soxQ==
X-Gm-Message-State: ACrzQf3e+exYWyX0tVMzI/p06XuzNuT1UH9E5SuzQgIhRMWHLK6hF10l
        HqbX2rvWotjfdOGJIi1d78MEDg==
X-Google-Smtp-Source: AMsMyM46zn4T0seWJ3c9PYP1nSGVMtPx9SViNF8wXVzKL6+IpRiSZqZIv4g2ENI5CQs0xSL/suBAMw==
X-Received: by 2002:a05:6402:c95:b0:463:6034:3dd9 with SMTP id cm21-20020a0564020c9500b0046360343dd9mr31196471edb.115.1667640394917;
        Sat, 05 Nov 2022 02:26:34 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o19-20020a170906769300b00722e50dab2csm674348ejm.109.2022.11.05.02.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 02:26:34 -0700 (PDT)
Date:   Sat, 5 Nov 2022 10:26:33 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com
Subject: Re: [patch net-next] net: devlink: expose the info about version
 representing a component
Message-ID: <Y2YsSfcGgrxuuivW@nanopsycho>
References: <20221104152425.783701-1-jiri@resnulli.us>
 <20221104192510.32193898@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104192510.32193898@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Nov 05, 2022 at 03:25:10AM CET, kuba@kernel.org wrote:
>On Fri,  4 Nov 2022 16:24:25 +0100 Jiri Pirko wrote:
>> If certain version exposed by a driver is marked to be representing a
>> component, expose this info to the user.
>> 
>> Example:
>> $ devlink dev info
>> netdevsim/netdevsim10:
>>   driver netdevsim
>>   versions:
>>       running:
>>         fw.mgmt 10.20.30
>>       flash_components:
>>         fw.mgmt
>
>Didn't I complain that this makes no practical sense because
>user needs to know what file to flash, to which component?
>Or was that a different flag that I was complaining about?

Different. That was about exposing a default component.


>
>> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>> index 2f24b53a87a5..7f2874189188 100644
>> --- a/include/uapi/linux/devlink.h
>> +++ b/include/uapi/linux/devlink.h
>> @@ -607,6 +607,8 @@ enum devlink_attr {
>>  
>>  	DEVLINK_ATTR_SELFTESTS,			/* nested */
>>  
>> +	DEVLINK_ATTR_INFO_VERSION_IS_COMPONENT,	/* u8 0 or 1 */
>
>In the interest of fairness I should complain about the use of u8/u16
>
>devlink is genetlink so user will know kernel supports the attribute 
>(by looking at family->maxattr). So this can be a flag.

Okay, makes sense.
