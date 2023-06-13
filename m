Return-Path: <netdev+bounces-10460-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CB0472E97D
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:26:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2097428106A
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D23B30B8C;
	Tue, 13 Jun 2023 17:26:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502FB23C6A
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 17:26:00 +0000 (UTC)
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B499E212F;
	Tue, 13 Jun 2023 10:25:30 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4f62cf9755eso7160450e87.1;
        Tue, 13 Jun 2023 10:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686677046; x=1689269046;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ODAKB6kMlEX4PRQW3AKishpUPeUFtuBOriTsESRpwjE=;
        b=pLcwynQ+oas3Kb8/0F2Hz+m1VyNqeFVV/YvMS3XyBpbDFLR9FXZUR6LeBm7+9BXefh
         wLOkX1dHxIrIqJEOlqpZKVWZEhQ6AyDg+0q04bVX/KIt8AWuHx8OeocQHM8a9c/VE9X7
         25cjyEZNsk5E5nqTacfHBbh9IzcKjq2g5ij39zdum0KJ80EO5bucu2dsGlb0DyTlvIWe
         HUkun7St2gyaZEJw+AXCTo2MJx8inmwAcnyqVjvRowRrewcQ7Z+qJF1QEfRY3uxBFq9S
         XwwapRDwqoqzVWG1L/7OIOb4cH3MIdS2twG/T+dfZ41jDSPJugwYd7t7hf9MKaRDQXLX
         jIFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686677046; x=1689269046;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ODAKB6kMlEX4PRQW3AKishpUPeUFtuBOriTsESRpwjE=;
        b=NtE05oPC8iABwHHEUlB9IMAVYpZMxtr8LHEQRBlrtrq33kke0vvJ6IlI0PS7rUl6Eg
         w9b1o+d7gdfW290o2cdoVEWNo+rSn5dmmpG26IEb70JFPofB/OSDsDk8B7cYRh+Cp5Kr
         EbIZRUI/50sK9Ny+PvafJRK0+az0eIV0squlhCFdJoiqFhy81/lDFHeqps06tfw7xQpA
         bwTROj/fFHBMSM9v0xw0j/ov1Ug+8jCmXALmmUIA3kAXTkQRleTFCwGDFiRCNBbln2l/
         e/gnKBYLPCi+t+wQdvUw0emsO7Du18M/3G+cvRsuYVPtMO8sYi89ieQ3A0yjC5TmB6H4
         k03A==
X-Gm-Message-State: AC+VfDwy/JzuwLDhoRob8utD1UY6UzKQQuScvLE5MblJaaPOTA2lJQOi
	sJIqzvY8NGDH+zOq2nT4u5E=
X-Google-Smtp-Source: ACHHUZ5FED+iaQ0AU4j8ePw/sCKudiJLTltePzDr7wRRsMmxp2Y8olQvUpTIE5i+5HP7X96hf1qLwg==
X-Received: by 2002:a05:6512:3284:b0:4f3:b49b:e246 with SMTP id p4-20020a056512328400b004f3b49be246mr7076497lfe.5.1686677045828;
        Tue, 13 Jun 2023 10:24:05 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id e3-20020a50fb83000000b0051879590e06sm982088edq.24.2023.06.13.10.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 10:24:05 -0700 (PDT)
Date: Tue, 13 Jun 2023 20:24:02 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: Daniel Golle <daniel@makrotopia.org>,
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
Subject: Re: [PATCH net v2 2/7] net: dsa: mt7530: fix trapping frames with
 multiple CPU ports on MT7530
Message-ID: <20230613172402.grdpgago6in4jogq@skbuf>
References: <20230611081547.26747-1-arinc.unal@arinc9.com>
 <20230611081547.26747-2-arinc.unal@arinc9.com>
 <20230613150815.67uoz3cvvwgmhdp2@skbuf>
 <a91e88a8-c528-0392-1237-fc8417931170@arinc9.com>
 <20230613171858.ybhtlwxqwp7gyrfs@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230613171858.ybhtlwxqwp7gyrfs@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 08:18:58PM +0300, Vladimir Oltean wrote:
> On Tue, Jun 13, 2023 at 08:14:35PM +0300, Arınç ÜNAL wrote:
> > Actually, having only "net: dsa: introduce preferred_default_local_cpu_port
> > and use on MT7530" backported is an enough solution for the current stable
> > kernels.
> > 
> > When multiple CPU ports are defined on the devicetree, the CPU_PORT bits
> > will be set to port 6. The active CPU port will also be port 6.
> > 
> > This would only become an issue with the changing the DSA conduit support.
> > But that's never going to happen as this patch will always be on the kernels
> > that support changing the DSA conduit.
> 
> Aha, ok. I thought that device trees with CPU port 5 exclusively defined
> also exist in the wild. If not, and this patch fixes a theoretical only
> issue, then it is net-next material.

On second thought, compatibility with future device trees is the reason
for this patch set, so that should equally be a reason for keeping this
patch in a "net" series.

If I understand you correctly, port 5 should have worked since commit
c8b8a3c601f2 ("net: dsa: mt7530: permit port 5 to work without port 6 on
MT7621 SoC"), and it did, except for trapping, right?

So how about settling on that as a more modest Fixes: tag, and
explaining clearly in the commit message what's affected?

