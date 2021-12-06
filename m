Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E563A469E58
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 16:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356706AbhLFPiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 10:38:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388619AbhLFPeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 10:34:25 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26438C08E887
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 07:20:12 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id i5-20020a05683033e500b0057a369ac614so14005581otu.10
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 07:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1MFs3OxsE2/CiZfsm5WkE1ZG4KsgbSlX5OMi4PmyJJE=;
        b=GJa7Dcd8aQt6r87QALrKdMZeU9e0U6D0290YqkT/OawX7n5zty2NUXYVEhkSvj0/DO
         kQFc78ov3pl6uUzCff2M8tlEa19n187jZJqx75Xtb2Srf+H3boLj68/mmGMLbz8CMN6K
         Fd1Y+XrefRhm+Cq9W196NezczcBfId0qRisF0F8tYle8j7A0xui9ne4y50kPcuMr/g2c
         IAlv8RgjPSikPhrzCitg7u0J6PsQ2SGBMZLMM0EbSAGDFtMvAoDyQhu4c0eZOhxqqqSa
         tvDzbcpDSdxGwsSz4QfqW7FdpI54Cocgi8Q8AMGgpyNDn2iBIr7C5pX7z2cNdY3kBETg
         4GgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1MFs3OxsE2/CiZfsm5WkE1ZG4KsgbSlX5OMi4PmyJJE=;
        b=FJR9BR0PPR0xslTU+5iy5Ywl0A+RPAiMJ1gUbe6//oRyrWieyf9g9ew+zWwqBpiU45
         bH6fvfdYZ2q/47jQUITq6Xp1CD73Q7gQi3btwwCbTym8uDZgoaj37LsVvFJwIldGKqpo
         aajU4+cWaL+K9ila1bfXA/+Ij5+mr/etQ33zsSJhIDAslJO3htsYt8lO446uYYI68b4B
         XLeJ5qMcbQ6KFSGCb0T/ydP7eozerVUMqPJC1NDYP+TmxdTCpNdg73v1gx8Aqybin0se
         EPqKtSLwk69GZuYoqPwms08dONHrNjzQ457c1Xj/+S8ritMum8KYdTWh2dZaO9BkOD2n
         +y2g==
X-Gm-Message-State: AOAM5330FrZobSlV705v/qDJgCwVBv2GU/SWJOxo4MTJYE73Lrid5RkX
        2owr0j+3y3VU0HoKhCGB2DSDKEKHO4U=
X-Google-Smtp-Source: ABdhPJxDgDcDytQSpHnng8Ci3VTzldmAzBY3VmvJFj3oL6JA8QXEne1HAL65OZfd/dfk8yjQVk7JNw==
X-Received: by 2002:a9d:628f:: with SMTP id x15mr18952616otk.348.1638804011544;
        Mon, 06 Dec 2021 07:20:11 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id f12sm2205103ote.75.2021.12.06.07.20.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 07:20:11 -0800 (PST)
Message-ID: <98c6884c-642b-66d3-10ad-a8f0afebf446@gmail.com>
Date:   Mon, 6 Dec 2021 08:20:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH net-next v5] rtnetlink: Support fine-grained netdevice
 bulk deletion
Content-Language: en-US
To:     nicolas.dichtel@6wind.com,
        Lahav Schlesinger <lschlesinger@drivenets.com>,
        netdev@vger.kernel.org
Cc:     kuba@kernel.org, nikolay@nvidia.com
References: <20211205093658.37107-1-lschlesinger@drivenets.com>
 <84166fe9-37f1-2c99-2caf-c68dcc5a370c@6wind.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <84166fe9-37f1-2c99-2caf-c68dcc5a370c@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/21 1:25 AM, Nicolas Dichtel wrote:
>> @@ -3050,6 +3052,78 @@ static int rtnl_group_dellink(const struct net *net, int group)
>>  	return 0;
>>  }
>>  
>> +static int dev_ifindex_cmp(const void *a, const void *b)
>> +{
>> +	struct net_device * const *dev1 = a, * const *dev2 = b;
>> +
>> +	return (*dev1)->ifindex - (*dev2)->ifindex;
>> +}
>> +
>> +static int rtnl_ifindex_dellink(struct net *net, struct nlattr *head, int len,
>> +				struct netlink_ext_ack *extack)
>> +{
>> +	int i = 0, num_devices = 0, rem;
>> +	struct net_device **dev_list;
>> +	const struct nlattr *nla;
>> +	LIST_HEAD(list_kill);
>> +	int ret;
>> +
>> +	nla_for_each_attr(nla, head, len, rem) {
>> +		if (nla_type(nla) == IFLA_IFINDEX)
>> +			num_devices++;
>> +	}
>> +
>> +	dev_list = kmalloc_array(num_devices, sizeof(*dev_list), GFP_KERNEL);
>> +	if (!dev_list)
>> +		return -ENOMEM;
>> +
>> +	nla_for_each_attr(nla, head, len, rem) {
>> +		const struct rtnl_link_ops *ops;
>> +		struct net_device *dev;
>> +		int ifindex;
>> +
>> +		if (nla_type(nla) != IFLA_IFINDEX)
>> +			continue;
>> +
>> +		ifindex = nla_get_s32(nla);
>> +		ret = -ENODEV;
>> +		dev = __dev_get_by_index(net, ifindex);
>> +		if (!dev) {
>> +			NL_SET_ERR_MSG_ATTR(extack, nla, "Unknown ifindex");
> It would be nice to have the ifindex in the error message. This message does not
> give more information than "ENODEV".

extack infra does not allow dynamic messages. It does point to the
location of the bad index, so userspace could figure it out.

> 
>> +			goto out_free;
>> +		}
>> +
>> +		ret = -EOPNOTSUPP;
>> +		ops = dev->rtnl_link_ops;
>> +		if (!ops || !ops->dellink) {
>> +			NL_SET_ERR_MSG_ATTR(extack, nla, "Device cannot be deleted");
> Same here.
> 
> 
> Thank you,
> Nicolas
> 

