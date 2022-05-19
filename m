Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C51F52DCAD
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 20:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243856AbiESSYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 14:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243851AbiESSYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 14:24:39 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF7DEAD3D;
        Thu, 19 May 2022 11:24:38 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id c12so7977302eds.10;
        Thu, 19 May 2022 11:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=FWPD97cb8S73dntadkkurTxu7r8LXYywfF/bwbTXOx0=;
        b=aJ7gnWzJsrDBi/w2joafUjA7zOHjzUeqgdE2uEjE8QuVpqMbPMvHh/tpz8akuiXbKE
         cKW0BpY2qfrd0pTczmdcvMOeE7UU/7R7uQw1c+JiSDMJ66wD6/qmV4QAVg5bs7Qs8PUi
         trNL82H224lOgZ1Of8LZhiWNW3/DpgLOAvrskY3hNOZGRJvuzl0mXQJT2q6KryzveOVs
         9W0Owse0kbAZ4DGNVswUsBWN2+e20FNXXbB4VKw5Fp3EeylYhA8fCTQRa95doBf9o85O
         VofRU9azL4rl8Lbj8uJ6RduSwrdXW4oyeT4kBVVbx+In3ll7YHyNXjPudIVZqMWfcxRf
         4EXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=FWPD97cb8S73dntadkkurTxu7r8LXYywfF/bwbTXOx0=;
        b=wWlaf36qMWhJBETMeVXj0EjKnxV6XVNjuEM4XtDA0ZaHgPjaXB7NEvpoSEmd0mhljX
         kYd+qaJteODEtt8oKJtjFEGja8GU8wkS3w9p5MIVHPr6iek+R3YTKiY6rYVHCGnLacJn
         Dx0ppUChnq4V4E4+sZC0d4mGp1POqr1qBDBUX/dAXS4fIyrgKpy487NOTfqUJhiij7C3
         WDsq2JfBwtWsKSe0EkWWKjBoHxfcPbaevKJW/5qsQRHiHpnUE76rs5nzLZqQEdaipfK5
         TRU+G0i9dGI+jq5rehVsASP0ocl2vaN0vTqz6CnZJAF13yLkN3yTRgkCCCfcQSuy5ZhB
         GEPw==
X-Gm-Message-State: AOAM5334nHDhvuHgVLAJHOt4hqVIU54k1cgPOjWwSIHZgh5MhpyA0h7y
        /1Frp16CmUD/fUA4US0WMOA=
X-Google-Smtp-Source: ABdhPJxHy8T7Shze22UGB/kayCDpRB32BDswmmz82apYxAY9sJl2ae5VWNQEW/AxETs6nkM3jo44MQ==
X-Received: by 2002:a05:6402:50d1:b0:42b:c3e:d71e with SMTP id h17-20020a05640250d100b0042b0c3ed71emr2343989edb.144.1652984677093;
        Thu, 19 May 2022 11:24:37 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id h13-20020aa7c60d000000b0042ab649183asm3128709edq.35.2022.05.19.11.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 11:24:36 -0700 (PDT)
Date:   Thu, 19 May 2022 21:24:34 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v5 08/13] net: dsa: rzn1-a5psw: add statistics
 support
Message-ID: <20220519182434.ncjyoelgndvoev33@skbuf>
References: <20220519153107.696864-1-clement.leger@bootlin.com>
 <20220519153107.696864-9-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220519153107.696864-9-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 05:31:02PM +0200, Clément Léger wrote:
> diff --git a/drivers/net/dsa/rzn1_a5psw.h b/drivers/net/dsa/rzn1_a5psw.h
> index 306cab55db24..649165d37fde 100644
> --- a/drivers/net/dsa/rzn1_a5psw.h
> +++ b/drivers/net/dsa/rzn1_a5psw.h
> @@ -146,7 +146,50 @@
>  
>  #define A5PSW_STATS_HIWORD		0x900
>  
> -#define A5PSW_DUMMY_WORKAROUND		0x5000
> +/* Stats */
> +#define A5PSW_aFramesTransmittedOK		0x868
> +#define A5PSW_aFramesReceivedOK			0x86C
> +#define A5PSW_aFrameCheckSequenceErrors		0x870
> +#define A5PSW_aAlignmentErrors			0x874
> +#define A5PSW_aOctetsTransmittedOK		0x878
> +#define A5PSW_aOctetsReceivedOK			0x87C
> +#define A5PSW_aTxPAUSEMACCtrlFrames		0x880
> +#define A5PSW_aRxPAUSEMACCtrlFrames		0x884
> +	/* If */

It would probably be good to keep the same alignment for all comments here.

> +#define A5PSW_ifInErrors			0x888
> +#define A5PSW_ifOutErrors			0x88C
> +#define A5PSW_ifInUcastPkts			0x890
> +#define A5PSW_ifInMulticastPkts			0x894
> +#define A5PSW_ifInBroadcastPkts			0x898
> +#define A5PSW_ifOutDiscards			0x89C
> +#define A5PSW_ifOutUcastPkts			0x8A0
> +#define A5PSW_ifOutMulticastPkts		0x8A4
> +#define A5PSW_ifOutBroadcastPkts		0x8A8
> +	/* Ether */
> +#define A5PSW_etherStatsDropEvents		0x8AC
> +#define A5PSW_etherStatsOctets			0x8B0
> +#define A5PSW_etherStatsPkts			0x8B4
> +#define A5PSW_etherStatsUndersizePkts		0x8B8
> +#define A5PSW_etherStatsOversizePkts		0x8BC
> +#define A5PSW_etherStatsPkts64Octets		0x8C0
> +#define A5PSW_etherStatsPkts65to127Octets	0x8C4
> +#define A5PSW_etherStatsPkts128to255Octets	0x8C8
> +#define A5PSW_etherStatsPkts256to511Octets	0x8CC
> +#define A5PSW_etherStatsPkts512to1023Octets	0x8D0
> +#define A5PSW_etherStatsPkts1024to1518Octets	0x8D4
> +#define A5PSW_etherStatsPkts1519toXOctets	0x8D8
> +#define A5PSW_etherStatsJabbers			0x8DC
> +#define A5PSW_etherStatsFragments		0x8E0
> +
> +#define A5PSW_VLANReceived			0x8E8
> +#define A5PSW_VLANTransmitted			0x8EC
> +
> +#define A5PSW_aDeferred				0x910
> +#define A5PSW_aMultipleCollisions		0x914
> +#define A5PSW_aSingleCollisions			0x918
> +#define A5PSW_aLateCollisions			0x91C
> +#define A5PSW_aExcessiveCollisions		0x920
> +#define A5PSW_aCarrierSenseErrors		0x924
