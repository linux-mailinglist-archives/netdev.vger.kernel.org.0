Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016D13D2D1B
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 22:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbhGVTZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 15:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhGVTZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 15:25:14 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DE9C061575;
        Thu, 22 Jul 2021 13:05:48 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id dj21so8344320edb.0;
        Thu, 22 Jul 2021 13:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n6sggzgTkVk4//C61mJiDT041uOw3JW87CcdidLGV9U=;
        b=MP0DpBzLHm6ZTMUfSGaxtAEtNFK6HBSYZ8sDIWQ17WjlxzBIOrXmHkWfTwUb4XID4+
         db4HJQzcWT2F8cvpcQd7+D4MuBfoH6XjFK6w+CH8BdInnsHDKtzf97O27YHDfo4Lqa7s
         463Q/IyNf7KOLN136Pkc0GMESiprMn0wMXuEPiYKRa0+y1uUkVl8XBVpbrx4kZSp/Qxu
         UgCtOx2ixaL9iXqQgq2TAY4f/mppcE+kTPlGvyQFyp3LJNsQSJwf7x9HMBHlR97KvVCE
         OyNmkESkTUPKQAPJTEmLEKsQ23RYaPd/aXyhPWwkidCjd7r+FszcdKs7YLPGwO9ML7HI
         zd3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n6sggzgTkVk4//C61mJiDT041uOw3JW87CcdidLGV9U=;
        b=EF3bfkpk4/RdWhvS95xUURVfpgJclQxWzPcju5HRHms2VoC49xGHggvFb3RPJqKcps
         TAoF3nyAz7Ehkdg8asxfQo9qDBKEjHZHWKVzZEz8vCnj/g19FWZ/3vNnAJP/MUDlUKb3
         D5JMQHsPgDO79HnqHblF+OslUkTYOn81s7ZLH3oksqhg7hA+ZhhluSRBeT+noT8uVtz1
         s43PX3UaaxeKDXrCKWKKvzZBrNxgzaUQ6zuqCDuLkmJzuXYdRLaG+alrJBvWIChEAi9v
         kDXRReIOEvtUz6u8Difc/8nsomvifNbkQSIbDU4uHuc1ViIrXsIBmmf9KlpvJDk3Ha7b
         9ebQ==
X-Gm-Message-State: AOAM530eKmzPlfCDWfzOcz2pf+z3f58EGm2fAYorWSmbHDBBm7iqpFJU
        uTQlj5bbUvf5cmX3uaY59DI=
X-Google-Smtp-Source: ABdhPJwzgK5u5serwWfWzvSjBfWa5SiSftEo5EJbk+QcCyUFBUqy2zelVHcW0dY++Ge0GkUGDqb8VQ==
X-Received: by 2002:a05:6402:18c4:: with SMTP id x4mr1510052edy.350.1626984346665;
        Thu, 22 Jul 2021 13:05:46 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id kj26sm10048348ejc.24.2021.07.22.13.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 13:05:46 -0700 (PDT)
Date:   Thu, 22 Jul 2021 23:05:44 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: dsa: sja1105: remove redundant re-assignment
 of pointer table
Message-ID: <20210722200544.qvl3sj57qph2whrw@skbuf>
References: <20210722191529.11013-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722191529.11013-1-colin.king@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 08:15:29PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer table is being re-assigned with a value that is never
> read. The assignment is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/dsa/sja1105/sja1105_main.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> index 6618abba23b3..c65dba3111d7 100644
> --- a/drivers/net/dsa/sja1105/sja1105_main.c
> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> @@ -2157,8 +2157,6 @@ static int sja1105_build_vlan_table(struct sja1105_private *priv)
>  	if (!new_vlan)
>  		return -ENOMEM;
>  
> -	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
> -
>  	for (i = 0; i < VLAN_N_VID; i++)
>  		new_vlan[i].vlanid = VLAN_N_VID;
>  
> -- 
> 2.31.1
> 

Oh my, what an interesting bug you uncovered.

That duplicate assignment was introduced in commit 3f01c91aab92 ("net:
dsa: sja1105: implement VLAN retagging for dsa_8021q sub-VLANs") and
used to read:

	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
	new_retagging = kcalloc(SJA1105_MAX_RETAGGING_COUNT,
				table->ops->unpacked_entry_size, GFP_KERNEL);

In retrospect, it should have been:

	table = &priv->static_config.tables[BLK_IDX_RETAGGING];

because we must allocate SJA1105_MAX_RETAGGING_COUNT elements of the
size of one VLAN retagging entry, and not of one VLAN lookup entry.

In commit 0fac6aa098ed ("net: dsa: sja1105: delete the
best_effort_vlan_filtering mode") I deleted everything that had to do
with VLAN retagging but left this behind because it didn't say RETAGGING
on it.

	[BLK_IDX_VLAN_LOOKUP] = {
		.unpacked_entry_size = sizeof(struct sja1105_vlan_lookup_entry),
	},
	[BLK_IDX_RETAGGING] = {
		.unpacked_entry_size = sizeof(struct sja1105_retagging_entry),
	},

and if you look at them, struct sja1105_retagging_entry has 7 u64
fields, while struct sja1105_vlan_lookup_entry has 6 elements (actually
since commit 3e77e59bf8cf ("net: dsa: sja1105: add support for the
SJA1110 switch family") it also has 7.

The point is, between commit 3f01c91aab92 and commit 3e77e59bf8cf, the
driver allocated 8 bytes too few per VLAN retagging entry, or multiplied
by 32 (the value of SJA1105_MAX_RETAGGING_COUNT), it only allocates
enough memory for 27.4 VLAN retagging entries. So any attempt to access
VLAN retagging entries 27-31 in this function would trigger an out of
bounds memory access.

Could you please also send a patch for the "net" tree with this, and the
explanation above?

-	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
+	table = &priv->static_config.tables[BLK_IDX_RETAGGING];

Thanks.
