Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F8759E41C
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 15:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241357AbiHWNSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 09:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241289AbiHWNSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 09:18:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF83B804A7
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661249800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ug9ScV+eP+woSlkFWqhtmkaaga2yb/zevxvR9PDPku0=;
        b=WbbaHTsvGtham3dyQeaAItj/eLqX0pjuJ7eR9QRe9xt8JY38Xfk9EkQ9vKkUTJ/g0Jfco3
        Kv57YlyJaXAVSeuhL01lg6ZnZH7oxbXhv4ANw83LNfuMH9+4xe4ezCWlBvHrwIZFMhDbXf
        WX+Fvhw1VbPS+yk/TiQ67lOHYdGXlN8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-365-QWd7hNz9N2yIdIibD8ezYQ-1; Tue, 23 Aug 2022 06:16:39 -0400
X-MC-Unique: QWd7hNz9N2yIdIibD8ezYQ-1
Received: by mail-wm1-f70.google.com with SMTP id j3-20020a05600c1c0300b003a5e72421c2so511263wms.1
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:16:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc;
        bh=Ug9ScV+eP+woSlkFWqhtmkaaga2yb/zevxvR9PDPku0=;
        b=MpzW4NAp2RmzkPe5cIg13G2F95Q81ZtPtxlMYbIgZ1gZhWjo0kQONJxkK0/kSxh1oz
         8gUPRErV1hTfWvjZnuztWJm1pf23cvDJHgyPP6G4XW3KMJhDQJpJ6bQLcCxwt1KQIaAZ
         2wLCBUpHiGy6+xKoQy/C1OpUJkyWSqY745Xw90ft/t2zbB84tZpDaF5OKVRn7QgyscVA
         A7blCHQCDYNOVmmjsm8K1b9NzK31Shf2/6E1ZiyzYvpoTPQ62M69YGHtL8ao84QZ4GD4
         oVfsBUrPTH07uo8eKwc2Mkj8qRA6AXkwqsiIDrmdkkkG6I9r+nJ1bn9qa5XSYK+AFsux
         R4gQ==
X-Gm-Message-State: ACgBeo3ODYzcHeU3jufkJKPeTPxNSHSfWlUWyS3SSL1kuV6v8AuMn0iF
        CRtIZNFpV9+gaFyLf02kLrCk4eFY+RWLiXbC3BOgCPTZkbI+GUztUdXmBCfJMQWzMAh/Yxy8OzQ
        2SgIbcsM17GifkwNi
X-Received: by 2002:a5d:47ca:0:b0:220:5cbc:1c59 with SMTP id o10-20020a5d47ca000000b002205cbc1c59mr12877116wrc.662.1661249798441;
        Tue, 23 Aug 2022 03:16:38 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5mBXOkByvXcs2vkeZjlHWZPAo/Qp1n9gB8bbvak42A0p6/hYeoFPSIPDEkRvQuMVth4NCjZw==
X-Received: by 2002:a5d:47ca:0:b0:220:5cbc:1c59 with SMTP id o10-20020a5d47ca000000b002205cbc1c59mr12877103wrc.662.1661249798144;
        Tue, 23 Aug 2022 03:16:38 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-176.dyn.eolo.it. [146.241.97.176])
        by smtp.gmail.com with ESMTPSA id p16-20020a05600c1d9000b003a60ff7c082sm21277832wms.15.2022.08.23.03.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 03:16:37 -0700 (PDT)
Message-ID: <1f647343d0755f9ba0deabb98cd83bf32f0c9d36.camel@redhat.com>
Subject: Re: [PATCH net-next 3/5] r8169: remove support for chip version 49
From:   Paolo Abeni <pabeni@redhat.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Tue, 23 Aug 2022 12:16:36 +0200
In-Reply-To: <470b2f1c-54bd-f6e9-1398-64d0cc204684@gmail.com>
References: <e3d2fc9d-3ce7-b545-9cd1-6ad9fbe0adb7@gmail.com>
         <470b2f1c-54bd-f6e9-1398-64d0cc204684@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-08-20 at 15:53 +0200, Heiner Kallweit wrote:
> Detection of this chip version has been disabled for few kernel versions now.
> Nobody complained, so remove support for this chip version.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169.h          |  2 +-
>  drivers/net/ethernet/realtek/r8169_main.c     | 26 ++-----------------
>  .../net/ethernet/realtek/r8169_phy_config.c   | 22 ----------------
>  3 files changed, 3 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
> index a66b10850..7c85c4696 100644
> --- a/drivers/net/ethernet/realtek/r8169.h
> +++ b/drivers/net/ethernet/realtek/r8169.h
> @@ -59,7 +59,7 @@ enum mac_version {
>  	RTL_GIGA_MAC_VER_46,
>  	/* support for RTL_GIGA_MAC_VER_47 has been removed */
>  	RTL_GIGA_MAC_VER_48,
> -	RTL_GIGA_MAC_VER_49,
> +	/* support for RTL_GIGA_MAC_VER_49 has been removed */
>  	RTL_GIGA_MAC_VER_50,
>  	RTL_GIGA_MAC_VER_51,
>  	RTL_GIGA_MAC_VER_52,
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 0e7d10cd6..b22b80aab 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -134,7 +134,6 @@ static const struct {
>  	[RTL_GIGA_MAC_VER_44] = {"RTL8411b",		FIRMWARE_8411_2 },
>  	[RTL_GIGA_MAC_VER_46] = {"RTL8168h/8111h",	FIRMWARE_8168H_2},
>  	[RTL_GIGA_MAC_VER_48] = {"RTL8107e",		FIRMWARE_8107E_2},
> -	[RTL_GIGA_MAC_VER_49] = {"RTL8168ep/8111ep"			},
>  	[RTL_GIGA_MAC_VER_50] = {"RTL8168ep/8111ep"			},
>  	[RTL_GIGA_MAC_VER_51] = {"RTL8168ep/8111ep"			},
>  	[RTL_GIGA_MAC_VER_52] = {"RTL8168fp/RTL8117",  FIRMWARE_8168FP_3},
> @@ -885,7 +884,6 @@ static void rtl8168g_phy_suspend_quirk(struct rtl8169_private *tp, int value)
>  {
>  	switch (tp->mac_version) {
>  	case RTL_GIGA_MAC_VER_40:
> -	case RTL_GIGA_MAC_VER_49:
>  		if (value & BMCR_RESET || !(value & BMCR_PDOWN))
>  			rtl_eri_set_bits(tp, 0x1a8, 0xfc000000);
>  		else
> @@ -1199,7 +1197,7 @@ static enum rtl_dash_type rtl_check_dash(struct rtl8169_private *tp)
>  	case RTL_GIGA_MAC_VER_28:
>  	case RTL_GIGA_MAC_VER_31:
>  		return r8168dp_check_dash(tp) ? RTL_DASH_DP : RTL_DASH_NONE;
> -	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_53:
> +	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_53:

The above chunk looks incorrect. I think should be:
	case RTL_GIGA_MAC_VER_50 ... RTL_GIGA_MAC_VER_53:

instead.

Thanks!

Paolo

