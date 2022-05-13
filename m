Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4805D525F8B
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 12:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379249AbiEMKH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 06:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359219AbiEMKHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 06:07:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23E66AA46;
        Fri, 13 May 2022 03:07:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 636066222D;
        Fri, 13 May 2022 10:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D07AC34100;
        Fri, 13 May 2022 10:07:53 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="LwDOuIuH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1652436471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7N1zyXIi+oMbfwTrQnEnFevk7qISh3+9W8x85t6Q8bY=;
        b=LwDOuIuHymjucObEZc6dI/e+wZ50PeYNASM60HYX9wYpZsJIZvBVBqAtCFcZsR844wLYPa
        rCG3RtG3UnuMYyVc6ym4HNSTqGtQD7PeAmohnOeVmGeqSWOj+uHuBU/DUldfXPFlyIREl7
        S5KBsIdtQEDxVpxILA3yK/51DIhVYMY=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ae4f983b (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 13 May 2022 10:07:51 +0000 (UTC)
Date:   Fri, 13 May 2022 12:07:49 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Dominik Brodowski <linux@dominikbrodowski.net>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] random32: use real rng for non-deterministic randomness
Message-ID: <Yn4t9S71LhI8W0ek@zx2c4.com>
References: <20220511143257.88442-1-Jason@zx2c4.com>
 <Yn34Tf4CpSaZBlGi@owl.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yn34Tf4CpSaZBlGi@owl.dominikbrodowski.net>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dominik,

On Fri, May 13, 2022 at 08:18:53AM +0200, Dominik Brodowski wrote:
> Nice! However, wouldn't it be much better to clean up the indirection
> introduced here as well? prandom_u32() as wrapper for get_random_u32() and
> prandom_bytes() as wrapper for get_random_bytes() seems unnecessary...

Yes; we can look at tree-wide changes for 5.20. The first step in making
tree-wide changes is filling in the old function with an inline wrapper,
which then gets removed as part of the last step after all the other
patches have landed. That's a huge process, so this is just step one.

Jason
