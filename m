Return-Path: <netdev+bounces-5060-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A97070F90F
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:48:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA05D2813DE
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:48:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32289182CF;
	Wed, 24 May 2023 14:48:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268D060875
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:48:26 +0000 (UTC)
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBB0130;
	Wed, 24 May 2023 07:48:24 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-4f3a166f8e9so1069993e87.0;
        Wed, 24 May 2023 07:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684939702; x=1687531702;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XMA9OrU/15fPUa0Dy5HWt9/3JbIUzxDlly+e73u9etQ=;
        b=SRGgeknfaJW9HxYvJDQYT3/MtL3CtkbovJiM1N4FuHjrfmsuijxccWeL8T6BZ8srnn
         B67fpywaBScdbX4GcRdGuZu9+uQcFIvdYrmuUY4lfx6++q0iUdE/J0mIAZ/0D7f14YpP
         h77AhZOR8avLjbV++eaHDlilOwr3Yn9StKQqMsVsEvZovwU1IL0b+HVgg++Xv4w1RRYN
         mLsmXdy2ZHn8Ltv1yQEXmYTBtZjzju/HSAg8hg8pJR3VkMm+/5pqG6WoHf//uxqcp+nY
         iiGopGp1bIbWstvn8UufMhd8O0tJV/pIO8kSJq11hZ9wBlT0wc+l0E1uqZgs0IcJPu3C
         wOJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684939702; x=1687531702;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XMA9OrU/15fPUa0Dy5HWt9/3JbIUzxDlly+e73u9etQ=;
        b=eWiu+Q2CW308vnDpsP4Hgg7Ga0VIl6WyFebjn8uyjBu1W3cuKpSMyFm0RWIbzS/hll
         Q08xLhaevcyLiOfqktRNSq68VzHAmBgFZCttzObE7fyO8rdr/1uFyVgLZ+wzzid1mazI
         obcZHPweK+/HqyePlhZLhMwiigzW4P8zpF7GD5KhuN7Ns2jkgodVEQVCItPTY5LFXNBc
         LwJX+OPR2fsm6E+ksh8lwgvrSs/qc2A5TLazZ21bKekvS3JupNA4PsNfPom47mXx8raa
         Tyu6f1z0bFoIELKSWmno/Vy7X5fjtr3L1K5erVN5YMTjjftVRI3JyG90fbGYo9tRNLJm
         AaPw==
X-Gm-Message-State: AC+VfDwY0Nryz0cb8gJw4saC2mukfJhe6/NUEhT+FAXqyHIiWgAgzdp5
	62E8VFQs315npLjkqnlbJS4=
X-Google-Smtp-Source: ACHHUZ5XkiPQ059g/mB5V15M6VwZz2Sbq592VYrkn4uU78BxhyGBj66JRl7gvxctkgOXcoC2bcw4Gg==
X-Received: by 2002:a05:6512:3d0d:b0:4f4:7a5:e800 with SMTP id d13-20020a0565123d0d00b004f407a5e800mr3788949lfv.10.1684939702123;
        Wed, 24 May 2023 07:48:22 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id u22-20020ac243d6000000b004f14535a962sm1750995lfl.174.2023.05.24.07.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 07:48:21 -0700 (PDT)
Date: Wed, 24 May 2023 17:48:17 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: arinc9.unal@gmail.com
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
	=?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	erkin.bozoglu@xeront.com, mithat.guner@xeront.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 03/30] net: dsa: mt7530: properly support
 MT7531AE and MT7531BE
Message-ID: <20230524144817.dubqwmfbthes2ggh@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-4-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230522121532.86610-4-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:15:05PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> Introduce the p5_sgmii field to store the information for whether port 5
> has got SGMII or not.
> 
> Move the comment about MT7531AE and MT7531BE to mt7531_setup(), where the
> switch is identified.
> 
> Get rid of mt7531_dual_sgmii_supported() now that priv->p5_sgmii stores the
> information. Address the code where mt7531_dual_sgmii_supported() is used.
> 
> Get rid of mt7531_is_rgmii_port() which just prints the opposite of
> priv->p5_sgmii.
> 
> Remove P5_INTF_SEL_GMAC5_SGMII. The p5_interface_select enum is supposed to
> represent the mode that port 5 is being used in, not the hardware
> information of port 5. Set p5_intf_sel to P5_INTF_SEL_GMAC5 instead, if
> port 5 is not dsa_is_unused_port().
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Acked-by: Daniel Golle <daniel@makrotopia.org>
> ---

Pretty busy patch, and after reading it, I'm not sure:

- why? (this seems to be absent from the commit message)
- how are MT7531AE and MT7531BE supported any more properly after this
  change, as the commit title claims
- what is the overall effect, other than just refactoring. If that's
  all, what's written on the tin needs to be a better representation of
  what's inside.

Pure refactoring is not a bad goal in itself, as long as we're on the
same page that there is a justification which makes the new code better
than the old one.

