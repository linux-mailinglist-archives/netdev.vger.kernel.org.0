Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF422CFED6
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 21:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgLEUdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 15:33:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:47750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbgLEUdm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 15:33:42 -0500
Date:   Sat, 5 Dec 2020 12:33:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607200381;
        bh=0TdjNJJIBOBunxGNEawV+BmeS+hZ+v1lxUi+76d6Mio=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=dszsNcmd/fiN4hREWbOSv1bY0HWjt5wgAXpeRhB8a8gTaIz3x1biNVgJdF4TVdQfQ
         s3yBtzXnjkKYk9JD+4IRKHXA0LGD98R0dLZ1SGR8t0R1x3lKtDDtplq99nad53RJ5T
         ldAA1BgegdycTtEuUSpaGKkyjPSZ09NYWt9uD0S6FUp27U3KDplG+BA2jpfVh6Aaqk
         pAaBSEzKKCvmQEYT1WYPVMYLyuQgMM2r+WPa6z/S+P4dt/FsgpBRrmKiUho55EEYKx
         c3VxA/zaxS0lVdJlBnno5w+eYqKK5iAmRr4gAH6VHxDM0nD3v1x0sWLDyRsiTzwT5k
         zeoeWPe5W0/nQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Thomas Wagner <thwa1@web.de>
Subject: Re: [net 3/3] can: isotp: add SF_BROADCAST support for functional
 addressing
Message-ID: <20201205123300.34f99141@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <eefc4f80-da1c-fed5-7934-11615f1db0fc@pengutronix.de>
References: <20201204133508.742120-1-mkl@pengutronix.de>
        <20201204133508.742120-4-mkl@pengutronix.de>
        <20201204194435.0d4ab3fd@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <b4acc4eb-aff6-9d20-b8a9-d1c47213cefd@hartkopp.net>
        <eefc4f80-da1c-fed5-7934-11615f1db0fc@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Dec 2020 21:24:42 +0100 Marc Kleine-Budde wrote:
> On 12/5/20 12:26 PM, Oliver Hartkopp wrote:
> > On 05.12.20 04:44, Jakub Kicinski wrote:  
> >> On Fri,  4 Dec 2020 14:35:08 +0100 Marc Kleine-Budde wrote:  
> >>> From: Oliver Hartkopp <socketcan@hartkopp.net>
> >>>
> >>> When CAN_ISOTP_SF_BROADCAST is set in the CAN_ISOTP_OPTS flags the CAN_ISOTP
> >>> socket is switched into functional addressing mode, where only single frame
> >>> (SF) protocol data units can be send on the specified CAN interface and the
> >>> given tp.tx_id after bind().
> >>>
> >>> In opposite to normal and extended addressing this socket does not register a
> >>> CAN-ID for reception which would be needed for a 1-to-1 ISOTP connection with a
> >>> segmented bi-directional data transfer.
> >>>
> >>> Sending SFs on this socket is therefore a TX-only 'broadcast' operation.  
> >>
> >> Unclear from this patch what is getting fixed. Looks a little bit like
> >> a feature which could be added in a backward compatible way, no?
> >> Is it only added for completeness of the ISOTP implementation?
> >>  
> > 
> > Yes, the latter.
> > 
> > It's a very small and simple tested addition and I hope it can still go 
> > into the initial upstream process.  
> 
> What about the (incremental?) change that Thomas Wagner posted?
> 
> https://lore.kernel.org/r/20201204135557.55599-1-thwa1@web.de

That settles it :) This change needs to got into -next and 5.11.
