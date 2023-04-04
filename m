Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFF76D5C7E
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 11:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbjDDJ6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 05:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233811AbjDDJ6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 05:58:34 -0400
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [20.232.28.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A279819AE;
        Tue,  4 Apr 2023 02:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=buaa.edu.cn; s=buaa; h=Received:Subject:To:Cc:References:From:
        Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:Content-Type:
        Content-Transfer-Encoding:Content-Language; bh=da+9B3dO4N64/X93i
        viw9y205qmZYA8m+wN8DpKVXss=; b=2c2MgQ7oa3RZaCEawEf8T2HeaRt5cSvYl
        bDEpXcEO0C8f4G+TQkpcK3AVDexc++0DVnjl+7Jx1KZlKpTMdi04hZV8QGYeOOz9
        xg80qF/s5apOMTJPECX1lP4KTxrxyXrB8m8g7XzIcKm0Wu7K+PoUcjl7n+rVJzZy
        jhmC900vXg=
Received: from [192.168.1.106] (unknown [10.130.159.144])
        by coremail-app1 (Coremail) with SMTP id OCz+CgCnh5Sz9CtkRG4aAw--.18976S3;
        Tue, 04 Apr 2023 17:58:11 +0800 (CST)
Subject: Re: [PATCH v2] net: mac80211: Add NULL checks for sta->sdata
To:     Simon Horman <simon.horman@corigine.com>
Cc:     johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <ZCBfHlOhU8LjdRg3@corigine.com>
From:   Jia-Ju Bai <baijiaju@buaa.edu.cn>
Message-ID: <f70554b9-eedf-43e4-9a55-a809e9b9e89a@buaa.edu.cn>
Date:   Tue, 4 Apr 2023 17:58:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0
MIME-Version: 1.0
In-Reply-To: <ZCBfHlOhU8LjdRg3@corigine.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: OCz+CgCnh5Sz9CtkRG4aAw--.18976S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtr4xAw4DXr1kAw1Uur17Jrb_yoW7Ar47pr
        Z5G3WaqFWUJa4xXr1fJr1Y9FyFvw48Kr18Ar1fCF1xA3ZY9FnYkF4v9rW8ZF9YkrWUJ3WS
        vFWj939xua1qkrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvmb7Iv0xC_tr1lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
        cIk0rVWUuVWrJwAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
        AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
        6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI
        0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
        Yx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbV
        WUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vIY487MxkIecxEwVCm-wCF04k2
        0xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26F1DJr1UJwCFx2IqxVCFs4IE7xkEbVWUJV
        W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
        1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
        IIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
        x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnU
        UI43ZEXa7IU8489tUUUUU==
X-CM-SenderInfo: yrruji46exttoohg3hdfq/
X-Spam-Status: No, score=-2.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon,

Thanks for your reply, and sorry for the delay.

On 2023/3/26 23:05, Simon Horman wrote:
> On Tue, Mar 21, 2023 at 05:31:22PM +0800, Jia-Ju Bai wrote:
>> In a previous commit 69403bad97aa ("wifi: mac80211: sdata can be NULL
>> during AMPDU start"), sta->sdata can be NULL, and thus it should be
>> checked before being used.
>>
>> However, in the same call stack, sta->sdata is also used in the
>> following functions:
>>
>> ieee80211_ba_session_work()
>>    ___ieee80211_stop_rx_ba_session(sta)
>>      ht_dbg(sta->sdata, ...); -> No check
>>      sdata_info(sta->sdata, ...); -> No check
>>      ieee80211_send_delba(sta->sdata, ...) -> No check
>>    ___ieee80211_start_rx_ba_session(sta)
>>      ht_dbg(sta->sdata, ...); -> No check
>>      ht_dbg_ratelimited(sta->sdata, ...); -> No check
>>    ieee80211_tx_ba_session_handle_start(sta)
>>      sdata = sta->sdata; if (!sdata) -> Add check by previous commit
>>    ___ieee80211_stop_tx_ba_session(sdata)
>>      ht_dbg(sta->sdata, ...); -> No check
>>    ieee80211_start_tx_ba_cb(sdata)
>>      sdata = sta->sdata; local = sdata->local -> No check
>>    ieee80211_stop_tx_ba_cb(sdata)
>>      ht_dbg(sta->sdata, ...); -> No check
>>
>> Thus, to avoid possible null-pointer dereferences, the related checks
>> should be added.
>>
>> These bugs are reported by a static analysis tool implemented by myself,
>> and they are found by extending a known bug fixed in the previous commit.
>> Thus, they could be theoretical bugs.
>>
>> Signed-off-by: Jia-Ju Bai <baijiaju@buaa.edu.cn>
>> ---
>> v2:
>> * Fix an error reported by checkpatch.pl, and make the bug finding
>>    process more clear in the description. Thanks for Simon's advice.
>> ---
>>   net/mac80211/agg-rx.c | 68 ++++++++++++++++++++++++++-----------------
>>   net/mac80211/agg-tx.c | 16 ++++++++--
>>   2 files changed, 55 insertions(+), 29 deletions(-)
>>
>> diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
>> index c6fa53230450..6616970785a2 100644
>> --- a/net/mac80211/agg-rx.c
>> +++ b/net/mac80211/agg-rx.c
>> @@ -80,19 +80,21 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
>>   	RCU_INIT_POINTER(sta->ampdu_mlme.tid_rx[tid], NULL);
>>   	__clear_bit(tid, sta->ampdu_mlme.agg_session_valid);
>>   
>> -	ht_dbg(sta->sdata,
>> -	       "Rx BA session stop requested for %pM tid %u %s reason: %d\n", > -	       sta->sta.addr, tid,
>> -	       initiator == WLAN_BACK_RECIPIENT ? "recipient" : "initiator",
>> -	       (int)reason);
>> +	if (sta->sdata) {
>> +		ht_dbg(sta->sdata,
>> +		       "Rx BA session stop requested for %pM tid %u %s reason: %d\n",
>> +		       sta->sta.addr, tid,
>> +		       initiator == WLAN_BACK_RECIPIENT ? "recipient" : "initiator",
>> +		       (int)reason);
>> +	}
> The first line of the body of ___ieee80211_stop_rx_ba_session() is:
>
> 	struct ieee80211_local *local = sta->sdata->local;
>
> So a NULL pointer dereference will have occurred before
> the checks this change adds to that function.

I checked the source code again (including the latest version 6.3-rc5).
The first line of the body of ___ieee80211_stop_rx_ba_session() is:

     struct ieee80211_local *local = sta->local;

Thus, there is no dereference of sta->sdata.

In a different function, namely ___ieee80211_start_rx_ba_session(), the 
first line is:

     struct ieee80211_local *local = sta->sdata->local;

Thus, there should be a NULL check for sta->sdata in this function.
I will add this in my patch v3.

>
>
>>   
>> -	if (drv_ampdu_action(local, sta->sdata, &params))
>> +	if (sta->sdata && drv_ampdu_action(local, sta->sdata, &params))
>>   		sdata_info(sta->sdata,
>>   			   "HW problem - can not stop rx aggregation for %pM tid %d\n",
>>   			   sta->sta.addr, tid);
>>   
> ...
>
>> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
>> index f9514bacbd4a..03b31b6e7ac7 100644
>> --- a/net/mac80211/agg-tx.c
>> +++ b/net/mac80211/agg-tx.c
>> @@ -368,8 +368,10 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
>>   
>>   	spin_unlock_bh(&sta->lock);
>>   
>> -	ht_dbg(sta->sdata, "Tx BA session stop requested for %pM tid %u\n",
>> -	       sta->sta.addr, tid);
>> +	if (sta->sdata) {
>> +		ht_dbg(sta->sdata, "Tx BA session stop requested for %pM tid %u\n",
>> +		       sta->sta.addr, tid);
>> +	}
> This seems clean :)
>
>>   	del_timer_sync(&tid_tx->addba_resp_timer);
>>   	del_timer_sync(&tid_tx->session_timer);
>> @@ -776,7 +778,12 @@ void ieee80211_start_tx_ba_cb(struct sta_info *sta, int tid,
>>   			      struct tid_ampdu_tx *tid_tx)
>>   {
>>   	struct ieee80211_sub_if_data *sdata = sta->sdata;
>> -	struct ieee80211_local *local = sdata->local;
>> +	struct ieee80211_local *local;
>> +
>> +	if (!sdata)
>> +		return;
> I'm not sure that silently ignoring non-existent sdata is the right approach.
> Perhaps a WARN_ON or WARN_ONCE is appropriate?

Okay, I will use WARN_ON  in my patch v3.

>
>> +
>> +	local = sdata->local;
>>   
>>   	if (WARN_ON(test_and_set_bit(HT_AGG_STATE_DRV_READY, &tid_tx->state)))
>>   		return;
>> @@ -902,6 +909,9 @@ void ieee80211_stop_tx_ba_cb(struct sta_info *sta, int tid,
>>   	bool send_delba = false;
>>   	bool start_txq = false;
>>   
>> +	if (!sdata)
>> +		return;
>> +
> Ditto.

Okay, I will use WARN_ON  in my patch v3.

>
>>   	ht_dbg(sdata, "Stopping Tx BA session for %pM tid %d\n",
>>   	       sta->sta.addr, tid);
>>   


Best wishes,
Jia-Ju Bai

