Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAB7CAECA
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 21:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732289AbfJCTEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 15:04:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47368 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729702AbfJCTEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 15:04:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 38427146D042D;
        Thu,  3 Oct 2019 12:04:37 -0700 (PDT)
Date:   Thu, 03 Oct 2019 12:04:34 -0700 (PDT)
Message-Id: <20191003.120434.606814989607407144.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: sja1105: Add support for port
 mirroring
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191002233443.12345-1-olteanv@gmail.com>
References: <20191002233443.12345-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Oct 2019 12:04:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Thu,  3 Oct 2019 02:34:43 +0300

> +	already_enabled = (general_params->mirr_port != SJA1105_NUM_PORTS);
> +	if (already_enabled && enabled && general_params->mirr_port != to) {
> +		dev_err(priv->ds->dev,
> +			"Delete mirroring rules towards port %d first", to);
> +		return -EBUSY;
> +	}

In this situation, the user is trying to add a mirror rule to port 'to'
when we already have rules pointing to "general_params->mirr_port".

So you should be printing out the value of "general_params->mirr_port"
in this message rather than 'to'.
