Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6950F180311
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 17:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgCJQTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 12:19:22 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:38103 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbgCJQTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 12:19:21 -0400
Received: by mail-pf1-f181.google.com with SMTP id z5so1825781pfn.5
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 09:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fZ/+3HJzkZnPa6K+dn0ykQTQmf5wdRVwROVNShQXqCw=;
        b=KsvVJO4X1otdaLJ0q6n/cOBa3L6o+skxwyVR/ZUE7J7VeyycwEC+kJwOh5F1GbLe4p
         oK5VbxID44P8V3OxdBekPG5WnhCpptkQKaDG0POQ4YKDOV5KpyStT7NfO5aTJoYOBLh4
         rbAo6NPw54hlFmwC52stuUgzGdBKpPyMfQjh4rtd/yQNKUMJbfV62bnYGpcXhY33Ygsn
         FVKPrtGsge7qt+eq+yjqEhn3s2SR1ZKL9lsfasmNrzIFohCNsXcTba7bOVqWyayQMxFD
         Auiprrt4PS6+JQloosmWZwhB+XsjcvaGzTvrKLwH4IEAgEGMcuruJnpk+/KFlPgJYRAp
         JzbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fZ/+3HJzkZnPa6K+dn0ykQTQmf5wdRVwROVNShQXqCw=;
        b=G+AkinN9+Jg2ysv1bZ+wnDOO0jBtg04BFxviRcLFbU4QDArTGw3vbS+4fZKtGwfxKr
         1+0t5MkmwaskaQLr9H3XJ7mOkBNJmn8nxR6pGnRsEJ1L3QhD0rwuiEAC9E4ECbKVK9Ff
         4EYNly63WElrKh+Xv7ddRtUtcm+rR4TQQIulWlkqozxUdU/lXnh9ld+NUl02SKTaivyN
         tdoToMhm1w1CkN9WNJRnvjuQ9Yv720Daxrls7+MBbWV4bEHf+JNxOpcXyQw82HaXOhMd
         Q6wUBGu/r///mHF6nA4+3/PuXJGP+xSjin4DHYRchfbBJ1sL9iL77xkFFVuwTaiNAbax
         xmFw==
X-Gm-Message-State: ANhLgQ2lmygM/9qGZj35sGHUwNRnAZTFEMKN25R7e1ki+3WADGdbM9XC
        rkICDbooOvYb2BcdIRpTieYF/GQR
X-Google-Smtp-Source: ADFU+vuVI087/S+X/mHiLyYj0FTyZYbnn3kW70y+gnKrlGVBaUJ9ngLuKwAgjUx+xqQOrBqmvHpPxQ==
X-Received: by 2002:a63:f757:: with SMTP id f23mr21726407pgk.223.1583857158885;
        Tue, 10 Mar 2020 09:19:18 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id q20sm5605017pfh.89.2020.03.10.09.19.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 09:19:16 -0700 (PDT)
Subject: Re: TCP receive failure
To:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org
Cc:     Martin Pohlack <mpohlack@amazon.de>
References: <3748be15d31f71c6534f344b0c78f48fc4e3db21.camel@infradead.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <abe4f3a8-956a-6024-80f5-349c640fa48d@gmail.com>
Date:   Tue, 10 Mar 2020 09:19:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <3748be15d31f71c6534f344b0c78f48fc4e3db21.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/10/20 2:40 AM, David Woodhouse wrote:
> I'm chasing a problem which was reported to me as an OpenConnect packet
> loss, with downloads stalling until curl times out and aborts.
> 
> I can't see a transport problem though; I think I see TCP on the
> receive side misbehaving. This is an Ubuntu 5.3.x client kernel
> (5.3.0-40-generic #32~18.04.1-Ubuntu) which I think is 5.3.18?
> 
> The test is just downloading a large file full of zeroes. The problem
> starts with a bit of packet loss and a 40ms time warp:
> 
> 19:14:02.643175 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735738493, win 24576, options [nop,nop,TS val 2290571884 ecr 653279830], length 0
> 19:14:02.644536 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735738493:1735739691, ack 366489597, win 235, options [nop,nop,TS val 653279830 ecr 2290571824], length 1198: HTTP
> 19:14:02.645054 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735739691:1735740889, ack 366489597, win 235, options [nop,nop,TS val 653279830 ecr 2290571824], length 1198: HTTP
> 19:14:02.645089 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735740889, win 24576, options [nop,nop,TS val 2290571885 ecr 653279830], length 0
> 19:14:02.645787 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735740889:1735742087, ack 366489597, win 235, options [nop,nop,TS val 653279831 ecr 2290571826], length 1198: HTTP
> 19:14:02.645794 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735742087:1735743285, ack 366489597, win 235, options [nop,nop,TS val 653279831 ecr 2290571826], length 1198: HTTP
> 19:14:02.645802 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735743285, win 24576, options [nop,nop,TS val 2290571886 ecr 653279831], length 0
> 19:14:02.646153 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735743285:1735744483, ack 366489597, win 235, options [nop,nop,TS val 653279831 ecr 2290571826], length 1198: HTTP
> 19:14:02.646159 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735744483:1735745681, ack 366489597, win 235, options [nop,nop,TS val 653279831 ecr 2290571826], length 1198: HTTP
> 19:14:02.646165 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735745681, win 24576, options [nop,nop,TS val 2290571887 ecr 653279831], length 0
> 19:14:02.647369 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735745681:1735746879, ack 366489597, win 235, options [nop,nop,TS val 653279831 ecr 2290571826], length 1198: HTTP
> 19:14:02.686487 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735831937:1735833135, ack 366489597, win 235, options [nop,nop,TS val 653279840 ecr 2290571867], length 1198: HTTP
> 19:14:02.686489 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735746879, win 24567, options [nop,nop,TS val 2290571927 ecr 653279831,nop,nop,sack 1 {1735831937:1735833135}], length 0
> 19:14:02.686741 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735833135:1735834333, ack 366489597, win 235, options [nop,nop,TS val 653279840 ecr 2290571867], length 1198: HTTP
> 19:14:02.686746 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735746879, win 24567, options [nop,nop,TS val 2290571927 ecr 653279831,nop,nop,sack 1 {1735831937:1735834333}], length 0
> 19:14:02.687333 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735834333:1735835531, ack 366489597, win 235, options [nop,nop,TS val 653279841 ecr 2290571867], length 1198: HTTP
> 19:14:02.687337 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735746879, win 24567, options [nop,nop,TS val 2290571928 ecr 653279831,nop,nop,sack 1 {1735831937:1735835531}], length 0
> 
> There follows a period of the server sending new data before it resends
> the missed part, while the client continues to grow its SACK region
> accordingly:
> 
> 19:14:02.687339 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735835531:1735836729, ack 366489597, win 235, options [nop,nop,TS val 653279841 ecr 2290571867], length 1198: HTTP
> 19:14:02.688344 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735746879, win 24567, options [nop,nop,TS val 2290571928 ecr 653279831,nop,nop,sack 1 {1735831937:1735836729}], length 0
> 19:14:02.689035 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735836729:1735837927, ack 366489597, win 235, options [nop,nop,TS val 653279841 ecr 2290571869], length 1198: HTTP
> 19:14:02.690074 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735746879, win 24567, options [nop,nop,TS val 2290571929 ecr 653279831,nop,nop,sack 1 {1735831937:1735837927}], length 0
> 19:14:02.690409 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735837927:1735839125, ack 366489597, win 235, options [nop,nop,TS val 653279841 ecr 2290571869], length 1198: HTTP
> 19:14:02.691165 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735839125:1735840323, ack 366489597, win 235, options [nop,nop,TS val 653279842 ecr 2290571870], length 1198: HTTP
> 19:14:02.691167 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735840323:1735841521, ack 366489597, win 235, options [nop,nop,TS val 653279842 ecr 2290571870], length 1198: HTTP
> 19:14:02.691416 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735746879, win 24567, options [nop,nop,TS val 2290571932 ecr 653279831,nop,nop,sack 1 {1735831937:1735841521}], length 0
> 19:14:02.693063 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735841521:1735842719, ack 366489597, win 235, options [nop,nop,TS val 653279842 ecr 2290571871], length 1198: HTTP
> 19:14:02.693069 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735842719:1735843917, ack 366489597, win 235, options [nop,nop,TS val 653279842 ecr 2290571871], length 1198: HTTP
> 19:14:02.694109 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735746879, win 24567, options [nop,nop,TS val 2290571933 ecr 653279831,nop,nop,sack 1 {1735831937:1735843917}], length 0
> 19:14:02.695417 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735843917:1735845115, ack 366489597, win 235, options [nop,nop,TS val 653279843 ecr 2290571875], length 1198: HTTP
> 19:14:02.695969 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735845115:1735846313, ack 366489597, win 235, options [nop,nop,TS val 653279843 ecr 2290571875], length 1198: HTTP
> 19:14:02.696423 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735746879, win 24567, options [nop,nop,TS val 2290571936 ecr 653279831,nop,nop,sack 1 {1735831937:1735846313}], length 0
> 19:14:02.696555 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735846313:1735847511, ack 366489597, win 235, options [nop,nop,TS val 653279843 ecr 2290571876], length 1198: HTTP
> 19:14:02.696556 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735847511:1735848709, ack 366489597, win 235, options [nop,nop,TS val 653279843 ecr 2290571876], length 1198: HTTP
> 19:14:02.696870 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735848709:1735849907, ack 366489597, win 235, options [nop,nop,TS val 653279843 ecr 2290571876], length 1198: HTTP
> 19:14:02.696874 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735849907:1735851105, ack 366489597, win 235, options [nop,nop,TS val 653279843 ecr 2290571876], length 1198: HTTP
> 19:14:02.697562 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735746879, win 24567, options [nop,nop,TS val 2290571937 ecr 653279831,nop,nop,sack 1 {1735831937:1735851105}], length 0
> 19:14:02.698180 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735851105:1735852303, ack 366489597, win 235, options [nop,nop,TS val 653279843 ecr 2290571877], length 1198: HTTP
> 19:14:02.698184 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735852303:1735853501, ack 366489597, win 235, options [nop,nop,TS val 653279843 ecr 2290571877], length 1198: HTTP
> 19:14:02.698186 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735853501:1735854699, ack 366489597, win 235, options [nop,nop,TS val 653279843 ecr 2290571877], length 1198: HTTP
> 19:14:02.698765 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735854699:1735855897, ack 366489597, win 235, options [nop,nop,TS val 653279843 ecr 2290571877], length 1198: HTTP
> 19:14:02.699156 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735855897:1735857095, ack 366489597, win 235, options [nop,nop,TS val 653279844 ecr 2290571878], length 1198: HTTP
> 19:14:02.699159 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735857095:1735858293, ack 366489597, win 235, options [nop,nop,TS val 653279844 ecr 2290571878], length 1198: HTTP
> 19:14:02.699207 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735746879, win 24567, options [nop,nop,TS val 2290571940 ecr 653279831,nop,nop,sack 1 {1735831937:1735858293}], length 0
> 19:14:02.700513 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735858293:1735859491, ack 366489597, win 235, options [nop,nop,TS val 653279844 ecr 2290571880], length 1198: HTTP
> 19:14:02.700916 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735859491:1735860689, ack 366489597, win 235, options [nop,nop,TS val 653279844 ecr 2290571880], length 1198: HTTP
> 19:14:02.700920 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735860689:1735861887, ack 366489597, win 235, options [nop,nop,TS val 653279844 ecr 2290571881], length 1198: HTTP
> 19:14:02.701413 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735861887:1735863085, ack 366489597, win 235, options [nop,nop,TS val 653279844 ecr 2290571881], length 1198: HTTP
> 19:14:02.701417 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735863085:1735864283, ack 366489597, win 235, options [nop,nop,TS val 653279844 ecr 2290571881], length 1198: HTTP
> 19:14:02.701517 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735746879, win 24567, options [nop,nop,TS val 2290571942 ecr 653279831,nop,nop,sack 1 {1735831937:1735864283}], length 0
> 19:14:02.701891 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735864283:1735865481, ack 366489597, win 235, options [nop,nop,TS val 653279844 ecr 2290571881], length 1198: HTTP
> 19:14:02.702898 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735746879, win 24567, options [nop,nop,TS val 2290571942 ecr 653279831,nop,nop,sack 1 {1735831937:1735865481}], length 0
> 19:14:02.703202 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735865481:1735866679, ack 366489597, win 235, options [nop,nop,TS val 653279844 ecr 2290571881], length 1198: HTTP
> 19:14:02.703206 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735866679:1735867877, ack 366489597, win 235, options [nop,nop,TS val 653279844 ecr 2290571881], length 1198: HTTP
> 19:14:02.703207 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735867877:1735869075, ack 366489597, win 235, options [nop,nop,TS val 653279845 ecr 2290571882], length 1198: HTTP
> 19:14:02.703515 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735869075:1735870273, ack 366489597, win 235, options [nop,nop,TS val 653279845 ecr 2290571882], length 1198: HTTP
> 19:14:02.703519 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735870273:1735871471, ack 366489597, win 235, options [nop,nop,TS val 653279845 ecr 2290571884], length 1198: HTTP
> 19:14:02.704118 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735871471:1735872669, ack 366489597, win 235, options [nop,nop,TS val 653279845 ecr 2290571884], length 1198: HTTP
> 19:14:02.704122 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735872669:1735873867, ack 366489597, win 235, options [nop,nop,TS val 653279845 ecr 2290571884], length 1198: HTTP
> 19:14:02.704208 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735746879, win 24567, options [nop,nop,TS val 2290571945 ecr 653279831,nop,nop,sack 1 {1735831937:1735873867}], length 0
> 19:14:02.704540 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735873867:1735875065, ack 366489597, win 235, options [nop,nop,TS val 653279845 ecr 2290571884], length 1198: HTTP
> 19:14:02.705174 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735875065:1735876263, ack 366489597, win 235, options [nop,nop,TS val 653279845 ecr 2290571884], length 1198: HTTP
> 19:14:02.705178 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735876263:1735877461, ack 366489597, win 235, options [nop,nop,TS val 653279845 ecr 2290571884], length 1198: HTTP
> 19:14:02.705547 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735746879, win 24567, options [nop,nop,TS val 2290571946 ecr 653279831,nop,nop,sack 1 {1735831937:1735877461}], length 0
> 19:14:02.706356 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735877461:1735878659, ack 366489597, win 235, options [nop,nop,TS val 653279846 ecr 2290571885], length 1198: HTTP
> 19:14:02.706358 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735878659:1735879857, ack 366489597, win 235, options [nop,nop,TS val 653279846 ecr 2290571885], length 1198: HTTP
> 19:14:02.707362 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735746879, win 24567, options [nop,nop,TS val 2290571947 ecr 653279831,nop,nop,sack 1 {1735831937:1735879857}], length 0
> 19:14:02.707607 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735879857:1735881055, ack 366489597, win 235, options [nop,nop,TS val 653279846 ecr 2290571886], length 1198: HTTP
> 19:14:02.707999 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735881055:1735882253, ack 366489597, win 235, options [nop,nop,TS val 653279846 ecr 2290571886], length 1198: HTTP
> 19:14:02.708004 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735882253:1735883451, ack 366489597, win 235, options [nop,nop,TS val 653279846 ecr 2290571887], length 1198: HTTP
> 19:14:02.708437 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735883451:1735884649, ack 366489597, win 235, options [nop,nop,TS val 653279846 ecr 2290571887], length 1198: HTTP
> 19:14:02.708612 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735746879, win 24567, options [nop,nop,TS val 2290571949 ecr 653279831,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 
> At this point the server stops sending new data and goes back to fill
> in what was dropped, with the client sending immediate ACKs as it ramps
> up again:
> 
> 19:14:02.715902 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735746879:1735748077, ack 366489597, win 235, options [nop,nop,TS val 653279856 ecr 2290571927], length 1198: HTTP
> 19:14:02.715909 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735748077, win 24558, options [nop,nop,TS val 2290571956 ecr 653279856,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.715911 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735748077:1735749275, ack 366489597, win 235, options [nop,nop,TS val 653279856 ecr 2290571927], length 1198: HTTP
> 19:14:02.715913 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735749275, win 24549, options [nop,nop,TS val 2290571956 ecr 653279856,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.716262 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735749275:1735750473, ack 366489597, win 235, options [nop,nop,TS val 653279856 ecr 2290571927], length 1198: HTTP
> 19:14:02.716267 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735750473, win 24540, options [nop,nop,TS val 2290571957 ecr 653279856,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.716269 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735750473:1735751671, ack 366489597, win 235, options [nop,nop,TS val 653279856 ecr 2290571928], length 1198: HTTP
> 19:14:02.716270 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735751671, win 24531, options [nop,nop,TS val 2290571957 ecr 653279856,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.719424 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735751671:1735752869, ack 366489597, win 235, options [nop,nop,TS val 653279856 ecr 2290571928], length 1198: HTTP
> 19:14:02.719429 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735752869, win 24522, options [nop,nop,TS val 2290571960 ecr 653279856,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.719431 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735752869:1735754067, ack 366489597, win 235, options [nop,nop,TS val 653279857 ecr 2290571929], length 1198: HTTP
> 19:14:02.719432 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735754067, win 24513, options [nop,nop,TS val 2290571960 ecr 653279857,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.719742 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735754067:1735755265, ack 366489597, win 235, options [nop,nop,TS val 653279857 ecr 2290571932], length 1198: HTTP
> 19:14:02.719746 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735755265, win 24504, options [nop,nop,TS val 2290571960 ecr 653279857,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.720354 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735755265:1735756463, ack 366489597, win 235, options [nop,nop,TS val 653279857 ecr 2290571932], length 1198: HTTP
> 19:14:02.720358 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735756463, win 24495, options [nop,nop,TS val 2290571961 ecr 653279857,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.720360 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735756463:1735757661, ack 366489597, win 235, options [nop,nop,TS val 653279857 ecr 2290571932], length 1198: HTTP
> 19:14:02.720362 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735757661, win 24486, options [nop,nop,TS val 2290571961 ecr 653279857,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.723893 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735757661:1735758859, ack 366489597, win 235, options [nop,nop,TS val 653279858 ecr 2290571933], length 1198: HTTP
> 19:14:02.723897 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735758859, win 24477, options [nop,nop,TS val 2290571964 ecr 653279858,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.724490 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735758859:1735760057, ack 366489597, win 235, options [nop,nop,TS val 653279858 ecr 2290571933], length 1198: HTTP
> 19:14:02.724495 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735760057, win 24468, options [nop,nop,TS val 2290571965 ecr 653279858,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.727202 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735760057:1735761255, ack 366489597, win 235, options [nop,nop,TS val 653279858 ecr 2290571936], length 1198: HTTP
> 19:14:02.727208 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735761255, win 24459, options [nop,nop,TS val 2290571968 ecr 653279858,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.727210 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735761255:1735762453, ack 366489597, win 235, options [nop,nop,TS val 653279858 ecr 2290571936], length 1198: HTTP
> 19:14:02.727229 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735762453, win 24450, options [nop,nop,TS val 2290571968 ecr 653279858,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.728343 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735762453:1735763651, ack 366489597, win 235, options [nop,nop,TS val 653279858 ecr 2290571937], length 1198: HTTP
> 19:14:02.728349 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735763651, win 24441, options [nop,nop,TS val 2290571969 ecr 653279858,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.728957 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735763651:1735764849, ack 366489597, win 235, options [nop,nop,TS val 653279858 ecr 2290571937], length 1198: HTTP
> 19:14:02.728963 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735764849, win 24432, options [nop,nop,TS val 2290571969 ecr 653279858,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.728965 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735764849:1735766047, ack 366489597, win 235, options [nop,nop,TS val 653279858 ecr 2290571937], length 1198: HTTP
> 19:14:02.728968 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735766047, win 24423, options [nop,nop,TS val 2290571969 ecr 653279858,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.728970 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735766047:1735767245, ack 366489597, win 235, options [nop,nop,TS val 653279858 ecr 2290571937], length 1198: HTTP
> 19:14:02.728971 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735767245, win 24414, options [nop,nop,TS val 2290571969 ecr 653279858,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.729921 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735767245:1735768443, ack 366489597, win 235, options [nop,nop,TS val 653279859 ecr 2290571940], length 1198: HTTP
> 19:14:02.729924 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735768443, win 24405, options [nop,nop,TS val 2290571970 ecr 653279859,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.729928 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735768443:1735769641, ack 366489597, win 235, options [nop,nop,TS val 653279859 ecr 2290571940], length 1198: HTTP
> 19:14:02.729930 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735769641, win 24396, options [nop,nop,TS val 2290571970 ecr 653279859,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.729931 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735769641:1735770839, ack 366489597, win 235, options [nop,nop,TS val 653279859 ecr 2290571940], length 1198: HTTP
> 19:14:02.729934 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735770839, win 24387, options [nop,nop,TS val 2290571970 ecr 653279859,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.730126 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735770839:1735772037, ack 366489597, win 235, options [nop,nop,TS val 653279859 ecr 2290571940], length 1198: HTTP
> 19:14:02.730130 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735772037, win 24378, options [nop,nop,TS val 2290571971 ecr 653279859,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.730732 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735772037:1735773235, ack 366489597, win 235, options [nop,nop,TS val 653279859 ecr 2290571940], length 1198: HTTP
> 19:14:02.730738 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735773235, win 24369, options [nop,nop,TS val 2290571971 ecr 653279859,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.730740 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735773235:1735774433, ack 366489597, win 235, options [nop,nop,TS val 653279859 ecr 2290571940], length 1198: HTTP
> 19:14:02.730742 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735774433, win 24360, options [nop,nop,TS val 2290571971 ecr 653279859,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.731998 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735774433:1735775631, ack 366489597, win 235, options [nop,nop,TS val 653279859 ecr 2290571942], length 1198: HTTP
> 19:14:02.732003 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735775631, win 24351, options [nop,nop,TS val 2290571972 ecr 653279859,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.732005 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735775631:1735776829, ack 366489597, win 235, options [nop,nop,TS val 653279859 ecr 2290571942], length 1198: HTTP
> 19:14:02.732028 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735776829, win 24342, options [nop,nop,TS val 2290571972 ecr 653279859,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.732416 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735776829:1735778027, ack 366489597, win 235, options [nop,nop,TS val 653279859 ecr 2290571942], length 1198: HTTP
> 19:14:02.732439 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735778027, win 24333, options [nop,nop,TS val 2290571973 ecr 653279859,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.732441 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735778027:1735779225, ack 366489597, win 235, options [nop,nop,TS val 653279859 ecr 2290571942], length 1198: HTTP
> 19:14:02.732444 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735779225, win 24324, options [nop,nop,TS val 2290571973 ecr 653279859,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.732445 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735779225:1735780423, ack 366489597, win 235, options [nop,nop,TS val 653279859 ecr 2290571942], length 1198: HTTP
> 19:14:02.732449 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735780423, win 24315, options [nop,nop,TS val 2290571973 ecr 653279859,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.733727 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735780423:1735781621, ack 366489597, win 235, options [nop,nop,TS val 653279860 ecr 2290571942], length 1198: HTTP
> 19:14:02.733733 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735781621, win 24306, options [nop,nop,TS val 2290571974 ecr 653279860,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.734448 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735781621:1735782819, ack 366489597, win 235, options [nop,nop,TS val 653279860 ecr 2290571945], length 1198: HTTP
> 19:14:02.734468 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735782819, win 24297, options [nop,nop,TS val 2290571975 ecr 653279860,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.734472 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735782819:1735784017, ack 366489597, win 235, options [nop,nop,TS val 653279860 ecr 2290571945], length 1198: HTTP
> 19:14:02.734481 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735784017, win 24288, options [nop,nop,TS val 2290571975 ecr 653279860,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.734812 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735784017:1735785215, ack 366489597, win 235, options [nop,nop,TS val 653279860 ecr 2290571945], length 1198: HTTP
> 19:14:02.734833 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735785215, win 24279, options [nop,nop,TS val 2290571975 ecr 653279860,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.735263 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735785215:1735786413, ack 366489597, win 235, options [nop,nop,TS val 653279860 ecr 2290571945], length 1198: HTTP
> 19:14:02.735271 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735786413, win 24270, options [nop,nop,TS val 2290571976 ecr 653279860,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.735273 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735786413:1735787611, ack 366489597, win 235, options [nop,nop,TS val 653279860 ecr 2290571945], length 1198: HTTP
> 19:14:02.735277 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735787611, win 24261, options [nop,nop,TS val 2290571976 ecr 653279860,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.735643 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735787611:1735788809, ack 366489597, win 235, options [nop,nop,TS val 653279860 ecr 2290571945], length 1198: HTTP
> 19:14:02.735662 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735788809, win 24252, options [nop,nop,TS val 2290571976 ecr 653279860,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.735666 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735788809:1735790007, ack 366489597, win 235, options [nop,nop,TS val 653279860 ecr 2290571945], length 1198: HTTP
> 19:14:02.735672 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735790007, win 24243, options [nop,nop,TS val 2290571976 ecr 653279860,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.735675 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735790007:1735791205, ack 366489597, win 235, options [nop,nop,TS val 653279860 ecr 2290571946], length 1198: HTTP
> 19:14:02.735683 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735791205, win 24234, options [nop,nop,TS val 2290571976 ecr 653279860,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.735830 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735791205:1735792403, ack 366489597, win 235, options [nop,nop,TS val 653279860 ecr 2290571946], length 1198: HTTP
> 19:14:02.735839 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735792403, win 24225, options [nop,nop,TS val 2290571976 ecr 653279860,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.735842 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735792403:1735793601, ack 366489597, win 235, options [nop,nop,TS val 653279860 ecr 2290571946], length 1198: HTTP
> 19:14:02.735844 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735793601, win 24216, options [nop,nop,TS val 2290571976 ecr 653279860,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.739103 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735793601:1735794799, ack 366489597, win 235, options [nop,nop,TS val 653279862 ecr 2290571947], length 1198: HTTP
> 19:14:02.739120 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735794799, win 24207, options [nop,nop,TS val 2290571979 ecr 653279862,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.739123 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735794799:1735795997, ack 366489597, win 235, options [nop,nop,TS val 653279862 ecr 2290571947], length 1198: HTTP
> 19:14:02.739128 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735795997, win 24198, options [nop,nop,TS val 2290571980 ecr 653279862,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.739465 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735795997:1735797195, ack 366489597, win 235, options [nop,nop,TS val 653279862 ecr 2290571949], length 1198: HTTP
> 19:14:02.739477 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735797195, win 24189, options [nop,nop,TS val 2290571980 ecr 653279862,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.739494 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735797195:1735798393, ack 366489597, win 235, options [nop,nop,TS val 653279862 ecr 2290571949], length 1198: HTTP
> 19:14:02.739496 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735798393, win 24180, options [nop,nop,TS val 2290571980 ecr 653279862,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.739752 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735798393:1735799591, ack 366489597, win 235, options [nop,nop,TS val 653279862 ecr 2290571949], length 1198: HTTP
> 19:14:02.739775 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735799591, win 24171, options [nop,nop,TS val 2290571980 ecr 653279862,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:02.739780 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735799591:1735800789, ack 366489597, win 235, options [nop,nop,TS val 653279862 ecr 2290571949], length 1198: HTTP
> 19:14:02.739785 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735800789, win 24171, options [nop,nop,TS val 2290571980 ecr 653279862,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.013563 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735800789:1735801987, ack 366489597, win 235, options [nop,nop,TS val 653279931 ecr 2290571980], length 1198: HTTP
> 19:14:03.013576 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735801987, win 24171, options [nop,nop,TS val 2290572254 ecr 653279931,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.040855 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735801987:1735803185, ack 366489597, win 235, options [nop,nop,TS val 653279937 ecr 2290572254], length 1198: HTTP
> 19:14:03.040870 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735803185, win 24171, options [nop,nop,TS val 2290572281 ecr 653279937,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 
> Looks sane enough so far...
> 
> 19:14:03.041903 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735950539:1735951737, ack 366489597, win 235, options [nop,nop,TS val 653279937 ecr 2290572254], length 1198: HTTP
> 
> WTF? The server has never sent us anything past 1735884649 and now it's
> suddenly sending 1735950539? 


Just huge packet losses. Ask the sender to use BBR instead of cubic ;)

But OK, despite some confusing future
> packets which apparently get ignored (and make me wonder if I really
> understand what's going on here), the client is making progress because
> the server is *also* sending sensible packets, and the originally
> dropped segments are being recovered...
> 
> 19:14:03.068337 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735803185:1735804383, ack 366489597, win 235, options [nop,nop,TS val 653279944 ecr 2290572281], length 1198: HTTP
> 19:14:03.068363 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735804383, win 24171, options [nop,nop,TS val 2290572309 ecr 653279944,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.068546 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735951737:1735952935, ack 366489597, win 235, options [nop,nop,TS val 653279944 ecr 2290572281], length 1198: HTTP
> 19:14:03.095811 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735804383:1735805581, ack 366489597, win 235, options [nop,nop,TS val 653279951 ecr 2290572309], length 1198: HTTP
> 19:14:03.095835 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735805581, win 24171, options [nop,nop,TS val 2290572336 ecr 653279951,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.096203 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735805581:1735806779, ack 366489597, win 235, options [nop,nop,TS val 653279951 ecr 2290572309], length 1198: HTTP
> 19:14:03.096214 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735806779, win 24171, options [nop,nop,TS val 2290572337 ecr 653279951,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.096503 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735952935:1735954133, ack 366489597, win 235, options [nop,nop,TS val 653279951 ecr 2290572309], length 1198: HTTP
> 19:14:03.125018 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735806779:1735807977, ack 366489597, win 235, options [nop,nop,TS val 653279958 ecr 2290572336], length 1198: HTTP
> 19:14:03.125034 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735807977, win 24171, options [nop,nop,TS val 2290572365 ecr 653279958,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.125438 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735807977:1735809175, ack 366489597, win 235, options [nop,nop,TS val 653279958 ecr 2290572336], length 1198: HTTP
> 19:14:03.125448 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735809175, win 24171, options [nop,nop,TS val 2290572366 ecr 653279958,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.125805 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735954133:1735955331, ack 366489597, win 235, options [nop,nop,TS val 653279958 ecr 2290572336], length 1198: HTTP
> 19:14:03.126304 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735809175:1735810373, ack 366489597, win 235, options [nop,nop,TS val 653279958 ecr 2290572337], length 1198: HTTP
> 19:14:03.126314 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735810373, win 24171, options [nop,nop,TS val 2290572367 ecr 653279958,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.126685 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735955331:1735956529, ack 366489597, win 235, options [nop,nop,TS val 653279958 ecr 2290572337], length 1198: HTTP
> 19:14:03.152257 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735810373:1735811571, ack 366489597, win 235, options [nop,nop,TS val 653279965 ecr 2290572365], length 1198: HTTP
> 19:14:03.152272 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735811571, win 24171, options [nop,nop,TS val 2290572393 ecr 653279965,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.152640 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735811571:1735812769, ack 366489597, win 235, options [nop,nop,TS val 653279965 ecr 2290572365], length 1198: HTTP
> 19:14:03.152648 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735812769, win 24171, options [nop,nop,TS val 2290572393 ecr 653279965,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.152973 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735956529:1735957727, ack 366489597, win 235, options [nop,nop,TS val 653279965 ecr 2290572365], length 1198: HTTP
> 19:14:03.153341 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735812769:1735813967, ack 366489597, win 235, options [nop,nop,TS val 653279965 ecr 2290572366], length 1198: HTTP
> 19:14:03.153350 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735813967, win 24171, options [nop,nop,TS val 2290572394 ecr 653279965,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.153353 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735957727:1735958925, ack 366489597, win 235, options [nop,nop,TS val 653279965 ecr 2290572366], length 1198: HTTP
> 19:14:03.153905 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735813967:1735815165, ack 366489597, win 235, options [nop,nop,TS val 653279966 ecr 2290572367], length 1198: HTTP
> 19:14:03.153914 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735815165, win 24171, options [nop,nop,TS val 2290572394 ecr 653279966,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.154203 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735958925:1735960123, ack 366489597, win 235, options [nop,nop,TS val 653279966 ecr 2290572367], length 1198: HTTP
> 19:14:03.180246 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735815165:1735816363, ack 366489597, win 235, options [nop,nop,TS val 653279972 ecr 2290572393], length 1198: HTTP
> 19:14:03.180260 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735816363, win 24171, options [nop,nop,TS val 2290572421 ecr 653279972,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.180601 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735816363:1735817561, ack 366489597, win 235, options [nop,nop,TS val 653279972 ecr 2290572393], length 1198: HTTP
> 19:14:03.180613 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735817561, win 24171, options [nop,nop,TS val 2290572421 ecr 653279972,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.181029 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735817561:1735818759, ack 366489597, win 235, options [nop,nop,TS val 653279972 ecr 2290572393], length 1198: HTTP
> 19:14:03.181043 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735818759, win 24171, options [nop,nop,TS val 2290572421 ecr 653279972,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.181592 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735960123:1735961321, ack 366489597, win 235, options [nop,nop,TS val 653279972 ecr 2290572393], length 1198: HTTP
> 19:14:03.181917 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735818759:1735819957, ack 366489597, win 235, options [nop,nop,TS val 653279972 ecr 2290572393], length 1198: HTTP
> 19:14:03.181926 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735819957, win 24171, options [nop,nop,TS val 2290572422 ecr 653279972,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.181928 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735961321:1735962519, ack 366489597, win 235, options [nop,nop,TS val 653279972 ecr 2290572393], length 1198: HTTP
> 19:14:03.182208 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735819957:1735821155, ack 366489597, win 235, options [nop,nop,TS val 653279973 ecr 2290572394], length 1198: HTTP
> 19:14:03.182217 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735821155, win 24171, options [nop,nop,TS val 2290572423 ecr 653279973,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.182801 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735962519:1735963717, ack 366489597, win 235, options [nop,nop,TS val 653279973 ecr 2290572394], length 1198: HTTP
> 19:14:03.183210 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735821155:1735822353, ack 366489597, win 235, options [nop,nop,TS val 653279973 ecr 2290572394], length 1198: HTTP
> 19:14:03.183221 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735822353, win 24171, options [nop,nop,TS val 2290572424 ecr 653279973,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.183224 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735822353:1735823551, ack 366489597, win 235, options [nop,nop,TS val 653279973 ecr 2290572394], length 1198: HTTP
> 19:14:03.183228 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735823551, win 24171, options [nop,nop,TS val 2290572424 ecr 653279973,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.183578 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735963717:1735964915, ack 366489597, win 235, options [nop,nop,TS val 653279973 ecr 2290572394], length 1198: HTTP
> 19:14:03.209525 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735823551:1735824749, ack 366489597, win 235, options [nop,nop,TS val 653279979 ecr 2290572421], length 1198: HTTP
> 19:14:03.209535 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735824749, win 24171, options [nop,nop,TS val 2290572450 ecr 653279979,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.210042 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735824749:1735825947, ack 366489597, win 235, options [nop,nop,TS val 653279979 ecr 2290572421], length 1198: HTTP
> 19:14:03.210052 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735825947, win 24171, options [nop,nop,TS val 2290572450 ecr 653279979,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.210054 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735825947:1735827145, ack 366489597, win 235, options [nop,nop,TS val 653279979 ecr 2290572421], length 1198: HTTP
> 19:14:03.210057 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735827145, win 24162, options [nop,nop,TS val 2290572450 ecr 653279979,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.210520 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735964915:1735966113, ack 366489597, win 235, options [nop,nop,TS val 653279979 ecr 2290572421], length 1198: HTTP
> 19:14:03.210522 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735827145:1735828343, ack 366489597, win 235, options [nop,nop,TS val 653279979 ecr 2290572421], length 1198: HTTP
> 19:14:03.210529 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735828343, win 24171, options [nop,nop,TS val 2290572451 ecr 653279979,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.210532 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735828343:1735829541, ack 366489597, win 235, options [nop,nop,TS val 653279979 ecr 2290572421], length 1198: HTTP
> 19:14:03.210535 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735829541, win 24162, options [nop,nop,TS val 2290572451 ecr 653279979,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.210537 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735829541:1735830739, ack 366489597, win 235, options [nop,nop,TS val 653279979 ecr 2290572421], length 1198: HTTP
> 19:14:03.210541 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735830739, win 24153, options [nop,nop,TS val 2290572451 ecr 653279979,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 19:14:03.210765 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735966113:1735967311, ack 366489597, win 235, options [nop,nop,TS val 653279979 ecr 2290572421], length 1198: HTTP
> 19:14:03.211301 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735830739:1735831937, ack 366489597, win 235, options [nop,nop,TS val 653279980 ecr 2290572422], length 1198: HTTP
> 19:14:03.211316 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735884649, win 24171, options [nop,nop,TS val 2290572452 ecr 653279980], length 0
> 
> OK, now it's caught up. Client continues to ignore bogus future packets
> from the server, and doesn't even SACK them.
> 
> 19:14:03.211629 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735967311:1735968509, ack 366489597, win 235, options [nop,nop,TS val 653279980 ecr 2290572422], length 1198: HTTP
> 19:14:03.211896 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735884649:1735885847, ack 366489597, win 235, options [nop,nop,TS val 653279980 ecr 2290572423], length 1198: HTTP
> 19:14:03.212593 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735885847:1735887045, ack 366489597, win 235, options [nop,nop,TS val 653279980 ecr 2290572423], length 1198: HTTP
> 19:14:03.212878 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735887045:1735888243, ack 366489597, win 235, options [nop,nop,TS val 653279980 ecr 2290572423], length 1198: HTTP
> 19:14:03.212883 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735888243:1735889441, ack 366489597, win 235, options [nop,nop,TS val 653279980 ecr 2290572424], length 1198: HTTP
> 19:14:03.213395 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735889441:1735890639, ack 366489597, win 235, options [nop,nop,TS val 653279980 ecr 2290572424], length 1198: HTTP
> 19:14:03.213400 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735890639:1735891837, ack 366489597, win 235, options [nop,nop,TS val 653279980 ecr 2290572424], length 1198: HTTP
> 19:14:03.213402 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735891837:1735893035, ack 366489597, win 235, options [nop,nop,TS val 653279980 ecr 2290572424], length 1198: HTTP
> 19:14:03.213614 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735968509:1735969707, ack 366489597, win 235, options [nop,nop,TS val 653279980 ecr 2290572424], length 1198: HTTP
> 19:14:03.237076 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735893035:1735894233, ack 366489597, win 235, options [nop,nop,TS val 653279986 ecr 2290572450], length 1198: HTTP
> 19:14:03.237410 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735894233:1735895431, ack 366489597, win 235, options [nop,nop,TS val 653279986 ecr 2290572450], length 1198: HTTP
> 19:14:03.237417 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735895431:1735896629, ack 366489597, win 235, options [nop,nop,TS val 653279986 ecr 2290572450], length 1198: HTTP
> 19:14:03.237864 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735969707:1735970905, ack 366489597, win 235, options [nop,nop,TS val 653279986 ecr 2290572450], length 1198: HTTP
> 19:14:03.238150 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735896629:1735897827, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572450], length 1198: HTTP
> 19:14:03.238446 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735970905:1735972103, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572450], length 1198: HTTP
> 19:14:03.238800 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735897827:1735899025, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572450], length 1198: HTTP
> 19:14:03.239157 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735972103:1735973301, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572450], length 1198: HTTP
> 19:14:03.239635 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735899025:1735900223, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572451], length 1198: HTTP
> 19:14:03.239638 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735900223:1735901421, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572451], length 1198: HTTP
> 19:14:03.239928 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735901421:1735902619, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572451], length 1198: HTTP
> 19:14:03.240410 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735973301:1735974499, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572451], length 1198: HTTP
> 19:14:03.240414 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735902619:1735903817, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572451], length 1198: HTTP
> 19:14:03.240416 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735974499:1735975697, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572451], length 1198: HTTP
> 19:14:03.240673 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735903817:1735905015, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.240677 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735905015:1735906213, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.241173 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735906213:1735907411, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.241176 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735975697:1735976895, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.241178 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735976895:1735978093, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.241520 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735978093:1735979291, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.241523 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735979291:1735980489, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.241935 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735980489:1735981687, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.241939 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735981687:1735982885, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.242389 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735982885:1735984083, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.242394 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735984083:1735985281, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.242396 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735985281:1735986479, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.242641 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735986479:1735987677, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.243126 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735987677:1735988875, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.243129 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735988875:1735990073, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.243131 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735990073:1735991271, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.243433 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735991271:1735992469, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.243438 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735992469:1735993667, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.243839 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735993667:1735994865, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.243845 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735994865:1735996063, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.243846 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735996063:1735997261, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.244280 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735997261:1735998459, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.244285 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735998459:1735999657, ack 366489597, win 235, options [nop,nop,TS val 653279987 ecr 2290572452], length 1198: HTTP
> 19:14:03.244287 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735999657:1736000855, ack 366489597, win 235, options [nop,nop,TS val 653279988 ecr 2290572452], length 1198: HTTP
> 19:14:03.244642 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736000855:1736002053, ack 366489597, win 235, options [nop,nop,TS val 653279988 ecr 2290572452], length 1198: HTTP
> 19:14:03.244648 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736002053:1736003251, ack 366489597, win 235, options [nop,nop,TS val 653279988 ecr 2290572452], length 1198: HTTP
> 19:14:03.244923 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736003251:1736004449, ack 366489597, win 235, options [nop,nop,TS val 653279988 ecr 2290572452], length 1198: HTTP
> 19:14:03.245411 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736004449:1736005647, ack 366489597, win 235, options [nop,nop,TS val 653279988 ecr 2290572452], length 1198: HTTP
> 19:14:03.245417 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736005647:1736006845, ack 366489597, win 235, options [nop,nop,TS val 653279988 ecr 2290572452], length 1198: HTTP
> 19:14:03.247234 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736006845:1736008043, ack 366489597, win 235, options [nop,nop,TS val 653279988 ecr 2290572452], length 1198: HTTP
> 19:14:03.247236 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736008043:1736009241, ack 366489597, win 235, options [nop,nop,TS val 653279988 ecr 2290572452], length 1198: HTTP
> 19:14:03.247542 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736009241:1736010439, ack 366489597, win 235, options [nop,nop,TS val 653279988 ecr 2290572452], length 1198: HTTP
> 19:14:03.247913 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736010439:1736011637, ack 366489597, win 235, options [nop,nop,TS val 653279988 ecr 2290572452], length 1198: HTTP
> 19:14:03.249035 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736011637:1736012835, ack 366489597, win 235, options [nop,nop,TS val 653279988 ecr 2290572452], length 1198: HTTP
> 19:14:03.249037 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736012835:1736014033, ack 366489597, win 235, options [nop,nop,TS val 653279988 ecr 2290572452], length 1198: HTTP
> 19:14:03.249388 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736014033:1736015231, ack 366489597, win 235, options [nop,nop,TS val 653279988 ecr 2290572452], length 1198: HTTP
> 19:14:03.249395 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736015231:1736016429, ack 366489597, win 235, options [nop,nop,TS val 653279988 ecr 2290572452], length 1198: HTTP
> 19:14:03.249702 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736016429:1736017627, ack 366489597, win 235, options [nop,nop,TS val 653279988 ecr 2290572452], length 1198: HTTP
> 19:14:03.249704 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736017627:1736018825, ack 366489597, win 235, options [nop,nop,TS val 653279988 ecr 2290572452], length 1198: HTTP
> 19:14:03.250033 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736018825:1736020023, ack 366489597, win 235, options [nop,nop,TS val 653279988 ecr 2290572452], length 1198: HTTP
> 19:14:03.250449 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736020023:1736021221, ack 366489597, win 235, options [nop,nop,TS val 653279988 ecr 2290572452], length 1198: HTTP
> 19:14:03.250456 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736021221:1736022419, ack 366489597, win 235, options [nop,nop,TS val 653279988 ecr 2290572452], length 1198: HTTP
> 19:14:03.250872 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736022419:1736023617, ack 366489597, win 235, options [nop,nop,TS val 653279988 ecr 2290572452], length 1198: HTTP
> 19:14:03.250876 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736023617:1736024815, ack 366489597, win 235, options [nop,nop,TS val 653279988 ecr 2290572452], length 1198: HTTP
> 19:14:03.250878 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736024815:1736026013, ack 366489597, win 235, options [nop,nop,TS val 653279988 ecr 2290572452], length 1198: HTTP
> 19:14:03.251177 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736026013:1736027211, ack 366489597, win 235, options [nop,nop,TS val 653279989 ecr 2290572452], length 1198: HTTP
> 19:14:03.251510 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736027211:1736028409, ack 366489597, win 235, options [nop,nop,TS val 653279989 ecr 2290572452], length 1198: HTTP
> 19:14:03.251516 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736028409:1736029607, ack 366489597, win 235, options [nop,nop,TS val 653279989 ecr 2290572452], length 1198: HTTP
> 
> Server finally comes to its senses and actually sends the packet that
> the client wants. Repeatedly.
> 
> 19:14:03.469417 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735884649:1735885847, ack 366489597, win 235, options [nop,nop,TS val 653280045 ecr 2290572452], length 1198: HTTP
> 19:14:03.933488 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735884649:1735885847, ack 366489597, win 235, options [nop,nop,TS val 653280161 ecr 2290572452], length 1198: HTTP
> 19:14:04.861503 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735884649:1735885847, ack 366489597, win 235, options [nop,nop,TS val 653280393 ecr 2290572452], length 1198: HTTP
> 19:14:06.735809 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735884649:1735885847, ack 366489597, win 235, options [nop,nop,TS val 653280858 ecr 2290572452], length 1198: HTTP
> 19:14:10.524440 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735884649:1735885847, ack 366489597, win 235, options [nop,nop,TS val 653281788 ecr 2290572452], length 1198: HTTP
> 19:14:17.881996 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735884649:1735885847, ack 366489597, win 235, options [nop,nop,TS val 653283648 ecr 2290572452], length 1198: HTTP
> 
> Client didn't seem to accept it (despite checksums all being correct),
> and curl eventually hits its 15-second timeout and aborts the
> connection.
> 
> 19:14:18.212173 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [F.], seq 366489597, ack 1735884649, win 24576, options [nop,nop,TS val 2290587453 ecr 653279980], length 0
> 19:14:18.276852 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], ack 366489598, win 235, options [nop,nop,TS val 653283747 ecr 2290587453], length 0
> 19:14:18.452091 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [F.], seq 366489597, ack 1735884649, win 24576, options [nop,nop,TS val 2290587692 ecr 653279980], length 0
> 19:14:18.478633 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], ack 366489598, win 235, options [nop,nop,TS val 653283797 ecr 2290587692,nop,nop,sack 1 {366489597:366489598}], length 0
> 19:14:18.692036 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [F.], seq 366489597, ack 1735884649, win 24576, options [nop,nop,TS val 2290587932 ecr 653279980], length 0
> 19:14:18.721019 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], ack 366489598, win 235, options [nop,nop,TS val 653283857 ecr 2290587932,nop,nop,sack 1 {366489597:366489598}], length 0
> 19:14:19.180036 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [F.], seq 366489597, ack 1735884649, win 24576, options [nop,nop,TS val 2290588420 ecr 653279980], length 0
> 19:14:19.228343 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], ack 366489598, win 235, options [nop,nop,TS val 653283979 ecr 2290588420,nop,nop,sack 1 {366489597:366489598}], length 0
> 19:14:20.140032 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [F.], seq 366489597, ack 1735884649, win 24576, options [nop,nop,TS val 2290589380 ecr 653279980], length 0
> 19:14:20.220702 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], ack 366489598, win 235, options [nop,nop,TS val 653284219 ecr 2290589380,nop,nop,sack 1 {366489597:366489598}], length 0
> 19:14:22.060035 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [F.], seq 366489597, ack 1735884649, win 24576, options [nop,nop,TS val 2290591300 ecr 653279980], length 0
> 19:14:22.111761 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], ack 366489598, win 235, options [nop,nop,TS val 653284699 ecr 2290591300,nop,nop,sack 1 {366489597:366489598}], length 0
> 19:14:26.028033 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [F.], seq 366489597, ack 1735884649, win 24576, options [nop,nop,TS val 2290595268 ecr 653279980], length 0
> 19:14:26.062672 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], ack 366489598, win 235, options [nop,nop,TS val 653285691 ecr 2290595268,nop,nop,sack 1 {366489597:366489598}], length 0
> 19:14:32.788354 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735884649:1735885847, ack 366489598, win 235, options [nop,nop,TS val 653287368 ecr 2290595268], length 1198: HTTP
> 19:14:33.708035 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [F.], seq 366489597, ack 1735884649, win 24576, options [nop,nop,TS val 2290602948 ecr 653279980], length 0
> 19:14:33.769533 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], ack 366489598, win 235, options [nop,nop,TS val 653287614 ecr 2290602948,nop,nop,sack 1 {366489597:366489598}], length 0
> 
> 
> So OK, the server is behaving weirdly, as far as I can tell. But why
> would Linux on the client side refuse to accept that packet that it's
> been waiting for? In the full capture I have checked that the IP and
> TCP checksums are correct.
> 

Try to get during the communication multiple samples of :

ss -temoi dst 10.28.82.105 ; nstat

Might give us some clue.
