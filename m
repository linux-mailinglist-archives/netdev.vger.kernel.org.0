Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44D76B9A22
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbjCNPoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbjCNPoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:44:18 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A59ABAF7
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:43:42 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id h8so20007000ede.8
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678808621;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=08RSAi0vqcdPOKP0EiRvce0yplswuhwZhDglHUvA7Ws=;
        b=jbIsro88L9GK52YJoT/Lq5SKkLKDiSa80SEC1muRLFVDDoLkAp2PA6ZlA5bIAeOIpg
         OGCRuFGG8RJz1A+DZgJdNR9iVI3PwVMNKGzdzvbsP2eOSmEOF3FWLaPL7vcc6hX1tVj/
         V2C76FsLF09xDUj2ns7+w54m01s/CsP4bGlsQ97E/vEwLq0TMiOw08UQUhz7DTxXKITv
         Iq0OpXBM5fbOGHHDujS6eUBkHdnwjUD3+Sf2V1tUUUbg+7gySw8zUdBJXFXIQ8Cgwipl
         MD9/PAGL+AlcxKL1A2jO7OgC+nstOCGPjXKANScxiTYvMHvgwzaS4neYckDAICSokT4v
         wV5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678808621;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=08RSAi0vqcdPOKP0EiRvce0yplswuhwZhDglHUvA7Ws=;
        b=os+jDjgewIFgGtqwW0voQn8q13mXleW7sgc8gcN2bWwoMVwbeygrGJYIwJML4AJS7/
         KxX63B8cYbh/6jnZl/kDDaNWIuBgxRJaETc+kB6MyxfbyZ35D6WYCEvjtMay0tjAMNXg
         JkaAW13r50a20VfGtMddpzBQpznhugQmOTcqTvhEyV3CImiiIBIFnJkq2cLDAHiScACv
         Ix7U2JxL8n1nTdLhLAtbWKB5H5PkYEiuEJf13LzUGhGw2tXjYXP1Yff0FdJx+z6sxpMG
         8m9fdUj2b939CDOU3Km9hSdbvWZXD9MsWYFJgHTtIOvLorQvAXar7IOmQIRxrGYI+LRe
         +gRw==
X-Gm-Message-State: AO0yUKVp16EFztMaw/FcN0lVOtmEvgA+BB51yYCX9wBb/vTyh0lFweiL
        l2TSqgF/HSUQBhW3aNUORXTXeg==
X-Google-Smtp-Source: AK7set+GhaIjf4QOJ6A9dqh3KfLWV/JOJ7zOhEyas0/aBQlhgRnOYv2qappMNUImVJAOes0H8gV4Kg==
X-Received: by 2002:a05:6402:416:b0:4bb:f229:9431 with SMTP id q22-20020a056402041600b004bbf2299431mr16231924edv.19.1678808620849;
        Tue, 14 Mar 2023 08:43:40 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id a38-20020a509ea9000000b004c06f786602sm1208214edf.85.2023.03.14.08.43.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 08:43:40 -0700 (PDT)
Message-ID: <2b55ef32-812c-25ec-7715-595380344689@blackwall.org>
Date:   Tue, 14 Mar 2023 17:43:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v3] Make vxlan try to send a packet normally if
 local bypass fails.
Content-Language: en-US
To:     Vladimir Nikishkin <vladimir@nikishkin.pw>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
        gnault@redhat.com
References: <20230314013423.12029-1-vladimir@nikishkin.pw>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230314013423.12029-1-vladimir@nikishkin.pw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/03/2023 03:34, Vladimir Nikishkin wrote:
> In vxlan_core, if an fdb entry is pointing to a local
> address with some port, the system tries to get the packet to
> deliver the packet to the vxlan directly, bypassing the network
> stack.
> 
> This patch makes it still try canonical delivery, if there is no
> linux kernel vxlan listening on this port. This will be useful
> for the cases when there is some userspace daemon expecting
> vxlan packets for post-processing, or some other implementation
> of vxlan.
> 
> Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
> ---
>  drivers/net/vxlan/vxlan_core.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 

Hi Vladimir,
You should structure the subject to driver: change, in this case
you can use something like
vxlan: try to send a packet normally if local bypass fails

> diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
> index b1b179effe2a..0379902da766 100644
> --- a/drivers/net/vxlan/vxlan_core.c
> +++ b/drivers/net/vxlan/vxlan_core.c
> @@ -2422,19 +2422,13 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
>  	if (rt_flags & RTCF_LOCAL &&
>  	    !(rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))) {
>  		struct vxlan_dev *dst_vxlan;
> -
> -		dst_release(dst);
>  		dst_vxlan = vxlan_find_vni(vxlan->net, dst_ifindex, vni,
>  					   daddr->sa.sa_family, dst_port,
>  					   vxlan->cfg.flags);
>  		if (!dst_vxlan) {

you can drop the {} for a single line

> -			dev->stats.tx_errors++;
> -			vxlan_vnifilter_count(vxlan, vni, NULL,
> -					      VXLAN_VNI_STATS_TX_ERRORS, 0);
> -			kfree_skb(skb);
> -
> -			return -ENOENT;
> +			return 0;
>  		}
> +		dst_release(dst);
>  		vxlan_encap_bypass(skb, vxlan, dst_vxlan, vni, true);
>  		return 1;
>  	}

This also changes such packet delivery expectations so these packets are not
dropped anymore which might surprise people and allow traffic that would've been
dropped otherwise. IMO it should be hidden behind a new vxlan option that defaults
to the old behaviour.

Cheers,
 Nik

