Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0949C3C246
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 06:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389662AbfFKEel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 00:34:41 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46359 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389561AbfFKEek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 00:34:40 -0400
Received: by mail-pf1-f195.google.com with SMTP id 81so6559362pfy.13
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 21:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c2/AfWvvHUx3PuUspiJghXWqNSNF291c4Fhv4OEwDMU=;
        b=kO5y6n0lNkcJnCEtevyoK6RNKVkJ/QJLAnlJgl8r9u7ayfHM0sjuimM68erKRvYPrD
         TPmZKZj6geUspkSMsbgdCacM8TjPdalIoVbkcLWOlGliwHfZf3DtymZKLKHCdxLjCd5j
         XGfe/ogAYB5QXIzMtDd/EULdZviHdPiCwN+Bi9ZdHrMWyN8XSY40IrYJgojuNNYFkioS
         Z7whPmwdZ2D/sIXVMp3m2/sd9vF3tu9E/3QFgzah7O6JhJGd0RxGzpPogRsDj/qDg/pk
         LW7nrYtWPf2dRE8IGFjGK67n+Ij0NMPTBevIR4Obx9xb3I0CRdeI+7QVkjGCOvX50U/A
         xh+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c2/AfWvvHUx3PuUspiJghXWqNSNF291c4Fhv4OEwDMU=;
        b=aOa2Ccynrgx0b5+mV+TaKLhr+HMMTof7meKBn2ZknABgtmg4FWFxBqyQr5nl82SuFm
         dC+wv94ljJmr9DcYOJDhDsvXnPIIFVX6hHyQ2rOgFmo5YpVl41/TZ7hubZgcBaRM+Smm
         weAl8g+7uir8oPlnJZI7ERyjMs0rU0/FyPPqH7Xe2CrX5UxlYltipFn74D57G3Hqouia
         cVWGT2jdNSd2/KY1anDX9S0YjqBkeAMfGNZQsu3QC7yw6fHvWnAyh4rgFA2c4FKVxz7i
         gWZ8UG4rhUV+vbV5LdJ2Es1lhKyUP2u5FCpUajA7HAUHxv+DPvMKtHHDKqU9gZ2dL3cL
         KfLA==
X-Gm-Message-State: APjAAAXNsWkgXlkC2hf1D+TWqQsKsUXCShSU9uzea4RJjt27Ksa35rC/
        LdyfluRfEdE/QhsE2VLU6ns=
X-Google-Smtp-Source: APXvYqwVBBeEyycV5PMR2lsx9Rd90a6RDLnotmJIHb3X3PTsIpjgFgEHQ1eoDLlhonNRytSAb7kV8A==
X-Received: by 2002:a17:90a:20e7:: with SMTP id f94mr24115945pjg.68.1560227679635;
        Mon, 10 Jun 2019 21:34:39 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s15sm3370788pfd.183.2019.06.10.21.34.37
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 21:34:39 -0700 (PDT)
Subject: Re: [PATCH RESEND net] net: handle 802.1P vlan 0 packets properly
To:     Govindarajulu Varadarajan <gvaradar@cisco.com>, benve@cisco.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        govind.varadar@gmail.com
Cc:     ssuryaextr@gmail.com
References: <20190610183122.4521-1-gvaradar@cisco.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <13332a7b-bd3d-e546-27d1-402ed8013f41@gmail.com>
Date:   Tue, 11 Jun 2019 13:34:33 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190610183122.4521-1-gvaradar@cisco.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/06/11 3:31, Govindarajulu Varadarajan wrote:
> When stack receives pkt: [802.1P vlan 0][802.1AD vlan 100][IPv4],
> vlan_do_receive() returns false if it does not find vlan_dev. Later
> __netif_receive_skb_core() fails to find packet type handler for
> skb->protocol 801.1AD and drops the packet.
> 
> 801.1P header with vlan id 0 should be handled as untagged packets.
> This patch fixes it by checking if vlan_id is 0 and processes next vlan
> header.
> 
> Signed-off-by: Govindarajulu Varadarajan <gvaradar@cisco.com>
> ---
>   net/8021q/vlan_core.c | 24 +++++++++++++++++++++---
>   1 file changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
> index a313165e7a67..0cde54c02c3f 100644
> --- a/net/8021q/vlan_core.c
> +++ b/net/8021q/vlan_core.c
> @@ -9,14 +9,32 @@
>   bool vlan_do_receive(struct sk_buff **skbp)
>   {
>   	struct sk_buff *skb = *skbp;
> -	__be16 vlan_proto = skb->vlan_proto;
> -	u16 vlan_id = skb_vlan_tag_get_id(skb);
> +	__be16 vlan_proto;
> +	u16 vlan_id;
>   	struct net_device *vlan_dev;
>   	struct vlan_pcpu_stats *rx_stats;
>   
> +again:
> +	vlan_proto = skb->vlan_proto;
> +	vlan_id = skb_vlan_tag_get_id(skb);
>   	vlan_dev = vlan_find_dev(skb->dev, vlan_proto, vlan_id);
> -	if (!vlan_dev)
> +	if (!vlan_dev) {
> +		/* Incase of 802.1P header with vlan id 0, continue if
> +		 * vlan_dev is not found.
> +		 */
> +		if (unlikely(!vlan_id)) {
> +			__vlan_hwaccel_clear_tag(skb);

Looks like this changes existing behavior. Priority-tagged packets will be untagged
before bridge, etc. I think priority-tagged packets should be forwarded as priority-tagged
(iff bridge is not vlan-aware), not untagged.

> +			if (skb->protocol == cpu_to_be16(ETH_P_8021Q) ||
> +			    skb->protocol == cpu_to_be16(ETH_P_8021AD)) {
> +				skb = skb_vlan_untag(skb);
> +				*skbp = skb;
> +				if (unlikely(!skb))
> +					return false;
> +				goto again;
> +			}
> +		}
>   		return false;
> +	}
>   
>   	skb = *skbp = skb_share_check(skb, GFP_ATOMIC);
>   	if (unlikely(!skb))
> 

Toshiaki Makita
