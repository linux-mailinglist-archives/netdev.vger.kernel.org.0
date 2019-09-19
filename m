Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C69D9B7D33
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 16:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390236AbfISOtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 10:49:45 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:35516 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389041AbfISOtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 10:49:45 -0400
Received: by mail-pl1-f173.google.com with SMTP id y10so425686plp.2
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 07:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FnkxA6cT5rhpzcVuSxW3+7y7Cd49DuupKHsORawHxbc=;
        b=sRZz+5FWgLwCg1A6KMz/VBSBLUnIaQAU+DbQPajNrt3U3tFaa8t56diyxVklPb4SRJ
         oa1dUbTOMFK2YiScFHVJCR56VxYZDfzirDVwQB7wIUibzmZZ94w6DKCcrtfJ4jkt9kSf
         yOIP5yz3FD4z3X/ADwunSD0B0V0XnqKn61GjRRIW0n9M04FuPI92TaHBdTB2Q52/oljD
         dEtwgl+qs7E9+Ol9yiDSfCnuSmjt2pj0tdbSxr81H1T4O5PYdgYsa8YkPkI64w5wQU9B
         C9CZ02GjYO3BRQrJviKSxGncC+WPCZ6+2WdoZkqsjyYG8NuS02dqEBpQvLGpjv0P0Li8
         NjKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FnkxA6cT5rhpzcVuSxW3+7y7Cd49DuupKHsORawHxbc=;
        b=PWARdyzztz5hXBUcKAfkjmqFIyqJ0kQJzRl+3ga488oQAgwZjaKuN2fo1duBEhT938
         Yf6BdeA+VpbcqyyZuVGTlp4lAa4JnaNCTnso+70ATpmrYaD3ih+hRwsQ4n6QgbJRZ6gy
         6ZTpXnD+fEyRYH2WEXDCDEWx4yhIUH0QfMGH9oy3/6R3CvtDw1wXk9+nSfshkSm6fCSV
         Rr4Fws5DBTgLClHrwrm8EjiBaLE3SpbC4PIf5BWs9DthCVkmprCJBDrmcxxsVhYhrRLi
         QhMlJV1UUy3ybhmzJIPpVMAKfTDg61UYzkY2i08fMrRUl9I4Lcnnnm0/n9BhpnE3Cxj5
         B+1Q==
X-Gm-Message-State: APjAAAWEL7R81se3FHSDB/ztNOcQxMXl/C+BHV9GXVv/3szC9e7Eo6jX
        G9LAZEnD82GpT1WNosOP/PE=
X-Google-Smtp-Source: APXvYqxwyAfiRa48B3cPGSgbwZ7WadKHkB1nu4zyuZhQ4rAv+Yb+DXsOc1OhUN3OAumZhH0WKY2idg==
X-Received: by 2002:a17:902:690b:: with SMTP id j11mr10656345plk.35.1568904584584;
        Thu, 19 Sep 2019 07:49:44 -0700 (PDT)
Received: from [172.27.227.189] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id e184sm16942375pfa.87.2019.09.19.07.49.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 07:49:43 -0700 (PDT)
Subject: Re: [patch iproute2-next v2] devlink: add reload failed indication
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        tariqt@mellanox.com, mlxsw@mellanox.com
References: <20190916094448.26072-1-jiri@resnulli.us>
 <c9b57141-2caf-71c6-7590-a4783796e037@gmail.com>
 <20190917183629.GP2286@nanopsycho.orion>
 <12070e36-64e3-9a92-7dd5-0cbce87522db@gmail.com>
 <20190918073738.GA2543@nanopsycho>
 <13688c37-3f27-bdb4-973b-dd73031fa230@gmail.com>
 <20190918202350.GA2187@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5d0ae672-0fa5-a215-3159-564acdc40567@gmail.com>
Date:   Thu, 19 Sep 2019 08:49:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190918202350.GA2187@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/18/19 2:23 PM, Jiri Pirko wrote:
> Wed, Sep 18, 2019 at 10:01:31PM CEST, dsahern@gmail.com wrote:
>> On 9/18/19 1:37 AM, Jiri Pirko wrote:
>>> Wed, Sep 18, 2019 at 01:46:13AM CEST, dsahern@gmail.com wrote:
>>>> On 9/17/19 12:36 PM, Jiri Pirko wrote:
>>>>> Tue, Sep 17, 2019 at 06:46:31PM CEST, dsahern@gmail.com wrote:
>>>>>> On 9/16/19 3:44 AM, Jiri Pirko wrote:
>>>>>>> From: Jiri Pirko <jiri@mellanox.com>
>>>>>>>
>>>>>>> Add indication about previous failed devlink reload.
>>>>>>>
>>>>>>> Example outputs:
>>>>>>>
>>>>>>> $ devlink dev
>>>>>>> netdevsim/netdevsim10: reload_failed true
>>>>>>
>>>>>> odd output to user. Why not just "reload failed"?
>>>>>
>>>>> Well it is common to have "name value". The extra space would seem
>>>>> confusing for the reader..
>>>>> Also it is common to have "_" instead of space for the output in cases
>>>>> like this.
>>>>>
>>>>
>>>> I am not understanding your point.
>>>>
>>>> "reload failed" is still a name/value pair. It is short and to the point
>>>> as to what it indicates. There is no need for the name in the uapi (ie.,
>>>> the name of the netlink attribute) to be dumped here.
>>>
>>> Ah, got it. Well it is a bool value, that means it is "true" or "false".
>>> In json output, it is True of False. App processing json would have to
>>> handle this case in a special way.
>>>
>>
>> Technically it is a u8. But really I do not understand why it is
>> RELOAD_FAILED and not RELOAD_STATUS which is more generic and re-usable.
>> e.g,. 'none', 'failed', 'success'.
> 
> I was thinking about that. But I was not able to figure out any other
> possible values. So it is bool. For indication of some other status,
> there would have to be independent bool/othertype anyway.
> 

applied to iproute2-next, but I think this API is reactionary and not
very good from a user perspective.
