Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD46306AA8
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhA1Bq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:46:58 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18851 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbhA1Bqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 20:46:51 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6012175f0003>; Wed, 27 Jan 2021 17:46:07 -0800
Received: from [172.27.8.81] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Jan
 2021 01:46:02 +0000
Subject: Re: [PATCH net-next v3] net: psample: Introduce stubs to remove NIC
 driver dependency
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <jiri@nvidia.com>, <saeedm@nvidia.com>,
        "kernel test robot" <lkp@intel.com>
References: <20210127101648.513562-1-cmi@nvidia.com>
 <20210127154934.2afbadda@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Chris Mi <cmi@nvidia.com>
Message-ID: <39607ec0-feab-2f0f-c13f-f106676e9a7a@nvidia.com>
Date:   Thu, 28 Jan 2021 09:45:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210127154934.2afbadda@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611798367; bh=EnusXecb0daihlBa67YAnsOA/2k8og1cuODWcZ6SkWQ=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=WaioSAt68lAatys1ZQeRwLrmJWVzs0Rac8Oi+oXaYwbJVU65sMcRhDQr+C/7CPYXc
         VXfDJrq4EBZY4YAxBYkvb8o7lYI3cn/Fd+54uUWeD2bfoSspJJvkmsu5O0OvQNq5f6
         +O4D5tVyJBVL5c/mh07K0anzhRi+N1mXUohAcwOtn07PT233Op6s9g2QJAnCXYQ4ik
         VcKdu4xuOReU8afpDyHXIuA7eDP5ilRm+Yi7409FKDmKHghif0UW0DJvmY1fLSt1gB
         vbA7rTsGbV/hv3Sme22/ztGRk5TCkRmOJm8Jkq7BEywdZz0y9JPPQ/H9tVnsvQsvkw
         pnucrSmiidCng==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/2021 7:49 AM, Jakub Kicinski wrote:
> On Wed, 27 Jan 2021 18:16:48 +0800 Chris Mi wrote:
>> @@ -35,4 +45,21 @@ static inline void psample_sample_packet(struct psample_group *group,
>>   
>>   #endif
>>   
>> +static void
> static inline
Done.
>
>> +psample_nic_sample_packet(struct psample_group *group,
>> +			  struct sk_buff *skb, u32 trunc_size,
>> +			  int in_ifindex, int out_ifindex,
>> +			  u32 sample_rate)
>> +{
>> +	const struct psample_ops *ops;
>> +
>> +	rcu_read_lock();
>> +	ops = rcu_dereference(psample_ops);
>> +	if (ops)
>> +		ops->sample_packet(group, skb, trunc_size,
>> +				   in_ifindex, out_ifindex,
>> +				   sample_rate);
>> +	rcu_read_unlock();
>> +}

