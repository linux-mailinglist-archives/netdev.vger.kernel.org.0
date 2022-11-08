Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9961B621DE3
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 21:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiKHUoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 15:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiKHUn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 15:43:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B0F62CF
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 12:43:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 837B161751
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 20:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD876C433D6;
        Tue,  8 Nov 2022 20:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667940213;
        bh=RncdDFJTBkuU/6E47MaTlBcCnBMpmVXVuti6qll5zvc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ml2t72HYSiYGjg9yP7rNgRVYSUz+/mTNNHMvgPoWscERJ4wt26VRMdAR9JpgFNMND
         erKZrQ9Y8KiDtDw/WiTBhTceD6NQ+QFwkCYj7UjiT9rHIBfVaDZy5lmKMafdiuZqBA
         IuXgoGPVItoum4nlGhCyHnfCWG9Q0A2HF0Az3GAWQfY6pXCyuMHcgNk3DBEsUkVPYK
         wEpRr4vWpnhBbkIe1P0+NQAkCh5I91uH22rnGQK9zsQGdA+acggvx3PQPPPC7VTIHQ
         V+iy6ZNL9899opshzXgtSAURGS1T4+YbYzJZ6EhZjbsaO5rkpFILZjgGRLgKC4qxpL
         O8ULfTXdz1gpw==
Date:   Tue, 8 Nov 2022 12:43:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com
Subject: Re: [PATCH net-next] genetlink: correctly begin the iteration over
 policies
Message-ID: <20221108124332.4759847d@kernel.org>
In-Reply-To: <20221108204128.330287-1-kuba@kernel.org>
References: <20221108204128.330287-1-kuba@kernel.org>
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

On Tue,  8 Nov 2022 12:41:28 -0800 Jakub Kicinski wrote:
> Why KASAN doesn't catch the use of uninit memory here is a mystery :S

Ah, because it's not KMSAN.
