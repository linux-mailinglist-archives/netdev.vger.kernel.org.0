Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4314B2C4C34
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 01:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730077AbgKZAdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 19:33:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbgKZAdS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 19:33:18 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 124EB2064B;
        Thu, 26 Nov 2020 00:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606350798;
        bh=2Xvi6CB6PeTHm2HSq3rbewypFHSNNA2x6hc4Rubrz0k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qRrHhtrnIQnMd//+Q228+AXjAtFWaSwbRf4YfcahTaQs7uyeXYlicRV2LO8DBgjE9
         6ci+NqE8PjR8j+rWKoC9c7di65sUFKSKY0kTbzP+VODhUQYkokVzubAHt0PLtJDZz9
         hPNoEiet1jmMalV7G5wZHh3KI+Ugyn8yY1k/hPLA=
Date:   Wed, 25 Nov 2020 16:33:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH net-next v5 12/14] net/smc: Add SMC-D Linkgroup
 diagnostic support
Message-ID: <20201125163317.05b7e22b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124175047.56949-13-kgraul@linux.ibm.com>
References: <20201124175047.56949-1-kgraul@linux.ibm.com>
        <20201124175047.56949-13-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 18:50:45 +0100 Karsten Graul wrote:
> +static int smc_nl_fill_smcd_lgr(struct smc_link_group *lgr,
> +				struct sk_buff *skb,
> +				struct netlink_callback *cb)
> +{
> +	char smc_host[SMC_MAX_HOSTNAME_LEN + 1];
> +	char smc_pnet[SMC_MAX_PNETID_LEN + 1];
> +	char smc_eid[SMC_MAX_EID_LEN + 1];
> +	struct nlattr *v2_attrs;
> +	struct nlattr *attrs;
> +	void *nlh;
> +
> +	nlh = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
> +			  &smc_gen_nl_family, NLM_F_MULTI,
> +			  SMC_NETLINK_GET_LGR_SMCD);
> +	if (!nlh)
> +		return -EMSGSIZE;

In the previous patched you had a goto here. I prefer direct return,
but either way - please be consistent.
