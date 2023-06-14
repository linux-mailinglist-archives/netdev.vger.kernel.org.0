Return-Path: <netdev+bounces-10871-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51361730999
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:14:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BF142814F4
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 739DE125CD;
	Wed, 14 Jun 2023 21:13:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6460A6D3F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 21:13:59 +0000 (UTC)
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE671FFF;
	Wed, 14 Jun 2023 14:13:57 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-9768fd99c0cso24198066b.0;
        Wed, 14 Jun 2023 14:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686777236; x=1689369236;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ipkryWTzeCn4lFAJVnAmTwSDrdS5UBblgoVYILKN5NA=;
        b=KMm/rm5AsvMhw17jX+jPJuFJgPsp/l1qjp21KttZ02R/WZLKceIBGalUX06KEfNitv
         OnyPaWCrjEO60M8QWKPqkGp84mluIhRr1bR9ZK+ssh//VrdlG4BVKOjQ771ILfj0wG4c
         933QZx8Z2XkG7qxtlUYAw0Gg8qN2kIbX5A1pqu6Lc60sw+vuJz7YjRPX04N1x8pP39VS
         IPRigyfwV+Ibsy3WjKujNmRUJ5b3FkK8GsEeTrWjsGXKqzGCLdTg2o8Wm3MiU0zbnQiu
         n4Zps/KkZUCsNv/sjjNUghsJAOq2SeXAoohWnLCsE8TGWSDHHDg1O3tA+BIsy7y6Av3p
         AghQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686777236; x=1689369236;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ipkryWTzeCn4lFAJVnAmTwSDrdS5UBblgoVYILKN5NA=;
        b=L6V+tjCglw0ukhQtBc1Fz4S9vDoDy65qAvs8u8wHL+fjIf2H6XrFAv+zGM2H8GA8KZ
         qeZTbBHjoIE6wTwEGOEvmvuhpX+hLJyhQNHFmrGAIpkWJMxeuG/QHIzp1d1MUl0x/eKE
         NYTpBPrd0E4WtCJiSRkIUi/gc45z2kAqKWKZhVdMy3jLRq6gHj58uWXJw6ky5F/qkNr3
         Bhr3m1n0PjVTDE9kCg8+YIgafqg+C4EURM5odBCO6kpe9mcHVqBh18Ee7AHROjZReyDh
         /q2sqwdrVokT0lI+My9DN+SUBKKDtM/fZNgATwx1w2HgLPGgyfkKRss0YOy9sTsgl1B0
         Y5Tw==
X-Gm-Message-State: AC+VfDwP88fFwi3yj+55PQb1nuxcnal2J1n3Euq5t2nzDQaBypV4WheI
	IczP1dawfDGBJwhpUW0gKn0=
X-Google-Smtp-Source: ACHHUZ5bY3Xe8wAoc++i3xwTmoAv335BMtBiiTPZqP30EIaZjKvG5mv7LDn+0nTbxmHd07WZDNs7EA==
X-Received: by 2002:a17:907:9615:b0:968:892b:1902 with SMTP id gb21-20020a170907961500b00968892b1902mr3056941ejc.6.1686777235923;
        Wed, 14 Jun 2023 14:13:55 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id kt5-20020a170906aac500b00978868cb24csm8678230ejb.144.2023.06.14.14.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 14:13:55 -0700 (PDT)
Date: Thu, 15 Jun 2023 00:13:52 +0300
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
Subject: Re: [PATCH net v4 1/7] net: dsa: mt7530: fix trapping frames with
 multiple CPU ports on MT7531
Message-ID: <20230614211352.sls7ao5swiqjgtjz@skbuf>
References: <20230612075945.16330-1-arinc.unal@arinc9.com>
 <20230612075945.16330-1-arinc.unal@arinc9.com>
 <20230612075945.16330-2-arinc.unal@arinc9.com>
 <20230612075945.16330-2-arinc.unal@arinc9.com>
 <20230614194330.qhhoxai7namrgczq@skbuf>
 <1e737fe9-6a2e-225b-9c0f-9a069e8fd4bc@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1e737fe9-6a2e-225b-9c0f-9a069e8fd4bc@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 11:56:44PM +0300, Arınç ÜNAL wrote:
> On 14.06.2023 22:43, Vladimir Oltean wrote:
> > On Mon, Jun 12, 2023 at 10:59:39AM +0300, arinc9.unal@gmail.com wrote:
> > > From: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > 
> > > Every bit of the CPU port bitmap for MT7531 and the switch on the MT7988
> > > SoC represents a CPU port to trap frames to. These switches trap frames
> > > received from a user port to the CPU port that is affine to the user port
> > > from which the frames are received.
> > > 
> > > Currently, only the bit that corresponds to the first found CPU port is set
> > > on the bitmap. When multiple CPU ports are being used, the trapped frames
> > > from the user ports not affine to the first CPU port will be dropped as the
> > > other CPU port is not set on the bitmap. The switch on the MT7988 SoC is
> > > not affected as there's only one port to be used as a CPU port.
> > > 
> > > To fix this, introduce the MT7531_CPU_PMAP macro to individually set the
> > > bits of the CPU port bitmap. Set the CPU port bitmap for MT7531 and the
> > > switch on the MT7988 SoC on mt753x_cpu_port_enable() which runs on a loop
> > > for each CPU port.
> > > 
> > > Add a comment to explain frame trapping for these switches.
> > > 
> > > According to the document MT7531 Reference Manual for Development Board
> > > v1.0, the MT7531_CPU_PMAP bits are unset after reset so no need to clear it
> > > beforehand. Since there's currently no public document for the switch on
> > > the MT7988 SoC, I assume this is also the case for this switch.
> > > 
> > > Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
> > > Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > ---
> > 
> > Would you agree that this is just preparatory work for change "net: dsa:
> > introduce preferred_default_local_cpu_port and use on MT7530" and not a
> > fix to an existing problem in the code base?
> 
> Makes sense. Pre-preferred_default_local_cpu_port patch, there isn't a case
> where there's a user port affine to a CPU port that is not enabled on the
> CPU port bitmap. So yeah, this is just preparatory work for "net: dsa:
> introduce preferred_default_local_cpu_port and use on MT7530".
> 
> So how do I change the patch to reflect this?
> 
> Arınç

net: dsa: mt7530: set all CPU ports in MT7531_CPU_PMAP

MT7531_CPU_PMAP represents the destination port mask for trapped-to-CPU
frames (further restricted by PCR_MATRIX).

Currently the driver sets the first CPU port as the single port in this
bit mask, which works fine regardless of whether the device tree defines
port 5, 6 or 5+6 as CPU ports. This is because the logic coincides with
DSA's logic of picking the first CPU port as the CPU port that all user
ports are affine to, by default.

An upcoming change would like to influence DSA's selection of the
default CPU port to no longer be the first one, and in that case, this
logic needs adaptation.

Since there is no observed leakage or duplication of frames if all CPU
ports are defined in this bit mask, simply include them all.

Note that there is no Fixes tag

