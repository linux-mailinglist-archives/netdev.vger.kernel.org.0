Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDE62D2122
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 03:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgLHCuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 21:50:12 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4559 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgLHCuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 21:50:12 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fcee9ba0000>; Mon, 07 Dec 2020 18:49:30 -0800
Received: from [172.27.8.99] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 8 Dec
 2020 02:49:29 +0000
Subject: Re: [PATCH net] net: flow_offload: Fix memory leak for indirect flow
 block
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <roid@nvidia.com>
References: <20201207015916.43126-1-cmi@nvidia.com>
 <20201207182832.346e246e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Chris Mi <cmi@nvidia.com>
Message-ID: <54ce3946-7b8b-1cb6-e949-f6854c6cd78c@nvidia.com>
Date:   Tue, 8 Dec 2020 10:49:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201207182832.346e246e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607395770; bh=4ztV9VUiwvQhkLXNsJ9uLoEg9PrwC9ncETQmc7UuS4A=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=PCjeuFCKHuP+o8NP9DXXRyB1q+te0FxkoavyA6xIHubbcMVGUKC1AoIA81gAINo0T
         53Br9BsaCef4LDtNNhWBrCUxiQBq5+tMlj4/VtKaa/YTpFylnDlRAT8jLPlKS2L/Iw
         clSrKqseJsoqm6vHuvJXzRIPOnRMlG6BZc61d5q4n5hClLHmv4CY6JMukba+1VdWqv
         pi1yxjI6qWgWtoZr8uk6fyq2OmopcNoJVi0DxeSPIu2SIb7K+IL9tg/5/+fvNXFIe4
         bxj76mDc6+y8WhHSoqPGd9BcEzRrGF/VR9mxNuZRlL5oAgTBW2hUkt+G92lDj88xdZ
         Bl2CraE+xOLJg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/2020 10:28 AM, Jakub Kicinski wrote:
> On Mon,  7 Dec 2020 09:59:16 +0800 Chris Mi wrote:
>> The offending commit introduces a cleanup callback that is invoked
>> when the driver module is removed to clean up the tunnel device
>> flow block. But it returns on the first iteration of the for loop.
>> The remaining indirect flow blocks will never be freed.
>>
>> Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")
>> Signed-off-by: Chris Mi <cmi@nvidia.com>
>> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Please repost and CC relevant people.
>
Done.
