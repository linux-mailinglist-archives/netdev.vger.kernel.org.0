Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDA829C64C
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 19:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1826049AbgJ0SP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 14:15:29 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33474 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756350AbgJ0OMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 10:12:46 -0400
Received: by mail-io1-f68.google.com with SMTP id p15so1682158ioh.0
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 07:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Up+a2ZkZv99FDSZmt5Vx3GwQt8rHxXwHR/WA+ZeL2wo=;
        b=g1cRwowRl/hhfss7RQhcXorDuRXlZ8/jCd2lS+0RCewY4Ae5OFsQfhNx/gvbwVPS34
         FW3Hawy7pfMTTy2IXbnk443QgyGMIe5wM2sptHKpbRetCBptw0XdRXwt/Rj6/LaFzaaz
         KhDQRRD8Ty+h7aiGmnTvfmgRXav3UN//boqbiVLf09DeyID26rMK6+VQXuGFVFQXvhPI
         V6vStgxY3CHhz1XVerBN+ujjrbOjE/qIwdvL16EGk6rXCo3/zKmXrDBBtRkkCsxhwMWh
         20FUstjWvZn3h85BBw6oDeqsZJKkNZiZY5XJaP1pQ3UVjsLhhwLdXdRwZe1PK99kyt0S
         CQTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Up+a2ZkZv99FDSZmt5Vx3GwQt8rHxXwHR/WA+ZeL2wo=;
        b=n97A+oACWbfEPZagbL8n46pkOgZpDWPJEbwLa+tuVu62ZtBBOj06su0u1a3k4wyIlb
         m0TPCQ9pDxp7k40iRkhOerRTbxzPAbcV2DZfyOMk3v+nYPmDnrcY95OvMfS5wByvl/pe
         Hlx0RtbPlpgsYEKoaMPwvpIqnx0YutFIBgcxP2N84r7kynuz7kQZOkq5FC6sST978Djd
         m09FBbtCXwA1w0SjIVuhjBixA4f/ZCGIPb9fgA7ej8DnNWX/PGWBhAY8GJBYnTPmbMYy
         vezy61GMv0plLuRwJ3sIB8kI1eD7B8HUk1eq+9Kkqti0lMAaFlgwjqivaeXz0N81Swuc
         lABQ==
X-Gm-Message-State: AOAM531l0keO87oTrO6JJ2KFKxqWfxVcN6e4HbRUPkiBIga4Mk2ZO4yh
        iVcEe6vANnuzK7oQoJnUBkk=
X-Google-Smtp-Source: ABdhPJxDQrSJqWWVTCDWfPmgpxBuwgDzwGyl+140bad1mV5ZkS01wcXdZ2NNSyGlBTtGGbioG5bVqA==
X-Received: by 2002:a5d:9656:: with SMTP id d22mr2164112ios.50.1603807965378;
        Tue, 27 Oct 2020 07:12:45 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:f994:8208:36cb:5fef])
        by smtp.googlemail.com with ESMTPSA id z200sm973358iof.47.2020.10.27.07.12.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 07:12:44 -0700 (PDT)
Subject: Re: [iproute2-next] tc flower: use right ethertype in icmp/arp
 parsing
To:     Zahari Doychev <zahari.doychev@linux.com>,
        Simon Horman <simon.horman@netronome.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com
References: <20201019114708.1050421-1-zahari.doychev@linux.com>
 <bd0eb394-72a3-1c95-6736-cd47a1d69585@gmail.com>
 <20201026084824.GA29950@netronome.com>
 <20201027091116.6mteci6gs3urx4st@tycho>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d3992c0c-3cae-b81d-4caf-a4950ebc2d8b@gmail.com>
Date:   Tue, 27 Oct 2020 08:12:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201027091116.6mteci6gs3urx4st@tycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/20 3:11 AM, Zahari Doychev wrote:
> On Mon, Oct 26, 2020 at 09:48:24AM +0100, Simon Horman wrote:
>> On Sun, Oct 25, 2020 at 03:18:48PM -0600, David Ahern wrote:
>>> On 10/19/20 5:47 AM, Zahari Doychev wrote:
>>>> Currently the icmp and arp prsing functions are called with inccorect
>>>> ethtype in case of vlan or cvlan filter options. In this case either
>>>> cvlan_ethtype or vlan_ethtype has to be used.
>>>>
>>>> Signed-off-by: Zahari Doychev <zahari.doychev@linux.com>
>>>> ---
>>>>  tc/f_flower.c | 43 ++++++++++++++++++++++++++-----------------
>>>>  1 file changed, 26 insertions(+), 17 deletions(-)
>>>>
>>>> diff --git a/tc/f_flower.c b/tc/f_flower.c
>>>> index 00c919fd..dd9f3446 100644
>>>> --- a/tc/f_flower.c
>>>> +++ b/tc/f_flower.c
>>>> @@ -1712,7 +1712,10 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
>>>>  			}
>>>>  		} else if (matches(*argv, "type") == 0) {
>>>>  			NEXT_ARG();
>>>> -			ret = flower_parse_icmp(*argv, eth_type, ip_proto,
>>>> +			ret = flower_parse_icmp(*argv, cvlan_ethtype ?
>>>> +						cvlan_ethtype : vlan_ethtype ?
>>>> +						vlan_ethtype : eth_type,
>>>> +						ip_proto,
>>>
>>> looks correct to me, but would like confirmation of the intent from Simon.
>>
>> Thanks, this appears to be correct to me as ultimately
>> the code wants to operate on ETH_P_IP or ETH_P_IPV6 rather
>> than a VLAN Ether type.
>>
>>> Also, I am not a fan of the readability of that coding style. Rather
>>> than repeat that expression multiple times, make a short helper to
>>> return the relevant eth type and use a temp variable for it. You should
>>> also comment that relevant eth type changes as arguments are parsed.
> 
> I will add the helper and resend.
> 


perhaps it is simpler to have a new local variable that tracks the eth
type to be used in these locations.
