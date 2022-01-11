Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BD648B2DF
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343819AbiAKRGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343812AbiAKRGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:06:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80B3C061756;
        Tue, 11 Jan 2022 09:06:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66098B81C0E;
        Tue, 11 Jan 2022 17:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC54C36AFF;
        Tue, 11 Jan 2022 17:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641920810;
        bh=U8ceB9E7WQfF4lwWpFA/N8znZp7a8I1RSXD2sgzVbFU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OT1VxB5X9Ad+NfxrxNedZjTKUQso9H0g4m7x1y5U9rQ0ge4hiHf2h7tmGGgqUjeu4
         vqXdkIkVEkE72XNl0PZLHAjesp3nnH4zrnroY+1UymT6C0R8R5bWHbXavoLcyj62H6
         KKuwHSHix2BhMPUfa7qJ3DgH1k+xe3Zzef0nNYlKIRgKsJxuZgfUCC9HghjsRwVdmw
         OdxOeVOXUOgAboqKC3zZ6FHF+tFLfxNJQ3WXpdvjuFmlojduArslQOiUc8XBk6+pF0
         sG06Fv72fJR1EE7puz74jsRveKkuSMUOXDMI7hYXKGyrk1ecGVxOsjv6HlPgyFYfR0
         +uY5sgk0Wrlbg==
Date:   Tue, 11 Jan 2022 09:06:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Limonciello, Mario" <mario.limonciello@amd.com>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>,
        Aaron Ma <aaron.ma@canonical.com>, henning.schild@siemens.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Message-ID: <20220111090648.511e95e8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <2b779fef-459f-79bb-4005-db4fd3fd057f@amd.com>
References: <20220105151427.8373-1-aaron.ma@canonical.com>
        <YdXVoNFB/Asq6bc/@lunn.ch>
        <bb6d8bc4-abee-8536-ca5b-bac11d1ecd53@suse.com>
        <YdYbZne6pBZzxSxA@lunn.ch>
        <CAAd53p52uGFjbiuOWAA-1dN7mTqQ0KFe9PxWvPL+fjfQb9K5vQ@mail.gmail.com>
        <YdbuXbtc64+Knbhm@lunn.ch>
        <CAAd53p5YnQZ0fDiwwo-q3bNMVFTJSMLcdkUuH-7=OSaRrW954Q@mail.gmail.com>
        <20220106183145.54b057c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAAd53p7egh8G=fPMcua_FTHrA3HA6Dp85FqVhvcSbuO2y8Xz9A@mail.gmail.com>
        <20220110085110.3902b6d4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAAd53p5mSq_bZdsZ=-RweiVLgAYU5+=Uje7TmYtAbBzZ7XCPUA@mail.gmail.com>
        <ec2aaeb0-995e-0259-7eca-892d0c878e19@amd.com>
        <20220111082653.02050070@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <3f258c23-c844-7b48-fffb-2fbf5d6d7475@amd.com>
        <20220111084348.7e897af9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <2b779fef-459f-79bb-4005-db4fd3fd057f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jan 2022 10:54:50 -0600 Limonciello, Mario wrote:
> > Also knowing how those OSes handle the new docks which don't have
> > unique device IDs would obviously be great..  
> 
> I'm sorry, can you give me some more context on this?  What unique 
> device IDs?

We used to match the NICs based on their device ID. The USB NICs
present in docks had lenovo as manufacturer and a unique device ID.
Now reportedly the new docks are using generic realtek IDs so we have
no way to differentiate "blessed" dock NICs from random USB dongles,
and inheriting the address to all devices with the generic relatek IDs
breaks setups with multiple dongles, e.g. Henning's setup.

If we know of a fuse that can be read on new docks that'd put us back
in more comfortable position. If we need to execute random heuristics
to find the "right NIC" we'd much rather have udev or NetworkManager 
or some other user space do that according to whatever policy it
chooses.
