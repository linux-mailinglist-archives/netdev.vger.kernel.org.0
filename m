Return-Path: <netdev+bounces-3700-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 772DF7085A6
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:09:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 325D1280E80
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 16:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77DDF23D4E;
	Thu, 18 May 2023 16:09:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B23E53A8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 16:09:00 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D44E10C3
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 09:08:52 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-96aadfb19d7so412504766b.2
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 09:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1684426131; x=1687018131;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iyuoVXRwAkG96IRjsmBXEWPPWLN9VCCign9YtDLx2cU=;
        b=kzLWYsW5n4uheX6EWn13HctN1sZsIT92orviF9/G5tPKzzsBBJlST4z8e52bJTC48D
         wNd4Qs12HRV/ULmxl+RAaayJilGjmHYnw8h2ijZn/tgAEA1DP74dMTDe5tGnHA/o34BF
         SoQDvdckzQxFjgGgv50++7rmnWea9MrZfITdHZyyyHmW/6CGhqJCYJpRsC6mH19znuo5
         3CVGj1dMhIsaUp5RGhbetdD9KrCAyptFYo7OgI5U+K8MSbc0/tGnSQ2x8aZ8O86H+Oak
         5qpCB8JbjUfkAKY4J4NossABK8ME6WuUYbDc5eA+DWk6AVa5sLW7pG9ucqx9MMuuKwb5
         EnCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684426131; x=1687018131;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iyuoVXRwAkG96IRjsmBXEWPPWLN9VCCign9YtDLx2cU=;
        b=gN1ah7pvzXa16r8QQ6QV7jn3b5kIdId6OrbC/Y69UuFk8tzgY6yTCZxaGlBJKHub85
         +NX1mUKtYyPOV2GDAFd8iF5KjsMMUunYIeIbrdZOX0KPKqZD5SsWSbkvOssUZEEl5BN2
         mOtpczjRhJMTOC0YOF/lgIGFoNGWCdpfdx9uBCzi1LhMrZz8xCXPx0Y6mi8JJCoB3RrO
         1dVoWisISaKtxjYJCZhIZDM0qElNdzpLYa+YCwg8zU2ex4LeyyZzDs47BEDlAorA8SYO
         2Biq9ih9Q73dshY36H/deVTuAY2DoBL+MrhXGdthHAKvkRtS+bH2mAyvKpVFWwW0EwNa
         04cA==
X-Gm-Message-State: AC+VfDw1xfOeidzY/9c/B4bCQh3ze86F2P4wYX9QVkJvCeKv8nHAYTyY
	5cExKEb24y7Y/tGM4UVg6GS7567eEu3htD8yzPsIcJvt
X-Google-Smtp-Source: ACHHUZ5d7GREsGn+BiVykYFE9gOPpFrSYkoCOuHyK3u0f9UtxcQmzqZk1SrBy22elWLHH1l8VamFTw==
X-Received: by 2002:a17:906:4792:b0:96a:138:c1a0 with SMTP id cw18-20020a170906479200b0096a0138c1a0mr30986419ejc.9.1684426130604;
        Thu, 18 May 2023 09:08:50 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id gl19-20020a170906e0d300b009663cf5dc43sm1133077ejb.181.2023.05.18.09.08.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 09:08:49 -0700 (PDT)
Message-ID: <1ed139d5-6cb9-90c7-323c-22cf916e96a0@blackwall.org>
Date: Thu, 18 May 2023 19:08:47 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/5] skbuff: bridge: Add layer 2 miss indication
Content-Language: en-US
To: Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
 bridge@lists.linux-foundation.org
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, roopa@nvidia.com, taras.chornyi@plvision.eu,
 saeedm@nvidia.com, leon@kernel.org, petrm@nvidia.com,
 vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
 alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
 jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
 taspelund@nvidia.com
References: <20230518113328.1952135-1-idosch@nvidia.com>
 <20230518113328.1952135-2-idosch@nvidia.com>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230518113328.1952135-2-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 18/05/2023 14:33, Ido Schimmel wrote:
> Allow the bridge driver to mark packets that did not match a layer 2
> entry during forwarding by adding a 'l2_miss' bit to the skb.
> 
> Clear the bit whenever a packet enters the bridge (received from a
> bridge port or transmitted via the bridge) and set it if the packet did
> not match an FDB/MDB entry.
> 
> Subsequent patches will allow the flower classifier to match on this
> bit. The motivating use case in non-DF (Designated Forwarder) filtering
> where we would like to prevent decapsulated packets from being flooded
> to a multi-homed host.
> 
> Do not allocate the bit if the kernel was not compiled with bridge
> support and place it after the two bit fields in accordance with commit
> 4c60d04c2888 ("net: skbuff: push nf_trace down the bitfield"). The bit
> does not increase the size of the structure as it is placed at an
> existing hole. Layout with allmodconfig:
> 
> struct sk_buff {
> [...]
> 			__u8       csum_not_inet:1;      /*   132: 3  1 */
> 			__u8       l2_miss:1;            /*   132: 4  1 */
> 
> 			/* XXX 3 bits hole, try to pack */
> 			/* XXX 1 byte hole, try to pack */
> 
> 			__u16      tc_index;             /*   134     2 */
> 			u16        alloc_cpu;            /*   136     2 */
> [...]
> } __attribute__((__aligned__(8)));
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  include/linux/skbuff.h  | 4 ++++
>  net/bridge/br_device.c  | 1 +
>  net/bridge/br_forward.c | 3 +++
>  net/bridge/br_input.c   | 1 +
>  4 files changed, 9 insertions(+)
> 
[snip]
>  	while (p || rp) {
> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index fc17b9fd93e6..d8ab5890cbe6 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -334,6 +334,7 @@ static rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
>  		return RX_HANDLER_CONSUMED;
>  
>  	memset(skb->cb, 0, sizeof(struct br_input_skb_cb));
> +	skb->l2_miss = 0;
>  
>  	p = br_port_get_rcu(skb->dev);
>  	if (p->flags & BR_VLAN_TUNNEL)

Overall looks good, only this part is a bit worrisome and needs some additional
investigation because now we'll unconditionally dirty a cache line for every
packet that is forwarded. Could you please check the effect with perf?

Thanks,
 Nik


