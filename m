Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA8501499FB
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 11:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbgAZKML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 05:12:11 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:53609 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726571AbgAZKMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 05:12:10 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id B800C544;
        Sun, 26 Jan 2020 05:12:09 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 26 Jan 2020 05:12:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=XlM5aTqPjEMi9TaRomrJUnEnkRR
        2amKVBeDI73t0AQQ=; b=CMfPnwP2H6fEi0z9AqWtYq0ysw9Id85b/RaWZ9pfPPz
        rU8k4Bmqin2KENdWWW6a/UMZOu6JWoF+O4qXKYVp10GD2zcSQlg8NpazDqubrOM/
        FKIxr8tF4orLNCRMsC9Hlhrct3ITpLxB+PKnlntTSNJdKqNhjR3xSUVyhjOVpHQY
        /meChs7RZTM8u9mAUd2xSurIdlQIqINPxq2Zp1AMbKmCVyOTsJqm+HylDJuYqWvv
        w1kQaOiquuSyrbX4oS+Kzu6mobs4ZIAw8YZh/10MAjS/jFc/37eR4P0XVDI9C7x4
        wkx5MRBvLANpHtUPNnw47NQrIEYOjG6OWxcbofT9s3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=XlM5aT
        qPjEMi9TaRomrJUnEnkRR2amKVBeDI73t0AQQ=; b=C7zhslTfX0zUmlJcKjrqtZ
        Cmvce/WhTxCm9+27sK+cJV4mJqV/sNqYxH8cG66hb4NzLQtxSFcejbE8G0OUNJqO
        VqPWepIwT2RiqJyMqvhgnROOxdYf8Lyj8t3AtsgTmiKEy1kGPLJm1OM+SdiozPJl
        XVsZO/fPEc0DJuAdIYz/ZgGASc3CnGkqKs8Hs6eBCYN8wiMa5G4ekGh1907Og51m
        5A6rrhyX1V0hn8rLwisHkVCVLlyIOV2XFdL362LtlEaimstSXhc8ltJRU3ok+elg
        1Jp46IyKim9ksAbKAOoTzXA3fXcIj/ZY2W8unmQry7KdZ/kJAxfumKmVolJ8QOJQ
        ==
X-ME-Sender: <xms:-GUtXgf9s2Q4CGrYDm7aW_TXGACLCva4oazKZ_x8nRQvMaAkMHVO_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrfedtgddufecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecukfhppeeije
    drudeitddrvddujedrvdehtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:-GUtXpBri47xySrfzwc8IxHC6vzJT0ldodcFm-Osifek0DD8RyNiCg>
    <xmx:-GUtXqfCTdq1ffp7T9CYbxhWDmoQd5xWWLLAmYeD5s4Yr9j-HO93-Q>
    <xmx:-GUtXoy28yvR5WoGbcB_NTWtwd68gULPd0Yvqza03dqFX4EkO-IKAg>
    <xmx:-WUtXgfK7jJYx96ODHA9vZVWxxFhX0UFxYJjV7tZl6mpzY5giI5q8w>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 96F4730673EF;
        Sun, 26 Jan 2020 05:12:08 -0500 (EST)
Date:   Sun, 26 Jan 2020 02:12:07 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
        davem@davemloft.net, netdev@vger.kernel.org, jannh@google.com
Subject: Re: [PATCH 2/4] io_uring: io_uring: add support for async work
 inheriting files
Message-ID: <20200126101207.oqovstqfr4iddc3p@alap3.anarazel.de>
References: <20191025173037.13486-1-axboe@kernel.dk>
 <20191025173037.13486-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025173037.13486-3-axboe@kernel.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2019-10-25 11:30:35 -0600, Jens Axboe wrote:
> This is in preparation for adding opcodes that need to add new files
> in a process file table, system calls like open(2) or accept4(2).
> 
> If an opcode needs this, it must set IO_WQ_WORK_NEEDS_FILES in the work
> item. If work that needs to get punted to async context have this
> set, the async worker will assume the original task file table before
> executing the work.
> 
> Note that opcodes that need access to the current files of an
> application cannot be done through IORING_SETUP_SQPOLL.


Unfortunately this partially breaks sharing a uring across with forked
off processes, even though it initially appears to work:


> +static int io_uring_flush(struct file *file, void *data)
> +{
> +	struct io_ring_ctx *ctx = file->private_data;
> +
> +	io_uring_cancel_files(ctx, data);
> +	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
> +		io_wq_cancel_all(ctx->io_wq);
> +	return 0;
> +}

Once one process having the uring fd open (even if it were just a fork
never touching the uring, I believe) exits, this prevents the uring from
being usable for any async tasks. The process exiting closes the fd,
which triggers flush. io_wq_cancel_all() sets IO_WQ_BIT_CANCEL, which
never gets unset, which causes all future async sqes to be be
immediately returned as -ECANCELLED by the worker, via io_req_cancelled.

It's not clear to me why a close() should cancel the the wq (nor clear
the entire backlog, after 1d7bb1d50fb4)? Couldn't that even just be a
dup()ed fd? Or a fork that immediately exec()s?

After rudely ifdefing out the above if, and reverting 44d282796f81, my
WIP io_uring using version of postgres appears to pass its tests - which
are very sparse at this point - again with 5.5-rc7.

Greetings,

Andres Freund
