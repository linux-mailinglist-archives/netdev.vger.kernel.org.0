Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69CA64B55E1
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 17:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbiBNQRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 11:17:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiBNQRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 11:17:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6AEEC73
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 08:16:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99D00B811D8
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 16:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E36C340E9;
        Mon, 14 Feb 2022 16:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644855415;
        bh=XTjNIPOR+Txz2UKpOIYpNr0gJRW2vwZZSf/2JxXHO7M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G5do9OA/X7QgIyh1pBSbtOSDMkepgB1TPt13KqgfHNo80LYieazAAOMFmYoJzsBJJ
         sLIwXlDabzx/DUJvT6HyqUcpNQ8JQgWfxclxnBeqEd92j8YbWmLAYzZHnJFBFhfFhs
         r1RMZRQ/4Nt+LbWgPbqNHnfvvELdaVELGb9VlS+oTK9/SXfGh3ZqAK6NIHzo4tk4bT
         RoqWyGndoWGlFk6wb9RVz1SgFPbEJT7iopqxhfa5btBqv/8zA4dBW3OWwlSXjGwuz9
         A/WLh0WGCXMRpIEvc4X3kILZiEB8wZxq76oeeYF5FlLtr6tFj4gudc+1AvwezIPBI6
         8QmwluGiVJ9Bg==
Date:   Mon, 14 Feb 2022 08:16:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/5] Add support for locked bridge ports
 (for 802.1X)
Message-ID: <20220214081654.56694f81@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <86h791hljv.fsf@gmail.com>
References: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
        <20220211145957.5680d99b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <86h791hljv.fsf@gmail.com>
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

On Mon, 14 Feb 2022 09:58:12 +0100 Hans Schultz wrote:
> On fre, feb 11, 2022 at 14:59, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed,  9 Feb 2022 14:05:32 +0100 Hans Schultz wrote:  
> >> The most common approach is to use the IEEE 802.1X protocol to take
> >> care of the authorization of allowed users to gain access by opening
> >> for the source address of the authorized host.  
> >
> > noob question - this is 802.1x without crypto? I'm trying to understand
> > the system you're describing.  
> 
> No, user space will take care of authentication, f.ex. hostapd, so in a
> typical setup the supplicant and the authentication daemon will take
> care of all crypto related stuff in their communication.
> So the authentication daemon will open the port for the authenticated
> supplicant.

To be clear - I'm talking about wire crypto after all the communication
with the control plane and after the connection the port is opened. Not
crypto in whatever authentication method gets used. Does the device get
the keys somehow from user space?

> See the cover letter.

Which part of it?

