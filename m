Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C696ADDEB
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 12:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbjCGLsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 06:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbjCGLsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 06:48:22 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C79A7B129;
        Tue,  7 Mar 2023 03:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678189646; x=1709725646;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=ABa115dzYhbKqxSWjzfNIHa1e+/UpB5wXI8AqnFj1B8=;
  b=ND3BhInNqYYDdwVTdXvVkZLjlzB7QOtSTX6sc5q5u8KLubZNnj4iM75f
   UQDU/qKA+Qd7wFWVvr0Jv/DPPlZp5VmuopDndctr34otG95hhjvYP9mc3
   xWByA5stMt19+Fuhax0v9ZxMA9YNigR7gLBG5LmGEsUCfx+yPqjjid6BX
   H2n7Hf+Vl0pvNntWBCrqOf+Dhmv2pS5FjaoYcxroF80yl95HIp2aL8XMi
   EDBaNdaHHe7XzqOO0tsflFlsvqsj7UKiOUmN28v/9nVFKO6u0LphbSSqT
   o0ZrBq5jgfDzvV+Vd9sf/uSViXqTWw4ylnR0I2OGIIQU/0ul8hIcBf7ew
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="316229508"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="316229508"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 03:43:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="706777464"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="706777464"
Received: from unknown (HELO ijarvine-MOBL2.mshome.net) ([10.237.66.32])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 03:43:37 -0800
Date:   Tue, 7 Mar 2023 13:43:35 +0200 (EET)
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
In-Reply-To: <AM9PR04MB86037CDF6A032963405AF0CEE7B69@AM9PR04MB8603.eurprd04.prod.outlook.com>
Message-ID: <48e776a1-7526-5b77-568b-322d4555a138@linux.intel.com>
References: <20230301154514.3292154-1-neeraj.sanjaykale@nxp.com> <20230301154514.3292154-4-neeraj.sanjaykale@nxp.com> <73527cb7-6546-6c47-768c-5f4648b6d477@linux.intel.com> <AM9PR04MB86037CDF6A032963405AF0CEE7B69@AM9PR04MB8603.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Mar 2023, Neeraj sanjay kale wrote:

> Hi Ilpo,
> 
> Thank you for reviewing this patch. I have resolved most of your review comments in v7 patch, and I have some clarification inline below:

Further discussion below + I sent a few against v7.

 
> > > +static bool nxp_fw_change_baudrate(struct hci_dev *hdev, u16 req_len)
> > > +{
> > > +     struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> > > +     struct nxp_bootloader_cmd nxp_cmd5;
> > > +     struct uart_config uart_config;
> > > +
> > > +     if (req_len == sizeof(nxp_cmd5)) {
> > > +             nxp_cmd5.header = __cpu_to_le32(5);
> > > +             nxp_cmd5.arg = 0;
> > > +             nxp_cmd5.payload_len = __cpu_to_le32(sizeof(uart_config));
> > > +             nxp_cmd5.crc = swab32(crc32_be(0UL, (char *)&nxp_cmd5,
> > > +                                            sizeof(nxp_cmd5) - 4));
> > 
> > swab32(crc32_be(...)) seems and odd construct instead of __cpu_to_le32().
> Earlier I had tried using __cpu_to_le32() but that did not work. The FW expects a swapped
> CRC value for it's header and payload data.

So the .crc member should be __be32 then?

> > > +     serdev_device_write_buf(nxpdev->serdev, (u8 *)&nxp_cmd7,
> > > + req_len);
> > 
> > Is it safe to assume req_len is small enough to not leak stack content?
> The chip requests chunk of FW data which is never more than 2048 bytes 
> at a time. 

Eh, sizeof(*nxp_cmd7) is 16 bytes!?! Are you sure that req_len given to 
serdev_device_write_buf() is not larger than 16 bytes?

> > > +static bool nxp_check_boot_sign(struct btnxpuart_dev *nxpdev) {
> > > +     int ret;
> > > +
> > > +     serdev_device_set_baudrate(nxpdev->serdev,
> > HCI_NXP_PRI_BAUDRATE);
> > > +     serdev_device_set_flow_control(nxpdev->serdev, 0);
> > > +     set_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state);
> > > +
> > > +     ret = wait_event_interruptible_timeout(nxpdev-
> > >check_boot_sign_wait_q,
> > > +                                            !test_bit(BTNXPUART_CHECK_BOOT_SIGNATURE,
> > > +                                                      &nxpdev->tx_state),
> > > +                                            msecs_to_jiffies(1000));
> > > +     if (ret == 0)
> > > +             return false;
> > > +     else
> > > +             return true;
> > 
> > How does does this handle -ERESTARTSYS? But this runs in nxp_setup() so is
> > that even relevant (I don't know).
> This function is waits for 1 second and checks if it is receiving any bootloader signatures
> over UART. If yes, it means FW download is needed. If no, it means FW is already present
> on the chip, and we skip FW download.

Okay, it seems your changes had a side-effect of addressing this.

> > > +static int nxp_enqueue(struct hci_dev *hdev, struct sk_buff *skb) {
> > > +     struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> > > +     struct ps_data *psdata = nxpdev->psdata;
> > > +     struct hci_command_hdr *hdr;
> > > +     u8 param[MAX_USER_PARAMS];
> > > +
> > > +     if (!nxpdev || !psdata)
> > > +             goto free_skb;
> > > +
> > > +     /* if vendor commands are received from user space (e.g. hcitool),
> > update
> > > +      * driver flags accordingly and ask driver to re-send the command to
> > FW.
> > > +      */
> > > +     if (bt_cb(skb)->pkt_type == HCI_COMMAND_PKT &&
> > > + !psdata->driver_sent_cmd) {
> > 
> > Should this !psdata->driver_sent_cmd do something else than end up into a
> > place labelled send_skb. Maybe return early (or free skb + return)?
> > There's a comment elsewhere stating: "set flag to prevent re-sending
> > command in nxp_enqueue."
> I'm sorry if the comment was misleading. This flag is set to prevent nxp_enqueue() from
> Parsing the command parameters again, and calling hci_cmd_sync_queue() again.
> The commands sent from user space, as well as the commands sent by __hci_cmd_sync(),
> both endup in nxp_enqueue().
> Hope this helps!

Okay, makes sense now and the logic is also clearer now. However, the
brace blocks you added into those cases in bxp_enqueue() you should try to 
remove. I realize you do it to avoid name collisions because you reused 
param in each but they introduced these ugly constructs:
	case XX:
		{
			...
			goto free_skb;
		}
		break;

-- 
 i.

