Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D9839E281
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhFGQRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbhFGQQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 12:16:10 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936BCC061766
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 09:14:05 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id h9so18603643oih.4
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 09:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QpPCoMIIEN/pLv0DBVofSnqALoENTFlCa3f78nmEXYU=;
        b=oAOsKfiCgSGstExE/d/Goj+Ys00P1oaX/ja8P6RFV5B2J6eFkE+rOqKQCNcBxlnW9D
         UtjfTMG1DFUkbJetKPRtsbeReCHqzCs8gmkmGmzJR79qwOg6jgZYVbc2tORKXnMZh2u/
         x9cXiC2L4j1b+WwoSQg07Dz0ZL7b2yk0y8Gg2AgY+Z+6JsFoH/roztAz7HjIhHECQfFd
         E9RborPP9vsInXNEu0Ri8CIMTGFyAsTotPyfYfbQ0qBvWOtTAwQG4sUyQ2MVuaDodN0X
         3w78tDLo3aaWFOVYsljFO6amjr56OGgzhdGbzWN4y6RWBZE8MYKL5W8OlO0F7G1rOOIV
         deFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QpPCoMIIEN/pLv0DBVofSnqALoENTFlCa3f78nmEXYU=;
        b=WhbM6aEJcxU14ePJYLWxrtF37l0+LvDG5KvZSRTixFgsT4TWVVgwGuwL2dZDlGmvF3
         9PDatLgcUdo/ezPIBVGjj7VXJmDfXUGiEAm7mYx7Uzwk+Fg4V8lnkjBCtAbrXUgZQvJu
         TcxGOOpaaqnnGX/JR9NYIV5LCR1ra6+pxC9OcgmHzcECKeM+M6xI6ByKzFjtJZrBPiI9
         UU1uaH3re84N6DAfGFzDE5DxqrN7Yj8W0eXv7m0EpTJ7Pi+xz2POwf6GwavZbbMEEmUz
         mnUvr0b14OYpSM6v3dPBez7quS4SeDQ5Gvgweg5AFekA9jkdySQwqlT1XalkF2t0Pix9
         6Zcg==
X-Gm-Message-State: AOAM533N/siWRfbRmfR9WXYZDuzAc8lb1DuYBH+dC8ltOZZ2+JZ7Mhnk
        EiDe9OW+VrOVe3HQOhKEEfbAtDWxUaE=
X-Google-Smtp-Source: ABdhPJxJp2B6TBYDgw1lBmqjRHmbzEJJrsfl3casq+ITXg8/M7LaO+VeabMxaOn4DRctbE6jPIGpZQ==
X-Received: by 2002:aca:d4cd:: with SMTP id l196mr26139oig.58.1623082442524;
        Mon, 07 Jun 2021 09:14:02 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id x9sm2336806oig.18.2021.06.07.09.14.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 09:14:01 -0700 (PDT)
Subject: Re: [PATCH RESEND iproute2-next] devlink: Add optional controller
 user input
To:     Parav Pandit <parav@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Jiri Pirko <jiri@nvidia.com>
References: <20210603111901.9888-1-parav@nvidia.com>
 <43ebc191-4b2d-4866-411b-81de63024942@gmail.com>
 <PH0PR12MB548101A3A5CEAD2CAAB04FB1DC389@PH0PR12MB5481.namprd12.prod.outlook.com>
 <d41a4e6c-0669-0b6c-5a2d-af1f3e5ae3bd@gmail.com>
 <PH0PR12MB54813150C3567170590BE36DDC389@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5a3a1292-a18d-8088-f835-44060aeb6a8a@gmail.com>
Date:   Mon, 7 Jun 2021 10:14:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <PH0PR12MB54813150C3567170590BE36DDC389@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/21 9:12 AM, Parav Pandit wrote:
> 
> 
>> From: David Ahern <dsahern@gmail.com>
>> Sent: Monday, June 7, 2021 8:11 PM
>>
>> On 6/7/21 5:43 AM, Parav Pandit wrote:
>>> Hi David,
>>>
>>>> From: David Ahern <dsahern@gmail.com>
>>>> Sent: Monday, June 7, 2021 8:31 AM
>>>>
>>>> On 6/3/21 5:19 AM, Parav Pandit wrote:
>>>>> @@ -3795,7 +3806,7 @@ static void cmd_port_help(void)
>>>>>  	pr_err("       devlink port param set DEV/PORT_INDEX name
>>>> PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
>>>>>  	pr_err("       devlink port param show [DEV/PORT_INDEX name
>>>> PARAMETER]\n");
>>>>>  	pr_err("       devlink port health show [ DEV/PORT_INDEX reporter
>>>> REPORTER_NAME ]\n");
>>>>> -	pr_err("       devlink port add DEV/PORT_INDEX flavour FLAVOUR
>>>> pfnum PFNUM [ sfnum SFNUM ]\n");
>>>>> +	pr_err("       devlink port add DEV/PORT_INDEX flavour FLAVOUR
>>>> pfnum PFNUM [ sfnum SFNUM ] [ controller CNUM ]\n");
>>>>>  	pr_err("       devlink port del DEV/PORT_INDEX\n");
>>>>>  }
>>>>>
>>>>> @@ -4324,7 +4335,7 @@ static int __cmd_health_show(struct dl *dl,
>>>>> bool show_device, bool show_port);
>>>>>
>>>>>  static void cmd_port_add_help(void)  {
>>>>> -	pr_err("       devlink port add { DEV | DEV/PORT_INDEX } flavour
>>>> FLAVOUR pfnum PFNUM [ sfnum SFNUM ]\n");
>>>>> +	pr_err("       devlink port add { DEV | DEV/PORT_INDEX } flavour
>>>> FLAVOUR pfnum PFNUM [ sfnum SFNUM ] [ controller CNUM ]\n");
>>>>
>>>> This line and the one above need to be wrapped. This addition puts it
>>>> well into the 90s.
>>>>
>>> It’s a print message.
>>> I was following coding style of [1] that says "However, never break user-
>> visible strings such as printk messages because that breaks the ability to grep
>> for them.".
>>> Recent code of dcb_ets.c has similar long string in print. So I didn't wrap it.
>>
>> I missed that when reviewing the dcb command then.
>>
>>> Should we warp it?
>>>
>>> [1]
>>> https://www.kernel.org/doc/html/latest/process/coding-style.html#break
>>> ing-long-lines-and-strings
>>>
>>
>> [1] is referring to messages from kernel code, and I agree with that style. This
>> is help message from iproute2. I tend to keep my terminal widths between
>> 80 and 90 columns, so the long help lines from commands are not very
>> friendly causing me to resize the terminal.
> I see. So do you recommend splitting the print message?
> I personally feel easier to follow kernel coding standard as much possible in spirit of "grep them". 😊
> But its really up to you. Please let me know.
> 


There are different type of strings:
1. help,
2. error messages,
3. informational messages,
4. displaying a configuration

1. is "how do I use this command". There is no reason to make that 1
gigantic line. All of the iproute2 commands wrap the help. My comment
above is on this category.

2. and 3. should not be wrapped to allow someone to attempt to go from
"why did I get this output" to a line of code (or many lines). This is
the kernel reference above.

4. Displaying attributes and settings for some object getting dumped.
The lines can get really long and unreadable to humans; these should be
split across multiple lines - like iproute2 commands do. There is no
reason for this to be on online unless the user asks for it via -oneline
option.
