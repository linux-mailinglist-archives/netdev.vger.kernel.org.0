Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B7A1A6247
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 06:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbgDME4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 00:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728739AbgDME4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 00:56:00 -0400
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556E9C0A3BE0;
        Sun, 12 Apr 2020 21:56:00 -0700 (PDT)
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A3D9206A1;
        Mon, 13 Apr 2020 04:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586753759;
        bh=ntRtM/0XRAKESl58dPv8YFdKb0z/yYug4RvgbiDPSAY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h24HO9c4n/g0j4mIV/Nln3QBeWywG0Xui2ZucpyyvlaRblXFDymGGT5dtcV4wgsqO
         KSHEvuR1ApPvx70Wz2xIsy44vCBQlP3Z+WTzHL7hVFO9zO/B7sspw1bsbv7VTQmLAk
         MeGiBuAxN903NVm9i0yn2OyCcdU/tQr1zNM20nXs=
Date:   Mon, 13 Apr 2020 07:55:55 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     bp@alien8.de, kuba@kernel.org, thomas.lendacky@amd.com,
        keyur@os.amperecomputing.com, pcnet32@frontier.com,
        vfalico@gmail.com, j.vosburgh@gmail.com, linux-acenic@sunsite.dk,
        mripard@kernel.org, heiko@sntech.de, mark.einon@gmail.com,
        chris.snook@gmail.com, linux-rockchip@lists.infradead.org,
        iyappan@os.amperecomputing.com, irusskikh@marvell.com,
        dave@thedillows.org, netanel@amazon.com,
        quan@os.amperecomputing.com, jcliburn@gmail.com,
        LinoSanfilippo@gmx.de, linux-arm-kernel@lists.infradead.org,
        andreas@gaisler.com, andy@greyhouse.net, netdev@vger.kernel.org,
        thor.thayer@linux.intel.com, linux-kernel@vger.kernel.org,
        ionut@badula.org, akiyano@amazon.com, jes@trained-monkey.org,
        nios2-dev@lists.rocketboards.org, wens@csie.org
Subject: Re: [PATCH] net/3com/3c515: Fix MODULE_ARCH_VERMAGIC redefinition
Message-ID: <20200413045555.GE334007@unreal>
References: <20200224085311.460338-1-leon@kernel.org>
 <20200224085311.460338-4-leon@kernel.org>
 <20200411155623.GA22175@zn.tnic>
 <20200412.210341.1711540878857604145.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200412.210341.1711540878857604145.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 12, 2020 at 09:03:41PM -0700, David Miller wrote:
> From: Borislav Petkov <bp@alien8.de>
> Date: Sat, 11 Apr 2020 17:56:23 +0200
>
> > From: Borislav Petkov <bp@suse.de>
> >
> > Change the include order so that MODULE_ARCH_VERMAGIC from the arch
> > header arch/x86/include/asm/module.h gets used instead of the fallback
> > from include/linux/vermagic.h and thus fix:
> >
> >   In file included from ./include/linux/module.h:30,
> >                    from drivers/net/ethernet/3com/3c515.c:56:
> >   ./arch/x86/include/asm/module.h:73: warning: "MODULE_ARCH_VERMAGIC" redefined
> >      73 | # define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY
> >         |
> >   In file included from drivers/net/ethernet/3com/3c515.c:25:
> >   ./include/linux/vermagic.h:28: note: this is the location of the previous definition
> >      28 | #define MODULE_ARCH_VERMAGIC ""
> >         |
> >
> > Fixes: 6bba2e89a88c ("net/3com: Delete driver and module versions from 3com drivers")
> > Signed-off-by: Borislav Petkov <bp@suse.de>
>
> I'm so confused, that commit in the Fixes: tag is _removing_ code but adding
> new #include directives?!?!
>
> Is vermagic.h really needed in these files?

You are completely right, it is not needed at all in those files.

Thanks
