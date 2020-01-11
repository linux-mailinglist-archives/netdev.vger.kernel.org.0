Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E634138146
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 12:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbgAKL5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 06:57:15 -0500
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:22669 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgAKL5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 06:57:15 -0500
Received: from [192.168.42.210] ([93.22.149.238])
        by mwinf5d27 with ME
        id ozxC2100d58rESd03zxDWh; Sat, 11 Jan 2020 12:57:13 +0100
X-ME-Helo: [192.168.42.210]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 11 Jan 2020 12:57:13 +0100
X-ME-IP: 93.22.149.238
Subject: Re: [PATCH][next] ath11k: avoid null pointer dereference when pointer
 band is null
From:   Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Colin King <colin.king@canonical.com>
Cc:     David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Janitors <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <05d5d54e035e4d69ad4ffb4a835a495a@huawei.com>
 <64797126-0c77-4c2c-ad2b-29d7af452c13@wanadoo.fr>
Message-ID: <17571eee-9d72-98cb-00f5-d714a28b853b@wanadoo.fr>
Date:   Sat, 11 Jan 2020 12:57:11 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <64797126-0c77-4c2c-ad2b-29d7af452c13@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: fr
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 11/01/2020 à 10:50, linmiaohe a écrit :
> Colin Ian King<colin.king@canonical.com>  wrote：
>> From: Colin Ian King<colin.king@canonical.com>
>>
>> In the unlikely event that cap->supported_bands has neither WMI_HOST_WLAN_2G_CAP set or WMI_HOST_WLAN_5G_CAP set then pointer band is null and a null dereference occurs when assigning
>> band->n_iftype_data.  Move the assignment to the if blocks to
>> avoid this.  Cleans up static analysis warnings.
>>
>> Addresses-Coverity: ("Explicit null dereference")
>> Fixes: 9f056ed8ee01 ("ath11k: add HE support")
>> Signed-off-by: Colin Ian King<colin.king@canonical.com>
>> ---
>> drivers/net/wireless/ath/ath11k/mac.c | 8 ++++----
>> 1 file changed, 4 insertions(+), 4 deletions(-)
> It looks fine for me. Thanks.
> Reviewed-by: Miaohe Lin<linmiaohe@huawei.com>
(sorry for incomplete mail and mailing list addresses, my newsreader ate 
them, and I cannot get the list from get_maintainer.pl because my 
(outdated) tree does not have ath11k/...
I've only including the ones in memory of my mail writer.

Please forward if needed)


Hi

Shouldn't there be a

|

- band->n_iftype_data  =  count; at the end of the patch if the assignment is *moved*? Without it, 
'band' (as well as 'count') could be un-initialized, and lead to memory 
corruption. Just my 2c. CJ |

