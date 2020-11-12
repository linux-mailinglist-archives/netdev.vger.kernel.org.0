Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DCA2B0904
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgKLPzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:55:08 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18452 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbgKLPzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:55:07 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fad5ad40000>; Thu, 12 Nov 2020 07:55:00 -0800
Received: from [10.26.72.39] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 15:54:54 +0000
Subject: Re: [PATCH net-next 2/2] net/mlx5e: Add DSFP EEPROM dump support to
 ethtool
To:     Andrew Lunn <andrew@lunn.ch>, Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
References: <1605160181-8137-1-git-send-email-moshe@mellanox.com>
 <1605160181-8137-3-git-send-email-moshe@mellanox.com>
 <20201112131321.GL1480543@lunn.ch>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <74076266-d861-993d-cd84-1cf170937c5f@nvidia.com>
Date:   Thu, 12 Nov 2020 17:54:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201112131321.GL1480543@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605196500; bh=AlQUsIIvi1vx9vzhpJCTmYuyukuo54TxajiSXi4JMUI=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=ADWfX9m71HxHqTm0Wmyn0dj2A2Df8+Pu7oMbuyQoI/G8HOulO8YQqQYryaxUQNI19
         elq41wZSxA8Og30/wcpZdcLWBoXL/sxZ5hcArpGzHz3jzM2nIW3W5iDBikaaMUI+SF
         VZ9IUOUssijwRbuJh2enIOVqt05FQdZ4wKRD8y4g/EzJpWsG0egI9Xco7BHUwSBHKr
         md/wKBVpRWECBavOOBRA8sSeCNOFuxLCJocCI9/i63WdIbbZKVrvxiDZ/K3SthPZY7
         ID9athsELxZpV1/7hCMcwGIciJFbfEibotmBB4vVv6WHnzDDI8j0h0HgIPeKsIGmp9
         cTuhWSiYWYBjQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/12/2020 3:13 PM, Andrew Lunn wrote:
> On Thu, Nov 12, 2020 at 07:49:41AM +0200, Moshe Shemesh wrote:
>> From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
>>
>> DSFP is a new cable module type, which EEPROM uses memory layout
>> described in CMIS 4.0 document. Use corresponding standard value for
>> userspace ethtool to distinguish DSFP's layout from older standards.
>>
>> Add DSFP module ID in accordance to SFF-8024.
>>
>> DSFP module memory can be flat or paged, which is indicated by a
>> flat_mem bit. In first case, only page 00 is available, and in second -
>> multiple pages: 00h, 01h, 02h, 10h and 11h.
> You are simplifying quite a bit here, listing just these pages. When i
> see figure 8-1, CMIS Module Memory Map, i see many more pages, and
> banks of pages.


Right, but as I understand these are the basic 5 pages which are 
mandatory. Supporting more than that we will need new API.

> The current API is getting more and more strand to support SFP
> EEPROMs. We really do need to think of a new API, and it seems like
> now is a good time to do it, in order to support these devices.
>
>      Andrew
