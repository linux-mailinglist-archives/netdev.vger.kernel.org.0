Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60E726441D
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 11:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfGJJGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 05:06:30 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37334 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726580AbfGJJGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 05:06:30 -0400
Received: by mail-wr1-f67.google.com with SMTP id n9so1584868wrr.4
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 02:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gfiGdoMrNOXbv2R2b/ALuxp4d8khvzgv9lGUsocDsBc=;
        b=pjy217XIpnijmquHDV5m9IIxXUeufF48+n5UfMueTkCPkeWqEgmBzfzifRR/9O+4nu
         WJN/ujPs8LbUUcY0Hks9XVPEm8TV4864sulAZczauVTEPNIv+5s++7dOvj+rAiuL4uqU
         HUawgpV/h5n67vmCzDYtnzOPywxUsLcnrbD4rg7ImB+crIQaYK+QOxXmSVYljLmIoAhx
         OGiUwISb3bt7FZrfgc3NckIkd4raO453MbhPnt5NnvBym1gaeo/mxt2THaw8QLgNaNSY
         E2u//KDxYvdeAHhYCwM1SJGOAPfaExEZFyuJ7/C2BqkWIbZi5zDANj3NTxCN0XzP4VmO
         aJdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gfiGdoMrNOXbv2R2b/ALuxp4d8khvzgv9lGUsocDsBc=;
        b=E0vB7nz2HKlOa+ybTN/jvkFgJdNUMfTJZY07DARKchd4iuL8T3+JZxpRq25aWGvuCO
         Tde8yep8L1qf9cMa4Udraw4Mw9BCi51dVNN6PZEm4fQGynKNxpYZE7OlnshTw6KkzKq2
         XcvJscT92XWkmXXr5mA4hN7SNb5Xk2/Hgpq2oLFEMB0DvFyPzpFot8+EirHOCHZyZ9hd
         2TivwRGyhs9QMYDkb0Gt+4fcwJa0/94hJX2KoHKlWRZDaIozzzVONrxoUUpl8rG2zk9I
         e6PqirPZHEd6ozGsnTlN3pmBu5yrEJTejIjskIxX6iTgju08kzM9JoWwvvS9OVtbgrjA
         fD6Q==
X-Gm-Message-State: APjAAAW6VrVnYx8mQNpoSag5GWprtFW7onrh3H8Wdh0DB1RW7EM729Bw
        xFm51pLZqogEiZQmbv4qKdlOYw==
X-Google-Smtp-Source: APXvYqxcBeWPqezd48Im6NCAZBn28KAUIeeIUpiU2sv+/vColU7Chh5MLaWW82St7p4SuKkIxWt8PQ==
X-Received: by 2002:adf:e446:: with SMTP id t6mr30608322wrm.115.1562749589271;
        Wed, 10 Jul 2019 02:06:29 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id x8sm1364286wmc.5.2019.07.10.02.06.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 02:06:28 -0700 (PDT)
Date:   Wed, 10 Jul 2019 11:06:28 +0200
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
Subject: Re: [PATCH net-next,v4 05/12] net: flow_offload: add list handling
 functions
Message-ID: <20190710090628.GF2282@nanopsycho>
References: <20190709205550.3160-1-pablo@netfilter.org>
 <20190709205550.3160-6-pablo@netfilter.org>
 <20190710073652.GD2282@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710073652.GD2282@nanopsycho>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 10, 2019 at 09:36:52AM CEST, jiri@resnulli.us wrote:
>Tue, Jul 09, 2019 at 10:55:43PM CEST, pablo@netfilter.org wrote:
>
>[...]
>
>
>>@@ -176,6 +176,7 @@ struct flow_block_cb *flow_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,
>> 	if (!block_cb)
>> 		return ERR_PTR(-ENOMEM);
>> 
>>+	block_cb->net = net;
>> 	block_cb->cb = cb;
>> 	block_cb->cb_ident = cb_ident;
>> 	block_cb->cb_priv = cb_priv;
>>@@ -194,6 +195,22 @@ void flow_block_cb_free(struct flow_block_cb *block_cb)
>> }
>> EXPORT_SYMBOL(flow_block_cb_free);
>> 
>>+struct flow_block_cb *flow_block_cb_lookup(struct flow_block_offload *f,
>>+					   tc_setup_cb_t *cb, void *cb_ident)
>>+{
>>+	struct flow_block_cb *block_cb;
>>+
>>+	list_for_each_entry(block_cb, f->driver_block_list, driver_list) {
>>+		if (block_cb->net == f->net &&

Looking at this a bit more, this is wrong. This breaks block sharing
concept. The original lookup look up the block_cb in certain block - the
block to be shared. With this, you broke the block sharing feature for
mlxsw.

We need to maintain the existing block concept (changed to flow_block).


>
>I don't understand why you need net for this. You should have a list of
>cbs per subsystem (tc/nft) go over it here.
>
>The clash of 2 suybsytems is prevented later on by
>flow_block_cb_is_busy().
>
>Am I missing something?
>If not, could you please remove use of net from flow_block_cb_alloc()
>and from here and replace it by some shared flow structure holding the
>cb list that would be used by both tc and nft?
>
>
>
>>+		    block_cb->cb == cb &&
>>+		    block_cb->cb_ident == cb_ident)
>>+			return block_cb;
>>+	}
>>+
>>+	return NULL;
>>+}
>>+EXPORT_SYMBOL(flow_block_cb_lookup);
>>+
>
>[...]
