Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2B2754D37
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 13:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730277AbfFYLG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 07:06:58 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37280 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730028AbfFYLG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 07:06:58 -0400
Received: by mail-qk1-f195.google.com with SMTP id d15so12184626qkl.4
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 04:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v9S+EOmNcUXRrGjNn2Sv/m2GVrjpg3onsj1s7RcBoZM=;
        b=iuftpYJEjZ064//Z4zse81SRmw3hm7aWTINc/EhYV9rWzjSYnODWTrpsGPZZNeK8su
         rMR8k4TxBsr+aBTFJFUvMQ4GZSxrJ6Z7dL37Qi1wnhaazm6D6nEeAbTu3qEkjwjkbkqY
         TGnjx6t+Ev6o6qSs9JmNJ/DNaja2wSJIqWZ8PdqXF3Zl8Qe7uWVAddbgYn+v0WCL+7Oc
         3xNYcoDIzjrRDeEx8GnCeHaMkwohLw7fC80pQSXeWUbskSXjxGehb0E2O4nCTqjFTTMK
         ckVTetnkXfKFMYaXE7Xcc7N/VmT7SRt1UfM+Ss42f4ipgKpbU7igM25IStgjw0PNEEjl
         wJ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v9S+EOmNcUXRrGjNn2Sv/m2GVrjpg3onsj1s7RcBoZM=;
        b=KMzrvkbGlOye2Viw90/e+D1/wAjfLz+1gdlbZr4Meq6uWMRTRVEDrCkZyhKtrYWZLH
         QXQOmkPXTumaTjAe368PmTUcUTNODZpXzdOuM0xCJ9Eo5GFn3/jH/d3BxaSdkdn2d9B7
         3MtY7n+LHNW3o3Gwfvrm/7ukMyk2+perFduxtgoyPWlxdJ0Ciw/8lubFlMFEhCh1LQcq
         YFUUst5E8RbR5rKwWfCg3BlA5/o7O/yz3E9N9WIv2pXrgH5uzejj605Mrb8iByDa7Tmx
         Rf+T/Wo+FXcWVA2Z5RCflIjT2r+fywm7KNQmwmWChjCzOBBHLsi8wc3d+98D27iHo56h
         dDng==
X-Gm-Message-State: APjAAAWWURmErniMlJecg0w6qBG4bGmP6IuMKIv6hkM4btYXw/A31BDX
        WXKlZWnVm1ENtdsrwL/fMo851g==
X-Google-Smtp-Source: APXvYqy3WybT+tAqFcJG2018tFrdeQb0V26aGZ6e3FIxNG/SRgsIEhIRaeIKyspum/lDK3RULVqepg==
X-Received: by 2002:ae9:ef47:: with SMTP id d68mr22536437qkg.225.1561460817421;
        Tue, 25 Jun 2019 04:06:57 -0700 (PDT)
Received: from [192.168.0.124] (24-212-162-241.cable.teksavvy.com. [24.212.162.241])
        by smtp.googlemail.com with ESMTPSA id z18sm7499626qka.12.2019.06.25.04.06.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 04:06:56 -0700 (PDT)
Subject: Re: Removing skb_orphan() from ip_rcv_core()
To:     Joe Stringer <joe@wand.net.nz>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        netdev <netdev@vger.kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <CAOftzPisP-3jN8drC6RXcTigXJjdwEnvTRvTHR-Kv4LKn4rhQQ@mail.gmail.com>
 <ab745372-35eb-8bb8-30a4-0e861af27ac2@mojatatu.com>
 <CAOftzPj_+6hfrb-FwU+E2P83RLLp6dtv0nJizSG1Fw7+vCgYwA@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <f69a7930-6e8a-d717-0aa4-a63ea6e7b5e0@mojatatu.com>
Date:   Tue, 25 Jun 2019 07:06:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAOftzPj_+6hfrb-FwU+E2P83RLLp6dtv0nJizSG1Fw7+vCgYwA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-06-24 11:26 p.m., Joe Stringer wrote:
[..]
> 
> I haven't got as far as UDP yet, but I didn't see any need for a
> dependency on netfilter.

I'd be curious to see what you did. My experience, even for TCP is
the socket(transparent/tproxy) lookup code (to set skb->sk either
listening or established) is entangled in
CONFIG_NETFILTER_SOMETHING_OR_OTHER. You have to rip it out of
there (in the tproxy tc action into that  code). Only then can you
compile out netfilter.
I didnt bother to rip out code for udp case.
i.e if you needed udp to work with the tc action,
youd have to turn on NF. But that was because we had
no need for udp transparent proxying.
IOW:
There is really no reason, afaik, for tproxy code to only be
accessed if netfilter is compiled in. Not sure i made sense.

cheers,
jamal
