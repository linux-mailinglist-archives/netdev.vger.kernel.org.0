Return-Path: <netdev+bounces-5787-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6592D712BDD
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 19:39:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F66F28197E
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7086F28C3B;
	Fri, 26 May 2023 17:39:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661101E536
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 17:39:00 +0000 (UTC)
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC5E99;
	Fri, 26 May 2023 10:38:58 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-96fab30d1e1so232516466b.0;
        Fri, 26 May 2023 10:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685122737; x=1687714737;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PTiLq4ygH0IvGpIu6yVKyZxG0Q1NzCebyg9n2MhnoWM=;
        b=bwvKFcmzuCcjiY8UjRyGDFyDfiRO4TxeBvS+aOYa/Krvw0DQQ/A/QAR7XfbpE2cr59
         cdDJlv9ERgQfVXA9QhbbHL7q11EMuj8eGZfNQz6+unf2MmVUBykymvQ4jE35p1jis4di
         +GVUtSXRjAxgLjv2rvLHOKDI7VLjva6g1V4ILoYIpkzmvzLSYQTZVSlRPA9t7ylHrwNu
         /d1r48lydgy64JZFUD5VDP2vAIhxZ3/+lbZlV9LNAsX692/FlVXD6vZYfWFtbJhZryzl
         34RJYBCxsW20gJlsdowmvZYLdwDrnqRXBQwU2wBJVEyf31gEJDLeVyYTk9VnNER+lHKn
         2WTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685122737; x=1687714737;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PTiLq4ygH0IvGpIu6yVKyZxG0Q1NzCebyg9n2MhnoWM=;
        b=PaIO17GEyK3Q5VOPSQDF3pMX0qd+zxVbM8R0GFcoIrlq/WHt+rpckMZ3hEmRNzKcrA
         Z2q6bNlA2DmilY3OS3tpPqRv6cTIj8bQe0+cKG8nanIFpTjFfnbj6C6qf2spgcAhLvGB
         t09QIOM2imbPNF60rIPMRvQ8Go+BImiO1QdMkyTl2jC/+qiK8LDJ6mJ7P6yTO8CLaj5W
         FkCbDzHg7KrP5/pogMCbuW0CTP/K1fOB35iE6sIDUeKNj01rq0YRyuA7suLRyEp1mDTo
         u6xAaO/6oI81lB5W4p2iQh40Crx/ZMeQopTDsSzmgzoebIJe2b7b/NVd5xOAcBzexA59
         V4FA==
X-Gm-Message-State: AC+VfDy4dSK9EtEKtpP6wn5mP0f830AR7UA8FxwLpXuflF4sNimcGLP8
	s1wl1EcJkwOjv/q3wZfTqFU=
X-Google-Smtp-Source: ACHHUZ4PFyKyc2QUHAnlcpOFn+49tIH6s0K2Tb/i0az8Bqph4zclDagFl+Zci851eE1HSGF8K9cw0w==
X-Received: by 2002:a17:907:3603:b0:969:c354:7d9a with SMTP id bk3-20020a170907360300b00969c3547d9amr4363175ejc.12.1685122737125;
        Fri, 26 May 2023 10:38:57 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id z9-20020a1709060f0900b0094e1344ddfdsm2394951eji.34.2023.05.26.10.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 10:38:56 -0700 (PDT)
Date: Fri, 26 May 2023 20:38:54 +0300
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
Subject: Re: [PATCH net-next 30/30] MAINTAINERS: add me as maintainer of
 MEDIATEK SWITCH DRIVER
Message-ID: <20230526173854.ubaz2yojpt6k6rxj@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-31-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230522121532.86610-31-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:15:32PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> Add me as a maintainer of the MediaTek MT7530 DSA subdriver.
> 
> List maintainers in alphabetical order by first name.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

Well, I suppose we need more active people maintaining this driver, so yeah:

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

