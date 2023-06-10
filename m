Return-Path: <netdev+bounces-9842-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3982172ADF7
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 19:57:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7CA22815FD
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 17:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 474B91F163;
	Sat, 10 Jun 2023 17:57:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D6A23C5
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 17:57:10 +0000 (UTC)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED34BD;
	Sat, 10 Jun 2023 10:57:08 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-30aea656e36so1946641f8f.1;
        Sat, 10 Jun 2023 10:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686419827; x=1689011827;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A0RlF2SCoY8DOBZFSAE7oSXdOZufl2PQqXGpj/ndfFo=;
        b=qc3sSnbYwiTFPHv4KX+/zz30qPr0aKzhUV+yAYQhdIK/ubrS6U/MpjW47xI+xSqTlG
         5c8MjhMI/vC+3L4Gc+5GT4yp1OpdrBR9+rxrv/QMgPfqkGRFiJzsuTbPh3srcAhQcJAE
         Su91tgLfnhbg6P5EhPCN6hD2xIT/qB04aEvBAGIecIM19DulbPXr1N3xy448pn/JkVZF
         XIH/l9UG+Hfynm7yYosycnIkhaLKPNovgVsz3CDhungzZYqB70GZwQZQRRkp66MXQ9TZ
         jmjgL+b83qWQmSRk8Ce7FmnahwlpUZbT+6jZZ00x147TKDlkmI9NNwHQ0mB2JTbjlzBW
         Ybiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686419827; x=1689011827;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A0RlF2SCoY8DOBZFSAE7oSXdOZufl2PQqXGpj/ndfFo=;
        b=BFgGKQxiNu0HwCs3NXfv30L74ZbJOQ2Ld698m8FUk4lD56oPXyiQVgmYUdO+zJUH31
         SHus4VcdKMYrgRBtDHQzX/Pvva5IWlJMcF5hyPh/38TCLh2RB9kHzvNw7cN527ydbrqd
         Y15aJIil0DpLGD33h/jyXdy0kTr6dN8Aw4D6DUwwIDF3zp5jmO49IG3hZ3fSS4G307hW
         plOY17sOYSabuLr3g5Wocivw2j0BbuVqJMKLUiTDVu99B8EjNF8jmcVniVkMJ8xO16SD
         MQJp/iSdVcpBZl6S7B/cP0jAwGI4dr1nveQZpk9dPH0cEWjPecYVHeQxqEN4bY5bSgpZ
         AxVg==
X-Gm-Message-State: AC+VfDwzhIbwSy1S6sydjbZzCs7p/Sxbp6CECCfwtYnCjGAl4GXtUndU
	o8YBoB5M0UapM9QNiggj+I8=
X-Google-Smtp-Source: ACHHUZ7gB7Hp35URvk8Xu0h7QliavyRRbHC04YIotRJd45hFrnBxeGDG0NyzpoF50hot0UL4oO4PuQ==
X-Received: by 2002:adf:fd87:0:b0:306:3021:2304 with SMTP id d7-20020adffd87000000b0030630212304mr1609781wrr.60.1686419827127;
        Sat, 10 Jun 2023 10:57:07 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id e10-20020a056000194a00b0030497b3224bsm7613288wry.64.2023.06.10.10.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 10:57:06 -0700 (PDT)
Date: Sat, 10 Jun 2023 20:57:03 +0300
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
Subject: Re: [PATCH net-next 27/30] net: dsa: mt7530: introduce BPDU trapping
 for MT7530 switch
Message-ID: <20230610175703.r2wlzfovl6fnebu2@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-28-arinc.unal@arinc9.com>
 <20230526170223.gjdek6ob2w2kibzr@skbuf>
 <f22d1ddd-b3a4-25da-b681-e0790913f526@arinc9.com>
 <20230604092304.gkcdccgfda5hjitf@skbuf>
 <cc21196b-a18a-ce3c-e3f3-4303abf4b9a3@arinc9.com>
 <20230604124701.svt2r3aveyybajc3@skbuf>
 <6a64db9e-ac6c-c571-fb8b-ae3aa2da07b7@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6a64db9e-ac6c-c571-fb8b-ae3aa2da07b7@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 10, 2023 at 11:32:45AM +0300, Arınç ÜNAL wrote:
> Maybe I should submit this and LLDP trapping to net? Currently, the MT7530
> subdriver on the stable kernels treat LLDP frames and BPDUs as regular
> multicast frames, therefore flooding them to user ports, which is wrong.
> These patches could count as bug fixes.

Yes, I believe that trapping link-local frames only to the host
constitutes "net.git" material.

