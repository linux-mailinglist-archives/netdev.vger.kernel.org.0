Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B527813B000
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgANQup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:50:45 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33635 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgANQuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 11:50:44 -0500
Received: by mail-lf1-f65.google.com with SMTP id n25so10390281lfl.0
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 08:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kXgipRMkTlu0Gbfl9KY1bZYr2HsM+sHNWhsLriinPy0=;
        b=P+SSveyNmfeHKKX8h7KBwiom6Wrbq5dXDBDWvB10zz8+l8971zyKx5sbprEdssCVxS
         ZKKVUnumhd567wWjorJhDR+V0iOdSFw8Pf2X0CZ/h4rbWyPIEv6t4zRyGl7vYcPwaPAl
         lzLaEA18x+E221l6dVomI3Cn3Pl0CYyB4+XnE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kXgipRMkTlu0Gbfl9KY1bZYr2HsM+sHNWhsLriinPy0=;
        b=FKBJ71t5zirVxlFEsCWrg1A2GeOvSk130L0/faBNHV0kUqhIx0s2P5H8bKiQtJ9PA2
         Afxc8QQ/n+9TpxfaFW8/PKancWVLZn5HqORNuZ+vlZsCvfIFtSgPycWsbHXuOADeysVo
         MCW1iWUhSQm6Ev1CwVPGIrbGPLKfhH/VQwzHobXTUXwZsO4KGdXaoJqo5nJ8fREo3612
         QlG+eGxvB/aTcSBf3mgqKjYoo+JLkGov40qcSmjXaggptq6jpQGxCHM2YdOG2YqqYXXr
         Ih8mxEVcpVZn+beALYVEvjxjEouNg8TaVTh95ZRxyI1mAR0nkIcSq2aOcZVzU/UL45an
         Y7Hw==
X-Gm-Message-State: APjAAAXlzRyKW6YAe98LMKN3Gjx6iibZi8UUDbKtra88/oKfvad+v11F
        JXnWGF0I27+K6/2IZlNXpjUBXQ==
X-Google-Smtp-Source: APXvYqzym6TP3Sdk+UOkkiIW5EujqmFv2FfQG4NAYd2t4UTBxpYfj1XWCqfUtVZAIUcL/e88Q0gFnw==
X-Received: by 2002:ac2:5310:: with SMTP id c16mr2379058lfh.102.1579020643038;
        Tue, 14 Jan 2020 08:50:43 -0800 (PST)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s4sm7946229ljd.94.2020.01.14.08.50.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2020 08:50:42 -0800 (PST)
Subject: Re: [PATCH net-next 3/8] net: bridge: vlan: add rtm definitions and
 dump support
To:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org
References: <20200113155233.20771-1-nikolay@cumulusnetworks.com>
 <20200113155233.20771-4-nikolay@cumulusnetworks.com>
 <20200114055544.77a7806f@cakuba.hsd1.ca.comcast.net>
 <076a7a9f-67c6-483a-7b86-f9d70be6ad47@gmail.com>
 <00c4bc6b-2b31-338e-a9ad-b4ea28fc731c@cumulusnetworks.com>
 <344f496a-5d34-4292-b663-97353f6cfa94@cumulusnetworks.com>
 <d5291717-2ce5-97e0-6204-3ff0d27583c5@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <aa9878d2-22d7-3bcd-deae-cf9bccd4226e@cumulusnetworks.com>
Date:   Tue, 14 Jan 2020 18:50:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <d5291717-2ce5-97e0-6204-3ff0d27583c5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/01/2020 18:49, David Ahern wrote:
> On 1/14/20 9:45 AM, Nikolay Aleksandrov wrote:
>> On 14/01/2020 18:36, Nikolay Aleksandrov wrote:
>>> On 14/01/2020 17:34, David Ahern wrote:
>>>> On 1/14/20 6:55 AM, Jakub Kicinski wrote:
>>>>> On Mon, 13 Jan 2020 17:52:28 +0200, Nikolay Aleksandrov wrote:
>>>>>> +static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
>>>>>> +{
>>>>>> +	int idx = 0, err = 0, s_idx = cb->args[0];
>>>>>> +	struct net *net = sock_net(skb->sk);
>>>>>> +	struct br_vlan_msg *bvm;
>>>>>> +	struct net_device *dev;
>>>>>> +
>>>>>> +	if (cb->nlh->nlmsg_len < nlmsg_msg_size(sizeof(*bvm))) {
>>>>>
>>>>> I wonder if it'd be useful to make this a strict != check? At least
>>>>> when strict validation is on? Perhaps we'll one day want to extend 
>>>>> the request?
>>>>>
>>>>
>>>> +1. All new code should be using the strict checks.
>>>>
>>>
>>> IIRC, I did it to be able to add filter attributes later, but it should just use nlmsg_parse()
>>> instead and all will be taken care of.
>>> I'll respin v2 with that change.
>>>
>>> Thanks,
>>>  Nik
>>>
>>
>> Actually nlmsg_parse() uses the same "<" check for the size before parsing. :)
>> If I change to it and with no attributes to parse would be essentially equal to the
>> current situation, but if I make it strict "!=" then we won't be able to add
>> filter attributes later as we won't be backwards compatible. I'll continue looking
>> into it, but IMO we should leave it as it is in order to be able to add the filtering later.
>>
>> Thoughts ?
>>
>>
>>
>>
> 
> If the header is > sizeof(*bvm) I expect this part of
> __nla_validate_parse() to kick in:
> 
>         if (unlikely(rem > 0)) {
>                 pr_warn_ratelimited("netlink: %d bytes leftover after
> parsing attributes in process `%s'.\n",
>                                     rem, current->comm);
>                 NL_SET_ERR_MSG(extack, "bytes leftover after parsing
> attributes");
>                 if (validate & NL_VALIDATE_TRAILING)
>                         return -EINVAL;
>         }
> 

Ah fair enough, so nlmsg_parse() would be better even without attrs.

