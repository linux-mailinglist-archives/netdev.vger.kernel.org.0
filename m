Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC123D6989
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 00:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbhGZVs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 17:48:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233348AbhGZVs6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 17:48:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B88EA60F41;
        Mon, 26 Jul 2021 22:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627338566;
        bh=QdrJaVGMLrQC8oSbYCjjPNiCiosiPmFNLxtHtUqmaPQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OW3YVfbAZ8jlCUJhYUa8woVqtVQdCoLgXw0kFr7vQmnK6QuUtXqNOPatEJ8D9lJc+
         G3DADlU9uLMu5jf7tvClhgfqBwSRJ2Rc86FPs5QRf85Pv6MDTbVyDWKqAXHfImZe26
         5mFWRPsg+bbk5HHd27XGWBsrE1+WSb4/J/wTyv+hqjwXUCNO9oqXv+O84rFrfeLK3D
         uEqmPEBZ8LjJjpfbkxbLDtiWIlL5N7Oap/Hmlj3U5eSukvjLZR+lQIwQWXGJChNYwN
         vMz/cOsqfBKl8bHbFlj4tb0Y3ruBkUypUnc1x3DSG2o2Qlsa7uYYwsTBq6TIDmad8/
         TvVlOaINv5dHA==
Message-ID: <3bc237a32a1e823739e4e15df9758171c4051a66.camel@kernel.org>
Subject: Re: [PATCH v2 1/2] net: ethtool: Support setting ntuple rule count
From:   Saeed Mahameed <saeed@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>, Sunil Goutham <sgoutham@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Date:   Mon, 26 Jul 2021 15:29:24 -0700
In-Reply-To: <YPxMlaxjT0vSeqZg@lunn.ch>
References: <1627064206-16032-1-git-send-email-sgoutham@marvell.com>
         <1627064206-16032-2-git-send-email-sgoutham@marvell.com>
         <YPxMlaxjT0vSeqZg@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-07-24 at 19:23 +0200, Andrew Lunn wrote:
> On Fri, Jul 23, 2021 at 11:46:45PM +0530, Sunil Goutham wrote:
> > Some NICs share resources like packet filters across
> > multiple interfaces they support. From HW point of view
> > it is possible to use all filters for a single interface.
> > Currently ethtool doesn't support modifying filter count so
> > that user can allocate more filters to a interface and less
> > to others. This patch adds ETHTOOL_SRXCLSRLCNT ioctl command
> > for modifying filter count.
> > 
> > example command:
> > ./ethtool -U eth0 rule-count 256
> 
> How can use see what the current usage is? How many in total you have
> available?  What the current split is between the interfaces?
> 

There is no point of adding this ethtool interface if the orchestration
tool already knows the "rule-count" in advance, it's just redundant to
have a user managed limiting device in ethtool.

> You say:
> 
>    * Jakub suggested if devlink-resource can be used for this.
> 
> devlink-resource provides you a standardised mechanism to answer the
> questions i just asked. So i would have to agree with Jakub.
> 

+1, devlink is your address when a single device is shared across
multiple interfaces.

>           Andrew


