Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCFC654203C
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384261AbiFHATr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1583049AbiFGXqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 19:46:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DEB195941;
        Tue,  7 Jun 2022 15:06:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C06861944;
        Tue,  7 Jun 2022 22:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68697C385A2;
        Tue,  7 Jun 2022 22:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654639575;
        bh=YH+P3LYLx7Tm2PJ2F4edHaCG/gLgDOCPlgGr94QeaIg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JR+ziHpeN4WpMxBhyffqFam49asBgk7MouOL1vukNrcH+Jc0y9z6zNGDlNBV/qt5S
         jNyi0Ic2txl+7f7lNUx3qpsm2rMq1NXeRlBxUCdHSdQDjJ+9yZq/QeZLJFGvs+Q4RW
         Vx+L6IvhdxQ9h92F+5f+h7mpeaC05c9h3mVtSjt+VLn9ZLzaVRAekmsl+RJA7NPxV8
         8ud99o86zF6OTm5nMLqM6vEttoqCRX5rHaYPm7GOSCpf50glg4DECmvIAeWzWRs5VJ
         K6eY2Can6ndeT9AP8RqhnLtauzSAlIAfEzEL6OKnped28nkV7Wxq9TvLPd9ZceKEjZ
         A8FWQ57Gss5fQ==
Date:   Tue, 7 Jun 2022 15:06:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Max Staudt <max@enpas.org>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 4/7] can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
Message-ID: <20220607150614.6248c504@kernel.org>
In-Reply-To: <20220607182216.5fb1084e.max@enpas.org>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
        <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
        <20220604163000.211077-5-mailhol.vincent@wanadoo.fr>
        <CAMuHMdXkq7+yvD=ju-LY14yOPkiiHwL6H+9G-4KgX=GJjX=h9g@mail.gmail.com>
        <CAMZ6RqLEEHOZjrMH+-GLC--jjfOaWYOPLf+PpefHwy=cLpWTYg@mail.gmail.com>
        <20220607182216.5fb1084e.max@enpas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Jun 2022 18:22:16 +0200 Max Staudt wrote:
> > Honestly, I am totally happy to have the "default y" tag, the "if
> > unsure, say Y" comment and the "select CAN_RX_OFFLOAD" all together.
> > 
> > Unless I am violating some kind of best practices, I prefer to keep it
> > as-is. Hope this makes sense.  

AFAIU Linus likes for everything that results in code being added to
the kernel to default to n. If the drivers hard-select that Kconfig
why bother user with the question at all? My understanding is that
Linus also likes to keep Kconfig as simple as possible.

> I wholeheartedly agree with Vincent's decision.
> 
> One example case would be users of my can327 driver, as long as it is
> not upstream yet. They need to have RX_OFFLOAD built into their
> distribution's can_dev.ko, otherwise they will have no choice but to
> build their own kernel.

Upstream mentioning out-of-tree modules may have the opposite effect 
to what you intend :( Forgive my ignorance, what's the reason to keep
the driver out of tree?
