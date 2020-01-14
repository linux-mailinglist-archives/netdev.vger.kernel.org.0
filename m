Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E38813AFB9
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgANQpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:45:52 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40285 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbgANQpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 11:45:51 -0500
Received: by mail-lj1-f195.google.com with SMTP id u1so15122817ljk.7
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 08:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/sWh7+7+OUKVxtsGUyUPmwfLLEU4raHR2CwW0UB18ac=;
        b=Gbex73vtG5zmTfTRwDfT/HlTOZaMGn8olVK2tLOcd/WFZy7S4oqH1K/OqXs88O46vI
         rZq7gtkDgk2sG+ALAPG36F2eQbj3rZE38UilWkitKvTG4bPsTsNvPNYNiz0rqq3WJuB1
         jwlWMQ3hI04+bS0PcOLMO75D0++0XOolFrgW8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/sWh7+7+OUKVxtsGUyUPmwfLLEU4raHR2CwW0UB18ac=;
        b=om6BobpBaAYL2jRcYWzXiUXFul2hY3q7qabb1hleaE4Z1ooNz/oPPANBzaHorDw5Co
         zJdY/4ERrledNmXaS0jiV/kvvjz1BHc6jPiEzEWNNj9jS6CLZEAv+VYbzOj3/DNv/Bft
         +vOF/WCprOR+tC9YO85r2MuDcYsmMgCHLmPfxPJ62cgcxP1p79MZQqO156t7A5XFWcjh
         jPTj2R3aSuAxk0//zqLDdsXBqFAw1IIoaQmNOKvot0AV4kjFKXpDlXvqnDSSrZ8ZTxhe
         6c5IrqqiP/yIcXFiYKES9+VRWR0Vcm4YM70e7OqY+zqAVykE93369qomXk3WTn9xVz88
         l7LA==
X-Gm-Message-State: APjAAAUsCI9cKGGt+MSkEuM8S0RFdMDbdlNQtHa393FNrR1exsLCA6Dn
        S+NdXty4E5KxlJD3damyzQMV6A==
X-Google-Smtp-Source: APXvYqwmxQmNg8BxjVeQGlMzs/GV5zbrIV4IUHt7pI3dH0CY1M9RsXjSPcRkwwfrdk/Y+qdd227foQ==
X-Received: by 2002:a05:651c:214:: with SMTP id y20mr14603586ljn.139.1579020349035;
        Tue, 14 Jan 2020 08:45:49 -0800 (PST)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id g15sm7737882ljn.32.2020.01.14.08.45.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2020 08:45:48 -0800 (PST)
Subject: Re: [PATCH net-next 3/8] net: bridge: vlan: add rtm definitions and
 dump support
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org
References: <20200113155233.20771-1-nikolay@cumulusnetworks.com>
 <20200113155233.20771-4-nikolay@cumulusnetworks.com>
 <20200114055544.77a7806f@cakuba.hsd1.ca.comcast.net>
 <076a7a9f-67c6-483a-7b86-f9d70be6ad47@gmail.com>
 <00c4bc6b-2b31-338e-a9ad-b4ea28fc731c@cumulusnetworks.com>
Message-ID: <344f496a-5d34-4292-b663-97353f6cfa94@cumulusnetworks.com>
Date:   Tue, 14 Jan 2020 18:45:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <00c4bc6b-2b31-338e-a9ad-b4ea28fc731c@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/01/2020 18:36, Nikolay Aleksandrov wrote:
> On 14/01/2020 17:34, David Ahern wrote:
>> On 1/14/20 6:55 AM, Jakub Kicinski wrote:
>>> On Mon, 13 Jan 2020 17:52:28 +0200, Nikolay Aleksandrov wrote:
>>>> +static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
>>>> +{
>>>> +	int idx = 0, err = 0, s_idx = cb->args[0];
>>>> +	struct net *net = sock_net(skb->sk);
>>>> +	struct br_vlan_msg *bvm;
>>>> +	struct net_device *dev;
>>>> +
>>>> +	if (cb->nlh->nlmsg_len < nlmsg_msg_size(sizeof(*bvm))) {
>>>
>>> I wonder if it'd be useful to make this a strict != check? At least
>>> when strict validation is on? Perhaps we'll one day want to extend 
>>> the request?
>>>
>>
>> +1. All new code should be using the strict checks.
>>
> 
> IIRC, I did it to be able to add filter attributes later, but it should just use nlmsg_parse()
> instead and all will be taken care of.
> I'll respin v2 with that change.
> 
> Thanks,
>  Nik
> 

Actually nlmsg_parse() uses the same "<" check for the size before parsing. :)
If I change to it and with no attributes to parse would be essentially equal to the
current situation, but if I make it strict "!=" then we won't be able to add
filter attributes later as we won't be backwards compatible. I'll continue looking
into it, but IMO we should leave it as it is in order to be able to add the filtering later.

Thoughts ?




