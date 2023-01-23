Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A12367863A
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 20:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbjAWTZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 14:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbjAWTZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 14:25:22 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622AE359B
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 11:25:18 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id w11so589899edv.0
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 11:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dH2djSpCc2F8meaf+MyRzV4dLcG5Tpvbdah1kV35+Yg=;
        b=k9UF+UKY1qbc1tKBjDxf4KwEt/vpL23NVr5EkX8u4K16WYqJt3ejcxQplpbkPrbh51
         SXlkhEpkA1bYlYJBgVF1aFjqs9gVb/Dnm8sM/f3ZOqzKp+cr7+Ekzih/9cKaCu8e0vaX
         UMdwJbf13BUvlNnmvGvT40blPlWooXUpE/eGEK2CnSAvyxa/GXzzUjAOHEFofHidmZSe
         PSE62euhyDSIZQXIECjstlkp1XrQzxeCOGWmEczmIm1aZhIX5wASEU3T6OiCPyUpdGwy
         5AHu5ogHptIdo9XuDNfhLqX3vsGHeFUxz9+6XK5aAttGC+yXsPNBCv0QBQQsPmHLLlBb
         TlnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dH2djSpCc2F8meaf+MyRzV4dLcG5Tpvbdah1kV35+Yg=;
        b=WGk24QG39SPtDWlV0M1FIJOJD2/N5MoBsfEVghEmqs1Z062TmVNe72zGLcOl0Xpl4Y
         uPpvZJd7vMHuli9u0nJOEb9r68YVDxpMWegojq9PNTurfffighHBQP/TUek2FJi5r4VN
         0W0iQBjX+D4yoMTHnJJqyg+5AHxD06AN95dJpyRqrHKgwuFxeWVMHlMi9SL503Cr+8qH
         ebqEN3CEjqrzhWEopYXOQLzSkfGzX0r4Rqny6bdJWyPU+YP55hf+OOzJrszbKJLDuKT5
         dXaHnTBrcN+oUMFty2AKC6G0qIJ62qGlNfVRKZmVB8K5vqn6YHhikSqYvvKoKRsMzo5a
         Xm/w==
X-Gm-Message-State: AFqh2kornxJFUqVJWfMyqW9YXvvRHiOEK3JtkzItDZsWJL9iEitJnY2a
        is9o9nBODjr13TGe2wANvdAHy/Osr8M=
X-Google-Smtp-Source: AMrXdXt2w/5G5crd5xX8Q0DqUUs0GK2/SFzhHSUrg0Ba7KlKF5dW0I7h0Dng/VGNvkVnxQs0B0b3nA==
X-Received: by 2002:a50:fe95:0:b0:46c:aa8b:da5c with SMTP id d21-20020a50fe95000000b0046caa8bda5cmr25515331edt.33.1674501916792;
        Mon, 23 Jan 2023 11:25:16 -0800 (PST)
Received: from [192.168.1.13] ([88.118.3.238])
        by smtp.gmail.com with ESMTPSA id j1-20020aa7de81000000b00488117821ffsm97735edv.31.2023.01.23.11.25.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 11:25:16 -0800 (PST)
Message-ID: <eaab7495-53d5-0026-842c-acb420408cd0@gmail.com>
Date:   Mon, 23 Jan 2023 21:25:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US, lt
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org
References: <f171a249-1529-4095-c631-f9f54d996b90@gmail.com>
 <CANn89iK1aPiystTAk2qTnzsN-LFskJ4BxL=XgTk2aLpExrWFEw@mail.gmail.com>
From:   =?UTF-8?Q?Mantas_Mikul=c4=97nas?= <grawity@gmail.com>
Subject: Re: traceroute failure in kernel 6.1 and 6.2
In-Reply-To: <CANn89iK1aPiystTAk2qTnzsN-LFskJ4BxL=XgTk2aLpExrWFEw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023-01-23 17:21, Eric Dumazet wrote:
> On Sat, Jan 21, 2023 at 7:09 PM Mantas Mikulėnas <grawity@gmail.com> wrote:
>>
>> Hello,
>>
>> Not sure whether this has been reported, but:
>>
>> After upgrading from kernel 6.0.7 to 6.1.6 on Arch Linux, unprivileged
>> ICMP traceroute using the `traceroute -I` tool stopped working – it very
>> reliably fails with a "No route to host" at some point:
>>
>>          myth> traceroute -I 83.171.33.188
>>          traceroute to 83.171.33.188 (83.171.33.188), 30 hops max, 60
>>          byte packets
>>           1  _gateway (192.168.1.1)  0.819 ms
>>          send: No route to host
>>          [exited with 1]
>>
>> while it still works for root:
>>
>>          myth> sudo traceroute -I 83.171.33.188
>>          traceroute to 83.171.33.188 (83.171.33.188), 30 hops max, 60
>>          byte packets
>>           1  _gateway (192.168.1.1)  0.771 ms
>>           2  * * *
>>           3  10.69.21.145 (10.69.21.145)  47.194 ms
>>           4  82-135-179-168.static.zebra.lt (82.135.179.168)  49.124 ms
>>           5  213-190-41-3.static.telecom.lt (213.190.41.3)  44.211 ms
>>           6  193.219.153.25 (193.219.153.25)  77.171 ms
>>           7  83.171.33.188 (83.171.33.188)  78.198 ms
>>
>> According to `git bisect`, this started with:
>>
>>          commit 0d24148bd276ead5708ef56a4725580555bb48a3
>>          Author: Eric Dumazet <edumazet@google.com>
>>          Date:   Tue Oct 11 14:27:29 2022 -0700
>>
>>              inet: ping: fix recent breakage
>>
>>
>>
>>
>> It still happens with a fresh 6.2rc build, unless I revert that commit.
>>
>> The /bin/traceroute is the one that calls itself "Modern traceroute for
>> Linux, version 2.1.1", on Arch Linux. It seems to use socket(AF_INET,
>> SOCK_DGRAM, IPPROTO_ICMP), has neither setuid nor file capabilities.
>> (The problem does not occur if I run it as root.)
>>
>> This version of `traceroute` sends multiple probes at once (with TTLs
>> 1..16); according to strace, the first approx. 8-12 probes are sent
>> successfully, but eventually sendto() fails with EHOSTUNREACH. (Though
>> if I run it on local tty as opposed to SSH, it fails earlier.) If I use
>> -N1 to have it only send one probe at a time, the problem doesn't seem
>> to occur.
> 
> 
> 
> I was not able to reproduce the issue (downloading
> https://sourceforge.net/projects/traceroute/files/latest/download)
> 
> I suspect some kind of bug in this traceroute, when/if some ICMP error
> comes back.
> 
> Double check by
> 
> tcpdump -i ethXXXX icmp
> 
> While you run traceroute -I ....

Hmm, no, the only ICMP errors I see in tcpdump are "Time exceeded in 
transit", which is expected for traceroute. Nothing else shows up.

(But when I test against an address that causes *real* ICMP "Host 
unreachable" errors, it seems to handle those correctly and prints "!H" 
as usual -- that is, if it reaches that point without dying.)

I was able to reproduce this on a fresh Linode 1G instance (starting 
with their Arch image), where it also happens immediately:

	# pacman -Sy archlinux-keyring
	# pacman -Syu
	# pacman -Sy traceroute strace
	# reboot
	# uname -r
	6.1.7-arch1-1
	# useradd foo
	# su -c "traceroute -I 8.8.8.8" foo
	traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
	 1  10.210.1.195 (10.210.1.195)  0.209 ms
	send: No route to host

So now I'm fairly sure it is not something caused by my own network, either.

On one system, it seems to work properly about half the time, if I keep 
re-running the same command.

