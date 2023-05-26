Return-Path: <netdev+bounces-5541-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E5DE7120B6
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:14:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C984D281678
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 07:14:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C84A07490;
	Fri, 26 May 2023 07:14:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC4E53B5
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 07:14:31 +0000 (UTC)
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289E19E
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 00:14:30 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2af24ee004dso3871381fa.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 00:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ferroamp-se.20221208.gappssmtp.com; s=20221208; t=1685085268; x=1687677268;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3K/62msDIii3xLYW9Icv9dnXBGx+K8WckoEIc9LcduA=;
        b=H0qkNClkPMIWXXZNXMH5tA2x04zcS0hk+cqhMPZwXHszLan7W5SX1Kws9AaRAuDNGJ
         pgCueACS7YZWv+imegF89fLvEOi7HrfnhEB3ZsyOatvcdcjOVXgutlhZZvtJlp/u2mcY
         Kjh28TkQAxCVGaW17ZI4UiJTEsC00hwKlqpoFJF+sHnZxVlYHrUrt+Xtk+YDe/6ty1zh
         /ShrdoYVV4mmQcIpdSizk8L9Kn4MmHbN6GcI+Hjc3yqkyZqHfsrfpbGh/vAKiRLuv22P
         WExg/oEW3Y5cnzkoaFvd4D4U/67Sv9DLB5TthXCVUUWNFEDmLkpdSruB5EhpfPmhougY
         ViBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685085268; x=1687677268;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3K/62msDIii3xLYW9Icv9dnXBGx+K8WckoEIc9LcduA=;
        b=HxaxQQV3Bxoj+YVnaqmbTtLsjywFylgJZnfxTz53NeOtc59MqLMAFaxluupYZft6Rs
         xMCIHOF42DL/mwmDMv6TvVOtrecy7R3lUlP9Ng+RrkPu6pNXWAggnpgxSJEIqTGDU7Qs
         QjvbK5Pw2NYCwWZ+QgNoBapXVgKKjWBVmH4dUps+mh9BjBLhDqtli5YNhuIMmNW9FlRw
         t8SWrTn09r5wI7WCl+v5wuGQqSto0FrKCSWTVGxY2TLVVvts3JUI1oVEyTZyi5fNQdRP
         fie9H6+ZY8qwO1aWdToP/fDXBYZYttNKVE5a+YX56FT57SEkQx8kwc/XcNZF1dqtb1ae
         +GXA==
X-Gm-Message-State: AC+VfDwzLjsGUBeEWmHHBbEYW3WQITT+vfmSvhK2JoA0ToDQjLyQTy2j
	dyp6/YBxPOATxf+Nsnn+/QE8CA==
X-Google-Smtp-Source: ACHHUZ65xMv2X15SMYn7/LhjUXnbr6qqdbl8nLCRTsUbx9ec0tlYM2I8fNH80L+MU/pklpilBOqhRg==
X-Received: by 2002:a2e:84c1:0:b0:2ac:8a05:b2c7 with SMTP id q1-20020a2e84c1000000b002ac8a05b2c7mr384572ljh.7.1685085268428;
        Fri, 26 May 2023 00:14:28 -0700 (PDT)
Received: from debian (151.236.202.107.c.fiberdirekt.net. [151.236.202.107])
        by smtp.gmail.com with ESMTPSA id z4-20020a05651c022400b002aa3cff0529sm586897ljn.74.2023.05.26.00.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 00:14:27 -0700 (PDT)
Date: Fri, 26 May 2023 09:14:26 +0200
From: =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
To: Parthiban.Veerasooran@microchip.com
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Horatiu.Vultur@microchip.com,
	Woojung.Huh@microchip.com, Nicolas.Ferre@microchip.com,
	Thorsten.Kummermehr@microchip.com
Subject: Re: [PATCH net-next v3 4/6] net: phy: microchip_t1s: fix reset
 complete status handling
Message-ID: <ZHBcUvSbX0taOED3@debian>
References: <20230524144539.62618-1-Parthiban.Veerasooran@microchip.com>
 <20230524144539.62618-5-Parthiban.Veerasooran@microchip.com>
 <ZG+oOVWuKnwE0IB2@builder>
 <8a46450d-7c6e-68a4-c09d-3b195a935907@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a46450d-7c6e-68a4-c09d-3b195a935907@microchip.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 06:00:08AM +0000, Parthiban.Veerasooran@microchip.com wrote:
> Hi Ramon,
> >> +     /* Read STS2 register and check for the Reset Complete status to do the
> >> +      * init configuration. If the Reset Complete is not set, wait for 5us
> >> +      * and then read STS2 register again and check for Reset Complete status.
> >> +      * Still if it is failed then declare PHY reset error or else proceed
> >> +      * for the PHY initial register configuration.
> >> +      */
> > 
> > This comment explains exactly what the code does, which is also obvious
> > from reading the code. A meaningful comment would be explaining why the
> > state can change 5us later.
> > 
> As per design, LAN867x reset to be completed by 3us. Just for a safer 
> side it is recommended to use 5us. With the assumption of more than 3us 
> completion, the first read checks for the Reset Complete. If the 
> config_init is more faster, then once again checks for it after 5us.
> 
> As you mentioned, can we remove the existing block comment as it 
> explains the code and add the above comment to explain 5us delay.
> What is your opinion on this proposal?
> 
> Best Regards,
> Parthiban V
> 

I'd suggest the following
/*The chip completes a reset in 3us, we might get here earlier than that,
as an added margin we'll conditionally sleep 5us*/

