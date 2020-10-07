Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FD128625A
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 17:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgJGPkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 11:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgJGPke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 11:40:34 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753B5C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 08:40:34 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k10so2736003wru.6
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 08:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:from:to:cc:references:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tPqVGXYiwHhc1vd1ThKO4W4URhYXe5ivKs2s60q40Tg=;
        b=PQElpJiJCABKWnKCI2pyuGM4mxCT6EpsJpflX2ZvKuGSfAnfvsckAJ2Fleir1KxZoO
         HVIum+ZiUWXdeJgnLODTZ+pQODYhYrj6KeK/0yv0bWQhEZWdYLoQEi2baz0IPfJ57hUU
         UJb7bfw5ADhBGMkT/vV0La3CCzOeDEdfma4uimziVQc8ApXW3zQdtIfsBeuZAZEEvSN4
         TJOa0sNGx8b/5tx0xywCUHlBnpg0fhOtPSQjui0b1jiOtXDLjk7/ScUdChHxKaRQDaJ5
         loJ5fEtwyUQyw1IiFrrzZJD/lSwSi5gy3bSr5QdZ2P8DRtVKP1+0QaVpSXs9VRSWLOST
         9Z4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:from:to:cc:references
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=tPqVGXYiwHhc1vd1ThKO4W4URhYXe5ivKs2s60q40Tg=;
        b=mqquM8zFVBFSbf8ELfDw0pPHYW4jsAxmVC0kgtgZkCRkNEZhO8cuqhcjLLhds/BmXJ
         JGqtyoudTKiOGti4K87+NTkUmJsKqUSfaT+Qi4dqcpTBB4zGap9yPLQlKOIRpKl7Os/Z
         ADtr1m+qACwwkJX7jgnOc7cTo82e5+k7SE19bCxRY1vw868KZrW8ME9p5VEC8b4AMGTX
         h1/GTfbWW8mLKNXiEtCBJsFOUccCyyV03GCVcKlNV7IRgPkWfjrqyYbuI8NQuq9wEOUj
         1IXyB0pMFdaPs4PCMlb2TPEellgTPe6IeCnYIAMdicwoekREXM6pCrdciwKmrFPlLBpz
         VXxA==
X-Gm-Message-State: AOAM531XpZ/YaAH/czN7cntuY3ZVNpn23dPwTZ2HpctkVEpTf1KpjVJG
        Rwn98qx4QU2EBWqO7/UNoGKXcBtBvHH1SA==
X-Google-Smtp-Source: ABdhPJwQnDAdnXSn/RGJm168irKb9Yuiqkv/JMigN6zEHJoQAE1IdaLm+tzZY4BOdVaU72rKW7/YIw==
X-Received: by 2002:adf:f984:: with SMTP id f4mr4240597wrr.102.1602085232661;
        Wed, 07 Oct 2020 08:40:32 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:199a:22f:7140:b143? ([2a01:e0a:410:bb00:199a:22f:7140:b143])
        by smtp.gmail.com with ESMTPSA id x81sm3169338wmb.11.2020.10.07.08.40.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 08:40:31 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 10/19] xfrm: interface: support IP6IP6 and IP6IP tunnels
 processing with .cb_handler
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        network dev <netdev@vger.kernel.org>
References: <20200730054130.16923-1-steffen.klassert@secunet.com>
 <20200730054130.16923-11-steffen.klassert@secunet.com>
 <c79acf02-f6a9-8833-fca4-94f990c1f1f3@6wind.com>
 <CADvbK_c6gbV-F9Lv6aiT6JbGGJD96ExWxTj_SWerJsvwvzOoXQ@mail.gmail.com>
 <621ebebc-c73d-b707-3faf-c315e45cf4a4@6wind.com>
Organization: 6WIND
Message-ID: <2df6aeeb-bad8-e148-d5de-d7a30207cd4c@6wind.com>
Date:   Wed, 7 Oct 2020 17:40:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <621ebebc-c73d-b707-3faf-c315e45cf4a4@6wind.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 05/10/2020 à 17:11, Nicolas Dichtel a écrit :
> Le 03/10/2020 à 11:41, Xin Long a écrit :
> [snip]
>> When xfrmi processes the ipip packets, it does the state lookup and xfrmi
>> device lookup both in xfrm_input(). When either of them fails, instead of
>> returning err and continuing the next .handler in tunnel4_rcv(), it would
>> drop the packet and return 0.
>>
>> It's kinda the same as xfrm_tunnel_rcv() and xfrm6_tunnel_rcv().
>>
>> So the safe fix is to lower the priority of xfrmi .handler but it should
>> still be higher than xfrm_tunnel_rcv() and xfrm6_tunnel_rcv(). Having
>> xfrmi loaded will only break IPCOMP, and it's expected. I'll post a fix:
> Thanks. This patch fixes my test cases.
Do you think that you will have time to send the patch before the release (v5.9)
goes out?
If not, I can send it ;-)
