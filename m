Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342115E6CA9
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 22:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiIVUFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 16:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiIVUF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 16:05:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A47AA8CC4;
        Thu, 22 Sep 2022 13:05:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3888B80DE4;
        Thu, 22 Sep 2022 20:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F50BC433D6;
        Thu, 22 Sep 2022 20:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663877126;
        bh=MGbVyhewQ7VxXznFUjRgEqvL1s+44pP4F3IRDbTf/5c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KrfxTNyQFtRJ78gmGC4KkzSEDtm7tsC9er9OGUCgIUGNRPtNzAhpJ6xwUNf11kdR3
         dNFHXLxgc4uXKHFJncMp8EPpm6tlMHQ34aDPGWGx1XZ1kipq5xnEvWE+Hsx81OQ2jk
         I+PdplmgO8sm1vs0L9hBwKNRPnjXBYCyReuRh7a4meT9/tifiQ6nAOJy+v+8SHnx4r
         wx6i6stj4ZjAPRr3XuK6J7EBMZwt/J2f8mxXncXsNb3HDuMFFcKSt2i0hGmqWxMXMv
         jyHDeBApQx+mwDUD+KHiptmZJSYPAD6XnZtzXYNBTY0nDsOPLlHOZTjqpaNqkaBbeY
         aiWwttVG45EzA==
Date:   Thu, 22 Sep 2022 13:05:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, MPTCP Upstream <mptcp@lists.linux.dev>
Subject: Re: [PATCH net 2/3] can: gs_usb: gs_can_open(): fix race
 dev->can.state condition
Message-ID: <20220922130525.6b1a1104@kernel.org>
In-Reply-To: <20220922082338.a6mbf2bbtznr3lvz@pengutronix.de>
References: <20220921083609.419768-1-mkl@pengutronix.de>
        <20220921083609.419768-3-mkl@pengutronix.de>
        <84f45a7d-92b6-4dc5-d7a1-072152fab6ff@tessares.net>
        <20220922082338.a6mbf2bbtznr3lvz@pengutronix.de>
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

On Thu, 22 Sep 2022 10:23:38 +0200 Marc Kleine-Budde wrote:
> On 22.09.2022 10:04:55, Matthieu Baerts wrote:
> > FYI, we got a small conflict when merging -net in net-next in the MPTCP
> > tree due to this patch applied in -net:
> > 
> >   5440428b3da6 ("can: gs_usb: gs_can_open(): fix race dev->can.state
> > condition")
> > 
> > and this one from net-next:
> > 
> >   45dfa45f52e6 ("can: gs_usb: add RX and TX hardware timestamp support")
> > 
> > The conflict has been resolved on our side[1] and the resolution we
> > suggest is attached to this email.  

Thanks for the resolution! If you happen to remember perhaps throw
"manual merge" into the subject. That's what I search my inbox for
when merging, it will allow us to be even more lazy :)
