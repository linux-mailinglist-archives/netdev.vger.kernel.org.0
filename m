Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10AA22DD28
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 10:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgGZIKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 04:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgGZIKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 04:10:37 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC03C0619D2;
        Sun, 26 Jul 2020 01:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3915KriMet4cte0HTVlxNc6u/33aLWN9iC1lOprRd9k=; b=OvbtUZfBlBi9zcxNPT6puBcmPi
        NZ9G5QMXeTFPYiVuEp1YUlOTE/gi7TQ8PjcwlNV/fY7o6HU290Y7WaCwxUoTmSXOyTmboR+CvZIHP
        LCDDAHffIkM/xzUdjHFcMiT/4g4irEupnb1MqVItpQNqUbiVoAQnV0u5/jGNIJfMZ9U4=;
Received: from p5b206d80.dip0.t-ipconnect.de ([91.32.109.128] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1jzbjc-0007aH-CD; Sun, 26 Jul 2020 10:10:16 +0200
Subject: Re: [RFC 0/7] Add support to process rx packets in thread
To:     Hillf Danton <hdanton@sina.com>
Cc:     David Laight <David.Laight@ACULAB.COM>,
        Andrew Lunn <andrew@lunn.ch>,
        Rakesh Pillai <pillair@codeaurora.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        Markus Elfring <Markus.Elfring@web.de>,
        Ding Zhao Nan <oshack@hotmail.com>,
        "evgreen@chromium.org" <evgreen@chromium.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
 <20200721172514.GT1339445@lunn.ch> <20200725081633.7432-1-hdanton@sina.com>
 <20200726012244.15264-1-hdanton@sina.com>
From:   Felix Fietkau <nbd@nbd.name>
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 xsDiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwc0cRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPsJgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQzsFNBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabwkkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <3ce69fb9-f340-d50d-8e77-61c7210a61c6@nbd.name>
Date:   Sun, 26 Jul 2020 10:10:15 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200726012244.15264-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-26 03:22, Hillf Danton wrote:
>> - add a state bit for threaded NAPI
>> - make netif_threaded_napi_add inline
>> - run queue_work outside of local_irq_save/restore (it does that
>> internally already)
>>
>> If you don't mind, I'd like to propose this to netdev soon. Can I have
>> your Signed-off-by for that?
> 
> Feel free to do that. Is it likely for me to select a Cc?
Shall I use Signed-off-by: Hillf Danton <hdanton@sina.com>?
What Cc do you want me to add?

>> ---
>> --- a/include/linux/netdevice.h
>> +++ b/include/linux/netdevice.h
>> @@ -347,6 +347,7 @@ struct napi_struct {
>>  	struct list_head	dev_list;
>>  	struct hlist_node	napi_hash_node;
>>  	unsigned int		napi_id;
>> +	struct work_struct	work;
>>  };
>>  
>>  enum {
>> @@ -357,6 +358,7 @@ enum {
>>  	NAPI_STATE_HASHED,	/* In NAPI hash (busy polling possible) */
>>  	NAPI_STATE_NO_BUSY_POLL,/* Do not add in napi_hash, no busy polling */
>>  	NAPI_STATE_IN_BUSY_POLL,/* sk_busy_loop() owns this NAPI */
>> +	NAPI_STATE_THREADED,	/* Use threaded NAPI */
>>  };
>>  
>>  enum {
>> @@ -367,6 +369,7 @@ enum {
>>  	NAPIF_STATE_HASHED	 = BIT(NAPI_STATE_HASHED),
>>  	NAPIF_STATE_NO_BUSY_POLL = BIT(NAPI_STATE_NO_BUSY_POLL),
>>  	NAPIF_STATE_IN_BUSY_POLL = BIT(NAPI_STATE_IN_BUSY_POLL),
>> +	NAPIF_STATE_THREADED	 = BIT(NAPI_STATE_THREADED),
>>  };
>>  
>>  enum gro_result {
>> @@ -2315,6 +2318,26 @@ static inline void *netdev_priv(const struct net_device *dev)
>>  void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>>  		    int (*poll)(struct napi_struct *, int), int weight);
>>  
>> +/**
>> + *	netif_threaded_napi_add - initialize a NAPI context
>> + *	@dev:  network device
>> + *	@napi: NAPI context
>> + *	@poll: polling function
>> + *	@weight: default weight
>> + *
>> + * This variant of netif_napi_add() should be used from drivers using NAPI
>> + * with CPU intensive poll functions.
>> + * This will schedule polling from a high priority workqueue that
>> + */
>> +static inline void netif_threaded_napi_add(struct net_device *dev,
>> +					   struct napi_struct *napi,
>> +					   int (*poll)(struct napi_struct *, int),
>> +					   int weight)
>> +{
>> +	set_bit(NAPI_STATE_THREADED, &napi->state);
>> +	netif_napi_add(dev, napi, poll, weight);
>> +}
>> +
>>  /**
>>   *	netif_tx_napi_add - initialize a NAPI context
>>   *	@dev:  network device
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -158,6 +158,7 @@ static DEFINE_SPINLOCK(offload_lock);
>>  struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
>>  struct list_head ptype_all __read_mostly;	/* Taps */
>>  static struct list_head offload_base __read_mostly;
>> +static struct workqueue_struct *napi_workq;
> 
> Is __read_mostly missing?
Yes, thanks. I will add that before sending the patch.

- Felix
