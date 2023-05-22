Return-Path: <netdev+bounces-4353-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0CFB70C2A8
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:43:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A0F61C20B32
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:43:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D7DB15481;
	Mon, 22 May 2023 15:43:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9104E14AAE
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 15:43:35 +0000 (UTC)
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359A9A1;
	Mon, 22 May 2023 08:43:34 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-96f7bf3cf9eso665370766b.0;
        Mon, 22 May 2023 08:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684770212; x=1687362212;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YFlUZmtcEFUGRJLdJ4IMhNurzNwCQnfw3VnK9RxExKk=;
        b=ALR0+sN3cJmqm5YRGQVYJ27udzZd4OHs+U76NwiRwAT+gfljBvpy/cFKAN91f28DlW
         QOEsN2vSjg1YEbWbgqmPd8hAR9XRERQwfbgi4a5urAdZqFc8+h0GYu+2JI2fLvWNFC7T
         ABgC3IDf1+ESpnj1828uKLiyj/CCG8OkVVkwlXw7bI4qU/uonY1e5LHG3d8JCjLvj8uw
         BeCDg8gF3Y497/FoyvpzBynopYfd8EV6QAXXNziErCH4pAZULbqoP+5RPyDJ1/3+ABxe
         fIDkS4HpzVZ/coha2GfCG1KZ5bZaSc3uf8CoTuLHXNDVstOrW8gplis2inlHNbLdM1qu
         LEyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684770212; x=1687362212;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YFlUZmtcEFUGRJLdJ4IMhNurzNwCQnfw3VnK9RxExKk=;
        b=WvcPwSm70tgS6dI1uqBF2P9IU8G0hDohKuMfVe4h0q3pE34k9Tm1s/xAKWPJp9NRdM
         Rhc6eyezDVVN+65obcpl39O1yHQ2FyZNoT9gIwdBb2001qdFc42Zo+ScO/hqHjFuoeX8
         QFLOWQYD8IIQWiAkYOIxlRZxE2EBAGHICPxK6mzrRnKo2AA1iOF3Xa6wJ4MOS/5AyzAv
         K9t5U5hsMNFbAuIKIox+lAipmFqET5LcLQQperUIwGgJRvzfgz4EwfI8z1sX1BOIsnqe
         Qm9+4AFyjfa3t08vtWeb953uz5FSJlWT0X3FdO9Df2tsdEYGpYYCBhy6Pf/kZfeylM7W
         58Ew==
X-Gm-Message-State: AC+VfDw6sbsya2MEVu49XtIs5jvHjo/ixbhQXHZiD28jJ1mvWOo0T4VN
	8nWKE1rC/muwQM7EquP9+lY=
X-Google-Smtp-Source: ACHHUZ7G64caxfVS+RsX/khR0zw6oy3v3ttbJXFrG+JI+YW3XuGZFFBdcza+hiosaEZTIQMtOOKwMw==
X-Received: by 2002:a17:907:1b29:b0:966:4d75:4a44 with SMTP id mp41-20020a1709071b2900b009664d754a44mr9735908ejc.24.1684770212243;
        Mon, 22 May 2023 08:43:32 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id s2-20020a170906778200b0096ace550467sm3266289ejm.176.2023.05.22.08.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 08:43:32 -0700 (PDT)
Date: Mon, 22 May 2023 18:43:29 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Sean Wang <sean.wang@mediatek.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>,
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
Subject: Re: [PATCH net-next 00/30] net: dsa: mt7530: improve, trap BPDU &
 LLDP, and prefer CPU port
Message-ID: <20230522154329.n23j3wwbsh7b47m3@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <5feba864-b792-4fe4-a58a-e1b22bb7842b@lunn.ch>
 <0346d5dd-bcb8-1bd9-6943-2c9d83587364@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0346d5dd-bcb8-1bd9-6943-2c9d83587364@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 04:37:28PM +0300, Arınç ÜNAL wrote:
> Later patches require the prior ones to apply properly. I can submit the
> first 15 patches, then the remaining once the first submission is applied.
> Would that suit you?

Please wait for some feedback on (a subset of) what you've submitted thus far.
Thanks.

