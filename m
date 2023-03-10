Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27EF6B3FD9
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 14:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjCJNAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 08:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjCJNAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 08:00:52 -0500
Received: from mail11.truemail.it (mail11.truemail.it [IPv6:2001:4b7e:0:8::81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D50CB676;
        Fri, 10 Mar 2023 05:00:47 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        by mail11.truemail.it (Postfix) with ESMTPA id 294B820BBD;
        Fri, 10 Mar 2023 14:00:41 +0100 (CET)
Date:   Fri, 10 Mar 2023 14:00:37 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
Cc:     Francesco Dolcini <francesco@dolcini.it>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
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
Subject: Re: [EXT] Re: [PATCH v6 3/3] Bluetooth: NXP: Add protocol support
 for NXP Bluetooth chipsets
Message-ID: <ZAsp9fm779DR0Vuz@francesco-nb.int.toradex.com>
References: <20230301154514.3292154-1-neeraj.sanjaykale@nxp.com>
 <20230301154514.3292154-4-neeraj.sanjaykale@nxp.com>
 <ZAX/HHyy2yL76N0K@francesco-nb.int.toradex.com>
 <AM9PR04MB860372E06283EA79BD341998E7BA9@AM9PR04MB8603.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM9PR04MB860372E06283EA79BD341998E7BA9@AM9PR04MB8603.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 12:09:09PM +0000, Neeraj sanjay kale wrote:
> > > +#define FIRMWARE_W8987       "nxp/uartuart8987_bt.bin"
> > > +#define FIRMWARE_W8997       "nxp/uartuart8997_bt_v4.bin"
> > > +#define FIRMWARE_W9098       "nxp/uartuart9098_bt_v1.bin"
> > > +#define FIRMWARE_IW416       "nxp/uartiw416_bt_v0.bin"
> > > +#define FIRMWARE_IW612       "nxp/uartspi_n61x_v1.bin.se"
> > 
> > Where are this files coming from? Where can I download those?
> > Is loading a combo firmware from the mwifiex driver supported?
> We are working on submitting these files to linux-firmware. They will
> be available under nxp/ directory once merged.

What about the combo firmware that would be downloaded by mwifiex
driver? How is this supposed to interact with it?

> > > +#define HCI_NXP_PRI_BAUDRATE 115200
> > > +#define HCI_NXP_SEC_BAUDRATE 3000000
> > What if the UART device does not support 3000000 baudrate (think at
> > limitation on the clock source/divider of the UART)? Shouldn't this be
> > configurable?
> We have noted this requirement and decided to design and implement on
> this in upcoming patches along with other new features.  We have a
> number of customers out there who have been using these chips as well
> as the legacy Marvell chips, which need FW download at 3000000
> baudrate, and so far there were no issues reported.  Using a lower
> standard baudrate affects the time it takes to download the FW, which
> we are trying to keep strictly under 5 seconds.

ok, just for you to know our hardware, using NXP SoC, will not work with
this baudrate (no way to have it given the clock tree we have).

> Hope this helps!
Yes, thanks!

Francesco

