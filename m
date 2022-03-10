Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE18F4D5189
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 20:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245617AbiCJSxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 13:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbiCJSxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 13:53:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEB89E9CF;
        Thu, 10 Mar 2022 10:52:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5548760A5B;
        Thu, 10 Mar 2022 18:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302F6C340E8;
        Thu, 10 Mar 2022 18:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646938354;
        bh=y/1iJANFpJBZAClEvTFM6+CMClorptbc0C5A7qFstWc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pscF9adyqaPKmci8/7e5yo1QQeQ9HTjHp0ilIspfkBQcCVzxMg/uKc3eBU3yXKZvD
         LmuqzWbkRhxOsfqpYyaGOUzqk3Vp2S5fJxA26Ft7s86IR+NRt2JXwTfHBYQFaiXN6P
         eAbQ+SfQwid+VCZU7sw452sM2mZJdJEX6aX4mQqcfqutibJiWJ0sNvnkjVJMzPtp9q
         jHcMwQ5U3qJ5Ebjj5NECQ8C7wnycBoxkbUOo44RQ4FhFaa8mHGsAVgFn19eAzvTb3j
         3QOtcPazvskfA+tC6xTzqT2mBkhSawcqUHZ37dsoqsvjC/xp10xjkwneIGA4Kid0hZ
         /f3Y8LibrMN+Q==
Date:   Thu, 10 Mar 2022 10:52:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Manish Chopra <manishc@marvell.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "it+netdev@molgen.mpg.de" <it+netdev@molgen.mpg.de>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: [EXT] Re: [PATCH v2 net-next 1/2] bnx2x: Utilize firmware
 7.13.21.0
Message-ID: <20220310105232.66f0a429@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAHk-=whXCf43ieh79fujcF=u3Ow1byRvWp+Lt5+v3vumA+V0yA@mail.gmail.com>
References: <20211217165552.746-1-manishc@marvell.com>
        <ea05bcab-fe72-4bc2-3337-460888b2c44e@molgen.mpg.de>
        <BY3PR18MB46129282EBA1F699583134A4AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
        <e884cf16-3f98-e9a7-ce96-9028592246cc@molgen.mpg.de>
        <BY3PR18MB4612BC158A048053BAC7A30EAB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
        <CAHk-=wjN22EeVLviARu=amf1+422U2iswCC6cz7cN8h+S9=-Jg@mail.gmail.com>
        <BY3PR18MB4612C2FFE05879E30BAD91D7AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
        <CAHk-=whXCf43ieh79fujcF=u3Ow1byRvWp+Lt5+v3vumA+V0yA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Mar 2022 14:18:23 -0800 Linus Torvalds wrote:
> On Wed, Mar 9, 2022 at 11:46 AM Manish Chopra <manishc@marvell.com> wrote:
> >
> > This has not changed anything functionally from driver/device perspective, FW is still being loaded only when device is opened.
> > bnx2x_init_firmware() [I guess, perhaps the name is misleading] just request_firmware() to prepare the metadata to be used when device will be opened.  
> 
> So how do you explain the report by Paul Menzel that things used to
> work and no longer work now?
> 
> You can't do request_firmware() early. When you actually then push the
> firmware to the device is immaterial - but request_firmware() has to
> be done after the system is up and running.

Alright, I don't see a revert in my inbox, so let me double check.

Linus, is my understanding correct that our PR today should revert
the patches in question [1]? Or just drop them from stable for now, 
and give Manish and team a week or two to figure out a fix?

Manish, assuming it's the former - would you be able to provide 
a revert within a couple of hours (and I mean  "couple" in the 
British sense of roughly two)?

[1] patches in question:
 e13ad1443684 ("bnx2x: fix driver load from initrd")
 802d4d207e75 ("bnx2x: Invalidate fastpath HSI version for VFs")
 b7a49f73059f ("bnx2x: Utilize firmware 7.13.21.0")
