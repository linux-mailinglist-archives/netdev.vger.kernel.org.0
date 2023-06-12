Return-Path: <netdev+bounces-10217-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D2A272D024
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 22:06:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 805C81C20B07
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 20:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AA48AD5C;
	Mon, 12 Jun 2023 20:06:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA63881F
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 20:06:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1FB186
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 13:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686600391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0M/d98x762H4zuN8FNzgVtnMfzxWhlymbFLqT2RC6Mg=;
	b=g7AyH8ga1h7TJJE20uCF79uhqfOlujIC3u+pcK+bSq0IB1SCLGKL/tD8Nr4Hcw07+dq6mg
	ZFXRcDuEu9wKwDBP4UCkdixTwADEANsUNNgzk003vhNDkq3zclEeeOO5qQTeOkTus0Crsg
	sghHDjeaLV5LQpzSWC2nvX17pN9JG2Y=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-152-byyvQwR1MCS3Dn6RQjpUjQ-1; Mon, 12 Jun 2023 16:06:29 -0400
X-MC-Unique: byyvQwR1MCS3Dn6RQjpUjQ-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-568bc5db50dso122471517b3.0
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 13:06:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686600388; x=1689192388;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0M/d98x762H4zuN8FNzgVtnMfzxWhlymbFLqT2RC6Mg=;
        b=YkDiMGBbqZte99o0mph5pz1u4Ws5oS/ksWKiDboKroSGWGV1qVCzLVWpi48erd+eBY
         K8OSPM6LSx0kBWCsRTnbaA3951QoBDalKZk0NIoX2lgLHgAt/6+6m5X6PBL7Mhz1go9j
         2PbzWDhMbDh28hi1YdknSXEGSlBH7ShkopYoifdbiCgS3ejCg1ChbowJiQBgiz2JHjDa
         siMUwMVXxwQwkdzh0RvEP+baCwp3EmlbBEgIqnqoYZ6ecCocrf7jwvcIZM06iFeoyS1i
         So1BH+wl2zV1fFqNZnKKyXUD1FY1rvUt9j0uLLr5NAeEtmvDDopFawRytTJ3KnNKjEK6
         RCRw==
X-Gm-Message-State: AC+VfDwO7xNSIeW6AB5kzKhRAr+jM+aejcrMP2ASFmOArdWjZ1FAV6pO
	LXl7OIzpQpndY/kfiTWOxL9Uw1SCFbP2F9S/ltcIzOvdKdlI8UOgWc/DPh+nqU3P/q+hSVk/Chz
	GYGZmbIewGIWhneuF
X-Received: by 2002:a0d:d914:0:b0:56d:3cb6:8a85 with SMTP id b20-20020a0dd914000000b0056d3cb68a85mr3028334ywe.13.1686600388570;
        Mon, 12 Jun 2023 13:06:28 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ76nT4fsOumxEmo+PTpkq6Cy2kw7r9EpHd6856hkyTJvZHjyfWwkpG7DXRuh3pkEkAcTXM4cw==
X-Received: by 2002:a0d:d914:0:b0:56d:3cb6:8a85 with SMTP id b20-20020a0dd914000000b0056d3cb68a85mr3028315ywe.13.1686600388330;
        Mon, 12 Jun 2023 13:06:28 -0700 (PDT)
Received: from halaney-x13s ([2600:1700:1ff0:d0e0::45])
        by smtp.gmail.com with ESMTPSA id q67-20020a818046000000b0054f83731ad2sm2736173ywf.0.2023.06.12.13.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 13:06:27 -0700 (PDT)
Date: Mon, 12 Jun 2023 15:06:24 -0500
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
Subject: Re: [PATCH 09/26] net: stmmac: dwmac-qcom-ethqos: add missing include
Message-ID: <20230612200624.jvlyemz7g5aoen62@halaney-x13s>
References: <20230612092355.87937-1-brgl@bgdev.pl>
 <20230612092355.87937-10-brgl@bgdev.pl>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612092355.87937-10-brgl@bgdev.pl>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 11:23:38AM +0200, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> device_get_phy_mode() is declared in linux/property.h but this header
> is not included.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>

> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> index e19d142630d3..ecb94e5388c7 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> @@ -6,6 +6,7 @@
>  #include <linux/of_device.h>
>  #include <linux/platform_device.h>
>  #include <linux/phy.h>
> +#include <linux/property.h>
>  #include "stmmac.h"
>  #include "stmmac_platform.h"
>  
> -- 
> 2.39.2
> 


