Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3E22A7BDF
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 11:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbgKEKb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 05:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgKEKb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 05:31:57 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63890C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 02:31:57 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id i19so1852845ejx.9
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 02:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5pF9v8rpTkCtDXKuBnQPqVNGe6M4hBulo1LFjYCCOBI=;
        b=VPy6FDynIU+AY6D59IA1XLXLJ3QXCLWFKKpS1elvFvttgZ23Gsx3vDirocpngax0kh
         9ucxy/9bOEgYDCwtLxiWcK9r55bCHa4+ztZo1zhIlC5nqA/q3jrqbOblLjL/d4iqA8dP
         I1Iv2a8I9giq7TXhlXfOZVRlVbxtgNxFZ1LmiMnBiWDwgoWX4RpaIn4PAH8IdhpTUmjo
         dMPsfDrrjW3nNLwVu5jjrQKEmqAu4hp0clZHDGlv/HxGKOuq+zv9976BDqiM1iv62RNk
         50iR7opGL6rbbOLqG8rn6/qSIwPcTHHfLo/8lPJ0kBsTdM8O223M7+HNIx1o/6VNlaCD
         MlEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5pF9v8rpTkCtDXKuBnQPqVNGe6M4hBulo1LFjYCCOBI=;
        b=ge8Ne2j7dipXC3s8hQ94VDHabo3XvY5mb7cSu2MowZU51ZtXBlKnCsGUQp6KutwkYv
         uA9vXXRCvN6g77DyxFXBeLa2SE9yS6wj7SysXSLKPEkjcR843kQVIzIoqIrteuaDPDmH
         /8wb7VFP7Dzw2NX/QLEbK01ACD1koNGp5lNLwN4OTJ21wFQTZYvW4Y7XtVDiBDn9qhTU
         At/qBy/Kp72Cbxo1Tgiy/Ed6L5lH5dEs/347F6KEfiQ+SPJ/mcpP/9Ns5BDNwi5nZZ/f
         o70bZKhGgMnp9uV2CCKXfdlJ6f1E5V1K8koFlr1QocsPTLqJ7zXFj3drhpylOo2n8HpK
         oMWA==
X-Gm-Message-State: AOAM5312gn3eM1qwLPzK3mNF9TxLtWu46ZpHqOy9l9ZRigoPq8ud/fUn
        XsSUXXovAhIPPQwWSy4/d5g=
X-Google-Smtp-Source: ABdhPJxAKtwT323dFSgJcuELyOY0maa201gYarrJK8YkPqhn/DwnG8KFcLsAApUcMEVI/vwtKbpXaw==
X-Received: by 2002:a17:906:a385:: with SMTP id k5mr1574755ejz.492.1604572316067;
        Thu, 05 Nov 2020 02:31:56 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:59d0:7417:1e79:f522? (p200300ea8f23280059d074171e79f522.dip0.t-ipconnect.de. [2003:ea:8f23:2800:59d0:7417:1e79:f522])
        by smtp.googlemail.com with ESMTPSA id m1sm708520ejj.117.2020.11.05.02.31.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 02:31:55 -0800 (PST)
Subject: Re: [PATCH net] r8169: work around short packet hw bug on RTL8125
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maxim Plotnikov <wgh@torlan.ru>
References: <8002c31a-60b9-58f1-f0dd-8fd07239917f@gmail.com>
 <20201104174521.2a902678@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <4bd669af-847f-020e-9c80-51ff325b4cbc@gmail.com>
Date:   Thu, 5 Nov 2020 11:31:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201104174521.2a902678@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.11.2020 02:45, Jakub Kicinski wrote:
> On Tue, 3 Nov 2020 18:52:18 +0100 Heiner Kallweit wrote:
>> Network problems with RTL8125B have been reported [0] and with help
>> from Realtek it turned out that this chip version has a hw problem
>> with short packets (similar to RTL8168evl). Having said that activate
>> the same workaround as for RTL8168evl.
>> Realtek suggested to activate the workaround for RTL8125A too, even
>> though they're not 100% sure yet which RTL8125 versions are affected.
>>
>> [0] https://bugzilla.kernel.org/show_bug.cgi?id=209839
>>
>> Fixes: 0439297be951 ("r8169: add support for RTL8125B")
>> Reported-by: Maxim Plotnikov <wgh@torlan.ru>
>> Tested-by: Maxim Plotnikov <wgh@torlan.ru>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> Applied, thanks!
> 
>> @@ -4125,7 +4133,7 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
>>  
>>  		opts[1] |= transport_offset << TCPHO_SHIFT;
>>  	} else {
>> -		if (unlikely(rtl_test_hw_pad_bug(tp, skb)))
>> +		if (unlikely(skb->len < ETH_ZLEN && rtl_test_hw_pad_bug(tp)))
>>  			return !eth_skb_pad(skb);
>>  	}
> 
> But looks like we may have another bug here - looks like this function
> treas skb_cow_head() and eth_skb_pad() failures the same, but former
> doesn't free the skb on error, while the latter does.
> 
Thanks for the hint, indeed we have an issue. The caller of
rtl8169_tso_csum_v2() also frees the skb if false is returned, therefore
we have a double free if eth_skb_pad() fails.

When checking eth_skb_pad() I saw that it uses kfree_skb() to free
the skb on error. Kernel documentation say about ndo_start_xmit context:

Process with BHs disabled or BH (timer),
will be called with interrupts disabled by netconsole.

Is it safe to use kfree_skb() if interrupts are disabled?
I'm asking because dev_kfree_skb_any() uses the irq path if
irqs_disabled() is true.
