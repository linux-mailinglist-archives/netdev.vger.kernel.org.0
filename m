Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0495244DBAA
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 19:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbhKKSlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 13:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbhKKSlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 13:41:52 -0500
X-Greylist: delayed 354 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 11 Nov 2021 10:39:02 PST
Received: from relay02.th.seeweb.it (relay02.th.seeweb.it [IPv6:2001:4b7a:2000:18::163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BA6C061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 10:39:02 -0800 (PST)
Received: from SoMainline.org (94-209-165-62.cable.dynamic.v4.ziggo.nl [94.209.165.62])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by m-r1.th.seeweb.it (Postfix) with ESMTPSA id 4E6251F633;
        Thu, 11 Nov 2021 19:33:05 +0100 (CET)
Date:   Thu, 11 Nov 2021 19:33:03 +0100
From:   Marijn Suijten <marijn.suijten@somainline.org>
To:     Konrad Dybcio <konrad.dybcio@somainline.org>
Cc:     ~postmarketos/upstreaming@lists.sr.ht, martin.botka@somainline.org,
        angelogioacchino.delregno@somainline.org,
        jamipkettunen@somainline.org, Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ipa: ipa_resource: Fix wrong for loop range
Message-ID: <20211111183303.avx45fu5mk5wnglj@SoMainline.org>
References: <20211111173401.551408-1-konrad.dybcio@somainline.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111173401.551408-1-konrad.dybcio@somainline.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-11 18:34:00, Konrad Dybcio wrote:
> The destrination group count was mistakenly assigned to both dst and src loops.

There's an unnecessary `r` in destRination...  Apart that I think you
meant to say "source" here since both assignments to group_count use(d)
rsrc_group_src_count, not the destination.

> Fix it to make IPA probe and work again.
> 

This is missing:

Fixes: 4fd704b3608a ("net: ipa: record number of groups in data")

For backporting to 5.13 and above. Before that commit src and dst were
correctly used.  Apart that, after fixing this all:

Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>

> Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
> ---
>  drivers/net/ipa/ipa_resource.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ipa/ipa_resource.c b/drivers/net/ipa/ipa_resource.c
> index e3da95d69409..06cec7199382 100644
> --- a/drivers/net/ipa/ipa_resource.c
> +++ b/drivers/net/ipa/ipa_resource.c
> @@ -52,7 +52,7 @@ static bool ipa_resource_limits_valid(struct ipa *ipa,
>  				return false;
>  	}
>  
> -	group_count = data->rsrc_group_src_count;
> +	group_count = data->rsrc_group_dst_count;
>  	if (!group_count || group_count > IPA_RESOURCE_GROUP_MAX)
>  		return false;
>  
> -- 
> 2.33.0
> 
