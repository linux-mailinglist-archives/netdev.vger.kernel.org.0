Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9AE68CF7E
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 07:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjBGGad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 01:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjBGGac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 01:30:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6BB5FEB
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 22:30:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5282EB81690
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 06:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B0DC433EF;
        Tue,  7 Feb 2023 06:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675751428;
        bh=rPnzmAwbqSckDZcO3S0UYXYRILa3UgZwpQXQfw3P+S4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lsluIHjrhyrBXR8f1pJYW/pWREfWWOegbDXrzFJmlYoLFFkAkaA2fv6sb5/wov+Oe
         IF4lxfeIa4ey0CCbPsiHk9YqSimXu/afaecMNx5YHqtAcpJ3IaSsVBhCz88pAQ9+Af
         gcTNHURefTjutsrlURVpHXz7Ht5DE8dWfxPdBH9Qwe1TlK6hbjjxVQUT7pJ49/f1W+
         wdim41bHski+BikNj7j1lLm4h4AXeNrpiC1SKpOsQgrDKd0uLOGhbsEPrjx8B4XUhC
         NwsYZfDk70OG8jJ5C2F7HLLrm1wUADm1nhNwCpFBRlMKMTp5FwCFqH+gNOgsC9ga4Q
         LI7CyBDI+oyeg==
Date:   Mon, 6 Feb 2023 22:30:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Stein <alexander.stein@ew.tq-group.com>
Cc:     Wei Fang <wei.fang@nxp.com>, Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Lunn <andrew@lunn.ch>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: fec: Don't fail on missing optional
 phy-reset-gpios
Message-ID: <20230206223027.0d65ce10@kernel.org>
In-Reply-To: <20230203132102.313314-1-alexander.stein@ew.tq-group.com>
References: <20230203132102.313314-1-alexander.stein@ew.tq-group.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Feb 2023 14:21:02 +0100 Alexander Stein wrote:
> The conversion to gpio descriptors accidentally removed the short return
> if there is no 'phy-reset-gpios' property, leading to the error
> 
> fec 30be0000.ethernet: error -ENOENT: failed to get phy-reset-gpios
> 
> This is especially the case when the PHY reset GPIO is specified in
> the PHY node itself.
> 
> Fixes: 468ba54bd616 ("fec: convert to gpio descriptor")
> Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>

Fixed around the same time by commit d7b5e5dd669436 right?
