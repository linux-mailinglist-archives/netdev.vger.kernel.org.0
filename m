Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 161B013AFF5
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgANQtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:49:15 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38882 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbgANQtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 11:49:15 -0500
Received: by mail-qk1-f194.google.com with SMTP id k6so12730782qki.5
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 08:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GeTSHz91fcXtgbICDsZuWJas6zJnynbYdE0cwNsBcng=;
        b=t1u8MbhfGSbOxyQab3hacmNqz8xVfzaZoD5Apdw/KcLgnfJmGFpTLGooe004LAjP5i
         PfFG3haUyCyEtZnKccw3ZxpEPd1gx67oVp3LlWclSVSSecuL280j0iKCzU4kEZNm1WLa
         qe/y1Sk0f9r+MLTt0YWXAsKYApFZ2y46Np3CsCXkjZFhMuad0D8uitARY/MIAHCShti7
         czoT/APCsnSsJg9Xz5Tc6Q8X7F12MhuCVo5rbxWnRPztcu1yt3ysHejavyZLxWih7FiT
         ojt2YNRa9mgV6wMFkTIK1TI1VehYodeFhPAQJotjLhUo3g00EkYyvffHOXSVk0wo6o71
         ui3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GeTSHz91fcXtgbICDsZuWJas6zJnynbYdE0cwNsBcng=;
        b=BXbGqbV7V/muXxeoG7Kg4J1isMtfhVNIRAmE9ll8V8fp/dq2TXyykQyG6p3p9mSuWJ
         jA8tKyKhJR3Khy+5WFfBWnlJuI4/Ogl7JO2bwmViZjedCF96LhFbOJygr4heElZqGiNM
         YzQ3Uio+oiMqcS1S58RA+5H91Ou6xc9KTuF9/GrcFsTX6qtUb6Js45wx38SH0hl2dpwA
         DySqiQGJDgaJYRyO4LJPjsXcZ47bUT1g8PsIIGHh6eEI2d7GouT3Idb/A61mn2BjgMdg
         29CDH9yvpn7TJVlZForIwOkSLxv7pSmTv3LV55+I08VAdAMNbTFSuBX9z+QeGoo5NBrB
         jHgg==
X-Gm-Message-State: APjAAAXmvdU93jIzohDRLanOJD9ufV8IkaTMYL00V8V4ShE7MVp0SmQf
        Jl9bpV80S5Kehbo0pb9QyGA=
X-Google-Smtp-Source: APXvYqxqlVMixEfc4ZWCf1vVaJg+BOUSqibaCI7brjRH5MMoZovm9hTRKFgw+iPaIgPAM1bT2RDTFA==
X-Received: by 2002:a05:620a:1415:: with SMTP id d21mr22153009qkj.17.1579020554398;
        Tue, 14 Jan 2020 08:49:14 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:cda2:cdcb:a404:13ae? ([2601:282:800:7a:cda2:cdcb:a404:13ae])
        by smtp.googlemail.com with ESMTPSA id z6sm6770263qkz.101.2020.01.14.08.49.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2020 08:49:13 -0800 (PST)
Subject: Re: [PATCH net-next 3/8] net: bridge: vlan: add rtm definitions and
 dump support
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org
References: <20200113155233.20771-1-nikolay@cumulusnetworks.com>
 <20200113155233.20771-4-nikolay@cumulusnetworks.com>
 <20200114055544.77a7806f@cakuba.hsd1.ca.comcast.net>
 <076a7a9f-67c6-483a-7b86-f9d70be6ad47@gmail.com>
 <00c4bc6b-2b31-338e-a9ad-b4ea28fc731c@cumulusnetworks.com>
 <344f496a-5d34-4292-b663-97353f6cfa94@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d5291717-2ce5-97e0-6204-3ff0d27583c5@gmail.com>
Date:   Tue, 14 Jan 2020 09:49:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <344f496a-5d34-4292-b663-97353f6cfa94@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/20 9:45 AM, Nikolay Aleksandrov wrote:
> On 14/01/2020 18:36, Nikolay Aleksandrov wrote:
>> On 14/01/2020 17:34, David Ahern wrote:
>>> On 1/14/20 6:55 AM, Jakub Kicinski wrote:
>>>> On Mon, 13 Jan 2020 17:52:28 +0200, Nikolay Aleksandrov wrote:
>>>>> +static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
>>>>> +{
>>>>> +	int idx = 0, err = 0, s_idx = cb->args[0];
>>>>> +	struct net *net = sock_net(skb->sk);
>>>>> +	struct br_vlan_msg *bvm;
>>>>> +	struct net_device *dev;
>>>>> +
>>>>> +	if (cb->nlh->nlmsg_len < nlmsg_msg_size(sizeof(*bvm))) {
>>>>
>>>> I wonder if it'd be useful to make this a strict != check? At least
>>>> when strict validation is on? Perhaps we'll one day want to extend 
>>>> the request?
>>>>
>>>
>>> +1. All new code should be using the strict checks.
>>>
>>
>> IIRC, I did it to be able to add filter attributes later, but it should just use nlmsg_parse()
>> instead and all will be taken care of.
>> I'll respin v2 with that change.
>>
>> Thanks,
>>  Nik
>>
> 
> Actually nlmsg_parse() uses the same "<" check for the size before parsing. :)
> If I change to it and with no attributes to parse would be essentially equal to the
> current situation, but if I make it strict "!=" then we won't be able to add
> filter attributes later as we won't be backwards compatible. I'll continue looking
> into it, but IMO we should leave it as it is in order to be able to add the filtering later.
> 
> Thoughts ?
> 
> 
> 
> 

If the header is > sizeof(*bvm) I expect this part of
__nla_validate_parse() to kick in:

        if (unlikely(rem > 0)) {
                pr_warn_ratelimited("netlink: %d bytes leftover after
parsing attributes in process `%s'.\n",
                                    rem, current->comm);
                NL_SET_ERR_MSG(extack, "bytes leftover after parsing
attributes");
                if (validate & NL_VALIDATE_TRAILING)
                        return -EINVAL;
        }

