Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04CDF214E1B
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 19:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbgGERIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 13:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbgGERIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 13:08:12 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE45FC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 10:08:12 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id bj10so9193289plb.11
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 10:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oDn9WZMjwNZ+w57ysOXwQxn7reYWQNZaBmh+6aRV/Fk=;
        b=oSSm5IUPtmvM/SwcsR5wOYe0NMcYemsfSCdag5hAN2dCQ4hTiUyBN1K59B49ocYHm8
         dixCIM3bW6YKiUsMytHsV2I3pMgc3gZGsMrY2Ipcz7+DWX9sPF+W5/m9xjsuPSmKoFA8
         7nPSSLWvruVY1pq87HUvs17GlHjlobhOj13nGgvcwD6UkUps7ONrz3uR2SfimSBG8iR4
         fG3oIYMjVWMnCszjQnNLZq4iYM+Y4r9v2C9E+JjzJ5Ax4qy78PbgdDrGc7cHH2clh47E
         uwcO/9juhv8Bz1JzWTTZtErHN2cwAy4JUU0PHtu/rhpI5/ZMrFrqAugMtuQBpcsurQpr
         2NQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oDn9WZMjwNZ+w57ysOXwQxn7reYWQNZaBmh+6aRV/Fk=;
        b=ZXPrddMg04b6jvMaNIcuUYFTuWuLn+c9WrddD7mn9Fg+uxJ9gsui5qJxgLgcsFEQPx
         l7oazzm260wAhvmwuDJBcski06UwSCip8DwK99m0MVw+hwHt+jB91zNmwl23/81u8hIL
         ZZje9tgWFwfLUooNPRyOlM2XPXbT7jgJynEUvSRL8zvPj6VRn5skItSxDS9BDQzX9K3D
         0RYbOOc8E05ara7l8Q3SH7PZaaX80ZvHvgMoHbc6DVbHEMBnIlFQDrDL2OkK46ZuxPB3
         xX2WbxykT35918d5zWGEiU2P9ryuwflNtxXvpcgED4hXOrCuPb8UTGLMEliuHZTTY+L4
         C8yQ==
X-Gm-Message-State: AOAM532ZI/hw3UR2A041cTrZ6erFj+GsuvpONcJ+e1hezTtdcAx3G5zr
        C3kCmrewzsiiAzC+PgeRtGU=
X-Google-Smtp-Source: ABdhPJze7NTHhCMGhb7zf49fO6+9bZilCQEXMVxQCVd01putU76BtzrESigS+iUQ2ZGJc2uv0x94+g==
X-Received: by 2002:a17:902:b413:: with SMTP id x19mr17200839plr.286.1593968891166;
        Sun, 05 Jul 2020 10:08:11 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id i21sm1279919pfa.18.2020.07.05.10.08.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 10:08:10 -0700 (PDT)
Subject: Re: [PATCH v2 net-next] inet: Remove an unnecessary argument of
 syn_ack_recalc().
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        osa-contribution-log@amazon.com, Julian Anastasov <ja@ssi.bg>
References: <20200704081158.83489-1-kuniyu@amazon.co.jp>
 <20200704152852.39935-1-kuniyu@amazon.co.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <cb795577-4759-3ab6-43c9-7a4f9c8d832f@gmail.com>
Date:   Sun, 5 Jul 2020 10:08:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200704152852.39935-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/4/20 8:28 AM, Kuniyuki Iwashima wrote:
> Commit 0c3d79bce48034018e840468ac5a642894a521a3 ("tcp: reduce SYN-ACK
> retrans for TCP_DEFER_ACCEPT") introduces syn_ack_recalc() which decides
> if a minisock is held and a SYN+ACK is retransmitted or not.
> 
> If rskq_defer_accept is not zero in syn_ack_recalc(), max_retries always
> has the same value because max_retries is overwritten by rskq_defer_accept
> in reqsk_timer_handler().
> 
> This commit adds two changes:
> - remove max_retries from the arguments of syn_ack_recalc() and use
>    rskq_defer_accept instead.
> - rename thresh to max_retries for readability.
> 

Honestly this looks unnecessary code churn to me.

This will make future backports more error prone.

Real question is : why do you want this change in the first place ?

