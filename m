Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95910526F8C
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiENByd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 21:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiENByb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 21:54:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63883E96F8;
        Fri, 13 May 2022 16:56:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC33E61886;
        Fri, 13 May 2022 23:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0BFC385AA;
        Fri, 13 May 2022 23:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652486149;
        bh=CJKAmPqm12fVzfJjZZGPW/HI/KKYeiwMgwg0OgeyvWs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cChnpewBc6oesIl+tdA8nJedFkjYaJaBfUZx0xBI+TY3y7esVgVYqZsx4wrYzXONw
         oCVF/gO/sKHbardb0WtqQsTIhmTbDdbGjO4dpMsXjtrekwVOUbl0Hx/HYOIoIqgXec
         /aRrgsJAqPIDDvc6vxXExViSE268lGrsOjkZlHFOQwP2Jq43SnK/XB8bVd+VQLtpcq
         vyOp80+wt8MjpoQevvueNn8eGz0tagpN3STqopBrBkLG7VYAZRWSNJGNm6XHptiqaF
         xpHsNZMdiYh7+BtNfm8fQDAaqZnHj+5CQbr0erLu9asipwqsnIWAjfoYh8ywgsHq0+
         cfQfBABfZDAnA==
Date:   Fri, 13 May 2022 16:55:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ober <dober6023@gmail.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, aaron.ma@canonical.com,
        markpearson@lenovo.com, dober@lenovo.com
Subject: Re: [PATCH v4] net: usb: r8152: Add in new Devices that are
 supported for Mac-Passthru
Message-ID: <20220513165547.03d1c778@kernel.org>
In-Reply-To: <20220513124906.402630-1-dober6023@gmail.com>
References: <20220513124906.402630-1-dober6023@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 May 2022 08:49:06 -0400 David Ober wrote:
> Lenovo Thunderbolt 4 Dock, and other Lenovo USB Docks are using the
> original Realtek USB ethernet Vendor and Product IDs
> If the Network device is Realtek verify that it is on a Lenovo USB hub
> before enabling the passthru feature
>=20
> This also adds in the device IDs for the Lenovo USB Dongle and one other
> USB-C dock
>=20
> V2 fix formating of code
> V3 remove Generic define for Device ID 0x8153 and change it to use value
> V4 rearrange defines and case statement to put them in better order
>=20
> Signed-off-by: David Ober <dober6023@gmail.com>
> ---
>  drivers/net/usb/r8152.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index c2da3438387c..d8f2d4b85db4 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -771,7 +771,9 @@ enum rtl8152_flags {
>  };
> =20
>  #define DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2	0x3082
> +#define DEVICE_ID_THINKPAD_USB_C_DONGLE			0x720c
>  #define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2		0xa387
> +#define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN3		0x3062
> =20
>  struct tally_counter {
>  	__le64	tx_packets;
> @@ -9646,6 +9648,14 @@ static int rtl8152_probe(struct usb_interface *int=
f,
>  		switch (le16_to_cpu(udev->descriptor.idProduct)) {
>  		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
>  		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
> +		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN3:
> +		case DEVICE_ID_THINKPAD_USB_C_DONGLE:
> +			tp->lenovo_macpassthru =3D 1;
> +		}
> +	} else if ((le16_to_cpu(udev->descriptor.idVendor) =3D=3D VENDOR_ID_REA=
LTEK) &&
> +		   (le16_to_cpu(udev->parent->descriptor.idVendor) =3D=3D VENDOR_ID_LE=
NOVO)) {

The parenthesis around the condition are unnecessary. If the compiler
does not warn it's okay to skip parenthesis. checkpatch should warn
about this. We assume kernel developers know the C operator precedence.

I think you should factor these checks out to a separate helper tho.
Create a helper like:

static bool rtl8152_needs_lenovo_macpassthru(dev)

that can use local variables to avoid the tediously long and repeated
le16_to_cpu(...) lines. Then just assign:

	tp->lenovo_macpassthru =3D rtl8152_needs_lenovo_macpassthru(dev);

Please CC Bj=C3=B8rn Mork <bjorn@mork.no> since he commented on the previous
version. I'd personally also love to see this solved in user space...
but have no clear idea how.

> +		switch (le16_to_cpu(udev->descriptor.idProduct)) {
> +		case 0x8153:
>  			tp->lenovo_macpassthru =3D 1;
>  		}
>  	}

