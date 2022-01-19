Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA2F493D65
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 16:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355835AbiASPlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 10:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355826AbiASPk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 10:40:57 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A284C061574
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 07:40:57 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id d14so2518455ila.1
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 07:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=unwF9QbB1EwW1U667yhctowhDFu5SZcl3y/KxnaePIE=;
        b=l3YrgfO57SFwdrJjW/Nvp8k7Zb41PBf8jxAhxd3Vu81jZsL5wSw3bRcpeokZYcnn3y
         gs9G++2vxGa0YDoRN0vQ5ES+sUic9w2vOVHwXwhffdXmbxISx3Ns3iEy0vgoGRCKBulV
         ZUxiiR6X75CH2sfeME5t9t5gOrVP3mx0lUzW9YZPLO10yNBtsQttXTK12T9D2t6cwCr4
         IDprsv7mrPXWdzgA3qWM493YqYz8DPDecb31iKIYckPIx/KpGhGiKdWOQ4uhbDQmEUd7
         bdXo2yvd3PM/4EsUvDb8HkBvyp4wcaRs9uxIBYGO+SrJKXpL4YKLGAwPSBzw/o4XIo75
         TxZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=unwF9QbB1EwW1U667yhctowhDFu5SZcl3y/KxnaePIE=;
        b=aA9WAoK0JsT78pqs28hTjADPV2uqD74/OArZZFQRUegd6DsN4fRLXIdxPy4olWmWzq
         dUp/ZrYUFAE7onfkMPtXrBH2Nbgl7gMD7EwF6rryQ1NpuafS0poP1VfWrgmI8xefd6S5
         Yf6JpOngj9aikKzvFGwAf4McZ73rXHzPe4c6VM7bJ4Xv5S01jWXGJwVWEjZ3djRzRALK
         Tb94b9VuVjhnvyWKEjixbhXdt6Gb4zNF1I/pTZOPQBmbRrzV1V6OkkUtzOS1vXAWrG9e
         EtZIlLPWOv+bi/9rLfs3DMxCqJndIirStkwe/WkSRxA9M7LAhitfaHAC83ihnlDt3Coz
         xBNQ==
X-Gm-Message-State: AOAM5338ku57Z05boWBRsjL4QpHMM2pqPg7D7ugyW5qoRrDtTSQaQ/lN
        oD95dfWGRiBiDv+1q+sXqadoTP91UhU=
X-Google-Smtp-Source: ABdhPJxOVUD+sqNUyaQjhZWYeef82+XBi6m113ZDjUCZ31lZNyhvH53EbUZrCW1/F0F9b1F61UoUtQ==
X-Received: by 2002:a92:d68b:: with SMTP id p11mr15528731iln.222.1642606856495;
        Wed, 19 Jan 2022 07:40:56 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.58])
        by smtp.googlemail.com with ESMTPSA id b11sm88413ilr.51.2022.01.19.07.40.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 07:40:55 -0800 (PST)
Message-ID: <1432bf8b-dda9-0cd0-d04a-aab41cb216d2@gmail.com>
Date:   Wed, 19 Jan 2022 08:40:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH v2 net 2/2] ipv4: add net_hash_mix() dispersion to
 fib_info_laddrhash keys
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20220119100413.4077866-1-eric.dumazet@gmail.com>
 <20220119100413.4077866-3-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220119100413.4077866-3-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/22 3:04 AM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> net/ipv4/fib_semantics.c uses a hash table (fib_info_laddrhash)
> in which fib_sync_down_addr() can locate fib_info
> based on IPv4 local address.
> 
> This hash table is resized based on total number of
> hashed fib_info, but the hash function is only
> using the local address.
> 
> For hosts having many active network namespaces,
> all fib_info for loopback devices (IPv4 address 127.0.0.1)
> are hashed into a single bucket, making netns dismantles
> very slow.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/ipv4/fib_semantics.c | 29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


