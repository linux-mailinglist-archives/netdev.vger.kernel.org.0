Return-Path: <netdev+bounces-7769-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D5E5721734
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 15:08:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 916FE281136
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 13:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC2C4A94F;
	Sun,  4 Jun 2023 13:08:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10A233F2
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 13:08:20 +0000 (UTC)
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BB31A8;
	Sun,  4 Jun 2023 06:08:13 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-51456392cbbso10430978a12.0;
        Sun, 04 Jun 2023 06:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685884092; x=1688476092;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ehsXLibKE7EsdL7h37Ey3hxWw2NtYcUCkyRCtwhN2Ag=;
        b=ho+w3R3eBSHT8APyM7DlSIiJgXHu4swFXy6oR7N4hSWfBv4/VSLDlCoenkxDecIIlT
         2+LSHeMWaiAkSJRBhQOF0gj8sXyagxD4+joGAovn0s8rgH4HAIg2vLslWxfoyu9ui6Fu
         OlGh3SmmHNly48F0zQ4V/bEY/w6BNQ8D7iN64zGovx2m6blJc24vJnmkCGgr904JwbHJ
         rRNMnRblhHbjaonYZhEO1tajssgFtoPZb8r4PLZ/J7ypsYZKbwhSe/TIVbaiZ+Tett0f
         tLQ+5rBRC84k0ATMBhVTl2UcI9J8XkHk+h6psOo3h0xlqUICdWWX9pyvfey8ekmv1MZF
         XDbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685884092; x=1688476092;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ehsXLibKE7EsdL7h37Ey3hxWw2NtYcUCkyRCtwhN2Ag=;
        b=iBMWsl98xz5aVyHXlxaOpmlnobLjmHXmEhuNdOMlIkq7b6ts4+iRiviOW8CpxgkK5a
         l8QEbi5bYf53IvjR9y/kYlyHRInLt3Rs2lZuAQyXlje0A1pVrJ8Ngpj1OXsApxr0C2NN
         /4ybihCS3JUvmJIE6kD3vx1mdYwUi7vML8uJYO+TJGrH7u2CtnQvhx7nOwqAaWQ0d6Ub
         he/iD4R/N0FtgFAtgb/e2noFKh+4w+sleEIGnJbVoXOx4QNqOw252DF1t26BQcZzJ5Mx
         v36qfXp4NIkXzwoVgFrX7U5JIyFPNxzmjJ7hA3PR3UquZL1xtf/2BFtHcQPUzr5yhEH0
         GucQ==
X-Gm-Message-State: AC+VfDwpTnIHJBQMBl4X63HIVmspVTZDvu1CJ9sGOKj/DBPAdcBeJTab
	vNSH7FeBvxNCjrHtq5P/5cQ=
X-Google-Smtp-Source: ACHHUZ59tILfc6BM6SJHOqRlylQ71wlvooctdxI8yBhJwx+vZqx3AMdIhV5aVsgRYPcUsvofHoWPVQ==
X-Received: by 2002:a05:6402:34c4:b0:516:5b18:a9f1 with SMTP id w4-20020a05640234c400b005165b18a9f1mr836092edc.0.1685884091938;
        Sun, 04 Jun 2023 06:08:11 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id b9-20020aa7dc09000000b005149e64260esm2773600edu.16.2023.06.04.06.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 06:08:11 -0700 (PDT)
Date: Sun, 4 Jun 2023 16:08:08 +0300
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
Subject: Re: [PATCH net-next 25/30] net: dsa: mt7530: properly set
 MT7531_CPU_PMAP
Message-ID: <20230604130808.3lxuz5ezsouhku57@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-26-arinc.unal@arinc9.com>
 <20230522121532.86610-26-arinc.unal@arinc9.com>
 <20230526155124.sps74wayui6bydao@skbuf>
 <9423a818-f9c0-d867-7f7d-27f05e1536b9@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9423a818-f9c0-d867-7f7d-27f05e1536b9@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 11:21:48AM +0300, Arınç ÜNAL wrote:
> > Stylistically, the existence of an indirect call to priv->info->cpu_port_config()
> > per switch family is a bit dissonant with an explicit check for device id later
> > in the same function.
> 
> mt753x_cpu_port_enable() is not being called from priv->info->cpu_port_config()
> though.

Quite the other way around. I'm saying that mt753x_cpu_port_enable(),
the function whose logic you're changing, already has a mechanism to
execute code specific to one switch family.

> I'm not sure how I would do this without the device ID check here.

Hmm, by defining a new mt7530_cpu_port_config() procedure for ID_MT7621
and ID_MT7530?

Although in a different thread we are perhaps challenging the idea that
what is currently in priv->info->cpu_port_config() is useful - at least
half of it are manual invocations of phylink methods which are possibly
not needed. If after the removal of those, it no longer makes sense to
have priv->info->cpu_port_config() at all, then I'm not saying that the
explicit check for device id here doesn't make sense. Just that it's not
in harmony with what currently exists 3 lines above.

> > > -#define  MT7531_CPU_PMAP_MASK		GENMASK(7, 0)
> > > +#define  MT7531_CPU_PMAP(x)		((x) & 0xff)
> > 
> > You can leave this as ((x) & GENMASK(7, 0))
> 
> Now that I've read Russell's comment on the previous patch, the below would
> be even better?
> 
> MT7531_CPU_PMAP(x)		FIELD_PREP(MT7531_CPU_PMAP_MASK, x)
> 
> > 
> > > +#define  MT7531_CPU_PMAP_MASK		MT7531_CPU_PMAP(~0)
> > 
> > There's no other user of MT7531_CPU_PMAP_MASK, you can remove this.
> 
> Should I do above or remove this?

No specific preference. If you want to make this driver start using
FIELD_PREP() then go ahead.

