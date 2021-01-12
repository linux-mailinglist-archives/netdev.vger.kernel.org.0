Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB322F3D64
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407049AbhALViZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:38:25 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:58772 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437143AbhALVTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 16:19:20 -0500
Received: from [10.193.177.153] (moorthi.asicdesigners.com [10.193.177.153] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 10CLHoxb022281;
        Tue, 12 Jan 2021 13:17:52 -0800
Subject: Re: [net] net: feature check mandating HW_CSUM is wrong
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com,
        ast@kernel.org, bjorn.topel@intel.com, daniel@iogearbox.net,
        andriin@fb.com, tariqt@nvidia.com, edumazet@google.com,
        xiyou.wangcong@gmail.com, ap420073@gmail.com, jiri@mellanox.com,
        borisp@nvidia.com
References: <20210106175327.5606-1-rohitm@chelsio.com>
 <20210106111710.34ab4eab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   rohit maheshwari <rohitm@chelsio.com>
Message-ID: <3d94bd63-dee0-3699-8e42-193e652592fa@chelsio.com>
Date:   Wed, 13 Jan 2021 02:47:51 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20210106111710.34ab4eab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 07/01/21 12:47 AM, Jakub Kicinski wrote:
> On Wed,  6 Jan 2021 23:23:27 +0530 Rohit Maheshwari wrote:
>> Mandating NETIF_F_HW_CSUM to enable TLS offload feature is wrong.
>> And it broke tls offload feature for the drivers, which are still
>> using NETIF_F_IP_CSUM or NETIF_F_IPV6_CSUM. We should use
>> NETIF_F_CSUM_MASK instead.
>>
>> Fixes: ae0b04b238e2 ("net: Disable NETIF_F_HW_TLS_TX when HW_CSUM is disabled")
>> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
> Please use Tariq's suggestion.
HW_TLS_TX feature is for both IPv4/v6. And If one device is limited to
support only IPv4 checksum offload, TLS offload should be allowed for
that too. So I think putting a check of CSUM_MASK is enough.
