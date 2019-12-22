Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8213128C97
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 05:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfLVE5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 23:57:38 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:34821 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbfLVE5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 23:57:37 -0500
Received: by mail-io1-f66.google.com with SMTP id v18so13299118iol.2
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 20:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jcnk1B0MsUqEQj419gGeSMvJeezB1YbnBJ98+8euboc=;
        b=ajO6ZGx0zBl2RwDzuOf3bZj29RXDfvutuKgnm2RQQyKZtvlmGsV7iEzrWFDl4ht22Q
         kGv7355jRRHHnTIaeck6+obiDxn0gS6NjWeP21uY4d/UUb25VU3nlRamCWmZ1iNDMVBo
         0PKuk0aFgjKNb5u/CBqKc88+PoAMLASNzAv5hokH+OrG9a5fkUtV8k/ugwgUNOqoktyg
         +HS7PO2C4yq56Mngn3ngr9YzI+7+kVOPfPGmh9AJIwU8SiY2tC/0dHeJeHGXqtZXUJ9l
         igKmeOdah9Xdw9055zLVCe3Afv4+YV6n7ZRoCtw0uF3gBkWV3qN/esP42MGTS9Qrg3xC
         soWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jcnk1B0MsUqEQj419gGeSMvJeezB1YbnBJ98+8euboc=;
        b=r9tto2Lzx3SFY8MzWjfBwWL2niAXvdwOc7Cm/yqKbCAwdBr9pO/WYOV44dyD8XyeaK
         /M0bkhXZdfVNeJEw0nM/eJyvUC8IEquTgPF/Waz6RZIOfj3/afLUrFPo4Vzga/e24C4y
         uG9yD4MRoNlCknOHtSu1dMnmStS084H7mahpQztYCt1gUvfYk4oQPNWWf3uI5EL+su/L
         Kwd2rZv+8zMBv8sqKDMDV9+AonWhTDsisJObIZeIbKN/S5Hi+hbE/mNUXgT7vMXhXlR9
         GqrKywnnl8GjQOsywQBFqmAs6ZOqiAhRDbqe4fdOG/YPLZUssVbYzw3gZNFSXPLPWm5G
         8Xzw==
X-Gm-Message-State: APjAAAUBH9eo2guGviE5ok1N89uPCSy/Zew7UdbHR0iYTsgZpJSK8vBz
        OaHUYlraa9wHjL4s5CrAWEI=
X-Google-Smtp-Source: APXvYqzsjDPL9Jj6pCENLgGRgrs5cu6T3/06mSa3LotVSqpkEJxWeiGtVyvbpdtaE6d7hRiI3cBzeg==
X-Received: by 2002:a5e:9902:: with SMTP id t2mr15550376ioj.120.1576990657155;
        Sat, 21 Dec 2019 20:57:37 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:9c40:b5b:dc0:a3f8? ([2601:282:800:fd80:9c40:b5b:dc0:a3f8])
        by smtp.googlemail.com with ESMTPSA id s88sm7658934ilk.79.2019.12.21.20.57.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Dec 2019 20:57:36 -0800 (PST)
Subject: Re: [patch net-next 0/4] net: allow per-net notifier to follow netdev
 into namespace
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, saeedm@mellanox.com, leon@kernel.org,
        tariqt@mellanox.com, ayal@mellanox.com, vladbu@mellanox.com,
        michaelgur@mellanox.com, moshe@mellanox.com, mlxsw@mellanox.com
References: <20191220123542.26315-1-jiri@resnulli.us>
 <72587b16-d459-aa6e-b813-cf14b4118b0c@gmail.com>
 <20191221081406.GB2246@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e66fee63-ad27-c5e0-8321-76999e7d82c9@gmail.com>
Date:   Sat, 21 Dec 2019 21:57:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191221081406.GB2246@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/21/19 1:14 AM, Jiri Pirko wrote:
> Fri, Dec 20, 2019 at 07:30:22PM CET, dsahern@gmail.com wrote:
>> On 12/20/19 5:35 AM, Jiri Pirko wrote:
>>> However if netdev can change namespace, per-net notifier cannot be used.
>>> Introduce dev_net variant that is basically per-net notifier with an
>>> extension that re-registers the per-net notifier upon netdev namespace
>>> change. Basically the per-net notifier follows the netdev into
>>> namespace.
>>
>> This is getting convoluted.
>>
>> If the driver wants notifications in a new namespace, then it should
>> register for notifiers in the new namespace. The info for
>> NETDEV_UNREGISTER event could indicate the device is getting moved to a
>> new namespace and the driver register for notifications in the new
> 
> Yes, I considered this option. However, that would lead to having a pair
> of notifier block struct for every registration and basically the same
> tracking code would be implemented in every driver.
> 
> That is why i chose this implementation where there is still one
> notifier block structure and the core takes care of the tracking for
> all.
> 

This design has core code only handling half of the problem - automatic
registration in new namespaces for a netdev but not dealing with drivers
receiving notifications in namespaces they no longer care about. If a
driver cares for granularity, it can deal with namespace changes on its
own. If that's too much, use the global registration.
