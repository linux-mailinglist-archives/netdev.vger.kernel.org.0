Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E958C4ADCB1
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 16:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380458AbiBHPcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 10:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235109AbiBHPcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 10:32:16 -0500
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2002::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B917C061576;
        Tue,  8 Feb 2022 07:32:15 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1644334333; bh=wgBzt5vK3cFN8FMnyCpL9e4AgZNfJRkAyZy5pNQF5Y8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=SDtmhTSuRrLIi0rBu2TtRfajchoprAs5Y921ThZLf60QXQWj6C62Z5d3CntC9fB8Y
         ez/6QuDAttYFRjncVb18h5leoNYSIKF36l4hIHnk0J88KgCvWwFD6tjAuTSGcS67fq
         KgxpwbYrlF0bYZJyz4sRLqrY0/AWc5OOOR41hFO7tBxRgfaBOG50spbTS16HvvZISB
         OfOpaj5w6vLOhL2ndpQwatDM2xZvXdeHDQAL4mzNzU7krdAzhVE8HgMv+kAuZNBseT
         btlWIBr5CH4FAUjEDGuNNOxcV4COjwF9Y3PB43j2h8/q5b8xTUiyCSq23x7nMrHLK1
         O5SZLzArGhTxw==
To:     Jeff Johnson <quic_jjohnson@quicinc.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        ath9k-devel@qca.qualcomm.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, linville@tuxdriver.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ath9k: htc: clean up *STAT_* macros
In-Reply-To: <258ac12b-9ca3-9b24-30df-148f9df51582@quicinc.com>
References: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
 <28c83b99b8fea0115ad7fbda7cc93a86468ec50d.1644265120.git.paskripkin@gmail.com>
 <258ac12b-9ca3-9b24-30df-148f9df51582@quicinc.com>
Date:   Tue, 08 Feb 2022 16:32:13 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87ee4d9xxe.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jeff Johnson <quic_jjohnson@quicinc.com> writes:

> On 2/7/2022 12:24 PM, Pavel Skripkin wrote:
>> I've changed *STAT_* macros a bit in previous patch and I seems like
>> they become really unreadable. Align these macros definitions to make
>> code cleaner.
>> 
>> Also fixed following checkpatch warning
>> 
>> ERROR: Macros with complex values should be enclosed in parentheses
>> 
>> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
>> ---
>> 
>> Changes since v2:
>> 	- My send-email script forgot, that mailing lists exist.
>> 	  Added back all related lists
>> 	- Fixed checkpatch warning
>> 
>> Changes since v1:
>> 	- Added this patch
>> 
>> ---
>>   drivers/net/wireless/ath/ath9k/htc.h | 16 ++++++++--------
>>   1 file changed, 8 insertions(+), 8 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
>> index 141642e5e00d..b4755e21a501 100644
>> --- a/drivers/net/wireless/ath/ath9k/htc.h
>> +++ b/drivers/net/wireless/ath/ath9k/htc.h
>> @@ -327,14 +327,14 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
>>   }
>>   
>>   #ifdef CONFIG_ATH9K_HTC_DEBUGFS
>> -#define __STAT_SAVE(expr) (hif_dev->htc_handle->drv_priv ? (expr) : 0)
>> -#define TX_STAT_INC(c) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
>> -#define TX_STAT_ADD(c, a) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
>> -#define RX_STAT_INC(c) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
>> -#define RX_STAT_ADD(c, a) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
>> -#define CAB_STAT_INC   priv->debug.tx_stats.cab_queued++
>> -
>> -#define TX_QSTAT_INC(q) (priv->debug.tx_stats.queue_stats[q]++)
>> +#define __STAT_SAVE(expr)	(hif_dev->htc_handle->drv_priv ? (expr) : 0)
>> +#define TX_STAT_INC(c)		__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
>> +#define TX_STAT_ADD(c, a)	__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
>> +#define RX_STAT_INC(c)		__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
>> +#define RX_STAT_ADD(c, a)	__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
>> +#define CAB_STAT_INC		(priv->debug.tx_stats.cab_queued++)
>> +
>> +#define TX_QSTAT_INC(q)		(priv->debug.tx_stats.queue_stats[q]++)
>>   
>>   void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
>>   			   struct ath_rx_status *rs);
>
> It seems that these macros (both the original and the new) aren't 
> following the guidance from the Coding Style which tells us under 
> "Things to avoid when using macros" that we should avoid "macros that 
> depend on having a local variable with a magic name". Wouldn't these 
> macros be "better" is they included the hif_dev/priv as arguments rather 
> than being "magic"?

Hmm, yeah, that's a good point; looks like the non-HTC ath9k stats
macros have already been converted to take the container as a parameter,
so taking this opportunity to fix these macros is not a bad idea. While
we're at it, let's switch to the do{} while(0) syntax the other macros
are using instead of that weird usage of ?:. And there's not really any
reason for the duplication between ADD/INC either. So I'm thinking
something like:

#define __STAT_SAVE(_priv, _member, _n) do { if (_priv) (_priv)->_member += (_n); } while(0)

#define TX_STAT_ADD(_priv, _c, _a) __STAT_SAVE(_priv, debug.tx_stats._c, _a)
#define TX_STAT_INC(_priv, _c) TX_STAT_ADD(_priv, _c, 1)

[... etc ...]

-Toke
