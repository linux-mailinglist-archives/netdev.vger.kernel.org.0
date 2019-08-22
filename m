Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF2F299496
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 15:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389012AbfHVNJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 09:09:45 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56159 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731205AbfHVNJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 09:09:45 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0403C2012F;
        Thu, 22 Aug 2019 09:09:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 22 Aug 2019 09:09:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=ABWs19ACjqr2jGSfb/bYO8WtT2S
        Manh6xOhvmZdjegU=; b=ptOi7tqrIhbpnMUub/rTLLdvN7m/hDuusG42sXsNDNN
        YjUEBzEtJNDPlVSgPh6hp+/g3c8pEefFz6ZpGfN3g08NWWZxEWCqunKjMbVA6hbp
        1hb9MpDwzJMnwX3+h5jAVRWXK5ZmO5pBFpblORlzDKYFtSSYrorYU5RKYC64bVTG
        DEiX6NnWfsnbCxMqq99atrjqDh5fHxffd/ureZcKYQoNfNeuogiwKZuT+jE2L8T6
        dhnCv/ZEJJQH+YD/WsUxywBcsnAtxjYDewewJ2fOxqPPwOCgq+eDjHmVE++0f8dv
        igKY/J9pmeZcWObJjc9GxEHZ2/m3g/Jcvj0XhdF6Jtg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ABWs19
        ACjqr2jGSfb/bYO8WtT2SManh6xOhvmZdjegU=; b=uCZsMSY58FlVWLwG0gFVgV
        9Rdjr+6Q5NQFWfTmpvlF8PD/GNo/Oejb5b0gBRUsGNYyzJLOdL01GdEBiE0KHvE3
        QOsEI150vo91yYqOo2Tv+eWm6xL+HUkDPTvd3QVjBhL/ICKEMW9ELXkn8BLwNM/T
        5lBPW+WiW0E32bYTeP+fCSq8oqznf1yOqjAYvHlaH6M+BgzghEV38hXDusCD7qa0
        OiPLLjvppZ1A1Z/oDxMTz29EtfX4A5IKURIqdETZaDuAm8mMZdZcKD0cE37tBs9D
        8MtHu0H1QKSxkS6OHXBRDp1adMyvNP2BwvQGAvNeVxNebeD0VflsjH/eYAv+e95A
        ==
X-ME-Sender: <xms:F5ReXWJFwRbKAwCbWDUa5Lg3vpFZAnuJ2FiXdceUIAuF-HqjxUzWZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudegiedgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeduvddrudeiiedrudejge
    drheenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:F5ReXUSBLdN1Mc47ojV3RACI10j4zcmoxvv8jOdUxa4hgOBilSyx0Q>
    <xmx:F5ReXZZyjulrroT2QWgz2eW5ecTLsKHk0IUQ-_OPkQLQZbM7pMt4uQ>
    <xmx:F5ReXZOcPHM6JJIqvtFpLPioYuL8e3_HGhAsXNJAervbdrmXSTXYqA>
    <xmx:F5ReXVgZujX-ug2RXPcYuCJRPvR6-PUavQnHaF3ayUL8IMGsR64XIA>
Received: from localhost (unknown [12.166.174.5])
        by mail.messagingengine.com (Postfix) with ESMTPA id 076058006F;
        Thu, 22 Aug 2019 09:09:42 -0400 (EDT)
Date:   Thu, 22 Aug 2019 06:09:41 -0700
From:   Greg KH <greg@kroah.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     stable@vger.kernel.org, vakul.garg@nxp.com, netdev@vger.kernel.org,
        Kristian Evensen <kristian.evensen@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 4.14.y stable] xfrm: policy: remove pcpu policy cache
Message-ID: <20190822130941.GA15754@kroah.com>
References: <DB7PR04MB46208495C3ADCCD58B1131C88BA50@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190822112109.13269-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822112109.13269-1-fw@strlen.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 01:21:09PM +0200, Florian Westphal wrote:
> commit e4db5b61c572475bbbcf63e3c8a2606bfccf2c9d upstream.
> 
> Kristian Evensen says:
>   In a project I am involved in, we are running ipsec (Strongswan) on
>   different mt7621-based routers. Each router is configured as an
>   initiator and has around ~30 tunnels to different responders (running
>   on misc. devices). Before the flow cache was removed (kernel 4.9), we
>   got a combined throughput of around 70Mbit/s for all tunnels on one
>   router. However, we recently switched to kernel 4.14 (4.14.48), and
>   the total throughput is somewhere around 57Mbit/s (best-case). I.e., a
>   drop of around 20%. Reverting the flow cache removal restores, as
>   expected, performance levels to that of kernel 4.9.
> 
> When pcpu xdst exists, it has to be validated first before it can be
> used.
> 
> A negative hit thus increases cost vs. no-cache.
> 
> As number of tunnels increases, hit rate decreases so this pcpu caching
> isn't a viable strategy.
> 
> Furthermore, the xdst cache also needs to run with BH off, so when
> removing this the bh disable/enable pairs can be removed too.
> 
> Kristian tested a 4.14.y backport of this change and reported
> increased performance:
> 
>   In our tests, the throughput reduction has been reduced from around -20%
>   to -5%. We also see that the overall throughput is independent of the
>   number of tunnels, while before the throughput was reduced as the number
>   of tunnels increased.
> 
> Reported-by: Kristian Evensen <kristian.evensen@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> ---
>  Vakul Garg reports traffic going via ipsec tunnels will cause the kernel
>  to spin in an infinite loop due to xfrm policy reference count
>  overflowing and becoming 0.
>  The refcount leak is in the pcpu cache.  Instead of fixing this, just
>  remove the pcpu cache -- its not present in any other stable release.
>  Vakul reported that this patch fixes the problem.
> 
>  There are no major deviations from the upstream revert; conflicts
>  were only due to context.

Now queued up, does 4.9.y also need this?

thanks,

greg k-h
