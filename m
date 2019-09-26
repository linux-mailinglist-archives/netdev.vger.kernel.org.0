Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C592BF714
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 18:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbfIZQqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 12:46:25 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:35762 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727525AbfIZQqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 12:46:24 -0400
Received: by mail-pg1-f180.google.com with SMTP id a24so1884087pgj.2
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 09:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SUwW/Chjrvs00GAvTlzF6awFlxdf73MExm8LjS+2PO8=;
        b=g6sj3kl4QhdcoGIr5E8ElyDrLS7ODXMFfm2EyAB4spLlRI6vN9K/VVZHcQt9kCgoO0
         4gWKie5na6YeTTCE2fQsI0PYXxrtEe3qwLT2Oxep45GDhNTgsYwQG3U7PBQ7u/wpen8N
         1TnAg2lveWtb6/WUpmnTwgekkHHxxz1QB9VmQSdTudFUQGilVzfi3PwUBTx9NP9gBuDI
         qp0v/vbcau82ruPsDT5IYsDH9411YtPmApb1TRW04TE5y6SmwA86G/QhoS8CcAkarNq3
         3x0YoO3SG3/gckbbGMnfFgl5TiYoVEjOwtB1e/xi8Vp6UkxNLUIl6j26G9nMMwoS9BQt
         o8cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SUwW/Chjrvs00GAvTlzF6awFlxdf73MExm8LjS+2PO8=;
        b=P68WbfBWyEOL3hHwW8Vv1Hh3S6RqJ/t2Vdca1McQ0QJKuCwhPHsX9V5pAtr20gFsym
         1ue/D7DrkK67ELEWCKSXa/1Xi7yb+ooL8X99PA4oPz2c3JN9MQe7t3Gn6WGJhwRp3O8C
         RDBX9uvF8Rq0/05bmipjDFjL1DxzbqABArweHUyJHSBf34GYJGuaK4ynzSVgDeoZxjgb
         Vui+978khjE/B+uPM4KXjpiT6BTmMh6VC9jb1on8Wz+lwB0Hp2qzUT1xzmmwQsYmtg1y
         9VrCHBO+c99lqTTEGr5zE8upxidk/Ft7krI3R7pTKFA4ohAN4D5tYYcrj2dOETpuEBxu
         ykFg==
X-Gm-Message-State: APjAAAWGzO8/dgRnXsyISSNto2g2/JDclSDxd816//A5cUFBxg+Rryyu
        bn/c1Uu81nDPE4ukfNmYX2oOLBm8
X-Google-Smtp-Source: APXvYqws7aVNgWO2lLyy7v4sPRkmteeTD1GJYgLk8rbeMA7FjUHrDUooQnz0U2jszu8g8iiLd67fqA==
X-Received: by 2002:a63:505:: with SMTP id 5mr4205872pgf.297.1569516383383;
        Thu, 26 Sep 2019 09:46:23 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id g202sm4248620pfb.155.2019.09.26.09.46.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 09:46:21 -0700 (PDT)
Subject: Re: TCP_USER_TIMEOUT, SYN-SENT and tcp_syn_retries
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Marek Majkowski <marek@cloudflare.com>, netdev@vger.kernel.org
References: <CAJPywTL0PiesEwiRWHdJr0Te_rqZ62TXbgOtuz7NTYmQksE_7w@mail.gmail.com>
 <c682fe41-c5ee-83b9-4807-66fcf76388a4@gmail.com>
Message-ID: <61e4c437-cb1e-bcd6-b978-e5317d1e76c3@gmail.com>
Date:   Thu, 26 Sep 2019 09:46:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <c682fe41-c5ee-83b9-4807-66fcf76388a4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/26/19 8:05 AM, Eric Dumazet wrote:
> 
> 
> On 9/25/19 1:46 AM, Marek Majkowski wrote:
>> Hello my favorite mailing list!
>>
>> Recently I've been looking into TCP_USER_TIMEOUT and noticed some
>> strange behaviour on fresh sockets in SYN-SENT state. Full writeup:
>> https://blog.cloudflare.com/when-tcp-sockets-refuse-to-die/
>>
>> Here's a reproducer. It does a simple thing: sets TCP_USER_TIMEOUT and
>> does connect() to a blackholed IP:
>>
>> $ wget https://gist.githubusercontent.com/majek/b4ad53c5795b226d62fad1fa4a87151a/raw/cbb928cb99cd6c5aa9f73ba2d3bc0aef22fbc2bf/user-timeout-and-syn.py
>>
>> $ sudo python3 user-timeout-and-syn.py
>> 00:00.000000 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
>> 00:01.007053 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
>> 00:03.023051 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
>> 00:05.007096 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
>> 00:05.015037 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
>> 00:05.023020 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
>> 00:05.034983 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
>>
>> The connect() times out with ETIMEDOUT after 5 seconds - as intended.
>> But Linux (5.3.0-rc3) does something weird on the network - it sends
>> remaining tcp_syn_retries packets aligned to the 5s mark.
>>
>> In other words: with TCP_USER_TIMEOUT we are sending spurious SYN
>> packets on a timeout.
>>
>> For the record, the man page doesn't define what TCP_USER_TIMEOUT does
>> on SYN-SENT state.
>>
> 
> Exactly, so far this option has only be used on established flows.
> 
> Feel free to send patches if you need to override the stack behavior
> for connection establishment (Same remark for passive side...)

Also please take a look at TCP_SYNCNT,  which predates TCP_USER_TIMEOUT


