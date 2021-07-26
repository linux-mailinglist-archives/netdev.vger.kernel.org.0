Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0C53D68AA
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 23:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbhGZUtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 16:49:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46296 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229687AbhGZUtA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 16:49:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=DzYMuyVjPUHDRpj9800p1iL/0YIO6wGB071ILr0Dc6A=; b=P5vU4sIZH0QuiwDyc/OMxSEsOm
        00kudS+M0V5i0GAGQaUVkxUt0M3y6egejFpyCgqL/6lQu9G3EIrj/GNkah8sNPnCZmsv2x+H6OD6M
        +fJ4G4aRe7AOEc1p4TCfULvRCQ5lKzbujtJpPjojAKKOYLvr9xj3VBP8aSR1cvLwSync=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m88A7-00Ev2y-8e; Mon, 26 Jul 2021 23:29:23 +0200
Date:   Mon, 26 Jul 2021 23:29:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] tsnep: Add TSN endpoint Ethernet MAC driver
Message-ID: <YP8pM+qD/AfuSCcU@lunn.ch>
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
 <20210726194603.14671-5-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726194603.14671-5-gerhard@engleder-embedded.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This driver provides a driver specific interface in tsnep_stream.c for
> direct access to all but the first TX/RX queue pair. There are two
> reasons for this interface. First: It enables the reservation or direct use
> of TX/RX queue pairs by real-time application on dedicated CPU cores or
> in user space.

Hi Gerhard

I expect you will get a lot of push back with a character device in
the middle of an Ethernet driver. One that mmap the Tx/Rx queue is
going to need a lot of review to make sure it is secure. Maybe talk to
the XDP/AF_XDP people, there might be a way to do it through that?

So i strongly suggest your drop tsnep_stream.c for the moment. Get the
basic plain boring Ethernet driver merged. Then start a discussion
about a suitable API for exporting rings to user space.

      Andrew
