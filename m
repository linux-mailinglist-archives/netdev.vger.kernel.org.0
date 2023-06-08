Return-Path: <netdev+bounces-9220-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80AC872803A
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 14:41:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC8DB1C20FFB
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 12:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8363C11CA2;
	Thu,  8 Jun 2023 12:41:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7797F947B
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 12:41:06 +0000 (UTC)
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F20F2D48
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 05:41:03 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-543a09ee32eso1212369a12.1
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 05:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686228062; x=1688820062;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=o6uvPLwieY5RkBOZk+PD7M8YvflhokrnPtugOrS3QNE=;
        b=Mx3sJVE2F1ORzjGqe3xy6X7wsCEApK1+VCCgRvjXycaGUApi2Tp0szjSn8M0PPbOrY
         L6ZT2JbB809hrtAlSMLtJWgI0nHKoi/twmYAH9M+c9GMxpGAo8IGutngAyddmrMKefPf
         RCBU4mnCL8+y9Yt8bpiSs2ZXdu8RQpYfL+zv2Gdo/ZaxOJSXFBTVqBrjamKKAnk98XpL
         A7o0ukDCFy0RxCHOvs0/9rVuq8Zu9N2PmEmZ1tpwMEr4hiD84QamxF/SauHaF9MhLS8B
         H5kQh9NyXsLSH3lUag3Ko/bg3fjlMsun8spM10a3OnrUJn+QiGsJ/VHlyT4g7Qu0l+ww
         rEGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686228062; x=1688820062;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o6uvPLwieY5RkBOZk+PD7M8YvflhokrnPtugOrS3QNE=;
        b=U07/aizfzQmR/TQj5Smec1v3MCsz73WF28ZtnkI4tqWZOC00klBziak2S93uwL3CHO
         LFn27kT+Pp8xbup19vbhFv7SLKQEWE+BclVa58B+BSrpfxr2Hui0suhTQ72D72Lccoz3
         6VQvnjVTIjDe7bFkzaoZq2vLCPOEAJJZ3+y7oz4wgU8f3Ui1AwNJG7NiYP0puepbOuiF
         fxhhWjvGl/UaSs8ClZU+dgDKvi76eCH0X+Rfzc4X5XV3ZKRurtEKUkGTJWy0snHoY2wv
         EVnOAE6yjvrZkcK4RNdJv7tSsqKjxzoyf0BXWz9vmh34e33G7wQ94prUW5WRvVgKhpyg
         azXA==
X-Gm-Message-State: AC+VfDzKdnclaHfqY1+aE0FKXPehGWrsgRv6M6S9vYQMxjshupNMols6
	aJEUTajRohyQ8nBf8vzJ4puIEqlJuOmg8Cs6Fg==
X-Google-Smtp-Source: ACHHUZ5poAB/V7RXQ3dOzoAJckBX+G4y1Bj7UJT9KsKdnWi22t9GzGjV2GyemH6S7dwhra7PXiL1qQ==
X-Received: by 2002:a17:90b:314c:b0:25b:83ca:2b75 with SMTP id ip12-20020a17090b314c00b0025b83ca2b75mr176896pjb.3.1686228062475;
        Thu, 08 Jun 2023 05:41:02 -0700 (PDT)
Received: from thinkpad ([117.202.186.138])
        by smtp.gmail.com with ESMTPSA id 30-20020a17090a01de00b00259a3c99978sm1285622pjd.17.2023.06.08.05.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 05:41:02 -0700 (PDT)
Date: Thu, 8 Jun 2023 18:10:57 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
	edumazet@google.com, pabeni@redhat.com, mhi@lists.linux.dev,
	linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, loic.poulain@linaro.org
Subject: Re: [PATCH v2 0/2] Add MHI Endpoint network driver
Message-ID: <20230608124057.GD5672@thinkpad>
References: <20230607152427.108607-1-manivannan.sadhasivam@linaro.org>
 <20230607094922.43106896@kernel.org>
 <eb4b45ab-1f51-47e9-a286-a9e26461ebed@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eb4b45ab-1f51-47e9-a286-a9e26461ebed@lunn.ch>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 08:13:32PM +0200, Andrew Lunn wrote:
> On Wed, Jun 07, 2023 at 09:49:22AM -0700, Jakub Kicinski wrote:
> > On Wed,  7 Jun 2023 20:54:25 +0530 Manivannan Sadhasivam wrote:
> > > This series adds a network driver for the Modem Host Interface (MHI) endpoint
> > > devices that provides network interfaces to the PCIe based Qualcomm endpoint
> > > devices supporting MHI bus (like Modems). This driver allows the MHI endpoint
> > > devices to establish IP communication with the host machines (x86, ARM64) over
> > > MHI bus.
> > > 
> > > On the host side, the existing mhi_net driver provides the network connectivity
> > > to the host.
> > 
> > Why are you posting the next version before the discussion on the
> > previous one concluded? :|
> > 
> > In any case, I'm opposed to reuse of the networking stack to talk
> > to firmware. It's a local device. The networking subsystem doesn't
> > have to cater to fake networks. Please carry:
> > 
> > Nacked-by: Jakub Kicinski <kuba@kernel.org>
> 
> Remote Processor Messaging (rpmsg) Framework does seem to be what is
> supposed to be used for these sorts of situations. Not that i know
> much about it.
> 

Rpmsg is another messaging protocol used for talking to the remote processor.
MHI is somewhat similar in terms of usecase but it is a proprietary protocol
used by Qcom for their devices.

- Mani

>      Andrew

-- 
மணிவண்ணன் சதாசிவம்

