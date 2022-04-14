Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEDF5012B0
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 17:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240530AbiDNOZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 10:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343613AbiDNNuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 09:50:20 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B574A6E30;
        Thu, 14 Apr 2022 06:44:11 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id v4so6418729edl.7;
        Thu, 14 Apr 2022 06:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=5coa3OBWaIiXyJ1TJsvTvbGW8ucgi9WcCkL0M7ii1Ac=;
        b=nrNu1svoISX1APZ50+JiEAl8u9jDBuz8d9Cxyz6EuUVB/sY5Ykf1r7CgRiowPFTY7b
         Le13noEzoOmLbca8xuw39YtKrgs0gf7eyF8i9mrtfw9PfEVfNzNGnWZWLLCi7Uyu1S/R
         dkY13N/1vInqBApx9uuZC8/NyKPQnhECC1m92z8HhjLbrRs8IXLm/2ILivrKpx2n7cLZ
         +SRLPDxhRyaCwRTV3DHRoJbFxLdqC77dEBsT6JLzRN5a30di6rb3TcTuaGL80D5+ZMUr
         rfa9qUZc4fdOfvWdibJ5h82FWUEhD1TPBSUCg6qzSlS1F/dP3TLhd2LyxItRws/6H+NE
         pXvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5coa3OBWaIiXyJ1TJsvTvbGW8ucgi9WcCkL0M7ii1Ac=;
        b=FXATKJ5mMijKM6wWHzdFqlCK4ndW2L/hDWuCB88nqbhtgOAYhoJ15azNbZJlDJgZgw
         FP51ynXGtbakXVvs4fVzDSiY/luKb4nkUMBX3mMKCA+QsIygADWwLskyOCLoNTG5cGCJ
         8l3q8D0rd9wmRIosNeSKYoUHEIsgMwL18ThJSV2cOPdt2FCSoCTer7YHAHPhb8zwTnig
         pUQ0cpJGHRlT6yfP015E1IBj6qhXDFLxeY6EvnhkrTi585DkrDmJyClY4NP9dYCgRd3x
         Tg4RdqoMmvRKFQ01XYw6oYsFDztACsSZrqBXO0zDp2BJ+0mtfHIoMALZJyz6bFOkDx6F
         qgjQ==
X-Gm-Message-State: AOAM530DOHgC9fv09MUkdGDS+xM1PJ3fJvpvwHTTf4noVVnRXaUp2mTp
        SvU48P2TRcdutRufO0gpVZw=
X-Google-Smtp-Source: ABdhPJzkQUDBsDWQTu01bvGCEc2uVQV5houVOM1xZHAxz4SHp+vELS6VLTdLSUAfysTUbV9b6QBWNA==
X-Received: by 2002:a05:6402:5c9:b0:420:aac6:257b with SMTP id n9-20020a05640205c900b00420aac6257bmr3086166edx.128.1649943849435;
        Thu, 14 Apr 2022 06:44:09 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id k14-20020a50e18e000000b0041b6f23f7f6sm1039363edl.22.2022.04.14.06.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 06:44:09 -0700 (PDT)
Date:   Thu, 14 Apr 2022 16:44:06 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 01/12] net: dsa: add support for Renesas RZ/N1
 A5PSW switch tag code
Message-ID: <20220414134406.qk6zxlmsqwaamg4c@skbuf>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-2-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220414122250.158113-2-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 02:22:39PM +0200, Clément Léger wrote:
> Add DSA tag code for Renesas RZ/N1 Advanced 5 port switch. This switch
> uses a special VLAN type followed by 6 bytes which contains other
> useful information (port, timestamp, etc).
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---

Please squash this with the next patch.

>  include/net/dsa.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 934958fda962..2aa8eaae4eb9 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -53,6 +53,7 @@ struct phylink_link_state;
>  #define DSA_TAG_PROTO_SJA1110_VALUE		23
>  #define DSA_TAG_PROTO_RTL8_4_VALUE		24
>  #define DSA_TAG_PROTO_RTL8_4T_VALUE		25
> +#define DSA_TAG_PROTO_RZN1_A5PSW_VALUE		26
>  
>  enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
> @@ -81,6 +82,7 @@ enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_SJA1110		= DSA_TAG_PROTO_SJA1110_VALUE,
>  	DSA_TAG_PROTO_RTL8_4		= DSA_TAG_PROTO_RTL8_4_VALUE,
>  	DSA_TAG_PROTO_RTL8_4T		= DSA_TAG_PROTO_RTL8_4T_VALUE,
> +	DSA_TAG_PROTO_RZN1_A5PSW	= DSA_TAG_PROTO_RZN1_A5PSW_VALUE,
>  };
>  
>  struct dsa_switch;
> -- 
> 2.34.1
> 
