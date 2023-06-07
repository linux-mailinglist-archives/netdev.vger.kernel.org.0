Return-Path: <netdev+bounces-8717-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16880725523
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 09:12:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 758D01C20CDF
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 07:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBC116AB2;
	Wed,  7 Jun 2023 07:12:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDCC6AAE
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:12:39 +0000 (UTC)
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5CC1732
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 00:12:37 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-1a2c85ef3c2so4442436fac.0
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 00:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686121957; x=1688713957;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=448kJfx0P49/QlavcytCAcn+ROp1DkOsc8XIkFFDohc=;
        b=F4oCDwUyfoV1OdJR1wEXY3toanGZYTwTSZswGSkG/Qk6fd1zE55rZr4c58azMzm844
         I0Iyd9o5eUgpi4wLOR/kTe9lQlS6Rdg0MJ+OyO/KSHJUKULWL9Xy6HDNS8wxHDuRFLDT
         bfwv8xOxwhwhWi1Ui064vvYaLTFtFPleGOaH/QblFoGPkux8tCXQESii4DXcKMTf3UDs
         7f0eqMcZ6wDQoe5LLjKvQi/aTm2OZYw3nIixdJ8uwbPaB7fDRNxdpvfoJIUF//8i7x+U
         wfKBVlC2yExFlZsV/W9Refc8oN0rmqLSOJ1joDYQzBaEq4oX0n5e3PC2m/3fg/x0s2nR
         0pPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686121957; x=1688713957;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=448kJfx0P49/QlavcytCAcn+ROp1DkOsc8XIkFFDohc=;
        b=GwHBzkScBGkbOiQpLqh6CpM/zj0Jwo0coJE0Ah4QYkWHE76EYUhNBcieuM+cpuqjWS
         LzLgJJK6QepHXjxWfhi+TsnB/OyMrquGeNDz3jMCSV1GnZ6+DIqSAfWMVphLkbIdO/Vs
         vqgwG8/UuJ2tYLEGavVyiRQmYuEDDf5xw/ObBHWd3Pfjout+AsEkxCuyBj4n8ePs9iRJ
         pPKJwuubUD4D9xaG60se8yAfRgNz0C1LBcFlyrKLgCIMSEtvj0s3iDTTr1+hssXxC7v6
         ZSsOZ8Hf2tFmYxb9Osbp2Whpa2EOmHDzeUJEs3gri9wKFH8bjxTEb0Atn/pnFMPrBU1W
         8lfg==
X-Gm-Message-State: AC+VfDzcmf/wf9oQHFt9xPLl7px+VIqiQhHDl6Ykx8UheThlsgYYm1Bb
	1Iddei4DmpzZLrqpK9Urz9EXmem8UPTVIxMN791o0Q==
X-Google-Smtp-Source: ACHHUZ55XZ8n6rPguTjh4Pc2NQCXjiTAWuZ8fsxM5qyf71DyztoixFdpPmuzGD5p5MAGNLXWEijL56kaTVb4VPpr7as=
X-Received: by 2002:a05:6870:44c5:b0:19f:698f:56a1 with SMTP id
 t5-20020a05687044c500b0019f698f56a1mr4397617oai.15.1686121956816; Wed, 07 Jun
 2023 00:12:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230606123119.57499-1-manivannan.sadhasivam@linaro.org>
 <c769c95d-e8cb-4cf6-a41a-9bef5a786bb1@lunn.ch> <20230607065652.GA5025@thinkpad>
In-Reply-To: <20230607065652.GA5025@thinkpad>
From: Loic Poulain <loic.poulain@linaro.org>
Date: Wed, 7 Jun 2023 09:12:00 +0200
Message-ID: <CAMZdPi-xJAj_eFvosVTmSzA99m3eYhrwoKPfBk-qH87yZzNupQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Add MHI Endpoint network driver
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, mhi@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 7 Jun 2023 at 08:56, Manivannan Sadhasivam
<manivannan.sadhasivam@linaro.org> wrote:
>
> On Tue, Jun 06, 2023 at 02:59:00PM +0200, Andrew Lunn wrote:
> > On Tue, Jun 06, 2023 at 06:01:16PM +0530, Manivannan Sadhasivam wrote:
> > > Hi,
> > >
> > > This series adds a network driver for the Modem Host Interface (MHI) endpoint
> > > devices that provides network interfaces to the PCIe based Qualcomm endpoint
> > > devices supporting MHI bus (like Modems). This driver allows the MHI endpoint
> > > devices to establish IP communication with the host machines (x86, ARM64) over
> > > MHI bus.
> > >
> > > On the host side, the existing mhi_net driver provides the network connectivity
> > > to the host.
> > >
> > > - Mani
> > >
> > > Manivannan Sadhasivam (3):
> > >   net: Add MHI Endpoint network driver
> > >   MAINTAINERS: Add entry for MHI networking drivers under MHI bus
> > >   net: mhi: Increase the default MTU from 16K to 32K
> > >
> > >  MAINTAINERS              |   1 +
> > >  drivers/net/Kconfig      |   9 ++
> > >  drivers/net/Makefile     |   1 +
> > >  drivers/net/mhi_ep_net.c | 331 +++++++++++++++++++++++++++++++++++++++
> > >  drivers/net/mhi_net.c    |   2 +-
> >
> > Should we add a drivers/net/modem directory? Maybe modem is too
> > generic, we want something which represents GSM, LTE, UMTS, 3G, 4G,
> > 5G, ... XG etc.
> >
>
> The generic modem hierarchy sounds good to me because most of the times a
> single driver handles multiple technologies. The existing drivers supporting
> modems are already under different hierarchy like usb, wwan etc... So unifying
> them makes sense. But someone from networking community should take a call.


Yes, so there is already a drivers/net/wwan directory for this, in
which there are drivers for control and data path, that together
represent a given 'wwan' (modem) entity. So the generic mhi_net could
be moved there, but the point is AFAIU, that MHI, despite his name, is
not (more) used only for modem, but as a generic memory sharing based
transport protocol, such as virtio. It would then not be necessarily
true that a peripheral exposing MHI net channel is actually a modem?

Regards,
Loic

