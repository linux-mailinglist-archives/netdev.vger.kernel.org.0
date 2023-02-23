Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C97A6A0B72
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 15:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbjBWOC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 09:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234514AbjBWOCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 09:02:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1544657D08;
        Thu, 23 Feb 2023 06:02:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3CCE61723;
        Thu, 23 Feb 2023 14:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A859C433A7;
        Thu, 23 Feb 2023 14:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677160957;
        bh=QfxUQghE4DPpZIz+o5tpKsleTcnAA0ZVlwhLSMgXCtw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TkFY8ikFg+bB2r4feFrEQQ4G0kBWDk2EPbwGvb+4u7JcMFKDZ+bFxgg703xu7FUlF
         R2kw5NzCQkWNef8PnLMDx1bxPd+wCYKVudgJ7JQqHH4zPfqSD6Hh8ZmDTbhmp27R+N
         Q8mmCIOZcLr7OKrETZXJ2HpIw0Bazos44XU+oZIQ=
Date:   Thu, 23 Feb 2023 15:02:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: Re: [PATCH v5] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Message-ID: <Y/dx+y8enikEP9iu@kroah.com>
References: <20230223103614.4137309-1-neeraj.sanjaykale@nxp.com>
 <20230223103614.4137309-4-neeraj.sanjaykale@nxp.com>
 <Y/dEa6UJ2pXWsyOV@kroah.com>
 <AM9PR04MB8603BD23BC407407316E928AE7AB9@AM9PR04MB8603.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM9PR04MB8603BD23BC407407316E928AE7AB9@AM9PR04MB8603.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 01:57:58PM +0000, Neeraj sanjay kale wrote:
> Hi Greg,
> 
> Thank you for your feedback.
> 
> > 
> > > +
> > > +static int init_baudrate = 115200;
> > 
> > and neither will this, as you need to support multiple devices in the system,
> > your driver should never be only able to work with one device.
> > Please make these device-specific things, not the same for the whole driver.
> > 
> 
> I am using this init_baudrate as a module parameter
> static int init_baudrate = 115200;
> module_param(init_baudrate, int, 0444);
> MODULE_PARM_DESC(init_baudrate, "host baudrate after FW download: default=115200");

Ah, totally missed that.

That is not ok, sorry, this is not the 1990's, we do not use module
parameters for drivers as that obviously does not work at all for when
you have multiple devices controlled by that driver.  Please make this
all dynamic and "just work" properly for all devices.

> We need this parameter configurable since different chip module vendors using the same NXP chipset, configure these chips differently.

Then you are pushing the configuration to userspace for someone else to
put on their boot command line?  that's crazy, please never do that.

> For example, module vendor A distributes his modules based on NXP 88w8987 chips with a different configuration compared to module vendor B (based on NXP 88w8987), and the init_baudrate is one of the important distinctions between them.

Then put that logic in DT where it belongs.

> If we are able to keep this init_baudrate configurable, while compiling btnxpuart.ko as module, we will be able to support such baudrate variations.

Again, no, that's not how tty or serial devices work.

thanks,

greg k-h
