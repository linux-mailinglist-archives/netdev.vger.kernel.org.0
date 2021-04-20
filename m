Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221CC365DA1
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 18:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbhDTQoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 12:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbhDTQoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 12:44:15 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1ECC06174A;
        Tue, 20 Apr 2021 09:43:42 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id r7so26331854wrm.1;
        Tue, 20 Apr 2021 09:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LpVz5RmpwtqItSVESt1PTOxzEM6O2cxGwpOaIWTZdzU=;
        b=NlRKRpEIay2vRk/+cunFLLCQczYArdIYpVXduxEYEXSq8GL2Lv5cZUqZShkgCrdj9Y
         AwhvMFSYeK0wUwep5OtkM6CIURtWoNS6jfS6WIeoz4op7VOvnjr4eSlkQd0Ot/6L15Rz
         hXOnCunkC+kbD1sQE5Gz8szSCu0wWTn0jfAJ4rQ+nz4/OdicJMVSgSC1g1Q3NWsVnMVE
         awUyiHHXzUPz+H3S+A2yuVeAIE/6sgEDBAHbfk/qtSgYkRKAggN+Kf8Fd13xq8U5y3Fr
         8VK+jYwiBirFFoOB1kp84M0eEDl5fOaHqsoQU6IWPA71aofE65Fi7kD3FivpXVXAlmYF
         zHbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LpVz5RmpwtqItSVESt1PTOxzEM6O2cxGwpOaIWTZdzU=;
        b=S2Pbz09wkZefCBmzti8poL2rNc1F+j+A6lFDP/kkD2vwkAiZznIg7h+AYZ0YtStPUH
         knXnUUsEd8xrP2PuPXrFQtbubuJiajv31uZPY1MTWyvY5XIT7ru6v83zUVrouyBmkyQY
         D8uQv5NWlp1EYW3t6jQ3Pm5m+KIAAiSQxPguhBcCFx1aMHvVy1i7/mJlN2lIVvtd3REY
         l04OI809Zja02Ghno9DRYvYgVvuqgZ81fTnHN40/mVoWotekbEXaYg95ugfb4U0qzJTT
         NnOSApoc0iATiqvfjQzbIphLfPyj6Pfx+F2vsNzSzwIQbOWsjcMBW+7NltYpFky/dArV
         AdOg==
X-Gm-Message-State: AOAM532C1hjgKKWjl2QM0TfN59i2dEuhRXG/+Lw+5m8XYVP+RJL9KyOu
        GiJYKxc+wNMZA6/4pGEAeCWSGU53Qjo=
X-Google-Smtp-Source: ABdhPJzx47XUjPjSlcDso/iy62dphANI1REQIx62gYqRtRNBWPiHHh9l/5tlWHnUUqLFNTY4IjnOWg==
X-Received: by 2002:adf:f38e:: with SMTP id m14mr21229678wro.34.1618937020346;
        Tue, 20 Apr 2021 09:43:40 -0700 (PDT)
Received: from [192.168.1.102] ([37.164.106.63])
        by smtp.gmail.com with ESMTPSA id m2sm3571453wmq.15.2021.04.20.09.43.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 09:43:39 -0700 (PDT)
Subject: Re: [PATCH v3 bpf-next 00/11] Socket migration for SO_REUSEPORT.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210420154140.80034-1-kuniyu@amazon.co.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <67fb2df2-3703-4ce9-62d0-ba15435c5a0b@gmail.com>
Date:   Tue, 20 Apr 2021 18:43:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210420154140.80034-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/20/21 5:41 PM, Kuniyuki Iwashima wrote:
> The SO_REUSEPORT option allows sockets to listen on the same port and to
> accept connections evenly. However, there is a defect in the current
> implementation [1]. When a SYN packet is received, the connection is tied
> to a listening socket. Accordingly, when the listener is closed, in-flight
> requests during the three-way handshake and child sockets in the accept
> queue are dropped even if other listeners on the same port could accept
> such connections.
> 
> This situation can happen when various server management tools restart
> server (such as nginx) processes. For instance, when we change nginx
> configurations and restart it, it spins up new workers that respect the new
> configuration and closes all listeners on the old workers, resulting in the
> in-flight ACK of 3WHS is responded by RST.
> 
> The SO_REUSEPORT option is excellent to improve scalability.

This was before the SYN processing was made lockless.

I really wonder if we still need SO_REUSEPORT for TCP ?

Eventually a new accept() system call where different threads
can express how they want to choose the children sockets would
be less invasive.

Instead of having many listeners, have one listener and eventually multiple
accept queues to improve scalability of accept() phase.

