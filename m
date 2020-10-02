Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD65F28119B
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 13:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387768AbgJBLyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 07:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgJBLyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 07:54:01 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57211C0613D0;
        Fri,  2 Oct 2020 04:54:01 -0700 (PDT)
Date:   Fri, 2 Oct 2020 13:53:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601639639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QmDCCE/DzrLFNkg9IzeC2MW91V1ZMgH/Seb/D4bvH0c=;
        b=sV9gXxmVESanAKPHJVHnQajLDipL+1e8MFp8k4/jnTC4krBPmbF7pzv58brvhg4VTLT4g+
        GIgWcoqe7q7AS9eXxfY4xvu67vpN1sjqxDWAygWhd9HrAuf5y2C5ZETyrwBwC6GYEFQciP
        6CMfSiLDFaKvk8s2GUKt3GbOgyni4j63qao4XX335IeCynf0vfln3XTKVDT4H8JR5VaqLV
        apL9aSy3qbDDXc3a6+Hf8jbclx+37xxjFOtuYFFpY0sL6lM/k77d0Ll+PTGs6bWVuKKlbl
        Yyeqm69WLyxmXVgZDFAUbRQsvJxNuDMCzlbeJp7G2muXTZtE/oM5J+qtCaC34g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601639639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QmDCCE/DzrLFNkg9IzeC2MW91V1ZMgH/Seb/D4bvH0c=;
        b=hEOOYSzQnR713OvbKYPQ1yQt4SMmV258pRx8lH4ACi+Uk9TbwGfuO8eGB7PEQEUUChtbVt
        DkQ9rEurS4FPV0BQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] Status of orinoco_usb
Message-ID: <20201002115358.6aqemcn5vqc5yqtw@linutronix.de>
References: <20201002103517.fhsi5gaepzbzo2s4@linutronix.de>
 <20201002113725.GB3292884@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201002113725.GB3292884@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-02 13:37:25 [+0200], Greg Kroah-Hartman wrote:
> > Is it possible to end up here in softirq context or is this a relic?
> 
> I think it's a relic of where USB host controllers completed their urbs
> in hard-irq mode.  The BH/tasklet change is a pretty recent change.

But the BH thingy for HCDs went in v3.12 for EHCI. XHCI was v5.5. My
guess would be that people using orinoco USB are on EHCI :)

> > Should it be removed?
> 
> We can move it out to drivers/staging/ and then drop it to see if anyone
> complains that they have the device and is willing to test any changes.

Not sure moving is easy since it depends on other files in that folder.
USB is one interface next to PCI for instance. Unless you meant to move
the whole driver including all interfaces.
I was suggesting to remove the USB bits.

> thanks,
> 
> greg k-h

Sebastian
