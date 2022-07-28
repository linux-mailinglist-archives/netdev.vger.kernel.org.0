Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFEE85836A5
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 04:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235564AbiG1CFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 22:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234232AbiG1CFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 22:05:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA9622B13;
        Wed, 27 Jul 2022 19:05:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1155061871;
        Thu, 28 Jul 2022 02:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2996EC433D6;
        Thu, 28 Jul 2022 02:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658973912;
        bh=zxAKqmDeRgvh0LUTcg21PJ4FKLkJ74pWTcnTnUAl92Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mhQM00jTzuSpHfXb4wQ/CqjEsZAhMkVaV/YZBeJNXHT9hTmBuc0PwSl4HUHGO98U3
         qbDLVZ7R4FqiZRgLP8+Tj/mEahMK/x/o+5PdACpxTByTcRGR3+dXxvtAuJXHMRFhUi
         nABawSHdGdbZ8TZxOWZQsA+cXu7muQJT2VDNLIEg9AU+K4J/gdK4Xj4tqriwLSPaiE
         W69sbSsE1ZqQewNtk6Gg7HxjiqIFJYmdwBGLXVeWS3LvoAQAwJNsO9vyrrvmEtAeeD
         Ws46dXFdCewXSbo8tR3PV2Y75oUaR/kQa1Pmwav3AYW6JyxVeE5MDJ6ru7ZUapVIL2
         4QvKQQllZGw6A==
Date:   Wed, 27 Jul 2022 19:05:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, davem@davemloft.net,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] tls: rx: Fix unsigned comparison with less than
 zero
Message-ID: <20220727190511.08f4fe0c@kernel.org>
In-Reply-To: <20220728011025.10865-1-yang.lee@linux.alibaba.com>
References: <20220728011025.10865-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jul 2022 09:10:25 +0800 Yang Li wrote:
>  	struct tls_strparser *strp = (struct tls_strparser *)desc->arg.data;
> -	size_t sz, len, chunk;
> +	int sz;
> +	size_t len, chunk;
>  	struct sk_buff *skb;
>  	skb_frag_t *frag;

Thanks for the fix, please keep the sorting of the variable lines from
longest to shortest. "int sz;" should be the last variable declaration
line and "size_t len, chunk;" goes after the skb.
