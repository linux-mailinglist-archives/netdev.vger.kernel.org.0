Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F23D28F746
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 18:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731114AbgJOQ4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 12:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730793AbgJOQ4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 12:56:44 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E2EC061755;
        Thu, 15 Oct 2020 09:56:43 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id c20so2370996pfr.8;
        Thu, 15 Oct 2020 09:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c89SKpAIAopcmZmV7SsNNuT7Bom+CXMUjA+qRYu76JU=;
        b=kw6E45Z89QKMc4iYjf3Fv1g34Ff8dV8SLGS4kLU0J8JHIMtRtEaB2xveIpZxamON3x
         WnVHl3oqf6U1x6vlGe3NqHGOzQRLXQg0Q2iDJ7X7Q+bFaSL/+sUQnnxNFNWrq75DX0UR
         HjZDU8sLfeMnDAS6IbmLHD3fVnFg4Rh43RVyYgR0KZBXRXlSpxj1pDS8yxRoFC+rQZCm
         MV7LQghCwUUXyEHwfVWRWyXvIJ9BxRXFAA4zMc/8Yb0W+IyALvAPBbH+7KzDEvh+LYI+
         VrtMTmJWp1k+NHJvuKlbWPm2CgZZ3U++9pJb96N4tdfWU9SiRFYOoiwSRF/XxswJ81j8
         CfNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=c89SKpAIAopcmZmV7SsNNuT7Bom+CXMUjA+qRYu76JU=;
        b=DuI5086WgXHBLUlS7iHxs+6nukynDt7OrIPzw+5Wt9qaM1KJ06fNnRVjutE/FC8zgJ
         LLBFd80ylNdXE0kQEvNsX6tpfdF4l+5L1CcNB7ybfqbmq/tFraRhrdVWLUrmMapvnE4G
         ARlMhdA/5sGGwlBC34ddsPVQ/6RTp5MW5MDkVVwboTh3MF6VmGSwd587Ynq8hIurc/Gy
         pVG4xIksEiPUhIXTir3bNVeQcDTlTHdWjgfXayyzI4eKyzOr4HGo46oFP78qkElf1jjU
         W3mPUTGfN2HYEzxnWyqR4XX4pOomSVkSZ7LwIIEx+Zx3hL0bu+mzsim0HGHYfL4LCIEf
         blog==
X-Gm-Message-State: AOAM530H+KfVXYPIm2Z6uRk3DTjrnH44x48Bl6l8SNqOfVFToEt5JP8j
        NmzpwiVYMa+MnCry5zwQJIAsnN3z6RY=
X-Google-Smtp-Source: ABdhPJzfJxXTGh6o99eOzJXj/39hSGmWbA8bcG2+5hS9ydk+vUZwE9jh2qSHX1yZFxo4EDep+ew6QQ==
X-Received: by 2002:a63:1d4b:: with SMTP id d11mr3963226pgm.31.1602781002859;
        Thu, 15 Oct 2020 09:56:42 -0700 (PDT)
Received: from [10.67.48.230] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w12sm3953021pfu.53.2020.10.15.09.56.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 09:56:42 -0700 (PDT)
Subject: Re: [PATCH net-next] net: ptp: get rid of IPV4_HLEN() and OFF_IHL
 macros
To:     Richard Cochran <richardcochran@gmail.com>,
        Christian Eggers <ceggers@arri.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Vishal Kulkarni <vishal@chelsio.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201014115805.23905-1-ceggers@arri.de>
 <20201015033648.GA24901@hoboy>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <939828b0-846c-9e10-df31-afcb77b1150a@gmail.com>
Date:   Thu, 15 Oct 2020 09:56:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201015033648.GA24901@hoboy>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/14/20 8:36 PM, Richard Cochran wrote:
> On Wed, Oct 14, 2020 at 01:58:05PM +0200, Christian Eggers wrote:
>> Both macros are already marked for removal.
> 
> I'm not sure what Daniel Borkmann meant by that comment, but ...
> 
>>  	switch (type & PTP_CLASS_PMASK) {
>>  	case PTP_CLASS_IPV4:
>> -		ptr += IPV4_HLEN(ptr) + UDP_HLEN;
>> +		ptr += (((struct iphdr *)ptr)->ihl << 2) + UDP_HLEN;
> 
> to my eyes
> 
> 	IPV4_HLEN(ptr)
> 
> is way more readable than
> 
> 	(((struct iphdr *)ptr)->ihl << 2)
> 
> and this
> 
> 	(struct udphdr *)((char *)ih + (ih->ihl << 2))
> 
> is really baroque.
> 
> I don't see any improvement here.

Having recently helped someone with a bug that involved using
IPV4_HLEN() instead of ip_hdr() in a driver's transmit path (so with the
transport header correctly set), it would probably help if we could make
IPV4_HLEN()'s semantics clearer with converting it to a static inline
function and put asserts in there about what the transport and MAC
header positions should be.

At the very least, creating a new function, like this maybe in
include/linux/ip.h might help:

static inline u8 __ip_hdr_len(const struct sk_buff *skb)
{
	const struct iphdr *ip_hdr = (const struct iphdr *)(skb->data);

	return ip_hdr->ihl << 2;
}
-- 
Florian
