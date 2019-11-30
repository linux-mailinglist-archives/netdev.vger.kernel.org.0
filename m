Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 303D010DDC8
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 14:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfK3N3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 08:29:47 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45809 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfK3N3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 08:29:47 -0500
Received: by mail-lj1-f196.google.com with SMTP id d20so4999019ljc.12
        for <netdev@vger.kernel.org>; Sat, 30 Nov 2019 05:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=Mdb4T961s/1Pcn7Snum1QFXu2ONNJ1wf0K7LmowejOA=;
        b=rt7I1jNZ+ZXMKPBdgk96daMbufwwaKUPrQaESEumVv8rQbRp30PqGaZnYoAKntNCR7
         WrXLq/uHKDBbHZaScQlym69MOhFeSqOH/RPd7SsTiiH2Hr1HLHdFZey6LkPwbNUTLZRb
         gHbXb9B5A3EPoG+ipS14E+Uxo3UidVTAWcsY0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=Mdb4T961s/1Pcn7Snum1QFXu2ONNJ1wf0K7LmowejOA=;
        b=Skd+bUYbtRdb2TSeMD3sSde5oLqiiynu7pgAagZu9+IUG7LWAL+3qEtlL4pILHjIgu
         yfs2YyFRo2FjJbr6WJTOzHAGpsW5qKybxRAUgfCU+yyMrHLqlfegZCW5B57TlXB5m84m
         3tGHKggBQlaF0t2x3JhieDdX9NDHnbsH+NPS3D1USr7e/XPvg+41ydbXvTMX3MHzNzbr
         d/EwsAbSwOegI2dpKl+n4PBKbqbBSwrKWHfa1iNt3yxT0M9cWjtSVr3UQ9EyA25J6uXm
         KOOCFxSQJYpC7yMLpWJy69YIjbGPIXPbSNG8Yl5D0aPJFCCeKPknNWx3xbqjprqSKhen
         9zHg==
X-Gm-Message-State: APjAAAWqDYcHi/DKxtz8eV4fa9H5TLjF3kS9CBKL76jZ3T/GgIQbSdex
        UcmCz6ueMn1yfhtL6/MS4wnVNA==
X-Google-Smtp-Source: APXvYqzF5JiIbgzFnCwRNgVkm0roxjKO5TwpSIQR326r09K+QY0zUppTu5iT6aFPPSjuBKYOENiQbA==
X-Received: by 2002:a2e:7318:: with SMTP id o24mr6000039ljc.185.1575120584323;
        Sat, 30 Nov 2019 05:29:44 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id a12sm6967959ljk.48.2019.11.30.05.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Nov 2019 05:29:43 -0800 (PST)
References: <bc84e68c0980466096b0d2f6aec95747@AcuMS.aculab.com> <CAJPywTJYDxGQtDWLferh8ObjGp3JsvOn1om1dCiTOtY6S3qyVg@mail.gmail.com> <5f4028c48a1a4673bd3b38728e8ade07@AcuMS.aculab.com> <20191127164821.1c41deff@carbon> <0b8d7447e129539aec559fa797c07047f5a6a1b2.camel@redhat.com> <2f1635d9300a4bec8a0422e9e9518751@AcuMS.aculab.com> <313204cf-69fd-ec28-a22c-61526f1dea8b@gmail.com> <1265e30d04484d08b86ba2abef5f5822@AcuMS.aculab.com> <c46e43d1-ba7d-39d9-688f-0141931df1b0@gmail.com>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        'Paolo Abeni' <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        'Marek Majkowski' <marek@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: epoll_wait() performance
In-reply-to: <c46e43d1-ba7d-39d9-688f-0141931df1b0@gmail.com>
Date:   Sat, 30 Nov 2019 14:29:41 +0100
Message-ID: <878snxo5kq.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 30, 2019 at 02:07 AM CET, Eric Dumazet wrote:
> On 11/28/19 2:17 AM, David Laight wrote:
>> From: Eric Dumazet
>>> Sent: 27 November 2019 17:47
>> ...
>>> A QUIC server handles hundred of thousands of ' UDP flows' all using only one UDP socket
>>> per cpu.
>>>
>>> This is really the only way to scale, and does not need kernel changes to efficiently
>>> organize millions of UDP sockets (huge memory footprint even if we get right how
>>> we manage them)
>>>
>>> Given that UDP has no state, there is really no point trying to have one UDP
>>> socket per flow, and having to deal with epoll()/poll() overhead.
>>
>> How can you do that when all the UDP flows have different destination port numbers?
>> These are message flows not idempotent requests.
>> I don't really want to collect the packets before they've been processed by IP.
>>
>> I could write a driver that uses kernel udp sockets to generate a single message queue
>> than can be efficiently processed from userspace - but it is a faff compiling it for
>> the systems kernel version.
>
> Well if destinations ports are not under your control,
> you also could use AF_PACKET sockets, no need for 'UDP sockets' to receive UDP traffic,
> especially it the rate is small.

Alternatively, you could steer UDP flows coming to a certain port range
to one UDP socket using TPROXY [0, 1].

TPROXY has the same downside as AF_PACKET, meaning that it requires at
least CAP_NET_RAW to create/set up the socket.

OTOH, with TPROXY you can gracefully co-reside with other services,
filering on just the destination addresses you want in iptables/nftables.

Fan-out / load-balancing with reuseport to have one socket per CPU is
not possible, though. You would need to do that with Netfilter.

-Jakub

[0] https://www.kernel.org/doc/Documentation/networking/tproxy.txt
[1] https://blog.cloudflare.com/how-we-built-spectrum/
