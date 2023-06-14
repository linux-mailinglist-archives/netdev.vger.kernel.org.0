Return-Path: <netdev+bounces-10882-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 425897309F0
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:43:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECA3C280DD5
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:43:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46DCF134BB;
	Wed, 14 Jun 2023 21:43:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22055125D5
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 21:43:19 +0000 (UTC)
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1792689;
	Wed, 14 Jun 2023 14:43:18 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-98284402adeso26322566b.1;
        Wed, 14 Jun 2023 14:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686778997; x=1689370997;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6DlSsbuLakE8qwRDvFOYvEZK8aqxRJUH47dNWQGOtVo=;
        b=OhLcqVWvNWCD/pVF0vAVEOqlWSZR0rR9Uy3FJYd7H/bVyFE9/zXuYmUqD573EtqpvL
         MLcKoWS1DAnSWuwizosGkMCrxEDXzKQk0L3cD9muL6NADw9VwjVESqoF7B4MY/aJUZUE
         KARwDPECfwdM+ZlRhr+pEFwJSjIidM05O4HnDfXC7vbc9TO/HD7OpOIzhSV952go2Imp
         ULmySsUqHWCsb/3v/npQEKWczHHmllafaGyKvwPwLOabawIlmETBJAHIOzK89nkRYUSL
         Z/6DLQDYnuHT3AJtcuOjcTRftQ3v7LIsyz/ZO7/fnwkwPSs6Ts79pP1KqFfiYE5HSKlX
         ZgYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686778997; x=1689370997;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6DlSsbuLakE8qwRDvFOYvEZK8aqxRJUH47dNWQGOtVo=;
        b=i9E02LesXMV7qQnsuFaN9J7jOGy8Isj+sSUlgu5UVglD8w1QQsq29NugQUZUdsHDBO
         hoMbpLIcx9Ro45M80SzrlyA/erLRBD02D7Agl4uNb1xitZ/tQDDYqnZbmdUsMp8jcwM9
         baJi1I1JTBOuGTDHk975I7fNRcgcgBEZlxdD3fHRNExhqdD5ggxrjRI9TzO9jQteC1D/
         RjW0rjem35ipSKNaUz7VSbvXJdSh5/JUg2Jtf4TA8phOOCZh/VtkrlVEA94GKYJECsFp
         mNMlwM1AkTQjYhQMc+c7zha640INAEXRRb9nClLXFsCL9a4CQhgDDn00mAl3lHHh38VE
         4Zhw==
X-Gm-Message-State: AC+VfDyZVPpI5IL5JbwHxAjLPahrk1kXI4sSpcGpxdu8wgDq08BmaxBy
	Wf3ow+yUC+ChKrjxcX4e690=
X-Google-Smtp-Source: ACHHUZ43JnHdG/ZDbEpsP/J1DKoBrMCWsqe7Mv4c57IVGVWo1WI90SGnN9hU0JCewkI7+lo1xn8PFw==
X-Received: by 2002:a17:907:a40d:b0:982:a1b9:a5d8 with SMTP id sg13-20020a170907a40d00b00982a1b9a5d8mr17590ejc.15.1686778996667;
        Wed, 14 Jun 2023 14:43:16 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id w13-20020a056402070d00b00518337f4453sm5148631edx.75.2023.06.14.14.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 14:43:16 -0700 (PDT)
Date: Thu, 15 Jun 2023 00:43:13 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
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
Subject: Re: [PATCH net v4 5/7] net: dsa: mt7530: fix handling of LLDP frames
Message-ID: <20230614214313.oezqcs3jdpsll5k4@skbuf>
References: <20230612075945.16330-1-arinc.unal@arinc9.com>
 <20230612075945.16330-6-arinc.unal@arinc9.com>
 <ZInt8mmrZ6tCGy1N@shell.armlinux.org.uk>
 <3eaf5a2c-6ef2-e43a-1d0e-08ec4e1ee7e8@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3eaf5a2c-6ef2-e43a-1d0e-08ec4e1ee7e8@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 11:52:24PM +0300, Arınç ÜNAL wrote:
> On 14.06.2023 19:42, Russell King (Oracle) wrote:
> > On Mon, Jun 12, 2023 at 10:59:43AM +0300, arinc9.unal@gmail.com wrote:
> > > From: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > 
> > > LLDP frames are link-local frames, therefore they must be trapped to the
> > > CPU port. Currently, the MT753X switches treat LLDP frames as regular
> > > multicast frames, therefore flooding them to user ports. To fix this, set
> > > LLDP frames to be trapped to the CPU port(s).

so far so good

> > > 
> > > The mt753x_bpdu_port_fw enum is universally used for trapping frames,
> > > therefore rename it and the values in it to mt753x_port_fw.

yeah, this part of the patch is not useful at all [ here ]

> > > 
> > > For MT7530, LLDP frames received from a user port will be trapped to the
> > > numerically smallest CPU port which is affine to the DSA conduit interface
> > > that is up.
> > > 
> > > For MT7531 and the switch on the MT7988 SoC, LLDP frames received from a
> > > user port will be trapped to the CPU port that is affine to the user port
> > > from which the frames are received.

redundant and useless information here - what's important here is that
they're trapped, not where

> > > The bit for R0E_MANG_FR is 27. When set, the switch regards the frames with
> > > :0E MAC DA as management (LLDP) frames. This bit is set to 1 after reset on
> > > MT7530 and MT7531 according to the documents MT7620 Programming Guide v1.0
> > > and MT7531 Reference Manual for Development Board v1.0, so there's no need
> > > to deal with this bit. Since there's currently no public document for the
> > > switch on the MT7988 SoC, I assume this is also the case for this switch.

I guess that the reader who isn't familiar with the hardware will never
get to ask himself "is the unrelated R0E_MANG_FR bit set ok?", and the
familiar reader can just look that up in the programming guides that are
available, and see the default value and that the driver doesn't change it.

So I just don't see how this bit of information is relevant in this
patch. Sure, by all means, provide all context that helps the reader to
understand the change, but at the same time: less is more.

> > > 
> > > Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> > 
> > Patch 4 claims to be a fix for this commit, and introduces one of these
> > modifications to MT753X_BPC, which this patch then changes.
> > 
> > On the face of it, it seems this patch is actually a fix to patch 4 as
> > well as the original patch, so does that mean that patch 4 only half
> > fixes a problem?
> 
> I should do the enum renaming on my net-next series instead, as it's not
> useful to what this patch fixes at all.

please do so (assuming that the enum really has to be changed).

also, if you're not really sure that this behavior has impacted any user
(including yourself), I suppose there's also the option of fixing this in
net-next as one of the earliest patches, independent from any other rework,
so that in case there's a request to backport it to stable, it's possible.
I remember having suggested this once already.

