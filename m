Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3471E375E
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 06:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgE0Ecw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 00:32:52 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:64389 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgE0Ecv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 00:32:51 -0400
Received: from [10.193.177.188] (chethan-pc.asicdesigners.com [10.193.177.188] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 04R4WgPv029537;
        Tue, 26 May 2020 21:32:44 -0700
Subject: Re: [PATCH net v2] cxgb4/chcr: Enable ktls settings at run time
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
References: <20200526140634.21043-1-rohitm@chelsio.com>
 <20200526154241.24447b41@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   rohit maheshwari <rohitm@chelsio.com>
Message-ID: <00b63ada-06d0-5298-e676-1c02e8676d61@chelsio.com>
Date:   Wed, 27 May 2020 10:02:42 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20200526154241.24447b41@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 27/05/20 4:12 AM, Jakub Kicinski wrote:
> On Tue, 26 May 2020 19:36:34 +0530 Rohit Maheshwari wrote:
>> Current design enables ktls setting from start, which is not
>> efficient. Now the feature will be enabled when user demands
>> TLS offload on any interface.
>>
>> v1->v2:
>> - taking ULD module refcount till any single connection exists.
>> - taking rtnl_lock() before clearing tls_devops.
> Callers of tls_devops don't hold the rtnl_lock.
I think I should correct the statement here, " taking rtnl_lock()
before clearing tls_devops and device flags". There won't be any
synchronization issue while clearing tls_devops now, because I
am incrementing module refcount of CRYPTO ULD, so this will
never be called if there is any connection (new connection
request) exists.
>> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
