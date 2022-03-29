Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040154EB63D
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 00:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237604AbiC2W6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 18:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238783AbiC2W55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 18:57:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E8C1FF218;
        Tue, 29 Mar 2022 15:56:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D620B81AC0;
        Tue, 29 Mar 2022 22:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4853BC340ED;
        Tue, 29 Mar 2022 22:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648594570;
        bh=ksuq1R8pSpjJONhoUKRGAf+f3bC+JKVtq1dWnWz3wNU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IEEH07hp4AwMgoIeNeOBPvNW99HUs9/erJvbuIyH0Ken+cf7aXHjsNJyR/OtWd+++
         b3/ySZiyOwGfBRKFOMhL5CHvzf7LvKjEM0TK/gEcIoFjQud5xxHFYX1ioBnnBxyLzd
         wLmn/5MOszcCuBmiZH/1lJxSk2EZvaHhB+qe0ctvk1WkmPKSfFEKALd84XvbzwTUUh
         MhyKVApRE87yj53FaptWGgbmwuCPcM7AVzOdPuNDiR42Cy1o9loL3/wnhI43zZTjcs
         oXW7iHXWfLqPdS1ixDyIV+3IoD/bmzGa4dxe9eKQebH31MOnccUbKpHKQlX2wTve8p
         dh6GFb5/MuFCw==
Date:   Tue, 29 Mar 2022 15:56:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     andrew@lunn.ch
Cc:     Andy Chiu <andy.chiu@sifive.com>, radhey.shyam.pandey@xilinx.com,
        robert.hancock@calian.com, michal.simek@xilinx.com,
        davem@davemloft.net, pabeni@redhat.com, robh+dt@kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        Greentime Hu <greentime.hu@sifive.com>
Subject: Re: [PATCH v7 net 4/4] net: axiemac: use a phandle to reference
 pcs_phy
Message-ID: <20220329155609.674caa9c@kernel.org>
In-Reply-To: <20220329024921.2739338-5-andy.chiu@sifive.com>
References: <20220329024921.2739338-1-andy.chiu@sifive.com>
        <20220329024921.2739338-5-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Mar 2022 10:49:21 +0800 Andy Chiu wrote:
> In some SGMII use cases where both a fixed link external PHY and the
> internal PCS/PMA PHY need to be configured, we should explicitly use a
> phandle "pcs-phy" to get the reference to the PCS/PMA PHY. Otherwise, the
> driver would use "phy-handle" in the DT as the reference to both the
> external and the internal PCS/PMA PHY.
> 
> In other cases where the core is connected to a SFP cage, we could still
> point phy-handle to the intenal PCS/PMA PHY, and let the driver connect
> to the SFP module, if exist, via phylink.
> 
> Fixes: 1a02556086fc (net: axienet: Properly handle PCS/PMA PHY for 1000BaseX mode)
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> Reviewed-by: Robert Hancock <robert.hancock@calian.com>

I'm not sure if this is a fix or adding support for a new configuration.
Andrew, WDYT?

If it really is a fix and needs to be backported we should take patch 2
out of this series, and post it separately later. Refactoring does not
belong in stable trees.
