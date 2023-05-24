Return-Path: <netdev+bounces-5131-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE1B270FC09
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 18:57:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CE7828134B
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:57:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 206A519BD9;
	Wed, 24 May 2023 16:57:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075D26087C
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 16:57:09 +0000 (UTC)
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD3810B;
	Wed, 24 May 2023 09:57:06 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-96fa4a6a79bso178994866b.3;
        Wed, 24 May 2023 09:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684947425; x=1687539425;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XeYz+UHp1BdAADtFCMDrvi6V+EkmkXCK/AxBNs57v08=;
        b=bqFNnLIiRYxhCll0RGSuw2nKMMAguyc/BFGPqqToS/oPPNn8vZrajcbq4p4LjetWfk
         YZCILREk+GagD3q+lKBzKl5XI/X4XqMoYH5Zgcp0JLZ1dcf/ahrk7cVADdhEKrlKFakq
         ANz2m0v5IwLz8BkvyC/yggQ0ETDsN+uchbV+0xymp7q58eh5te2o+CRK4w/hNd+VlKA9
         lJjMvFO4MJVSyA2pEPXDXitBzVKYTYqAtl/WvhM+S0qgUlWqs4LJOLqFVN2E6EnJP9HE
         Uo2nh8Jv81TrUebZ6dWCd3QRua94SVvdTqr0FiAhMy6cnrnC03BoDbvywgMalXYNKsTl
         H1hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684947425; x=1687539425;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XeYz+UHp1BdAADtFCMDrvi6V+EkmkXCK/AxBNs57v08=;
        b=fS1wVVTZekf0ilVukSXqHgA274TYzJiNVbMIa+5jjBAKO5hF8dECQD/N2AeTDSAKUF
         sQLosqEvstYizosHkQr3yNeH1YxHCX+dlqblnjKXMaL4ojsWPM8/3wKHusPllB0ouWOi
         ZXQ9l+1XJhsUibGy+vPDJsmZFhicTkEhkahj5IwrlM+hzLx2GS+87xOlfip4vyUiYqHZ
         Ad/CQCuITqEPizIzjGcd9WRvO428o5u9yhRRts6ocIwGKg7hy8Ud48N7EUuG+vtIpVAT
         m0FVRBrmxM7WCQ8ByY+VIogPPw1kZxuiyf1G17AZ5U5BIHUWzikMhtaDx4iKGudDGd9E
         eOJg==
X-Gm-Message-State: AC+VfDzAvpAkVhdSTYWSdx5ljEHMaILCYUj51eUxdF/QCkTVUg2AYM/p
	sTjq1YL5jwVdpjDL61veDsw=
X-Google-Smtp-Source: ACHHUZ5CJz5jxB6qbPwCbTc+prI9Nva9PTqbNys2iAAru4n0/lWzK/8PgjqMrqwU3jaEm/ggBXnjGg==
X-Received: by 2002:a17:907:930d:b0:94a:959f:6d58 with SMTP id bu13-20020a170907930d00b0094a959f6d58mr19818491ejc.18.1684947424548;
        Wed, 24 May 2023 09:57:04 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id t19-20020a170906a11300b0097382ed45cbsm1067674ejy.108.2023.05.24.09.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 09:57:04 -0700 (PDT)
Date: Wed, 24 May 2023 19:57:01 +0300
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
Subject: Re: [PATCH net-next 05/30] net: dsa: mt7530: read XTAL value from
 correct register
Message-ID: <20230524165701.pbrcs4e74juzb4r3@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-6-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230522121532.86610-6-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:15:07PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> On commit 7ef6f6f8d237 ("net: dsa: mt7530: Add MT7621 TRGMII mode support")
> macros for reading the crystal frequency were added under the MT7530_HWTRAP
> register. However, the value given to the xtal variable on
> mt7530_pad_clk_setup() is read from the MT7530_MHWTRAP register instead.
> 
> Although the document MT7621 Giga Switch Programming Guide v0.3 states that
> the value can be read from both registers, use the register where the
> macros were defined under.
> 
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

I'm sorry, but I refuse this patch, mainly as a matter of principle -
because that's just not how we do things, and you need to understand why.

The commit title ("read XTAL value from correct register") claims that
the process of reading a field which cannot be changed by software is
any more correct when it is read from HWTRAP rather than MHWTRAP
(modified HWTRAP).

Your justification is that it's confusing to you if two registers have
the same layout, and the driver has a single set of macros to decode the
fields from both. You seem to think it's somehow not correct to decode
fields from the MHWTRAP register using macros which have just HWTRAP in
the name.

While in this very particular case there should be no negative effect
caused by the change (*because* XTAL_FSEL is read-only), your approach
absolutely does not scale to the other situations that you will be faced
with.

If it was any other r/w field from HWTRAP vs MHWTRAP, you would have
needed to get used to that coding pattern (or do something about the
coding pattern itself), and not just decide to change the register to
what you think is correct - which is a *behavior* change and not just
a *coding style* change. You don't change the *behavior* when you don't
like the *coding style* !!! because that's not a punctual fix to your
problem.

I'm sorry that it is like this, but you can't expect the Linux kernel to
be written for the level of understanding of a beginner C programmer.
It's simply too hard for everyone to change, and much easier, and more
beneficial overall, for you to change.

I understand that you're poking sticks at everything in order to become
more familiar with the driver. That's perfectly normal and fine. But not
everything that comes as a result of that is of value for sharing back
to the mainline kernel's mailing lists.

Seriously, please first share these small rewrites with someone more
senior than you, and ask for a preliminary second opinion.

As they say, "on the Internet, nobody knows you're a dog". If reviewers
don't take into account that you're a newbie with C (which is a badge
that you don't carry everywhere - because you don't have to), it's easy
for patches like this (and most of this series) to come across as:
"I have no consideration for the fact that the existing code works, and
the way in which it works, I'm just gonna rewrite all of it according to
my own sensibilities and subjective justifications, and throw baseless
words at it such as: fix this, correct that, when in fact all I'm doing
is make silly changes with no effect to the observable behavior".

Because I know that the above isn't the case, I try to be as polite as
possible expressing my frustration that I am looking at a large volume
of worthless and misguided refactoring.

