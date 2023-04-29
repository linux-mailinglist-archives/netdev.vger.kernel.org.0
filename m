Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7696F257D
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 19:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjD2Rf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 13:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjD2Rf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 13:35:28 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC981BC5
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 10:35:26 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-5050491cb04so1353201a12.0
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 10:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682789725; x=1685381725;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FlOO5mxlakrkWJMqTyJJvzQ2W0AKdb1nViezUvxLKmw=;
        b=pda0tal6t5a49854zLPYAbscEMwHhRV4B54VGHX6nuisCnA2u5Zp+ajdMOuwuvRkXk
         fiqppxGKcds8UzSrRgCuWKy5RrS+BGmXZeMQwNwcBSkQcQCeuhrHaql9zaLUg6RdJqHh
         L1Z2eBE/7F0+WY4uMTO+XMe5WyY2IKb91xcUSCsXMPnPS4mcC+aCg4m43VtbBpi8t9a/
         j5Q6wKf8a1kL51M2cGPI1Pk0jeRIQort3OzGcP1KFFNNQKKt1XlGD+O1KEWmTJtHViOV
         H1xXbeYe4dpGCzjhFp16J7ldfV3xII66HJkpuHZkb9Hz7COzetMdEHWs0+X8swjQTK6P
         Vt8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682789725; x=1685381725;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FlOO5mxlakrkWJMqTyJJvzQ2W0AKdb1nViezUvxLKmw=;
        b=fiWNZ8mr3wpqD+5XAdy38lyKO6yShHRx+5e38iotOv1eubkDFagPk/RamZ2mk6HbEQ
         t2OG3UpssB7EbhtpgzegmFd+74aFjDqdtH2NWenP2R8n+S1yePcagRErj9FMlB1QFbP5
         X7gzj/oRTDXXxX9MHlWXIo0PEfM75OZVDM6dkhYYWO+FhMe+5Tey0poCTK9CXvdWNymw
         45lhfHsE+KzULhoucHjI36pW+OsYlf+tu1BQsmguGQ3NKIWVhGXaqUjSMj3M7pTqXeOH
         ELbcV+lf4LOjLL9uxWf/0p4ytYfEPCRgaE351M49RMmaC/UmnTjSlq7mSK94LnXYZB36
         ijjw==
X-Gm-Message-State: AC+VfDw9mzW269N+k7HHLKnVaKFmI7mBqRsk1FDCrb+6CmRlPMAEcPl6
        lnTrh7JGoWLTnzAMp4ilWNk=
X-Google-Smtp-Source: ACHHUZ7M4wktdnE7jmiqHD5TpbeagZVI6lBKZCA8pGzW504rw11ej02I9mUDAIR/RgCu995q56TW6w==
X-Received: by 2002:a05:6402:1a28:b0:504:7d53:2148 with SMTP id be8-20020a0564021a2800b005047d532148mr1569040edb.30.1682789724650;
        Sat, 29 Apr 2023 10:35:24 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id d5-20020a17090648c500b008c16025b318sm12737890ejt.155.2023.04.29.10.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Apr 2023 10:35:24 -0700 (PDT)
Date:   Sat, 29 Apr 2023 20:35:22 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     DENG Qingfang <dqfext@gmail.com>, Greg Ungerer <gerg@kernel.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
        bartel.eerdekens@constell8.be, netdev <netdev@vger.kernel.org>
Subject: Re: MT7530 bug, forward broadcast and unknown frames to the correct
 CPU port
Message-ID: <20230429173522.tqd7izelbhr4rvqz@skbuf>
References: <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
 <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
 <20230426205450.kez5m5jr4xch7hql@skbuf>
 <0183eb91-8517-f40f-c2bb-b229e45d6fa5@arinc9.com>
 <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
 <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
 <20230426205450.kez5m5jr4xch7hql@skbuf>
 <0183eb91-8517-f40f-c2bb-b229e45d6fa5@arinc9.com>
 <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
 <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
 <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 29, 2023 at 04:03:57PM +0300, Arınç ÜNAL wrote:
> This is the final diff I'm going to submit to net.
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 4d5c5820e461..cc5fa641b026 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1008,9 +1008,9 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
>  	mt7530_write(priv, MT7530_PVC_P(port),
>  		     PORT_SPEC_TAG);
> -	/* Disable flooding by default */
> -	mt7530_rmw(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | UNU_FFP_MASK,
> -		   BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) | UNU_FFP(BIT(port)));
> +	/* Enable flooding on the CPU port */
> +	mt7530_set(priv, MT7530_MFC, BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) |
> +		   UNU_FFP(BIT(port)));
>  	/* Set CPU port number */
>  	if (priv->id == ID_MT7621)
> @@ -2225,6 +2225,10 @@ mt7530_setup(struct dsa_switch *ds)
>  		/* Disable learning by default on all ports */
>  		mt7530_set(priv, MT7530_PSC_P(i), SA_DIS);
> +		/* Disable flooding on all ports */
> +		mt7530_clear(priv, MT7530_MFC, BC_FFP(BIT(i)) | UNM_FFP(BIT(i)) |
> +			     UNU_FFP(BIT(i)));
> +
>  		if (dsa_is_cpu_port(ds, i)) {
>  			ret = mt753x_cpu_port_enable(ds, i);
>  			if (ret)
> @@ -2412,6 +2416,10 @@ mt7531_setup(struct dsa_switch *ds)
>  		mt7530_set(priv, MT7531_DBG_CNT(i), MT7531_DIS_CLR);
> +		/* Disable flooding on all ports */
> +		mt7530_clear(priv, MT7530_MFC, BC_FFP(BIT(i)) | UNM_FFP(BIT(i)) |
> +			     UNU_FFP(BIT(i)));
> +
>  		if (dsa_is_cpu_port(ds, i)) {
>  			ret = mt753x_cpu_port_enable(ds, i);
>  			if (ret)

Looks ok, but considering that the register is the same for all ports,
then instead of accessing the hardware one by one for each port, you
could issue a single:

	mt7530_clear(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | UNU_FFP_MASK);

before the per-port for loop.
