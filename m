Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852FB2B136E
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 01:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgKMAog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 19:44:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52342 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgKMAof (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 19:44:35 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kdNCV-006l5p-SL; Fri, 13 Nov 2020 01:44:27 +0100
Date:   Fri, 13 Nov 2020 01:44:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: Re: [PATCH net-next 2/2] net/mlx5e: Add DSFP EEPROM dump support to
 ethtool
Message-ID: <20201113004427.GP1480543@lunn.ch>
References: <1605160181-8137-1-git-send-email-moshe@mellanox.com>
 <1605160181-8137-3-git-send-email-moshe@mellanox.com>
 <20201112131321.GL1480543@lunn.ch>
 <74076266-d861-993d-cd84-1cf170937c5f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74076266-d861-993d-cd84-1cf170937c5f@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 05:54:51PM +0200, Moshe Shemesh wrote:
> 
> On 11/12/2020 3:13 PM, Andrew Lunn wrote:
> > On Thu, Nov 12, 2020 at 07:49:41AM +0200, Moshe Shemesh wrote:
> > > From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
> > > 
> > > DSFP is a new cable module type, which EEPROM uses memory layout
> > > described in CMIS 4.0 document. Use corresponding standard value for
> > > userspace ethtool to distinguish DSFP's layout from older standards.
> > > 
> > > Add DSFP module ID in accordance to SFF-8024.
> > > 
> > > DSFP module memory can be flat or paged, which is indicated by a
> > > flat_mem bit. In first case, only page 00 is available, and in second -
> > > multiple pages: 00h, 01h, 02h, 10h and 11h.
> > You are simplifying quite a bit here, listing just these pages. When i
> > see figure 8-1, CMIS Module Memory Map, i see many more pages, and
> > banks of pages.
> 
> 
> Right, but as I understand these are the basic 5 pages which are mandatory.
> Supporting more than that we will need new API.

Humm, actually, looking at the diagram again, pages 10h and 11h are
banked. Is one bamk sufficient? If so, you need to document that bank
zero is always returned, and make sure your firmware is doing that.

We also need to be clear that tunable laser information is not
available, due to this fixed layout.

     Andrew
