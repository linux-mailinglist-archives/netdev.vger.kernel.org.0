Return-Path: <netdev+bounces-11382-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B527732D7A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:25:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E988A1C20864
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:25:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC3EF18AE8;
	Fri, 16 Jun 2023 10:25:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE675DDC9
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:25:27 +0000 (UTC)
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62FF137;
	Fri, 16 Jun 2023 03:25:25 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-51a1d539ffaso1278672a12.0;
        Fri, 16 Jun 2023 03:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686911124; x=1689503124;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A5xA3WpiWD7/SJz12VfIiDnQC9qfWts98XdM2oognM0=;
        b=GgAJGkNHzUN5nGMb3pM6DX4PWANxQZwcU/HS6COioHphK2zTPH5/1y6x9pFqKfpnA0
         b0nHbiWbdbZZuN0/OEgwhQ/uN7Y2N5pfk5/9wKnanUKkSEvZ+vX1VB7Z/tqCpo/Aju6z
         LnbfhSbOFcKAmo/xsnWjVbA/tjTTVH2ISxJGQxjtsm+GUXKNkKFgjwT8OG+Pgf3YgKps
         6vyQOP/v/PbF9dbrVETq+uqseS4r9Y7WoKy4Us8bmjdAnFYJbQsCR4Qoj94u7VCNndOr
         T3b6lla8591dp2GOpXjSUOYucBLNpkYDwtrU82H8bKTYSgPxvNhinCr1MwpmL51Ng2xu
         J1lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686911124; x=1689503124;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A5xA3WpiWD7/SJz12VfIiDnQC9qfWts98XdM2oognM0=;
        b=ChTczWc2QtVLtzCyb+HVta1WgB0YYz/I+s1rrbUkHBRuAn7/vE2xsGQGJcH3Mn8yE9
         /cFdU2HHnsDt12je1Wxb/8bzaidOYmeEK//Vrc3+4ULJ3N44CdThbLzQeCh2BekVi7Ik
         F8zl2nh9DI4/BEs7LoAdth56dg9zPz1VLTWQVvGp3qbuwTfMnN8Av1LhqZyCL7zpcJEf
         cuHTvTB3ojdfV9bQJbY9roRPcoWMdWz1+cWkwT/bfB4a5UVHIFyMHgO+i/hUVEOAGdJH
         4J20somiCn8BhyrFWctskMCI9UgTGYq6W3RbmYxrphkDjA26PCd7nntji2vULapvIzbG
         2SQA==
X-Gm-Message-State: AC+VfDw8ity0NTSAAbiI4pnQyQERWIQmlZaQ6DscIt1wI7cR4PvY4Pqr
	lo21zX2GtZrdOZNLYUHIjg4=
X-Google-Smtp-Source: ACHHUZ4NHpdm+Rw5V7Fqw2OSVcV0DEjRQSxtenZ0W+4iofjpObAu4Lv75YsiFyCEWztfWpmcqQOcYA==
X-Received: by 2002:a05:6402:4409:b0:51a:409f:a0bd with SMTP id y9-20020a056402440900b0051a409fa0bdmr310207eda.19.1686911124006;
        Fri, 16 Jun 2023 03:25:24 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id s13-20020aa7cb0d000000b005163a6c9f18sm9721634edt.53.2023.06.16.03.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 03:25:23 -0700 (PDT)
Date: Fri, 16 Jun 2023 13:25:20 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: arinc9.unal@gmail.com,
	=?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
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
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v5 2/6] net: dsa: mt7530: fix trapping frames on
 non-MT7621 SoC MT7530 switch
Message-ID: <20230616102520.4uvuhywkcpk5ljtk@skbuf>
References: <20230616025327.12652-1-arinc.unal@arinc9.com>
 <20230616025327.12652-3-arinc.unal@arinc9.com>
 <20230616100314.x2qak6t7uxo2qnja@skbuf>
 <ZIw20jmqI1d/W+YY@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZIw20jmqI1d/W+YY@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 11:17:54AM +0100, Russell King (Oracle) wrote:
> On Fri, Jun 16, 2023 at 01:03:14PM +0300, Vladimir Oltean wrote:
> > On Fri, Jun 16, 2023 at 05:53:23AM +0300, arinc9.unal@gmail.com wrote:
> > > From: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > 
> > > The check for setting the CPU_PORT bits must include the non-MT7621 SoC
> > > MT7530 switch variants to trap frames. Expand the check to include them.
> > > 
> > > Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> > > Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > ---
> > 
> > why do you say non-MT7621 when the change specifically includes MT7621?
> > What is the affected SoC then?
> 
> Thanks for falling into one of the issues that makes reviewing these
> patches difficult. :/
> 
> > > -	if (priv->id == ID_MT7621)
> > > +	if (priv->id == ID_MT7530 || priv->id == ID_MT7621)
> > >  		mt7530_rmw(priv, MT7530_MFC, CPU_MASK, CPU_EN | CPU_PORT(port));
> 
> I *think* what the commit message should be saying is that the setup
> for the CPU port(*) is necessary not only for MT7621, but also for
> MT7530 variants as well.
> 
> That can be construed from the commit message, but it doesn't easily
> read that way.
> 
> * - in this case, it's the CPU port field and the CPU enable bit.
> Note that CPU_MASK only covers CPU_PORT() and not CPU_EN, but this
> doesn't matter for mt7530_rmw().
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

Ah, no, I just misread the patch, because the new term was added to the
left of the existing one, and not to the right as I would have expected.
I though it was this:

> > > -	if (priv->id == ID_MT7530)
> > > +	if (priv->id == ID_MT7530 || priv->id == ID_MT7621)

thus my confusion and my question.

I'm okay with the change now.

