Return-Path: <netdev+bounces-5149-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1017770FD09
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 19:46:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BED2D281385
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F38C1F190;
	Wed, 24 May 2023 17:46:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A50538B
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 17:46:10 +0000 (UTC)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5D01A8;
	Wed, 24 May 2023 10:45:39 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-50bcb229adaso2451961a12.2;
        Wed, 24 May 2023 10:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684950338; x=1687542338;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nWBdICZs1ylHFsz8zslSqh0ccqIAuQOZUPv8JnOg1n4=;
        b=Ph7hH4NN5Xzd3WzBdsSVQS8+U87aBSWIrpyy7+WW0QkU1h5rnmAglEqXX+qT8idyBn
         tuGBsqy4bNR0P53kYTfSXcv1RVx8P56JrjDguFJ2xDB2Jik1T7xuU68m7BLTI6vydpBx
         4/vYBbe6gwOchR/v4SnWspk2/qa+klTSroJ/HZE9nio1csB5CsvtuWQBAw3X2wM5N72V
         RWOe1yPtyX+SB1o+4y7Vfl1FqeSZah/FtQcfO7aAisxjzo96nvUquvYRLFzTHHRJYfMB
         we7KhGHMmZmN1xxtrD17MLFmjbw8pI8ji/9G6fRM7laNyrmArTJCgVKO4wfxQTUk5mg6
         DTXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684950338; x=1687542338;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWBdICZs1ylHFsz8zslSqh0ccqIAuQOZUPv8JnOg1n4=;
        b=aHYMhV6KrwbFanPLkA1Fb+EeyhXNrNwpq+xnD1VAJG2fvV3hLnmDNHHwBVS1XWLjqE
         RBu74f7+nLJL1pBKrigxM0OSE/k9lHeE95pn/T9SzvW5nSOroQMYCipXxFTZNAo7DZII
         xdCYe7OsWpKZDMq3o65vBAV5aZAXFgfNwSghQol8Q/jtVQB0SCDAUWiDuBmZclXYlpnn
         ot4jmPoj0BOUf5v4WHtH1H+J2LQ3BtQjrJfSe953GoXQ/8/WWMxyh5O/NbR16CMimAwt
         Ecoe2FuGoqNJES/9OPBFyZk6FIXboUBcDCUs14HpZyZXeYBSUel4ZaYdfDLoqdUGTC9m
         IWXQ==
X-Gm-Message-State: AC+VfDxouFjzlxxp1QMP6RU0E5KfFpP+Lr3VXDdMzQW5eu2PXqPCHHrg
	JV9+K4n824n+KBmI3xrr2Ps=
X-Google-Smtp-Source: ACHHUZ5kNjjMXypD+xFlWxn/uIyXBW8jfQ4bsLcwCAUAU/F/MLjAg+8IbDjx5a+657iaeX5f2L+AEg==
X-Received: by 2002:a17:907:9809:b0:966:23e5:c8f7 with SMTP id ji9-20020a170907980900b0096623e5c8f7mr17741535ejc.62.1684950338056;
        Wed, 24 May 2023 10:45:38 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id ja26-20020a170907989a00b0096b55be592asm6025738ejc.92.2023.05.24.10.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 10:45:37 -0700 (PDT)
Date: Wed, 24 May 2023 20:45:34 +0300
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
Subject: Re: [PATCH net-next 07/30] net: dsa: mt7530: do not run
 mt7530_setup_port5() if port 5 is disabled
Message-ID: <20230524174534.hcxn6tjhjmho6io7@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-8-arinc.unal@arinc9.com>
 <20230522121532.86610-8-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230522121532.86610-8-arinc.unal@arinc9.com>
 <20230522121532.86610-8-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:15:09PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> There's no need to run all the code on mt7530_setup_port5() if port 5 is
> disabled. The only case for calling mt7530_setup_port5() from
> mt7530_setup() is when PHY muxing is enabled. That is because port 5 is not
> defined as a port on the devicetree, therefore, it cannot be controlled by
> phylink.
> 
> Because of this, run mt7530_setup_port5() if priv->p5_intf_sel is
> P5_INTF_SEL_PHY_P0 or P5_INTF_SEL_PHY_P4. Remove the P5_DISABLED case from
> mt7530_setup_port5().
> 
> Stop initialising the interface variable as the remaining cases will always
> call mt7530_setup_port5() with it initialised.
> 
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

