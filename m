Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94A1690C21
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 15:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjBIOrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 09:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjBIOrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 09:47:17 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAAD402CD;
        Thu,  9 Feb 2023 06:47:15 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id c26so2248281ejz.10;
        Thu, 09 Feb 2023 06:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JA1dtStn/FELPiXnU/VmDeB+f/rDJ8+vPh28Fy48pYw=;
        b=b+S+v7yTsIIFc/qiVsiiGUPhm8BFWv9mKu53Sg0WaIwcDvnkRKVPnCSgU3m89ijvT3
         W2bLTq6OrlX9Dt+xg80VrF/gYR3PQdlIIhj67Sr4iAYqKg1IKTSCJ0qZxYrpQR4ctTkL
         9/1IVt3SWTkXa/R1lqrQzb2Tzj0YpVc8OIAPXabutA+l/zW1sPVgAYEFTfTL92GW472j
         3eSs0jjKVyyS26r9UZrqQF/Y4982O5GOzfPnz6FyVQlpkhVnJOT3TJQuj/ITzQPR1hzm
         1LXGu3crCUn09Fmx0JvaWbW76ZrcCRSqYw+44lsgRMyvrIFubKxxyxpE9Hf/rPnPghnh
         EgHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JA1dtStn/FELPiXnU/VmDeB+f/rDJ8+vPh28Fy48pYw=;
        b=O0lqMiBGU1eEjHPNmzXYrSLdwFhKd+eTcFcElJdC2U3eCOWlYIL+81OviQMh95KG+6
         YLGH6uaZPO52V2oLNBStQGDNbhW4yvKuw0svVFZW4JQOkXZwzCAhGHZHj6na42tWucJe
         ccZfSyK6bkNxIcSTSxVNUmcAYInawXaXx4Gb2B4VjlfJOPhqrx/F+FUY5eD42GRW6RSF
         Bk2wr3gPtosbwVkzBnsSjTOTuhX44NbE30u1EYdO1VbZTjLa7dd7HWAEvWZrjoI8Rnsz
         y31VViPZt67sfFTJC6P1ygXYSMyt1CwGnnmzeJ5v69GlDRptiwszQB3EJoTuXtff8X7s
         04Pg==
X-Gm-Message-State: AO0yUKUyBz3tjS9O/0j/za9Qmd9F979Sz5shYBKstsw/IWBBHW0vi8hP
        qAblaqJueIEXcW2a0cAFJXA=
X-Google-Smtp-Source: AK7set8+Nd1FHDML75QGlIUrQhfdsOT1PjTWh9yS5jCBDzIQINv4qGXDpxa2gKhyOMQDukzv7zCOmg==
X-Received: by 2002:a17:907:a391:b0:8a9:f870:d25b with SMTP id se17-20020a170907a39100b008a9f870d25bmr11247487ejc.15.1675954034537;
        Thu, 09 Feb 2023 06:47:14 -0800 (PST)
Received: from sakura.myxoz.lan (81-230-97-204-no2390.tbcn.telia.com. [81.230.97.204])
        by smtp.gmail.com with ESMTPSA id fi9-20020a170906da0900b0084c6ec69a9dsm950533ejb.124.2023.02.09.06.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 06:47:13 -0800 (PST)
Message-ID: <23e899f83c4f05a18deb2f86047d57d941205374.camel@gmail.com>
Subject: Re: [PATCH v2] net/usb: kalmia: Fix uninit-value in
 kalmia_send_init_packet
From:   Miko Larsson <mikoxyzzz@gmail.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
Date:   Thu, 09 Feb 2023 15:47:12 +0100
In-Reply-To: <Y9pY61y1nwTuzMOa@nanopsycho>
References: <7266fe67c835f90e5c257129014a63e79e849ef9.camel@gmail.com>
         <f0b62f38c042d2dcb8b8e83c827d76db2ac5d7ad.camel@gmail.com>
         <Y9pY61y1nwTuzMOa@nanopsycho>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.module_f37+15877+cf3308f9) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-02-01 at 13:19 +0100, Jiri Pirko wrote:
> Tue, Jan 31, 2023 at 03:20:33PM CET, mikoxyzzz@gmail.com=C2=A0wrote:
> > syzbot reports that act_len in kalmia_send_init_packet() is
> > uninitialized. Fix this by initializing it to 0.
> >=20
> > Fixes: d40261236e8e ("net/usb: Add Samsung Kalmia driver for
> > Samsung GT-B3730")
> > Reported-and-tested-by:
> > syzbot+cd80c5ef5121bfe85b55@syzkaller.appspotmail.com
> > Signed-off-by: Miko Larsson <mikoxyzzz@gmail.com>
> > ---
> > v1 -> v2
> > * Minor alteration of commit message.
> > * Added 'reported-and-tested-by' which is attributed to syzbot.
> >=20
> > drivers/net/usb/kalmia.c | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/net/usb/kalmia.c b/drivers/net/usb/kalmia.c
> > index 9f2b70ef39aa..b158fb7bf66a 100644
> > --- a/drivers/net/usb/kalmia.c
> > +++ b/drivers/net/usb/kalmia.c
> > @@ -56,7 +56,7 @@ static int
> > kalmia_send_init_packet(struct usbnet *dev, u8 *init_msg, u8
> > init_msg_len,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u8 *buffer, u8 expected=
_len)
> > {
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int act_len;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int act_len =3D 0;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int status;
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0netdev_dbg(dev->net, "S=
ending init packet");
>=20
> Hmm, this is not the right fix.
>=20
> If the second call of usb_bulk_msg() in this function returns !=3D 0,
> the
> act_len printed out contains the value from previous usb_bulk_msg()
> call,
> which does not make sense.
>=20
> Printing act_len on error path is pointless, so rather remove it from
> the error message entirely for both usb_bulk_msg() calls.

Something like this, then?

diff --git a/drivers/net/usb/kalmia.c b/drivers/net/usb/kalmia.c
index 9f2b70ef39aa..613fc6910f14 100644
--- a/drivers/net/usb/kalmia.c
+++ b/drivers/net/usb/kalmia.c
@@ -65,8 +65,8 @@ kalmia_send_init_packet(struct usbnet *dev, u8 *init_msg,=
 u8 init_msg_len,
 		init_msg, init_msg_len, &act_len, KALMIA_USB_TIMEOUT);
 	if (status !=3D 0) {
 		netdev_err(dev->net,
-			"Error sending init packet. Status %i, length %i\n",
-			status, act_len);
+			"Error sending init packet. Status %i\n",
+			status);
 		return status;
 	}
 	else if (act_len !=3D init_msg_len) {
@@ -83,8 +83,8 @@ kalmia_send_init_packet(struct usbnet *dev, u8 *init_msg,=
 u8 init_msg_len,
=20
 	if (status !=3D 0)
 		netdev_err(dev->net,
-			"Error receiving init result. Status %i, length %i\n",
-			status, act_len);
+			"Error receiving init result. Status %i\n",
+			status);
 	else if (act_len !=3D expected_len)
 		netdev_err(dev->net, "Unexpected init result length: %i\n",
 			act_len);

--=20
~miko
