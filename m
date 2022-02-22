Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 513914C056F
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 00:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbiBVXm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 18:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236317AbiBVXmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 18:42:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFA0647C
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 15:42:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21560B81D5E
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 23:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B233C340E8;
        Tue, 22 Feb 2022 23:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645573346;
        bh=mgwwJFvz2z639DD1TJYEnwDmR7XLMs4r9tuO2rq+3Ts=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pjXjlh8+7XUVaYSPk1XaQPMGhGc312x/7SYuaRDAikwby0qYFb69PDgPLYAILsEzk
         7jWdSzu4QhIs8suSjAQunvGXPP+d1qfyDOv6my9lzGE1IN2cFJj1f0ci4LBUdwOpQx
         dZ285zL3D2psxqR1Wk7qjfIGLkO3iojMmGlZg2VxejsCZzRjmQyyfs1Lt4gSOhJJon
         hpV0yz/USs1L5Gtb5jwWrc7UyjTFLfJ7dnSyG3CSDdJ/ZBVReseLuTGHN7/JINw2/z
         xigKu0peR8cTEojlsOEwqIIV4jHZxHiqxoqh6LcNUwHbGenIyv+SmA5m/Dzr4F+HCM
         nQzRSM2pfl9ew==
Date:   Tue, 22 Feb 2022 15:42:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Peter Robinson <pbrobinson@gmail.com>
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>
Subject: Re: [PATCH] net: bcmgenet: Return not supported if we don't have a
 WoL IRQ
Message-ID: <20220222154225.41a6a2d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220222095348.2926536-1-pbrobinson@gmail.com>
References: <20220222095348.2926536-1-pbrobinson@gmail.com>
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

On Tue, 22 Feb 2022 09:53:48 +0000 Peter Robinson wrote:
> +	/* We need a WoL IRQ to enable support, not all HW has one setup */
> +	if (priv->wol_irq <= 0)
> +		return -ENOTSUPP;

EOPNOTSUPP, ignore the existing code in this function and trust
checkpatch's warning. ENOTSUPP should be avoided.
