Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7186746A5B0
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 20:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348433AbhLFTd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 14:33:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348416AbhLFTd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 14:33:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0FEC061746;
        Mon,  6 Dec 2021 11:29:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDF2FB81208;
        Mon,  6 Dec 2021 19:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF31C341C1;
        Mon,  6 Dec 2021 19:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638818995;
        bh=cfme0EXJt4xUtU6xUHbW7A5qSAq/bwtXhJkqUeEe9+w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BBdXDWzny5s26e1L+B8Z4WeCVf8TvxdthnP+bKU1i7hQsM5KiAg+26BYMdBXcRtUP
         5N9ZEP7grhqg+gvoTDzR9U+akIO67JjSDvNDxsfsLN2w3Jxr5LVqDVqC61rKA075dE
         tzTseYpBAG1q05MBj1fSe9EQcuVRTNJ70roHYuA2k0wxfKafyO3YOzMZAcbjowS+eK
         8MOxZikPiQTQLSn9U/xk8WgvXL5C3qLFhnUj2zCuk/IflW6X1eYizhCig3FC4MdYAH
         vH1s+NTNeI3GCI2mNOVi0uObBtx+ewWnRcHOg6kmBXjpFfLcbHPk3KBiK8owL3sBPM
         nZV2pPmtT89Iw==
Date:   Mon, 6 Dec 2021 11:29:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Michael Heimpold <michael.heimpold@in-tech.com>,
        jimmy.shen@vertexcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH RFC V2 3/4] net: introduce media selection
 IF_PORT_HOMEPLUG
Message-ID: <20211206112955.285b26b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1638623871-21805-4-git-send-email-stefan.wahren@i2se.com>
References: <1638623871-21805-1-git-send-email-stefan.wahren@i2se.com>
        <1638623871-21805-4-git-send-email-stefan.wahren@i2se.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  4 Dec 2021 14:17:50 +0100 Stefan Wahren wrote:
> Introduce a new media selection dedicated for HomePlug powerline
> communication. This allows us to use the proper if_port setting in
> HomePlug drivers.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>

I _think_ the IF_PORT API is an very ancient (Linux 2.2) way of
switching ports on early Ethernet cards. Isn't it? It predates
ethtool and all the modern interfaces. Quick grep seems to indicate
it's accessed only for old HW as well.

Do you have a use case for setting it?

> diff --git a/include/uapi/linux/netdevice.h b/include/uapi/linux/netdevice.h
> index f3770c5..0f1f536 100644
> --- a/include/uapi/linux/netdevice.h
> +++ b/include/uapi/linux/netdevice.h
> @@ -53,7 +53,8 @@ enum {
>          IF_PORT_AUI,
>          IF_PORT_100BASET,
>          IF_PORT_100BASETX,
> -        IF_PORT_100BASEFX
> +        IF_PORT_100BASEFX,
> +        IF_PORT_HOMEPLUG
>  };
>  
>  /* hardware address assignment types */

