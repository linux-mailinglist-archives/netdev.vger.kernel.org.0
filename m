Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDD12D3427
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbgLHUau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:30:50 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:5146 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730078AbgLHUat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 15:30:49 -0500
Received: from [10.193.177.141] (shamnad.asicdesigners.com [10.193.177.141] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0B8J3Kiv008401;
        Tue, 8 Dec 2020 11:03:21 -0800
Subject: Re: [PATCH net v2] net/tls: Fix kernel panic when socket is in tls
 toe mode
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
References: <20201205113529.14574-1-vinay.yadav@chelsio.com>
 <20201208101927.39dddc85@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Message-ID: <3047d30a-0fc0-c241-e0e9-641ab99c243b@chelsio.com>
Date:   Wed, 9 Dec 2020 00:46:23 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201208101927.39dddc85@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/8/2020 11:49 PM, Jakub Kicinski wrote:
> On Sat,  5 Dec 2020 17:05:30 +0530 Vinay Kumar Yadav wrote:
>> When socket is in tls-toe (TLS_HW_RECORD) and connections
>> are established in kernel stack, on every connection close
>> it clears tls context which is created once on socket creation,
>> causing kernel panic. fix it by not initializing listen in
>> kernel stack incase of tls-toe, allow listen in only adapter.
> 
> IOW the socket will no longer be present in kernel's hash tables?
> 
Yes, when tls-toe devices are present.
