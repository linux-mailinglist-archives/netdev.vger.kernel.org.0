Return-Path: <netdev+bounces-10873-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EBA487309A7
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:17:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A725D281143
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:17:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7771125D6;
	Wed, 14 Jun 2023 21:17:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D2611CB1
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 21:17:03 +0000 (UTC)
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709DFE6C;
	Wed, 14 Jun 2023 14:17:02 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-97454836448so160131466b.2;
        Wed, 14 Jun 2023 14:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686777421; x=1689369421;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xt834FEuuau+dhXyiK6Us9w6s+LXDl9lf/qHhQT3U1M=;
        b=m/3jIuP25nI+K1ul4UlfpZ9MWiYVvcJK2XUhm5e495M9I8PhvamySyxbPEXd+vaADG
         yu6yffQBZ+RFlOiEXnGK7hhMvXC5uzfTxC9EaLgSQUvTFyvOYa5TZCZ1gVKTie+G5Mcu
         9y0+3B4ravEta/76EjZlL2qahQKDN0IRGz+dmzonLj/HC4Jg89zuGIB9DQdSOHBHm9Uw
         sHoidWvEbo8Ij3fOtO0q3YtEnoxgNWyIgMaShWG+2BkiTi9CJIZxawNvv5bCHhezJts5
         FOY9HSyuruynbBZkznitjZx3c/tmGFH/lj+QE6GQnuBbkZjMQUJhBG3VyhSyCugHA8x1
         8hAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686777421; x=1689369421;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xt834FEuuau+dhXyiK6Us9w6s+LXDl9lf/qHhQT3U1M=;
        b=R1aInpnUurVKb8Cvon0mt0d/Oi+r7Zmyt/b+5V1cQCgwc7kz0xhsm/K52HvXN70Kvw
         nZHkD3NVsK1XX8rsh08sUBYm9ItxRFN/Yh0qS2h5R4a1HQ8o8Iq+Ay+btjw1VljJXL1R
         AfMajDMUIblwrbk+HobPruOyehhVY/aFd4u54tipYJw8xUvzZ+B5cqOR3/Y9kJ7E2f6u
         /aIPydE0p3QIK9mcWYSbaxwt8At/OOCpm99goh/bnJ9A8TEJpi4yR1qE3PEBz76owtmi
         lePvNq+Z4oh1fCqwX7kFKN4xwM8reZdCQbCxSUY0J12uerdJARPT2W6UkVM2GZtTnjeB
         B6rw==
X-Gm-Message-State: AC+VfDwKTUmLkIskuwcM5LApyj7WZ031Wr7RTHueXSrkbV7ZvewdZP+K
	M1z2FLOhSKJCTwPApdknyRU=
X-Google-Smtp-Source: ACHHUZ7h1ThvmhUVEqyCTIVWjGGdlqAe2bIZezMhJtsZz5zUUWOUL9Qqe1oJ6+Y8W8kcPkpT/DUWqg==
X-Received: by 2002:a17:907:c15:b0:94e:1764:b09b with SMTP id ga21-20020a1709070c1500b0094e1764b09bmr14263413ejc.45.1686777420734;
        Wed, 14 Jun 2023 14:17:00 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id u16-20020a1709064ad000b009828e26e519sm496960ejt.122.2023.06.14.14.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 14:17:00 -0700 (PDT)
Date: Thu, 15 Jun 2023 00:16:57 +0300
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
Subject: Re: [PATCH net v4 4/7] net: dsa: mt7530: fix handling of BPDUs on
 MT7530 switch
Message-ID: <20230614211657.2c3ljwnlng7vxamz@skbuf>
References: <20230612075945.16330-1-arinc.unal@arinc9.com>
 <20230612075945.16330-5-arinc.unal@arinc9.com>
 <20230614205008.czro45ogsc4c6sb5@skbuf>
 <e8a0f46b-f133-c155-f0de-9046a53e6069@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e8a0f46b-f133-c155-f0de-9046a53e6069@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 12:05:44AM +0300, Arınç ÜNAL wrote:
> On 14.06.2023 23:50, Vladimir Oltean wrote:
> > Where have you seen the BPC register in the memory map of MT7530 or MT7621?
> 
> I did not somehow dump the memory map of the switch hardware and confirm the
> BPC register is there, if that's what you're asking.

I mean to say that I looked at

MT7530 Giga Switch programming guide.pdf
MT7621 Giga Switch Programming Guide.pdf
MT7621_ProgrammingGuide_GSW_v01.pdf

and I did not find this register.

> However, I can confirm the register is there and identical across all MT7530
> variants. I have tested the function of the register on the MCM MT7530 on
> the MT7621 SoC and the standalone MT7530. The register is also described on
> the document MT7620 Programming Guide v1.0, page 262.

Interesting. I did not have that one. Hard to keep up.

