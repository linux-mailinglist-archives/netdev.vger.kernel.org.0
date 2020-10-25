Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C517D298232
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 15:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416882AbgJYOr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 10:47:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43508 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1415756AbgJYOr3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Oct 2020 10:47:29 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kWhIo-003RJA-Vi; Sun, 25 Oct 2020 15:47:22 +0100
Date:   Sun, 25 Oct 2020 15:47:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tom Rix <trix@redhat.com>
Cc:     Xu Yilun <yilun.xu@intel.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        mdf@kernel.org, lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        linux-fpga@vger.kernel.org, netdev@vger.kernel.org,
        lgoncalv@redhat.com, hao.wu@intel.com,
        Russ Weight <russell.h.weight@intel.com>
Subject: Re: [RFC PATCH 5/6] ethernet: dfl-eth-group: add DFL eth group
 private feature driver
Message-ID: <20201025144722.GF792004@lunn.ch>
References: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
 <1603442745-13085-6-git-send-email-yilun.xu@intel.com>
 <326cf423-33ef-1fea-86c5-1b5245eadddf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <326cf423-33ef-1fea-86c5-1b5245eadddf@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +u64 read_mac_stats(struct eth_com *ecom, unsigned int addr)
> > +{
> > +	u32 data_l, data_h;
> > +
> > +	if (eth_com_read_reg(ecom, addr, &data_l) ||
> > +	    eth_com_read_reg(ecom, addr + 1, &data_h))
> > +		return 0xffffffffffffffffULL;

> return -1; ?

Since this is a u64 function, i expect you get a compiler
warning. Maybe only with W=1. It is better to use U64_MAX.

	 Andrew
