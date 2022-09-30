Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6F55F0DDC
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiI3Opy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbiI3Opu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:45:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B96691B1
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:45:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC0BA62350
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BBCC433D6;
        Fri, 30 Sep 2022 14:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664549148;
        bh=0XcVjxNfa4BwVCnJRuSVkTefkRGOYRt5nAJfvvk+lCg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XihF327+7ZuJhGxPbTFQsaCZxfoAwL4VPxzzyGd2apdCEeHFTxeZ3hadAdRvvjTZ7
         9yRC9hjmAQvduPFHsoic/FIvEWflheL+++EJFlvYukDE7/n7qPX2ow+O3ZbHtYxP6W
         E/+k8Wf3bxTKp7KyXaEa8PvAAKKfJrqOuSC6i8DMIKErmlk+poIrb/CVscAhjARDbR
         l8UfrK5jlnRKGs1RKKthA0xoDOLzunPQVLWhcx84DvkN0dTNxvt/08OzjLsrn94Knv
         ScuvRk9CmK7ut3tSwOdmiJIGsBi/Sc/fYjcTQdbjdhTGbxHa5bPpOFX/CcNOE7347m
         7gYAs6AVT/ZIw==
Date:   Fri, 30 Sep 2022 07:45:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Subject: Re: PHY firmware update method
Message-ID: <20220930074546.0873af1d@kernel.org>
In-Reply-To: <Yzbi335GQGbGLL4k@lunn.ch>
References: <bf53b9b3660f992d53fe8d68ea29124a@walle.cc>
        <YzQ96z73MneBIfvZ@lunn.ch>
        <YzVDZ4qrBnANEUpm@nanopsycho>
        <YzWPXcf8kXrd73PC@lunn.ch>
        <20220929071209.77b9d6ce@kernel.org>
        <YzWxV/eqD2UF8GHt@lunn.ch>
        <Yzan3ZgAw3ImHfeK@nanopsycho>
        <Yzbi335GQGbGLL4k@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Sep 2022 14:36:47 +0200 Andrew Lunn wrote:
> > Yeah, I tend to agree here. I believe that phylib should probably find a
> > separate way to to the flash.
> > 
> > But perhaps it could be a non-user-facing flash. I mean, what if phylib
> > has internal routine to:
> > 1) do query phy fw version
> > 2) load a fw bin related for this phy (easy phy driver may provide the
> > 				       path/name of the file)
> > 3) flash if there is a newer version available  
> 
> That was my first suggestion. One problem is getting the version from
> the binary blob firmware. But this seems like a generic problem for
> linux-firmware, so maybe somebody has worked on a standardised header
> which can be preppended with this meta data?

Not that I know, perhaps the folks that do laptop FW upgrade have some
thoughts https://fwupd.org/ 

Actually maybe there's something in DMTF, does PLDM have standard image
format? Adding Jake. Not sure if PHYs would use it tho :S 

What's the interface that the PHY FW exposes? Ben H was of the opinion
that we should just expose the raw mtd devices.. just saying..
