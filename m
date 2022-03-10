Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8239D4D3FE8
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 04:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbiCJDvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 22:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234822AbiCJDvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 22:51:38 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B0812B764
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 19:50:37 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id q189so4746721oia.9
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 19:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=L9GLR8qBxcL1SS0X7w/cdkvdT+zag22wSXl/ZkApVlo=;
        b=HksMmk3jCvHBJk+2qi3eSd4jyi7WvL1Nu+ClVhYsUELptyEKUYhcBReDEX41CJtvf4
         rTNJyK0hNWrMOTE/NxNbztftLIHxMH3SJUCEBa0+4VRfZ5P8E/VWk1y6JDqPl+Rr+aJc
         UJJWAGPWpEiDsF/XF4iYD0R5rOwZdwRxQ0blI1ZkJEOkgGW+5LgwOfD7xWCYO+/vSVh4
         jVj1AaCxfaHmwrfVWVk0SOl4F1jfUoxPUgdh3bjBzrqBLOTvzPU88z4LB4h41Hk7Taqm
         f+1qaC3k05r2SzMO4XMimxwKY/au/9bb4tY/t2VaqbDqGodhE6MF3EDp5zUwP9Rl0O6U
         E+lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=L9GLR8qBxcL1SS0X7w/cdkvdT+zag22wSXl/ZkApVlo=;
        b=nK0bj5mB31QG0W1WCcpjczJpekit4YisJZ+W2iMLugFMprhCWy4L6KJdLnx7GfQXdB
         xdL1xXHzondJ6FiUxMe/091MwoUsWEw8C5OLXl5ZT43HWXZWBE/NLfxjVc+GaiNgACQK
         GSvK9EM/k+wwmj6E8ae2Her19milw1xT3k+LZ+EXUIeOr92GoeMYhMU8s5yA4ntDBxmc
         nGIZjWW+BDYLsKfsPHgYUe0A8lm+dsL5wqJ51+jgCXjlcZxugRjvV3WGkxKowkk6zYCm
         O/DkkA5d2ywlSKodONsmqayxBt7EmPqN/MMo5haIYpLBtDoi1G7xcHA4rMKf/sDqwv40
         l+Lg==
X-Gm-Message-State: AOAM530tCrc5rY2dKl25IWDDMN/LS2J3pHyAEfG/70zJwVCHwg4muDHS
        lftFwcF6vrxBgRnh6F+nblCaz1fvt3rRMQ==
X-Google-Smtp-Source: ABdhPJyzcDKT3ShX7I6nvbDq4j83KRyByL7nLNy6A+EDIb65T3xcyz9QU/xaSMHnR4lmJ87dgFiVRw==
X-Received: by 2002:a05:6808:1416:b0:2d9:d291:a912 with SMTP id w22-20020a056808141600b002d9d291a912mr8279523oiv.143.1646884236872;
        Wed, 09 Mar 2022 19:50:36 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.65])
        by smtp.googlemail.com with ESMTPSA id l4-20020a4a94c4000000b002ea822fbac8sm1920118ooi.21.2022.03.09.19.50.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 19:50:36 -0800 (PST)
Message-ID: <ae513933-4ec1-d3bc-f024-d620d0a6ed46@gmail.com>
Date:   Wed, 9 Mar 2022 20:50:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH net-next 2/2] net: limit altnames to 64k total
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@resnulli.us,
        George Shuklin <george.shuklin@gmail.com>
References: <20220309182914.423834-1-kuba@kernel.org>
 <20220309182914.423834-3-kuba@kernel.org>
 <3731ad8f-55b4-154e-28b7-0ee6cea827b8@gmail.com>
 <20220309193708.340a6af5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220309193708.340a6af5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/22 8:37 PM, Jakub Kicinski wrote:
> On Wed, 9 Mar 2022 19:51:07 -0700 David Ahern wrote:
>> On 3/9/22 11:29 AM, Jakub Kicinski wrote:
>>> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>>> index aa05e89cc47c..159c9c61e6af 100644
>>> --- a/net/core/rtnetlink.c
>>> +++ b/net/core/rtnetlink.c
>>> @@ -3652,12 +3652,23 @@ static int rtnl_alt_ifname(int cmd, struct net_device *dev, struct nlattr *attr,
>>>  			   bool *changed, struct netlink_ext_ack *extack)
>>>  {
>>>  	char *alt_ifname;
>>> +	size_t size;
>>>  	int err;
>>>  
>>>  	err = nla_validate(attr, attr->nla_len, IFLA_MAX, ifla_policy, extack);
>>>  	if (err)
>>>  		return err;
>>>  
>>> +	if (cmd == RTM_NEWLINKPROP) {
>>> +		size = rtnl_prop_list_size(dev);
>>> +		size += nla_total_size(ALTIFNAMSIZ);
>>> +		if (size >= U16_MAX) {
>>> +			NL_SET_ERR_MSG(extack,
>>> +				       "effective property list too long");
>>> +			return -EINVAL;
>>> +		}
>>> +	}
>>> +
>>>  	alt_ifname = nla_strdup(attr, GFP_KERNEL_ACCOUNT);
>>>  	if (!alt_ifname)
>>>  		return -ENOMEM;  
>>
>> this tests the existing property size. Don't you want to test the size
>> with the alt_ifname - does it make the list go over 64kB?
> 
> Do you mean counting the exact length of the string?
> 
> Or that I'm counting pre-add? That's why I added:
> 
> 	size += nla_total_size(ALTIFNAMSIZ);
> 
> I like coding things up as prepare (validate) + commit,
> granted it doesn't exactly look pretty here so I can recode
> if you prefer. But there's no bug, right? (other than maybe 
>> = could have been > but whatever).

right. It's a worst case size estimation versus taking into account the
actual space used for the name (rtnl_prop_list_size does that for each
name so this is really conservative in space use).

Reviewed-by: David Ahern <dsahern@kernel.org>
