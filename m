Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8D4A1932E0
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 22:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgCYVhl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 25 Mar 2020 17:37:41 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:60905 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgCYVhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 17:37:40 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 73B3CCECD6;
        Wed, 25 Mar 2020 22:47:10 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v2 1/2] Bluetooth: btusb: Indicate Microsoft vendor
 extension for Intel 9460/9560 and 9160/9260
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CABmPvSFL_bkrZQJkAzUMck_bAY5aBZkL=5HGV_Syv2QRYfRLfw@mail.gmail.com>
Date:   Wed, 25 Mar 2020 22:37:38 +0100
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <B2A2CFFE-8FC1-462B-9C7F-1CD584B6EB24@holtmann.org>
References: <20200325070336.1097-1-mcchou@chromium.org>
 <20200325000332.v2.1.I0e975833a6789e8acc74be7756cd54afde6ba98c@changeid>
 <72699110-843A-4382-8FF1-20C5D4D557A2@holtmann.org>
 <CABmPvSFL_bkrZQJkAzUMck_bAY5aBZkL=5HGV_Syv2QRYfRLfw@mail.gmail.com>
To:     Miao-chen Chou <mcchou@chromium.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Miao-chen,

>>> This adds a bit mask of driver_info for Microsoft vendor extension and
>>> indicates the support for Intel 9460/9560 and 9160/9260. See
>>> https://docs.microsoft.com/en-us/windows-hardware/drivers/bluetooth/
>>> microsoft-defined-bluetooth-hci-commands-and-events for more information
>>> about the extension. This was verified with Intel ThunderPeak BT controller
>>> where msft_vnd_ext_opcode is 0xFC1E.
>>> 
>>> Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
>>> ---
>>> 
>>> Changes in v2:
>>> - Define struct msft_vnd_ext and add a field of this type to struct
>>> hci_dev to facilitate the support of Microsoft vendor extension.
>>> 
>>> drivers/bluetooth/btusb.c        | 14 ++++++++++++--
>>> include/net/bluetooth/hci_core.h |  6 ++++++
>>> 2 files changed, 18 insertions(+), 2 deletions(-)
>>> 
>>> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
>>> index 3bdec42c9612..4c49f394f174 100644
>>> --- a/drivers/bluetooth/btusb.c
>>> +++ b/drivers/bluetooth/btusb.c
>>> @@ -58,6 +58,7 @@ static struct usb_driver btusb_driver;
>>> #define BTUSB_CW6622          0x100000
>>> #define BTUSB_MEDIATEK                0x200000
>>> #define BTUSB_WIDEBAND_SPEECH 0x400000
>>> +#define BTUSB_MSFT_VND_EXT   0x800000
>>> 
>>> static const struct usb_device_id btusb_table[] = {
>>>      /* Generic Bluetooth USB device */
>>> @@ -335,7 +336,8 @@ static const struct usb_device_id blacklist_table[] = {
>>> 
>>>      /* Intel Bluetooth devices */
>>>      { USB_DEVICE(0x8087, 0x0025), .driver_info = BTUSB_INTEL_NEW |
>>> -                                                  BTUSB_WIDEBAND_SPEECH },
>>> +                                                  BTUSB_WIDEBAND_SPEECH |
>>> +                                                  BTUSB_MSFT_VND_EXT },
>>>      { USB_DEVICE(0x8087, 0x0026), .driver_info = BTUSB_INTEL_NEW |
>>>                                                   BTUSB_WIDEBAND_SPEECH },
>>>      { USB_DEVICE(0x8087, 0x0029), .driver_info = BTUSB_INTEL_NEW |
>>> @@ -348,7 +350,8 @@ static const struct usb_device_id blacklist_table[] = {
>>>      { USB_DEVICE(0x8087, 0x0aa7), .driver_info = BTUSB_INTEL |
>>>                                                   BTUSB_WIDEBAND_SPEECH },
>>>      { USB_DEVICE(0x8087, 0x0aaa), .driver_info = BTUSB_INTEL_NEW |
>>> -                                                  BTUSB_WIDEBAND_SPEECH },
>>> +                                                  BTUSB_WIDEBAND_SPEECH |
>>> +                                                  BTUSB_MSFT_VND_EXT },
>>> 
>>>      /* Other Intel Bluetooth devices */
>>>      { USB_VENDOR_AND_INTERFACE_INFO(0x8087, 0xe0, 0x01, 0x01),
>>> @@ -3734,6 +3737,8 @@ static int btusb_probe(struct usb_interface *intf,
>>>      hdev->send   = btusb_send_frame;
>>>      hdev->notify = btusb_notify;
>>> 
>>> +     hdev->msft_ext.opcode = HCI_OP_NOP;
>>> +
>> 
>> do this in the hci_alloc_dev procedure for every driver. This doesn’t belong in the driver.
> Thanks for the note, I will address this.
>> 
>>> #ifdef CONFIG_PM
>>>      err = btusb_config_oob_wake(hdev);
>>>      if (err)
>>> @@ -3800,6 +3805,11 @@ static int btusb_probe(struct usb_interface *intf,
>>>              set_bit(HCI_QUIRK_STRICT_DUPLICATE_FILTER, &hdev->quirks);
>>>              set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
>>>              set_bit(HCI_QUIRK_NON_PERSISTENT_DIAG, &hdev->quirks);
>>> +
>>> +             if (id->driver_info & BTUSB_MSFT_VND_EXT &&
>>> +                     (id->idProduct == 0x0025 || id->idProduct == 0x0aaa)) {
>> 
>> Please scrap this extra check. You already selected out the PID with the blacklist_table. In addition, I do not want to add a PID in two places in the driver.
> If we scrap the check around idProduct, how do we tell two controllers
> apart if they use different opcode for Microsoft vendor extension?

for Intel controllers this is highly unlikely. If we really decide to change the opcode in newer firmware versions, we then deal with it at that point.

However for Intel controllers I have the feeling that we better do it after the Read the Intel version information and then do it based on hardware revision and firmware version.

>> An alternative is to not use BTUSB_MSFT_VND_EXT and let the Intel code set it based on the hardware / firmware revision it finds. We might need to discuss which is the better approach for the Intel hardware since not all PIDs are unique.
> We are expecting to indicate the vendor extension for non-Intel
> controllers as well, and having BTUSB_MSFT_VND_EXT seems to be more
> generic. What do you think?

We don’t have to have one specific way of doing it. As I said, if we ever have Zephyr based controller with MSFT extension, we have a vendor command to determine the support and the opcode. So that will not require any extra quirks or alike.

Anyhow, maybe we introduce BTUSB_MSFT_VND_EXT_FC1E that just says set the opcode to FC1E. For all other opcodes we will introduce similar constants. At most I assume we end up with 5-6 constants.

>> 
>>> +                     hdev->msft_ext.opcode = 0xFC1E;
>>> +             }
>>>      }

Regards

Marcel

