Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DD5207EC0
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 23:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404449AbgFXVkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 17:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404493AbgFXVkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 17:40:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC5BC061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 14:40:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3947812731C8E;
        Wed, 24 Jun 2020 14:40:12 -0700 (PDT)
Date:   Wed, 24 Jun 2020 14:40:11 -0700 (PDT)
Message-Id: <20200624.144011.1350715546340588876.davem@davemloft.net>
To:     daniel@zonque.org
Cc:     netdev@vger.kernel.org, jcobham@questertangent.com, andrew@lunn.ch
Subject: Re: [PATCH v2] dsa: Allow forwarding of redirected IGMP traffic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200620193925.3166913-1-daniel@zonque.org>
References: <20200620193925.3166913-1-daniel@zonque.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jun 2020 14:40:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Mack <daniel@zonque.org>
Date: Sat, 20 Jun 2020 21:39:25 +0200

> The driver for Marvell switches puts all ports in IGMP snooping mode
> which results in all IGMP/MLD frames that ingress on the ports to be
> forwarded to the CPU only.
> 
> The bridge code in the kernel can then interpret these frames and act
> upon them, for instance by updating the mdb in the switch to reflect
> multicast memberships of stations connected to the ports. However,
> the IGMP/MLD frames must then also be forwarded to other ports of the
> bridge so external IGMP queriers can track membership reports, and
> external multicast clients can receive query reports from foreign IGMP
> queriers.
> 
> Currently, this is impossible as the EDSA tagger sets offload_fwd_mark
> on the skb when it unwraps the tagged frames, and that will make the
> switchdev layer prevent the skb from egressing on any other port of
> the same switch.
> 
> To fix that, look at the To_CPU code in the DSA header and make
> forwarding of the frame possible for trapped IGMP packets.
> 
> Introduce some #defines for the frame types to make the code a bit more
> comprehensive.
> 
> This was tested on a Marvell 88E6352 variant.
> 
> Signed-off-by: Daniel Mack <daniel@zonque.org>

Applied, thank you.
