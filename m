Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE9160EEC2
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 05:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbiJ0Dkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 23:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234471AbiJ0Dk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 23:40:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C3E2CCA2;
        Wed, 26 Oct 2022 20:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 608E262157;
        Thu, 27 Oct 2022 03:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5531AC433C1;
        Thu, 27 Oct 2022 03:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666842018;
        bh=GyIfj4IMk1Z0HBO58cMK4cGISzPvw+zc6MisDvaFk9w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U63FD2C3f+mnxAKh3hmd8a/fk7vemt+nCfPUkcwTmluNTTYDZ7bHp8AzkAfV6woPP
         wsNubL1QFMGF/2xOixBO4rPTPYw6ngwwUokk4Do/487B1s6Z10IgsaTCHEZo9KLgG+
         EWGhGwoHIxoRzcwsWUq59pzDIncTDLriTgs3+cffVTF5F92kTjXb/2d1msfyJYB2yy
         04xlO61IbgysK8TBX9qB13YXRmjQXuYrYItjiIkIYQrTgwwq4ZOJhQtqr132TKcKey
         YXwfSXfQvkzK4pbos3J4CtlYG/dib7VAGM2v0RIj/+BV0HA+jrwK8HIzwadaZvG/2A
         OIA2ys4fPDhuA==
Date:   Wed, 26 Oct 2022 20:40:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexandru Tachici <alexandru.tachici@analog.com>
Cc:     <linux-kernel@vger.kernel.org>, <andrew@lunn.ch>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <lennart@lfdomain.com>
Subject: Re: [net v3 1/1] net: ethernet: adi: adin1110: Fix notifiers
Message-ID: <20221026204017.0a0afff5@kernel.org>
In-Reply-To: <20221025075227.9276-2-alexandru.tachici@analog.com>
References: <20221025075227.9276-1-alexandru.tachici@analog.com>
        <20221025075227.9276-2-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Oct 2022 10:52:27 +0300 Alexandru Tachici wrote:
> +	int err;
> +
> +	err = adin1110_setup_notifiers();
> +	if (err)
> +		return err;
> +
> +	return spi_register_driver(&adin1110_driver);

What unregisters the notifies if spi_register_driver()
fails, now?
