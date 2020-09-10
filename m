Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFBD2654CA
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 00:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbgIJWFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 18:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgIJWFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 18:05:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9A0C061573;
        Thu, 10 Sep 2020 15:05:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0F7E9135A93D2;
        Thu, 10 Sep 2020 14:49:02 -0700 (PDT)
Date:   Thu, 10 Sep 2020 15:05:48 -0700 (PDT)
Message-Id: <20200910.150548.696841576525551255.davem@davemloft.net>
To:     mayflowerera@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] macsec: Support 32bit PN netlink attribute for XPN
 links
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200910095609.17999-1-mayflowerera@gmail.com>
References: <20200910095609.17999-1-mayflowerera@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 10 Sep 2020 14:49:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Era Mayflower <mayflowerera@gmail.com>
Date: Thu, 10 Sep 2020 09:56:09 +0000

> -		pn_len = secy->xpn ? MACSEC_XPN_PN_LEN : MACSEC_DEFAULT_PN_LEN;
> -		if (nla_len(tb_sa[MACSEC_SA_ATTR_PN]) != pn_len) {
> -			pr_notice("macsec: nl: upd_rxsa: bad pn length: %d != %d\n",
> -				  nla_len(tb_sa[MACSEC_SA_ATTR_PN]), pn_len);
> +			pr_notice("macsec: nl: upd_rxsa: pn length on non-xpn links must be %d\n",
> +				  MACSEC_DEFAULT_PN_LEN);
> +			rtnl_unlock();
> +			return -EINVAL;
> +
> +		default:
> +			pr_notice("macsec: nl: upd_rxsa: pn length must be %d or %d\n",
> +				  MACSEC_DEFAULT_PN_LEN, MACSEC_XPN_PN_LEN);
>  			rtnl_unlock();

Please do not spam the kernel log like this.  Instead, report this
info via netlink extended ACKs.

Thank you.
