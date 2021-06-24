Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8D03B37CA
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 22:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhFXU3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 16:29:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54504 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232524AbhFXU3g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 16:29:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/pm2bkWF1cJ37ONb08ORETdFiK8h6vzOxgurAFfTJfw=; b=31NNr20SPIRxg8jIQlxyorAb0u
        pOeV/OA8PcPZvLCD1tvdZQ7y4YOTmgo9p6IGB+w0w+FCz5z0w13zheqSGgklQPznUbVBVPwcxscMC
        ZRNK6qoLChK3HlXkmbxrpgJI0fOFewBjf8k1knUkWbQyF/w7vPictzFCHflduCkPybjA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lwVwP-00B1cG-VY; Thu, 24 Jun 2021 22:27:13 +0200
Date:   Thu, 24 Jun 2021 22:27:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, vladyslavt@nvidia.com, moshe@nvidia.com,
        vadimp@nvidia.com, mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/4] ethtool: Add ability to write to
 transceiver module EEPROMs
Message-ID: <YNTqofVlJTgsvDqH@lunn.ch>
References: <20210623075925.2610908-1-idosch@idosch.org>
 <YNOBKRzk4S7ZTeJr@lunn.ch>
 <YNTfMzKn2SN28Icq@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNTfMzKn2SN28Icq@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I fail to understand this logic. I would understand pushing
> functionality into the kernel in order to create an abstraction for user
> space over different hardware interfaces from different vendors. This is
> not the case here. Nothing is vendor specific. Not to the host vendor
> nor to the module vendor.

Hi Ido

My worry is, we are opening up an ideal vector for user space drivers
for SFPs. And worse still, closed source user space drivers. We have
had great success with switchdev, over a hundred supported switches,
partially because we have always pushed back against kAPIs which allow
user space driver, closed binary blobs etc.

We have the choice here. We can add a write method to the kAPI, add
open source code to Ethtool using that API, and just accept people are
going to abuse the API for all sorts of horrible things in user space.
Or we can add more restrictive kAPIs, put more code in the kernel, and
probably limit user space doing horrible things. Maybe as a side
effect, SFP vendors contribute some open source code, rather than
binary blobs?

I tend to disagree about adding kAPIs which allow write. But i would
like to hear other peoples opinions on this.

     Andrew

