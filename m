Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E910F10B4BA
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 18:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfK0Rqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 12:46:49 -0500
Received: from mail-pg1-f176.google.com ([209.85.215.176]:39406 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbfK0Rqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 12:46:48 -0500
Received: by mail-pg1-f176.google.com with SMTP id b137so8926970pga.6;
        Wed, 27 Nov 2019 09:46:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tKHZyDg6udiRlYpCVqWn+WRhsu18FyQUMCFzqJkHa30=;
        b=vHKgmJUcmJy5fxsEr/kQHZjWqDay4ZSL97Z5ibV+B00e4bqFkYQM/6pbrgxFhxJUMQ
         S0XzcUjWlOD47ppweFgcF9CdtnlKifpqid82Y+A8TIv2krbvBVsYuwJfVGrroUMknBBS
         Wg0I5mXBt484k5lsgTq2QYT7Vhza/UACIKs/xufeNZyZr3wjgF4N/3KNgf7XZjBc+u0o
         nSXHon8qNrvyu9tCgsj7zwdajLB+X3E3sVcRvckqVLSLeZUdktN9KckYtHgP9JguToZB
         cKgRv+wSsVrH7vt4tT2Z9c1xc0Hbc6dqBGZbLV3AjMEwX4b5OmRg7dBA2tg5YTgrKGQN
         iAjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tKHZyDg6udiRlYpCVqWn+WRhsu18FyQUMCFzqJkHa30=;
        b=jXQlDNn2hGpBBPUaUTqF5W1wAGT11it1fMWiErVip1XybbppzammbHgRvtIrH8knDw
         jT2DRink/ajZboVuU0VZ2MuKHWPmvp1QOAigRWSiSq7dGq3YDzCJMLyuJMBtaITtrcQ8
         2r7mhbCmSuj5IkfFI4BL+FE2Sl4T2SzVEMSpHi/wJzwazf/Cl70lUTvG+4GRAQxQL3yc
         DRe1Yi1eOH6gWWDyPA0keA5R48qhQ8jfqs/c8SzA1I6bL1svBaNpqlsYXusvymlTdZ4e
         m3wh7DcCMCpxNhLeTNxhDn7I9fXLjeN7IAmUSoRENZ6QZ5IG0lJrHF1U9rCnhPOJIe4t
         eN/w==
X-Gm-Message-State: APjAAAVs6CAToj03DPqWsexM/AALIyooVXgpsbQqpqmzkDsl4AJYO+La
        1ZXfUfHhiOloXslbSEuyyxY=
X-Google-Smtp-Source: APXvYqyAG8AREyU8c7G4EqYf3ewYnpRomBHtVKqscW9BcvyKglot1cXCFoPDPOsTqMh0cIQYQPNP/g==
X-Received: by 2002:a63:cb:: with SMTP id 194mr6519340pga.163.1574876808078;
        Wed, 27 Nov 2019 09:46:48 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id f132sm3551647pgc.50.2019.11.27.09.46.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2019 09:46:47 -0800 (PST)
Subject: Re: epoll_wait() performance
To:     David Laight <David.Laight@ACULAB.COM>,
        'Paolo Abeni' <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     'Marek Majkowski' <marek@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
References: <bc84e68c0980466096b0d2f6aec95747@AcuMS.aculab.com>
 <CAJPywTJYDxGQtDWLferh8ObjGp3JsvOn1om1dCiTOtY6S3qyVg@mail.gmail.com>
 <5f4028c48a1a4673bd3b38728e8ade07@AcuMS.aculab.com>
 <20191127164821.1c41deff@carbon>
 <0b8d7447e129539aec559fa797c07047f5a6a1b2.camel@redhat.com>
 <2f1635d9300a4bec8a0422e9e9518751@AcuMS.aculab.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <313204cf-69fd-ec28-a22c-61526f1dea8b@gmail.com>
Date:   Wed, 27 Nov 2019 09:46:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <2f1635d9300a4bec8a0422e9e9518751@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/27/19 9:30 AM, David Laight wrote:
> From: Paolo Abeni
>> Sent: 27 November 2019 16:27
> ...
>> @David: If I read your message correctly, the pkt rate you are dealing
>> with is quite low... are we talking about tput or latency? I guess
>> latency could be measurably higher with recvmmsg() in respect to other
>> syscall. How do you measure the releative performances of recvmmsg()
>> and recv() ? with micro-benchmark/rdtsc()? Am I right that you are
>> usually getting a single packet per recvmmsg() call?
> 
> The packet rate per socket is low, typically one packet every 20ms.
> This is RTP, so telephony audio.
> However we have a lot of audio channels and hence a lot of sockets.
> So there are can be 1000s of sockets we need to receive the data from.
> The test system I'm using has 16 E1 TDM links each of which can handle
> 31 audio channels.
> Forwarding all these to/from RTP (one of the things it might do) is 496
> audio channels - so 496 RTP sockets and 496 RTCP ones.
> Although the test I'm doing is pure RTP and doesn't use TDM.
> 
> What I'm measuring is the total time taken to receive all the packets
> (on all the sockets) that are available to be read every 10ms.
> So poll + recv + add_to_queue.
> (The data processing is done by other threads.)
> I use the time difference (actually CLOCK_MONOTONIC - from rdtsc)
> to generate a 64 entry (self scaling) histogram of the elapsed times.
> Then look for the histograms peak value.
> (I need to work on the max value, but that is a different (more important!) problem.)
> Depending on the poll/recv method used this takes 1.5 to 2ms
> in each 10ms period.
> (It is faster if I run the cpu at full speed, but it usually idles along
> at 800MHz.)
> 
> If I use recvmmsg() I only expect to see one packet because there
> is (almost always) only one packet on each socket every 20ms.
> However there might be more than one, and if there is they
> all need to be read (well at least 2 of them) in that block of receives.
> 
> The outbound traffic goes out through a small number of raw sockets.
> Annoyingly we have to work out the local IPv4 address that will be used
> for each destination in order to calculate the UDP checksum.
> (I've a pending patch to speed up the x86 checksum code on a lot of
> cpus.)
> 
> 	David

A QUIC server handles hundred of thousands of ' UDP flows' all using only one UDP socket
per cpu.

This is really the only way to scale, and does not need kernel changes to efficiently
organize millions of UDP sockets (huge memory footprint even if we get right how
we manage them)

Given that UDP has no state, there is really no point trying to have one UDP
socket per flow, and having to deal with epoll()/poll() overhead.




