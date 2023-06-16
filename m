Return-Path: <netdev+bounces-11345-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FE9D732AC3
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:59:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0A01281681
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:59:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AB5DD30F;
	Fri, 16 Jun 2023 08:59:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19DA33ED
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 08:59:40 +0000 (UTC)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E412030D1;
	Fri, 16 Jun 2023 01:59:38 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9827bd8e0afso65792566b.1;
        Fri, 16 Jun 2023 01:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686905977; x=1689497977;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NQxUeJluDhZ+zh34p6pOl/CaDE/BAEwaqQwArt1volI=;
        b=k0GAcc9btQyliotFHtDvEDISAxjC7DcQiR1ZLq2ExuUjnNYFK5ai2g/z88gEzQb6M0
         BVsvK7suBVOC3zoI8uwrSa9SbJGgSUM+jN3p71mGbDTZa6V1/DTjN9tEYOJ8bYId7WGC
         XlNVd7kdxsTVw4x0ZhWgjpDMHBnKuk4lJ6QMr8SsSnWbayBRDt18QlY97tygqYOUs894
         zKAuk/mi/uERJCmjVBJ91K7soX2EJP2zferNy+seNen5bA5l1x54VYv+4myNfIqADZ7H
         IkLFDnM0WnU6GGLNL7HIh59sadaPy1LEtbqPGzCgStvyyID3JHBkjDvosxNm20zjysGr
         2arA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686905977; x=1689497977;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NQxUeJluDhZ+zh34p6pOl/CaDE/BAEwaqQwArt1volI=;
        b=lRzq/BIWz/12qNGsgFIEMk3K/naEHRSDw6Q7OCIxeL5XA31JOOxlJqZyD8znyYpCEI
         Avc/Rs0hqiV/ZqdvivB22kEFiyefYuOEr8RHn/PnYaM58svF9l1v/1WAX57H2HSwZ4fb
         wwVNElUAfSSxrIa4v6Z4QR6LfcFfTXWm15wSV5o29l3mFrssrg1I9JuGtVIxsWZGjFNk
         Kk5IdurmphOMhrvhePwTkppqCqkr8PKqh1OOVWsIJ+VsakRFVwPQ4HfYnNnkvW081E8N
         2bqp7YpUrUJUVnMhMe7p1fTxc9+MhanyOlr4E1O2GmbHJUQOPXEMLp3j46C8v8IbuR61
         M3zQ==
X-Gm-Message-State: AC+VfDxKK0LMRjGkEphSAg0bcGoSZyYVwRucmakimcf3o4EiPEkJCMMJ
	A8EBGNZ28vK5L1PVcaaxPP8=
X-Google-Smtp-Source: ACHHUZ4xiz4jftf6X9cpZn7GcY35ix4lZRoU57wKfH73RnCZYWSJPQEriDhCEFl170zL/hBvndfrrQ==
X-Received: by 2002:a17:907:783:b0:982:c8d0:683f with SMTP id xd3-20020a170907078300b00982c8d0683fmr1256009ejb.18.1686905977096;
        Fri, 16 Jun 2023 01:59:37 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id oq19-20020a170906cc9300b00977e0bcff1esm10578129ejb.10.2023.06.16.01.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 01:59:36 -0700 (PDT)
Date: Fri, 16 Jun 2023 11:59:33 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: frank-w@public-files.de, arinc9.unal@gmail.com,
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
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v5 4/6] net: dsa: mt7530: fix handling of LLDP frames
Message-ID: <20230616085933.3im44mrpeduhmvqt@skbuf>
References: <20230616025327.12652-1-arinc.unal@arinc9.com>
 <20230616025327.12652-5-arinc.unal@arinc9.com>
 <CFD0E43B-1D0F-4BC3-8DB8-8CFA09F8AA94@public-files.de>
 <44531D5A-9219-44CC-9197-DD59E9506453@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44531D5A-9219-44CC-9197-DD59E9506453@arinc9.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLY,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 09:21:40AM +0300, Arınç ÜNAL wrote:
> On 16 June 2023 08:44:32 GMT+03:00, Frank Wunderlich <frank-w@public-files.de> wrote:
> >Am 16. Juni 2023 04:53:25 MESZ schrieb arinc9.unal@gmail.com:
> >I though these 2 hunks should go into some common function
> 
> Like I said, I will do that on my net-next patch series.
> 
> Arınç

Please create a common function now.

