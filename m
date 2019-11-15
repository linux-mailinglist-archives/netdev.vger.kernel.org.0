Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0ABFE5B5
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 20:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfKOTfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 14:35:10 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43408 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfKOTfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 14:35:10 -0500
Received: by mail-pf1-f193.google.com with SMTP id 3so7142844pfb.10
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 11:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=SYrybljTLmRZf2tyoawg2jBMOahFgH2xWbEpDAnPmHs=;
        b=ERWegw+rkZGi3bA3leKMvQull6+mUzLy2r4w7AMqNqz5eHqpCNRBLJT0UegqMzrosQ
         +B1rr7rCFSX2WV56RapRnIto91FvCKddvkMG3WPcMKzXqWLnJVgaEOTGS/M4Gj/kznuU
         1LRp2joPQGYsHZAYovPqGuvb2nGImjXXRPyCpCoG5FzYwsJCvnRrz4b4BbsTuyW2bWd2
         lZ6ERX0nh7I+olyOl8E666+lNUkhiSBK0yicwLp4F13lqWa7j70fFZxNoab4HSb9jdgC
         WB12PUScJLbv9OvOwBYocKvLr9OsHDV/AiIGWqsTAzvSE84V28LQIlQgygBN11vn9Bgq
         jeeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=SYrybljTLmRZf2tyoawg2jBMOahFgH2xWbEpDAnPmHs=;
        b=emz1qJ/ViYYwQxlvTMUodw5HipB/MyiRh/GN/CuJmjQ3oCWjpgvEthM2I0ze2d/rYk
         UJVQIMdaZQEFgRgUKte4Nay/JLwcu627j+DU2EaW2XV42oTvPvsEuPAHeOrV7f2EbUDx
         HILOJb7d+X1UAynkaUd1+iKN8+J8LsScQY/RMlzOrywuqOSMj5DwY7LSuyKqGfcGPU7r
         kl6IGLPYVW3bkLnhYooBchHAJfJGcAh7VQ7VvJsxsFiLE+EJ211iJ4uYzmppQu8Z2eTh
         E+tluAqeA8+Tkz0acCpwfbuC4b0SnBOCQPZcKPfduH1zqLDTTdPsfK+AwPP+ENySTK52
         eZrg==
X-Gm-Message-State: APjAAAUqev1qB5VZ05guxCOfjO07YVOBzrAxnisEfWOoosCoWChfQ8q9
        sxSjuxwd213l1u99gr5NXrE=
X-Google-Smtp-Source: APXvYqwB04Z3zeMscnnqNddyKOu0o1RkIijHvwSK1Lo/ayz/B+oNUTDdyIOQv3ZuDHw3tUiGMVlqXQ==
X-Received: by 2002:a63:1e0d:: with SMTP id e13mr9179350pge.166.1573846508796;
        Fri, 15 Nov 2019 11:35:08 -0800 (PST)
Received: from [172.20.54.79] ([2620:10d:c090:200::2:83d7])
        by smtp.gmail.com with ESMTPSA id w5sm12324303pfd.31.2019.11.15.11.35.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Nov 2019 11:35:08 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Lorenzo Bianconi" <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        ilias.apalodimas@linaro.org, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, mcroce@redhat.com
Subject: Re: [PATCH v3 net-next 2/3] net: page_pool: add the possibility to
 sync DMA memory for device
Date:   Fri, 15 Nov 2019 11:35:07 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <A329EE59-03C4-424C-8C17-10E434CE39AD@gmail.com>
In-Reply-To: <1e177bb63c858acdf5aeac9198c2815448d37820.1573844190.git.lorenzo@kernel.org>
References: <cover.1573844190.git.lorenzo@kernel.org>
 <1e177bb63c858acdf5aeac9198c2815448d37820.1573844190.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15 Nov 2019, at 11:01, Lorenzo Bianconi wrote:

> Introduce the following parameters in order to add the possibility to sync
> DMA memory for device before putting allocated pages in the page_pool
> caches:
> - PP_FLAG_DMA_SYNC_DEV: if set in page_pool_params flags, all pages that
>   the driver gets from page_pool will be DMA-synced-for-device according
>   to the length provided by the device driver. Please note DMA-sync-for-CPU
>   is still device driver responsibility
> - offset: DMA address offset where the DMA engine starts copying rx data
> - max_len: maximum DMA memory size page_pool is allowed to flush. This
>   is currently used in __page_pool_alloc_pages_slow routine when pages
>   are allocated from page allocator
> These parameters are supposed to be set by device drivers.
>
> This optimization reduces the length of the DMA-sync-for-device.
> The optimization is valid because pages are initially
> DMA-synced-for-device as defined via max_len. At RX time, the driver
> will perform a DMA-sync-for-CPU on the memory for the packet length.
> What is important is the memory occupied by packet payload, because
> this is the area CPU is allowed to read and modify. As we don't track
> cache-lines written into by the CPU, simply use the packet payload length
> as dma_sync_size at page_pool recycle time. This also take into account
> any tail-extend.
>
> Tested-by: Matteo Croce <mcroce@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
