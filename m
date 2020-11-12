Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13392B060E
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 14:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgKLNNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 08:13:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50430 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbgKLNNb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 08:13:31 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kdCPh-006etz-QP; Thu, 12 Nov 2020 14:13:21 +0100
Date:   Thu, 12 Nov 2020 14:13:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [PATCH net-next 2/2] net/mlx5e: Add DSFP EEPROM dump support to
 ethtool
Message-ID: <20201112131321.GL1480543@lunn.ch>
References: <1605160181-8137-1-git-send-email-moshe@mellanox.com>
 <1605160181-8137-3-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1605160181-8137-3-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 07:49:41AM +0200, Moshe Shemesh wrote:
> From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
> 
> DSFP is a new cable module type, which EEPROM uses memory layout
> described in CMIS 4.0 document. Use corresponding standard value for
> userspace ethtool to distinguish DSFP's layout from older standards.
> 
> Add DSFP module ID in accordance to SFF-8024.
> 
> DSFP module memory can be flat or paged, which is indicated by a
> flat_mem bit. In first case, only page 00 is available, and in second -
> multiple pages: 00h, 01h, 02h, 10h and 11h.

You are simplifying quite a bit here, listing just these pages. When i
see figure 8-1, CMIS Module Memory Map, i see many more pages, and
banks of pages.

The current API is getting more and more strand to support SFP
EEPROMs. We really do need to think of a new API, and it seems like
now is a good time to do it, in order to support these devices.

    Andrew
