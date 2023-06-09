Return-Path: <netdev+bounces-9509-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D09D3729846
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 13:38:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 950DE2818BE
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 901B216400;
	Fri,  9 Jun 2023 11:38:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822F3A93C
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 11:38:28 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1487930E7
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 04:38:25 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f732d37d7bso12036825e9.0
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 04:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1686310703; x=1688902703;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6e5QbRUnU+agFZANreqZIgq4SD5UQhoPe6DRJUY6y9k=;
        b=YMwWwqAnsDoN4SkvomdU10HDl54IFKKlrEjetiCPwmKf2brL04M3tC2/hSLmW31nPB
         HE4IJnCcnnApNMje3Akdyb7kZAMQRFTao7i/N2oXp+vhpJBz4AlksxYQVeEgWDs5pVFk
         WhlQrAjm3HGufIfHlnIfnhJhhvW24ZH9sUFq3EftfbMwaSHkMFzMKpOE/sr2UTyfuhGs
         yHyL0RlZpXRy8G6jSsWOv7yq/rxTTd2tLMYpcIWVtvuPmw0zj8yceWAV5mcPYozfl1W3
         tZ5YKbtv8WmiSkdwqDEPla45xeAmRU4oIu8eUGvwFnbHTzAG8a4BqC1FPhP3cxaIS/A/
         lKWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686310703; x=1688902703;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6e5QbRUnU+agFZANreqZIgq4SD5UQhoPe6DRJUY6y9k=;
        b=L43TteTfIU6ZD6STn++xHKNLy+A1mRuSvNeNtdxBT8qRpajdTISyMGsfumZGsW9mdn
         AIpsdVKsO3mlw5yKfB2kBHGcZ6mzN1ZP7rXmgs27qzzpZxcjOSKiTEH/JXmAzDxLeXYA
         b8yHye1ovZa8yXeFksoDSI9/pqnacfTTd4vm11Ev1IeWjKM8RyxHeOcGHVoN7ScNlRG0
         Q3OamLxAfXxwO/FGKEHbahbRlG5sdRyi/UtBnRsksAnT67kPE5FGUemv5W/fdEOAF6/j
         90aBjKBMWp1XBIL7Y60lXrBusJPMhnxKrA1Yx1xbeAs9KMqOe1eqUvXc1oDJ6Gt4hedM
         jCXA==
X-Gm-Message-State: AC+VfDwXgqu71h3pCC2MQNAMrnbzU7FsWwiiQvVUq66iNUsVLnQpTf68
	5S6ny37+9x8lenVgoYWVTyFF/g==
X-Google-Smtp-Source: ACHHUZ5tXNBQnN0YokqinPTWBRgL5yCO5urh+1uT1H6tsM9CPm+SC1MbYVNW80JpCuQ2kovJMT8d2g==
X-Received: by 2002:a05:600c:cd:b0:3f7:e7a0:967c with SMTP id u13-20020a05600c00cd00b003f7e7a0967cmr748405wmm.19.1686310703366;
        Fri, 09 Jun 2023 04:38:23 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id n6-20020a7bcbc6000000b003f6f6a6e769sm2422024wmi.17.2023.06.09.04.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 04:38:22 -0700 (PDT)
Date: Fri, 9 Jun 2023 13:38:21 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Yang Li <yang.lee@linux.alibaba.com>
Cc: simon.horman@corigine.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH net-next 3/3] tools: ynl: Remove duplicated include in
 devlink-user.c
Message-ID: <ZIMPLYi/xRih+DlC@nanopsycho>
References: <20230609085249.131071-1-yang.lee@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609085249.131071-1-yang.lee@linux.alibaba.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, Jun 09, 2023 at 10:52:47AM CEST, yang.lee@linux.alibaba.com wrote:
>./tools/net/ynl/generated/devlink-user.c: stdlib.h is included more than once.
>
>Reported-by: Abaci Robot <abaci@linux.alibaba.com>
>Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=5464
>Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
>---
> tools/net/ynl/generated/devlink-user.c | 1 -
> 1 file changed, 1 deletion(-)
>
>diff --git a/tools/net/ynl/generated/devlink-user.c b/tools/net/ynl/generated/devlink-user.c
>index c3204e20b971..18157afd7c73 100644
>--- a/tools/net/ynl/generated/devlink-user.c
>+++ b/tools/net/ynl/generated/devlink-user.c

You are patching generated file, as the path suggests.
See what the file header says:
/* Do not edit directly, auto-generated from: */
/*      Documentation/netlink/specs/devlink.yaml */


>@@ -8,7 +8,6 @@
> #include "ynl.h"
> #include <linux/devlink.h>
> 
>-#include <stdlib.h>
> #include <stdio.h>
> #include <string.h>
> #include <libmnl/libmnl.h>
>-- 
>2.20.1.7.g153144c
>
>

