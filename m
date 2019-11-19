Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEBE102AE3
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 18:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfKSRkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 12:40:24 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42462 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbfKSRkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 12:40:24 -0500
Received: by mail-pl1-f193.google.com with SMTP id j12so12117791plt.9
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 09:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UXRxnVWqdFLg9p/S0J7/eu8mH53LsZoGvLaIM5gWSgA=;
        b=DYMyF7sDRD2cgH7SuaBp4fBRpyaRYDejYURA/i3PFh0O6/+gNHBgJ5sk6R4sgaoHlS
         NFG0b/k2D6u33Wn+o60kz3ITd0xIehpauWAwwjuUYnVaTeXFb58wrwWI8Pu34R/JtLKb
         3bgDVWzR/OYoFg4+DSE4WuK99jojYpdAf2w3/ushps7qNZK4ZXD7KzfA+4IYkEflWvob
         CK2t0c86CMJIvZDIaNrK1h5ovjFlOAzNlcv/ro66hCLsrQZu3yNF+MTQ4Y1lMaxOh2mg
         b+Ka1+Cdb90z5m3jigV86FB3a25A0h8w+VlAVip906JZRvEQ/pBshh0lieeaNjWd6vRt
         X6/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UXRxnVWqdFLg9p/S0J7/eu8mH53LsZoGvLaIM5gWSgA=;
        b=c8P5HFWvTQYl5Y4a6V9a+y5gor3roY8U5LnZ2qSQVeGJbpusOr9lobiJU9a3cYLWGm
         h8cs6zz8w28CeJrzj0a93BH38AFzensM69YU7q7xCoAodavBHoEAz7NGN4WHCdnxmhGv
         xOw+CJ6DcFK3ey1GPAAZZxOTnIH/IhNnDphj8qcsENSq0SAjvHeCM8CLaurcRDPuGSHz
         uR1xkTEHKUvLLVPWyi/dcOedvCY1RmcWIDst61fmDKhr0EBiQHrt+LZmarnptj/M1/zV
         AXnSLI5080P2qr22HVAzCvLVvetbULSE/JihM/NrW3DPrKhGqZS/zXdcVwRuKazBdL11
         t4aw==
X-Gm-Message-State: APjAAAW9r5DYIZ/vgK9nKBfnvvYP9q0LgyaKLcwxOCOX6MRMgKYwBB7Z
        3ZGlucnNjPy7kifMYIdVj5E=
X-Google-Smtp-Source: APXvYqwc0K4hLEiaqNCkf2H0L95/gO8jQ7KS7TrsgA0k4+vJtHiW+s5qLn3QSoERDfThden1wJp24A==
X-Received: by 2002:a17:90a:2a44:: with SMTP id d4mr7946424pjg.91.1574185223630;
        Tue, 19 Nov 2019 09:40:23 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id m15sm25665176pfh.19.2019.11.19.09.40.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2019 09:40:22 -0800 (PST)
Subject: Re: [PATCH net-next v3 1/2] ipv6: introduce and uses route look hints
 for list input
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        David Ahern <dsahern@gmail.com>
References: <cover.1574165644.git.pabeni@redhat.com>
 <422ebfbf2fcb8a6ce23bcd97ab1f7c3a0c633cbd.1574165644.git.pabeni@redhat.com>
 <c6d67eb8-623e-9265-567c-3d5cc1de7477@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <91cc8a38-55a4-74b6-7a1a-3f6dc2b0842e@gmail.com>
Date:   Tue, 19 Nov 2019 09:40:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <c6d67eb8-623e-9265-567c-3d5cc1de7477@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/19/19 9:34 AM, Eric Dumazet wrote:
> 

>>  
>> +static bool ip6_can_use_hint(struct sk_buff *skb, const struct sk_buff *hint)
>> +{
>> +	return hint && !skb_dst(skb) &&
>> +	       ipv6_addr_equal(&ipv6_hdr(hint)->daddr, &ipv6_hdr(skb)->daddr);
>> +}
>> +
> 
> Why keeping whole skb as the hint, since all you want is the ipv6_hdr(skb)->daddr ?
> 
> Remembering the pointer to daddr would avoid de-referencing many skb fields.
> 

Ah we also need the hint dst, scrap this then...

