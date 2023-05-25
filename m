Return-Path: <netdev+bounces-5333-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC84A710D40
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:31:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D51B72814EB
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 13:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F8EE1079D;
	Thu, 25 May 2023 13:31:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E5EE56F
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 13:31:47 +0000 (UTC)
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C7C186;
	Thu, 25 May 2023 06:31:46 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-50bcb00a4c2so3828496a12.1;
        Thu, 25 May 2023 06:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685021504; x=1687613504;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gT/KiN/GVyh9un3dWdPg6LQ82j/4nY+K0qSJUuMUUpI=;
        b=qwY0TP99Ca/0IXyk27S4mDxmWlYNSp8F/MWDDKTv+ExOQQRSAx/ztp5tsYcLPqOysY
         BUrxc8gfNJh4f22r4z7XXHTb2bbsK+aEsh0TYxie2/eAd6IDCzwdrPl6RfEtz2GD8qx4
         xrf0bjaw4Jvhkhn8O7dVhBLuS4joNfs10SrHXpZDwDaBXt2Cd3xXw1boXhEHE97CPDQi
         ukjzCp4QzULJ4DEAHjnoRth5O8b68CULO7pqpCK/AxpHKnr3paefwDwC+9kAVhKWW5Ba
         r2ZBxx3d/9/vOKyH5n4M0afyxFQrvnN+dyngVkXo6oU+Bx7mUnis9Dg/A4eEdoT2Dy54
         JhcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685021504; x=1687613504;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gT/KiN/GVyh9un3dWdPg6LQ82j/4nY+K0qSJUuMUUpI=;
        b=M38J7dJCfPwjWpEKdojeuht9GgGYxz6an8PNOCjv940tOGdLWQFN+gA6GjoaR+TMUr
         cvq27vJknIwijkrA0rmazzcl2q/STcjIWqZVgaWsXM1oZ8l0GcU4eR3u4kYZsfnkzQJ4
         KxJ3CuGxWYB8+eUVs9vSxCG5AjE0DRhtzOnpa6ODP10kzWoo/qYWLVdPJ3i44Da67Ht+
         4xpmTBBJ4K6Y6YeDQeXOfkmFi6c7U1m3S7RhUUwrbKfa3qIXM+L3pexc+IhyJP+By/mH
         GDdICWB/Vh7lzAcRYzXNhyXT7py6vP31f8IOwDqVlXa5RPaUmNovbHdh81obUQovfKE9
         +6DA==
X-Gm-Message-State: AC+VfDyRwl+pVg5dt7KU7TbXcHnTmoelH8wg5L+exrY08jxm10pZvHVr
	dQRYdgxUKVBPtw3xBJh2SH0=
X-Google-Smtp-Source: ACHHUZ7C1fLtYhn8fZGe3ehLd1Xq/uazQq9TEEOCoBMvdYjTG9644jyrZ3G60lSa+jZQQSKib5XpTw==
X-Received: by 2002:a05:6402:204d:b0:510:ec67:22d2 with SMTP id bc13-20020a056402204d00b00510ec6722d2mr4482475edb.10.1685021504024;
        Thu, 25 May 2023 06:31:44 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id r3-20020a056402034300b0050bce352dc5sm543380edw.85.2023.05.25.06.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 06:31:43 -0700 (PDT)
Date: Thu, 25 May 2023 16:31:40 +0300
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
Subject: Re: [PATCH net-next 05/30] net: dsa: mt7530: read XTAL value from
 correct register
Message-ID: <20230525133140.xewm6g5rl7sm57d2@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-6-arinc.unal@arinc9.com>
 <20230524165701.pbrcs4e74juzb4r3@skbuf>
 <7c915d5b-56c9-430d-05ac-544f76966eb1@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7c915d5b-56c9-430d-05ac-544f76966eb1@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 09:20:08AM +0300, Arınç ÜNAL wrote:
> On 24.05.2023 19:57, Vladimir Oltean wrote:
> > On Mon, May 22, 2023 at 03:15:07PM +0300, arinc9.unal@gmail.com wrote:
> > > From: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > 
> > > On commit 7ef6f6f8d237 ("net: dsa: mt7530: Add MT7621 TRGMII mode support")
> > > macros for reading the crystal frequency were added under the MT7530_HWTRAP
> > > register. However, the value given to the xtal variable on
> > > mt7530_pad_clk_setup() is read from the MT7530_MHWTRAP register instead.
> > > 
> > > Although the document MT7621 Giga Switch Programming Guide v0.3 states that
> > > the value can be read from both registers, use the register where the
> > > macros were defined under.
> > > 
> > > Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > ---
> > 
> > I'm sorry, but I refuse this patch, mainly as a matter of principle -
> > because that's just not how we do things, and you need to understand why.
> > 
> > The commit title ("read XTAL value from correct register") claims that
> > the process of reading a field which cannot be changed by software is
> > any more correct when it is read from HWTRAP rather than MHWTRAP
> > (modified HWTRAP).
> > 
> > Your justification is that it's confusing to you if two registers have
> > the same layout, and the driver has a single set of macros to decode the
> > fields from both. You seem to think it's somehow not correct to decode
> > fields from the MHWTRAP register using macros which have just HWTRAP in
> > the name.
> 
> No, it doesn't confuse me that two registers share the same layout. My
> understanding was that the MHWTRAP register should be used for modifying the
> hardware trap, and the HWTRAP register should be used for reading from the
> hardware trap.

My understanding is that reading from the read-only HWTRAP always gives
you the power-on settings, while reading from the r/w MHWTRAP always
gives you the current settings. If those settings coincide, as happens
here, there's no practical difference.

> I see that the XTAL constants were defined under the HWTRAP
> register so I thought it would make sense to change the code to read the
> XTAL values from the HWTRAP register instead. Let me know if you disagree
> with this.

I disagree as a matter of principle with the reasoning. The fact that
XTAL constants are defined under HWTRAP is not a reason to change the
code to read the XTAL values from the HWTRAP register. The fact that
XTAL_FSEL is read-only in MHWTRAP is indeed a reason why you *could*
read it from HWTRAP, but also not one why you *should* make a change.

> > Seriously, please first share these small rewrites with someone more
> > senior than you, and ask for a preliminary second opinion.
> 
> Would submitting this as an RFC had been a similar action to your describing
> here? Because I already did that:
> 
> https://lore.kernel.org/netdev/20230421143648.87889-6-arinc.unal@arinc9.com/

In practice, volume is also an issue. The higher the volume, the lower
the chances that people will be able to crop a chunk of time large enough
to review.

> I should've given more effort to explain my reasons for this patch. I
> disagree that the series is a large volume of worthless and misguided
> refactoring and am happy to discuss it patch by patch.

I agree that the follow-up patches, as far as I could reach into this
series, are not as gratuitous as this one.

