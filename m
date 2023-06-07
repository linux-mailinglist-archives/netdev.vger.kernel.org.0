Return-Path: <netdev+bounces-8971-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 560007266D7
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:12:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B041A1C20A6C
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:12:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF403733F;
	Wed,  7 Jun 2023 17:12:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAC935B21
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:12:04 +0000 (UTC)
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEE6E62
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 10:11:59 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-653436fcc1bso3258810b3a.2
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 10:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686157919; x=1688749919;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rWtY5he6E2U22BGtj3uJgNRgjOP3X6c6EEgHAfVceAA=;
        b=mXect4J9DJmCaxC7euotMiP2tk7blJ93LE1V553qNvnTmgH2GBDVmDFCW6KtS+vMN7
         Axb0cX1wJcgTaXm1IdIPtXfvXLDZpE07394pEVTrE2EVF/IZvAIl+cI3LEK+6Ds1SLKT
         Zts25GUsIdKWoR6Z11646M2mmeheA6oHVWYMwDBK4U5ejNAAmW/uoJI7wnNntiAmwrMC
         rM4DXU3ImtDRebjK9ONq1qEODm7k4Sw2nHN2ZzXetQcjOZrL0sV2of4OqDDo4SAkdanR
         FHSjjp2mkYKC7sGhMCpwfoQWDwYad8UwSext4uZZOPzYyjNv2RvxaCkNvhztbXyh7PzX
         bMpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686157919; x=1688749919;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rWtY5he6E2U22BGtj3uJgNRgjOP3X6c6EEgHAfVceAA=;
        b=dQY/JPP1woAeCPqqhIEZbFV8yP4odRxKmNMt7dpSyHzKMTVFHe5lQl75nOBcWXSmnt
         WoScQ4vOml22nhQAgvMoPCSAz/zPm3x1tgNHLh7tWooQdlTGaEiN6nOcfx0Uk4IGGLZp
         ETTxH9XvxwzigpkxT8r32Luz1LDl2G4qpx8Foi6vvKjvY9ese488D5OqAMTJcX/uBkAo
         PGZz78GI/Bf53foeTxHbuUsiMoTP3eMjqxNcQOTYu5F44Vm8qRx61lJfyevOe3mT1ONa
         3Fz7l8zGeF8codc0pxjTSE2qsg21eYvaUK+i0ev9dAOG1dMrASQkEwVicR1Ep2qh+Vbr
         2XtA==
X-Gm-Message-State: AC+VfDzqWgRuvpsimbLI9aKIL/Xf3afLtKkoLaykoPnOGvqz+b0uulII
	smpYvaiv+mJ9RNrrAXTb+WlH
X-Google-Smtp-Source: ACHHUZ5QgjgWoC5EH7Xt7czYHcPm4hEGhW8TrMZglVc/Jysfh+b6M9//znCzHXVkkqT037ZWx2uYdQ==
X-Received: by 2002:a05:6a20:4425:b0:10e:e218:d3f0 with SMTP id ce37-20020a056a20442500b0010ee218d3f0mr1743242pzb.54.1686157918848;
        Wed, 07 Jun 2023 10:11:58 -0700 (PDT)
Received: from thinkpad ([59.92.97.244])
        by smtp.gmail.com with ESMTPSA id 21-20020a630c55000000b0051b71e8f633sm9228268pgm.92.2023.06.07.10.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 10:11:58 -0700 (PDT)
Date: Wed, 7 Jun 2023 22:41:53 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	loic.poulain@linaro.org
Subject: Re: [PATCH v2 0/2] Add MHI Endpoint network driver
Message-ID: <20230607171153.GA109456@thinkpad>
References: <20230607152427.108607-1-manivannan.sadhasivam@linaro.org>
 <20230607094922.43106896@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230607094922.43106896@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 09:49:22AM -0700, Jakub Kicinski wrote:
> On Wed,  7 Jun 2023 20:54:25 +0530 Manivannan Sadhasivam wrote:
> > This series adds a network driver for the Modem Host Interface (MHI) endpoint
> > devices that provides network interfaces to the PCIe based Qualcomm endpoint
> > devices supporting MHI bus (like Modems). This driver allows the MHI endpoint
> > devices to establish IP communication with the host machines (x86, ARM64) over
> > MHI bus.
> > 
> > On the host side, the existing mhi_net driver provides the network connectivity
> > to the host.
> 
> Why are you posting the next version before the discussion on the
> previous one concluded? :|
> 

Previous discussion doesn't sound any controversial to me, so I thought of
respinning. Maybe I should've waited...

> In any case, I'm opposed to reuse of the networking stack to talk
> to firmware. It's a local device. The networking subsystem doesn't
> have to cater to fake networks. Please carry:
> 
> Nacked-by: Jakub Kicinski <kuba@kernel.org>
> 
> if there are future submissions.

Why shouldn't it be? With this kind of setup one could share the data connectivity
available in the device with the host over IP tunneling. If the IP source in the
device (like modem DSP) has no way to be shared with the host, then those IP
packets could be tunneled through this interface for providing connectivity to
the host.

I believe this is a common usecase among the PCIe based wireless endpoint
devices.

- Mani

-- 
மணிவண்ணன் சதாசிவம்

