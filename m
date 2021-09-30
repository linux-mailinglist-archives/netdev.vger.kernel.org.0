Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9D041D42B
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 09:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348627AbhI3HM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 03:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348502AbhI3HMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 03:12:22 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFC3C06161C
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 00:10:40 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id v18so18088989edc.11
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 00:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2Sg7oCNyrpZLwCF3NR07WTr3z7EIRuSJjV8y5nKYQUY=;
        b=7CRfTqtCAVPMAMPSJpzV0sqiB8/jKnV9fPAxxQZKp/kpfAvQUEBoV+1kapFydoqKE3
         m3pNXsOSXYEbLgxjhBt58Xdr4yJ4A3kMYHGIXeebpmthR78M4dhwMGrSFStwmnRtdyNn
         PpUzMeXfoNUgpT9mlkX0qTTSqQ/g4v0ZhjjASkiQTJ3xxMYWeWgJYPJMKxxu+3XsWLtv
         4BlwedqsVlA3ORb65PxpJGshFBQea9eeZLBpLyVscuNA3lBUDCd0OgxkCOMSUMSLWCFB
         yGs/HLgxxy9Mv0pp8bVpLcugcbbDo0rluKaezfCQunfqWgVFYAmIsrNlwL/1SJ1Ns2bx
         G11A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2Sg7oCNyrpZLwCF3NR07WTr3z7EIRuSJjV8y5nKYQUY=;
        b=Pxlwe5YXfX2B1wJiVizc4DSlKDYqgki+PqNawmfyrgyr1Lyg1KSX1LrCQVn1pxiNSh
         LFxsktUXC8DhN/5qn7DWUNhuQ5qUn/hOd1+ex4M11aS9CqsEg/tprIrc/x3P2gHX1F26
         xcc3x2GBQy8cxIfd/I9QF5Nh+cYI5B+c8CtPGHCErMQr4UO6JF63tblatm17f0InBvr9
         O6YWfqZtcqPM91ZDtUEaNj33l4c4JjBmIHf19VgE4JsKpyfllnh20WuyDiRTKC6jBvpZ
         u+OSFVf5H6Ez4qnGRyVoY7KXNMdEFw2Sc0HxOIdV1Yyq3iRswCI49uNvnC+8MUnOPoYx
         r2Jw==
X-Gm-Message-State: AOAM532WXqArICsGFxdsUsguiulEXfU78Tjw8dmjvLw/cFExF0b6opTm
        ZjOZgyB9Xw4zkTtxpjwb/Hx8TQ==
X-Google-Smtp-Source: ABdhPJxsEu6O/CiRZdfytT6JaN6UIt6pBROFCkWTVt7rIspwhZgb0uX7spRY2fkBnkAIM7PiHn7tuQ==
X-Received: by 2002:a05:6402:2889:: with SMTP id eg9mr5522720edb.384.1632985838317;
        Thu, 30 Sep 2021 00:10:38 -0700 (PDT)
Received: from [192.168.0.111] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i10sm1063545edl.15.2021.09.30.00.10.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 00:10:37 -0700 (PDT)
Subject: Re: [RFC iproute2-next 05/11] ip: nexthop: always parse attributes
 for printing
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, idosch@idosch.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20210929152848.1710552-1-razor@blackwall.org>
 <20210929152848.1710552-6-razor@blackwall.org>
 <5bdcb047-4b25-1390-e04a-ada3e7bf1785@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
Message-ID: <ca16c842-94a3-c081-19f9-59c9349d0cf3@blackwall.org>
Date:   Thu, 30 Sep 2021 10:10:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <5bdcb047-4b25-1390-e04a-ada3e7bf1785@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/09/2021 06:37, David Ahern wrote:
> On 9/29/21 9:28 AM, Nikolay Aleksandrov wrote:
>> @@ -481,56 +457,61 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
>>  	if (filter.proto && filter.proto != nhm->nh_protocol)
>>  		return 0;
>>  
>> -	parse_rtattr_flags(tb, NHA_MAX, RTM_NHA(nhm), len, NLA_F_NESTED);
>> -
>> +	err = parse_nexthop_rta(fp, nhm, len, &nhe);
>> +	if (err) {
>> +		close_json_object();
>> +		fprintf(stderr, "Error parsing nexthop: %s\n", strerror(err));
>> +		return -1;
>> +	}
> 
> so you are doing that but in reverse order. Re-order the patches such
> that existing code is refactored with the parse functions first.
> 

I added the parse functions first without any functional changes and converted
the existing printing code to use them in this patch after that. I don't mind
doing the conversion after each parse function is added, too.

