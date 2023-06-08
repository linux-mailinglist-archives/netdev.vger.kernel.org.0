Return-Path: <netdev+bounces-9219-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B0A172802E
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 14:37:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35E4D28174E
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 12:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 043B1BA40;
	Thu,  8 Jun 2023 12:37:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76C3D2FC
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 12:37:27 +0000 (UTC)
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20871E43
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 05:37:26 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-53fe2275249so251849a12.2
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 05:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686227845; x=1688819845;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vF7BJHmnxG54wdpwiHNjVAE0LjJI9FuEL9uTFxii16I=;
        b=Aiihaxqbz67spa16+ZNOJjy54FXq89dppdCCz9Lcbhkd1yMhtCvLFtvwjOBywkj95T
         gZo1sybXE7ojr4Mpm+2zdshpW7LLYICvQXmckN7RsoPdmf+ajw2t3ShsnENqNzpyL0jc
         n3TUh5i2XOfPD9zSWWou5wq+rd5FQ9VRL/C5w0rT/oHrYuFtHyXO9VEqP600FaiZQNuC
         wvmkXmP6rYdrESm3zrPXrqjiXGjz+GD/R64YTsoi8kCuMzvm2d6lZHjPGm2UhG/xAV+Q
         N001B3KB1Yv8ywbvOgjN8qmr29lrg22Q+MsgF2mpA+k/RfVRIPRwxwrcWXqgvDa+MZkx
         FjOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686227845; x=1688819845;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vF7BJHmnxG54wdpwiHNjVAE0LjJI9FuEL9uTFxii16I=;
        b=ArH36h/3Edne2TU4QfG46Gl5+3MdUL80ZGYHoQRuCH1PK2NXoHStQuLnQHn+uHi/UZ
         kvuolwOtxxiOPts63z33QGMG2enRSC70xb0qn/sMUV0CnR7SrayOcqbYxDHoOS1YpFxX
         nrALoBnEwhxEzIykOk6NEyLNJ8m+2k31HhYVaQZr6t07xk4rmvt3g1pcLl0foeT4sltt
         7gFTag9tJr38cM6CLvSIiXlbMiEwG6PMCgH9cfJbB01K+Spp+h0Vohck5npMhefvDK+D
         /xwuA8Ptx+4IsvEOxayZWYcMhNZsW99fLwHYlAB38IMwYQWdyh0+lOBehmMXphADPr4F
         cgew==
X-Gm-Message-State: AC+VfDwKHFvVBFez/iaga+4wpK4DfEkrhyHZCP7Ng6PCKg7eJ8hiCMDu
	353J7v9/lk3SZobbRvfTfAZBeTG77f100n9AIQ==
X-Google-Smtp-Source: ACHHUZ6tZyhqvp7cqUQlsZZN44LfD6nkDhNPmbUYwX0UZxMiBiudwS0spmZHcsUdiFOa9lkqBcSCYg==
X-Received: by 2002:a17:90a:fa42:b0:259:e35f:ab2e with SMTP id dt2-20020a17090afa4200b00259e35fab2emr1853190pjb.4.1686227845577;
        Thu, 08 Jun 2023 05:37:25 -0700 (PDT)
Received: from thinkpad ([117.202.186.138])
        by smtp.gmail.com with ESMTPSA id 22-20020a17090a19d600b0024c1ac09394sm1288861pjj.19.2023.06.08.05.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 05:37:25 -0700 (PDT)
Date: Thu, 8 Jun 2023 18:07:20 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	loic.poulain@linaro.org
Subject: Re: [PATCH v2 0/2] Add MHI Endpoint network driver
Message-ID: <20230608123720.GC5672@thinkpad>
References: <20230607152427.108607-1-manivannan.sadhasivam@linaro.org>
 <20230607094922.43106896@kernel.org>
 <20230607171153.GA109456@thinkpad>
 <20230607104350.03a51711@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230607104350.03a51711@kernel.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 10:43:50AM -0700, Jakub Kicinski wrote:
> On Wed, 7 Jun 2023 22:41:53 +0530 Manivannan Sadhasivam wrote:
> > > In any case, I'm opposed to reuse of the networking stack to talk
> > > to firmware. It's a local device. The networking subsystem doesn't
> > > have to cater to fake networks. Please carry:
> > > 
> > > Nacked-by: Jakub Kicinski <kuba@kernel.org>
> > > 
> > > if there are future submissions.  
> > 
> > Why shouldn't it be? With this kind of setup one could share the data connectivity
> > available in the device with the host over IP tunneling. If the IP source in the
> > device (like modem DSP) has no way to be shared with the host, then those IP
> > packets could be tunneled through this interface for providing connectivity to
> > the host.
> > 
> > I believe this is a common usecase among the PCIe based wireless endpoint
> > devices.
> 
> We can handwave our way into many scenarios and terrible architectures.
> I don't see any compelling reason to merge this.

These kind of usecases exist in the products out there in the market. Regarding
your comment on "opposed to reuse of the network stack to talk to firmware", it
not the just the firmware, it is the device in general that is talking to the
host over this interface. And I don't see how different it is from the host
perspective.

And these kind of scenarios exist with all types of interfaces like usb-gadget,
virtio etc... So not sure why the rule is different for networking subsystem.

- Mani

-- 
மணிவண்ணன் சதாசிவம்

