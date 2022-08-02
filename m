Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE94587D1F
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 15:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235854AbiHBNbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 09:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233142AbiHBNbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 09:31:42 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE61E1707C
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 06:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=94Klh7ZbIlEablWPYAvdogA44/E1XeUWPv6lShgFnHs=; b=eB8eO756asBCbwna9uKnNexwsS
        3V3J1JWZMtuDXNk+CSBEsv7pG2poZNfee4MXreFRMsnl3U4j+A8ySF9ew8DWZlYUZPr2RrofF3J7p
        9dJ38dSRtZrLHWA1OZO29wf8f68tG52EoFI3FhxJOPxb6LDXlHDpYDZq/9GX0z/4F7GU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oIrzg-00CGCA-NR; Tue, 02 Aug 2022 15:31:32 +0200
Date:   Tue, 2 Aug 2022 15:31:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     hayeswang@realtek.com, netdev@vger.kernel.org
Subject: Re: [RFC] r8152: pass through needs to be singular
Message-ID: <YuknNESeYxCjcPrD@lunn.ch>
References: <20220728191851.30402-1-oneukum@suse.com>
 <YuMJhAuZVVZtl9VZ@lunn.ch>
 <34f7cb15-91e8-e92c-7dcd-f5b28724df92@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34f7cb15-91e8-e92c-7dcd-f5b28724df92@suse.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> True. Nevertheless, do we really want to say that we dislike a design
> so much that we are not fixing bugs?

I'm not sure we can fix it. Part of that long thread about why this
whole concept is broken is that we have no idea which interface is the
one which should give the MAC address to. If we change it to only give
out the MAC address once, all we really do is change it from one bug
to another bug.

> > What exactly is your problem which you are trying to fix? 
> Adressing the comment Hayes made when reset_resume() was fixed
> from a deadlock, that it still assigns wrong MACs. I feel that
> before I fix keeping the correct address I better make sure the
> MAC is sane in the first place.

I would say that reset_resume() should restore whatever the MAC
address was before the suspend. It does not matter if the MAC address
is not unique. As far as i know, the kernel never prevents the user
assigning the same MAC address on multiple interfaces via ip link set.
So it could actually be a user choice.

   Andrew
