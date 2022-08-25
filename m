Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734135A1394
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 16:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbiHYO3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 10:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbiHYO27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 10:28:59 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EAD111D
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 07:28:54 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id k18-20020a05600c0b5200b003a5dab49d0bso2625767wmr.3
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 07:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc;
        bh=CE2tg3ZCTR/TIkLeXty4i2JkA90fRb0hIe6a9QR83JU=;
        b=JWVlNgN1e/VtSnTU4xgZHjA1syh4F0Qe0ILbBEcCFurDRDDYBOrLV7rECSrAlqeplE
         8UleTAWWSseIb8++UeCWFAgT3u7ICqyqVMkVKcugdCbTewSrGknoOTR3sN0+S7dHk0hM
         zWDZfcwfKa7ADu2COIDvHxPVXLSuMIfxRv0VHcp4IsDsAI0swuGnMaCjC1DGRgCXPgpO
         mYGPjIo+cpLyqWReRjQNra7o/adIGIXLURs3aV6CxdtWqHIrytS5aztFq98QbHMtfp3M
         rU3/PFQlTixQt0lZDCzhRjcPlPoKCamc3OGDkw+pEoUiGJrsrsMuEkdR6sDOPmlMJ+zX
         /lVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc;
        bh=CE2tg3ZCTR/TIkLeXty4i2JkA90fRb0hIe6a9QR83JU=;
        b=mZywB79irG4k3jlVmhw+wln+PI7pPUsc78wVIikwD8x4yfy3hqBSK4KaM7mToLSj96
         80DtAprI98usD3xwzxRXszImXNHhAshz8DLtC69b44lfDBP9frTtRwhzrsqHABUZVpnL
         Vt0rEAAqBG8YxJYtvJxnGWi5d+JKZPOGpd9yYVIgSwsfnPG0RE/5w2braYppCjMSCXug
         DO3nLu5xAyv5o1STUsAfVx8qxV5ivDQQDNQQk+LNUEU4UwdSpLEoZSuSDAGUci4YLkKt
         ZugskAv1izvasXtk9Ny+O+eH2zp0vwAAudFvnIHJnx9dyKXVqTtn5/Gtp9QeRQRi5fRw
         7jyA==
X-Gm-Message-State: ACgBeo0jZtbh2Y7Rtc+8O16oLDkt0RyVneOpyki26TgP+yKFW0MF+Ek+
        2BU02/mVxTBopNgRvANrPoLKTQ==
X-Google-Smtp-Source: AA6agR7XFE4RC4Nx+vvDpSoTdPSPvNnTpL4DxjbhUPaNt+zf7u/SRDmoTdl+ZastKpsJKJXj/DQwzA==
X-Received: by 2002:a1c:a4c6:0:b0:3a6:539b:a820 with SMTP id n189-20020a1ca4c6000000b003a6539ba820mr8438525wme.128.1661437732786;
        Thu, 25 Aug 2022 07:28:52 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:e5a8:418:4b2a:1186? ([2a01:e0a:b41:c160:e5a8:418:4b2a:1186])
        by smtp.gmail.com with ESMTPSA id j2-20020a5d4522000000b0022546ad3a77sm15310176wra.64.2022.08.25.07.28.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 07:28:52 -0700 (PDT)
Message-ID: <540ab583-5434-2970-68e3-8dc3df261bd4@6wind.com>
Date:   Thu, 25 Aug 2022 16:28:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec-next,v2 2/3] xfrm: interface: support collect
 metadata mode
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        dsahern@kernel.org, contact@proelbtn.com, pablo@netfilter.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20220825134636.2101222-1-eyal.birger@gmail.com>
 <20220825134636.2101222-3-eyal.birger@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220825134636.2101222-3-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 25/08/2022 à 15:46, Eyal Birger a écrit :
> This commit adds support for 'collect_md' mode on xfrm interfaces.
> 
> Each net can have one collect_md device, created by providing the
> IFLA_XFRM_COLLECT_METADATA flag at creation. This device cannot be
> altered and has no if_id or link device attributes.
> 
> On transmit to this device, the if_id is fetched from the attached dst
> metadata on the skb. If exists, the link property is also fetched from
> the metadata. The dst metadata type used is METADATA_XFRM which holds
> these properties.
> 
> On the receive side, xfrmi_rcv_cb() populates a dst metadata for each
> packet received and attaches it to the skb. The if_id used in this case is
> fetched from the xfrm state, and the link is fetched from the incoming
> device. This information can later be used by upper layers such as tc,
> ebpf, and ip rules.
> 
> Because the skb is scrubed in xfrmi_rcv_cb(), the attachment of the dst
> metadata is postponed until after scrubing. Similarly, xfrm_input() is
> adapted to avoid dropping metadata dsts by only dropping 'valid'
> (skb_valid_dst(skb) == true) dsts.
> 
> Policy matching on packets arriving from collect_md xfrmi devices is
> done by using the xfrm state existing in the skb's sec_path.
> The xfrm_if_cb.decode_cb() interface implemented by xfrmi_decode_session()
> is changed to keep the details of the if_id extraction tucked away
> in xfrm_interface.c.
> 
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> 
> ----
> 
> v2:
>   - add "link" property as suggested by Nicolas Dichtel
Thanks.

[snip]

> @@ -269,10 +303,24 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
>  	struct net_device *tdev;
>  	struct xfrm_state *x;
>  	int err = -1;
> +	u32 if_id;
>  	int mtu;
>  
> +	if (xi->p.collect_md) {
> +		struct xfrm_md_info *md_info = skb_xfrm_md_info(skb);
> +
> +		if (unlikely(!md_info))
> +			return -EINVAL;
> +
> +		if_id = md_info->if_id;
> +		if (md_info->link)
> +			fl->flowi_oif = md_info->link;
nit: flowi_oif is 0 in case of collect_md, thus the if can be omitted.

[snip]
> @@ -682,12 +746,19 @@ static int xfrmi_changelink(struct net_device *dev, struct nlattr *tb[],

>  		return -EINVAL;
>  	}
>  
> +	if (p.collect_md) {
> +		NL_SET_ERR_MSG(extack, "collect_md can't be changed");
> +		return -EINVAL;
> +	}
> +
>  	xi = xfrmi_locate(net, &p);
>  	if (!xi) {
>  		xi = netdev_priv(dev);
>  	} else {
>  		if (xi->dev != dev)
>  			return -EEXIST;
> +		if (xi->p.collect_md)
> +			return -EINVAL;

It could be useful to add an extack error msg in this case also.

Regards,
Nicolas
