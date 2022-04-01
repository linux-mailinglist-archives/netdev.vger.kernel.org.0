Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E647C4EE6A3
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 05:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244471AbiDADWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 23:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238195AbiDADWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 23:22:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A834C205950;
        Thu, 31 Mar 2022 20:21:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5984AB82201;
        Fri,  1 Apr 2022 03:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701D1C2BBE4;
        Fri,  1 Apr 2022 03:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648783258;
        bh=hMpy/yHT6+eg5qbI+E51oW/qDfSYgpS2WsLWbfKIZuQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mMuTeivXoC49G5YyuKL3cN9mJ1hdFH1CltBEgPcoHN3PDgVVFi6ZSsCQjtB5s8Zjc
         q+tsNv/dsN1FI6b8+PwgfO/CyOsDFhWo/Ydkj4H0lFad6nw/s9jFLJiRHpCL4qYniK
         cjsrkYMwLJlrEzD+vZHahoFztGmYRcpqCvxY0xw3coKKig8pF49R6H3IG0yyU6JvFR
         YEkO9dkyahUNHe32hC5ZhaAYU6oyS1TaVmYCFr1jowzRozVr325QTExQ/A+OJD8nfI
         eH6k7WppOfXplJbWbLPajkqLVH0pS12jtL7Cp+xj9jimIUQe2jV3HvgWFvfVvzXA6a
         8smNEImcXUlzg==
Date:   Thu, 31 Mar 2022 20:20:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     <borisp@nvidia.com>, <john.fastabend@gmail.com>,
        <daniel@iogearbox.net>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <vakul.garg@nxp.com>,
        <davejwatson@fb.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] net/tls: fix slab-out-of-bounds bug in
 decrypt_internal
Message-ID: <20220331202057.4bbfb719@kernel.org>
In-Reply-To: <20220331070428.36111-1-william.xuanziyang@huawei.com>
References: <20220331070428.36111-1-william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Mar 2022 15:04:28 +0800 Ziyang Xuan wrote:
> The memory size of tls_ctx->rx.iv for AES128-CCM is 12 setting in
> tls_set_sw_offload(). The return value of crypto_aead_ivsize()
> for "ccm(aes)" is 16. So memcpy() require 16 bytes from 12 bytes
> memory space will trigger slab-out-of-bounds bug as following:
> 
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in decrypt_internal+0x385/0xc40 [tls]
> Read of size 16 at addr ffff888114e84e60 by task tls/10911

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
