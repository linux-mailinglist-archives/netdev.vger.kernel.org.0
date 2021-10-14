Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D529042E15D
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 20:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbhJNSej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 14:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbhJNSej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 14:34:39 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E35C061755
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 11:32:34 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id y17so4497215ilb.9
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 11:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=odv4XstDMnH49PWgB4EnnlGdtcMHH/8B9Z0bVa3xDLY=;
        b=pwRfYyO2JDIBNpr1Tqk9S5m4K4wDVRZODpFPuHKARmtkEKUMUaV1xRKepLqUETezdC
         XSp6IWTPW0RxDZBwmPohUqqxvGqwcxWhi6mbgO+9aoFB0KVVBAVU5DpjNZl79qX7JG4u
         hh0nN2Mj9TxKxg2FWAhmefULg2reuachAYA60ZJbzcs3AEIg3Zr5YMeUHtnn53ndGJmm
         INte24aVHFB/uwkuxubJSJ4G4ObiI3XUXiKKLsBEf88eP5QB7gVHKqimYnyvQCLhKVHv
         1zK4Sy3vNMGFmxGze6s6Dg4Vdi/A0Z6sHGQyaAccN2btsTFuhzMVKO/qGmxF4Z2j/gd/
         71NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=odv4XstDMnH49PWgB4EnnlGdtcMHH/8B9Z0bVa3xDLY=;
        b=IQbJSjzL0ve//e7k2yGFcn3gixVmStMhe19RCU265JhWg9qH19GfHMr6yG2aJxrFSY
         W51GLGfbliSm6HMWU3lZ/9Mxk4apktWDaT4IkawmL2KBlTpKMJOfgPdlxSPbhD3n7Zgj
         wAeQthUSrF+hxjal7LLqTrEu9HpQiWAisdU2Gzp1KtDzDJg3oRjUftOJOrCq91nRCoDa
         aG72f4oU1jhIhdraQOmQ5Vk8VagCEl94BdNtVBGc3Q102WQ1XKaMbl875kTahkXa2aTe
         qi4Gn8A4d8LozTY9ywFnUVXN/bUWg7JI/xqYZ3F7MLR+ZLC062fSGscVaRGYIU2e83ap
         LaEQ==
X-Gm-Message-State: AOAM531rj7zFiqI33inXONBFhYJkUW8QSlZRZGHkFm0xDk+G8DXfrHhm
        qgWzOZe2/jgUFNdS29rW0DqrVkGskMBmqA==
X-Google-Smtp-Source: ABdhPJx53cGbARkx35ulTklQRL6vWlfSrdH1HtVtwEzeJ2oEQIZ9BcsNhokv6+30Q7ItSRa8ArRpCw==
X-Received: by 2002:a05:6e02:1a2d:: with SMTP id g13mr434545ile.123.1634236353578;
        Thu, 14 Oct 2021 11:32:33 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id ay5sm1727024iob.46.2021.10.14.11.32.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 11:32:32 -0700 (PDT)
Subject: Re: [PATCH 1/4] net: arp: introduce arp_evict_nocarrier sysctl
 parameter
To:     Jakub Kicinski <kuba@kernel.org>,
        James Prestwood <prestwoj@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20211013222710.4162634-1-prestwoj@gmail.com>
 <20211013163714.63abdd44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <10e8c5b435c3d19d062581b31e34de8e8511f75d.camel@gmail.com>
 <20211014095945.0767b4ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5e4a7d1e-9ca2-1e46-4bbc-e8f27b882db2@gmail.com>
Date:   Thu, 14 Oct 2021 12:32:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211014095945.0767b4ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/14/21 10:59 AM, Jakub Kicinski wrote:
> On Thu, 14 Oct 2021 09:29:05 -0700 James Prestwood wrote:
>>>> diff --git a/include/linux/inetdevice.h
>>>> b/include/linux/inetdevice.h
>>>> index 53aa0343bf69..63180170fdbd 100644
>>>> --- a/include/linux/inetdevice.h
>>>> +++ b/include/linux/inetdevice.h
>>>> @@ -133,6 +133,7 @@ static inline void ipv4_devconf_setall(struct
>>>> in_device *in_dev)
>>>>  #define IN_DEV_ARP_ANNOUNCE(in_dev)    IN_DEV_MAXCONF((in_dev),
>>>> ARP_ANNOUNCE)
>>>>  #define IN_DEV_ARP_IGNORE(in_dev)      IN_DEV_MAXCONF((in_dev),
>>>> ARP_IGNORE)
>>>>  #define IN_DEV_ARP_NOTIFY(in_dev)      IN_DEV_MAXCONF((in_dev),
>>>> ARP_NOTIFY)
>>>> +#define IN_DEV_ARP_EVICT_NOCARRIER(in_dev)
>>>> IN_DEV_CONF_GET((in_dev), ARP_EVICT_NOCARRIER)  
>>>
>>> IN_DEV_ANDCONF() makes most sense, I'd think.  
>>
>> So given we want '1' as the default as well as the ability to toggle
>> this option per-netdev I thought this was more appropriate. One caviat
>> is this would not work for setting ALL netdev's, but I don't think this
>> is a valid use case; or at least I can't imagine why you'd want to ever
>> do this.
>>
>> This is a whole new area to me though, so if I'm understanding these
>> macros wrong please educate me :)
> 
> Yeah, TBH I'm not sure what the best practice is here. I know we
> weren't very consistent in the past. Having a knob for "all" which 
> is 100% ignored seems like the worst option. Let me CC Dave Ahern,
> please make sure you CC him on v2 as well.
> 

agreed. It's a matter of consistency in the use of the 'all' variant. I
would say support it even if it you do not believe it will be changed.
