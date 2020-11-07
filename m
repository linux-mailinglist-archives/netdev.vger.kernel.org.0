Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71012AA1F7
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 02:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgKGBRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 20:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbgKGBRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 20:17:21 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87580C0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 17:17:19 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id c20so3079688pfr.8
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 17:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=9e3g3AOxSGRXtlBNKMRt9yT8I0o3V8bAX9ErKz5h17I=;
        b=Ubh8USTgrjJvxQ23kZXpLX+lyXQ+/fywazjuNzpk5meado1eTPYb/05bAgTL1gJ26v
         wM1rziC3+dTL67ZPqyTq6Qyg0U8pP7hgFXxHGu3ARxMbQLdSv+sE0RGzpv0MERgLDGvg
         ig8soRBiFiy/hxP0Mq+DaI7f3aDRMfYJEvDrGHHrZztYFCifNn0OqsZ4Mvn4s0GqYT7D
         6rSiY4przYMXZZEuyc+9kCFTxz99c9s8pk2pDxQlJHaBianBJDUZZ3DOVrkZaqph9/IU
         QbjOQFg2ATcsad/cULbZMovGsCauDAGgIrekJjvSdBPzhuwPisOiNyT4FLi0Fej6HAxN
         UhRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=9e3g3AOxSGRXtlBNKMRt9yT8I0o3V8bAX9ErKz5h17I=;
        b=WN358bMJTa3Ep8OPeSsikgZOg26Evt3BK1sEqMwpbVDZgXUD3vkaTALWaAC8f5fOj7
         p+rFwhhsG+QTk2VbaaSvP2ipKMfnEUiRruzreIQH2vPayFRrXgPz9nUhbx/GjXfeU+Kp
         L0CJjQKX2T0bwIVqZ3LFCcsQZpvEJa57BmgQavL//0i+oBQ7s9En0XNXt2Up4Ey7iCyM
         edYyLTzBZqRJGluio05Rslfod6CttBjcs/6SSMEcGnNlO5wlqqL9Ufmct1kRi5TOealc
         KfQ6GGVsl0DOLSJq2CXCAZ9DrZAQLGSQ1g7O8EzCiUN3rO12RZpuE1F8Xku9YWv79SKs
         HpIw==
X-Gm-Message-State: AOAM531xvBeYLoc1Cj6xVXemsT1yJOPxFgsfcH4CpyPPtZiKQ/PDgihs
        9Sn2nOHYR23pMwq4dgSRWaM7Qw==
X-Google-Smtp-Source: ABdhPJynxc7CrcvSCcgvqQJTNhdcxGn2aevW6uDSwEhp1VHC+XoTMqRUQ4kBgBbgNOEGxjNhoQN8zQ==
X-Received: by 2002:a17:90a:80c6:: with SMTP id k6mr2334081pjw.73.1604711838934;
        Fri, 06 Nov 2020 17:17:18 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id f4sm4051143pjs.8.2020.11.06.17.17.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 17:17:18 -0800 (PST)
Subject: Re: [PATCH v2 net-next 6/8] ionic: flatten calls to ionic_lif_rx_mode
To:     Saeed Mahameed <saeed@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
References: <20201106001220.68130-1-snelson@pensando.io>
 <20201106001220.68130-7-snelson@pensando.io>
 <5cf579a6b137b569b5f01871561f83ca2e9ac659.camel@kernel.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <6ebe62b9-b5ea-0241-acaa-c43def591683@pensando.io>
Date:   Fri, 6 Nov 2020 17:17:49 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <5cf579a6b137b569b5f01871561f83ca2e9ac659.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/6/20 1:33 PM, Saeed Mahameed wrote:
> On Thu, 2020-11-05 at 16:12 -0800, Shannon Nelson wrote:
>> The _ionic_lif_rx_mode() is only used once and really doesn't
>> need to be broken out.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   .../net/ethernet/pensando/ionic/ionic_lif.c   | 38 ++++++++---------
>> --
>>   1 file changed, 16 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> index a0d26fe4cbc3..ef092ee33e59 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> @@ -1129,29 +1129,10 @@ static void ionic_lif_rx_mode(struct
>> ionic_lif *lif, unsigned int rx_mode)
>>   		lif->rx_mode = rx_mode;
>>   }
>>   
>> -static void _ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int
>> rx_mode,
>> -			       bool from_ndo)
>> -{
>> -	struct ionic_deferred_work *work;
>> -
>> -	if (from_ndo) {
>> -		work = kzalloc(sizeof(*work), GFP_ATOMIC);
>> -		if (!work) {
>> -			netdev_err(lif->netdev, "%s OOM\n", __func__);
>> -			return;
>> -		}
>> -		work->type = IONIC_DW_TYPE_RX_MODE;
>> -		work->rx_mode = rx_mode;
>> -		netdev_dbg(lif->netdev, "deferred: rx_mode\n");
>> -		ionic_lif_deferred_enqueue(&lif->deferred, work);
>> -	} else {
>> -		ionic_lif_rx_mode(lif, rx_mode);
>> -	}
>> -}
>> -
>>   static void ionic_set_rx_mode(struct net_device *netdev, bool
>> from_ndo)
>>   {
>>   	struct ionic_lif *lif = netdev_priv(netdev);
>> +	struct ionic_deferred_work *work;
>>   	unsigned int nfilters;
>>   	unsigned int rx_mode;
>>   
>> @@ -1197,8 +1178,21 @@ static void ionic_set_rx_mode(struct
>> net_device *netdev, bool from_ndo)
>>   			rx_mode &= ~IONIC_RX_MODE_F_ALLMULTI;
>>   	}
>>   
>> -	if (lif->rx_mode != rx_mode)
>> -		_ionic_lif_rx_mode(lif, rx_mode, from_ndo);
>> +	if (lif->rx_mode != rx_mode) {
>> +		if (from_ndo) {
>> +			work = kzalloc(sizeof(*work), GFP_ATOMIC);
>> +			if (!work) {
>> +				netdev_err(lif->netdev, "%s OOM\n",
>> __func__);
>> +				return;
>> +			}
>> +			work->type = IONIC_DW_TYPE_RX_MODE;
>> +			work->rx_mode = rx_mode;
>> +			netdev_dbg(lif->netdev, "deferred: rx_mode\n");
>> +			ionic_lif_deferred_enqueue(&lif->deferred,
>> work);
>> +		} else {
>> +			ionic_lif_rx_mode(lif, rx_mode);
>> +		}
>> +	}
>>   }
> You could move this logic one level up and totally eliminate the if
> condition
>
> ionic_set_rx_mode_needed() {
>        //sync driver data base
>        return lif->rx_mode != rx_mode;
> }
>
> ndo_set_rx_mode() {
>        if (!ionic_set_rx_mode_needed())
>              return; // no change;
>        schedule_work(set_rx_mode_hw);
> }
>
> none_ndo_set_rx_mode() {
>        if (!ionic_set_rx_mode_needed())
>              return; // no change;
>        set_rx_mode_hw();
> }

Hmm... yes, that's possible, but I like keeping that bit of logic 
together with the rest in the main set_rx_mode block.

> Future improvement:
>
> One more thing I've noticed about you current ionic_set_rx_mode()
> is that in case of from_ndo, when it syncs mac addresses it will
> schedule a deferred mac address update work to hw per address. which i
> think is an overkill,

This is much less of an issue with the recent change in 
ionic_lif_deferred_work() to run through the whole work list in one 
deferred_work session.

sln

> a simpler design which will totally eliminate the
> need for from_ndo flags, is to do similar to the above but with a minor
> change.
>
> ionic_set_rx_mode_needed() {
>        // Just sync driver mac table here and update hw later
>        // in one deferred work rather than scheduling multi work
>        addr_changed = ionic_dev_uc_sync();
>        addr_changed |= ionic_dev_mc_sync();
>        rx_mode_changed = sync_driver_rx_mode(rx_mode);
>
>        return rx_mode_changed || addr_changed;
> }
>
> /* might sleep */
> set_rx_mode_hw() {
>        commit_addr_change_to_hw();
>        commit_rx_mode_changes_to_hw();
> }
>
> ndo_set_rx_mode() {
>        if (!ionic_set_rx_mode_needed())
>              return; // no change;
>        schedule_work(set_rx_mode_hw);
> }
>
> none_ndo_set_rx_mode() {
>        if (!ionic_set_rx_mode_needed())
>              return; // no change;
>        set_rx_mode_hw();
> }
>

