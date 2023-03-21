Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62166C3AC7
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 20:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbjCUTgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 15:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbjCUTfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 15:35:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99B624BFA;
        Tue, 21 Mar 2023 12:35:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0C1561DE2;
        Tue, 21 Mar 2023 19:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C45C433EF;
        Tue, 21 Mar 2023 19:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679427245;
        bh=gQ2gzzhOzltEtx3g9kF7Jdq/dw5w9/Uy8ZvBSkBR9AA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QV9CuRJlCSTRmHLL3qTD0DNariHmBpQbnNF2USf+Kp5ln9rftl+H6Tu3tyh5VVhw1
         /jWkLAYOCygBlpjn90HUzRTtAmPTNgXIudnr9WfW1KvL4eK1uKw8vtWqUJ+0qWZAu6
         8wq7HKTFdVULngK3EYp8nIuUYjPtJb6bX7HXQyED09un5xKV4wFzP4kD3pFOG7UhYL
         WFbHbTUCblhweRNz0huHZZnKBHM2JkjUXrPDQawwHCWuSb6GZlkE/cRB5iDmbWGhZh
         5wseBeird/t2f+XXf8qwwwdByQCFwnQFD+92ZcDG4cruXnqYpYdRKmIor88V5Eit3L
         qrXebfQNLvNrw==
Date:   Tue, 21 Mar 2023 12:34:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Kal Conley <kal.conley@dectris.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/3] xsk: Support UMEM chunk_size > PAGE_SIZE
Message-ID: <20230321123403.5e78d582@kernel.org>
In-Reply-To: <ZBmLe27KrmXp7Qfc@boxer>
References: <20230319195656.326701-1-kal.conley@dectris.com>
        <20230319195656.326701-2-kal.conley@dectris.com>
        <ZBmLe27KrmXp7Qfc@boxer>
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

On Tue, 21 Mar 2023 11:48:27 +0100 Maciej Fijalkowski wrote:
> tell mlx4 does not support xdp multi-buffer, so you were testing this

FWIW

ConnectX-3 [PRO] == mlx4
ConnectX-4       == mlx5

But agreed that more info would help. You'd need to have some TLB
pressure to see benefit of huge pages.
