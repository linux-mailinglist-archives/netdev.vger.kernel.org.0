Return-Path: <netdev+bounces-11377-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C0FC732D19
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:11:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 490BD1C20FAA
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30D3717FE7;
	Fri, 16 Jun 2023 10:11:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DF279D3
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:11:15 +0000 (UTC)
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04C4AC;
	Fri, 16 Jun 2023 03:11:13 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-5183101690cso3497286a12.0;
        Fri, 16 Jun 2023 03:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686910272; x=1689502272;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Od2IJ/bp8ubdmr1qWPt3A6bQBmcWuN4Gw3pOBhx9Hiw=;
        b=h+xwRePmzfLx6oR4GHRIbt2NUcewWAQ3UsEqc2SFYI5EmFlvbpXoYaF1U84AkRkpuL
         gGTiPUmfOLEqtMifptKGU9e5Wqnq9BY5I3mESXYnha4dzDClfGJf3Urtn/oN0hsuj/Kh
         Ngt2MqY2tEtPvuj6xw5/8ibVisxhu1mTE7UN1lnSKfmqcOMrm3QkMX1L2sx3pIZmqZqC
         b3tY9QxZVREwkYYxba9H7/wl6X+zMOCentjRbyU5ORTTsa/X9Wz13jYV/X18rOczhL5O
         NQA9QG++vwgC7AIxC7ChlaVKC+bNx2b8Mbq9xTN1rgoH3/XuNRDEG1DS6eX/EandPKS1
         dl/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686910272; x=1689502272;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Od2IJ/bp8ubdmr1qWPt3A6bQBmcWuN4Gw3pOBhx9Hiw=;
        b=kwk71qsjQHHxPKJD/+zq1CerynUoiu+Ndq64Iij/1/6mJt8/W5hdf4flR1qyUXIKZ6
         UFOg/7HAW86PhCXCjH0T2a+hBZgWVvVmJDFGPaGaw3/29BiTPulu/EoM5F7Lh3fX9LXC
         pAyTt2Hp/MRHTBXzbMzw7WdRqUiQhuB6zbo/esDragkj1hOPItbG2hgS2koWJrvPiDOq
         4ZTD9Jrue1Q2bcIigxpKf/7b9W94s/poOzokBjIyvR7sJ7jV4zTOZyfH6k3NcYkhTie6
         q2JuXz3xQ5VlVJA5LFRJdUSTmr3h3K17zPZTqiMDu9Wgf3rZIvJPMoWFCLmETm2fSLpq
         JfJA==
X-Gm-Message-State: AC+VfDzhy9mPXoQP1AgQe7sMdQ/zfgEuJvKxw1oUiQCx77ONGVD87ha+
	jOU+/vgjdnYYRryB33M1sDY=
X-Google-Smtp-Source: ACHHUZ4Xo2qDnOAqwgzL1CIulKn7qYv3IxxCekqKWRXtSp06XCuA7NcvBy15p4nVG0n2wKltyqPYXg==
X-Received: by 2002:a05:6402:1008:b0:51a:1f11:41e0 with SMTP id c8-20020a056402100800b0051a1f1141e0mr1170918edu.1.1686910272095;
        Fri, 16 Jun 2023 03:11:12 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id u10-20020a056402064a00b0051a318c0120sm842562edx.28.2023.06.16.03.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 03:11:11 -0700 (PDT)
Date: Fri, 16 Jun 2023 13:11:08 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: arinc9.unal@gmail.com
Cc: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v5 3/6] net: dsa: mt7530: fix handling of BPDUs on
 MT7530 switch
Message-ID: <20230616101108.wq5aote3yjpekilu@skbuf>
References: <20230616025327.12652-1-arinc.unal@arinc9.com>
 <20230616025327.12652-1-arinc.unal@arinc9.com>
 <20230616025327.12652-4-arinc.unal@arinc9.com>
 <20230616025327.12652-4-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230616025327.12652-4-arinc.unal@arinc9.com>
 <20230616025327.12652-4-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 05:53:24AM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> BPDUs are link-local frames, therefore they must be trapped to the CPU
> port. Currently, the MT7530 switch treats BPDUs as regular multicast
> frames, therefore flooding them to user ports. To fix this, set BPDUs to be
> trapped to the CPU port.
> 
> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  drivers/net/dsa/mt7530.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index e9fbe7ae6c2c..7b72cf3a0e30 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2262,6 +2262,10 @@ mt7530_setup(struct dsa_switch *ds)
>  
>  	priv->p6_interface = PHY_INTERFACE_MODE_NA;
>  
> +	/* Trap BPDUs to the CPU port */
> +	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
> +		   MT753X_BPDU_CPU_ONLY);
> +
>  	/* Enable and reset MIB counters */
>  	mt7530_mib_reset(ds);
>  
> -- 
> 2.39.2
> 

Ok, so this issue dates back to v4.12, but the patch won't apply that
far due to the difference in patch context.

Since the definition itself of the MT753X_BPC register was added as part
of commit c288575f7810 ("net: dsa: mt7530: Add the support of MT7531
switch") - dated v5.10 - then this patch cannot be practically be
backported beyond that.

So I see no possible objection to the request I'm about to make, which is:
please group this and the identical logic from mt7531_setup() into a
common function and call that.

