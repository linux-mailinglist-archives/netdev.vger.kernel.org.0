Return-Path: <netdev+bounces-10874-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6583C7309B4
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:19:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24D94281511
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:19:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39902134A1;
	Wed, 14 Jun 2023 21:19:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB4B125D5
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 21:19:52 +0000 (UTC)
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697C4E6C;
	Wed, 14 Jun 2023 14:19:51 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2b1badb8f9bso17292631fa.1;
        Wed, 14 Jun 2023 14:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686777589; x=1689369589;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Nemu++hPj2kZikPl1h1oFSjdDD6MXcNHrSfYyeHRBSA=;
        b=K/lcj/WhaymrAJKwK3wCNX/IP+Uj2hQlyTWOYtbrDnna+Zn/1U/aPLNhDUFJje8ftf
         +f4A9UMYaFallKxzRLKEjK+81Po3+R0r7WurrHsupMIiIIq7IoR7+49e2ALM6E4rKX7M
         +Fhe1yncce3qwqj5wzdKa15Puvnt+IatDOjf4iRqxZewf0BY896aumsTH+F448y9FUwG
         QeX+iQVCVKsgEq9ZfTEp8PQfnL9Mrj8Xp7O1Hvny5iYJER0aQXx0hG4VFB/+ug5Z9RNg
         SUn7eWKFU7C3ZL1muAqYaoenkb4PVvRP7Wb8sPwgmgQdb+hiWdug7kBEKwfr3XjVNg2W
         CDvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686777589; x=1689369589;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nemu++hPj2kZikPl1h1oFSjdDD6MXcNHrSfYyeHRBSA=;
        b=YqWqFSyzMhDcGH/Bh79oze2kgjqKrYZOr/tNwE/1h4aczEi4j9X2SmiAHrnrrwRLch
         g2WCBGSRCbDM9RlNrDRS3Pk2weLt02dFAX9jb/czWm9dCkJA7ffWedMhzmEbNvFwtetu
         XEhaZ2/4ivArTG9Bs19gOdvYuK8nUyfl2LXLshpkowEtrOFlUKMRwKgWdDGa2fmyiL4B
         kM8F84rF0fT4hu6E+oRMnLTZfHrsmuifcGjIvtoQ9dvjeE9kxPvritfS9iZPZh9UeWYk
         YD//6KfCoEdh2xfsz5qn/5Uy3N5DRheybI+wLASgqzpu9SbZjfqZI8fby43WgiTTnvYE
         jrCg==
X-Gm-Message-State: AC+VfDyM6XJ5I9EoWVglWHlpBDsrrx83CTTC6bRoUJHg31QUBi4BRHl1
	qk1ljh05fgxPHGujnhYsL0Q=
X-Google-Smtp-Source: ACHHUZ45TXehjwCg06WrJDg32kyOgof1iYjc9nhggwSBO8ctiPoSkAmPEpPRJy958E5G0j8EY+3Ykg==
X-Received: by 2002:ac2:5a0c:0:b0:4f6:2846:b1fb with SMTP id q12-20020ac25a0c000000b004f62846b1fbmr9411995lfn.18.1686777589293;
        Wed, 14 Jun 2023 14:19:49 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id f13-20020a170906390d00b009584c5bcbc7sm8408004eje.49.2023.06.14.14.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 14:19:48 -0700 (PDT)
Date: Thu, 15 Jun 2023 00:19:45 +0300
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
Subject: Re: [PATCH net v4 3/7] net: dsa: mt7530: fix trapping frames on
 non-MT7621 SoC MT7530 switch
Message-ID: <20230614211945.frpzl56uasb3qnwp@skbuf>
References: <20230612075945.16330-1-arinc.unal@arinc9.com>
 <20230612075945.16330-4-arinc.unal@arinc9.com>
 <20230614201336.lf5hqrp5nw7han4r@skbuf>
 <581f410d-e94f-e980-f54b-b870017ba73c@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <581f410d-e94f-e980-f54b-b870017ba73c@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 11:59:33PM +0300, Arınç ÜNAL wrote:
> On 14.06.2023 23:13, Vladimir Oltean wrote:
> > On Mon, Jun 12, 2023 at 10:59:41AM +0300, arinc9.unal@gmail.com wrote:
> > > From: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > 
> > > The check for setting the CPU_PORT bits must include the non-MT7621 SoC
> > > MT7530 switch variants to trap frames. Expand the check to include them.
> > > 
> > > Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> > > Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > ---
> > >   drivers/net/dsa/mt7530.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> > > index ef8879087932..2bde2fdb5fba 100644
> > > --- a/drivers/net/dsa/mt7530.c
> > > +++ b/drivers/net/dsa/mt7530.c
> > > @@ -3073,7 +3073,7 @@ mt753x_master_state_change(struct dsa_switch *ds,
> > >   	 * the numerically smallest CPU port which is affine to the DSA conduit
> > >   	 * interface that is up.
> > >   	 */
> > > -	if (priv->id != ID_MT7621)
> > > +	if (priv->id != ID_MT7530 && priv->id != ID_MT7621)
> > >   		return;
> > 
> > This patch and 2/7 should probably be reversed, since 2/7 is not going to net.
> 
> This patch is still necessary. It'll just modify the other location instead
> of here.
> 
> https://github.com/arinc9/linux/commit/4c8b983f7a95ba637799ccd1b700ee054b030729
> 
> Arınç

That's basically what I said, sorry if I wasn't clear.

