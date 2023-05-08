Return-Path: <netdev+bounces-899-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BC226FB493
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 18:02:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66CEC280FCD
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:02:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4566E4421;
	Mon,  8 May 2023 16:02:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3415317D0
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 16:02:52 +0000 (UTC)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FF85588;
	Mon,  8 May 2023 09:02:50 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f315735514so175743005e9.1;
        Mon, 08 May 2023 09:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683561769; x=1686153769;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:subject:cc:to:from:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8QMhc552UlUsj7kYvZWtMUMNf+gVyj2eysVQyi2xaKM=;
        b=HlBZP9zPGcvY5f1n0Z0Uf8lOdCdbUV5xpjGQS4G389s8eIBv01rai4p4cryDNgB+j9
         3qaIMo3beQUAjsH2QS1gNZi94/Wr6yV7ZVuQzW3MkWKKAk9VlWyniZqTKB317aIq93Ls
         AgM/iO383zjxC9eLglL1a2xJxlTqJRutlnCml/ApPRnUSAws2ctrbcsfhlCtXHLJIDIv
         kGbcTrMA5bE/zjCBzx+EXLS+UZrH+N2j5biSigIzNcZIXTeG12ZGAWDpolwh7tZTKdnt
         ozBrgxQW7UkkCukatEzjJnex8KgE7hdnIOor2cB5r4NXhryw6JI5QCx7gBi54WImVVB8
         7v6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683561769; x=1686153769;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:subject:cc:to:from:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8QMhc552UlUsj7kYvZWtMUMNf+gVyj2eysVQyi2xaKM=;
        b=GVuGv/he8vJv9tKszokXqOqHOqJQyTF+5tnjuidJEzsLThboyQzJqcgbI8ECybi8Zd
         QPgrqlYsxuuz68aiDfeG7SlZ8Q8D1L0gKRmjiYEKVYlfb/Ovn3b6RQLeUktj7tffp1sJ
         8DLwjE2KHOWg9iQF+xTvmUGE53dDnaW2dfTWOxfs3Y57mAUktTi4jQYeroptZ594kSxj
         1lAs5fZu9Cgb2/cBxmHB7QBvjbVN9DsTDa3RLBGA2nFpnlQUjEL/T1jnf6ZY4Rc16hes
         PEwMJP4qtAsNjixhWMSYkpjdg9SlZ9SCutAlMLQ1uW0ABIvO0Is7iwL5ACh/BiKTI8X3
         SXcQ==
X-Gm-Message-State: AC+VfDwiJonBXwEA5JwVVRxuxVTSisCrK1J2JABBKbZqqiy8Y4dqlOUE
	bpDgTe+04xIcge/BHrPAJ88=
X-Google-Smtp-Source: ACHHUZ5gut9Av3LAVbmrxULeIcOJYi74sqsnH/+A0yslUft1sWoiypVuYj5H2hMqmRzhO5GwVeo11Q==
X-Received: by 2002:adf:f785:0:b0:2f2:79aa:c8b9 with SMTP id q5-20020adff785000000b002f279aac8b9mr6830879wrp.35.1683561767917;
        Mon, 08 May 2023 09:02:47 -0700 (PDT)
Received: from Ansuel-xps. (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.gmail.com with ESMTPSA id g14-20020adff3ce000000b00300aee6c9cesm11744439wrp.20.2023.05.08.09.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 09:02:47 -0700 (PDT)
Message-ID: <64591d27.df0a0220.d1f7b.ca4a@mx.google.com>
X-Google-Original-Message-ID: <ZFkdJNHT2ARUKFic@Ansuel-xps.>
Date: Mon, 8 May 2023 18:02:44 +0200
From: Christian Marangi <ansuelsmth@gmail.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Felix Fietkau <nbd@nbd.name>, Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>, Kalle Valo <kvalo@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH] dt-bindings: mt76: support pointing to EEPROM using
 NVMEM cell
References: <20230508155820.9963-1-zajec5@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230508155820.9963-1-zajec5@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 05:58:20PM +0200, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> All kind of calibration data should be described as NVMEM cells of NVMEM
> devices. That is more generic solution than "mediatek,mtd-eeprom" which
> is MTD specific.
> 
> Add support for EEPROM NVMEM cells and deprecate existing MTD-based
> property.
> 
> Cc: Christian Marangi <ansuelsmth@gmail.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> Ansuel is working on mt76 driver support for NVMEM based EEPROM access:
> https://github.com/openwrt/mt76/pull/765
> 
> I took the liberty to propose this binding patch.
> 
> One important difference: my binding uses "eeprom" while Ansuel went
> with "precal". I found a lot of "eeprom" references and only one
> "precal". If you think however "precal" fits better please comment.

The name is totally "to decide". I feel eeprom might be also way too
much generic...
I was thinking to something like cal or precal following ath10k or
ath11k pattern.

Also in the code itself I notice there can be different calibration
hence the idea of precal and cal... (currently we define the entire mtd
partition and call it eeprom but on some card different data are
referenced with an offset... that will be dropped since nvmem cell will
reference directly the data without using offset, which seems an hack to
me)

-- 
	Ansuel

