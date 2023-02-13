Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99982694CFE
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjBMQdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjBMQdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:33:50 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3EA1F4A3;
        Mon, 13 Feb 2023 08:33:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676306002; x=1707842002;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=K70/T+wE2r0Y++L1JrzfkWNSLpgyO9Tcw3Cd5r1RiCE=;
  b=VMHEOkAkapeZI4WbeFarquPpGg+06waaFSPxWVTvevyXa5b5O0HxB0Bf
   SoyL+VM0TdFVCkgsLpIaPvcBuUfKO/6SqVrpxNVCd9K4Pg/Ldfo/KA5I8
   hn9h192SVklqoAKz27bst+0gotelTwMjOMw42IK1vbhqo9GSt7qr/0/4A
   odhjhhvPbEGeLPM7dSUwJmFNbic3OuxNPhuHFtwQ6gDEiEUW7Is/ykf1H
   W0Fq/JklgevSFh1bP5zUPB4wUdPsb5yah3dwO/24Q61Vh0HpcCJPuuk67
   KXCW9feV9KTdccGRsxNj7ZiHLKU3MvzFECJoTwzKxBIlJ+PvRzSMFCt2N
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="311290431"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="311290431"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 08:32:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="701327157"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="701327157"
Received: from hdevries-mobl.ger.corp.intel.com ([10.249.36.140])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 08:32:39 -0800
Date:   Mon, 13 Feb 2023 18:32:36 +0200 (EET)
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
        Netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: Re: [PATCH v1 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
In-Reply-To: <AM9PR04MB8603E350AC2E06CB788909C0E7DD9@AM9PR04MB8603.eurprd04.prod.outlook.com>
Message-ID: <ad1fc5d4-6d44-4982-71f9-6721aa8914d2@linux.intel.com>
References: <20230124174714.2775680-1-neeraj.sanjaykale@nxp.com> <20230124174714.2775680-4-neeraj.sanjaykale@nxp.com> <bd10dd58-35ff-e0e2-5ac4-97df1f6a30a8@linux.intel.com> <AM9PR04MB8603E350AC2E06CB788909C0E7DD9@AM9PR04MB8603.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-1018622996-1676305871=:1712"
Content-ID: <ad2d565a-4c1b-2eb9-5f77-3cd070a3f21a@linux.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1018622996-1676305871=:1712
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <2c6ecd2-a9c-a11e-73f8-e8d5518a2ffe@linux.intel.com>

On Mon, 13 Feb 2023, Neeraj sanjay kale wrote:

> Hi Ilpo,
> 
> Thank you for your review comments and sorry for the delay in replying to some of your queries.

I made some additional comments against v2 and I meant those ones were not 
addressed, the ones I made for v1 you've addressed I think.

-- 
 i.

> 
> > From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> > Sent: Wednesday, January 25, 2023 4:53 PM
> > To: Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
> > Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> > pabeni@redhat.com; robh+dt@kernel.org;
> > krzysztof.kozlowski+dt@linaro.org; marcel@holtmann.org;
> > johan.hedberg@gmail.com; luiz.dentz@gmail.com; Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org>; Jiri Slaby <jirislaby@kernel.org>; Netdev
> > <netdev@vger.kernel.org>; devicetree@vger.kernel.org; LKML <linux-
> > kernel@vger.kernel.org>; linux-bluetooth@vger.kernel.org; linux-serial
> > <linux-serial@vger.kernel.org>; Amitkumar Karwar
> > <amitkumar.karwar@nxp.com>; Rohit Fule <rohit.fule@nxp.com>; Sherry
> > Sun <sherry.sun@nxp.com>
> > Subject: Re: [PATCH v1 3/3] Bluetooth: NXP: Add protocol support for
> > NXP Bluetooth chipsets
> > 
> > > This adds a driver based on serdev driver for the NXP BT serial
> > > protocol based on running H:4, which can enable the built-in
> > > Bluetooth device inside a generic NXP BT chip.
> > >
> > > This driver has Power Save feature that will put the chip into
> > > sleep state whenever there is no activity for 2000ms, and will
> > > be woken up when any activity is to be initiated.
> > >
> > > This driver enables the power save feature by default by sending
> > > the vendor specific commands to the chip during setup.
> > >
> > > During setup, the driver is capable of reading the bootloader
> > > signature unique to every chip, and downloading corresponding
> > > FW file defined in a user-space config file. The firmware file
> > > name can be defined in DTS file as well, in which case the
> > > user-space config file will be ignored.
> > >
> > > Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> > > ---
> > >  MAINTAINERS                |    7 +
> > >  drivers/bluetooth/Kconfig  |   11 +
> > >  drivers/bluetooth/Makefile |    1 +
> > >  drivers/bluetooth/btnxp.c  | 1337
> > ++++++++++++++++++++++++++++++++++++
> > >  drivers/bluetooth/btnxp.h  |  230 +++++++
> > >  5 files changed, 1586 insertions(+)
> > >  create mode 100644 drivers/bluetooth/btnxp.c
> > >  create mode 100644 drivers/bluetooth/btnxp.h
> > >
> > > +static int ps_init_work(struct hci_dev *hdev)
> > > +{
> > > +     struct ps_data *psdata = kzalloc(sizeof(*psdata), GFP_KERNEL);
> > > +     struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> > > +
> > > +     if (!psdata) {
> > > +             BT_ERR("Can't allocate control structure for Power Save feature");
> > > +             return -ENOMEM;
> > > +     }
> > > +     nxpdev->psdata = psdata;
> > > +
> > > +     memset(psdata, 0, sizeof(*psdata));
> > 
> > Why memset to zero kzalloc'ed mem?
> I have removed all memset calls after kzalloc.
> > 
> 
> 
> 
> > > +static int send_ps_cmd(struct hci_dev *hdev, void *data)
> > > +{
> > > +     struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> > > +     struct ps_data *psdata = nxpdev->psdata;
> > > +     u8 pcmd;
> > > +     struct sk_buff *skb;
> > > +     u8 *status;
> > > +
> > > +     if (psdata->ps_mode ==  PS_MODE_ENABLE)
> > > +             pcmd = BT_PS_ENABLE;
> > > +     else
> > > +             pcmd = BT_PS_DISABLE;
> > > +
> > > +     psdata->driver_sent_cmd = true; /* set flag to prevent re-sending
> > command in nxp_enqueue */
> > > +     skb = __hci_cmd_sync(hdev, HCI_NXP_AUTO_SLEEP_MODE, 1, &pcmd,
> > HCI_CMD_TIMEOUT);
> > > +     psdata->driver_sent_cmd = false;
> > 
> > A helper for these 3 lines?
> Added a new function where ever setting psdata->driver_sent_cmd and __hci_cmd_sync() is needed.
> 
> 
> 
> > 
> > Do you need to free the skb?
> Yes. Freed skb's where ever it needs to be freed in v2 and v3 patches.
> 
> 
> 
> > > +     for (i = 0; i < map_table_size; i++) {
> > 
> > Isn't this just ARRAY_SIZE(chip_id_name_table)? use it directly here,
> > no need for the extra variable?
> > 
> > > +             if (!strcmp(chip_id_name_table[i].chip_name, name_str))
> > > +                     return chip_id_name_table[i].chip_id;
> > > +     }
> > > +
> > > +     return 0;  /* invalid name_str */
> > 
> > Put such comment preferrably to function's comment if you want to note
> > things like this or create a properly named define for it.
> I have slightly changed the way FW Download behaves, and removed this function.
> 
> 
> 
> > strncpy(fw_mod_params[param_index].fw_name,
> > > +                                                     value, MAX_FW_FILE_NAME_LEN);
> > > +                                     } else if (!strcmp(label, OPER_SPEED_TAG)) {
> > > +                                             ret = kstrtouint(value, 10,
> > > +                                             &fw_mod_params[param_index].oper_speed);
> > > +                                     } else if (!strcmp(label, FW_DL_PRI_BAUDRATE_TAG))
> > {
> > > +                                             ret = kstrtouint(value, 10,
> > > +
> > &fw_mod_params[param_index].fw_dnld_pri_baudrate);
> > > +                                     } else if (!strcmp(label, FW_DL_SEC_BAUDRATE_TAG))
> > {
> > > +                                             ret = kstrtouint(value, 10,
> > > +
> > &fw_mod_params[param_index].fw_dnld_sec_baudrate);
> > > +                                     } else if (!strcmp(label, FW_INIT_BAUDRATE)) {
> > > +                                             ret = kstrtouint(value, 10,
> > > +
> > &fw_mod_params[param_index].fw_init_baudrate);
> > > +                                     } else {
> > > +                                             BT_ERR("Unknown tag: %s", label);
> > > +                                             ret = -1;
> > > +                                             goto err;
> > > +                                     }
> > 
> > Your indent is way too deep here, refactor the line processing into
> > another function to make it readable?
> > 
> > Wouldn't something like sscanf() make it a bit simpler?
> 
> Created a new function to handle updating this data and used sscanf().
> 
> 
> 
> > > +             } else {
> > > +                     *dptr = sptr[i];
> > > +                     dptr++;
> > 
> > What prevents dptr becoming larger than the size allocated for line?
> Used array index method instead of dptr pointer to fill the line. Added check for index.
> 
> > > +static bool nxp_fw_change_baudrate(struct hci_dev *hdev, u16 req_len)
> > > +{
> > > +     struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> > > +     static u8 nxp_cmd5_header[HDR_LEN] = {
> > 
> > It would be good to prefix HDR_LEN with something to make it more specific
> > to this use case.
> We need this HDR_LEN macro while sending cmd7 as well. Hence kept this unchanged.
> 
> > 
> > > +                                                     0x05, 0x00, 0x00, 0x00,
> > > +                                                     0x00, 0x00, 0x00, 0x00,
> > > +                                                     0x2c, 0x00, 0x00, 0x00,
> > > +                                                     0x77, 0xdb, 0xfd, 0xe0};
> > > +     static u8 uart_config[60] = {0};
> > 
> > Is this some structure actually? You seem to be filling it always with
> > the same stuff in same order?
> > 
> > You probably need to handle byte-order properly too.
> Handled cmd5 and cmd7 in a proper way using structures and handled byte-ordering.
> 
> > > +static u32 nxp_get_data_len(const u8 *buf)
> > > +{
> > > +     return (buf[8] | (buf[9] << 8));
> > 
> > Custom byte-order func? Use std ones instead.
> Resolved in v2 patch.
> 
> > > +     if (nxpdev->fw_dnld_sec_baudrate != nxpdev->current_baudrate) {
> > > +             if (!timeout_changed) {
> > > +                     nxp_send_ack(NXP_ACK_V1, hdev);
> > > +                     timeout_changed = nxp_fw_change_timeout(hdev, req->len);
> > 
> > You never test if there was enough data? If there isn't req will be NULL
> > which you don't check before dereferencing req->len.
> Added check for req before dereferencing it.
> 
> 
> > > +             if (req->len & 0x01) {
> > > +                     /* The CRC did not match at the other end.
> > > +                      * That's why the request to re-send.
> > > +                      * Simply send the same bytes again.
> > > +                      */
> > > +                     requested_len = nxpdev->fw_sent_bytes;
> > > +                     BT_ERR("CRC error. Resend %d bytes of FW.", requested_len);
> > > +             } else {
> > > +                     /* Increment offset by number of previous successfully sent
> > bytes */
> > > +                     nxpdev->fw_dnld_offset += nxpdev->fw_sent_bytes;
> > > +                     requested_len = req->len;
> > > +             }
> > > +
> > > +             /* The FW bin file is made up of many blocks of
> > > +              * 16 byte header and payload data chunks. If the
> > > +              * FW has requested a header, read the payload length
> > > +              * info from the header, and then send the header.
> > > +              * In the next iteration, the FW should request the
> > > +              * payload data chunk, which should be equal to the
> > > +              * payload length read from header. If there is a
> > > +              * mismatch, clearly the driver and FW are out of sync,
> > > +              * and we need to re-send the previous header again.
> > > +              */
> > > +             if (requested_len == expected_len) {
> > > +                     if (requested_len == HDR_LEN)
> > > +                             expected_len = nxp_get_data_len(nxpdev->fw->data +
> > > +                                                                     nxpdev->fw_dnld_offset);
> > > +                     else
> > > +                             expected_len = HDR_LEN;
> > 
> > How can you ever end up into this else branch? Why assign expected_len
> > here?
> There are 2 scenarios where requested_len == expected_len.
> One, where requested_len is 16, which means a header was requested.
> Another, where requested_len is not 16, which means payload was requested.
> 
> So if header was requested, we calculate the payload length which should be equal to requested_len in next iteration.
> Similarly, if payload was requested, then in the next iteration the FW should request for a 16 bit header.
> The expected_len is expected to toggle between 2 values: 16 and (e.g.) 2048.
> 
> > 
> > > +             } else {
> > > +                     if (requested_len == HDR_LEN) {
> > 
> > Never true.
> Ideally we should not end up in this else part, but there are various customers and module vendors who use NXP chipsets within their products, which are already out in the market. Whenever the driver sends the cmd5 and cmd7 packets, we sometimes observe this scenario where the FW requests 16 bit header in 2 consecutive iterations, and we need to be sure that we re-send the 16 bit header, and not the 16 bit payload. 
> This happens when the chip updates it's baudrate while receiving the 1st header, and discards it due to CRC mismatch, and requests the header again.
> 
> >
> > > +                             /* FW download out of sync. Send previous chunk again> */
> > > +                            nxpdev->fw_dnld_offset -= nxpdev->fw_sent_bytes;
> > > +                             expected_len = HDR_LEN;> > +                     }
> > > +            }
> > > +
> 
> > > +static int nxp_recv_fw_req_v3(struct hci_dev *hdev, struct sk_buff *skb)
> > > +{
> > > +     struct V3_DATA_REQ *req = skb_pull_data(skb, sizeof(struct
> > V3_DATA_REQ));
> > > +     struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> > > +     static bool timeout_changed;
> > > +     static bool baudrate_changed;
> > > +
> > > +     if (!req || !nxpdev || !strlen(nxpdev->fw_name) || !nxpdev->fw->data)
> > > +             return 0;
> > 
> > Who is expected to free the skb? These functions or one of the callers?
> > (Which one? I lost track of the callchain and error passing too).
> Added kfree_skb() in the called functions.
> 
> 
> > > +                     strncpy(nxpdev->fw_name, fw_path,
> > MAX_FW_FILE_NAME_LEN);
> > > +                     strncpy(nxpdev->fw_name + strlen(fw_path), fw_name_dt,
> > > +                                     MAX_FW_FILE_NAME_LEN);
> > 
> > How can this second one be correct if you use +strlen(fw_path) for the
> > pointer. Why not use snprintf()?
> Replaced strncpy with snprintfs()
> 
> 
> 
> > > +static int nxp_enqueue(struct hci_dev *hdev, struct sk_buff *skb)
> > > +{
> > > +     struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> > > +     struct ps_data *psdata = nxpdev->psdata;
> > > +     struct hci_command_hdr *hdr;
> > > +     u8 *param;
> > > +
> > > +     /* if commands are received from user space (e.g. hcitool), update
> > > +      * driver flags accordingly and ask driver to re-send the command
> > > +      */
> > > +     if (bt_cb(skb)->pkt_type == HCI_COMMAND_PKT && !psdata-
> > >driver_sent_cmd) {
> > 
> > Should you need to check psdata for NULL before dereferencing it?
> Added checks for psdata before dereferencing it.
> 
> 
> > > +/* Bluetooth vendor command : Sleep mode */
> > > +#define HCI_NXP_AUTO_SLEEP_MODE      0xFC23
> > 
> > Try to change all hex letters to lowercase.
> Changed all hex letters to lowercase.
> 
> > > +struct V1_DATA_REQ {
> > > +     u16 len;
> > > +     u16 len_comp;
> > > +} __packed;
> > > +
> > > +struct V3_DATA_REQ {
> > > +     u16 len;
> > > +     u32 offset;
> > > +     u16 error;
> > > +     u8 crc;
> > > +} __packed;
> > > +
> > > +struct V3_START_IND {
> > > +     u16 chip_id;
> > > +     u8 loader_ver;
> > > +     u8 crc;
> > > +} __packed;
> > 
> > Struct names should be lowercased. Multibyte fields need to specify
> > byte-order?
> Resolved.
> 
> > > +
> > > +#define SWAPL(x) ((((x) >> 24) & 0xff) \
> > > +                              | (((x) >> 8) & 0xff00) \
> > > +                              | (((x) << 8) & 0xff0000L) \
> > > +                              | (((x) << 24) & 0xff000000L))
> > 
> > Perhaps something existing under include/ could do swap for you?
> Added call to a standard swab32() function.
> 
> > --
> >  i.
> 
> Please review the V3 patch and let me know if you have any suggestions or comments.
--8323329-1018622996-1676305871=:1712--
