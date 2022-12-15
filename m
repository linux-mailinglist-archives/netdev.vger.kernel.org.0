Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BA564DEF3
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 17:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbiLOQsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 11:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiLOQsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 11:48:14 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79252A953;
        Thu, 15 Dec 2022 08:48:12 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id w23so7427916ply.12;
        Thu, 15 Dec 2022 08:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tqbyrz2HDPwuRFgnegWH1TadErj2Xf8yg6MvsofKkIQ=;
        b=Y3rjBqnkXKdqQUKDqyNOLcxf54Disfcei/kcMFNwQoS8WKUKjWGdtZNNuuWWn1Fcn2
         hkAb2X1ziEmw/EYoHIAS7cJDZDBd0hUdie3BIvphqs12+AsG+TOzFiVuPaknc4AS2RuD
         Lwy54FGuSjbSmx3DUb1Rh6Z5njDQzw/sjNIWqDlfKUL2v0oMlRyF5AgaFf9V/dyl3vHq
         TG5gJ8mI3tUqW4xWzf5ZCW4JG2E5z5+mI8+Rc+sv7NAGIJboDWdxGRxhEvu9ya7zCkfr
         rZ+IVHVDsuTc1XK951BJPBGuLquCYCUdPKBoNo2HGzQHYpYXRA0YFmufqpsh7VBnpKki
         q8IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tqbyrz2HDPwuRFgnegWH1TadErj2Xf8yg6MvsofKkIQ=;
        b=rRLzxJ+kKyBiN0zVDA2iPKHW/qoZIipxkux/sUkFt7/ZPfcRloSam3mRjHi+9zPT0r
         fdRb8iYeC9Sa10orirHG0VK3Uo+8yj+mSPmoivw/7u/fACpjQSEqslehjhwCxBwK3vDe
         L4WlrxYjT6ZCVXUjPTh4W75LfNtXCMExmqup8fDyJmQYP/IY/1EsoSPJo86sITGHPXpT
         BBEKFvR9RWNZprQJX09+jVLU+fUfFBoH+OExuFRpInNClT6kEbyNNintqHJJavT//d1k
         LS4RuQFFfIFrECwOwQNg/7JCgQ8fc5S4+u9lvAe2g9qYeCyruCichSP8bqSxeWzhPl0J
         EpwQ==
X-Gm-Message-State: ANoB5pnn/VToeruV41oJawSWCX3vlwfJxzUcCVEu9NdbeJDI2zxzGC6y
        hrKtDgb0thssdvi7ffi62Yk=
X-Google-Smtp-Source: AA0mqf7LldEBXXl/VKtVxa+Pst9zFuUCi1CSp+rkAc/esE10GQboY2il34gu9ZrUIWzfCneWWyXGUg==
X-Received: by 2002:a17:902:ecc2:b0:18b:271e:5804 with SMTP id a2-20020a170902ecc200b0018b271e5804mr50367520plh.59.1671122892250;
        Thu, 15 Dec 2022 08:48:12 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id h8-20020a170902680800b00172f6726d8esm4036366plk.277.2022.12.15.08.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 08:48:11 -0800 (PST)
Message-ID: <4d16ffd327d193f8c1f7c40f968fda90a267348e.camel@gmail.com>
Subject: Re: [PATCH v2 1/3] dsa: marvell: Provide per device information
 about max frame size
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Lukasz Majewski <lukma@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 15 Dec 2022 08:48:10 -0800
In-Reply-To: <20221215144536.3810578-1-lukma@denx.de>
References: <20221215144536.3810578-1-lukma@denx.de>
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

On Thu, 2022-12-15 at 15:45 +0100, Lukasz Majewski wrote:
> Different Marvell DSA switches support different size of max frame
> bytes to be sent.
>=20
> For example mv88e6185 supports max 1632 bytes, which is now in-driver
> standard value. On the other hand - mv88e6250 supports 2048 bytes.
>=20
> As this value is internal and may be different for each switch IC,
> new entry in struct mv88e6xxx_info has been added to store it.
>=20
> Signed-off-by: Lukasz Majewski <lukma@denx.de>
> ---
> Changes for v2:
> - Define max_frame_size with default value of 1632 bytes,
> - Set proper value for the mv88e6250 switch SoC (linkstreet) family
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 13 ++++++++++++-
>  drivers/net/dsa/mv88e6xxx/chip.h |  1 +
>  2 files changed, 13 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
> index 2ca3cbba5764..7ae4c389ce50 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -3093,7 +3093,9 @@ static int mv88e6xxx_get_max_mtu(struct dsa_switch =
*ds, int port)
>  	if (chip->info->ops->port_set_jumbo_size)
>  		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
>  	else if (chip->info->ops->set_max_frame_size)
> -		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
> +		return (chip->info->max_frame_size  - VLAN_ETH_HLEN
> +			- EDSA_HLEN - ETH_FCS_LEN);
> +
>  	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
>  }
>=20
>=20

Is there any specific reason for triggering this based on the existance
of the function call? Why not just replace:
	else if (chip->info->ops->set_max_frame_size)
with:
	else if (chip->info->max_frame_size)

Otherwise my concern is one gets defined without the other leading to a
future issue as 0 - extra headers will likely wrap and while the return
value may be a signed int, it is usually stored in an unsigned int so
it would effectively uncap the MTU.

Actually you could take this one step further since all values should
be 1522 or greater you could just drop the else/if and replace the last
line with "max_t(int, chip->info->max_frame_size, 1522) - (headers)".
