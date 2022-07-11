Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79801570677
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 17:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbiGKPAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 11:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbiGKPAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 11:00:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635F967C9A;
        Mon, 11 Jul 2022 07:59:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA8C1B80FD4;
        Mon, 11 Jul 2022 14:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB573C341C8;
        Mon, 11 Jul 2022 14:59:23 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="PZIa/k5w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1657551562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mxP/vEZ3Mr3qqDMMF3zIXJpuCmFeAsuQEXwXxV8Yffs=;
        b=PZIa/k5wzyfIGju7PrzrizUwDtF5IVd9x9c/ABTM3Z/kHGHzu33q1x0jX60CQ5q5qCVGTi
        skihAGqu92TU+ZJM2f7FgoVyMBT2YW/m9K8r1SSiC/s7FlviTqpcVCNhqjkLjv/v68jqvX
        1YDOmZXWUfiLDHgb7mkU/mpFaklcqCk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 085561c8 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 11 Jul 2022 14:59:21 +0000 (UTC)
Date:   Mon, 11 Jul 2022 16:59:18 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: make the sha1 library optional
Message-ID: <Ysw6xiuLmV4NuGsf@zx2c4.com>
References: <20220709211849.210850-1-ebiggers@kernel.org>
 <20220709211849.210850-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220709211849.210850-3-ebiggers@kernel.org>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 09, 2022 at 02:18:49PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since the Linux RNG no longer uses sha1_transform(), the SHA-1 library
> is no longer needed unconditionally.  Make it possible to build the
> Linux kernel without the SHA-1 library by putting it behind a kconfig
> option, and selecting this new option from the kconfig options that gate
> the remaining users: CRYPTO_SHA1 for crypto/sha1_generic.c, BPF for
> kernel/bpf/core.c, and IPV6 for net/ipv6/addrconf.c.
> 
> Unfortunately, since BPF is selected by NET, for now this can only make
> a difference for kernels built without networking support.

Seems like a step in the right direction, thanks.

Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
