Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 454DE105BBA
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 22:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfKUVQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 16:16:08 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:32972 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfKUVQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 16:16:08 -0500
Received: by mail-qk1-f196.google.com with SMTP id 71so4457766qkl.0
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 13:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IQkjDH2eF68n677DH4zDG/JWDpxA9pFnAtCpWOaDacI=;
        b=fL8O6oxC+KsaQ5tmvt9VF6+dfbqEr/J02KzZM4g1hakDwUVgLtc9knUPZ1rXBtTcEa
         V2/xqsBl52FAoUTmowrfUruRXmp9izSyWnl9KJtO19DgP4pLo6oMZU+1b+2HPREZIJW4
         DSk8y/0I+GkSb70sUubW+Q33khCHsWdPfJAqKFWFwOzHiyF8946lXe4YOvMSNSL93vwN
         XOzpDHtAeDgJC1vNBAyxAVRJcgOzmXurkzTCZagGLZdzWWiDPmAhp9F8vT5bMlHsBOCi
         0dpSyV85dfQHl63HukhH1ptXoqwGzTs3uPSrSc5CvxTv5dXecWSh70ezwu8sI40xomL7
         HrDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IQkjDH2eF68n677DH4zDG/JWDpxA9pFnAtCpWOaDacI=;
        b=FQQZ4bX0MjZR9s4Q/2NgWR0aGo9pjQ93QkqvYSRX3GUHJR4Dt7b1Y1iFUfjKFh/OpP
         Sij0a4oAHtq/liGPZwm5NK3IgFeY+NWveGUcrnQAu78eWLlaP3NTDpq3Bz58dwl6E72c
         XoYAqxi3hSzw+v9YaF2GQEDQRS8J1Q503xM4LGWRHUN4dBnLnDjqENvX/+ZS+Dr5l6ch
         U809j7aPb131p2bsN48PYT1Uhu77DZConSpNf1j9ASYOsZObeHt5qDX1Rzitb7BdZ9yI
         ilCidDBqQigRglQdZ4o4j7mSs52+5XUSzJaEOlHBuy7W3Ljgn7GwXYG/Lz4P0jT/MQi7
         ZqCw==
X-Gm-Message-State: APjAAAVUrGhBnCQs1bLaU31tJ4IZXkhP+wBCA/0il/Loig/LWmkM8m62
        Wkk3aJgCJNmhhPFP66CWD1I=
X-Google-Smtp-Source: APXvYqwRaI/jW990cUs215cXVGZo3OfF89LHHEEaRGVSyPsKMChu7Z6iEbAD8bK7Mi/7YNFhpqKnzA==
X-Received: by 2002:ae9:e702:: with SMTP id m2mr9966772qka.269.1574370965609;
        Thu, 21 Nov 2019 13:16:05 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:b9b1:601f:b338:feda])
        by smtp.googlemail.com with ESMTPSA id 201sm1413087qkf.10.2019.11.21.13.16.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 13:16:04 -0800 (PST)
Subject: Re: [PATCH net-next v4 5/5] ipv4: use dst hint for ipv4 list receive
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <cover.1574252982.git.pabeni@redhat.com>
 <70221ba2d3cca4a2afb39c8ea95f7a2870326c13.1574252982.git.pabeni@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ae48a87b-0c5c-c153-aa4a-201171ca3ac8@gmail.com>
Date:   Thu, 21 Nov 2019 14:16:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <70221ba2d3cca4a2afb39c8ea95f7a2870326c13.1574252982.git.pabeni@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/19 5:47 AM, Paolo Abeni wrote:
> This is alike the previous change, with some additional ipv4 specific
> quirk. Even when using the route hint we still have to do perform
> additional per packet checks about source address validity: a new
> helper is added to wrap them.
> 
> Hints are explicitly disabled if the destination is a local broadcast,
> that keeps the code simple and local broadcast are a slower path anyway.
> 
> UDP flood performances vs recvmmsg() receiver:
> 
> vanilla		patched		delta
> Kpps		Kpps		%
> 1683		1871		+11
> 
> In the worst case scenario - each packet has a different
> destination address - the performance delta is within noise
> range.
> 
> v3 -> v4:
>  - re-enable hints for forward
> 
> v2 -> v3:
>  - really fix build (sic) and hint usage check
>  - use fib4_has_custom_rules() helpers (David A.)
>  - add ip_extract_route_hint() helper (Edward C.)
>  - use prev skb as hint instead of copying data (Willem)
> 
> v1 -> v2:
>  - fix build issue with !CONFIG_IP_MULTIPLE_TABLES
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  include/net/route.h |  4 ++++
>  net/ipv4/ip_input.c | 35 +++++++++++++++++++++++++++++++----
>  net/ipv4/route.c    | 42 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 77 insertions(+), 4 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


