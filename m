Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9116E79A61
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 22:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388358AbfG2Uzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 16:55:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39310 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387954AbfG2Uzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 16:55:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3B924145DD3AC;
        Mon, 29 Jul 2019 13:55:38 -0700 (PDT)
Date:   Mon, 29 Jul 2019 13:55:37 -0700 (PDT)
Message-Id: <20190729.135537.1580171394993286706.davem@davemloft.net>
To:     petrm@mellanox.com
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net v2] mlxsw: spectrum_ptp: Increase parsing depth
 when PTP is enabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <b1584bdec4a0a36a2567a43dc0973dd8f3a05dec.1564424420.git.petrm@mellanox.com>
References: <b1584bdec4a0a36a2567a43dc0973dd8f3a05dec.1564424420.git.petrm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 13:55:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>
Date: Mon, 29 Jul 2019 18:26:14 +0000

> Spectrum systems have a configurable limit on how far into the packet they
> parse. By default, the limit is 96 bytes.
> 
> An IPv6 PTP packet is layered as Ethernet/IPv6/UDP (14+40+8 bytes), and
> sequence ID of a PTP event is only available 32 bytes into payload, for a
> total of 94 bytes. When an additional 802.1q header is present as
> well (such as when ptp4l is running on a VLAN port), the parsing limit is
> exceeded. Such packets are not recognized as PTP, and are not timestamped.
> 
> Therefore generalize the current VXLAN-specific parsing depth setting to
> allow reference-counted requests from other modules as well. Keep it in the
> VXLAN module, because the MPRS register also configures UDP destination
> port number used for VXLAN, and is thus closely tied to the VXLAN code
> anyway.
> 
> Then invoke the new interfaces from both VXLAN (in obvious places), as well
> as from PTP code, when the (global) timestamping configuration changes from
> disabled to enabled or vice versa.
> 
> Fixes: 8748642751ed ("mlxsw: spectrum: PTP: Support SIOCGHWTSTAMP, SIOCSHWTSTAMP ioctls")
> Signed-off-by: Petr Machata <petrm@mellanox.com>
> ---
> 
> Notes:
>     v2:
>     - Preserve RXT in mlxsw_sp1_ptp_mtpppc_update()

Applied, thanks Petr.
