Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623092D2D74
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 15:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729828AbgLHOqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 09:46:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729441AbgLHOqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 09:46:19 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5458C061794
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 06:45:38 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id i9so898189wrc.4
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 06:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3XNO/f3By/6slfoGMEGF4/3HOHm+FDzXIGSmzjkSrZw=;
        b=Oto9br1Ol3WYYN1kUebJjI9+/z+umS0HIbUUg81KaxP1wgvLD21TIOPeja62VGkkGB
         ViMRfj++ZRNkzZurKxVRdTQu4F+Sa3jOl1aqTvm4BSXb6hbaUCLMPF7snQg0VrCjSKzc
         d/eYcgfEnnnK108pPWr1+2KYsD/X52FdQIeM6IsdwEldQFnuIt1W6uHWGuaFmg0Pvn8y
         wML+hvI7c/QRLGUUgk7AOKeGj/vy/yCNfjDeVMrg1+zGCdOp/9Q35aPj0vBElkAluJcM
         yT+Ge5rt4gcGPYJyREgYUfh1gTh4Skmvlb5hfO2mnKeEiik2AOzUeK1+16G4z4tGE2d9
         vjdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=3XNO/f3By/6slfoGMEGF4/3HOHm+FDzXIGSmzjkSrZw=;
        b=PqNm4Cr9zl59Bc9GbqOf9TgwwFzX4kZUsJ/1Sg3TxSKkHGsf7k+tUe5XhplMyRaO8K
         3vfDvLFEDDvk8yrUedXil0YOJAghci0LwKIK8lrTvH4w7ih1Sj0sEGED5zIexFecbXZ0
         OoulUsp+67Q6pPYkGdofVcYcTwYMz76Lu8UDtk4whG/jhkZ9E6LK0RuYRnmTlRLpRxtE
         1Apmv4+7SuSJcwxs5vhjHTZUciGP4UD46kKZIMnCEhd3b4o39mAcPALwUaLdMsdgP/WF
         5iVMAVjDHRVEekqq5LKS0jQm+cLlObW4+m+EJy0+ivUtWD3DoRmjM5hsLutnuPWMVZwW
         E+KA==
X-Gm-Message-State: AOAM531xu1+PRvIYInTGrXGlPO12e6JQwDiYlZHLBjcHfPKUcdLNuu3w
        oFUgNrgnHtnTYMCIBsIBMGB67dSuZEw6tA==
X-Google-Smtp-Source: ABdhPJwMXhZb2++JoFDAW/+YsPNXB0a4RXFXkQzYYCrz/OIcTAVUzwIXTkXfl4XRqAm1PplwexqNcQ==
X-Received: by 2002:a5d:504d:: with SMTP id h13mr4570094wrt.246.1607438736991;
        Tue, 08 Dec 2020 06:45:36 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:c0bd:aca3:59fd:a9c1? ([2a01:e0a:410:bb00:c0bd:aca3:59fd:a9c1])
        by smtp.gmail.com with ESMTPSA id n12sm10710949wrg.76.2020.12.08.06.45.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 06:45:36 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v2] xfrm: interface: Don't hide plain packets from
 netfilter
To:     Phil Sutter <phil@nwl.cc>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201207134309.16762-1-phil@nwl.cc>
 <9d9cb6dc-32a3-ff1a-5111-7688ce7a2897@6wind.com>
 <20201208140013.GX4647@orbyte.nwl.cc>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <29cef7a5-ca02-d07a-4f6f-c029cd32cbb6@6wind.com>
Date:   Tue, 8 Dec 2020 15:45:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201208140013.GX4647@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 08/12/2020 à 15:00, Phil Sutter a écrit :
> Hi Nicolas,
> 
> On Tue, Dec 08, 2020 at 10:02:16AM +0100, Nicolas Dichtel wrote:
>> Le 07/12/2020 à 14:43, Phil Sutter a écrit :
> [...]
>>> diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
>>> index aa4cdcf69d471..24af61c95b4d4 100644
>>> --- a/net/xfrm/xfrm_interface.c
>>> +++ b/net/xfrm/xfrm_interface.c
>>> @@ -317,7 +317,8 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
>>>  	skb_dst_set(skb, dst);
>>>  	skb->dev = tdev;
>>>  
>>> -	err = dst_output(xi->net, skb->sk, skb);
>>> +	err = NF_HOOK(skb_dst(skb)->ops->family, NF_INET_LOCAL_OUT, xi->net,
>> skb->protocol must be correctly set, maybe better to use it instead of
>> skb_dst(skb)->ops->family?
> 
> skb->protocol holds ETH_P_* values in network byte order, NF_HOOK()
> expects an NFPROTO_* value, so this would at least not be a simple
Yes, right. I forgot that.

> 
>>> +		      skb->sk, skb, NULL, skb_dst(skb)->dev, dst_output);
>> And here, tdev instead of skb_dst(skb)->dev ?
> 
> Well yes, tdev was set to dst->dev earlier. Likewise I could use dst
> directly instead of skb_dst(skb) to simplify the call a bit further.
> OTOH I like how in the version above it is clear that skb's dst should
> be used, irrespective of the code above (and any later changes that may
> receive). No strong opinion though, so if your version is regarded the
> preferred one, I'm fine with that.
I would vote for tdev, because:
 - the reader don't have to wonder why tdev is used for dst->dev and not
   for NF_HOOK();
 - tdev has probably been declared so that dst->dev is dereferenced only once;
 - using the same variable everywhere in the function eases code reading.


Thank you,
Nicolas
