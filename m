Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D224F945B
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 13:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbiDHLna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 07:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234928AbiDHLn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 07:43:28 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482C6194AB5;
        Fri,  8 Apr 2022 04:41:25 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id n6so16680124ejc.13;
        Fri, 08 Apr 2022 04:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oOLkJ7c4AnZzlwaZhpGpMRHcIgXhaokY4dCFfnVK8ik=;
        b=AJg0uFFwQge4JGuOOuXx8CRkZnu1ZXDnzVzYyDLWHmvIU38NMZoqu0q4pVe158Dkgn
         /eBGcEWGk1BeH46V8704WX2v2KXvFfp8vmK2QWBZU86JD8zqVMh6WPg5JLEG+MOHz132
         joX/LTo9GNjQ/PHxRdkig9FP8sCB1PK8s/CVdG9aD27OA02ni/wYOQv2VKyManpb4r2V
         l+NyhY4mu+ntHubH7dA6jGBBg6Rw6LlWbypc/PJx+kXrgjcCC5HTa5lEjYMn4vqquVmu
         OjghRQ+Tl9pBKfNcLM6JX8eao7netCFmQK+me98hABNrns/o3jeMpBRevLlGuLTg9CDP
         8pvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oOLkJ7c4AnZzlwaZhpGpMRHcIgXhaokY4dCFfnVK8ik=;
        b=CWTUXkKCNjmXCfKQmIvAHVeFE4P4HDo+u0dJjnU8LG89pms8uU1B1TDL4zm1eBI0YC
         1rGZ6K2rh5ejLCxr8DJFY1qmsTyQthuXS9XNwsAz6VCkxEhyHe28eXTFju6NE2uAB8SO
         vKprCw+sRk/GFuLgEAQjvpzka5u42o3NfUbZBPD6ZgEtn3pPh+EIJk1rQYzRWry2fRlE
         giEJXf1t6bNO0vXdZmpl4kxzQd3hkIzdZbSTEspRThCU2G4sNNZuF3OwJRmGfnrM/SAL
         GXp9rBCqE1XECxFDhTh8CpX/oRbXor6bcJYPO2/hZJgF3uxn6VZzrwMZ6daDzQJrUyD5
         z23w==
X-Gm-Message-State: AOAM531ifMCMAWvGYqNelZRiSuCHvhWcnJ2YhChrI2qHpb6cizBQGRLV
        HqKoRtrQiA/oQ/wsyM2/X/s=
X-Google-Smtp-Source: ABdhPJxeGaH+7ttKQKVamBraqnau+HZGtwku7UJ842hOx0+3i3iRgWvMoiWyLlCCBLIqlNq60ltPnQ==
X-Received: by 2002:a17:907:2d92:b0:6e8:4b2a:e41f with SMTP id gt18-20020a1709072d9200b006e84b2ae41fmr3203383ejc.124.1649418083561;
        Fri, 08 Apr 2022 04:41:23 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id e11-20020a50becb000000b0041b64129200sm10750300edk.50.2022.04.08.04.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 04:41:23 -0700 (PDT)
Date:   Fri, 8 Apr 2022 14:41:20 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: Re: [PATCH net-next 02/15] net: dsa: sja1105: Remove usage of
 iterator for list_add() after loop
Message-ID: <20220408114120.tvf2lxvhfqbnrlml@skbuf>
References: <20220407102900.3086255-1-jakobkoschel@gmail.com>
 <20220407102900.3086255-3-jakobkoschel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407102900.3086255-3-jakobkoschel@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakob,

On Thu, Apr 07, 2022 at 12:28:47PM +0200, Jakob Koschel wrote:
> In preparation to limit the scope of a list iterator to the list
> traversal loop, use a dedicated pointer to point to the found element [1].
> 
> Before, the code implicitly used the head when no element was found
> when using &pos->list. Since the new variable is only set if an
> element was found, the list_add() is performed within the loop
> and only done after the loop if it is done on the list head directly.
> 
> Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
> ---
>  drivers/net/dsa/sja1105/sja1105_vl.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
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
>  	}
>  
>  	gating_cfg->num_entries++;
> -- 
> 2.25.1
> 

I apologize in advance if I've misinterpreted the end goal of your patch.
I do have a vague suspicion I understand what you're trying to achieve,
and in that case, would you mind using this patch instead of yours?
I think it still preserves the intention of the code in a clean manner.

-----------------------------[ cut here ]-----------------------------
From 7aed740750d1bc3bff6e85fd33298f5905bb4e01 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Fri, 8 Apr 2022 13:55:14 +0300
Subject: [PATCH] net: dsa: sja1105: avoid use of type-confused pointer in
 sja1105_insert_gate_entry()

It appears that list_for_each_entry() leaks a type-confused pointer when
the iteration loop ends with no early break, since "*p" will no longer
point to a "struct sja1105_gate_entry", but rather to some memory in
front of "gating_cfg->entries".

This isn't actually a problem here, because if the element we insert has
the highest interval, therefore we never exit the loop early, "p->list"
(which is all that we use outside the loop) will in fact point to
"gating_cfg->entries" even though "p" itself is invalid.

Nonetheless, there are preparations to increase the safety of
list_for_each_entry() by making it impossible to use the encapsulating
structure of the iterator element outside the loop. So something needs
to change here before those preparations go in, even though this
constitutes legitimate use.

Make it clear that we are not dereferencing members of the encapsulating
"struct sja1105_gate_entry" outside the loop, by using the regular
list_for_each() iterator, and dereferencing the struct sja1105_gate_entry
only within the loop.

With list_for_each(), the iterator element at the end of the loop does
have a sane value in all cases, and we can just use that as the "head"
argument of list_add().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_vl.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index c0e45b393fde..fe93c80fe5ef 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -27,9 +27,15 @@ static int sja1105_insert_gate_entry(struct sja1105_gating_config *gating_cfg,
 	if (list_empty(&gating_cfg->entries)) {
 		list_add(&e->list, &gating_cfg->entries);
 	} else {
-		struct sja1105_gate_entry *p;
+		struct list_head *pos;
+
+		/* We cannot safely use list_for_each_entry()
+		 * because we dereference "pos" after the loop
+		 */
+		list_for_each(pos, &gating_cfg->entries) {
+			struct sja1105_gate_entry *p;
 
-		list_for_each_entry(p, &gating_cfg->entries, list) {
+			p = list_entry(pos, struct sja1105_gate_entry, list);
 			if (p->interval == e->interval) {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "Gate conflict");
@@ -40,7 +46,7 @@ static int sja1105_insert_gate_entry(struct sja1105_gating_config *gating_cfg,
 			if (e->interval < p->interval)
 				break;
 		}
-		list_add(&e->list, p->list.prev);
+		list_add(&e->list, pos->prev);
 	}
 
 	gating_cfg->num_entries++;
-----------------------------[ cut here ]-----------------------------
