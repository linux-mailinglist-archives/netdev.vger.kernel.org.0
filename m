Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342451CC7AF
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 09:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgEJHl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 03:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgEJHl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 03:41:28 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F655C061A0C;
        Sun, 10 May 2020 00:41:27 -0700 (PDT)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 04A7fH88024809
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sun, 10 May 2020 09:41:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1589096478; bh=0ektno/eixWqJUCCiVzDc/aHhKtbibJjf6a3mIpikDc=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=olgW/Ws8kwtuB8HJdniFdFLhEJC7qutQa4C36OHLCmbDH3Img5r70ZHnXUO+z1LV1
         49+FwDwaK47stz/ZyUhlq8cvlPoAxYkI75f+iLdOnrdomu0eH1Z6OekEd8J5Pdpc0W
         kVpLq7wQ19uIiYBYArnnxOOc+4fhZ5hih+0ocK9k=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@mork.no>)
        id 1jXgaK-0008K3-RX; Sun, 10 May 2020 09:41:16 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: qmi_wwan: remove redundant assignment to variable status
Organization: m
References: <20200509215756.506840-1-colin.king@canonical.com>
        <20200509215756.506840-2-colin.king@canonical.com>
Date:   Sun, 10 May 2020 09:41:16 +0200
In-Reply-To: <20200509215756.506840-2-colin.king@canonical.com> (Colin King's
        message of "Sat, 9 May 2020 22:57:56 +0100")
Message-ID: <87a72gck4j.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.2 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> writes:

> From: Colin Ian King <colin.king@canonical.com>
>
> The variable status is being initializeed with a value that is never read
> and it is being updated later with a new value. The initialization
> is redundant and can be removed.
>
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/usb/qmi_wwan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 4bb8552a00d3..b0eab6e5279d 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -719,7 +719,7 @@ static int qmi_wwan_change_dtr(struct usbnet *dev, bo=
ol on)
>=20=20
>  static int qmi_wwan_bind(struct usbnet *dev, struct usb_interface *intf)
>  {
> -	int status =3D -1;
> +	int status;
>  	u8 *buf =3D intf->cur_altsetting->extra;
>  	int len =3D intf->cur_altsetting->extralen;
>  	struct usb_interface_descriptor *desc =3D &intf->cur_altsetting->desc;


Yes, looks like this initialization was made redundant when the CDC
descriptor parsing was moved to usbcore. Thanks.

Adding Fixes for documentation only, not as a stable hint.  This is
cleanup only and not suitable for stable IMHO.

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
Fixes: 8492ed45aa5d ("qmi-wwan: use common parser")
