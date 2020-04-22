Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5331B4DB9
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 21:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgDVTxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 15:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725779AbgDVTxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 15:53:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D9CC03C1A9;
        Wed, 22 Apr 2020 12:53:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EE047120ED563;
        Wed, 22 Apr 2020 12:53:40 -0700 (PDT)
Date:   Wed, 22 Apr 2020 12:53:40 -0700 (PDT)
Message-Id: <20200422.125340.55926071085123839.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net v2 0/5] net: dsa: b53: Various ARL fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200421032655.5537-1-f.fainelli@gmail.com>
References: <20200421032655.5537-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 12:53:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Mon, 20 Apr 2020 20:26:50 -0700

> Hi David, Andrew, Vivien, Jakub,
> 
> This patch series fixes a number of short comings in the existing b53
> driver ARL management logic in particular:
> 
> - we were not looking up the {MAC,VID} tuples against their VID, despite
>   having VLANs enabled
> 
> - the MDB entries (multicast) would lose their validity as soon as a
>   single port in the vector would leave the entry
> 
> - the ARL was currently under utilized because we would always place new
>   entries in bin index #1, instead of using all possible bins available,
>   thus reducing the ARL effective size by 50% or 75% depending on the
>   switch generation
> 
> - it was possible to overwrite the ARL entries because no proper space
>   verification was done
> 
> This patch series addresses all of these issues.
> 
> Changes in v2:
> - added a new patch to correctly flip invidual VLAN learning vs. shared
>   VLAN learning depending on the global VLAN state
> 
> - added Andrew's R-b tags for patches which did not change
> 
> - corrected some verbosity and minor issues in patch #4 to match caller
>   expectations, also avoid a variable length DECLARE_BITMAP() call

Series applied and queued up for -stable, thanks.
