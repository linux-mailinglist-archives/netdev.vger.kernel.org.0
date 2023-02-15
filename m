Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 960D469756C
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 05:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbjBOE24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 23:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjBOE2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 23:28:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D14D24482;
        Tue, 14 Feb 2023 20:28:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEE9DB81FF1;
        Wed, 15 Feb 2023 04:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE76C433D2;
        Wed, 15 Feb 2023 04:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676435322;
        bh=gQItWQGViuqC4+TT/qMNvKQW0f7Z2GI5pq6Tmc/cnSw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hrJJanqiNyATEazIGNFnAGjhN6dMFxhO8QjMkU9sRACmx/H/ogmc3HzodBufMzB1e
         HYalY7868g2wTBMXzie8tEIVO2Ck7LzCngSosI0l4v/T2fmkhZyXHODP6pP1umXuDi
         R4w8zNzcswUDIYWcdK7ThjrvZ/3VsldZRlQrYcWULZuMQPXLm8XYd05txDF95Ih8tV
         emlWXj3EADYXb7dNQ4g7xS1ZpTly0m/7K7xF8KPNRPyRS405oYWbFk2OJNkd/AAEAR
         VBUeS/LE49QR+XGrq5GqFGXva9chUkQD9GwPL52tO5TNskyhgU8qqq7vtfR8F4r+Dj
         FZ2OjNM1KKMJA==
Date:   Tue, 14 Feb 2023 20:28:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Deepak R Varma <drv@mailo.com>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Saurabh Singh Sengar <ssengar@microsoft.com>,
        Praveen Kumar <kumarpraveen@linux.microsoft.com>
Subject: Re: [PATCH v2] octeontx2-pf: Use correct struct reference in test
 condition
Message-ID: <20230214202841.595656be@kernel.org>
In-Reply-To: <Y+ohwh7K5CYHhziq@ubun2204.myguest.virtualbox.org>
References: <Y+ohwh7K5CYHhziq@ubun2204.myguest.virtualbox.org>
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

On Mon, 13 Feb 2023 17:10:50 +0530 Deepak R Varma wrote:
> Fix the typo/copy-paste error by replacing struct variable ah_esp_mask name
> by ah_esp_hdr.
> Issue identified using doublebitand.cocci Coccinelle semantic patch.
> 
> Signed-off-by: Deepak R Varma <drv@mailo.com>

Your patch did not make it to the list, please make sure or recipients
are correct (common error is to lack a space between name and the
address, e.g. "David S. Miller"<davem@davemloft.net>).

When reposting please add a Fixes tag.

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
> index 684cb8ec9f21..10e11262d48a 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
> @@ -793,7 +793,7 @@ static int otx2_prepare_ipv6_flow(struct ethtool_rx_flow_spec *fsp,
>  
>  		/* NPC profile doesn't extract AH/ESP header fields */
>  		if ((ah_esp_mask->spi & ah_esp_hdr->spi) ||
> -		    (ah_esp_mask->tclass & ah_esp_mask->tclass))
> +		    (ah_esp_mask->tclass & ah_esp_hdr->tclass))
>  			return -EOPNOTSUPP;
>  
>  		if (flow_type == AH_V6_FLOW)

