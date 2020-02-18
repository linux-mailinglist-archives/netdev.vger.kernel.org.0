Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6AD16236F
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 10:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgBRJd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 04:33:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:43404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbgBRJd5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 04:33:57 -0500
Received: from dragon (80.251.214.228.16clouds.com [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4C8A20722;
        Tue, 18 Feb 2020 09:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582018436;
        bh=K36RDAcdA5MabXG47exlTsMpZKm6WyeaQQyW6jWnhCs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L9bL+/4yW0jhUgqaTD0QPEIhUsewMfhj9+WJtdmiKXtwOTGZA92D9dL3eAjBjjgLX
         mWc16CQ+64dnjveWLqv/sumLTuspB6LSkDBwptVYGX0JgAK3kvzKMqW4Z9vgVgdnp2
         HmU3WkwU9nJks1a6eJD7kiLvfZfXBbzityqETXVE=
Date:   Tue, 18 Feb 2020 17:33:51 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, wg@grandegger.com,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        Pankaj Bansal <pankaj.bansal@nxp.com>
Subject: Re: [PATCH 0/8] can: flexcan: add CAN FD support for NXP Flexcan
Message-ID: <20200218093346.GC6075@dragon>
References: <24eb5c67-4692-1002-2468-4ae2e1a6b68b@pengutronix.de>
 <20200213192027.4813-1-michael@walle.cc>
 <DB7PR04MB461896B6CC3EDC7009BCD741E6150@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <2322fb83486c678917957d9879e27e63@walle.cc>
 <DB7PR04MB46187A6B5A8EC3A1D73D69FFE6150@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <bf671072ce479049eb354d44f3617383@walle.cc>
 <DB7PR04MB46183F74C137B644A229B632E6150@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <78789949f2a9dc532ec461768fbd3a60@walle.cc>
 <20200217071349.GC7973@dragon>
 <0d02f6cee0d3a680f246e8fea40f6699@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d02f6cee0d3a680f246e8fea40f6699@walle.cc>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 09:48:36AM +0100, Michael Walle wrote:
> > My opinion is that all compatibles should be defined explicitly in
> > bindings doc.  In above example, the possible values of <processor>
> > should be given.  This must be done anyway, as we are moving to
> > json-schema bindings.
> 
> But if they are listed in the document, they also have to be in the
> of_device_id table, correct?

I do not think so.  Documenting compatibles used in DTS now doesn't
necessarily mean we need to use it in kernel driver right away.
Bindings doc is a specification for device tree, not kernel.  With the
compatible in DTS and bindings, kernel can start using it at any time
when there is a need, like dealing with SoC quirks or bugs found later.

Shawn

> Which somehow contradicts the talk Pankaj
> mentioned [1,2]. Eg.
> 
>   compatible = "fsl,ls1028ar1-flexcan","fsl,lx2160ar1-flexcan";
> 
> Doesn't make any sense, because the "fsl,ls1028ar1-flexcan" is alreay
> in the driver and the fallback "fsl,lx2160ar1-flexcan" isn't needed.
> 
> OTOH the talk is already 2 to 3 years old and things might have changed
> since then.
> 
> -michael
> 
> [1] https://elinux.org/images/0/0e/OSELAS.Presentation-ELCE2017-DT.pdf
> [2] https://www.youtube.com/watch?v=6iguKSJJfxo
