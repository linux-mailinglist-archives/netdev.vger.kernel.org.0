Return-Path: <netdev+bounces-10466-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4292672EA08
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:39:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24B1D1C2074C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BF1D3AE6A;
	Tue, 13 Jun 2023 17:39:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F68F33E3
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 17:39:18 +0000 (UTC)
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A201BD7;
	Tue, 13 Jun 2023 10:39:13 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-51496f57e59so8104402a12.2;
        Tue, 13 Jun 2023 10:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686677952; x=1689269952;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fRpNtV8zUEuU2BHqkyHRpezC5xzROKFDdAnAmIyuX2E=;
        b=FSGvf5FxPPNoQrGrAZnFTPeWSXTnArKC6LcO4f6JDuAGcusvhFLbaWumON/WY0HYOd
         vTQiWaK4cIFM6vQtOL/Gc2jJ1sNKTtPD5BAKTCwAV7t+ciSSNGRgHqR7q1o4o32Nq5wi
         J3vsadlk4ISVhQYxyGs2QbJn2TtBccZLSHoTGBP+uDByi3tVE6guV9qSsl+aMG9Q3eNC
         oYAlstYqrvgHfJxvuOuO4MURtprZxERoeKdcxgEt7doQIiR5nJuA1ivGKcl0ztSydAeD
         gX8+1/yCJpvIJ/US7fSaOnVYPmrUsB8t5Rte8DvIpAWtSyGrS9LyMeTXHArv6ap1rgd1
         cvHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686677952; x=1689269952;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fRpNtV8zUEuU2BHqkyHRpezC5xzROKFDdAnAmIyuX2E=;
        b=BRSFFrUBZF0x+qarDsX8aR++5goPQ5P+AXdAz00qN7B2WI0NX3ohZrxMeW7702l2Uu
         JMo7hI85LqyUtZrFmxkE81FhhkUO6qDuugQt3kiRjIx141Z2C+B4X1niiM4ICGq9m3Bj
         iTOwm7shHFSmvzH2kOenkdUNttlcqTZ52B3MvxydNqicwJLdbI7yj8CyiTdd5hIM+Lf4
         6ggZoEZn5efF+0yb4pmyfAwBRiMU4LlDnHxffWWkZTZzoby+w8jUh5wmMOa8a/q4q5zI
         J6S104LM5PWVIezfuS8PFhfZc5wkjbFkmKy0Sy0VjYuoGL9QM+7oqhwVmwW3/W/xmtUa
         pNWA==
X-Gm-Message-State: AC+VfDw8XG0NHbdkMiKTgVQrHgZWb17EmVNiqWofajGQnxjeZ4ZzrNNA
	ZEmeyIOEeL4ggbF3Utyrbwk=
X-Google-Smtp-Source: ACHHUZ47isHT2iPmpXgLQ1O8Q21l+6jRGRaZQitKOfJYSlUHWLYaekU++8CWEU9Dl0Vefi5SSuN+NA==
X-Received: by 2002:a17:907:169f:b0:96f:2b3f:61 with SMTP id hc31-20020a170907169f00b0096f2b3f0061mr14443839ejc.7.1686677951800;
        Tue, 13 Jun 2023 10:39:11 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id sa22-20020a170906edb600b0096f03770be2sm6932576ejb.52.2023.06.13.10.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 10:39:11 -0700 (PDT)
Date: Tue, 13 Jun 2023 20:39:08 +0300
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
Message-ID: <20230613173908.iuofbuvkanwyr7as@skbuf>
References: <20230611081547.26747-1-arinc.unal@arinc9.com>
 <20230611081547.26747-2-arinc.unal@arinc9.com>
 <20230613150815.67uoz3cvvwgmhdp2@skbuf>
 <a91e88a8-c528-0392-1237-fc8417931170@arinc9.com>
 <20230613171858.ybhtlwxqwp7gyrfs@skbuf>
 <20230613172402.grdpgago6in4jogq@skbuf>
 <ca78b2f9-bf98-af26-0267-60d2638f7f00@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ca78b2f9-bf98-af26-0267-60d2638f7f00@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 08:30:28PM +0300, Arınç ÜNAL wrote:
> That fixes port 5 on certain variants of the MT7530 switch, as it was
> already working on the other variants, which, in conclusion, fixes port 5 on
> all MT7530 variants.

Ok. I didn't pay enough attention to the commit message.

> And no, trapping works. Having only CPU port 5 defined on the devicetree
> will cause the CPU_PORT bits to be set to port 5. There's only a problem
> when multiple CPU ports are defined.

Got it. Then this is really not a problem, and the commit message frames
it incorrectly.

> > So how about settling on that as a more modest Fixes: tag, and
> > explaining clearly in the commit message what's affected?
> 
> I don't see anything to change in the patch log except addressing Russell's
> comments.

Ok. I see Russell has commented on v4, though I don't see that he particularly
pointed out that this fixes a problem which isn't yet a problem. I got lost in
all the versions. v2 and v3 are out of my inbox now :)

