Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 840EF1896A7
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 09:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbgCRILJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 04:11:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47830 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbgCRILI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 04:11:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0AA651489E0A9;
        Wed, 18 Mar 2020 01:11:08 -0700 (PDT)
Date:   Tue, 17 Mar 2020 22:47:32 -0700 (PDT)
Message-Id: <20200317.224732.583644832239870673.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 0/4] net: bridge: vlan options: add support
 for tunnel mapping
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200317120836.1765164-1-nikolay@cumulusnetworks.com>
References: <20200317120836.1765164-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Mar 2020 01:11:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Tue, 17 Mar 2020 14:08:32 +0200

> In order to bring the new vlan API on par with the old one and be able
> to completely migrate to the new one we need to support vlan tunnel mapping
> and statistics. This patch-set takes care of the former by making it a
> vlan option. There are two notable issues to deal with:
>  - vlan range to tunnel range mapping
>    * The tunnel ids are globally unique for the vlan code and a vlan can
>      be mapped to one tunnel, so the old API took care of ranges by
>      taking the starting tunnel id value and incrementally mapping
>      vlan id(i) -> tunnel id(i). This set takes the same approach and
>      uses one new attribute - BRIDGE_VLANDB_ENTRY_TUNNEL_ID. If used
>      with a vlan range then it's the starting tunnel id to map.
> 
>  - tunnel mapping removal
>    * Since there are no reserved/special tunnel ids defined, we can't
>      encode mapping removal within the new attribute, in order to be
>      able to remove a mapping we add a vlan flag which makes the new
>      tunnel option remove the mapping
> 
> The rest is pretty straight-forward, in fact we directly re-use the old
> code for manipulating tunnels by just mapping the command (set/del). In
> order to be able to keep detecting vlan ranges we check that the current
> vlan has a tunnel and it's extending the current vlan range end's tunnel
> id.

Looks good, series applied, thank you.
