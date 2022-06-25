Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC2255A770
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 08:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbiFYFpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 01:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbiFYFpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 01:45:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9817136B52
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 22:45:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E9595CE2006
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 05:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26365C3411C;
        Sat, 25 Jun 2022 05:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656135945;
        bh=7eYRqSb5y+OGX5o6D+hSZSA2g97Au/2HovtE2bO9RlY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UwjkAjtdEBWQUovBVF2grZPi1kebAzRAvWzfu1RNTNWKhzYnz22Oz3fw7kSlOKWov
         Fdr0aCZW0hGUt/CjRexTNJSwLbXNzH3v0w3U/Rvu8BNRaqCqxxpeT9Bgf7Z4xztwc5
         aQJdOB09BaiEZbyfZRBegmYKwAMs2j/i4YQ7u4dz7MFj3aI+DhKFxlP4XRezqsZo7K
         HOnCKVLrXmIry0cWY484qEiiAxbdvEDRLH53OqoCKs9L713MTQ9Vw6yFyxZVZ3ChyB
         Ssq6/q1ZCBgX+qrFb+RiW80uo6EZXhbnUmZ+s8Ah2xlRraBa6u0JDxUXsgQTcQCGeI
         LjxoOI/XhcEwA==
Date:   Fri, 24 Jun 2022 22:45:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] ptp: ocp: add EEPROM_AT24 dependency
Message-ID: <20220624224530.359d16b1@kernel.org>
In-Reply-To: <20220623235308.qrfmd5tfknhf7ggs@bsd-mbp.dhcp.thefacebook.com>
References: <20220623233141.31251-1-vfedorenko@novek.ru>
        <20220623235308.qrfmd5tfknhf7ggs@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jun 2022 16:53:08 -0700 Jonathan Lemon wrote:
> On Fri, Jun 24, 2022 at 02:31:41AM +0300, Vadim Fedorenko wrote:
> > Various information which is provided via devlink is stored in
> > EEPROM and is not accessible unless at24 eeprom is supported.
> > 
> > Fixes: 773bda964921 ("ptp: ocp: Expose various resources on the timecard.")
> > Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> > ---
> >  drivers/ptp/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
> > index 458218f88c5e..c86be47e69ed 100644
> > --- a/drivers/ptp/Kconfig
> > +++ b/drivers/ptp/Kconfig
> > @@ -171,7 +171,7 @@ config PTP_1588_CLOCK_OCP
> >  	tristate "OpenCompute TimeCard as PTP clock"
> >  	depends on PTP_1588_CLOCK
> >  	depends on HAS_IOMEM && PCI
> > -	depends on I2C && MTD
> > +	depends on I2C && EEPROM_AT24 && MTD
> >  	depends on SERIAL_8250
> >  	depends on !S390
> >  	depends on COMMON_CLK  
> 
> The intent was to list the minimum dependencies for the PTP clock to
> operate and for the module to compile.
> 
> While EEPROM_AT24 is needed to read the chip, it can operate without it.
> 
> Full access to all features needs addtional configuration options, for
> example, MTD_SPI_NOR, SPI_XILINX, I2C_XILINX.  These are not required
> for the basic ptp clock operation.  
> 
> I think listing these configuration options would be more appropriate
> in the Documentation entry.

You can try "imply".
