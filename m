Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4990345E5F
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 13:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhCWMll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 08:41:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42762 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231252AbhCWMlK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 08:41:10 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lOgLJ-00Cayl-5z; Tue, 23 Mar 2021 13:41:05 +0100
Date:   Tue, 23 Mar 2021 13:41:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic
 reconfiguration of tag protocol
Message-ID: <YFnh4dEap/lGX4ix@lunn.ch>
References: <20210323102326.3677940-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323102326.3677940-1-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 11:23:26AM +0100, Tobias Waldekranz wrote:
> All devices are capable of using regular DSA tags. Support for
> Ethertyped DSA tags sort into three categories:
> 
> 1. No support. Older chips fall into this category.
> 
> 2. Full support. Datasheet explicitly supports configuring the CPU
>    port to receive FORWARDs with a DSA tag.
> 
> 3. Undocumented support. Datasheet lists the configuration from
>    category 2 as "reserved for future use", but does empirically
>    behave like a category 2 device.
> 
> Because there are ethernet controllers that do not handle regular DSA
> tags in all cases, it is sometimes preferable to rely on the
> undocumented behavior, as the alternative is a very crippled
> system. But, in those cases, make sure to log the fact that an
> undocumented feature has been enabled.

Hi Tobias

I wonder if dynamic reconfiguration is the correct solution here. By
default it will be wrong for this board, and you need user space to
flip it.

Maybe a DT property would be better. Extend dsa_switch_parse_of() to
look for the optional property dsa,tag-protocol, a string containing
the name of the tag ops to be used.

    Andrew
