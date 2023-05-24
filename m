Return-Path: <netdev+bounces-5145-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E85E570FCBF
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 19:35:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 667671C20D76
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BC7A1D2A5;
	Wed, 24 May 2023 17:35:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D4819E6E
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 17:35:19 +0000 (UTC)
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C533123;
	Wed, 24 May 2023 10:35:15 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-510d9218506so145911a12.1;
        Wed, 24 May 2023 10:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684949714; x=1687541714;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UuWZGCzkbOMRI3DKUsjT1bBZX5K7moJ19ldgpCy0JvM=;
        b=UshDxhlZwL2RlsRgWuaG05N4herwcLHOO9gWXg/zppo1pzZCQnkOQ+SWBL8hqPHspS
         OOtWES1GFmpmKAZO2RPtmxNwV9enRAHPTe9LsWkO2/UVv4ZPF9oCt/jQfOmR8lW3irro
         D5tBZJTdwBTW9OWhrLg2fEH+WJLA4k97Hp7cEWR4m9EJZ0LTfm3g8IrX2gY+apmywGyy
         Aq7194GZarDb3AApZTuFTgSQNYaTcVN20dhn72DFej0x0vglISKOH9KddxSDAuDwDnMT
         glXhmymOYMV/Vyo9/r/jmEgTQAIZ20uJr+sCo6/89V8+73LoerVm2oN+scqnj3FWGuCc
         BT1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684949714; x=1687541714;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UuWZGCzkbOMRI3DKUsjT1bBZX5K7moJ19ldgpCy0JvM=;
        b=SK6xsOStNhpOS7hYJgX5p1wPQGgc+lgc8ehbMmqOFVMrrbHY4VNl5ovEHOyWtF7XTZ
         z/G1sy/2ZwqXiI7UxR8yhskjrhBY5pS4kp5eowRg/fUJme2tnedrq1DJNGaFi6lJLKOr
         wTf+WnlsjE5bi4GrwqBZqe8Q1lNU1p2fTCLQVL+IvgX8KpAedrSmpOvxkGk1sgPGie8T
         n25nSzuNSsXu5F4b+iTpP/jw66dAL8ew+wxOfmafeeSBm/Pu5WzPllRa2larnsxW3O0R
         8Gj8KCpmVVSk+OI4/Va2QQ8qbpUhI58hGZ0jSdLxv1tQHECAeI63bvQhzoeFrZnci3xX
         BmXQ==
X-Gm-Message-State: AC+VfDyWTYrgFj5rOfz0uUG4qOacU5JtJ2sZQDCLAfqwFOXw5GaPqQa5
	DA0Aot0s+k9cCXpYMubBtdk=
X-Google-Smtp-Source: ACHHUZ4CfH5rQekEpwKDf2dB5IQ2z7oJye5kqwJnfqfNUSqS4UHLVKcqhDT7i5TpD/mqssXnLShN+Q==
X-Received: by 2002:a05:6402:453:b0:504:a3ec:eacc with SMTP id p19-20020a056402045300b00504a3eceaccmr205970edw.4.1684949713669;
        Wed, 24 May 2023 10:35:13 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id ba7-20020a0564021ac700b0050bce352dc5sm126542edb.85.2023.05.24.10.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 10:35:13 -0700 (PDT)
Date: Wed, 24 May 2023 20:35:10 +0300
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
Subject: Re: [PATCH net-next 06/30] net: dsa: mt7530: improve code path for
 setting up port 5
Message-ID: <20230524173510.xvq434ekaee4664m@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-7-arinc.unal@arinc9.com>
 <20230522121532.86610-7-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230522121532.86610-7-arinc.unal@arinc9.com>
 <20230522121532.86610-7-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:15:08PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> There're two code paths for setting up port 5:
> 
> mt7530_setup()
> -> mt7530_setup_port5()
> 
> mt753x_phylink_mac_config()
> -> mt753x_mac_config()
>    -> mt7530_mac_config()
>       -> mt7530_setup_port5()
> 
> Currently mt7530_setup_port5() from mt7530_setup() always runs. If port 5
> is used as a CPU, DSA, or user port, mt7530_setup_port5() from
> mt753x_phylink_mac_config() won't run. That is because priv->p5_interface
> set on mt7530_setup_port5() will match state->interface on
> mt753x_phylink_mac_config() which will stop running mt7530_setup_port5()
> again.
> 
> mt7530_setup_port5() from mt753x_phylink_mac_config() won't run when port 5
> is disabled or used for PHY muxing as port 5 won't be defined on the
> devicetree.
> 
> Therefore, mt7530_setup_port5() will never run from
> mt753x_phylink_mac_config().
> 
> Address this by not running mt7530_setup_port5() from mt7530_setup() if
> port 5 is used as a CPU, DSA, or user port. For the cases of PHY muxing or
> the port being disabled, call mt7530_setup_port5() from mt7530_setup().

So TL;DR: mt7530_setup() -> mt7530_setup_port5() short-circuits
mt753x_phylink_mac_config() -> ... -> mt7530_setup_port5() through the
stateful variable priv->p5_interface, such that port 5 is effectively
never configured by phylink, but statically at probe time. The main goal of
the patch is to undo the short-circuit, and let phylink configure port 5.

It is worth stating that we know phylink will always be present, because
mt7530 isn't in the dsa_switches_apply_workarounds[] array. Otherwise
this strategy would have been problematic with some device trees.

> Do not set priv->p5_interface on mt7530_setup_port5(). There won't be a
> case where mt753x_phylink_mac_config() runs after mt7530_setup_port5()
> anymore.

The bulk of the change is difficult enough to follow. I believe this
part could be done through a separate patch, and the rest would still
work.

