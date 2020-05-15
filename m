Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC5F1D5825
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgEORlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726144AbgEORlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:41:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723A3C061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 10:41:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 34AF514DE231E;
        Fri, 15 May 2020 10:41:47 -0700 (PDT)
Date:   Fri, 15 May 2020 10:41:46 -0700 (PDT)
Message-Id: <20200515.104146.1397850162301312137.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org, ruxandra.radulescu@nxp.com
Subject: Re: [PATCH net-next 3/7] dpaa2-eth: Distribute ingress frames
 based on VLAN prio
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200515165300.16125-4-ioana.ciornei@nxp.com>
References: <20200515165300.16125-1-ioana.ciornei@nxp.com>
        <20200515165300.16125-4-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 May 2020 10:41:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Fri, 15 May 2020 19:52:56 +0300

> +/* Configure ingress classification based on VLAN PCP */
> +static int set_vlan_qos(struct dpaa2_eth_priv *priv)
> +{
> +	struct device *dev = priv->net_dev->dev.parent;
> +	struct dpkg_profile_cfg kg_cfg = {0};
> +	struct dpni_qos_tbl_cfg qos_cfg = {0};
> +	struct dpni_rule_cfg key_params;
> +	void *dma_mem, *key, *mask;

Please declare mask as "u16 *"

> +	*(u16 *)mask = cpu_to_be16(VLAN_PRIO_MASK);

And remove this cast, no other code changes are necessary.  Not even
to the calculation of the pointer value.
