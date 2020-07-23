Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D81522AADC
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 10:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgGWIkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 04:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728021AbgGWIkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 04:40:02 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A283C08C5C0
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 01:40:01 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id o18so5471908eje.7
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 01:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GBFjr2NO+tPwRt48f6bV0DAq1xVraB+4JvlLFlRB/+g=;
        b=rGyvMeQ+RAXj0neMlTzU8uPVoGP++MmPyXW9rehNveFQBhF8dyYxv6AjBxtstq4TFV
         4fm/sT4fngoHPtNhHHFkRlNaBXaqxFcoxzVPV4jnyhOEIxpE+8WP3v6Ys+mZIZHxnElm
         3+HlzqlN3TTCQNBXVwfzvcuNngRHeRTj8yDoqfrZmGsvdvEkoWCKJ4G7hKyFMO63jS/1
         vJu6u48QBIkiTQUHfssZnDO3TKFO/LYe7iUYcCJScMS5N6nkTfO2ZkCaQ5+U85Bpfz5I
         QzSiZ0n35L2/+Xm7/99AiElI31daRjEc7Mt7bFjI3zXI8qtconQ7jAfr+lIgPePAz6Ta
         OZpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GBFjr2NO+tPwRt48f6bV0DAq1xVraB+4JvlLFlRB/+g=;
        b=ONiuqTYECa8PoX2KjAIbjXMO5xKhg8XASk0DxfkDgimXEY83An10pVFHBjdBRNb91V
         yLQzXNDNgU50I9IUKkSkgiehVSjp0zzZoRtrXr9/0O933uj5hL1GGiQTlEx7RdduD/s/
         G36DEvOUdx1vMXAqqfhIlrgtVPFc4wjPgMzn8OSSa7f7p+QRrFzPsX15KyQfBOs6PzLl
         mPiluxC9hBsXP8XkDQ7O3L2nFOWYAvwypNx69L/Cr/PL8uQKSQ14SUC/KH+3dU14A391
         XiBI+XvhaH/A64i84cnqUVLp9uWhd5Duaix9IYue474Tl4veGMvII20cbh9SKsX7zPU2
         XtzA==
X-Gm-Message-State: AOAM532kNNTG450nQnkAuxmqLBMrNM/ZvuyUUKAyJdyerJMAZojaEA9z
        HB1IJNxQAYv+DdHLopYlL8IOYg==
X-Google-Smtp-Source: ABdhPJxCoyR6XAi+VAaWwhsRGBR37Zk2lE1XCLCzXK9C/pnGAxIlGjt4DDu+Ll1G6Qz23LuzpAwjkw==
X-Received: by 2002:a17:906:b0d3:: with SMTP id bk19mr3489955ejb.167.1595493599663;
        Thu, 23 Jul 2020 01:39:59 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([79.132.248.22])
        by smtp.gmail.com with ESMTPSA id z22sm1634990edx.72.2020.07.23.01.39.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 01:39:59 -0700 (PDT)
Subject: Re: [MPTCP] [PATCH 25/26] net: pass a sockptr_t into ->setsockopt
To:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org,
        Stefan Schmidt <stefan@datenfreihafen.org>
References: <20200723060908.50081-1-hch@lst.de>
 <20200723060908.50081-26-hch@lst.de>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <1056b902-fd25-1c13-758d-cd4341dd403b@tessares.net>
Date:   Thu, 23 Jul 2020 10:39:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200723060908.50081-26-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph,

On 23/07/2020 08:09, Christoph Hellwig wrote:
> Rework the remaining setsockopt code to pass a sockptr_t instead of a
> plain user pointer.  This removes the last remaining set_fs(KERNEL_DS)
> outside of architecture specific code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Stefan Schmidt <stefan@datenfreihafen.org> [ieee802154]
> ---
>   net/mptcp/protocol.c                      | 12 +++----

Thank you for the v2!

For MPTCP-related code:

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
