Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D36285880
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 08:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgJGGLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 02:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgJGGLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 02:11:14 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565FCC061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 23:11:14 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id i12so1211508ota.5
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 23:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ORlidC4idDydY7R0taRKctdp4cTrUV05KmlPutmBG3w=;
        b=vdrBJT7SfYluS0eoADhbgFNn2jpYagrnJMy1abNpnto7Bl0DEQ/DaV1q+43Xqwu0mw
         HXyD1Y+6+V9jNkoAkV1x9yHNDCZfpscn1bH3xaCELvWq28AWBcFwl9MMTzNii8tMT345
         EsL0MePnA8z2bTptVhfLK7Vll9SY9EUMCccYIEQrKTt4v/+GU4NQtjoqhByturiy3dlG
         4L1Uv6ZTIHXla0jB5BM2bDGQVh1QXRLpI56chqIgtzGpl9s1hAdzhibBEKG+AYgVtoJc
         DPvEu1vNzyEjaxxYEgyFboP8RGCmrXqYxDypue3bc++1f6krSZ6jjYXs9/JUCISc320R
         IeNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ORlidC4idDydY7R0taRKctdp4cTrUV05KmlPutmBG3w=;
        b=Gw256C6uhLOxToZyKFRxPww1VVxk8w59VbfKAn+GLEZwBeN04A2E8NdyH4xqYODUQU
         G424nVVNkxUMNHzLHWmGUHffyYP37+6w4Dku+qTq/g0xJY1lNvYdMW/rz2eigcrvtFy/
         UEXX/p0XTyvbp3Lx/8qSeznAmERHWPUrHKcK5w+hIy1poEa8lD0rA5ZMuhQP2RCk2EML
         8dloX9mz546qyOZ8ahMLdsQxASzzNhwqQqXL0TNyX6btjvQUY+uFVALuMDZD4cVnHYdZ
         oVU3qfpVGmLqSJ/YRBGiivSYQTEW/Q2vYsZKKmfoLiuHIc6awKxD/3odBtRP5tp8nkDj
         6XwQ==
X-Gm-Message-State: AOAM532uyp2hgwRPuozmId5Fr5MiLV9LrIJGzfao6JD5rYsRkAIOSvvz
        SQW0jFChIJHwJVQL8g8UA4m6cm8Tjju0Vg==
X-Google-Smtp-Source: ABdhPJy0AAC5NpzcLLeG9k20nxss/TkS/QOqneelx3PCGfXg5ZU2IvOljoQDzlBVK89N9FEufK8GOw==
X-Received: by 2002:a9d:7dc9:: with SMTP id k9mr938814otn.37.1602051073645;
        Tue, 06 Oct 2020 23:11:13 -0700 (PDT)
Received: from Davids-MBP.attlocal.net ([2600:1700:3eca:200:4df6:ae94:ee53:9573])
        by smtp.googlemail.com with ESMTPSA id s13sm895189otq.5.2020.10.06.23.11.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2020 23:11:13 -0700 (PDT)
Subject: Re: [PATCH iproute2-net v2] ip xfrm: support setting
 XFRMA_SET_MARK_MASK attribute in states
To:     Antony Antony <antony@phenome.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20200930043748.GA14318@AntonyAntony.local>
 <20201002132238.GA36488@AntonyAntony.local>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <96499050-f8e9-532b-cbd7-f18ba96a651d@gmail.com>
Date:   Tue, 6 Oct 2020 23:11:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201002132238.GA36488@AntonyAntony.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/20 6:22 AM, Antony Antony wrote:
> The XFRMA_SET_MARK_MASK attribute can be set in states (4.19+)
> It is optional and the kernel default is 0xffffffff
> It is the mask of XFRMA_SET_MARK(a.k.a. XFRMA_OUTPUT_MARK in 4.18)
> 
> e.g.
> ./ip/ip xfrm state add output-mark 0x6 mask 0xab proto esp \
>  auth digest_null 0 enc cipher_null ''
> ip xfrm state
> src 0.0.0.0 dst 0.0.0.0
> 	proto esp spi 0x00000000 reqid 0 mode transport
> 	replay-window 0
> 	output-mark 0x6/0xab
> 	auth-trunc digest_null 0x30 0
> 	enc ecb(cipher_null)
> 	anti-replay context: seq 0x0, oseq 0x0, bitmap 0x00000000
> 	sel src 0.0.0.0/0 dst 0.0.0.0/0
> 
> Signed-off-by: Antony Antony <antony@phenome.org>
> ---
>  v1 -> v2
>   - add man page and usage for mask
> --
>  ip/xfrm_state.c    | 23 ++++++++++++++++++-----
>  man/man8/ip-xfrm.8 |  4 +++-
>  2 files changed, 21 insertions(+), 6 deletions(-)
> 
applied to iproute2-next. Thanks


