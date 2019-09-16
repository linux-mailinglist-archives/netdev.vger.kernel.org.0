Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF62B348A
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 07:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbfIPFxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 01:53:53 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:48860 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725270AbfIPFxx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Sep 2019 01:53:53 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CB8CDB3E637D25ED0F96;
        Mon, 16 Sep 2019 13:53:48 +0800 (CST)
Received: from [127.0.0.1] (10.177.29.68) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Mon, 16 Sep 2019
 13:53:47 +0800
Message-ID: <5D7F236B.3070409@huawei.com>
Date:   Mon, 16 Sep 2019 13:53:47 +0800
From:   zhong jiang <zhongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] wlegacy: Remove unneeded variable and make function
 to be void
References: <1568306492-42998-1-git-send-email-zhongjiang@huawei.com> <1568306492-42998-3-git-send-email-zhongjiang@huawei.com> <87h85hh0hb.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87h85hh0hb.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.29.68]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/9/13 1:45, Kalle Valo wrote:
> zhong jiang <zhongjiang@huawei.com> writes:
>
>> il4965_set_tkip_dynamic_key_info  do not need return value to
>> cope with different ases. And change functon return type to void.
>>
>> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
>> ---
>>  drivers/net/wireless/intel/iwlegacy/4965-mac.c | 8 ++------
>>  1 file changed, 2 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
>> index ffb705b..a7bbfe2 100644
>> --- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
>> +++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
>> @@ -3326,12 +3326,11 @@ struct il_mod_params il4965_mod_params = {
>>  	return il_send_add_sta(il, &sta_cmd, CMD_SYNC);
>>  }
>>  
>> -static int
>> +static void
>>  il4965_set_tkip_dynamic_key_info(struct il_priv *il,
>>  				 struct ieee80211_key_conf *keyconf, u8 sta_id)
>>  {
>>  	unsigned long flags;
>> -	int ret = 0;
>>  	__le16 key_flags = 0;
>>  
>>  	key_flags |= (STA_KEY_FLG_TKIP | STA_KEY_FLG_MAP_KEY_MSK);
>> @@ -3367,8 +3366,6 @@ struct il_mod_params il4965_mod_params = {
>>  	memcpy(il->stations[sta_id].sta.key.key, keyconf->key, 16);
>>  
>>  	spin_unlock_irqrestore(&il->sta_lock, flags);
>> -
>> -	return ret;
>>  }
>>  
>>  void
>> @@ -3483,8 +3480,7 @@ struct il_mod_params il4965_mod_params = {
>>  		    il4965_set_ccmp_dynamic_key_info(il, keyconf, sta_id);
>>  		break;
>>  	case WLAN_CIPHER_SUITE_TKIP:
>> -		ret =
>> -		    il4965_set_tkip_dynamic_key_info(il, keyconf, sta_id);
>> +		il4965_set_tkip_dynamic_key_info(il, keyconf, sta_id);
>>  		break;
>>  	case WLAN_CIPHER_SUITE_WEP40:
>>  	case WLAN_CIPHER_SUITE_WEP104:
> To me this looks inconsistent with the rest of the cases in the switch
> statement. And won't we then return the ret variable uninitalised?
Yep,  I miss that.   please ignore the patch.  Thanks,

Sincerely,
zhong jiang

