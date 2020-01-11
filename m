Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 577AA138135
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 12:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729233AbgAKLre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 06:47:34 -0500
Received: from blaine.gmane.org ([195.159.176.226]:57358 "EHLO
        blaine.gmane.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgAKLrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 06:47:33 -0500
Received: from list by blaine.gmane.org with local (Exim 4.89)
        (envelope-from <gl-netdev-2@m.gmane.org>)
        id 1iqFCF-000e3K-Gt
        for netdev@vger.kernel.org; Sat, 11 Jan 2020 12:44:51 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     netdev@vger.kernel.org
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH][next] ath11k: avoid null pointer dereference when pointer
 band is null
Date:   Sat, 11 Jan 2020 12:44:22 +0100
Message-ID: <8e70739d-6b5f-9448-d012-05efc38ab988@wanadoo.fr>
References: <05d5d54e035e4d69ad4ffb4a835a495a@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
Cc:     linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <05d5d54e035e4d69ad4ffb4a835a495a@huawei.com>
Content-Language: en-US
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 11/01/2020 à 10:50, linmiaohe a écrit :
> Colin Ian King <colin.king@canonical.com> wrote：
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> In the unlikely event that cap->supported_bands has neither WMI_HOST_WLAN_2G_CAP set or WMI_HOST_WLAN_5G_CAP set then pointer band is null and a null dereference occurs when assigning
>> band->n_iftype_data.  Move the assignment to the if blocks to
>> avoid this.  Cleans up static analysis warnings.
>>
>> Addresses-Coverity: ("Explicit null dereference")
>> Fixes: 9f056ed8ee01 ("ath11k: add HE support")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>> drivers/net/wireless/ath/ath11k/mac.c | 8 ++++----
>> 1 file changed, 4 insertions(+), 4 deletions(-)
> It looks fine for me. Thanks.
> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Shouldn't there be a

|

- band->n_iftype_data  =  count; at the end of the patch if the assignment is *moved*? Without it, 
'band' (as well as 'count') could be un-initialized, and lead to memory 
corruption. Just my 2c. CJ |


