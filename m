Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10075847FE
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 00:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbiG1WLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 18:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbiG1WLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 18:11:23 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1EC78DC6
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 15:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LDqyog/eub7xSOGb/4JZwbkZ2yQA+0FvA48Dk0Q+fD4=; b=ASaiF4de4ElG33bKs8Ke3YvK3q
        pkzC6eoCCPWBCAeOOFxWe22W21ckIA/Z1PxTJG6wX8Uu0PFco3Hnu8MZ1vv+3YSO8EL2tykNE5Q+c
        kdScrLnqy3IZ5efodDVr7aNmFaBeHSvdUJw6T2lEmho0Wy0N22aweizhLhNu2+2hTOH8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oHBiu-00BqbI-Be; Fri, 29 Jul 2022 00:11:16 +0200
Date:   Fri, 29 Jul 2022 00:11:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     hayeswang@realtek.com, netdev@vger.kernel.org
Subject: Re: [RFC] r8152: pass through needs to be singular
Message-ID: <YuMJhAuZVVZtl9VZ@lunn.ch>
References: <20220728191851.30402-1-oneukum@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728191851.30402-1-oneukum@suse.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 09:18:51PM +0200, Oliver Neukum wrote:
> If multiple devices are connected only one of them
> is allowed to get the pass through MAC

Is that true? Ethernet switches often use the same MAC address on
multiple ports. It is not inherently broken to have the same MAC
address on multiple interfaces.

We also need to watch out for regressions. There could be users who do
have the same MAC address on multiple interfaces, and it works for
them. With this change it is a 50/50 chance they no longer get the MAC
address they expect, depending on probe order.

We know this implementation of pass through it very broken, but
unfortunately, it is there, and we have to follow the normal
regression rules, even if we really would like to throw it all out.

What exactly is your problem which you are trying to fix? 

     Andrew
