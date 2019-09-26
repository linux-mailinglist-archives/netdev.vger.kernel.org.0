Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9625CBF57E
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 17:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfIZPFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 11:05:33 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:38577 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfIZPFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 11:05:32 -0400
Received: by mail-pl1-f176.google.com with SMTP id w10so1440193plq.5
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 08:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Tl2stXRIMziFwW9iQ7WAC41X/iVuzuTIlWX9KsGSYPI=;
        b=uSTuJPbAX4XJzzr8soOQhOnM5uKVdmBaTiKtMhNHln8FyiQHXBF3FZ4UYY3/N3fOKY
         tWUQ69QKHWsScQiArNzAuzLLU91Z4FNgC0MXkkfbtW2ziQvl2IEZnPceHCXIih0GcuXS
         W/6CvnWIoFxw2G+sE0XR900ecXEHnfz8sCg85vDaAgi8PIFlrQrncEN4og/Nn8MzjtX6
         VIx2dSLYSIZ/QPVl3zu6BNsHkvgg2DbxMM4SuRA2Kj8MGcv22DJc4+WvFVgUFswHAHEP
         /66Y8q8J2NaKWpAaFi0t6Y7SqylkMfKKo/V3/jCeQnpkqDUvSGwatKnlayX5zR5bOlKb
         gaTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tl2stXRIMziFwW9iQ7WAC41X/iVuzuTIlWX9KsGSYPI=;
        b=lYPuCxNinIHjovxC6WjqMu3JXGWlKGG8iVYs5c91cnbffXL/CL0LnaaArH5J8Eeupp
         YK5UHfPh6J6BdABiCVxnVe3bOr7dwG+NNLECKJJtZiY6M4xcPtmZ6XQ0GJLf4QaKmCqJ
         LIXmJxsH7XIGbYF46dyLHiux76zrph1FyJ+7YlIsPX9UkO5i5807XsL4uWTeA18oZHl2
         nYJVksfUAQFezummj0mFl+7hBXdZgnF1etaSVT5cOMpPNPD3EACEkf81SMVQVbSXWExm
         +yd4fEZwhD+WHCrt37xriwsJj3a+pF3Sye4tPxnlwWelyh5UoW9xnetMeu4T1AFflDtv
         7ikw==
X-Gm-Message-State: APjAAAUkQNN9gxHjW5irsmUdZu6IE5pwWiK4BVWrIM3mArXwmz59xGWh
        Pv+eZdznAr7clKYngR7NPiM7KclX
X-Google-Smtp-Source: APXvYqzv1ktKJUQOeT4fSSN+pV1T2g9sQBpvHLBdlvu/la/pNVKRBmukGhd1jhcXGIv6qr6sC1EPVQ==
X-Received: by 2002:a17:902:7b8f:: with SMTP id w15mr1657159pll.247.1569510330785;
        Thu, 26 Sep 2019 08:05:30 -0700 (PDT)
Received: from [192.168.88.45] (189.8.197.35.bc.googleusercontent.com. [35.197.8.189])
        by smtp.gmail.com with ESMTPSA id l7sm2271195pjy.12.2019.09.26.08.05.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 08:05:30 -0700 (PDT)
Subject: Re: TCP_USER_TIMEOUT, SYN-SENT and tcp_syn_retries
To:     Marek Majkowski <marek@cloudflare.com>, netdev@vger.kernel.org
References: <CAJPywTL0PiesEwiRWHdJr0Te_rqZ62TXbgOtuz7NTYmQksE_7w@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c682fe41-c5ee-83b9-4807-66fcf76388a4@gmail.com>
Date:   Thu, 26 Sep 2019 08:05:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAJPywTL0PiesEwiRWHdJr0Te_rqZ62TXbgOtuz7NTYmQksE_7w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/25/19 1:46 AM, Marek Majkowski wrote:
> Hello my favorite mailing list!
> 
> Recently I've been looking into TCP_USER_TIMEOUT and noticed some
> strange behaviour on fresh sockets in SYN-SENT state. Full writeup:
> https://blog.cloudflare.com/when-tcp-sockets-refuse-to-die/
> 
> Here's a reproducer. It does a simple thing: sets TCP_USER_TIMEOUT and
> does connect() to a blackholed IP:
> 
> $ wget https://gist.githubusercontent.com/majek/b4ad53c5795b226d62fad1fa4a87151a/raw/cbb928cb99cd6c5aa9f73ba2d3bc0aef22fbc2bf/user-timeout-and-syn.py
> 
> $ sudo python3 user-timeout-and-syn.py
> 00:00.000000 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
> 00:01.007053 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
> 00:03.023051 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
> 00:05.007096 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
> 00:05.015037 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
> 00:05.023020 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
> 00:05.034983 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
> 
> The connect() times out with ETIMEDOUT after 5 seconds - as intended.
> But Linux (5.3.0-rc3) does something weird on the network - it sends
> remaining tcp_syn_retries packets aligned to the 5s mark.
> 
> In other words: with TCP_USER_TIMEOUT we are sending spurious SYN
> packets on a timeout.
> 
> For the record, the man page doesn't define what TCP_USER_TIMEOUT does
> on SYN-SENT state.
> 

Exactly, so far this option has only be used on established flows.

Feel free to send patches if you need to override the stack behavior
for connection establishment (Same remark for passive side...)

Thanks.

