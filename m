Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778A869A64B
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 08:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjBQHzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 02:55:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBQHzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 02:55:37 -0500
Received: from msg-2.mailo.com (msg-2.mailo.com [213.182.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9828A2449A;
        Thu, 16 Feb 2023 23:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailo.com; s=mailo;
        t=1676620514; bh=bYvQBdBh9CRkF50rTgS/IsrRMkGu7mldm4PQ5kTlJgc=;
        h=X-EA-Auth:Date:From:To:Cc:Subject:Message-ID:References:
         MIME-Version:Content-Type:In-Reply-To;
        b=fkw4a+hAMgz82TR1NLHYBJFC0Dg6/qMptVPQvn3lYWuEu3Pe3r82mH9tK/zWjhZr0
         qLHEpjDzWvR+zOLX+eSQI5PVeIm2omjAh69yQadKKIBvEtxEr6SlKSQ252d3fgzYKj
         gILharE1syVW40PvoxuvrQ4lejn83+SjtmHCka4s=
Received: by b-3.in.mailobj.net [192.168.90.13] with ESMTP
        via ip-206.mailobj.net [213.182.55.206]
        Fri, 17 Feb 2023 08:55:14 +0100 (CET)
X-EA-Auth: WOt8aKKNcwfx9cw8CyZOBbdpCZAc10lptd4eCcWZk9sEYopcdUikcn0YRh3sFrmsV3GLEqchkMWS5RGdTQ1QilkMex4O0S1k
Date:   Fri, 17 Feb 2023 13:25:08 +0530
From:   Deepak R Varma <drv@mailo.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Saurabh Singh Sengar <ssengar@microsoft.com>,
        Praveen Kumar <kumarpraveen@linux.microsoft.com>,
        Deepak R Varma <drv@mailo.com>
Subject: Re: [PATCH v2] octeontx2-pf: Use correct struct reference in test
 condition
Message-ID: <Y+8y3LYjuakER3CZ@ubun2204.myguest.virtualbox.org>
References: <Y+ohwh7K5CYHhziq@ubun2204.myguest.virtualbox.org>
 <20230214202841.595656be@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214202841.595656be@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 08:28:41PM -0800, Jakub Kicinski wrote:
> On Mon, 13 Feb 2023 17:10:50 +0530 Deepak R Varma wrote:
> > Fix the typo/copy-paste error by replacing struct variable ah_esp_mask name
> > by ah_esp_hdr.
> > Issue identified using doublebitand.cocci Coccinelle semantic patch.
> > 
> > Signed-off-by: Deepak R Varma <drv@mailo.com>
> 
> Your patch did not make it to the list, please make sure or recipients
> are correct (common error is to lack a space between name and the
> address, e.g. "David S. Miller"<davem@davemloft.net>).

Hello Jakub,
I again verified using the get_maintainer.pl script and did not find any issues
with the recipient list. Can you specify which mailing list it did not reach out
to please?

> 
> When reposting please add a Fixes tag.

Sure. I will include this detail in the v3.

Thank you,
./drv

> 
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
> > index 684cb8ec9f21..10e11262d48a 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
> > @@ -793,7 +793,7 @@ static int otx2_prepare_ipv6_flow(struct ethtool_rx_flow_spec *fsp,
> >  
> >  		/* NPC profile doesn't extract AH/ESP header fields */
> >  		if ((ah_esp_mask->spi & ah_esp_hdr->spi) ||
> > -		    (ah_esp_mask->tclass & ah_esp_mask->tclass))
> > +		    (ah_esp_mask->tclass & ah_esp_hdr->tclass))
> >  			return -EOPNOTSUPP;
> >  
> >  		if (flow_type == AH_V6_FLOW)
> 


