Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5966F6C2B8A
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 08:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjCUHl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 03:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbjCUHlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 03:41:20 -0400
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [20.232.28.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DAD413CE32;
        Tue, 21 Mar 2023 00:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=buaa.edu.cn; s=buaa; h=Received:Subject:To:Cc:References:From:
        Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:Content-Type:
        Content-Transfer-Encoding:Content-Language; bh=j20vTDU+hGLHvoez0
        N0ROxd3wPjt36wTxMiLv6GIuq0=; b=zHTDva2poavGnLgNE8Wsxsl7EkkJzRxPl
        Pq1oW58a5oPiv6LfC0Kup85WpDTuLoGHv73yWKZF2oiq6VjqEdBzs+I0H+Re7/69
        SHeiyzHl82DPQIPAsGXOUsHjXslJMibGF6rc96fdBy0nK67nTvoEP39XZU2xv1mI
        QzAuT2gXWY=
Received: from [192.168.1.101] (unknown [106.39.42.159])
        by coremail-app2 (Coremail) with SMTP id Nyz+CgDHsWB1Xxlk2EQiAA--.53854S3;
        Tue, 21 Mar 2023 15:40:37 +0800 (CST)
Subject: Re: [PATCH] net: mac80211: Add NULL checks for sta->sdata
To:     Simon Horman <simon.horman@corigine.com>
Cc:     johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <ZBiOhAJswYcAo8kv@corigine.com>
From:   Jia-Ju Bai <baijiaju@buaa.edu.cn>
Message-ID: <9b213efb-8c7a-497d-2e08-f404d174a6ae@buaa.edu.cn>
Date:   Tue, 21 Mar 2023 15:40:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0
MIME-Version: 1.0
In-Reply-To: <ZBiOhAJswYcAo8kv@corigine.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID: Nyz+CgDHsWB1Xxlk2EQiAA--.53854S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuF4xKF47Jw18KrW3Xr45Awb_yoW5Gr48p3
        4kCw4SqFs8J342yr4xKFn5uFWjvFWDJry8Wr9xGFy7WFn0gFnakr4I9FWrZ3ZY9Fy5J3Wa
        vF4jvrZIqanrua7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvCb7Iv0xC_Cr1lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
        cIk0rVWUuVWrJwAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
        AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
        6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI
        0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
        Yx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbV
        WUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vIY487MxkIecxEwVAFwVW8CwCF
        04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26F1DJr1UJwCFx2IqxVCFs4IE7xkEbV
        WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
        67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
        IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
        0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
        nxnUUI43ZEXa7IU8sYFJUUUUU==
X-CM-SenderInfo: yrruji46exttoohg3hdfq/
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Simon,

Thanks for the reply!


On 2023/3/21 0:49, Simon Horman wrote:
> On Mon, Mar 20, 2023 at 09:35:33PM +0800, Jia-Ju Bai wrote:
>> In a previous commit 69403bad97aa, sta->sdata can be NULL, and thus it
>> should be checked before being used.
> Please run checkpatch on this patch, and correct the commit description
> style.
>
> ./scripts/checkpatch.pl -g HEAD
> ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 69403bad97aa ("wifi: mac80211: sdata can be NULL during AMPDU start")'
> #6:
> In a previous commit 69403bad97aa, sta->sdata can be NULL, and thus it

Okay, I will revise it and run checkpatch.

>
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
> I wonder if it would be better to teach ht_* do do nothing
> if the first argument is NULL.

Okay, I will use this way in patch v2.

>
> Also, are these theoretical bugs?
> Or something that has been observed?
> And has a reproducer?

These bugs are found by my static analysis tool, by extending a known 
bug fixed in a previous commit 69403bad97aa.
Thus, they could be theoretical bugs.

>
>> Thus, to avoid possible null-pointer dereferences, the related checks
>> should be added.
>>
>> These results are reported by a static tool designed by myself.
>>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>> Reported-by: TOTE Robot <baijiaju@buaa.edu.cn>
> I see 4 copies of this patch in a few minutes.
> As per the FAQ [1], please leave at least 24h between posts of a patch.
>
> [1] https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html

I am quite sorry for this, because my script of git send email was buggy.
I noticed this problem after sending the e-mail, and now I have fixed it :)


Best wishes,
Jia-Ju Bai

