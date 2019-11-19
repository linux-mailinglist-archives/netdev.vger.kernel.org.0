Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1A710292C
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 17:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbfKSQVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 11:21:10 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37273 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727456AbfKSQVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 11:21:09 -0500
Received: by mail-pj1-f66.google.com with SMTP id f3so2824554pjg.4
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 08:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uwokoN46Gk13UZfE8ELxAnxSUQrFt+tO6wqftlwPgEE=;
        b=JPGeVw2zpTwEa4vInlXSR/+3z4dABCgVolm9pGo/M5vOKKWVqsCTLszPZ5N/89thSS
         irxUdVOAXdCx1MXbY4aE9Ms4Wc88XP/Gv2OYwGu9qpeYdsfViDxAubSwvMFvomnZ8An6
         zu4+CV9TLODqrsrcC2IXtQs497gYKgjukjsBBtdoTnf05TPfzEqFnS2/P7z3sfOPdUPQ
         L45BldeBiWafKS6ZYZOo0b6LLcHg1n9zHM5my5maLb79ytsHOIHmvehz7hcms+0dJKiw
         Czt32JjZeqUVl1h7/S9GbaRucKb97+8WM9+3A3RiuPTGmzZzTvPlQ+0ke0Vh8DU1GLzm
         aMrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uwokoN46Gk13UZfE8ELxAnxSUQrFt+tO6wqftlwPgEE=;
        b=tRhuTdPkuJxPqKuHZzFEqwzutoHgFaZTITKhNOE6OjSTWB8Do4a+fy1I2njpQeanr+
         +jNUHrAiZxJ5gBpvrsGyqrqdj6tGiS0yH8WNLBXeDx5VNqJa3nX4guDWeKLqqD0v5KM5
         91BBSHTI7R8VVJsrJ4N54VixpzBiVE38Q33rRUlczEbRXlvShjUyvsbE9rIzcve8f+AA
         wd9/Esc/CRmbU0MxDCZcJuigpO6PZmYJMWHxEICs0gyAMtQ6MQYLv0aYPLSZ+795bdTe
         grYjFgQCWRDCXpPNGjIe2rP7gV4YLSJaZmqk+VkXF4JUoD1YZS0QMBNi8meltfa2bSHh
         9wxg==
X-Gm-Message-State: APjAAAVZA7PPnEq2LoO8g+2NYvHWGPVn9L8eT8lqFy9me0L4jG2IMqEU
        wJFTdCs6finr0JpUXXMWDg0=
X-Google-Smtp-Source: APXvYqyQ4E8dttbTb44wtIP3glpXGmXgFTS2PrGBPYEfjcNXxCs6KJ1oe+QADw5XaH+qKmBstgBdEA==
X-Received: by 2002:a17:90a:eb04:: with SMTP id j4mr7594980pjz.80.1574180469156;
        Tue, 19 Nov 2019 08:21:09 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:3071:8113:4ecc:7f4c])
        by smtp.googlemail.com with ESMTPSA id i70sm24557978pge.14.2019.11.19.08.21.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2019 08:21:08 -0800 (PST)
Subject: Re: [PATCH net-next v3 1/2] ipv6: introduce and uses route look hints
 for list input
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>
References: <cover.1574165644.git.pabeni@redhat.com>
 <422ebfbf2fcb8a6ce23bcd97ab1f7c3a0c633cbd.1574165644.git.pabeni@redhat.com>
 <5bb4b0b2-cc12-2cce-0122-54bd72ab04e7@gmail.com>
 <f3a53240733bee0322100e9747b6c2e1049b058c.camel@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <76b6a88b-42ab-46c4-a04c-bd2ca073bc4a@gmail.com>
Date:   Tue, 19 Nov 2019 09:21:07 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <f3a53240733bee0322100e9747b6c2e1049b058c.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/19 9:00 AM, Paolo Abeni wrote:
> Hi,
> 
> On Tue, 2019-11-19 at 08:39 -0700, David Ahern wrote:
>> +static struct sk_buff *ip6_extract_route_hint(struct net *net,
>>> +					      struct sk_buff *skb)
>>> +{
>>> +	if (IS_ENABLED(IPV6_SUBTREES) || fib6_has_custom_rules(net))
>>
>> ... but basing on SUBTREES being disabled is going to limit its use. If
>> no routes are source based (fib6_src is not set), you should be able to
>> re-use the hint with SUBTREES enabled. e.g., track fib6_src use with a
>> per-namespace counter - similar to fib6_rules_require_fldissect.
> 
> Thank you for the feedback! Would you consider this as an intermediate
> step? e.g. get these patches in, and then I'll implement subtree
> support? 
> I'm asking because I don't have subtree setup handy, it will a little
> time to get there.
> 


IPV6_SUBTREES is just a matter of source based routing, so with iproute2
just add 'from <addr>'

If you delay dealing with it, then this patch needs a change: since
ip6_extract_route_hint will only return NULL, ip6_can_use_hint will only
take NULL as an input so leaving it enabled just adds overhead with no
benefit.
