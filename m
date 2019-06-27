Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47D0C586E3
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 18:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfF0QUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 12:20:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58698 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfF0QUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 12:20:36 -0400
Received: from mail-qt1-f198.google.com ([209.85.160.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <gpiccoli@canonical.com>)
        id 1hgX8S-00042b-UV
        for netdev@vger.kernel.org; Thu, 27 Jun 2019 16:20:33 +0000
Received: by mail-qt1-f198.google.com with SMTP id z6so2916463qtj.7
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 09:20:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=CrGCHfYXg93EdcUNeTyPg36Tk+bmXIjE7JR/IQz0xK8=;
        b=gkYOkoqJe8krXeBj96NNDhB+Mp0lFP8V0hSun0BANRpyjZKwFLTpt58/oGYLYqMjDA
         L0uo+3a3CJ2gs7UyEeqXmnbCILcl/2OxCfsh3yVJJLgdNFpLdkP9rXKGrHh37askSxch
         q85Msug1bGDPFHgUHfqFa5KfNNNNQm1IGc7Ut+6pSSFjZJ9can3mYYY2dAMYJp202izj
         D9hPxtZO+Vy8CLaNtULrCYHv4FBaHg2xwcDY07wn8TH1R0noOtRgXnAvppbA5s/AeaxA
         U0v+dxQY/j6GTkAYs3/eGWvB+fw3SfrYftpCW+PH9yrYUX5FWA48Ia8UAGr7ODszFfL6
         xNwQ==
X-Gm-Message-State: APjAAAW5KwR6UaMLRRU8/iZFNsG21fhH2otg2UnQKk9ew+bZE42WzOxH
        P6PLDGbf6FUd3sFAjePmPsC08fjCLmJFFRb/a0voxyE+VXirkM/OmWvz7vHpdSMAQ7t/HPZpUUh
        rahYRYdP+joo1+hCKjK2gFJH77qb8GthydQ==
X-Received: by 2002:ae9:eb53:: with SMTP id b80mr4171131qkg.172.1561652432122;
        Thu, 27 Jun 2019 09:20:32 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzh2QBZkYqreot6/RL7hK8FZj41j45M1dYCRc99Dt84EnF9qI6onIH97TdLVAxvAPQAl9gKgw==
X-Received: by 2002:ae9:eb53:: with SMTP id b80mr4171104qkg.172.1561652431851;
        Thu, 27 Jun 2019 09:20:31 -0700 (PDT)
Received: from [192.168.1.75] ([179.98.77.238])
        by smtp.gmail.com with ESMTPSA id o54sm1268756qtb.63.2019.06.27.09.20.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 09:20:29 -0700 (PDT)
Subject: Re: [EXT] [PATCH V3] bnx2x: Prevent ptp_task to be rescheduled
 indefinitely
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        "jay.vosburgh@canonical.com" <jay.vosburgh@canonical.com>
References: <20190626201835.31660-1-gpiccoli@canonical.com>
 <MN2PR18MB2528E0CB660FC35C475816E1D3FD0@MN2PR18MB2528.namprd18.prod.outlook.com>
From:   "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Openpgp: preference=signencrypt
Autocrypt: addr=gpiccoli@canonical.com; prefer-encrypt=mutual; keydata=
 mQENBFpVBxcBCADPNKmu2iNKLepiv8+Ssx7+fVR8lrL7cvakMNFPXsXk+f0Bgq9NazNKWJIn
 Qxpa1iEWTZcLS8ikjatHMECJJqWlt2YcjU5MGbH1mZh+bT3RxrJRhxONz5e5YILyNp7jX+Vh
 30rhj3J0vdrlIhPS8/bAt5tvTb3ceWEic9mWZMsosPavsKVcLIO6iZFlzXVu2WJ9cov8eQM/
 irIgzvmFEcRyiQ4K+XUhuA0ccGwgvoJv4/GWVPJFHfMX9+dat0Ev8HQEbN/mko/bUS4Wprdv
 7HR5tP9efSLucnsVzay0O6niZ61e5c97oUa9bdqHyApkCnGgKCpg7OZqLMM9Y3EcdMIJABEB
 AAG0LUd1aWxoZXJtZSBHLiBQaWNjb2xpIDxncGljY29saUBjYW5vbmljYWwuY29tPokBNwQT
 AQgAIQUCWmClvQIbAwULCQgHAgYVCAkKCwIEFgIDAQIeAQIXgAAKCRDOR5EF9K/7Gza3B/9d
 5yczvEwvlh6ksYq+juyuElLvNwMFuyMPsvMfP38UslU8S3lf+ETukN1S8XVdeq9yscwtsRW/
 4YoUwHinJGRovqy8gFlm3SAtjfdqysgJqUJwBmOtcsHkmvFXJmPPGVoH9rMCUr9s6VDPox8f
 q2W5M7XE9YpsfchS/0fMn+DenhQpV3W6pbLtuDvH/81GKrhxO8whSEkByZbbc+mqRhUSTdN3
 iMpRL0sULKPVYbVMbQEAnfJJ1LDkPqlTikAgt3peP7AaSpGs1e3pFzSEEW1VD2jIUmmDku0D
 LmTHRl4t9KpbU/H2/OPZkrm7809QovJGRAxjLLPcYOAP7DUeltveuQENBFpVBxcBCADbxD6J
 aNw/KgiSsbx5Sv8nNqO1ObTjhDR1wJw+02Bar9DGuFvx5/qs3ArSZkl8qX0X9Vhptk8rYnkn
 pfcrtPBYLoux8zmrGPA5vRgK2ItvSc0WN31YR/6nqnMfeC4CumFa/yLl26uzHJa5RYYQ47jg
 kZPehpc7IqEQ5IKy6cCKjgAkuvM1rDP1kWQ9noVhTUFr2SYVTT/WBHqUWorjhu57/OREo+Tl
 nxI1KrnmW0DbF52tYoHLt85dK10HQrV35OEFXuz0QPSNrYJT0CZHpUprkUxrupDgkM+2F5LI
 bIcaIQ4uDMWRyHpDbczQtmTke0x41AeIND3GUc+PQ4hWGp9XABEBAAGJAR8EGAEIAAkFAlpV
 BxcCGwwACgkQzkeRBfSv+xv1wwgAj39/45O3eHN5pK0XMyiRF4ihH9p1+8JVfBoSQw7AJ6oU
 1Hoa+sZnlag/l2GTjC8dfEGNoZd3aRxqfkTrpu2TcfT6jIAsxGjnu+fUCoRNZzmjvRziw3T8
 egSPz+GbNXrTXB8g/nc9mqHPPprOiVHDSK8aGoBqkQAPZDjUtRwVx112wtaQwArT2+bDbb/Y
 Yh6gTrYoRYHo6FuQl5YsHop/fmTahpTx11IMjuh6IJQ+lvdpdfYJ6hmAZ9kiVszDF6pGFVkY
 kHWtnE2Aa5qkxnA2HoFpqFifNWn5TyvJFpyqwVhVI8XYtXyVHub/WbXLWQwSJA4OHmqU8gDl
 X18zwLgdiQ==
Message-ID: <4aaa2e33-5847-88e8-ff73-d30aca8d4872@canonical.com>
Date:   Thu, 27 Jun 2019 13:20:25 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <MN2PR18MB2528E0CB660FC35C475816E1D3FD0@MN2PR18MB2528.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks again Sudarsana for the good review and advice. I'll send V4 soon.
Discussions about your points are in-line below:


On 27/06/2019 07:09, Sudarsana Reddy Kalluru wrote:
> 
>> [...]
>>  	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
>>  		if (!(bp->flags & TX_TIMESTAMPING_EN)) {
>> -			BNX2X_ERR("Tx timestamping was not enabled, this
>> packet will not be timestamped\n");
>> +			bp->eth_stats.ptp_skip_tx_ts++;
>> +			netdev_err_once(bp->dev,
>> +					"Tx timestamping isn't enabled, this
>> packet won't be timestamped\n");
>> +			DP(BNX2X_MSG_PTP,
>> +			   "Tx timestamping isn't enabled, this packet won't
>> be
>> +timestamped\n");
> 
> Hitting this path is very unlikely and also PTP packets arrive once in a second in general.
> Either retain BNX2X_ERR() statement or remove the extra call netdev_err_once().

Agreed, I retained BNX2X_ERR().


> 
>>  		} else if (bp->ptp_tx_skb) {
>> -			BNX2X_ERR("The device supports only a single
>> outstanding packet to timestamp, this packet will not be timestamped\n");
>> +			bp->eth_stats.ptp_skip_tx_ts++;
>> +			netdev_err_once(bp->dev,
>> +					"Device supports only a single
>> outstanding packet to timestamp, this packet won't be timestamped\n");
>> +			DP(BNX2X_MSG_PTP,
>> +			   "Device supports only a single outstanding packet to
>> timestamp,
>> +this packet won't be timestamped\n");
> Same as above.

Now this one I disagree - it's easy to have kernel log flooded by these
messages if, for instance, you reproduce the bug I'm trying to fix.
Even with my patch, the register value is 0x0 in TX timestamping read,
so this is likely to keep showing in the kernel, and may cause a
somewhat quick log rotation depending on user configuration.

For this one, I've removed the debug statement, but kept netdev_err_once
to warn users that something is wrong without slowly flood their logs.
If the users want more detail, they just need to enable debug level
logging in bnx2x. Makes sense to you?


>>  		} else {
>>  			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
>>  			/* schedule check for Tx timestamp */ diff --git
>> a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
>> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
>> index 51fc845de31a..4a0ba6801c9e 100644
>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
>> @@ -182,7 +182,9 @@ static const struct {
>>  	{ STATS_OFFSET32(driver_filtered_tx_pkt),
>>  				4, false, "driver_filtered_tx_pkt" },
>>  	{ STATS_OFFSET32(eee_tx_lpi),
>> -				4, true, "Tx LPI entry count"}
>> +				4, true, "Tx LPI entry count"},
>> +	{ STATS_OFFSET32(ptp_skip_tx_ts),
>> +				4, false, "ptp_skipped_tx_tstamp" },
>>  };
>>
>>  #define BNX2X_NUM_STATS		ARRAY_SIZE(bnx2x_stats_arr)
>> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
>> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
>> index 03ac10b1cd1e..af6e7a950a28 100644
>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
>> @@ -15214,11 +15214,27 @@ static void bnx2x_ptp_task(struct work_struct
>> *work)
>>  	u32 val_seq;
>>  	u64 timestamp, ns;
>>  	struct skb_shared_hwtstamps shhwtstamps;
>> +	bool bail = true;
>> +	int i;
>>
>> -	/* Read Tx timestamp registers */
>> -	val_seq = REG_RD(bp, port ? NIG_REG_P1_TLLH_PTP_BUF_SEQID :
>> -			 NIG_REG_P0_TLLH_PTP_BUF_SEQID);
>> -	if (val_seq & 0x10000) {
>> +	/* FW may take a while to complete timestamping; try a bit and if it's
>> +	 * still not complete, may indicate an error state - bail out then.
>> +	 */
>> +	for (i = 0; i < 10; i++) {
>> +		/* Read Tx timestamp registers */
>> +		val_seq = REG_RD(bp, port ?
>> NIG_REG_P1_TLLH_PTP_BUF_SEQID :
>> +				 NIG_REG_P0_TLLH_PTP_BUF_SEQID);
>> +		if (val_seq & 0x10000) {
>> +			bail = false;
>> +			break;
>> +		}
>> +
>> +		if (!(i % 4)) /* Avoid log flood */
>> +			DP(BNX2X_MSG_PTP, "There's no valid Tx timestamp
>> yet\n");
> This debug statement is not required as we anyway capture it in the error path below.
> 

Ack, removed.


>> +		msleep(1 << i);
>> +	}
>> +
>> +	if (!bail) {
>>  		/* There is a valid timestamp value */
>>  		timestamp = REG_RD(bp, port ?
>> NIG_REG_P1_TLLH_PTP_BUF_TS_MSB :
>>  				   NIG_REG_P0_TLLH_PTP_BUF_TS_MSB);
>> @@ -15233,16 +15249,18 @@ static void bnx2x_ptp_task(struct work_struct
>> *work)
>>  		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
>>  		shhwtstamps.hwtstamp = ns_to_ktime(ns);
>>  		skb_tstamp_tx(bp->ptp_tx_skb, &shhwtstamps);
>> -		dev_kfree_skb_any(bp->ptp_tx_skb);
>> -		bp->ptp_tx_skb = NULL;
>>
>>  		DP(BNX2X_MSG_PTP, "Tx timestamp, timestamp cycles =
>> %llu, ns = %llu\n",
>>  		   timestamp, ns);
>>  	} else {
>> -		DP(BNX2X_MSG_PTP, "There is no valid Tx timestamp
>> yet\n");
>> -		/* Reschedule to keep checking for a valid timestamp value
>> */
>> -		schedule_work(&bp->ptp_task);
>> +		DP(BNX2X_MSG_PTP,
>> +		   "Tx timestamp is not recorded (register read=%u)\n",
>> +		   val_seq);
>> +		bp->eth_stats.ptp_skip_tx_ts++;
>>  	}
>> +
>> +	dev_kfree_skb_any(bp->ptp_tx_skb);
>> +	bp->ptp_tx_skb = NULL;
>>  }
>>
>>  void bnx2x_set_rx_ts(struct bnx2x *bp, struct sk_buff *skb) diff --git
>> a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
>> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
>> index b2644ed13d06..d55e63692cf3 100644
>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
>> @@ -207,6 +207,9 @@ struct bnx2x_eth_stats {
>>  	u32 driver_filtered_tx_pkt;
>>  	/* src: Clear-on-Read register; Will not survive PMF Migration */
>>  	u32 eee_tx_lpi;
>> +
>> +	/* PTP */
>> +	u32 ptp_skip_tx_ts;
> The value need to be cleared in the case of internal reload e.g., mtu change, ifconfig-down/up.
> If this is not happening, please reset it in the nic load path.

I mostly agree with you here. The stat really needs to be zeroed in
interface reload, and it is, currently.
The path doing this on driver is:

bnx2x_nic_load()
  bnx2x_post_irq_nic_init()
    bnx2x_stats_init()

I've tested that using "ifconfig <iface> down" and then up. The
"ptp_skip_tx_ts" was zeroed. But for example, in MTU change it kept its
value, which I consider right. We don't want a MTU change to clear
stats, in my understanding.
The driver is behaving right IMO, what governs the reset of statistics
is "bp->stats_init", which is set in bnx2x_open(), leading to full stats
reset.

I've checked and the behavior is the same for other statistics like
rx_bytes (both per-queue and accumulated) and tx_*_packets.
If you consider this behavior as wrong we can fix that in another patch,
or if you think for some reason "ptp_skip_tx_ts" should behave
differently from the other statistics, let me know.

Thanks,

Guilherme


> 
>>  };
>>
>>  struct bnx2x_eth_q_stats {
>> --
>> 2.22.0
> 
