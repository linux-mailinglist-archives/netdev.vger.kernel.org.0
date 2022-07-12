Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D78C572770
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbiGLUjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbiGLUjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:39:04 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595E1FD13;
        Tue, 12 Jul 2022 13:39:01 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 61707C01D; Tue, 12 Jul 2022 22:38:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657658339; bh=xoIWT0+MGU+XdIrhk6lVq1lEsSSRx8pWavkPy8XPrhc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ESwoFOV316NhH0R9hOku2o0Bv1JXDoxMNFNlEvvRNmPtkOIKPtoifOHWnBmPMSG1H
         sQuiZNdjPK41hGT5j6xd3vLuvdbxV60GAO5SGLpx55rwCoKLo5EJncytk/FBiijncl
         XjCLjOPDKP81lY2LQcRcB2B8Z/sBsLgjZVc6vXGiQNqXWXWi99nZB4akvi8AB+91zv
         rXKuD1bvt4T6Izsjswxn4oWgf67mHj7yxrgy1GntzyHB/gYy1g+nMN6nxoeqRNbbeH
         CXabD/kGDAGulEBIp+qtaVDPUWJJSdy9OcOTgNGGsFjTewNiP834hnS322EqSKw7u7
         efofqaeojbX0g==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id BA27CC009;
        Tue, 12 Jul 2022 22:38:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657658337; bh=xoIWT0+MGU+XdIrhk6lVq1lEsSSRx8pWavkPy8XPrhc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hYL5aJsYK2K6nSHFdG4wihmfLZ2pKaJNYRNn9/sRs9KgdPw0WLHjBL6IyvyCSoqu6
         ovIy4KNGT2pknVIw2waXODhEQufmtk2X97AiyQx0KjQyD376bfgsnDjyR6lUks0FHt
         x/XWxDAQ2NLOsEct8O5WQo5miBCXSYVIJVJzyoMMwvPj70x3SB/k5HAlC6fzXHhhXL
         j/9JrkXz3XAybJDUuTXed/jCsrFkzOEWcdn8gTODyzAu7oIGsZ8UBg2r3fJmWTsh+u
         BMCVMc65maV7GhMn+uRpwdVs5SfNcWz63tPFgiuxgMawK+kycCftFu3/xtoNYeP82X
         m7/1QJ0ZYBZLQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 436c2c9e;
        Tue, 12 Jul 2022 20:38:53 +0000 (UTC)
Date:   Wed, 13 Jul 2022 05:38:38 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [PATCH v5 07/11] net/9p: limit 'msize' to KMALLOC_MAX_SIZE for
 all transports
Message-ID: <Ys3bzjuDgseOliUW@codewreck.org>
References: <cover.1657636554.git.linux_oss@crudebyte.com>
 <2506fd2ed484f688826cdc33c177c467e2b0506c.1657636554.git.linux_oss@crudebyte.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2506fd2ed484f688826cdc33c177c467e2b0506c.1657636554.git.linux_oss@crudebyte.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Tue, Jul 12, 2022 at 04:31:26PM +0200:
> This 9p client implementation is yet using linear message buffers for
> most message types, i.e. they use kmalloc() et al. for allocating
> continuous physical memory pages, which is usually limited to 4MB
> buffers. Use KMALLOC_MAX_SIZE though instead of a hard coded 4MB for
> constraining this more safely.
> 
> Unfortunately we cannot simply replace the existing kmalloc() calls by
> vmalloc() ones, because that would yield in non-logical kernel addresses
> (for any vmalloc(>4MB) that is) which are in general not accessible by
> hosts like QEMU.
> 
> In future we would replace those linear buffers by scatter/gather lists
> to eventually get rid of this limit (struct p9_fcall's sdata member by
> p9_fcall_init() and struct p9_fid's rdir member by
> v9fs_alloc_rdir_buf()).
> 
> Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
> ---
> 
> Hmm, that's a bit too simple, as we also need a bit of headroom for
> transport specific overhead. So maybe this has to be handled by each
> transport appropriately instead?

hm yes I'd say it's redundant with each transports max size already --
let's just keep appropriate max values in each transport.

> 
>  net/9p/client.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/net/9p/client.c b/net/9p/client.c
> index 20054addd81b..fab939541c81 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -1042,6 +1042,17 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
>  	p9_debug(P9_DEBUG_MUX, "clnt %p trans %p msize %d protocol %d\n",
>  		 clnt, clnt->trans_mod, clnt->msize, clnt->proto_version);
>  
> +	/*
> +	 * due to linear message buffers being used by client ATM
> +	 */
> +	if (clnt->msize > KMALLOC_MAX_SIZE) {
> +		clnt->msize = KMALLOC_MAX_SIZE;
> +		pr_info("Limiting 'msize' to %zu as this is the maximum "
> +			"supported by this client version.\n",
> +			(size_t) KMALLOC_MAX_SIZE
> +		);
> +	}
> +
>  	err = clnt->trans_mod->create(clnt, dev_name, options);
>  	if (err)
>  		goto put_trans;
