Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5C152AD29
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 22:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353070AbiEQU6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 16:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241513AbiEQU6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 16:58:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6504B51E66;
        Tue, 17 May 2022 13:58:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED02B61717;
        Tue, 17 May 2022 20:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92B5C385B8;
        Tue, 17 May 2022 20:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652821118;
        bh=hk8wEywVJmfG82zsYPnxL52HFBZTcO/cUlqMVKyBPi4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sqj24rsApE0TJ0U5E3nf6VNL0L/hLBs2UcaDGbyM4ljPEg/RFHnOWqFthu5E/ovwA
         QbiS9ODJVY7kRGpEFyk9ePkW/GqCMxyWT/jGCfhZjB9BZVUJSYXWXx2hFPdrieyzwU
         3ErbcTokULnq2qn6NES38rFPRzVaFeUrFLQsSgSuXdjt7sV+8IHl/mnE3PAgtq2GKz
         kMCIBH0wElXRNv9tggAbtRS10Wf5HUTEAvFd9e36Ra9tT1wFU0ARJRqaEstmK6vLTD
         MEbfJ1lw3maaFDHG5wmC9BnWyLkGRWrv3yG++N+J+ijHVjqddC0qrxw/a0EmbIvlDO
         B038KW11jZ/qg==
Date:   Tue, 17 May 2022 13:58:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v2 2/5] net: dsa: add out-of-band tagging
 protocol
Message-ID: <20220517135836.4455e77b@kernel.org>
In-Reply-To: <20220517085355.4fab54b3@pc-20.home>
References: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
        <20220514150656.122108-3-maxime.chevallier@bootlin.com>
        <20220516122048.70e238a2@kernel.org>
        <20220517085355.4fab54b3@pc-20.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 May 2022 08:53:55 +0200 Maxime Chevallier wrote:
> > This must had been asked on v1 but there's no trace of it in the
> > current submission afaict...  
> 
> No you're correct, this wasn't explained.
> 
> > If the tag is passed in the descriptor how is this not a pure
> > switchdev driver? The explanation must be preserved somehow.  
> 
> The main reason is that although the MAC and switch are rightly coupled
> on that platform, the switch is actually a QC8K that can live on it's
> own, as an external switch. Here, it's just a slightly modified version
> of this IP.
> 
> The same goes for the MAC IP, but so far we don't support any other
> platform that have the MAC as a standalone controller. As far as we can
> tell, platforms that have this MAC also include a QCA8K, but the
> datasheet also mentions other modes (like outputing RGMII).

Got it, thanks! Please weave this justification more explicitly into 
the cover letter.

> Is this valid to have it as a standalone ethernet driver in that
> situation ?

Quite possibly.. I won't pretend I've looked at the code, I defer 
to the reviewers :)
