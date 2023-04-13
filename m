Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 958E56E1358
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 19:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjDMRTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 13:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDMRTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 13:19:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285447EE8;
        Thu, 13 Apr 2023 10:19:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B09936402D;
        Thu, 13 Apr 2023 17:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A75C433D2;
        Thu, 13 Apr 2023 17:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681406362;
        bh=U5y8jkuTC9pbMLEtkYnUsX2gGuJmmSy8xSN2gPE42SQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZzBXD3y9Qo1Q/YyFC1NNvLiLVn3oern6WGp3U6ozHt964k8fyrDJWX0UAg+qXHfS0
         n0eoL7jiGIK9IYDIqJGzETBm0ncRRysPY9mxMXrERGm1cM5cPDoEvzDbUcSNy4bZ/m
         vDyNHe+NGzSJUFFT68ACPjABb49HkD7s0L7XmvUEdGJhPcI0tN7ge7G+fkFCA8LpWh
         nnzlHLASRCI67UkslxQDIn6GQLeBCFWf89NF83OEYji6g0pe+jlBHgXo73T6aVLZJt
         dX8L9MhFZfOfusd6M7GxPc3AThk94M3ijpjDTOnfEuVJidMl0t/fzYyG5XI9CpUFZ5
         68eV0WW2ArqhA==
Date:   Thu, 13 Apr 2023 20:19:18 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Yixin Shen <bobankhshen@gmail.com>
Cc:     linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, ncardwell@google.com
Subject: Re: [PATCH net-next] lib/win_minmax: export symbol of
 minmax_running_min
Message-ID: <20230413171918.GX17993@unreal>
References: <20230413164726.59019-1-bobankhshen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413164726.59019-1-bobankhshen@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 04:47:26PM +0000, Yixin Shen wrote:
> This commit export the symbol of the function minmax_running_min
> to make it accessible to dynamically loaded modules. It can make
> this library more general, especially for those congestion
> control algorithm modules who wants to implement a windowed min
> filter.
> 
> Signed-off-by: Yixin Shen <bobankhshen@gmail.com>
> ---
>  lib/win_minmax.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/lib/win_minmax.c b/lib/win_minmax.c
> index ec10506834b6..1682e614309c 100644
> --- a/lib/win_minmax.c
> +++ b/lib/win_minmax.c
> @@ -97,3 +97,4 @@ u32 minmax_running_min(struct minmax *m, u32 win, u32 t, u32 meas)
>  
>  	return minmax_subwin_update(m, win, &val);
>  }
> +EXPORT_SYMBOL(minmax_running_min);

Please provide in-tree kernel user for that EXPORT_SYMBOL.

Thanks

> -- 
> 2.25.1
> 
