Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDD064334
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 10:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbfGJIB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 04:01:26 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34041 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfGJIB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 04:01:26 -0400
Received: by mail-wr1-f68.google.com with SMTP id 31so1375785wrm.1
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 01:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VUt4JDXd3abgOvfmVJPctMNR1b9OY+268uKgd1yANdQ=;
        b=2LaZqJF/bZNamYYC7xIZy8zQRWB/Ve3WRuH3GxxjEB1En/pMMYMn7TDI9mLfnjoou/
         KvoSi4xHoodC5BK4E3LkdctH48PQNnFz9/aHZUl24cNz672vPcBm4HO4COW8TUuGvDpL
         g1vpcpoPKRoragcP2BE32HQllTTQE81mE4gNtSINcDh0QpUP806adBHa6jwlYkCZQ95L
         Kz5lQmmgs0zjEXb62SPdH5BMe6wExrIqBLJpPMCJg5ZPuiIA7e2b/6gleVx6xWOgpjgK
         GS8gxlF32pl49CV+wKEYUuM+kVyatYbeiTwOobQVv+IL8jIjtRej5O7GwYMnBZutq7ld
         WKWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VUt4JDXd3abgOvfmVJPctMNR1b9OY+268uKgd1yANdQ=;
        b=HYT0dSrRUgHdP4hjY7imDq+bAK3G7BU4XN3GSUOOABz4KTGyBqtGxM9YJpmZrLSWw2
         B4A5osAAStOxP5rlBBKG4vqrFYGD/gX9atYvt/M2pguvMvTyao6xReYp63BnlxmOlTA5
         428pavrA1uPz9En1d3YxVU8/Pi1Hn+ngXkHxgPgOEAXtaycwqdEuvGmuIqMbc066iCY2
         isd0wr2IcoNtdbJBDuYhO8JnD8TQtndPLS/0mQ2nFsK8DeABIaHiVbO7AkX2LavNumrL
         i9igZ8ziv7vDx0kb5Lu+Q78xAhm+isEKJjbNQ64paA94pdnoRhIJqvdnWmTmLpd+D6e7
         +9Hw==
X-Gm-Message-State: APjAAAX2Mfxz1vLbmFBefkAgetgeamCh2wbtrPOsemb2KnvmHQM/v4eA
        dzrvnxa/7Z/OrzFccqUV6EIdyQ==
X-Google-Smtp-Source: APXvYqzGi2z8+CKhfn38L0JCwH3C/M0OlxIuWjoyFR0hkcCb2XLm7HjgbPIBUw5uRX6aJ49zI5uUpg==
X-Received: by 2002:a5d:4e50:: with SMTP id r16mr30094112wrt.227.1562745684315;
        Wed, 10 Jul 2019 01:01:24 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id w67sm1568784wma.24.2019.07.10.01.01.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 01:01:23 -0700 (PDT)
Date:   Wed, 10 Jul 2019 10:01:23 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        peppe.cavallaro@st.com, grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ogerlitz@mellanox.com, Manish.Chopra@cavium.com,
        marcelo.leitner@gmail.com, mkubecek@suse.cz,
        venkatkumar.duvvuru@broadcom.com, maxime.chevallier@bootlin.com,
        cphealy@gmail.com, phil@nwl.cc, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next,v4 08/12] drivers: net: use flow block API
Message-ID: <20190710080123.GE2282@nanopsycho>
References: <20190709205550.3160-1-pablo@netfilter.org>
 <20190709205550.3160-9-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709205550.3160-9-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 09, 2019 at 10:55:46PM CEST, pablo@netfilter.org wrote:

[...]	
	
> static int
> mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
>-				    struct tcf_block *block, bool ingress,
>-				    struct netlink_ext_ack *extack)
>+			            struct flow_block_offload *f, bool ingress)
> {
> 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
> 	struct mlxsw_sp_acl_block *acl_block;
>-	struct tcf_block_cb *block_cb;
>+	struct flow_block_cb *block_cb;
>+	bool register_block = false;
> 	int err;
> 
>-	block_cb = tcf_block_cb_lookup(block, mlxsw_sp_setup_tc_block_cb_flower,
>-				       mlxsw_sp);
>+	block_cb = flow_block_cb_lookup(f, mlxsw_sp_setup_tc_block_cb_flower,
>+					mlxsw_sp);
> 	if (!block_cb) {
>-		acl_block = mlxsw_sp_acl_block_create(mlxsw_sp, block->net);
>+		acl_block = mlxsw_sp_acl_block_create(mlxsw_sp, f->net);
> 		if (!acl_block)
> 			return -ENOMEM;
>-		block_cb = __tcf_block_cb_register(block,
>-						   mlxsw_sp_setup_tc_block_cb_flower,
>-						   mlxsw_sp, acl_block, extack);
>+		block_cb = flow_block_cb_alloc(f->net,
>+					       mlxsw_sp_setup_tc_block_cb_flower,
>+					       mlxsw_sp, acl_block,
>+					       mlxsw_sp_tc_block_flower_release);
> 		if (IS_ERR(block_cb)) {
>+			mlxsw_sp_acl_block_destroy(acl_block);
> 			err = PTR_ERR(block_cb);
> 			goto err_cb_register;
> 		}
>+		register_block = true;
> 	} else {
>-		acl_block = tcf_block_cb_priv(block_cb);
>+		acl_block = flow_block_cb_priv(block_cb);
> 	}
>-	tcf_block_cb_incref(block_cb);
>+	flow_block_cb_incref(block_cb);
> 	err = mlxsw_sp_acl_block_bind(mlxsw_sp, acl_block,
> 				      mlxsw_sp_port, ingress);
> 	if (err)
>@@ -1622,28 +1634,31 @@ mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
> 	else
> 		mlxsw_sp_port->eg_acl_block = acl_block;
> 
>+	if (register_block) {
>+		flow_block_cb_add(block_cb, f);
>+		list_add_tail(&block_cb->driver_list, &mlxsw_sp_block_cb_list);
>+	}

What prevents you from doing these 2 above right after
flow_block_cb_alloc?

More than that, what prevents you do maintain the same flow as was there
originally? You just need struct flow_block as a replacement of
struct tcf_block and have it contained in both struct nft_base_chain
and struct tcf_block.

And you would push pointer to struct flow_block down to drivers
in struct flow_block_offload.


[...]

