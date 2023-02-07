Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E4B68CFCB
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 07:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbjBGGuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 01:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBGGuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 01:50:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA172298D9
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 22:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EFC2611C2
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 06:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3274C433D2;
        Tue,  7 Feb 2023 06:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675752620;
        bh=STBJXzqH0rwzIs7C7pXwMEgo8CLNO/9XxONtgn2cYdM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e53adCwbYAZK39ZLH0ywgtHb3s2wt8yO0C8IJjF9sxc67f51J7SsrJ7vr1uiJc3HE
         oVIUGltSz95pGc9VwNCk2kmp9Sc8HbEubxCsoFQW9COCyxKdFBlCvjCd6U2ClEyP0H
         X3+mzlrh/rkMItbVUAZ/X3P4AAaiwx0E47wg9ALM/YF8OlxLrY2Kh2zlnYtYkEmiJo
         A7uQwHuWOR9qIAKSXmubO877cmdjxHUWjUQ3BV8mjIN6MC3zPfSKOSdx165vA3ZKnr
         4/YISD/lKZDLv35M6eUW9LHvWdv/3U0jXVaufBPbDDGtgeIAD0V8lwX5mdRlvOIRkw
         Q9GC+ThWL3DrQ==
Date:   Mon, 6 Feb 2023 22:50:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH net-next v4] gve: Introduce a way to disable queue
 formats
Message-ID: <20230206225018.50d62d62@kernel.org>
In-Reply-To: <20230204192940.2782312-1-jeroendb@google.com>
References: <20230204192940.2782312-1-jeroendb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  4 Feb 2023 11:29:40 -0800 Jeroen de Borst wrote:
> The device is capable of simultaneously supporting multiple
> queue formats. These queue formats are:
> 
> - GQI-QPL: A queue format with in-order completions and a
> bounce-buffer (Queue Page List)
> - GQI-RDA: A queue format with in-order completions and no
> bounce-buffer (Raw DMA Access)
> - DQO-RDA: A queue format with out-of-order completions and
> no bounce buffer

Thanks but..

> With this change the driver can deliberately pick a queue format.

Driver can already do whatever it wants. Now the _user_ can pick 
the format. But the user still has no understanding of what the
practical impact of picking one queue format over another will be.
Do you have a reason to believe that the description above (and in 
docs) will be sufficient for user to make a decision? 

I tried to search the web but got no hits to any GCP docs either.

Differently put what is you motivation to give this control to the user?

> +
> +struct bpf_prog;
>  static int gve_verify_driver_compatibility(struct gve_priv *priv)

Adding the forward declaration for bpf_prog looks like a stray change.
