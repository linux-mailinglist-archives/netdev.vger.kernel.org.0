Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1126A280FCD
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 11:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387620AbgJBJ0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 05:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgJBJ0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 05:26:05 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2A8C0613D0;
        Fri,  2 Oct 2020 02:26:03 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id k18so975272wmj.5;
        Fri, 02 Oct 2020 02:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pSJaC3+uT2CVpuMJsIUx0m5RcX9EnuUYfAIsJkf7EKY=;
        b=XE5HJW7hSaUdPX/IY2gMFyFFUN1qkKpXMPD28s5njO9baZjtRVbqjwpCKFut1nwSQQ
         DpspD4U8uk2jLI/kytj+KZLmQk7oA6cY/vAOdOlsejFXmefXPde2PWsDZ+l/Gl68sIhl
         yzkjznv9Pe5oVFjIoXbYAhttErSXXLJre2xfYHdY9qcq51hVcn2gMaJEw37RAkZllCf7
         KPi9x0FE4zAdqaivrcAREW291s0fpE/UcYl6DweXWl31YyBsO3bz05tLa9x+cVKUjDql
         VfNyB4TqYFDrjBgBjmKdSpsq47lpJELvF9hGktNj8KXPRtV5n+yKsjymfj1ZaZWmVl62
         3aig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pSJaC3+uT2CVpuMJsIUx0m5RcX9EnuUYfAIsJkf7EKY=;
        b=qEsNjsHDgbPiWDnl/wj4wBP8lm2LJzTNaysupd2JCdLhBuLQ0+9V31NybyVkjcAqTh
         Uu3UzDS4DB81p+4gK7VMh4mtlQjWZUNxrz8waQDFPZBE6LccDEfa9qkDbrX8x+QaVx4B
         rs4Djjq5pym8KoDI2C35sdUqC9HL5F+tHr7xbgGwtrJ4gX1Qs148kFdRX7yA+wQhdj1L
         GeZzecHI7LWZfGjcDgb5xUuM/PONX/qOB2kiOlzRIwnaAuW4bw5klKSaYoIav82WqQxR
         IFEpRCHEA88qc0KnZpPDoQXYiHFwwnj/OLZnCdK7E56ndbDMYyh3KSSaaplD/14+AtF8
         CLAQ==
X-Gm-Message-State: AOAM532otAitbPYaWVWowZweMfMSO2X7JprYu5eVwHcFPUYwmGa2ezlM
        Z5CB1lbZqXF0c4x8oHn0z2KOGMHzaTk=
X-Google-Smtp-Source: ABdhPJzhmkXAlOvlQvmPzWY7DIFjMscOXirvXaHglcO2d0IBTMvBidrPUILcP1LBieNPdJY1jwoEBg==
X-Received: by 2002:a1c:2042:: with SMTP id g63mr1777455wmg.174.1601630762281;
        Fri, 02 Oct 2020 02:26:02 -0700 (PDT)
Received: from [192.168.8.147] ([37.166.162.133])
        by smtp.gmail.com with ESMTPSA id c16sm1168113wrx.31.2020.10.02.02.26.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 02:26:01 -0700 (PDT)
Subject: Re: Why ping latency is smaller with shorter send interval?
To:     =?UTF-8?B?5Y+25bCP6b6Z?= <muryo.ye@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <CAP0D=1X946M=yy=hMBvXuT11paPqxMi_xens-R4m7vyCnkUQzw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0d8f732d-03e1-75f0-09fd-520911088c0d@gmail.com>
Date:   Fri, 2 Oct 2020 11:26:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAP0D=1X946M=yy=hMBvXuT11paPqxMi_xens-R4m7vyCnkUQzw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/2/20 10:51 AM, 叶小龙 wrote:
> Hi, net experts,
> 
> Hope this is the right place to ask the question :)
> 
> Recently I've tried to measure the network latency between two
> machines by using ping, one interesting observation I found is that
> ping latency will be smaller if I use a shorter interval with -i
> option. For example,
> 
> when I use default ping (interval is 1s), then the ping result is as
> below with avg latency 0.062ms
> 
> # ping 9.9.9.2 -c 10
> PING 9.9.9.2 (9.9.9.2) 56(84) bytes of data.
> 64 bytes from 9.9.9.2: icmp_seq=1 ttl=64 time=0.059 ms
> 64 bytes from 9.9.9.2: icmp_seq=2 ttl=64 time=0.079 ms
> 64 bytes from 9.9.9.2: icmp_seq=3 ttl=64 time=0.060 ms
> 64 bytes from 9.9.9.2: icmp_seq=4 ttl=64 time=0.072 ms
> 64 bytes from 9.9.9.2: icmp_seq=5 ttl=64 time=0.048 ms
> 64 bytes from 9.9.9.2: icmp_seq=6 ttl=64 time=0.069 ms
> 64 bytes from 9.9.9.2: icmp_seq=7 ttl=64 time=0.067 ms
> 64 bytes from 9.9.9.2: icmp_seq=8 ttl=64 time=0.055 ms
> 64 bytes from 9.9.9.2: icmp_seq=9 ttl=64 time=0.058 ms
> 64 bytes from 9.9.9.2: icmp_seq=10 ttl=64 time=0.055 ms
> 
> --- 9.9.9.2 ping statistics ---
> 10 packets transmitted, 10 received, 0% packet loss, time 9001ms
> rtt min/avg/max/mdev = 0.048/0.062/0.079/0.010 ms
> 
> Then I use "-i 0.001", the lateny (0.038) is way better than defaut ping
> 
> # ping 9.9.9.2 -i 0.001 -c 10
> PING 9.9.9.2 (9.9.9.2) 56(84) bytes of data.
> 64 bytes from 9.9.9.2: icmp_seq=1 ttl=64 time=0.069 ms
> 64 bytes from 9.9.9.2: icmp_seq=2 ttl=64 time=0.039 ms
> 64 bytes from 9.9.9.2: icmp_seq=3 ttl=64 time=0.034 ms
> 64 bytes from 9.9.9.2: icmp_seq=4 ttl=64 time=0.033 ms
> 64 bytes from 9.9.9.2: icmp_seq=5 ttl=64 time=0.033 ms
> 64 bytes from 9.9.9.2: icmp_seq=6 ttl=64 time=0.033 ms
> 64 bytes from 9.9.9.2: icmp_seq=7 ttl=64 time=0.034 ms
> 64 bytes from 9.9.9.2: icmp_seq=8 ttl=64 time=0.036 ms
> 64 bytes from 9.9.9.2: icmp_seq=9 ttl=64 time=0.037 ms
> 64 bytes from 9.9.9.2: icmp_seq=10 ttl=64 time=0.038 ms
> 
> --- 9.9.9.2 ping statistics ---
> 10 packets transmitted, 10 received, 0% packet loss, time 9ms
> rtt min/avg/max/mdev = 0.033/0.038/0.069/0.012 ms
> 
> 
> ping loopback shows the similar result.
> 
> Default ping avg latency is 0.049ms
> 
> # ping 127.0.0.1 -c 10
> PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
> 64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.032 ms
> 64 bytes from 127.0.0.1: icmp_seq=2 ttl=64 time=0.049 ms
> 64 bytes from 127.0.0.1: icmp_seq=3 ttl=64 time=0.054 ms
> 64 bytes from 127.0.0.1: icmp_seq=4 ttl=64 time=0.058 ms
> 64 bytes from 127.0.0.1: icmp_seq=5 ttl=64 time=0.049 ms
> 64 bytes from 127.0.0.1: icmp_seq=6 ttl=64 time=0.042 ms
> 64 bytes from 127.0.0.1: icmp_seq=7 ttl=64 time=0.052 ms
> 64 bytes from 127.0.0.1: icmp_seq=8 ttl=64 time=0.052 ms
> 64 bytes from 127.0.0.1: icmp_seq=9 ttl=64 time=0.053 ms
> 64 bytes from 127.0.0.1: icmp_seq=10 ttl=64 time=0.055 ms
> 
> --- 127.0.0.1 ping statistics ---
> 10 packets transmitted, 10 received, 0% packet loss, time 9001ms
> rtt min/avg/max/mdev = 0.032/0.049/0.058/0.010 ms
> 
> ping with "-i 0.001" shows 0.014ms avg latency.
> 
> # ping 127.0.0.1 -i 0.001 -c 10
> PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
> 64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.040 ms
> 64 bytes from 127.0.0.1: icmp_seq=2 ttl=64 time=0.014 ms
> 64 bytes from 127.0.0.1: icmp_seq=3 ttl=64 time=0.012 ms
> 64 bytes from 127.0.0.1: icmp_seq=4 ttl=64 time=0.011 ms
> 64 bytes from 127.0.0.1: icmp_seq=5 ttl=64 time=0.011 ms
> 64 bytes from 127.0.0.1: icmp_seq=6 ttl=64 time=0.011 ms
> 64 bytes from 127.0.0.1: icmp_seq=7 ttl=64 time=0.011 ms
> 64 bytes from 127.0.0.1: icmp_seq=8 ttl=64 time=0.010 ms
> 64 bytes from 127.0.0.1: icmp_seq=9 ttl=64 time=0.010 ms
> 64 bytes from 127.0.0.1: icmp_seq=10 ttl=64 time=0.011 ms
> 
> --- 127.0.0.1 ping statistics ---
> 10 packets transmitted, 10 received, 0% packet loss, time 9ms
> rtt min/avg/max/mdev = 0.010/0.014/0.040/0.008 ms
> 
> I'm using centos 7.2 with kernel 3.10.
> 
> I am very confused about the result. As I understand it, it doesn't
> matter how frequently I send packets, each packet's latency should be
> the same. So How can I understand it from network stack point of view?
> 
> Any thoughts or suggestions would be highly appreciated.
> 
> 
> Thanks,
> Xiaolong
> 

Many factors in play here.

1) if you keep cpus busy enough, they tend to keep in their caches
the data needed to serve your requests. In your case, time taken to
process an ICMP packet can be very different depending on how hot
cpu caches are.

2) Idle cpus can be put in a power conserving state.
  It takes time to exit from these states, as you noticed.
  These delays can typically be around 50 usec, or more.

Search for cpu C-states , and powertop program.

