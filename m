Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B206EE37F
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 15:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbjDYNyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 09:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbjDYNyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 09:54:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B915D184
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 06:54:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 540586242A
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 13:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA02C433EF;
        Tue, 25 Apr 2023 13:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682430882;
        bh=Grd8nX6oRfpCHBvpsddf0RdektKMRFGTViOoRwFrRKI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nx2vFVaGBtVLpVrZLJPLLHLq8PNKQVH24w7Nl/C/jgQCL20foa26gtZ4+70GK4nis
         wf/z6uZTfG38Va4FKvAqAz9FA2r2x6pgIf2ID5pOAsyWPDy9G3WANJS47ciEbcpE3P
         9ebh+fYVjaeRPbVLWUxQoVwHwAmFAbO7dFtzxczcGPOu2kYBO7r+emrvK7Rxqk4Ok+
         yj7R/JwgKT0qCI2g26+7LiP+mv1szchBAwEYfOWeAwsSTZC+i+uaMmTpXlcZXJ7lZ+
         GIqaSCgimK1MoavJqrqEZ687af+4y+2u8phQmLXEnuv/QRzVoxpaBVYSvpCU+wQuFp
         T+VZxtg9dBsSQ==
Date:   Tue, 25 Apr 2023 06:54:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Corinna Vinschen <vinschen@redhat.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: allow ethtool action on PCI
 devices if device is down
Message-ID: <20230425065441.1bc15b29@kernel.org>
In-Reply-To: <ZEeLyVNgsFmRvour@calimero.vinschen.de>
References: <20230331092341.268964-1-vinschen@redhat.com>
        <45c43618-3368-f780-c8bb-68db4ed5760f@gmail.com>
        <ZCqfwxr2I7xt6zon@calimero.vinschen.de>
        <ZEeLyVNgsFmRvour@calimero.vinschen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Apr 2023 10:14:01 +0200 Corinna Vinschen wrote:
> is that patch still under review or is it refused, given the
> current behaviour is not actually incorrect?

That's not what Heiner said. Does the device not link the netdev
correctly to the bus device? Core already does pm_get/pm_put
around ethtool calls.
