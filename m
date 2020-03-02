Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53FDD17525D
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 04:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgCBDm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 22:42:29 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:53939 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgCBDm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 22:42:28 -0500
Received: by mail-pj1-f65.google.com with SMTP id cx7so634428pjb.3
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 19:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ESaMiaBBpmtpSRdKsJdzm4BjqynM4VAPoAlR77c5o2o=;
        b=YtlQyJCZTP2koEIe+TGjOXnRqplWtZ2riFABjAH/2EXsLWnfSyIUcUcgeDnKSbh9r5
         i6eZyiSs0TETzzSrhdpP1M2gwS1uLVpASwN9Jfu3ef1AhgSuCcr+97o6TSt0hcwoe4u3
         +mn0Idiz3mKqKe8KJPGfb/PyN56WuPqo6zLSUpfehJRGhh9D2wVI6AnyQY88jzD5Bwrw
         LSy3u/oH1Pod+qKRSNhiEkUEEk0ifjbPTFIYPO32Y7kKxwx8QYDzA81P4d2pP8XGpr88
         GYT5W1nvBr9nvoXU+46ssRj2TATrZDd/QxxaTR5Y4WiNRu5BKHZ2iH/xFAqF/9mKgm6I
         BQYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ESaMiaBBpmtpSRdKsJdzm4BjqynM4VAPoAlR77c5o2o=;
        b=ZDc3Cd9WzV9KjNyCpi9bTxOk9taLN+6VDksmLq83S0RipoCrP+/M5bagMMFkJ2sf+5
         lmSZRvlkaFkaoaLJs/H8SMHAOqGd0YMDmBIrSeoCnJJsswkq/dKhErBNP80mBsvL5FE4
         Y3iOD7KxTSqrubU/KObueS1cppVc99hyjIDR2/+hPxs0K0UUBRG4PuTDKuWKxailBk2h
         78KcoqQVcv/FLkvZCktiIUHD8JbkeEQ11voREfXyc3uj00TA3EdjG4EVPQID+AxiCB7G
         AuZTPRX3FHhhosFrRyPS/S/DdCnf+V4JXO3JwFH2pzm14tyoOxn67ZxIXW4v8tfIbAi1
         +63A==
X-Gm-Message-State: APjAAAUscSqjMw/HkB2vazhYLUrN1c4Qpdzr7NtR3poZ5A6WV824kH1r
        0+zRFp9Yz2JsMOczIt9udUY=
X-Google-Smtp-Source: APXvYqzd4T630p+Sf2zk8e3SbFQowGXbuH0TM82c1FmaYJuSbiUp/VthBTEw8CdPd84boe6aiaqRDg==
X-Received: by 2002:a17:90a:7784:: with SMTP id v4mr19320734pjk.134.1583120547811;
        Sun, 01 Mar 2020 19:42:27 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id t63sm19171197pfb.70.2020.03.01.19.42.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2020 19:42:27 -0800 (PST)
Subject: Re: [PATCH v3 net-next 2/4] tcp: bind(addr, 0) remove the
 SO_REUSEADDR restriction when ephemeral ports are exhausted.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, edumazet@google.com
Cc:     kuni1840@gmail.com, netdev@vger.kernel.org,
        osa-contribution-log@amazon.com
References: <20200229113554.78338-1-kuniyu@amazon.co.jp>
 <20200229113554.78338-3-kuniyu@amazon.co.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0b9db623-0a69-30e6-1e28-b6acb306c360@gmail.com>
Date:   Sun, 1 Mar 2020 19:42:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200229113554.78338-3-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/29/20 3:35 AM, Kuniyuki Iwashima wrote:
> Commit aacd9289af8b82f5fb01bcdd53d0e3406d1333c7 ("tcp: bind() use stronger
> condition for bind_conflict") introduced a restriction to forbid to bind
> SO_REUSEADDR enabled sockets to the same (addr, port) tuple in order to
> assign ports dispersedly so that we can connect to the same remote host.
> 
> The change results in accelerating port depletion so that we fail to bind
> sockets to the same local port even if we want to connect to the different
> remote hosts.
> 
> You can reproduce this issue by following instructions below.
>   1. # sysctl -w net.ipv4.ip_local_port_range="32768 32768"
>   2. set SO_REUSEADDR to two sockets.
>   3. bind two sockets to (address, 0) and the latter fails.
> 
> Therefore, when ephemeral ports are exhausted, bind(addr, 0) should
> fallback to the legacy behaviour to enable the SO_REUSEADDR option and make
> it possible to connect to different remote (addr, port) tuples.
> 
> This patch allows us to bind SO_REUSEADDR enabled sockets to the same
> (addr, port) only when all ephemeral ports are exhausted.
> 
> The only notable thing is that if all sockets bound to the same port have
> both SO_REUSEADDR and SO_REUSEPORT enabled, we can bind sockets to an
> ephemeral port and also do listen().
> 
> Fixes: aacd9289af8b ("tcp: bind() use stronger condition for bind_conflict")
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

I am unsure about this, since this could double the time taken by this
function, which is already very time consuming.

We added years ago IP_BIND_ADDRESS_NO_PORT socket option, so that the kernel
has more choices at connect() time (instead of bind()) time to choose a source port.

This considerably lowers time taken to find an optimal source port, since
the kernel has full information (source address, destination address & port)

       IP_BIND_ADDRESS_NO_PORT (since Linux 4.2)
              Inform the kernel to not reserve an ephemeral port when using
              bind(2) with a port number of 0.  The port will later be auto‐
              matically chosen at connect(2) time, in a way that allows
              sharing a source port as long as the 4-tuple is unique.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=90c337da1524863838658078ec34241f45d8394d

