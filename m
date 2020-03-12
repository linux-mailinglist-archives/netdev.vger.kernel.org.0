Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9780182893
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 06:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387873AbgCLFsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 01:48:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55896 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387677AbgCLFsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 01:48:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3AE4D14BA6B87;
        Wed, 11 Mar 2020 22:48:22 -0700 (PDT)
Date:   Wed, 11 Mar 2020 22:48:21 -0700 (PDT)
Message-Id: <20200311.224821.1526910923298377538.davem@davemloft.net>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@resnulli.us,
        andrew@lunn.ch, f.fainelli@gmail.com, linville@tuxdriver.com,
        johannes@sipsolutions.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 04/15] ethtool: add ethnl_parse_bitset() helper
From:   David Miller <davem@davemloft.net>
In-Reply-To: <70fe704ddd961de7250e2cb7800369509ed6e1d8.1583962006.git.mkubecek@suse.cz>
References: <cover.1583962006.git.mkubecek@suse.cz>
        <70fe704ddd961de7250e2cb7800369509ed6e1d8.1583962006.git.mkubecek@suse.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Mar 2020 22:48:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Wed, 11 Mar 2020 22:40:23 +0100 (CET)

> +int ethnl_parse_bitset(unsigned long *val, unsigned long *mask,
> +		       unsigned int nbits, const struct nlattr *attr,
> +		       ethnl_string_array_t names,
> +		       struct netlink_ext_ack *extack)
> +{
 ...
> +		if (bit_val)
> +			set_bit(idx, val);
> +		if (!no_mask)
> +			set_bit(idx, mask);

You can certainly use non-atomic __set_bit() in this context.
