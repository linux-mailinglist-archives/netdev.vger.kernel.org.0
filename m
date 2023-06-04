Return-Path: <netdev+bounces-7736-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FB85721548
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 09:14:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7C9E281582
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 07:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E961423CE;
	Sun,  4 Jun 2023 07:14:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6A515C1
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 07:14:51 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649B0CE;
	Sun,  4 Jun 2023 00:14:50 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-977d0288fd2so63452266b.1;
        Sun, 04 Jun 2023 00:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685862889; x=1688454889;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xIhKNTPXPe0u0jsGPi0f2cIWsy51Xap3dptIpk88dVw=;
        b=aBZpo9amahon3ntrSsg2wteLLxu4t7tqyGv95gv3ZHpEeiM8eqfHkNcoO/IQ7z9SwE
         zymWvbJ4G1AtHsG/hxqmWZ+PlBs6fiXIIaY39HODoNe0s8jZRdoY5OLs6w9n32UDxK7F
         5kApV6hcVgQ5heBbpGT27297qXuGu2UfRvlqZQG/4CGwIlxdXd6rqTux8vHQltdza16a
         6NzBkLH0uWU0fPhlgxSSGrChc5aJK1tkYNFiZ68/YvfikLup1Li1WXyNtegvknaNvYEF
         f7L0IwOEo6Bs8DRxT/H/Ak1wKgi7IEIzQywmZEYiIXH26r9sEbxIRXhPoxTAyyfBVOJ1
         cJoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685862889; x=1688454889;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xIhKNTPXPe0u0jsGPi0f2cIWsy51Xap3dptIpk88dVw=;
        b=Bn80bVMIyLrsLcUKHWmH01ZLIcuiqLnbYIJTSR2nLe6Eoru36WtD/Ux6MXxezwm93y
         ePoAbNNIPFYtr8O7Gpm31sMFjDFHIGAAxUuCD8hMmeB2pMFWEVXwT3ik+W+rEru2cGH5
         TbQQfXgJy3UT+uA9QzVghWNmzq8WLQ7fEYbrNXC+FCi3Vy9RCV5psIdd3W14vY3GG7c6
         03FVDvbA95mAgiuR+PMbP9qsB4cPSk3UJWugyaZAzKwxfUXJpW5zUMgIuFqvNYhMP6En
         XH0R0o7O3In0/x6knPzSXbALaI6a0n2X6TaJVefcRoZaazlFn+Nzlbr4W9Ke/tq2Z9Ld
         +NAA==
X-Gm-Message-State: AC+VfDw3eEvFgFgyqLzSubP1WWH+Bf2pBpx9sl8ABBtoklhK8zF8vveK
	x5cGRVQEC2M52aVSnZuPqSc=
X-Google-Smtp-Source: ACHHUZ4w1MieX+7rRio+qeSsBwtrLBg/KVLl5GMMP8Mx9DGNgb0YpvWremR2+g4SdP15RlY5jrN1Cg==
X-Received: by 2002:a17:906:9b8a:b0:967:142b:ff07 with SMTP id dd10-20020a1709069b8a00b00967142bff07mr3545323ejc.21.1685862888389;
        Sun, 04 Jun 2023 00:14:48 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id t5-20020a17090616c500b0096a6be0b66dsm2707305ejd.208.2023.06.04.00.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 00:14:48 -0700 (PDT)
Date: Sun, 4 Jun 2023 10:14:45 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: Sean Wang <sean.wang@mediatek.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	erkin.bozoglu@xeront.com, mithat.guner@xeront.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 16/30] net: dsa: mt7530: move lowering port 5
 RGMII driving to mt7530_setup()
Message-ID: <20230604071445.a5hg2tiybqp2iqwz@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-17-arinc.unal@arinc9.com>
 <20230522121532.86610-17-arinc.unal@arinc9.com>
 <20230526131739.5mso5y2d3ieelasf@skbuf>
 <08e9c220-cf15-4c61-f7f4-ad8073a3bcf7@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <08e9c220-cf15-4c61-f7f4-ad8073a3bcf7@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 10:05:44AM +0300, Arınç ÜNAL wrote:
> It wouldn't. I'll drop this patch, thanks. For reference, PMCR_TX_EN (bit
> 14) for port 5 is also set in the case of PHY muxing with this code on
> mt7530_setup_port5() which doesn't use phylink.
> 
> 		/* Setup the MAC by default for the cpu port */
> 		mt7530_write(priv, MT7530_PMCR_P(5), 0x56300);
> 
> 0x56300 = 0101 0110 0011 0000 0000
> 
> Maybe I should make a patch to use the definitions on mt7530.h for this?
> 
> Arınç

Yes, I don't believe magic numbers make things particularly obvious for
other driver writers, they should be avoided if possible.

