Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA92BF8FE
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 20:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbfIZSPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 14:15:12 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46821 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727919AbfIZSPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 14:15:11 -0400
Received: by mail-pg1-f193.google.com with SMTP id a3so1950263pgm.13
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 11:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WLVX4R9dhruFBwzh0l/Up7crMZVq0XyDdk7d8vVULMM=;
        b=FNFCwp5YJPZZrEUs/3R+sU/gS0KfwW4YuK4sZ7JAp3aWRtPh5v7TZeVSm9P2DYzyhy
         vNz1kiEeokpb7NcmTmL4hDeJBCus+0nALzy15AVvMy1CUh+ahN12CnajGtdF3vfS+84F
         bokiNspm0100x9Eh9qeauv+ESNHwrjRMquiHldO0zc0p0MOqaCRQ/aizOJs+EyQGQfnz
         b4f/C4T6ZQhjiCS/ebh9sOEAeWxvm094CNBBdcIVjYqyzuC9Kv8oxUClbHUwgj2ExlrD
         YL3NA8VcjMQVXZzUZeXD8UidNA4fnJPbkP6AdzaRW0qoqK2Fzh4jzMqK+v28pUbtuF1J
         eF5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WLVX4R9dhruFBwzh0l/Up7crMZVq0XyDdk7d8vVULMM=;
        b=lvpNLD10eGF2GD/hvrFZ9N98Zwn1kOEKJKptYDdZzrSUPvit1XBo4Y5DTW3xlI2vzT
         xryb2Zh3aAUadl6yKpMCbwtNRX93CMSvCdXn0MCnTwa9ZmfX7XCFGpbVza//fx0nrWMJ
         5NHE8gdVc9twtkhJrhd9+irH9jn8tdWPdZQNUWAjxIsrd40i3XAnaX1qFZZVUOhFFZjz
         Hw5tCgNoHo6Qqbpcii/xC8YUqkYXo+ULd8bgPWCFOYZ0Sw1KAPDxOftad14xqgh1SeKI
         06/kIhcLpwmplqYqWKUOIaDEVWbe9zBwAuku51CgTkr/CdBNVNnqTo1QwRO6UPQPLj4X
         eD4A==
X-Gm-Message-State: APjAAAWem/B/lgFiK1eNj7IpTW9hzjD13U4jGFavzlncTDOORvsNAHo5
        RQknTNs0pzsh7AvXCfgdUfI=
X-Google-Smtp-Source: APXvYqzgGLaO4rQ43bJNzwdMBQk29bSgOuDJu9LqD7iuStP6JmB+q9Vlq/noaganjI8xGSNToQd51Q==
X-Received: by 2002:a62:7c47:: with SMTP id x68mr5284218pfc.178.1569521711340;
        Thu, 26 Sep 2019 11:15:11 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id v15sm3451423pfn.27.2019.09.26.11.15.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 11:15:10 -0700 (PDT)
Subject: Re: [PATCH net] sk_buff: drop all skb extensions on free and skb
 scrubbing
To:     Florian Westphal <fw@strlen.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, steffen.klassert@secunet.com,
        paulb@mellanox.com, vladbu@mellanox.com
References: <20190926141840.31952-1-fw@strlen.de>
 <76c10ba7-5fc8-e9e8-769f-fc4d5cada7a2@gmail.com>
 <20190926180609.GB9938@breakpoint.cc>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7ba415ed-5332-b01e-8c2e-8e4e65e2d520@gmail.com>
Date:   Thu, 26 Sep 2019 11:15:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190926180609.GB9938@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/26/19 11:06 AM, Florian Westphal wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>> +static inline void skb_ext_reset(struct sk_buff *skb)
>>> +{
>>> +	if (skb->active_extensions) {
>>
>> This deserves an unlikely(skb->active_extensions) hint here ?
> 
> unlikely() isn't used in the other helpers (e.g. skb_ext_{put,del,copy}
> either, should I add it there too?
> 

At least in GRO paths unlikely() makes sense.

For other paths it might not be the case.
