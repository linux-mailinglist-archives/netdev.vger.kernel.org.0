Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF604F8DEB
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiDHD4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 23:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234010AbiDHD4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 23:56:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3050CBE4C;
        Thu,  7 Apr 2022 20:54:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15B80B829AE;
        Fri,  8 Apr 2022 03:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD55C385A1;
        Fri,  8 Apr 2022 03:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649390068;
        bh=XvrZjZaX5Rsi5fiZFoDR7A0z44p/01oSQz1BX2ODyvU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=avEXtVrk7mOyW8zohyzfG6CeVAW9WHmglJH2zFNO6BqivVAiwRFXM5FysYbfpSW4R
         e5ioNTKU9dR9CdSfVo/qzoEX+KFzJXpGKeUC7RYWphXdJ9lD7QEgvw1cEHhAK3riim
         SfLqUUEiyZ6Fo9fMpvbleZcmaOnWtrU+CsAVL3b/ftZoe3QS1owYNeov9z652aNwns
         +dhbMjxfJFqASqlpcBfHfh/dNAHNoXw1FYbDqttp1G+Tba1An+xtmjAldSlNV81Un0
         hXlyPc0jm4HYBSy2zICqZdHsaMx79AWrW1iGEJpX+m85MDo32q6JDwBzIWVYqdGVM3
         4k9iubEHtRGQg==
Date:   Thu, 7 Apr 2022 20:54:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Colin Ian King <colin.king@intel.com>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Di Zhu <zhudi21@huawei.com>, Xu Wang <vulab@iscas.ac.cn>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: Re: [PATCH net-next 02/15] net: dsa: sja1105: Remove usage of
 iterator for list_add() after loop
Message-ID: <20220407205426.6a31e4b2@kernel.org>
In-Reply-To: <20220407102900.3086255-3-jakobkoschel@gmail.com>
References: <20220407102900.3086255-1-jakobkoschel@gmail.com>
        <20220407102900.3086255-3-jakobkoschel@gmail.com>
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

On Thu,  7 Apr 2022 12:28:47 +0200 Jakob Koschel wrote:
> diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
> index b7e95d60a6e4..cfcae4d19eef 100644
> --- a/drivers/net/dsa/sja1105/sja1105_vl.c
> +++ b/drivers/net/dsa/sja1105/sja1105_vl.c
> @@ -27,20 +27,24 @@ static int sja1105_insert_gate_entry(struct sja1105_gating_config *gating_cfg,
>  	if (list_empty(&gating_cfg->entries)) {
>  		list_add(&e->list, &gating_cfg->entries);
>  	} else {
> -		struct sja1105_gate_entry *p;
> +		struct sja1105_gate_entry *p = NULL, *iter;
>  
> -		list_for_each_entry(p, &gating_cfg->entries, list) {
> -			if (p->interval == e->interval) {
> +		list_for_each_entry(iter, &gating_cfg->entries, list) {
> +			if (iter->interval == e->interval) {
>  				NL_SET_ERR_MSG_MOD(extack,
>  						   "Gate conflict");
>  				rc = -EBUSY;
>  				goto err;
>  			}
>  
> -			if (e->interval < p->interval)
> +			if (e->interval < iter->interval) {
> +				p = iter;
> +				list_add(&e->list, iter->list.prev);
>  				break;
> +			}
>  		}
> -		list_add(&e->list, p->list.prev);
> +		if (!p)
> +			list_add(&e->list, gating_cfg->entries.prev);

This turns a pretty slick piece of code into something ugly :(
I'd rather you open coded the iteration here than make it more 
complex to satisfy "safe coding guidelines".

Also the list_add() could be converted to list_add_tail().
