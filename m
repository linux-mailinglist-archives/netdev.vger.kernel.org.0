Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03E76547F0
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 22:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbiLVVhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 16:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiLVVhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 16:37:38 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2059023307;
        Thu, 22 Dec 2022 13:37:36 -0800 (PST)
Date:   Thu, 22 Dec 2022 16:37:21 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=t-8ch.de; s=mail;
        t=1671745054; bh=taNf+JuA+NAMhycQCNzWXEG5n+O4upNWA9xFd9MUSiU=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=cZ9SMaJMjee/jh8Z3sJJPaJy1Es9jq25h0S9RFBgt3MtxIo6FXWx1OmpvhrCeb0q0
         ozCZINowrizahr0OY7i8872tpZrBihliRxFepbQb+ppUSTu49yqQW7jRs5mcKhGmuF
         GJ71lbAXU6F64GGQUN+GtpfTY16XDjuca6z3ja+o=
From:   =?UTF-8?Q?Thomas_Wei=C3=9Fschuh_?= <thomas@t-8ch.de>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <4d42a44d-e0f3-4d01-8564-267d0f3f061a@t-8ch.de>
In-Reply-To: <CAO-hwJL+zenkC+qPuPWLO-dFkg_pWoGTQYXR5mzSqUrnX6MObA@mail.gmail.com>
References: <20221222-hid-v1-0-f4a6c35487a5@weissschuh.net> <20221222-hid-v1-2-f4a6c35487a5@weissschuh.net> <CAO-hwJL+zenkC+qPuPWLO-dFkg_pWoGTQYXR5mzSqUrnX6MObA@mail.gmail.com>
Subject: Re: [PATCH 2/8] HID: usbhid: Make hid_is_usb() non-inline
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <4d42a44d-e0f3-4d01-8564-267d0f3f061a@t-8ch.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Dec 22, 2022 16:13:06 Benjamin Tissoires <benjamin.tissoires@redhat.com>:

> On Thu, Dec 22, 2022 at 6:16 AM Thomas Wei=C3=9Fschuh <linux@weissschuh.n=
et> wrote:
>>
>> By making hid_is_usb() a non-inline function the lowlevel usbhid driver
>> does not have to be exported anymore.
>>
>> Also mark the argument as const as it is not modified.
>>
>> Signed-off-by: Thomas Wei=C3=9Fschuh <linux@weissschuh.net>
>> ---
>> drivers/hid/usbhid/hid-core.c | 6 ++++++
>> include/linux/hid.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 | 5 +----
>> 2 files changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core=
.c
>> index be4c731aaa65..54b0280d0073 100644
>> --- a/drivers/hid/usbhid/hid-core.c
>> +++ b/drivers/hid/usbhid/hid-core.c
>> @@ -1334,6 +1334,12 @@ struct hid_ll_driver usb_hid_driver =3D {
>> };
>> EXPORT_SYMBOL_GPL(usb_hid_driver);
>>
>> +bool hid_is_usb(const struct hid_device *hdev)
>> +{
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return hdev->ll_driver =3D=3D &usb=
_hid_driver;
>> +}
>> +EXPORT_SYMBOL_GPL(hid_is_usb);
>> +
>> static int usbhid_probe(struct usb_interface *intf, const struct usb_dev=
ice_id *id)
>> {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct usb_host_interface *in=
terface =3D intf->cur_altsetting;
>> diff --git a/include/linux/hid.h b/include/linux/hid.h
>> index 8677ae38599e..e8400aa78522 100644
>> --- a/include/linux/hid.h
>> +++ b/include/linux/hid.h
>> @@ -864,10 +864,7 @@ static inline bool hid_is_using_ll_driver(struct hi=
d_device *hdev,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return hdev->ll_driver =3D=3D=
 driver;
>> }
>>
>> -static inline bool hid_is_usb(struct hid_device *hdev)
>> -{
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return hid_is_using_ll_driver(hdev=
, &usb_hid_driver);
>> -}
>> +extern bool hid_is_usb(const struct hid_device *hdev);
>
> The problem here is that CONFIG_USB_HID can be set to either m or n.
> In the n case, you'll end up with an undefined symbol, in the m case,
> it won't link too if CONFIG_HID is set to Y (and it'll be quite a mess
> to call it if the module is not loaded yet).

Shouldn't we already have the same problem with
the symbol usb_hid_driver itself that is defined
right next to the new hid_is_usb()?

Thomas

>>
>> #define=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 PM_HINT_FULLON=C2=A0 1=
<<5
>> #define PM_HINT_NORMAL 1<<1
>>
>> --
>> 2.39.0
>>

