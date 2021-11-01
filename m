Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4FF441403
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 08:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhKAHO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 03:14:58 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56425 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231145AbhKAHOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 03:14:55 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 16EB55C00EF;
        Mon,  1 Nov 2021 03:12:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 01 Nov 2021 03:12:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4fX8NR
        AOk+O/aWbcdEs/lDF3SUCga+DQgKNNX9Asy+k=; b=WrD29iuvdGgIiCLcZrAV22
        DZDvpymUWj3uUjONZw76XYgiMjrl+x/Qx0kIUGsdHEJQWamoN8ExtbCekst77wwt
        pLQ297XkWE2V64B7dBtzmHvl32gGEp997CJwaim9OCIAFtp9kcsf4KqWpw417+/3
        e6HPDhdt4s0WMtaBpdn8RCjVZua9sj6B6y45CArJGsfrFwmB3bGuSFPjJE65ua7V
        1HLHztjE8aco98+u6ZV8chRp5GGSToeoUyN3JzRNCzPY53FWym9XMBRe7+WAPAbB
        IKt5jmdgsJ3M+ICZBq0hYXthqXNXVDPzSyBlihostsrVbwLHab9/6bYVKW7cE5mA
        ==
X-ME-Sender: <xms:VZN_YboCKaM3zlGwNguBgU_eaSEmY0qllreYhZuY6rd1KLOf-4Lk8Q>
    <xme:VZN_YVphV2j_zWUHw9HFcMxPJbdZPRGJQvCpGlhGzSbtf3ZxyM242KAamjl4fghEg
    OAM42M05EnwSNY>
X-ME-Received: <xmr:VZN_YYOnA7Ed6dO1lFAwukGJtSEmhBj8ZzV_C0qQZgpsv-4W29ysm47G-VHDFw2LHDUbll_6wcbXykqkek_GQE89g8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdehuddguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:VZN_Ye5wtfKGXQu2IvehavcEMlt4goo4272KeS1Ae8PlXDrk2pdxcA>
    <xmx:VZN_Ya6tYhahwndJD7eaKm-NtnJpXfSF1JEFxWMI-hifTaEbMBMNNA>
    <xmx:VZN_YWjjXLGmryl1Fs7_eTS4Sz9dxjt_wpw-v5brRt-rGNLMkCMeLg>
    <xmx:VpN_YcRuI55ZUi95a3x5K9DfDwBQLt5SjlAqER5P2CpqIE00k0p0ZQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 Nov 2021 03:12:21 -0400 (EDT)
Date:   Mon, 1 Nov 2021 09:12:17 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Leon Romanovsky <leon@kernel.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Leon Romanovsky <leonro@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <YX+TUX0agfjMD0Ft@shredder>
References: <9716f9a13e217a0a163b745b6e92e02d40973d2c.1635701665.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9716f9a13e217a0a163b745b6e92e02d40973d2c.1635701665.git.leonro@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 31, 2021 at 07:35:56PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Devlink reload was implemented as a special command which does _SET_
> operation, but doesn't take devlink->lock, while recursive devlink
> calls that were part of .reload_up()/.reload_down() sequence took it.
> 
> This fragile flow was possible due to holding a big devlink lock
> (devlink_mutex), which effectively stopped all devlink activities,
> even unrelated to reloaded devlink.
> 
> So let's make sure that devlink reload behaves as other commands and
> use special nested locking primitives with a depth of 1. Such change
> opens us to a venue of removing devlink_mutex completely, while keeping
> devlink locking complexity in devlink.c.

Jakub/Dave, I will be mostly unavailable until later this week, but I
have applied this patch to our queue and can report testing results
tomorrow. I would appreciate it if you could hold off on applying it
until then.

Thanks
