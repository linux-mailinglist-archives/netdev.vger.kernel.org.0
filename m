Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C93D25719F
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 03:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgHaBoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 21:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbgHaBoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 21:44:04 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0240C061573;
        Sun, 30 Aug 2020 18:44:03 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mw10so2165906pjb.2;
        Sun, 30 Aug 2020 18:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s5fICNS0zNIOQPt5M3FsAOhvE6sEqhTnd74/gVQE0QU=;
        b=Nekyqlzbgpda2B5CIdl6RC6vQXhQ5y08IGWy6M4jgJnIUGEn9nuuuckxYAwXqMXjrI
         DTxP0kyXO7qv/en3DTR5vgQH8IqoMg/HY0xB4+QXe0AyQnvJkq5DabcmYRqjm35X2U1V
         srUn4WLSxsZ7+oV0osGjG8iEflCDYT2SHPCzSIMniaGCkE+Mni5RJ+xBIqwVr9H3ou+X
         Syq5aPBToACIug8RaERVejosBOUZLrNOAOQGS/753yp0qTK+6TkyMXrCqen+XHBkNgfC
         ETZ9vFoGZuCJDBjxFCIGxcNN8s5fuWMJS1BmHfrVTLUdX27Snhkk5PBxatKHGaZ7EO8L
         YObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s5fICNS0zNIOQPt5M3FsAOhvE6sEqhTnd74/gVQE0QU=;
        b=t86mjmBowt7Ku8w2U1sEUd+7GuZwA7kewOncYUYatOLJwObpUwkD+YPQaQClBX8Qpn
         ChAkahKfK0jzMydK1Y1Bhv+ByW8EoJp7Fn1jFyqRneNhKNc6mIb/i873MujG7+4ks0EY
         QVrsesKU1nTXaD8OxCy8GsNTbAFrUzrtozjY/akKl61js3zKf3bCjn4aSWag/J0jQVNe
         DFd4Wxoas89sG1JmXfJIDZx0bdDsM5ui1jY33PrM85AOufCPWo30uiVCwtSZKpVL3YCe
         wJpmLWuNWSR7F9XGX6u7b1RnqrEc2BED4990OiuV73KbHVIaKsY9zFJKG+30wvoh1l5s
         hYdg==
X-Gm-Message-State: AOAM532sCKBO+T2A0We93btS0QhU+OLG0iYCbFIxG9ht04Ru5VAq127l
        Qsc4P/0OxvQ1C6/wFS7RZ26V4psThxU=
X-Google-Smtp-Source: ABdhPJzYvXWL2X8/p8anhxt5xGAB3WckC74E1GywIAHwh8uwxUQGPIUbXW7d5MXfp00qeQIOZM8lGw==
X-Received: by 2002:a17:902:c085:: with SMTP id j5mr7000594pld.39.1598838242151;
        Sun, 30 Aug 2020 18:44:02 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id l145sm6305224pfd.45.2020.08.30.18.44.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Aug 2020 18:44:01 -0700 (PDT)
Subject: Re: [PATCH] veth: fix memory leak in veth_newlink()
To:     Rustam Kovhaev <rkovhaev@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
References: <20200830131336.275844-1-rkovhaev@gmail.com>
 <32e30526-bcc9-1f2f-1250-f36687561fbb@gmail.com>
 <20200831005133.GA3295@thinkpad>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <01c8fa29-8bda-ccae-b7fb-8df85992b437@gmail.com>
Date:   Mon, 31 Aug 2020 10:43:57 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200831005133.GA3295@thinkpad>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/08/31 9:51, Rustam Kovhaev wrote:
> On Mon, Aug 31, 2020 at 09:16:32AM +0900, Toshiaki Makita wrote:
>> On 2020/08/30 22:13, Rustam Kovhaev wrote:
>>> when register_netdevice(dev) fails we should check whether struct
>>> veth_rq has been allocated via ndo_init callback and free it, because,
>>> depending on the code path, register_netdevice() might not call
>>> priv_destructor() callback
>>
>> AFAICS, register_netdevice() always goto err_uninit and calls priv_destructor()
>> on failure after ndo_init() succeeded.
>> So I could not find such a code path.
>> Would you elaborate on it?
> 
> in net/core/dev.c:9863, where register_netdevice() calls rollback_registered(),
> which does not call priv_destructor(), then register_netdevice() returns error
> net/core/dev.c:9884

Thank you, now I see the code path.
But then all devices which allocate something in ndo_init() and free them in
priv_destructor() are affected? E.g. loopback and ifb seem to do such thing.
Why not calling priv_destructor() after invocation of rollback_registered()?
It looks weird that only that path does not call priv_destructor().

Toshiaki Makita
