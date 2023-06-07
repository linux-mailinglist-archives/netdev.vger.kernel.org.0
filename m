Return-Path: <netdev+bounces-8724-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9420572560E
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 09:41:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0CC81C20CB8
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 07:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF0E26D22;
	Wed,  7 Jun 2023 07:41:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7A41C3A
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:41:38 +0000 (UTC)
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA522702
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 00:41:36 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-2566ed9328eso5992560a91.2
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 00:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686123696; x=1688715696;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PjfFNwe8EaTiGUc0QuU/z5HZzTxOk+LVPPYj8mjsNzM=;
        b=hS/0Qma+MSVMOmezs7ae7p8C6lqEhrJlH4f8w//ca/fANrvQFpvioDvwVaAwPHQSzE
         EL+56AyeCdS0kQd3cWCnJCzDFlyZ0NgUkjIKhc+IBMpxxfgC/UIbczsJD5rvidJWiFP9
         nsxFpkRubavOeHiiEIqmlgS/LCSdacfRd/nv2kdeFYj/T3jfPhrkGiOcxQ8TLNcAk9Mc
         NTiF2gKhlqebuJ/MTHPTamqsd29u40mFj8p5BVVapN6n6TGCmK0Q/ELwrFvNDnVn/Jw5
         JqSy0dBoTifuelcf07VOm2+g3Cg+A5XuT+aYXYH4rcXRsPuNJr31a1KxDYscNwARPcOh
         Q/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686123696; x=1688715696;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PjfFNwe8EaTiGUc0QuU/z5HZzTxOk+LVPPYj8mjsNzM=;
        b=MGfwTH13aOOIrspWoY4BiHv48iaZWh8a1aJ/IntPGinNPgUKIBwDVsuNHbWhquc8lv
         nMDu2D6t5lIKP2CT1TvWvQoMLvQ4Bm1cOUq5E8T5r/y6gDjr/nUWzCWv4PGh15owswIV
         NxNbP9aHifRRrM5UfhErNOYMPvyvfBtn2BLDrcUVRHD89EBRk9icz2yRAU2i0fdga5JZ
         W9JOabf0y+xAjgF2nzD3LRD5lPWUJPz1uLVOydDIYTYCzCScFBGsY0nda5FkXLeKscDs
         q9bOs9AAGIh2pU9Ntwd2feQqdFAwADq5CXCUFReOK0n4fn2LegNc6b/LINnf3ZlMlmoJ
         5YRw==
X-Gm-Message-State: AC+VfDyww0IhI6DflMo00+kmegmqGn9CGiPo44obJ1EHIi0tAeS2wfNr
	NIeYhLGwUUkHjVxjtPqsO66T
X-Google-Smtp-Source: ACHHUZ50Fei3Zw35iH9ZCnQkZU/3FdMXz9ZIxWFCszlfvuqnYaKVV+Vt/Nyt3IqrO4RypPINYFkinw==
X-Received: by 2002:a17:90b:3846:b0:253:49d7:ce19 with SMTP id nl6-20020a17090b384600b0025349d7ce19mr3930719pjb.18.1686123695820;
        Wed, 07 Jun 2023 00:41:35 -0700 (PDT)
Received: from thinkpad ([59.92.97.244])
        by smtp.gmail.com with ESMTPSA id 8-20020a17090a1a4800b0023a84911df2sm788372pjl.7.2023.06.07.00.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 00:41:35 -0700 (PDT)
Date: Wed, 7 Jun 2023 13:11:18 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Loic Poulain <loic.poulain@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, mhi@lists.linux.dev,
	linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Add MHI Endpoint network driver
Message-ID: <20230607074118.GD5025@thinkpad>
References: <20230606123119.57499-1-manivannan.sadhasivam@linaro.org>
 <c769c95d-e8cb-4cf6-a41a-9bef5a786bb1@lunn.ch>
 <20230607065652.GA5025@thinkpad>
 <CAMZdPi-xJAj_eFvosVTmSzA99m3eYhrwoKPfBk-qH87yZzNupQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMZdPi-xJAj_eFvosVTmSzA99m3eYhrwoKPfBk-qH87yZzNupQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 09:12:00AM +0200, Loic Poulain wrote:
> On Wed, 7 Jun 2023 at 08:56, Manivannan Sadhasivam
> <manivannan.sadhasivam@linaro.org> wrote:
> >
> > On Tue, Jun 06, 2023 at 02:59:00PM +0200, Andrew Lunn wrote:
> > > On Tue, Jun 06, 2023 at 06:01:16PM +0530, Manivannan Sadhasivam wrote:
> > > > Hi,
> > > >
> > > > This series adds a network driver for the Modem Host Interface (MHI) endpoint
> > > > devices that provides network interfaces to the PCIe based Qualcomm endpoint
> > > > devices supporting MHI bus (like Modems). This driver allows the MHI endpoint
> > > > devices to establish IP communication with the host machines (x86, ARM64) over
> > > > MHI bus.
> > > >
> > > > On the host side, the existing mhi_net driver provides the network connectivity
> > > > to the host.
> > > >
> > > > - Mani
> > > >
> > > > Manivannan Sadhasivam (3):
> > > >   net: Add MHI Endpoint network driver
> > > >   MAINTAINERS: Add entry for MHI networking drivers under MHI bus
> > > >   net: mhi: Increase the default MTU from 16K to 32K
> > > >
> > > >  MAINTAINERS              |   1 +
> > > >  drivers/net/Kconfig      |   9 ++
> > > >  drivers/net/Makefile     |   1 +
> > > >  drivers/net/mhi_ep_net.c | 331 +++++++++++++++++++++++++++++++++++++++
> > > >  drivers/net/mhi_net.c    |   2 +-
> > >
> > > Should we add a drivers/net/modem directory? Maybe modem is too
> > > generic, we want something which represents GSM, LTE, UMTS, 3G, 4G,
> > > 5G, ... XG etc.
> > >
> >
> > The generic modem hierarchy sounds good to me because most of the times a
> > single driver handles multiple technologies. The existing drivers supporting
> > modems are already under different hierarchy like usb, wwan etc... So unifying
> > them makes sense. But someone from networking community should take a call.
> 
> 
> Yes, so there is already a drivers/net/wwan directory for this, in
> which there are drivers for control and data path, that together
> represent a given 'wwan' (modem) entity. So the generic mhi_net could
> be moved there, but the point is AFAIU, that MHI, despite his name, is
> not (more) used only for modem, but as a generic memory sharing based
> transport protocol, such as virtio. It would then not be necessarily
> true that a peripheral exposing MHI net channel is actually a modem?
> 

Agree, mhi_*_net drivers can be used by non-modem devices too as long as they
support MHI protocol.

- Mani

> Regards,
> Loic

-- 
மணிவண்ணன் சதாசிவம்

