Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D896723595B
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 18:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgHBQzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 12:55:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39120 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgHBQzQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Aug 2020 12:55:16 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k2HGS-007wGX-8w; Sun, 02 Aug 2020 18:55:12 +0200
Date:   Sun, 2 Aug 2020 18:55:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Adrian Pop <popadrian1996@gmail.com>
Cc:     netdev@vger.kernel.org, linville@tuxdriver.com,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH] ethtool: Add QSFP-DD support
Message-ID: <20200802165512.GI1862409@lunn.ch>
References: <20200731084725.7804-1-popadrian1996@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731084725.7804-1-popadrian1996@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 11:47:25AM +0300, Adrian Pop wrote:
> The Common Management Interface Specification (CMIS) for QSFP-DD shares
> some similarities with other form factors such as QSFP or SFP, but due to
> the fact that the module memory map is different, the current ethtool
> version is not able to provide relevant information about an interface.
> 
> This patch adds QSFP-DD support to ethtool. The changes are similar to
> the ones already existing in qsfp.c, but customized to use the memory
> addresses and logic as defined in the specifications document.
> 
> Page 0x00 (lower and higher memory) are always implemented, so the ethtool
> expects at least 256 bytes if the identifier matches the one for QSFP-DD.
> For optical connected cables, additional pages are usually available (the
> contain module defined  thresholds or lane diagnostic information). In
> this case, ethtool expects to receive 768 bytes in the following format:
> 
>     +----------+----------+----------+----------+----------+----------+
>     |   Page   |   Page   |   Page   |   Page   |   Page   |   Page   |
>     |   0x00   |   0x00   |   0x01   |   0x02   |   0x10   |   0x11   |
>     |  (lower) | (higher) | (higher) | (higher) | (higher) | (higher) |
>     |   128B   |   128B   |   128B   |   128B   |   128B   |   128B   |
>     +----------+----------+----------+----------+----------+----------

Hi Adrian

Didn't we discuss that page 3 might be useful? I would prefer not to
document that pages 0x10 and 0x11 would follow page 2 until we have a
driver which does actually provide pages 0x10 and 0x11.

       Andrew
