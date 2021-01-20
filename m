Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075872FC925
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730110AbhATDfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 22:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731830AbhATC30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 21:29:26 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21475C0613C1
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 18:28:43 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id 36so10431018otp.2
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 18:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JIB/ou9F3Q9Bjm2JkXJgbj3HotfhqjfPfmPXsoPA6b0=;
        b=XZ8iO1DS1jMU3JmjU4qWHYCrqgsT9QAkjVGxCGL1kxqQaXNGXgMf6vmVyl1KPeixlB
         gmmm+NSKxiYksyMWr6AElrbPm9P1F+6z8OFtsbfC1hqzJQfQrytdOC8hwTYXx12ZKoCA
         quyOegIGc9H5rp8i2cbWiWSCaFCQqUwYbbIlQHXC3oRXb8vPcENIFmOP/g50BLGJkBIc
         3GPO95y25P4N8XD0pg3D/WVl7C2cDZcFUJec5+SIpLg8T/pQzWq/VDJSEtmW/z9SP+Nu
         bK+n0xvHQu7xUq7fl1PLIMnK62u433RV+RxwZXmc3icLicF50+pcU6K58oXAm2RBDRos
         gLYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JIB/ou9F3Q9Bjm2JkXJgbj3HotfhqjfPfmPXsoPA6b0=;
        b=qNmTRy5toqY/BxXwaE6IwufRKmhO5N1TM/V0eQVBZVNLTZvneDjISKCJJ1ZhRXDsIe
         QnCOSD69s/M+rhkQE1hR71vZi+3ev2zu0Ml5ECqK3iP09OGNglUFJogPxKUUbk2qoqYV
         P4Bl4CiH/jsQ5QRja+y0mrmxxCnSnrCYIIa0M34v0EQF7xN+oMY57ok0EtRgBNxq0uX+
         Tr5JLW3+caJQCt8eqvOo8MPbiTRSwFlPP7l1rCp8lcWdSaZcWk3PCnf46Nq29yf31MXl
         g86uc8kTf7cG5gCujtC/fUrlH1QksVA5BtiAl3HVozwN/pYjZ+bPHp3XL1GwDaYZhkr3
         UTvg==
X-Gm-Message-State: AOAM530Kc+RhIXsNyDmZXfRAf1HBNoNVR6EK4K3NNUX7oG5JkFkR/BD9
        NGV3I78bnVC/M2YWJTbkd/I=
X-Google-Smtp-Source: ABdhPJx+rlG0GghgO/QDkxeklRHxLD3SNOfm95z7ltAKK8JBjweG1bcZzppaWAPZRD74xa8SDuM0Mg==
X-Received: by 2002:a9d:d6b:: with SMTP id 98mr5522318oti.227.1611109722554;
        Tue, 19 Jan 2021 18:28:42 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.6.112.237])
        by smtp.googlemail.com with ESMTPSA id z3sm130832otq.22.2021.01.19.18.28.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 18:28:41 -0800 (PST)
Subject: Re: [PATCH net-next 1/3] nexthop: Use a dedicated policy for
 nh_valid_get_del_req()
To:     Jakub Kicinski <kuba@kernel.org>, Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1610978306.git.petrm@nvidia.org>
 <ec93d227609126c98805e52ba3821b71f8bb338d.1610978306.git.petrm@nvidia.org>
 <20210119125504.0b306d97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <74bb53b9-1bda-ba42-ceeb-9e85c8c2ea27@gmail.com>
Date:   Tue, 19 Jan 2021 19:28:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210119125504.0b306d97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/21 1:55 PM, Jakub Kicinski wrote:
>> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
>> index e53e43aef785..d5d88f7c5c11 100644
>> --- a/net/ipv4/nexthop.c
>> +++ b/net/ipv4/nexthop.c
>> @@ -36,6 +36,10 @@ static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] = {
>>  	[NHA_FDB]		= { .type = NLA_FLAG },
>>  };
>>  
>> +static const struct nla_policy rtm_nh_policy_get[NHA_MAX + 1] = {
> 
> This is an unnecessary waste of memory if you ask me.
> 
> NHA_ID is 1, so we're creating an array of 10 extra NULL elements.
> 
> Can you leave the size to the compiler and use ARRAY_SIZE() below?

interesting suggestion in general for netlink attributes.

> 
>> +	[NHA_ID]		= { .type = NLA_U32 },
>> +};
>> +
>>  static bool nexthop_notifiers_is_empty(struct net *net)
>>  {
>>  	return !net->nexthop.notifier_chain.head;
>> @@ -1843,27 +1847,14 @@ static int nh_valid_get_del_req(struct nlmsghdr *nlh, u32 *id,
>>  {
>>  	struct nhmsg *nhm = nlmsg_data(nlh);
>>  	struct nlattr *tb[NHA_MAX + 1];

This tb array too could be sized to just the highest indexed expected -
NHA_ID in this case.

>> -	int err, i;
>> +	int err;
>>  
>> -	err = nlmsg_parse(nlh, sizeof(*nhm), tb, NHA_MAX, rtm_nh_policy,
>> +	err = nlmsg_parse(nlh, sizeof(*nhm), tb, NHA_MAX, rtm_nh_policy_get,
>>  			  extack);
>>  	if (err < 0)
>>  		return err;
>>  
>>  	err = -EINVAL;
>> -	for (i = 0; i < __NHA_MAX; ++i) {
>> -		if (!tb[i])
>> -			continue;
>> -
>> -		switch (i) {
>> -		case NHA_ID:
>> -			break;
>> -		default:
>> -			NL_SET_ERR_MSG_ATTR(extack, tb[i],
>> -					    "Unexpected attribute in request");
>> -			goto out;
>> -		}
>> -	}
>>  	if (nhm->nh_protocol || nhm->resvd || nhm->nh_scope || nhm->nh_flags) {
>>  		NL_SET_ERR_MSG(extack, "Invalid values in header");
>>  		goto out;
> 

