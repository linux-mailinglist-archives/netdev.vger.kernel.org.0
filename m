Return-Path: <netdev+bounces-8712-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCDE87254EE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:58:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32CB31C20C77
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 06:58:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CFA9613B;
	Wed,  7 Jun 2023 06:58:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FF95686
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 06:58:20 +0000 (UTC)
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A9E198B
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 23:58:15 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-654f8b56807so4373713b3a.1
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 23:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686121095; x=1688713095;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nh4fHWBEz1Sr5TZZkrEsU0UWH1SdtjGoipfMtexv460=;
        b=bnBzP0j8cMrMInZQJqBsvQThQ1CjUgDjBdvee1vofjBKqB3P7P/QYSPwz5EEvOiWP2
         keVs4n6XcSdF6cTjCYzGq+/StlwCittJpYHPMBRbT/vcy6AArwOQm0h/7THFl1JeJ0Vg
         I2bI/uigd+Ctccth+LZpsbEq6m7nI+DjcbDIxbssfS1+GcTcyebckEv01y20eX14Eyfc
         lRBGrvynQq6UR35LU1MZuAn3NWmT5g1vJMkls1OZfxxBt/r63ClI4RQBb5zQCB93SyiN
         hVb20EWDVrrlDACHfxIbA6/do4YYIzRnmMhK2XSV+IszkXAKXz+1IVEViYHBHM7yz+Xs
         mnYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686121095; x=1688713095;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nh4fHWBEz1Sr5TZZkrEsU0UWH1SdtjGoipfMtexv460=;
        b=W8qDkDe208wj+0+UCgZ8AqftokpDtVMzyMUDoCsHOgGdJ0nATJhfPo7ZsJhqCCA2+/
         XzD8qGlfHO5rr59RhEI8v91lUT1h5kRZbKidyVpN7z1BhiZliz2O1n8AhoMZ0mlC1qzz
         6V6/LVe9/+rNtHmKXSLeNkGIGlnpnaRDBQzzNdrAjMRd0R2FvG5yBgjBhd0jSp+il++z
         WS0suRJX4EbyfmhsW8VtRhfahp9Z96tXjxikWUyw6tsQB9zzH+JSvVKMFd8hfI7pJ/aE
         g1Oko20rVlVWop5PcDwad27zdyn2qvHGOcGuo5WGZOmDd4i35B3A90bxqjhz0OsOgJ0W
         9zog==
X-Gm-Message-State: AC+VfDwoF1zr3o+H696AaaeC7gqNSkTR6f1bJBKpuEhMgCKTSFWN5qnL
	ireBU+G3miflNZXN9bs01DIl
X-Google-Smtp-Source: ACHHUZ7SORdiyujXnnRSGiVRS/CQfk/KmBM4qEEakzslTa7SK9spwRxfTllyzMqkaMeA45eOHSs3uQ==
X-Received: by 2002:a05:6a21:3a84:b0:10a:fad7:43bf with SMTP id zv4-20020a056a213a8400b0010afad743bfmr2058569pzb.39.1686121094787;
        Tue, 06 Jun 2023 23:58:14 -0700 (PDT)
Received: from thinkpad ([59.92.97.244])
        by smtp.gmail.com with ESMTPSA id h129-20020a636c87000000b0050f9b7e64fasm8482555pgc.77.2023.06.06.23.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 23:58:14 -0700 (PDT)
Date: Wed, 7 Jun 2023 12:28:09 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Jeffrey Hugo <quic_jhugo@quicinc.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, mhi@lists.linux.dev,
	linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, loic.poulain@linaro.org
Subject: Re: [PATCH 3/3] net: mhi: Increase the default MTU from 16K to 32K
Message-ID: <20230607065809.GB5025@thinkpad>
References: <20230606123119.57499-1-manivannan.sadhasivam@linaro.org>
 <20230606123119.57499-4-manivannan.sadhasivam@linaro.org>
 <b8a25a70-8781-8b82-96d8-bc1ecf2d5468@quicinc.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8a25a70-8781-8b82-96d8-bc1ecf2d5468@quicinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 07:50:23AM -0600, Jeffrey Hugo wrote:
> On 6/6/2023 6:31 AM, Manivannan Sadhasivam wrote:
> > Most of the Qualcomm endpoint devices are supporting 32K MTU for the
> > UL (Uplink) and DL (Downlink) channels. So let's use the same value
> > in the MHI NET driver also. This gives almost 2x increase in the throughput
> > for the UL channel.
> > 
> > Below is the comparision:
> > 
> > iperf on the UL channel with 16K MTU:
> > 
> > [ ID] Interval       Transfer     Bandwidth
> > [  3]  0.0-10.0 sec   353 MBytes   296 Mbits/sec
> > 
> > iperf on the UL channel with 32K MTU:
> > 
> > [ ID] Interval       Transfer     Bandwidth
> > [  3]  0.0-10.0 sec   695 MBytes   583 Mbits/sec
> > 
> > Cc: Loic Poulain <loic.poulain@linaro.org>
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >   drivers/net/mhi_net.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
> > index 3d322ac4f6a5..eddc2c701da4 100644
> > --- a/drivers/net/mhi_net.c
> > +++ b/drivers/net/mhi_net.c
> > @@ -14,7 +14,7 @@
> >   #define MHI_NET_MIN_MTU		ETH_MIN_MTU
> >   #define MHI_NET_MAX_MTU		0xffff
> > -#define MHI_NET_DEFAULT_MTU	0x4000
> > +#define MHI_NET_DEFAULT_MTU	0x8000
> 
> Why not SZ_32K?

Makes sense. Will change it in next iteration.

- Mani

-- 
மணிவண்ணன் சதாசிவம்

