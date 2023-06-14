Return-Path: <netdev+bounces-10849-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CAA527308A4
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:44:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AB4C281549
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D19E11CA8;
	Wed, 14 Jun 2023 19:44:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5121711CA3
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 19:44:02 +0000 (UTC)
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03542702;
	Wed, 14 Jun 2023 12:43:36 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-976a0a1a92bso172733766b.1;
        Wed, 14 Jun 2023 12:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686771815; x=1689363815;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wo2k8B7MGNyxmh3jaU19PWvWJJrdjMUIt4dfyXki7UM=;
        b=hhV5dkXmdZjOD+oCwVkjm+9276XiooihM6cbKdbPUe3KqBZfH9hX+fIL0LO9xZD1bB
         0cb6PPHnur5fU2vRZ1jDHw/SrwFRdfL5PrUBc85QzwgfqHa8BQw+63yln12/bf2tCACQ
         cicqZPwDh0+t6LhqETb2+pabhlKhEiFqV5dhd8XDOaOAGYBrtv1X0WNns9hKBZKFh1Oz
         pignhGM7d5IOd3g1w/4WqY3ohWlvju0/ytScdGTjAcG42Vg2V3KrlFIGFTUy4IQHt2yk
         OmPVu7rhNN5qgRfdEVU7ihV7jHjH3v4DQlZQ/UdY8BbfE4ZKfgOuz2XvSyz9dCfFxuSj
         b1Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686771815; x=1689363815;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wo2k8B7MGNyxmh3jaU19PWvWJJrdjMUIt4dfyXki7UM=;
        b=IzhloRQvWM6C2k+0yi8g+pygcX222Zr7I66/jJrtx4pbvR1DFfnW6ZVena6zpgFbF1
         Xhhvl9134Ye8462jVsH0zW1SSaCjKfU7VFkJ+U9+ou3XbGZC4mMH+tD2naruenqtDvd5
         bhH93lh+tivn/vTU/CRiZf1Lqg9NGzeCEhOkArvKXT8xVo8rY4nqzq1G9YPQjMmSsQR/
         YPomctjstPBWsAYTQc1MQZMxCAGOA4bzjugg4wsV7y/O/A9dZ4hLVRh/tXuhv9x/n97N
         qGl9MvzT4w5Dlzxr5kjeJCAXFFjuEvRyC5QcTodSUH/RjVSAmlVFkWgVbpI8vN/JxhO8
         BMsA==
X-Gm-Message-State: AC+VfDwFKthqPuau71AihvJZqw+HuOCow8ElzMAAA9RfN6pNZ2oLRLur
	rsg5NtYJDMh29EIUJMtDgmE=
X-Google-Smtp-Source: ACHHUZ4NiRdlI3efpenlQNXYrF7h5UVq223WzRqbYZ7tNAOpGXI5j/pTyx1uqiZas/x6Nhx1dWRTxA==
X-Received: by 2002:a17:907:2684:b0:96f:45cd:6c21 with SMTP id bn4-20020a170907268400b0096f45cd6c21mr17745808ejc.30.1686771815063;
        Wed, 14 Jun 2023 12:43:35 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id rs15-20020a170907036f00b009823e62ca91sm2517430ejb.189.2023.06.14.12.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 12:43:34 -0700 (PDT)
Date: Wed, 14 Jun 2023 22:43:30 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: arinc9.unal@gmail.com
Cc: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
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
	Russell King <linux@armlinux.org.uk>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v4 1/7] net: dsa: mt7530: fix trapping frames with
 multiple CPU ports on MT7531
Message-ID: <20230614194330.qhhoxai7namrgczq@skbuf>
References: <20230612075945.16330-1-arinc.unal@arinc9.com>
 <20230612075945.16330-1-arinc.unal@arinc9.com>
 <20230612075945.16330-2-arinc.unal@arinc9.com>
 <20230612075945.16330-2-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230612075945.16330-2-arinc.unal@arinc9.com>
 <20230612075945.16330-2-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 10:59:39AM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> Every bit of the CPU port bitmap for MT7531 and the switch on the MT7988
> SoC represents a CPU port to trap frames to. These switches trap frames
> received from a user port to the CPU port that is affine to the user port
> from which the frames are received.
> 
> Currently, only the bit that corresponds to the first found CPU port is set
> on the bitmap. When multiple CPU ports are being used, the trapped frames
> from the user ports not affine to the first CPU port will be dropped as the
> other CPU port is not set on the bitmap. The switch on the MT7988 SoC is
> not affected as there's only one port to be used as a CPU port.
> 
> To fix this, introduce the MT7531_CPU_PMAP macro to individually set the
> bits of the CPU port bitmap. Set the CPU port bitmap for MT7531 and the
> switch on the MT7988 SoC on mt753x_cpu_port_enable() which runs on a loop
> for each CPU port.
> 
> Add a comment to explain frame trapping for these switches.
> 
> According to the document MT7531 Reference Manual for Development Board
> v1.0, the MT7531_CPU_PMAP bits are unset after reset so no need to clear it
> beforehand. Since there's currently no public document for the switch on
> the MT7988 SoC, I assume this is also the case for this switch.
> 
> Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

Would you agree that this is just preparatory work for change "net: dsa:
introduce preferred_default_local_cpu_port and use on MT7530" and not a
fix to an existing problem in the code base?

