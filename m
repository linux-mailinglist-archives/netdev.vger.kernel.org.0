Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F72627C7D
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 12:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbiKNLkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 06:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235903AbiKNLkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 06:40:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD717B483;
        Mon, 14 Nov 2022 03:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 666B0B80E6D;
        Mon, 14 Nov 2022 11:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25EECC433D6;
        Mon, 14 Nov 2022 11:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668426013;
        bh=GT3VZNYIhMGDOg7rLWaUnnZ1FVKV70ahkY/v86oWAWo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QemPfybwnr41UjfgwuxeYtmf7ZurGLUDrh0ptjCeQ2t5fUdWWqP9Tjxv3XP+g38HB
         aPnFMxWeI9Tga8KrWqKV7tFGdQLt7QpL5s9MmAi+dWIoTxfL7W5d8t8aXAH/2aDn2u
         YRmM9210+LfyEsJXKkKNXsJ8fXI13RGmIEEnMQGI=
Date:   Mon, 14 Nov 2022 12:40:10 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Haozhe Chang =?utf-8?B?KOW4uOa1qeWTsik=?= 
        <Haozhe.Chang@mediatek.com>
Cc:     "stephan@gerhold.net" <stephan@gerhold.net>,
        "oneukum@suse.com" <oneukum@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linuxwwan@intel.com" <linuxwwan@intel.com>,
        "m.chetan.kumar@intel.com" <m.chetan.kumar@intel.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        Hua Yang =?utf-8?B?KOadqOWNjik=?= <Hua.Yang@mediatek.com>,
        "chiranjeevi.rapolu@linux.intel.com" 
        <chiranjeevi.rapolu@linux.intel.com>,
        Haijun Liu =?utf-8?B?KOWImOa1t+WGmyk=?= 
        <haijun.liu@mediatek.com>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "chandrashekar.devegowda@intel.com" 
        <chandrashekar.devegowda@intel.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "shangxiaojing@huawei.com" <shangxiaojing@huawei.com>,
        Lambert Wang =?utf-8?B?KOeOi+S8nyk=?= 
        <Lambert.Wang@mediatek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ricardo.martinez@linux.intel.com" <ricardo.martinez@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Xiayu Zhang =?utf-8?B?KOW8oOWkj+Wuhyk=?= 
        <Xiayu.Zhang@mediatek.com>
Subject: Re: [PATCH v3] wwan: core: Support slicing in port TX flow of WWAN
 subsystem
Message-ID: <Y3IpGs0SFSgvS0kw@kroah.com>
References: <20221111100840.105305-1-haozhe.chang@mediatek.com>
 <Y25j7fTdvCRqr26k@kroah.com>
 <82c8728b0b0b20c7da4e25642e90de27af52feca.camel@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <82c8728b0b0b20c7da4e25642e90de27af52feca.camel@mediatek.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 11:23:19AM +0000, Haozhe Chang (常浩哲) wrote:
> Hi Greg Kroah-Hartman
> 
> On Fri, 2022-11-11 at 16:02 +0100, Greg Kroah-Hartman wrote:
> > On Fri, Nov 11, 2022 at 06:08:36PM +0800, haozhe.chang@mediatek.com
> > wrote:
> > > From: haozhe chang <haozhe.chang@mediatek.com>
> > > 
> > > wwan_port_fops_write inputs the SKB parameter to the TX callback of
> > > the WWAN device driver. However, the WWAN device (e.g., t7xx) may
> > > have an MTU less than the size of SKB, causing the TX buffer to be
> > > sliced and copied once more in the WWAN device driver.
> > > 
> > > This patch implements the slicing in the WWAN subsystem and gives
> > > the WWAN devices driver the option to slice(by frag_len) or not. By
> > > doing so, the additional memory copy is reduced.
> > > 
> > > Meanwhile, this patch gives WWAN devices driver the option to
> > > reserve
> > > headroom in fragments for the device-specific metadata.
> > > 
> > > Signed-off-by: haozhe chang <haozhe.chang@mediatek.com>
> > > 
> > > ---
> > > Changes in v2
> > >   -send fragments to device driver by skb frag_list.
> > > 
> > > Changes in v3
> > >   -move frag_len and headroom_len setting to wwan_create_port.
> > > ---
> > >  drivers/net/wwan/iosm/iosm_ipc_port.c  |  3 +-
> > >  drivers/net/wwan/mhi_wwan_ctrl.c       |  2 +-
> > >  drivers/net/wwan/rpmsg_wwan_ctrl.c     |  2 +-
> > >  drivers/net/wwan/t7xx/t7xx_port_wwan.c | 34 +++++++--------
> > >  drivers/net/wwan/wwan_core.c           | 59 ++++++++++++++++++++
> > > ------
> > >  drivers/net/wwan/wwan_hwsim.c          |  2 +-
> > >  drivers/usb/class/cdc-wdm.c            |  2 +-
> > >  include/linux/wwan.h                   |  6 ++-
> > >  8 files changed, 73 insertions(+), 37 deletions(-)
> > > 
> > > diff --git a/drivers/net/wwan/iosm/iosm_ipc_port.c
> > > b/drivers/net/wwan/iosm/iosm_ipc_port.c
> > > index b6d81c627277..dc43b8f0d1af 100644
> > > --- a/drivers/net/wwan/iosm/iosm_ipc_port.c
> > > +++ b/drivers/net/wwan/iosm/iosm_ipc_port.c
> > > @@ -63,7 +63,8 @@ struct iosm_cdev *ipc_port_init(struct iosm_imem
> > > *ipc_imem,
> > >  	ipc_port->ipc_imem = ipc_imem;
> > >  
> > >  	ipc_port->iosm_port = wwan_create_port(ipc_port->dev,
> > > port_type,
> > > -					       &ipc_wwan_ctrl_ops,
> > > ipc_port);
> > > +					       &ipc_wwan_ctrl_ops, 0,
> > > 0,
> > > +					       ipc_port);
> > 
> > How is 0, 0 a valid option here?
> > 
> > and if it is a valid option, shouldn't you just have 2 different
> > functions, one that needs these values and one that does not?  That
> > would make it more descriptive as to what those options are, and
> > ensure
> > that you get them right.
> > 
> 0 is a valid option. 
> frag_len set to 0 means no split, and headroom set to 0 means no 
> reserved headroom in skb. 
> 
> Sorry, I can't understand why it's more descriptive, could you help
> with more information? It seems to me that the device driver needs to
> know what each parameter is and how to set them, and that process is
> also required in your proposed solution - "with 2 different functions",
> right?

When you see random integers in the middle of a function call like this,
you then have to go and look up the function call to determine what
exactly those values are and what is happening.  Using 0, 0 as valid
values helps no one out here at all.

While if the code said:
	ipc_port->iosm_port = wwan_create_port(ipc_port->dev, port_type,
						&ipc_wwan_ctrl_ops,
						NO_SPLIT,
						NO_RESERVED_HEADROOM,
						ipc_port);


or something like that, it would make more sense, right?

Remember, we write code for people to read and understand and maintain
it over time first, for the compiler second.

thanks,

greg k-h
