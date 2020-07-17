Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6214E223F10
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 17:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgGQPEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 11:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgGQPEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 11:04:55 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A4DC0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 08:04:54 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id r22so8976369qke.13
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 08:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E+ECNRvf0NEN+Tke0ZZEZCG+S0kp4/O1sSXuXc8086g=;
        b=tQldxi6SJ6vFXt0+1vB7RwcasQTxIA5CzJ2bQE5xruZXuT2LrqdKP0quGlVADB4qrQ
         zgf4md6b1SR0DH4Wqi0QsW7tM0yhUOv22UCvRRGpceFKLZsqq3rh9kd9tRjF5wPxcNBt
         PtLOqicDCS0uQWMyMaLE8AbhWQunq/cViqco++w+N/xEaSehjx58Enw8uIKY64bgGBIz
         ewSST0fDpMl5I/wa/9hs+VeosFO6yMx6mI9IAGISrHI0oiTKjsdMdyxqu62rAdAwcNWK
         XzwinBszTDPA+NsjxX+/ZOx91vohdg0xzKIdvxFmUO2DlcjJU6MA+sWryrWdXKwjYed6
         ZC8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E+ECNRvf0NEN+Tke0ZZEZCG+S0kp4/O1sSXuXc8086g=;
        b=k0jUqbXs8d8XDcbHPM4DVtH04xg5W6LRaWAskaCe7O0/WRfQNZg4D57hL5bVaWXWl2
         P+7OnzL5V2WRAEWM0fPlfEJSW6TIKZUzjyDWVyk9fK//lC9Vw5g+VNi+9HZotloYUrRS
         8UaHhXhPFXBFG0kH7MfjAI+MD7RWJ1wGKupK8cO2Q5sIxDjC+cniVA2l5mG7YBiyO8qw
         HMqi1eTiAbtTzOKCzP3wOzbL+6vlF8gs72BEfIGRNysLKoSZLXijKy3jNzcLKeBRZK/+
         iLqmmFtlvQy0CPLlESpGrdTNcOM7xawd9Nq1cEMHRdbuVZWXKzMolPyqGnaDW+qAUFst
         zffg==
X-Gm-Message-State: AOAM530sbR1YZwaFEwI8iNF8f+hSmjJ8NXygT8SiC9sTyeXfZ/TlsMIx
        zkSjZFsetesfF0/ex357MmI=
X-Google-Smtp-Source: ABdhPJyfXq0DabZthY6izrKYATGWlkqIDShUEdPf2yGa17C7s38iYNOLPygm8ocn230cUKvNjihXew==
X-Received: by 2002:a37:9c4d:: with SMTP id f74mr9634871qke.349.1594998294242;
        Fri, 17 Jul 2020 08:04:54 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:64cc:52f7:7602:a8f2? ([2601:282:803:7700:64cc:52f7:7602:a8f2])
        by smtp.googlemail.com with ESMTPSA id l31sm11312014qtc.33.2020.07.17.08.04.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2020 08:04:53 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
To:     Stefano Brivio <sbrivio@redhat.com>,
        Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, aconole@redhat.com
References: <20200712200705.9796-1-fw@strlen.de>
 <20200712200705.9796-2-fw@strlen.de> <20200713003813.01f2d5d3@elisabeth>
 <20200713080413.GL32005@breakpoint.cc>
 <b61d3e1f-02b3-ac80-4b9a-851871f7cdaa@gmail.com>
 <20200713140219.GM32005@breakpoint.cc> <20200714143327.2d5b8581@redhat.com>
 <20200715124258.GP32005@breakpoint.cc> <20200715153547.77dbaf82@elisabeth>
 <20200715143356.GQ32005@breakpoint.cc> <20200717142743.6d05d3ae@elisabeth>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <89e5ec7b-845f-ab23-5043-73e797a29a14@gmail.com>
Date:   Fri, 17 Jul 2020 09:04:51 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200717142743.6d05d3ae@elisabeth>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/17/20 6:27 AM, Stefano Brivio wrote:
>>
>>> Note that this doesn't work as it is because of a number of reasons
>>> (skb doesn't have a dst, pkt_type is not PACKET_HOST), and perhaps we
>>> shouldn't be using icmp_send(), but at a glance that looks simpler.  
>>
>> Yes, it also requires that the bridge has IP connectivity
>> to reach the inner ip, which might not be the case.
> 
> If the VXLAN endpoint is a port of the bridge, that needs to be the
> case, right? Otherwise the VXLAN endpoint can't be reached.
> 
>>> Another slight preference I have towards this idea is that the only
>>> known way we can break PMTU discovery right now is by using a bridge,
>>> so fixing the problem there looks more future-proof than addressing any
>>> kind of tunnel with this problem. I think FoU and GUE would hit the
>>> same problem, I don't know about IP tunnels, sticking that selftest
>>> snippet to whatever other test in pmtu.sh should tell.  
>>
>> Every type of bridge port that needs to add additional header on egress
>> has this problem in the bridge scenario once the peer of the IP tunnel
>> signals a PMTU event.
> 
> Yes :(
> 

The vxlan/tunnel device knows it is a bridge port, and it knows it is
going to push a udp and ip{v6} header. So why not use that information
in setting / updating the MTU? That's what I was getting at on Monday
with my comment about lwtunnel_headroom equivalent.
