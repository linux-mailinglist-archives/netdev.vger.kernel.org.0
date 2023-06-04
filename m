Return-Path: <netdev+bounces-7766-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EC41721714
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 14:55:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A87F81C20A12
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 12:55:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51C438835;
	Sun,  4 Jun 2023 12:55:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4376723C6
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 12:55:25 +0000 (UTC)
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749DFCE;
	Sun,  4 Jun 2023 05:55:22 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-977cc662f62so103756766b.3;
        Sun, 04 Jun 2023 05:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685883321; x=1688475321;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TDn8YYiBgXe3r21cm1jfI/woIIBtKXmlQB8jMG4QMOo=;
        b=rCiLQm8r7AsBnR0YdaOOjhZjiaTSbli+RZPxkqHLqdZGIpUudPt4jMW0oaGLQumV20
         VC3wBhx1K9m3OG/fOdrGjU/X2e21mZH51sVVVqYWByyxYW5XbC4ANM7Dh/e9zqdw/E4/
         QgUG5MftcXEhHF705ui6Vvs4iPaUskAvWNVtGeSYYH4ZUOw+NGlCcdbU6VF4FQTEJn3H
         jgbimlJwV4af5cQIR1GcDG5g2BGYhEEQFE0p7zCv93aH8M2uYv5HBTCYq85id/VgEphH
         L4aNWgDV3qHr+T8BM5Z2hrx53Rmie7o5hwsBR5RUoNlQfW70ZrNPEyU7BVqxoy8WiY3y
         ba2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685883321; x=1688475321;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TDn8YYiBgXe3r21cm1jfI/woIIBtKXmlQB8jMG4QMOo=;
        b=i8q0xNPXXL+7vw++7HSqtLoV8gOoHPDD4mcsg6xcPktVL+ubAXanj5se1BGFd94P7q
         bkJR50pel8RAGWQj0O/sjXp+OwUU9h0gYqvq49M40v40XbTZ9/LVFUOSv8+MvwuWSWxG
         ezN0dPBzFJwlYP+rGhW1BUCgbkDTOCPK1jroMXejNgjMgkBKuWOH9czN1PHb6FqvKJgs
         GwgvEyQcCG4tmKEXleldu5ckxFsFcWCrhJib3P4dj3zrpeJGKPX8cxJFqFdvG1/bXdGP
         QefNH18DEvW7IDJVEU4yHnzuFoN1zzPIeZoYik/8afsRkPSWtqBuM2U7DxDhthzBe/nM
         Qodg==
X-Gm-Message-State: AC+VfDzZDsyNZQ4GKpVrHHtRkH0AuNX40BD27tFaZeCQOisAIEd09JM6
	62RCiqRq4P1qFxbZCY+cnOA=
X-Google-Smtp-Source: ACHHUZ7ja9CDX3BNoyA2qTqEGzXUEEqIef58uTxByuQrtW5OxZTF515OuthTTD2Lh95XYymQeO7jeA==
X-Received: by 2002:a17:907:8690:b0:96b:4ed5:a1c9 with SMTP id qa16-20020a170907869000b0096b4ed5a1c9mr3772273ejc.51.1685883320625;
        Sun, 04 Jun 2023 05:55:20 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id gf18-20020a170906e21200b0096629607bb2sm3033939ejb.98.2023.06.04.05.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 05:55:20 -0700 (PDT)
Date: Sun, 4 Jun 2023 15:55:17 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	erkin.bozoglu@xeront.com, mithat.guner@xeront.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 08/30] net: dsa: mt7530: change p{5,6}_interface
 to p{5,6}_configured
Message-ID: <20230604125517.fwqh2uxzvsa7n5hu@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-9-arinc.unal@arinc9.com>
 <20230522121532.86610-9-arinc.unal@arinc9.com>
 <20230524175107.hwzygo7p4l4rvawj@skbuf>
 <576f92b0-1900-f6ff-e92d-4b82e3436ea1@arinc9.com>
 <20230526130145.7wg75yoe6ut4na7g@skbuf>
 <7117531f-a9f2-63eb-f69d-23267e5745d0@arinc9.com>
 <ZHsxdQZLkP/+5TF0@shell.armlinux.org.uk>
 <826fd2fc-fbf8-dab7-9c90-b726d15e2983@arinc9.com>
 <ZHyA/AmXmCxO6YMq@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHyA/AmXmCxO6YMq@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 01:18:04PM +0100, Russell King (Oracle) wrote:
> I don't remember whether Vladimir's firmware validator will fail for
> mt753x if CPU ports are not fully described, but that would be well
> worth checking. If it does, then we can be confident that phylink
> will always be used, and those bypassing calls should not be necessary.

It does, I've just retested this:

[    8.469152] mscc_felix 0000:00:00.5: OF node /soc/pcie@1f0000000/ethernet-switch@0,5/ports/port@4 of CPU port 4 lacks the required "phy-handle", "fixed-link" or "managed" properties
[    8.494571] mscc_felix 0000:00:00.5: error -EINVAL: Failed to register DSA switch
[    8.502151] mscc_felix: probe of 0000:00:00.5 failed with error -22

