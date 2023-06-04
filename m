Return-Path: <netdev+bounces-7771-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC2E5721750
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 15:17:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51D61281164
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 13:17:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CD44AD23;
	Sun,  4 Jun 2023 13:17:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424CA33F2
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 13:17:42 +0000 (UTC)
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B63B8;
	Sun,  4 Jun 2023 06:17:40 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-977c88c9021so164109766b.3;
        Sun, 04 Jun 2023 06:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685884659; x=1688476659;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7koqCf4VFYg5A/2SlKvWQmfNZkGvHu+fwrX65NT2BI4=;
        b=jMZgvtnFApMUryc5DT7S8bjme4Qu0G0eeb8MHj7I7ZZSFcLIIEE66aQJvSX9v/PjSK
         Qla4Dhh0sY0o4psUyfZVUyJl8vHiKe/wIKZk9rBAtRzpjgjE5gTEWS/BbzRI8g6sd64d
         52OB/NWm8zms+Xw8EzaCDLo4GxvRLVV+aGWKQyjFGPX9zY8W7cmVcuijwWSqM9iZ5CAe
         kPVZh48BVRYR8ehICFc1RRXkSnnFRip4jEY9ZAwd21rD+yil3n//VdMNcJFN/nUnf8mv
         wCy4L/3tCKgikqc2Abaji7GTuVRmjqd3dstJg0uitXWM1WlmUZMINZGlkY3qZwngIDob
         fUeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685884659; x=1688476659;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7koqCf4VFYg5A/2SlKvWQmfNZkGvHu+fwrX65NT2BI4=;
        b=Gmesh5OfdRc0WM7dwnpNHKnyQyS7mSaL6dsfcuiD4QDF7rwDKu3sUJNUJJZFdsGvsh
         jMIbjatPX678eAoHpnc+NvZKYodDrSam8NO15nfP2ROgPdwv6/9hTF1avvd6nodsvNpp
         n3N7SwZuHdHst/Mfu2hKo+uHXaQ61bpTU6x+rAmE9qnfbei4liCNzi1WQYFMzkBl8kS2
         aZiC3JBNbR9wE4BKs5LjVzyEPaLugymOepd8pGUhBW7lVbh1mADTYcbaeHC5b0BcxFCK
         7bg/MY4L1wPnkxTZw5Pv8L5D6Yo9ySApPkW8PqC6XiCJfNnS3dcrYf4/MdYQ/IJ4h/x3
         6B5Q==
X-Gm-Message-State: AC+VfDxOBtHu3M/TxwZKKj3Pm6LvdHpBbepp5YtteKxZ57H2S7TEfkrx
	gqlnyR5TIVi4srQyYFCiMUk=
X-Google-Smtp-Source: ACHHUZ7saaoTRYRxO+7KKd51tlh3hT91vDB1ym0R5O2wcD/2PGqGdEjATdeMyC7eoypX6390GMp+xw==
X-Received: by 2002:a17:907:720c:b0:973:ff8d:2a46 with SMTP id dr12-20020a170907720c00b00973ff8d2a46mr4415968ejc.3.1685884658963;
        Sun, 04 Jun 2023 06:17:38 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id s18-20020a056402165200b00510b5051f95sm2730393edx.90.2023.06.04.06.17.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 06:17:38 -0700 (PDT)
Date: Sun, 4 Jun 2023 16:17:35 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
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
Subject: Re: [PATCH net-next 24/30] net: dsa: mt7530: rename MT7530_MFC to
 MT753X_MFC
Message-ID: <20230604131735.f2clcinq67wspuun@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-25-arinc.unal@arinc9.com>
 <20230526154258.skbkk4p34ro5uivr@skbuf>
 <ZHDVUC1AqncfF2mK@shell.armlinux.org.uk>
 <e4aff9aa-d0c6-1f2e-7f16-35df59d51b90@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e4aff9aa-d0c6-1f2e-7f16-35df59d51b90@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 11:06:32AM +0300, Arınç ÜNAL wrote:
> > Even better are:
> > #define  MT7531_MIRROR_PORT_GET(x)	FIELD_GET(MT7531_MIRROR_MASK, x)
> > 
> > > > +#define  MT7531_MIRROR_PORT_SET(x)	(((x) & 0x7) << 16)
> > > 
> > > and here: (((x) << 16) & GENMASK(18, 16))
> > 
> > #define  MT7531_MIRROR_PORT_SET(x)	FIELD_PREP(MT7531_MIRROR_MASK, x)
> > 
> > No need to add parens around "x" in either of these uses as we're not
> > doing anything with x other than passing it into another macro.
> 
> Thanks. I suppose the GENMASK, FIELD_PREP, and FIELD_GET macros can be
> widely used on mt7530.h? Like GENMASK(2, 0) on MT7530_MIRROR_MASK and
> FIELD_PREP(MT7530_MIRROR_MASK, x) on MT7530_MIRROR_PORT(x)?

I suppose the answer would be "yes, they can be used", but then, I'm not
really sure what answer you're expecting.

