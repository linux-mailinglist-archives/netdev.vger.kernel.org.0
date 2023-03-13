Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD99D6B721D
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 10:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjCMJKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 05:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbjCMJJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 05:09:47 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16D156159;
        Mon, 13 Mar 2023 02:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678698521; x=1710234521;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=cq6QdrMcR3tA5ptzjJyzksVlZ4tZ93rLnwQheu8e54Q=;
  b=Ulprt4xM1tdMpTmsVc/JhnJCDDu7xcaQMYLK1tFy8h5QObEKk8Lxi81d
   ZDEZ6fkxzRuarFY14o47BFptora5h9+uCnjKRcYSMXrecuyY9eKqEma0a
   hNapvJEs6r2nzS8tLtDENtOkS0qHPk1KQoNX3/qBxL6IOuSrDGIEWXxro
   lph5kq0QGotjl8zs/2JmnMUrdnxzERCPjxILAMGLjvnf4Wa8p281ksCjj
   /DnX/56pB5fmD7vvvu/R/jjjs8kxtTczOUBWssSl4VszH4AHWN93cCuIq
   f8R7TLuusmleCJikVnQNq53Kg0JDdoCu6UlzaZPzAa+J1aQiP5l7Y6FDE
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="423363959"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="423363959"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 02:08:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="680950602"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="680950602"
Received: from etsykuno-mobl2.ccr.corp.intel.com ([10.252.47.211])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 02:08:35 -0700
Date:   Mon, 13 Mar 2023 11:08:33 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: Re: [PATCH v6 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
In-Reply-To: <AM9PR04MB8603D2F3E3CDC714BDACECC0E7BA9@AM9PR04MB8603.eurprd04.prod.outlook.com>
Message-ID: <11c7e098-19c8-6961-5369-214bc948bc37@linux.intel.com>
References: <20230301154514.3292154-1-neeraj.sanjaykale@nxp.com> <20230301154514.3292154-4-neeraj.sanjaykale@nxp.com> <73527cb7-6546-6c47-768c-5f4648b6d477@linux.intel.com> <AM9PR04MB86037CDF6A032963405AF0CEE7B69@AM9PR04MB8603.eurprd04.prod.outlook.com>
 <48e776a1-7526-5b77-568b-322d4555a138@linux.intel.com> <AM9PR04MB8603D2F3E3CDC714BDACECC0E7BA9@AM9PR04MB8603.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Mar 2023, Neeraj sanjay kale wrote:

> Hi Ilpo,
> 
> I have resolved most of your comments in v8 patch, and I have few things to discuss regarding the v6 patch.
> 
> > > > > +static bool nxp_fw_change_baudrate(struct hci_dev *hdev, u16
> > > > > +req_len) {
> > > > > +     struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> > > > > +     struct nxp_bootloader_cmd nxp_cmd5;
> > > > > +     struct uart_config uart_config;
> > > > > +
> > > > > +     if (req_len == sizeof(nxp_cmd5)) {
> > > > > +             nxp_cmd5.header = __cpu_to_le32(5);
> > > > > +             nxp_cmd5.arg = 0;
> > > > > +             nxp_cmd5.payload_len = __cpu_to_le32(sizeof(uart_config));
> > > > > +             nxp_cmd5.crc = swab32(crc32_be(0UL, (char *)&nxp_cmd5,
> > > > > +                                            sizeof(nxp_cmd5) -
> > > > > + 4));
> > > >
> > > > swab32(crc32_be(...)) seems and odd construct instead of
> > __cpu_to_le32().
> > > Earlier I had tried using __cpu_to_le32() but that did not work. The
> > > FW expects a swapped CRC value for it's header and payload data.
> > 
> > So the .crc member should be __be32 then?
> > 
> I disagree with using __be32.
> I have simplified this part of the code in v8 patch, please do check it out.
> So the CRC part of the data structure will remain __le32, and will be sent over UART to the chip in Little Endian format.
> It's just that the FW expects the CRC to be byte-swapped. 
> Technically it is big endian format, but you may think of it as a "+1 level" of encryption (although it isn't).
> So defining this structure member as __be32 can create more questions 
> than answers, leading to more confusion. 
> If it helps, I have also added a small comment in there to signify that 
> the FW  expects CRC in byte swapped method.

I'd have still put the member as __be32 and commented the swap expectation 
there. But it's not an end of the world even in the current form.

> > > > > +     serdev_device_write_buf(nxpdev->serdev, (u8 *)&nxp_cmd7,
> > > > > + req_len);
> > > >
> > > > Is it safe to assume req_len is small enough to not leak stack content?
> > > The chip requests chunk of FW data which is never more than 2048 bytes
> > > at a time.
> > 
> > Eh, sizeof(*nxp_cmd7) is 16 bytes!?! Are you sure that req_len given to
> > serdev_device_write_buf() is not larger than 16 bytes?
> > 
> I have now replaced req_len with sizeof(<struct>).
> There is also a check in the beginning of the function to return if req_len is not 16 bytes.

Ah, I'd missed that check for some reason.


-- 
 i.

