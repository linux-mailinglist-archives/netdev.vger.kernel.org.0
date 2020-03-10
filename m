Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3EF217EF87
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 05:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgCJEE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 00:04:28 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42587 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgCJEE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 00:04:28 -0400
Received: by mail-pl1-f196.google.com with SMTP id t3so2629397plz.9
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 21:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r2O6Dz8o8kanE7YGCGwL3eov0OuhEbdrLl2t3xi9tyw=;
        b=c7SF9aXh5ZaSVqYn1BApzN7OEr/GIs5P3EDr/oS6UAw/Dg/8Wd/hhJdfePNV2AdfyS
         EEQ/XeNSX2sZum5N0LH1dDgmQmm7R6es7v4eKEdpeB2M+w+NInEK8bDXTjkYpm0nSBjo
         i0x0S5lq0tiK18sStC6pyot8jkvXwGWp5RnjSyxMXoSNk+nhERf5/iUA4PZs2znT3Umi
         SRErzvh/VGw+69jm2oDtQaAe93dOtz3d64ZsdDFfqjbO8EBatKjkloxJdCtTxqJJnaGX
         cDeg2LBpoBQTpR2PHSg8szOiX4v6mHVRIqAmZbW77RF1UCjepI52uamKHQoR00ACl3pB
         po+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r2O6Dz8o8kanE7YGCGwL3eov0OuhEbdrLl2t3xi9tyw=;
        b=ekTx9otZdAHs1Jn1tLNRHwCWGhxZ3CxNUIgNNeSNF13z7WsoCwaxwoEiNM56mGTYDu
         7vGrEqeZ1DbWX+NzFsOoh/mBKEx/19o+N4C/U9w2gZ8GItRIsL4ZkbE5HxETmsX/rhEJ
         NnO7I3AlDs+rfg7jP4mlLVZNI8uskRT4TTRi+rKc/ftYwnHSL/X27XDu1vMesgs2mKPF
         PkqAIVpRUAnPhos00Jm2+Yx4QNUufJmRcxcWDyFFzOHT60s3jxAwFgmbhJx/eSRN/0sx
         Gnh6bichRgU8uBY8474DWYMKNdSnzH2CNZdtymffT+A8rKgN1FjykzRObUT7HVYDeL+W
         4xSw==
X-Gm-Message-State: ANhLgQ23VscO1vHp0xSB52b5Z4uCyZKrpRJTH9Gy8DVsmIXwDeOC+f7P
        xT2bW57zDKF/qFLsJWc3/BQ=
X-Google-Smtp-Source: ADFU+vu8BNwfXvcePW9sEZgbohzCQDODpYu+t3zMpUnxQKk5CPDUmpk3MYIX8+jUZ+yDlMHKqqX7xQ==
X-Received: by 2002:a17:902:61:: with SMTP id 88mr18881683pla.17.1583813066995;
        Mon, 09 Mar 2020 21:04:26 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id c15sm952211pja.30.2020.03.09.21.04.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 21:04:26 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 2/5] tcp: bind(0) remove the SO_REUSEADDR
 restriction when ephemeral ports are exhausted.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, edumazet@google.com
Cc:     kuni1840@gmail.com, netdev@vger.kernel.org,
        osa-contribution-log@amazon.com
References: <20200308181615.90135-1-kuniyu@amazon.co.jp>
 <20200308181615.90135-3-kuniyu@amazon.co.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ebaf23ff-6b6e-8e5b-6de5-5388284d611d@gmail.com>
Date:   Mon, 9 Mar 2020 21:04:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200308181615.90135-3-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/8/20 11:16 AM, Kuniyuki Iwashima wrote:
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
>   3. bind two sockets to (localhost, 0) and the latter fails.
> 
> Therefore, when ephemeral ports are exhausted, bind(0) should fallback to
> the legacy behaviour to enable the SO_REUSEADDR option and make it possible
> to connect to different remote (addr, port) tuples.

Sadly this commit tries hard to support obsolete SO_REUSEADDR for active connections,
which makes little sense now we have more powerful IP_BIND_ADDRESS_NO_PORT

SO_REUSEADDR only really makes sense for a listener, because you want a
server to be able to restart after core dump, while prior sockets are still
kept in TIME_WAIT state.

Same for SO_REUSEPORT : it only made sense for sharded listeners in linux kernel.

Trying to allocate a sport at bind() time, without knowing the destination address/port
is really not something that can be fixed.

Your patches might allow a 2x increase, while IP_BIND_ADDRESS_NO_PORT
basically allows for 1000x increase of the possible combinations.



> 
> This patch allows us to bind SO_REUSEADDR enabled sockets to the same
> (addr, port) only when all ephemeral ports are exhausted.
> 
> The only notable thing is that if all sockets bound to the same port have
> both SO_REUSEADDR and SO_REUSEPORT enabled, we can bind sockets to an
> ephemeral port and also do listen().
> 
> Fixes: aacd9289af8b ("tcp: bind() use stronger condition for bind_conflict")

I disagree with this Fixes: tag  : I do not want this patch in stable kernels,
particularly if you put the sysctl patch as a followup without a Fixes: tag.

Please reorder your patch to first introduce the sysctl, then this one.

Or squash the two patches.

> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

