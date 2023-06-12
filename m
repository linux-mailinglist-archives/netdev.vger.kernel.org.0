Return-Path: <netdev+bounces-10189-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B68972CC44
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 19:20:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6086F1C20B61
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24A4E1B91E;
	Mon, 12 Jun 2023 17:20:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173817474
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 17:20:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B74FB
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686590442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7qlKft7mE4b2kNS3x9A8djvNWYAtiYtMSSZe9V4o7Ek=;
	b=fdEYm5ePBJz8/sLLgUVBm+R801+8LnD8NjUGHFbjdaf27oyWXenG6Z3ZUtVNGn5uvySK78
	B+Osf9UhBiADVQH0iH08VioSP5Jl7ZV/lF6l1B9+FAMENolBKIZoRjRAKHGcmqluj2us/r
	IAZNz1smwBpSZ6pB4EzfEgUQEJJRgDs=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-UvczcCf-P0Wh4SKVbbHL-g-1; Mon, 12 Jun 2023 13:20:41 -0400
X-MC-Unique: UvczcCf-P0Wh4SKVbbHL-g-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-56cf9a86277so33058567b3.3
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:20:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686590440; x=1689182440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7qlKft7mE4b2kNS3x9A8djvNWYAtiYtMSSZe9V4o7Ek=;
        b=huUHq5yFpmo16ltoQfkba3ih7Uw0Bx/G4i8iWZRfnTv/ON6+FwgS6f6f40qV1pvoyA
         hKG9k9ljVZuh4Q7oT9b0/+ZFvep7bjIA050LdWpLWt5h9eqKR7MBdigeMiM6Jmx49uSz
         5TvjZi84JUylwsvBxcyMNaDZ96UKUZWYH3ldGXAStqgPymPP3KlZ5ww4qiGqZGP6PQDg
         VfpENQA+XdLOXX5RK/gS99xOX4XAJa+uHzX6qkil20gqhkwodTe6X2r71mJ507/IuxCl
         X/59hIGPCHRIw4XTrC3gAO+QR53zyrmMTHET9POql5g/+gRSPO/JwW7DbrBpeZOAZtYE
         nRvw==
X-Gm-Message-State: AC+VfDzICXDciSz4JG5IF7me2IiJr9tBpgJW5IUf+XP7bnlXj3ohofYd
	efaDU0abgYsJj2rQj9k5p2cOcMbB1k/hE+ZBfbGdssqdu5kWGYpFHTT6jwzQUKAY8RI0NUZxl2b
	cIUn7BclftZN1YzRy
X-Received: by 2002:a81:8047:0:b0:565:c888:1d09 with SMTP id q68-20020a818047000000b00565c8881d09mr11436050ywf.30.1686590440569;
        Mon, 12 Jun 2023 10:20:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6pK0EspHiEwXLJwZSnTgF0PmnWrSSsx5/e6T7JNdTcNpiEDXWG/J7snMtSub/jvW4XBEs/gg==
X-Received: by 2002:a81:8047:0:b0:565:c888:1d09 with SMTP id q68-20020a818047000000b00565c8881d09mr11436028ywf.30.1686590440315;
        Mon, 12 Jun 2023 10:20:40 -0700 (PDT)
Received: from halaney-x13s ([2600:1700:1ff0:d0e0::45])
        by smtp.gmail.com with ESMTPSA id t7-20020a815f07000000b0054f9e7fed7asm2622065ywb.137.2023.06.12.10.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 10:20:39 -0700 (PDT)
Date: Mon, 12 Jun 2023 12:20:36 -0500
From: Andrew Halaney <ahalaney@redhat.com>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Vinod Koul <vkoul@kernel.org>,
	Bhupesh Sharma <bhupesh.sharma@linaro.org>,
	Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH 01/26] phy: qualcomm: fix indentation in Makefile
Message-ID: <20230612172036.ztvjdzblh6bvmxp2@halaney-x13s>
References: <20230612092355.87937-1-brgl@bgdev.pl>
 <20230612092355.87937-2-brgl@bgdev.pl>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612092355.87937-2-brgl@bgdev.pl>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 11:23:30AM +0200, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Align all entries in Makefile.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>

> ---
>  drivers/phy/qualcomm/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/phy/qualcomm/Makefile b/drivers/phy/qualcomm/Makefile
> index de3dc9ccf067..5fb33628566b 100644
> --- a/drivers/phy/qualcomm/Makefile
> +++ b/drivers/phy/qualcomm/Makefile
> @@ -20,4 +20,4 @@ obj-$(CONFIG_PHY_QCOM_USB_HSIC) 	+= phy-qcom-usb-hsic.o
>  obj-$(CONFIG_PHY_QCOM_USB_HS_28NM)	+= phy-qcom-usb-hs-28nm.o
>  obj-$(CONFIG_PHY_QCOM_USB_SS)		+= phy-qcom-usb-ss.o
>  obj-$(CONFIG_PHY_QCOM_USB_SNPS_FEMTO_V2)+= phy-qcom-snps-femto-v2.o
> -obj-$(CONFIG_PHY_QCOM_IPQ806X_USB)		+= phy-qcom-ipq806x-usb.o
> +obj-$(CONFIG_PHY_QCOM_IPQ806X_USB)	+= phy-qcom-ipq806x-usb.o
> -- 
> 2.39.2
> 


