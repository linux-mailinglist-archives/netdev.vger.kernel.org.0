Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDC1EA59D
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 22:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfJ3Vjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 17:39:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46940 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfJ3Vjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 17:39:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3EE6B14C6834A;
        Wed, 30 Oct 2019 14:39:50 -0700 (PDT)
Date:   Wed, 30 Oct 2019 14:39:49 -0700 (PDT)
Message-Id: <20191030.143949.809392632168787466.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     linux-kernel@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/7] net: dsa: list DSA links in the fabric
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191028195220.2371843-2-vivien.didelot@gmail.com>
References: <20191028195220.2371843-1-vivien.didelot@gmail.com>
        <20191028195220.2371843-2-vivien.didelot@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 14:39:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Mon, 28 Oct 2019 15:52:14 -0400

> @@ -122,6 +124,29 @@ static struct dsa_port *dsa_tree_find_port_by_node(struct dsa_switch_tree *dst,
>  	return NULL;
>  }
>  
> +struct dsa_link *dsa_link_touch(struct dsa_port *dp, struct dsa_port *link_dp)
> +{
> +	struct dsa_switch *ds = dp->ds;
> +	struct dsa_switch_tree *dst = ds->dst;
> +	struct dsa_link *dl;

Please fix the reverse christmas tree here, two suggestions:

	struct dsa_switch *ds = dp->ds;
	struct dsa_switch_tree *dst;
	struct dsa_link *dl;

	dst = ds->dst;

Or, alternatively, since the dst variable is used only once, get rid of it
and change:

> +	list_add_tail(&dl->list, &dst->rtable);

to

> +	list_add_tail(&dl->list, &ds->dst->rtable);
