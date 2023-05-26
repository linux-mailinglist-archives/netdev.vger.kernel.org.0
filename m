Return-Path: <netdev+bounces-5540-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5581D7120AF
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:10:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 122F31C20B9B
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 07:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76B1D6FA2;
	Fri, 26 May 2023 07:10:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A42153A0
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 07:10:21 +0000 (UTC)
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD53F114
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 00:10:16 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4f00c33c3d6so398661e87.2
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 00:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ferroamp-se.20221208.gappssmtp.com; s=20221208; t=1685085015; x=1687677015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PdSg9NNrGreQrCE+41nuiJXywFlMg6bfSTzQTeA3s0E=;
        b=wV8hXAlTqXUsZbsSvOPXVKDD77Yds5Wc2nhgmK1XKx78K0YXTvRb7ImCIYu6fGBP1C
         4ZGOG5EXz679whvOJcZVf9ayuTYDJkWfhJfGXZ1TTRlC12IFhRRJCudrcyocrGM8JsC7
         gjApEvzwSGNhqtgBfYJikC7tHmBa/e1gRpecvurPwqj/N2DXnpienBYmThZ5EXymO7+S
         qxqTg9udNGx1qMwuegqMdG4MtLTriQF/spcMcne+uAIaxTLAXYRZq9OyUvYnY8TcZg+r
         fLRibuiWSK8ZbORI0XzQP9xpGZ372n4tO+ADw1Qkep36caoRbfOv2WwGk4hZ+KDY5MmL
         PmKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685085015; x=1687677015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PdSg9NNrGreQrCE+41nuiJXywFlMg6bfSTzQTeA3s0E=;
        b=jTPKiXg5KIxsSgpG6E1Yamg5U94l2O+Ixsqy5+bRioN7k7hT/HmU30hGc4bpcanAFa
         FUhquBSlMQta6N0+i1sMTqIHi0ReX2zscfzZN3YysmyvO6iuEwnxQECu8X6tKqMhKZZ+
         ixbUokCKYoMBtPXB7aGbvwcG35QvAtdtUDpzlnuddho0oFKKoJRkZFnRASv/DHBixxJ7
         AnDVLTy3nn+bhYY7QGCp6iqsQBB7oM0bjElIRz+nfd4p1hNWnPuLJsos/cJP5ANiLDYS
         huFEVLcRGDEnpEILKpCLSGKiPw+hpOct9fkr4ehq1cSS81SIDxPHO3jqnQ04MPO/9GN5
         gQig==
X-Gm-Message-State: AC+VfDyyYtTRPr9pDNA/QtBhuAK1xELSJJmFqjz8E2YbBgn5Ac2RpWBd
	h/89tc7QBVq6blADTO22yr8BHQ==
X-Google-Smtp-Source: ACHHUZ7+mkpIO2s9Sgs7OSiBzlir4Snu1p566KlcrNwvuimRXpNtoLOjtVD7HEOHgLF77AZ+hLTZkw==
X-Received: by 2002:a05:6512:15d:b0:4ec:7b87:931a with SMTP id m29-20020a056512015d00b004ec7b87931amr359152lfo.13.1685085015190;
        Fri, 26 May 2023 00:10:15 -0700 (PDT)
Received: from debian (151.236.202.107.c.fiberdirekt.net. [151.236.202.107])
        by smtp.gmail.com with ESMTPSA id b27-20020a056512025b00b004f121c8beddsm501833lfo.124.2023.05.26.00.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 00:10:14 -0700 (PDT)
Date: Fri, 26 May 2023 09:10:12 +0200
From: =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
To: Parthiban.Veerasooran@microchip.com
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Horatiu.Vultur@microchip.com,
	Woojung.Huh@microchip.com, Nicolas.Ferre@microchip.com,
	Thorsten.Kummermehr@microchip.com
Subject: Re: [PATCH net-next v3 2/6] net: phy: microchip_t1s: replace
 read-modify-write code with phy_modify_mmd
Message-ID: <ZHBbVNWeKK2di73h@debian>
References: <20230524144539.62618-1-Parthiban.Veerasooran@microchip.com>
 <20230524144539.62618-3-Parthiban.Veerasooran@microchip.com>
 <ZG9599nfDnkcw8er@debian>
 <f81c80cb-fbe8-0c7e-f0f9-14509f47c653@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f81c80cb-fbe8-0c7e-f0f9-14509f47c653@microchip.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 05:48:25AM +0000, Parthiban.Veerasooran@microchip.com wrote:
> Hi Ramon,
> > Nitpick, I think this block comment can be reduced to:
> > /* The following block deviates from AN1699 which states that a values
> >   * should be written back, even if unmodified.
> >   * Which is not necessary, so it's safe to use phy_modify_mmd here.*/
> > 
> >   The comment I added was intended to describe why I was doing weird
> >   things, but now I think it's more interesting to describe why we're
> >   deviating from the AN.
> > 
> >   Or the block comment could be dropped all togheter, I'm guessing no one
> >   is going to consult the AN if things 'just work'
> > 
> By consolidating all your comments in the other emails as well on this 
> 2nd patch, do you agree for my below proposal?
> 
> We will remove all block comments and simply put AN1699 reference as we 
> did for lan865x_revb0_config_init with a small addition on top of 
> phy_modify_mmd for loop? so the comment will look like below,
> 
> /* Reference to AN1699
>   * 
> https://ww1.microchip.com/downloads/aemDocuments/documents/AIS/ProductDocuments/SupportingCollateral/AN-LAN8670-1-2-config-60001699.pdf
>   * AN1699 says Read, Modify, Write, but the Write is not required if 
> the  register already has the required value. So it is safe to use 
> phy_modify_mmd here.
>   */
> 
> So in future, if someone wants to know about this configuration they can 
> simply refer the AN1699.
> 
> What do you think?
> 

I'm not sure about the link, resources have a tendency to move.
Otherwise LGTM

> Best Regards,
> Parthiban V

