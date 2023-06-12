Return-Path: <netdev+bounces-10218-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26A0872D025
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 22:07:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6566B1C20B8F
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 20:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E753BA38;
	Mon, 12 Jun 2023 20:07:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5278DAD5C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 20:07:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A885918C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 13:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686600421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X+0noFHcj2yLtNYh9uCwW0uaG8SfjbhqsP5is69vjY8=;
	b=Nmq5ShtWfiH5S3rXoXpJaLp6mSEgV2TNAh2iPKimY7+ZUHZKBM3zJnYBJZIw01ePcomypf
	Zp0Z+9/wEuX76JFoPckgIgvrpESXiC8LcKDyC4fZxasPOZ8/9Hnd2sQtd/4Oux21hgoBon
	MU8OEc/8fFopiX8p4JiOMHvoIU7UlkQ=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-9twpdlEVOh6ocyxHOngXzQ-1; Mon, 12 Jun 2023 16:07:00 -0400
X-MC-Unique: 9twpdlEVOh6ocyxHOngXzQ-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-56ce36fca90so46293217b3.0
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 13:07:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686600420; x=1689192420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X+0noFHcj2yLtNYh9uCwW0uaG8SfjbhqsP5is69vjY8=;
        b=cE7odwtnQTNco0BXp/Us2LbnHhHaVCKGbLQDVY9PhoBKRy0uvEaxeBdDyCVY+MKUn3
         rlbZ+9oKWPjAbpyVsDjWoSB/1iadSD0Zt38wyWyqqpD7R0XMVziYj6d9XzRc50ksCNuq
         S/Em2neU7sDAsL/P/gHFjW3OHvvovbe3QmZD5YQZ+jEvYPg86bnZh+X0QWW73uC+as8u
         J7NReErceFKG2XenHYMJZirVgqyUH5QmoBLA6pFJ3K/TJPW8UpKB1o1VJcAkE28fRCNe
         0Esn2TLsJkrVVJpEB5/ycV6wMtEjwfiXowBDV+n6nro6s/9zvsYtaENCYCYfClpS8/7H
         QYvQ==
X-Gm-Message-State: AC+VfDyjP0dGK4l/sfMo9GAS/S1PNQS4AYLey17rkUZ1i+ARlEEuFggY
	yqlBfOOZGqBcuy+FL7SYzFvxc4opren7TgRAeC6epBqk5gdjgOUHyGV/0NSiBtMaV0FjV7ZpDRo
	CTp3vkeUPrhIlQTin
X-Received: by 2002:a0d:d142:0:b0:569:feee:3950 with SMTP id t63-20020a0dd142000000b00569feee3950mr12226012ywd.2.1686600419880;
        Mon, 12 Jun 2023 13:06:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7PzolWatF3tOgmfa9XBAGwXjOlATUx5vSje4PclwYgketu3avPNRnBzek6n0LaOUY30qXC9g==
X-Received: by 2002:a0d:d142:0:b0:569:feee:3950 with SMTP id t63-20020a0dd142000000b00569feee3950mr12225997ywd.2.1686600419621;
        Mon, 12 Jun 2023 13:06:59 -0700 (PDT)
Received: from halaney-x13s ([2600:1700:1ff0:d0e0::45])
        by smtp.gmail.com with ESMTPSA id m14-20020a819e0e000000b00568e7e21db7sm2713928ywj.96.2023.06.12.13.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 13:06:59 -0700 (PDT)
Date: Mon, 12 Jun 2023 15:06:56 -0500
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
Subject: Re: [PATCH 10/26] net: stmmac: dwmac-qcom-ethqos: add a newline
 between headers
Message-ID: <20230612200656.ndt5pwhi3gqj42a5@halaney-x13s>
References: <20230612092355.87937-1-brgl@bgdev.pl>
 <20230612092355.87937-11-brgl@bgdev.pl>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612092355.87937-11-brgl@bgdev.pl>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 11:23:39AM +0200, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Typically we use a newline between global and local headers so add it
> here as well.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>

> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> index ecb94e5388c7..5b56abacbf6b 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> @@ -7,6 +7,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/phy.h>
>  #include <linux/property.h>
> +
>  #include "stmmac.h"
>  #include "stmmac_platform.h"
>  
> -- 
> 2.39.2
> 


