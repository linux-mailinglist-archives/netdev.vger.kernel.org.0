Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B7E509ED2
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 13:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbiDULoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 07:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbiDULoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 07:44:04 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A920D222A3;
        Thu, 21 Apr 2022 04:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iXYVGbF3ixeNyAq4kutRGrMygWxyhM6LeblM6gz0/Sk=; b=ytbKjW0ri609Ivn6UdOLdYEJRA
        hefxttXa9YRcq6mDgqruzU8i+8xjtNoR19zaN/MrfmcLAmSZoqD5JpzA+bQ49KVCuGPqTew/0z7M2
        w2Q1ok9zjURaNMIoJ5k3RBYnx410I7bI0VE43C4EpbbsV7Ftz/ld6q2+QafJC1mgJb5Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nhVB8-00GnGX-Mf; Thu, 21 Apr 2022 13:40:54 +0200
Date:   Thu, 21 Apr 2022 13:40:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] net: mdio: Mask PHY only when its ACPI node is
 present
Message-ID: <YmFCxnYdRnnk41QQ@lunn.ch>
References: <20220420124053.853891-1-kai.heng.feng@canonical.com>
 <20220420124053.853891-2-kai.heng.feng@canonical.com>
 <YmAc+dzroa4D1ny2@lunn.ch>
 <CAAd53p5Wwn+HOMm1Z0VWcR_WrTzRvAGZOYg4X_txugSFd+EsDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAd53p5Wwn+HOMm1Z0VWcR_WrTzRvAGZOYg4X_txugSFd+EsDQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 10:58:40AM +0800, Kai-Heng Feng wrote:
> On Wed, Apr 20, 2022 at 10:47 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Wed, Apr 20, 2022 at 08:40:48PM +0800, Kai-Heng Feng wrote:
> > > Not all PHY has an ACPI node, for those nodes auto probing is still
> > > needed.
> >
> > Why do you need this?
> >
> > Documentation/firmware-guide/acpi/dsd/phy.rst
> >
> > There is nothing here about there being PHYs which are not listed in
> > ACPI. If you have decided to go the ACPI route, you need to list the
> > PHYs.
> 
> This is for backward-compatibility. MAC can have ACPI node but PHY may
> not have one.

And if the PHY does not have an ACPI node, fall back to
mdiobus_register(). This is what of_mdiobus_register() does. If
np=NULL, it calls mdiobus_register() and skips all the OF stuff.

	 Andrew
