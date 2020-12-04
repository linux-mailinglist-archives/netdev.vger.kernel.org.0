Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13FD2CECF3
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 12:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgLDLVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 06:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgLDLVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 06:21:17 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEE5C0613D1
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 03:20:37 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id g185so6688041wmf.3
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 03:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g8YR0hRxIujjnFQkpIHB/e9UPjChJMy2MX/WJ8vQFvU=;
        b=uSj5UqdvwLTcduz1/AqMrA+g56oyCTcvWg++wDM9vYnYaepmTiZKgWTy9I0AqOB1oB
         X6mIKYXc1WcTgaPxHC3gILsavNw4Ceg2t80auo5KD7EbClOqTNpJKidwwJSkr0lW5rv3
         /xzFek3q8J3LAV9VV8NXr9wTYLezprVlnoJxnPs/sNC4oqaJqXHlJGkDuJZujFtKzOl0
         AuhaFCPBOmMJGPdP2xPyX1pxtM7hDehLu96DT3ROzXAhWU6T1kOKwOLC7n66FRF1DSar
         aLmYdmTGvdWOIfn1UFFW0fwtjxef86kdPmDiYI3S53EGXI6NIC27VK29+jMUbvu6NTsQ
         XYFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g8YR0hRxIujjnFQkpIHB/e9UPjChJMy2MX/WJ8vQFvU=;
        b=ZgBJajuYSIPyUCcn/gRZ49/3MHre/SHrrLhcII7txh9ChVjacs50fQHk6SeVfCdWzC
         lefaG9dWicJTz6vW4v/eSFQN0HFYayXNGZft3KJqwWaHTbSGmEm9ptL7oTQka2HegYao
         qfTxV63Hu8guhAcUehu7nlvgzJiRgM3/BJ9M1pAXD2Tzj5N7U7E/fzIMgZ9bLWManxbP
         RorRan7GRW4vDIn814Nv1bN9Mfzhh8AUcGbjKU32DNqK2/I4VQJAGU3RgZFOAoe0RSoP
         XIBNqrdJ8ldWivFwuGWu43wKB1vvMAYTC2PVwlJpvf0h+jBwtkMl3VjBbCytyn9+cdNJ
         xmXw==
X-Gm-Message-State: AOAM5327C4oIB1bDmLUx5DjGCrVqtQ2aYn7H3UKrMQtkZmPLrTyRDNFB
        tSkZZoVs4tCd8opCiDI1A3tiOXPEejkq0Q==
X-Google-Smtp-Source: ABdhPJzCf2WbbLDbq8j4WrhrqJC0x8iYKAEsAxHZfLaYhGHuoVfjF4iv9aD93vf8TB12jn4qOrEVuA==
X-Received: by 2002:a1c:c902:: with SMTP id f2mr3711915wmb.130.1607080834625;
        Fri, 04 Dec 2020 03:20:34 -0800 (PST)
Received: from [80.5.128.40] (cpc108961-cmbg20-2-0-cust39.5-4.cable.virginm.net. [80.5.128.40])
        by smtp.gmail.com with ESMTPSA id v20sm2590989wmh.44.2020.12.04.03.20.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 03:20:33 -0800 (PST)
Subject: Re: GRO: can't force packet up stack immediately?
To:     John Ousterhout <ouster@cs.stanford.edu>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org
References: <CAGXJAmx_xQr56oiak8k8MC+JPBNi+tQBtTvBRqYVsimmKtW4MA@mail.gmail.com>
 <72f3ea21-b4bd-b5bd-f72f-be415598591f@gmail.com>
 <CAGXJAmwEEnhX5KBvPZmwOKF_0hhVuGfvbXsoGR=+vB8bGge1sQ@mail.gmail.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <4d5b237b-3439-8242-4d2c-b27f9fcb49ca@gmail.com>
Date:   Fri, 4 Dec 2020 11:20:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CAGXJAmwEEnhX5KBvPZmwOKF_0hhVuGfvbXsoGR=+vB8bGge1sQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/12/2020 19:52, John Ousterhout wrote:
> Homa uses GRO to collect batches of packets for protocol processing,
> but there are times when it wants to push a batch of packet up through
> the stack immediately (it doesn't want any more packets to be
> processed at NAPI level before pushing the batch up). However, I can't
> see a way to achieve this goal.
It's kinda hacky, but you might be able to call netif_receive_skb_internal()
 yourself, and then return ERR_PTR(-EINPROGRESS), so that dev_gro_receive()
 returns GRO_CONSUMED.
Of course, you'd need to be careful about out-of-order issues in case
 any earlier homa packets were still sitting in the rx_list.

Other than that, I don't think there's currently a way for a protocol
 to tell GRO to flush out the whole rx_list (which could be argued to
 be a layering violation, anyway).  You might potentially be able to
 add a flag to struct napi_gro_cb and teach napi_gro_complete() or
 gro_normal_one() to check for it, but — we'd only consider adding
 something like that with an in-tree user, which your protocol doesn't
 appear to be AFAICT.

-ed
