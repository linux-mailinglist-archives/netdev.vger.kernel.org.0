Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8B4306BED
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 05:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbhA1EH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 23:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbhA1EGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 23:06:38 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5411FC0613D6
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 19:42:22 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id w124so4642209oia.6
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 19:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9Z8K2QrRLWsxdRZgac3musrjVZkH+bPVjUKn0DE2CGo=;
        b=mSgMb4n9vTKXnZnkrDAs8DEo3GVrEkepLkuYZ14HhAEZvIYgswNNNKtFzRGdtAgcrZ
         cW5r3VsulummxXLi3JjG+N74xyjxgzJOhyzL4Sf8p88NGMUrc/08xun4xskE1XHI1CQ6
         I+GRlIi1sIfvVWOXfcyieLwrL17Vo17Fpa//ddafPxznQ+5VG+pGJIotY0NTW0StX3OK
         NCtRUXSxmWriaqUaFK5QfS0H35V1KaIg7HdVkGBMF8HgLEel5eb9fo4nHfKL7RR4coLT
         7ziLsamgcUtQNGWPW1zHv9CJEHu2eeNh/Ia0jYcJdmHI/AJG7xcKeNUH3ZO4OMoNazM/
         FQhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9Z8K2QrRLWsxdRZgac3musrjVZkH+bPVjUKn0DE2CGo=;
        b=fD7TNtx0R+XF6pJDA4pvEUjwzkj/pkbuCrB8WIB65SFlZ2yfxi1OxI28rCjjge5VZ3
         lAR7ILe2QGzMVgdqa6Jsv+/tNGctH/eJrYmIERW9yf3cyfm8StZOTTCS0W1N0cXDgwt5
         qe5iVki3F8lwLCPqGAiohwOlHv8fOS/+x/9yHGnCGRiQUfMRfRCOMWMTTmcgWv+iojbu
         E3rQoRJT/i2erMeahDYE8hBUSOFupfvUM0cw3Xb2PrvtquVKmdgyP+pO2C8yrfd6ix8R
         WPhI2kUE3aHNkNbC0lwB8JED0JDHxmovShNtisgGFBu1nS94uEbCXVAAunVae4fzgPWL
         K4pg==
X-Gm-Message-State: AOAM530Ad9bKlkfKVAPkvukCETs7hnUT26xys9ALVPN3YoZLnrBLcUEE
        1ecVExj+9IGbPTUjhwzCLm6JMfGwjDk=
X-Google-Smtp-Source: ABdhPJwKUflWH04UKoM+wcN/SkyK7P2qCf8amAqoLfKju/Z2CwgIX9AcHZJhYDeQ8tgpQ7D0JFSf1g==
X-Received: by 2002:a05:6808:8ec:: with SMTP id d12mr5152512oic.34.1611805341857;
        Wed, 27 Jan 2021 19:42:21 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id d10sm851221ooh.32.2021.01.27.19.42.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 19:42:21 -0800 (PST)
Subject: Re: [PATCH net-next 01/10] netdevsim: fib: Convert the current
 occupancy to an atomic variable
To:     Amit Cohen <amcohen@nvidia.com>, Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Donald Sharp <sharpd@nvidia.com>,
        Benjamin Poirier <bpoirier@nvidia.com>,
        mlxsw <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
References: <20210126132311.3061388-1-idosch@idosch.org>
 <20210126132311.3061388-2-idosch@idosch.org>
 <b307a304-09ef-d8e8-7296-92ddddfc348c@gmail.com>
 <DM6PR12MB30665BEF4DBA4B1BA697E23ACBBB9@DM6PR12MB3066.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6b48c2cc-b8f5-3d28-5297-cdd306a4bb89@gmail.com>
Date:   Wed, 27 Jan 2021 20:42:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <DM6PR12MB30665BEF4DBA4B1BA697E23ACBBB9@DM6PR12MB3066.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/21 3:51 AM, Amit Cohen wrote:
> 
> 
>> -----Original Message-----
>> From: David Ahern <dsahern@gmail.com>
>> Sent: Wednesday, January 27, 2021 6:33
>> To: Ido Schimmel <idosch@idosch.org>; netdev@vger.kernel.org
>> Cc: davem@davemloft.net; kuba@kernel.org; Amit Cohen <amcohen@nvidia.com>; Roopa Prabhu <roopa@nvidia.com>; Donald
>> Sharp <sharpd@nvidia.com>; Benjamin Poirier <bpoirier@nvidia.com>; mlxsw <mlxsw@nvidia.com>; Ido Schimmel
>> <idosch@nvidia.com>
>> Subject: Re: [PATCH net-next 01/10] netdevsim: fib: Convert the current occupancy to an atomic variable
>>
>> On 1/26/21 6:23 AM, Ido Schimmel wrote:
>>> @@ -889,22 +882,29 @@ static void nsim_nexthop_destroy(struct
>>> nsim_nexthop *nexthop)  static int nsim_nexthop_account(struct nsim_fib_data *data, u64 occ,
>>>  				bool add, struct netlink_ext_ack *extack)  {
>>> -	int err = 0;
>>> +	int i, err = 0;
>>>
>>>  	if (add) {
>>> -		if (data->nexthops.num + occ <= data->nexthops.max) {
>>> -			data->nexthops.num += occ;
>>> -		} else {
>>> -			err = -ENOSPC;
>>> -			NL_SET_ERR_MSG_MOD(extack, "Exceeded number of supported nexthops");
>>> -		}
>>> +		for (i = 0; i < occ; i++)
>>> +			if (!atomic64_add_unless(&data->nexthops.num, 1,
>>> +						 data->nexthops.max)) {
>>
>> seems like this can be
>> 		if (!atomic64_add_unless(&data->nexthops.num, occ,
>> 					 data->nexthops.max)) {
> 
> atomic64_add_unless(x, y, z) adds y to x if x was not already z.
> Which means that when for example num=2, occ=2, max=3:
> atomic64_add_unless(&data->nexthops.num, occ, data->nexthops.max) won't fail when it should.
> 

ok, missed that in the description. I thought it was if the total would
equal or be greater than z.

