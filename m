Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4748824E271
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 23:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHUVK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 17:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726306AbgHUVK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 17:10:56 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733EBC061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 14:10:56 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id f75so2274368ilh.3
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 14:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ng6/G9RSzxwRB6HJfeDadSrodD/T5xTTHLF+jZi9TTo=;
        b=nTcZrTwyvaE082x6Eye9pH6tQqCUkx2yfTVgy4mZJb6LqFn2z9iTNnklYo1x5izFMi
         iiHu4B/PmpPvVwpg4zPr/GTy5PB8pAmhAygzqHkaQbNcczCtOeJR4SVEYcNHgxPGaJiE
         wXqbE19F3I8eoG7BB3b9dJ+u/nDyJQ7KWdBBtnamp8P0tejUjRkE4PdwlznvMsO2V/IF
         +y1EAK2l8UCRJqyCRa5b4lGi55ichkzQQd0QX2FSTF83kVzVadlNgr5+NORDw3qu5eJL
         kDyrXMQ1wfTSxHqAM4rd9SkJ05KEZBZAj4NhVkzsBW15DIYiAxDuIsQ4t8OW4G5gRdQ/
         CjmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ng6/G9RSzxwRB6HJfeDadSrodD/T5xTTHLF+jZi9TTo=;
        b=Tz/8U55kJpQnYY3qvIktp1SuvesJaa35/QPUKqeNU9jtSm5GuKrVyl29jN/doNhdQI
         SYqbOuZn1JbKktGVM8A0C0CuH5M16mEg/jNen0+qOPCjXPZF9Cgg8/RZEDqesGiPThir
         GFMVDwNvt82fiqGiAExlzpw/0TKHdSo1OTXoqC2pHgaIMvAm59S+JYL5WCTkwe16izL/
         UBVmoWPW7U90gIoGM6RCdpKJPzAsR92z3w/u2+rPlg8Ra/U1+jmPknidmt3UWw0lIjJG
         pYfCt+yoZr3DgcDkAIzWA3D28lWqbgSk2pnuU+vH/7PRykFXYNIxSNNBfo8QYaxRTS2w
         oZeA==
X-Gm-Message-State: AOAM533APILc2sHPifFPvdUDgfUJ5Ye5ILTBOh6GStbUAli41c2llBGg
        /D/SQ73ZP36UX+z/kiJzxXmGEg==
X-Google-Smtp-Source: ABdhPJxxiIxGPV8q7fMZoLHlRqZ15cUX11O3lcD4TSOFmbsDA55Plfc0bqv7PFubeAYStA1Mz/t8xQ==
X-Received: by 2002:a92:8556:: with SMTP id f83mr3891459ilh.135.1598044255798;
        Fri, 21 Aug 2020 14:10:55 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m18sm1888260iln.80.2020.08.21.14.10.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2020 14:10:55 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] io_uring: allow tcp ancillary data for
 __sys_recvmsg_sock()
To:     Luke Hsiao <luke.w.hsiao@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Luke Hsiao <lukehsiao@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jann Horn <jannh@google.com>
References: <20200820234954.1784522-1-luke.w.hsiao@gmail.com>
 <20200820234954.1784522-2-luke.w.hsiao@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a81192cd-822d-682a-4ddb-2171d7cac707@kernel.dk>
Date:   Fri, 21 Aug 2020 15:10:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200820234954.1784522-2-luke.w.hsiao@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/20 5:49 PM, Luke Hsiao wrote:
> From: Luke Hsiao <lukehsiao@google.com>
> 
> For TCP tx zero-copy, the kernel notifies the process of completions by
> queuing completion notifications on the socket error queue. This patch
> allows reading these notifications via recvmsg to support TCP tx
> zero-copy.
> 
> Ancillary data was originally disallowed due to privilege escalation
> via io_uring's offloading of sendmsg() onto a kernel thread with kernel
> credentials (https://crbug.com/project-zero/1975). So, we must ensure
> that the socket type is one where the ancillary data types that are
> delivered on recvmsg are plain data (no file descriptors or values that
> are translated based on the identity of the calling process).
> 
> This was tested by using io_uring to call recvmsg on the MSG_ERRQUEUE
> with tx zero-copy enabled. Before this patch, we received -EINVALID from
> this specific code path. After this patch, we could read tcp tx
> zero-copy completion notifications from the MSG_ERRQUEUE.
> 
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Acked-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Jann Horn <jannh@google.com>
> Signed-off-by: Luke Hsiao <lukehsiao@google.com>

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

