Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBDC664785
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 18:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234490AbjAJRgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 12:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbjAJRgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 12:36:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DFF1B1CD;
        Tue, 10 Jan 2023 09:36:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EAE8B818D4;
        Tue, 10 Jan 2023 17:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCAAC433EF;
        Tue, 10 Jan 2023 17:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673372165;
        bh=59ypGq2Qf4FeTGCBgsn+gwuksi0v6x1bCTZTGDdlhFE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q6wjreUvwBQ6qoS2ROe8EPtUJ2jdB9eMUYFE6hHA6mPMctqisbG8rjdlaYqOvERI6
         Ge3IWT34rfcjfIpvjZy3gbxzZOg/1TZ2CbFmkcniV4iU+I0+RmmlYVMFxpOglKs1FN
         TgDYdjtkOmlwTjqQfhM/9ljPBTUdq5OGczPmtqiNyHZmXq+uOLkOGvnHrk6emjeW2H
         wVg1lzRfIvY0wdzOUQCNoUSSN+CVhkxb5JveWm4AZTgu/Y69qQO2XUZa5wBbx7kdSq
         5g1miOf6RQiHSfIrVOGqa7uO//dhRoSn0hsRhr9WJFMK6SjNMi5KfpNjV9hyMU0/jL
         b94OrQ/6+AziQ==
Date:   Tue, 10 Jan 2023 09:36:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Wolfram Sang <wsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH RFC v2 0/2] Add I2C fwnode lookup/get interfaces
Message-ID: <20230110093604.15d7c113@kernel.org>
In-Reply-To: <Y71h7OF6ydo2A0dw@shell.armlinux.org.uk>
References: <Y6Az235wsnRWFYWA@shell.armlinux.org.uk>
        <Y7v/FWpjt1MFLafG@ninjato>
        <Y71h7OF6ydo2A0dw@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Jan 2023 13:02:36 +0000 Russell King (Oracle) wrote:
> On Mon, Jan 09, 2023 at 12:48:37PM +0100, Wolfram Sang wrote:
> > > This RFC series is intended for the next merge window, but we will need
> > > to decide how to merge it as it is split across two subsystems. These
> > > patches have been generated against the net-next, since patch 2 depends
> > > on a recently merged patch in that tree (which is now in mainline.)  
> > 
> > I'd prefer to apply it all to my I2C tree then. I can also provide an
> > immutable branch for net if that is helpful.  
> 
> If we go for the immutable branch, then patch 2 might as well be
> merged via the net tree, if net-next is willing to pull your
> immutable branch.
> 
> Dave? Jakub? Paolo? Do you have any preferences how you'd like to
> handle this?

No strong preference here. Immutable branch works.
Patch 2 will stick out in the diffstat for i2c so may indeed be better
to apply it to net-next only, then again perhaps Wolfram prefers to
have the user merged with the API? We're fine either way.
