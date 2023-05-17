Return-Path: <netdev+bounces-3393-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB160706DAD
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 18:10:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F06B7281716
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:10:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 266AD111B3;
	Wed, 17 May 2023 16:10:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17088101D9
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 16:10:52 +0000 (UTC)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDC061A9
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:10:33 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-9659f452148so176341466b.1
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684339832; x=1686931832;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0AfX89yAaREyFSJldXyDuKnUoq48HBA0I85W4X6Wvf8=;
        b=HYVdwdwDSlCXAXvIPvB7bCa6AgpvDlRQAsI33GFmJUB5KYd3TnHp99ekrtt2DIFxy8
         RUDG0VzXTUaXDq1zROy1VrJB6pOocLdlgjWUjAb1vlV10FBBVbfBTea0esK1H8+iuCX9
         Z1t162drOxm/aJuakWFadlArBMyh6uYzUj8DE1Myu6FiElvInspuO1NkJdhfV8uSioje
         K+liQZoKp31vJQDa4Bw0UXpRdk6ES0Qd/Yxjsq+DsQAt+kuZoAP8sM1fwW51rYWB7ugA
         37JfXjeYnfnzZD8cBNgijsqy3pTMY+ShyGPmJKciVKpDfDB8U7k+6+GlPgLTMxSwyzQV
         2x2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684339832; x=1686931832;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0AfX89yAaREyFSJldXyDuKnUoq48HBA0I85W4X6Wvf8=;
        b=MzrFtYP+CIoRlWUkm1gWfXR/ioFzNgbCV1LfCL5+EsqQfPnfS3wRW6MnXXHCiMHF5/
         c2zQiM3phHIFsU0v2Z/fE08eKgEXKGQ/7Uns3iFPtXL5lnCUYC5dUj1xYIiw7gAOyHNB
         yCuXMUKrLYpGawF2oVoIEXYe+NQzTY8tETqi8Fx8hXHmm+kmTStvo9sdkXmfMYDhteVq
         WsLLi6LELKANdvVCWK0y/Bn+oYvEMguDAql3pg2dDMS6rP7G33sCKGiiGuTk9KABh/Eq
         4Wzp3XAVuIIl99wXLXQP7T8AyS8ABN4/UtL7siUmAJ9CjjH6Py+0QeIneciExmMDAVWL
         6Jkw==
X-Gm-Message-State: AC+VfDxtSWLKccaYFayC4K/gyxyjD7BidauB5HtjCKGhAuedNyasOPOx
	lLP826mPUcsZ8jH/WDbN/mg=
X-Google-Smtp-Source: ACHHUZ5JFAM3GLPRD7Ca3RAMTAZuvJntIKmFaJihT9rUkB0iS/efpcTz8Cj2iEuD3kyGuy61WfoEmg==
X-Received: by 2002:a17:907:96ac:b0:948:a1ae:b2c4 with SMTP id hd44-20020a17090796ac00b00948a1aeb2c4mr45050207ejc.6.1684339831456;
        Wed, 17 May 2023 09:10:31 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id d19-20020a1709061f5300b009596e7e0dbasm12391123ejk.162.2023.05.17.09.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 09:10:31 -0700 (PDT)
Date: Wed, 17 May 2023 19:10:28 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: Frank Wunderlich <frank-w@public-files.de>,
	Felix Fietkau <nbd@nbd.name>, netdev <netdev@vger.kernel.org>,
	erkin.bozoglu@xeront.com, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	John Crispin <john@phrozen.org>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>
Subject: Re: Choose a default DSA CPU port
Message-ID: <20230517161028.6xmt4dgxtb4optm6@skbuf>
References: <trinity-4ef08653-c2e7-4da8-8572-4081dca0e2f7-1677271483935@3c-app-gmx-bap70>
 <20230224210852.np3kduoqhrbzuqg3@skbuf>
 <trinity-5a3fbd85-79ce-4021-957f-aea9617bb320-1677333013552@3c-app-gmx-bap06>
 <f9fcf74b-7e30-9b51-776b-6a3537236bf6@arinc9.com>
 <6383a98a-1b00-913d-0db1-fe33685a8410@arinc9.com>
 <trinity-6ad483d2-5c50-4f38-b386-f4941c85c1fd-1677413524438@3c-app-gmx-bs15>
 <20230228115846.4r2wuyhsccmrpdfh@skbuf>
 <91c90cc5-7971-8a95-fe64-b6e5f53a8246@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <91c90cc5-7971-8a95-fe64-b6e5f53a8246@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 10:29:27PM +0300, Arınç ÜNAL wrote:
> For MT7530, the port to trap the frames to is fixed since CPU_PORT is only
> of 3 bits so only one CPU port can be defined. This means that, in case of
> multiple ports used as CPU ports, any frames set for trapping to CPU port
> will be trapped to the numerically greatest CPU port.

*that is up

