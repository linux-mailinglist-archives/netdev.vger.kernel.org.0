Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4D169D76C
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 01:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbjBUANC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 19:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233299AbjBUANB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 19:13:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBDBCDE6;
        Mon, 20 Feb 2023 16:12:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 966CAB80D3D;
        Tue, 21 Feb 2023 00:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF96EC433D2;
        Tue, 21 Feb 2023 00:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676938377;
        bh=4faYiV3iBFka7fTWUT3lHxBKrVg5KJPfTjrPRg9FL1I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NKqqH7i8hGC+GaJr4j/EouBnGfsW4af1AENmATWENxVBWRGj21koo9/WS5LN0Uwr/
         FpJNvfiwq54cICUSG2v+gFEjsc0UCaZwqn4LHyZg1xWRpeLta9bAWi09Xf+S0kC9z5
         85xlAXWB+vTwsQy/GoCkmNJvt0nMh8icS0LviVwb5AfnjMya8AC9zuvi6AlhwgD1gS
         MdN7PeeRo4DstVCCcLtg1RyhiUmmhy++74NQW3f8w5qVcSGkT23PxGcYHhwAioyRsk
         cQvkd+7pCY3PCIPTJrPnhByThYdoSsgF8L2Wos1yg/vydLVr31uPtg0+hAvp1WR3nr
         s+EAVZS8mMw4Q==
Date:   Mon, 20 Feb 2023 16:12:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        aleksander.lobakin@intel.com, maciej.fijalkowski@intel.com
Subject: Re: pull-request: bpf-next 2023-02-17
Message-ID: <20230220161255.79d9bc6b@kernel.org>
In-Reply-To: <20230217221737.31122-1-daniel@iogearbox.net>
References: <20230217221737.31122-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Feb 2023 23:17:37 +0100 Daniel Borkmann wrote:
> There is a small merge conflict between aa1d3faf71a6 ("ice: Robustify
> cleaning/completing XDP Tx buffers") from bpf-next and recent merge in
> 675f176b4dcc ("Merge ra.kernel.org:/pub/scm/linux/kernel/git/netdev/net"),
> result should look like the following (CC'ing Alexander & Maciej just in
> case):
> 
>   [...]
>                 if (tx_buf->type == ICE_TX_BUF_XSK_TX) {
>                         tx_buf->type = ICE_TX_BUF_EMPTY;
>                         ice_clean_xdp_tx_buf(xdp_ring, tx_buf);
>                 } else {
>   [...]

FWIW Olek provided a different resolution here:

https://lore.kernel.org/all/a472728a-a4eb-391a-c517-06133e6bbc8c@intel.com/

I took his, it's different.
