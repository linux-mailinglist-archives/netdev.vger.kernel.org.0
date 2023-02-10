Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A45E6922F8
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 17:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbjBJQIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 11:08:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbjBJQIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 11:08:48 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10ACC1B312;
        Fri, 10 Feb 2023 08:08:48 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id m2so6952073plg.4;
        Fri, 10 Feb 2023 08:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SksRv/MqmI2Y27K3OdBm7ZwaCQAbGWalSsnSFZ595T8=;
        b=atDGbnDgMtGZSL2XHd/DHAbcb7c5uR7FLQhSHXVHTmITpgo1YRJ6wAx7SmylIzO6Tw
         y/wjXvvfpRyLIEUEl4VCNASwuZv7Xwh7I0Ouq+uoQYmwcmU7JEiF8UqEEHWfPXPQd/Q/
         N7gum0uxMoukW6JF2/w675/12xN8mqUcvKWM3DcyuwXVVqz9WAtbozpi92mXkzvbwl/k
         VdftkmsRgPRy4//1ElBBIFXRLrZ5b/Z5N1Emr0q9IR9DajZ1RcAYFhNxnT91L62M2kBL
         DQbwzR+gfAyQbWOTOlpvdU1Nzyzxc5ZoSRINquF1J309nWji06dnjaF3UY5i3eVgGV4S
         dhzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SksRv/MqmI2Y27K3OdBm7ZwaCQAbGWalSsnSFZ595T8=;
        b=w3jorLdpe5kYktW4H/X+y6FhcrrvEWmJQ5Tf9R1XAS2U0pc2t/vLjA4+dUZsEjOa/x
         7gLrD0wT+nTaU0zWXoYthXvN0yLM2cSLoy1Y4CTJBQU4bcuJzO0UWYMLAweia8UaKUcj
         Bwe0aAjohI4V32KN7kUls0VZSv71QMG+0uDj2mMO/QSLf3p+JxwyocuEvr9ixaehVPU2
         vwXVQ97s+OYilEmzhfdaLV8MXtNVijtMfReQCL9X2ICpfiiJfZC8DZiat6qrJTT92v6x
         /M/5P7npDykkqHDeJhD8gAOTLlk/cVu6QHUyCI6BOGkAHZyhLECwGzRIFhb6YvwoK/p+
         Lf7Q==
X-Gm-Message-State: AO0yUKVyBOooNJqq6FRWMC8qEr8m9WYWRXcnNXxaI57Pr7mDMFwwovhr
        oPSdLZph5OCm8L1h1k5ET2k=
X-Google-Smtp-Source: AK7set8z5Wu+zKNHqGExvUyupndq/KgDNy33cKoHPFqcX9TbDA74lp7v1Bc5Wj8nazMwlYNsnLR5+g==
X-Received: by 2002:a17:903:41cd:b0:19a:6f28:ec2c with SMTP id u13-20020a17090341cd00b0019a6f28ec2cmr4785754ple.62.1676045327374;
        Fri, 10 Feb 2023 08:08:47 -0800 (PST)
Received: from [192.168.0.128] ([98.97.119.54])
        by smtp.googlemail.com with ESMTPSA id jk14-20020a170903330e00b001993c1a42dbsm3560151plb.206.2023.02.10.08.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 08:08:46 -0800 (PST)
Message-ID: <9dc8b8dbfaf021af262ba349b8b92dab7962d8c4.camel@gmail.com>
Subject: Re: [PATCH] net/usb: kalmia: Don't pass act_len in usb_bulk_msg
 error path
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Miko Larsson <mikoxyzzz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, Paolo Abeni <pabeni@redhat.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Date:   Fri, 10 Feb 2023 08:08:45 -0800
In-Reply-To: <2f74aab82a40e4c11c91ccba40f5b620f6cb209c.camel@gmail.com>
References: <7266fe67c835f90e5c257129014a63e79e849ef9.camel@gmail.com>
         <f0b62f38c042d2dcb8b8e83c827d76db2ac5d7ad.camel@gmail.com>
         <2f74aab82a40e4c11c91ccba40f5b620f6cb209c.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
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

On Fri, 2023-02-10 at 09:13 +0100, Miko Larsson wrote:
> syzbot reported that act_len in kalmia_send_init_packet() is
> uninitialized when passing it to the first usb_bulk_msg error path. Jiri
> Pirko noted that it's pointless to pass it in the error path, and that
> the value that would be printed in the second error path would be the
> value of act_len from the first call to usb_bulk_msg.[1]
>=20
> With this in mind, let's just not pass act_len to the usb_bulk_msg error
> paths.
>=20
> 1: https://lore.kernel.org/lkml/Y9pY61y1nwTuzMOa@nanopsycho/
>=20
> Fixes: d40261236e8e ("net/usb: Add Samsung Kalmia driver for Samsung GT-B=
3730")
> Reported-and-tested-by: syzbot+cd80c5ef5121bfe85b55@syzkaller.appspotmail=
.com
> Signed-off-by: Miko Larsson <mikoxyzzz@gmail.com>
> ---
>  drivers/net/usb/kalmia.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/usb/kalmia.c b/drivers/net/usb/kalmia.c
> index 9f2b70ef39aa..613fc6910f14 100644
> --- a/drivers/net/usb/kalmia.c
> +++ b/drivers/net/usb/kalmia.c
> @@ -65,8 +65,8 @@ kalmia_send_init_packet(struct usbnet *dev, u8 *init_ms=
g, u8 init_msg_len,
>  		init_msg, init_msg_len, &act_len, KALMIA_USB_TIMEOUT);
>  	if (status !=3D 0) {
>  		netdev_err(dev->net,
> -			"Error sending init packet. Status %i, length %i\n",
> -			status, act_len);
> +			"Error sending init packet. Status %i\n",
> +			status);
>  		return status;
>  	}
>  	else if (act_len !=3D init_msg_len) {
> @@ -83,8 +83,8 @@ kalmia_send_init_packet(struct usbnet *dev, u8 *init_ms=
g, u8 init_msg_len,
> =20
>  	if (status !=3D 0)
>  		netdev_err(dev->net,
> -			"Error receiving init result. Status %i, length %i\n",
> -			status, act_len);
> +			"Error receiving init result. Status %i\n",
> +			status);
>  	else if (act_len !=3D expected_len)
>  		netdev_err(dev->net, "Unexpected init result length: %i\n",
>  			act_len);

Makes sense to me since the only possible return values for act_len
appear to be either uninitialized or 0 depending on where it fails.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

