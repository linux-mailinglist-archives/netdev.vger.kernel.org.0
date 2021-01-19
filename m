Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2536E2FAFD8
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 06:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732161AbhASEr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 23:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730046AbhASEhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 23:37:25 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07331C061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 20:36:39 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id i18so4627495ooh.5
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 20:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z8iuKXvAL3hk6T2BINpw09rjR9nNUS884dQZyC6NSz0=;
        b=SyHHarU0HY8cvkXgB90ADPjGAHf07yG0s74BO+I5+WMCu9O5MCdkpel7GkVHhfiJ2F
         AktTg3ebG4itRtbcqv2GBeWBILv0IBgC4D2Owv8WrKBMxJBD6IuABfFoa5wWQzdKTHx5
         Qz6CnJ4Kx275F1DB2clfKUzPi4spXLvv211u1D70n50Vce+h1VCdHLb2uxCkpST/gRll
         Gu5OKAbs7YoZoRrl4TxdPxovDbEXLVKcQzSgsHwKTo0WDINX3c8jZwaAGMBSsXg7Ah/j
         JQsdLwKJAM9YfA79eY0t4PSqh7hEyVEbegqu3NSbyB5y9an8gbWTfJn0xARBsOHhrlns
         nnlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z8iuKXvAL3hk6T2BINpw09rjR9nNUS884dQZyC6NSz0=;
        b=MX280Kc9D24Ag47lyIzjD+YemP5w8cLa52VJ+a3Z1wQQc0S4qfGPGOcQYTcJeNiUvY
         jz1GGDGPvABq7+benbFBZ+1xRtbLBl3/rCbEUQD5gEXE5KDZgzPpJcmV3LHjo+XeFI4N
         hyb08fvpYGDWtEUmgG+7fZ5vBvRGgP3eSqH/4zUCwR6pVnn3uzMa+RvQtioHMwL23yeY
         lqE10KMaKTF09mBL1BWQmOPjjZ2lb+X1BOg2qjrvOyOplGg5YVu6qEhNWOT3Iv6J8TmC
         D6eedBKt9LKBCGzdUqImWleDY1aj1Gc3i92cFNhesn4uIWY1JIrnf07k44ODwKaeskRw
         aZbg==
X-Gm-Message-State: AOAM531waFAgLcQr0n51eZ1a6zziCXNZOhYS5XB031hPPKw4S/F/KDkL
        WXzzNbtWJOW/QTZ3Fq5owLA=
X-Google-Smtp-Source: ABdhPJxCh8B22KtCBJsK7gdlf5Ac953lET+YJ5p0W5L3QL82Ct/eclsfTJ7dCBr7X+7kz2qiQrf8zQ==
X-Received: by 2002:a4a:eb18:: with SMTP id f24mr1586221ooj.80.1611030992663;
        Mon, 18 Jan 2021 20:36:32 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.6.112.203])
        by smtp.googlemail.com with ESMTPSA id n16sm4103817oov.23.2021.01.18.20.36.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 20:36:32 -0800 (PST)
Subject: Re: [PATCH v2 net-next 19/21] net/mlx5e: NVMEoTCP, data-path for DDP
 offload
To:     Boris Pismenny <borispismenny@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de,
        sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com, smalin@marvell.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
References: <20210114151033.13020-1-borisp@mellanox.com>
 <20210114151033.13020-20-borisp@mellanox.com>
 <10c28b01-49e5-c512-8670-bf8332b24b1b@gmail.com>
 <15248743-82bf-4283-d8c6-99f2210e42ae@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2a0bfce0-6226-7b9a-95b1-15f4f1f321e8@gmail.com>
Date:   Mon, 18 Jan 2021 21:36:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <15248743-82bf-4283-d8c6-99f2210e42ae@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/17/21 1:42 AM, Boris Pismenny wrote:
> This is needed for a few reasons that are explained in detail
> in the tcp-ddp offload documentation. See patch 21 overview
> and rx-data-path sections. Our reasons are as follows:

I read the documentation patch, and it does not explain it and really
should not since this is very mlx specific based on the changes.
Different h/w will have different limitations. Given that, it would be
best to enhance the patch description to explain why these gymnastics
are needed for the skb.

> 1) Each SKB may contain multiple PDUs. DDP offload doesn't operate on
> PDU headers, so these are written in the receive ring. Therefore, we
> need to rebuild the SKB to account for it. Additionally, due to HW
> limitations, we will only offload the first PDU in the SKB.

Are you referring to LRO skbs here? I can't imagine going through this
for 1500 byte packets that have multiple PDUs.


> 2) The newly constructed SKB represents the original data as it is on
> the wire, such that the network stack is oblivious to the offload.
> 3) We decided not to modify all of the mlx5e_skb_from_cqe* functions
> because it would make the offload harder to distinguish, and it would
> add overhead to the existing data-path fucntions. Therefore, we opted
> for this modular approach.
> 
> If we only had generic header-data split, then we just couldn't
> provide this offload. It is not enough to place payload into some
> buffer without TCP headers because RPC protocols and advanced storage
> protocols, such as nvme-tcp, reorder their responses and require data
> to be placed into application/pagecache buffers, which are anything
> but anonymous. In other words, header-data split alone writes data
> to the wrong buffers (reordering), or to anonymous buffers that
> can't be page-flipped to replace application/pagecache buffers.
> 

