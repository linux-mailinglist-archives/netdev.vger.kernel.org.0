Return-Path: <netdev+bounces-10362-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0E4172E1D3
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 13:40:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 179941C20C43
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 11:40:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0170F2A6E6;
	Tue, 13 Jun 2023 11:40:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E975F3C25
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 11:40:28 +0000 (UTC)
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609FFDB
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 04:40:25 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2b1fe3a1a73so64712071fa.1
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 04:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686656423; x=1689248423;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1ILFfjji/kek95HPgZNGtg2fnZxbJ7O+KIWwgEWEC9o=;
        b=qb+Rve8XJxiV4N8VP3P1UR3TYeC0ijhY5Q9q6E9zpanRXF4+uJnYutBj3O1sfCkiwM
         g/sgduyR6uMgQqW78XfkkAZ003Bn5LY9qY+xjPWz+5490ElZUrwW1BFUFv9MuA2lYZXv
         NeNZT9zrjDXSclpN06tcGqVLSWXr5wOsxOJViSn5WT5Z41lE0oomDiumvoaFAt1nzX/u
         4SFHjE5X8TTbGtCjIyTLJi1w6P6jo8RtPSk1gQdUTRH5wXrkgawzg36uiI7GjlYgjTbt
         zP0UCUxOv5I+agRJyb9unZV8uOsRYCdCr9sFpHAz8y3hd4n9MpaNd6j7d+HslVAGnmn1
         pA+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686656423; x=1689248423;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ILFfjji/kek95HPgZNGtg2fnZxbJ7O+KIWwgEWEC9o=;
        b=XzXJnJjfumGrTrlSbkK+mv5v+xl5w5VELB4kWv5ATjbE2jRjiIOU+ZAHKTCyz2TKsN
         /gY0w3i7nxONhGfV26Sfu4eBrhn1BkajncHGrErN3Y2v5eEOtUOUHoMSrlmFtBBTymMK
         s43udZpOmsFpDMBIgZDfcDLIrjGoJPXG6PZBKkcq+zVE5Xga2pdAHvuTY+Rp+eMc/E2S
         t2cvAbRDJxzYZ+vdbGybRfpdlSGZLqojStPZqsz3nv3YPPQJ9F11m81bEne7OVG5eNCq
         dhjHIklzV9JNvuH0ZFxEdiSAZbjBE7xZ85UaawBzPsvN7TmJix1ZCPFNRcdIgbEjrakJ
         NdVQ==
X-Gm-Message-State: AC+VfDwhc/B6l/xIXNWvg0CS1WpxVFkRhBiHD0V2SuCTaKbti7SFJBze
	qvTt3+FsZvsQyVw3ylQXUTM=
X-Google-Smtp-Source: ACHHUZ7rBx+/Fiz22aE/qj+0V5ehFrqS22UqrsC9yAkmIAxclnxjKThG+KT0Dpk7+tm19qX8FCfmxw==
X-Received: by 2002:a2e:9cd2:0:b0:2b2:1f2f:705f with SMTP id g18-20020a2e9cd2000000b002b21f2f705fmr4190644ljj.4.1686656423211;
        Tue, 13 Jun 2023 04:40:23 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id b14-20020aa7c6ce000000b00506987c5c71sm6256332eds.70.2023.06.13.04.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 04:40:22 -0700 (PDT)
Date: Tue, 13 Jun 2023 14:40:20 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, cai.huoqing@linux.dev, brgl@bgdev.pl,
	chenhao288@hisilicon.com, huangguangbin2@huawei.com,
	David Thompson <davthompson@nvidia.com>
Subject: Re: [PATCH net v2 1/1] mlxbf_gige: Fix kernel panic at shutdown
Message-ID: <20230613114020.6nbnherylwaqnggn@skbuf>
References: <20230612132841.xcrlmfhzhu5qazgk@skbuf>
 <20230612133853.GT12152@unreal>
 <20230612140521.tzhgliaok5u3q67o@skbuf>
 <20230613071959.GU12152@unreal>
 <20230613083002.pjzsno2tzbewej7o@skbuf>
 <20230613090920.GW12152@unreal>
 <20230613093501.46x4rvyhhyx5wo3b@skbuf>
 <20230613101038.GY12152@unreal>
 <20230613103422.ppjeigcugva4gnks@skbuf>
 <20230613112841.GZ12152@unreal>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613112841.GZ12152@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 02:28:41PM +0300, Leon Romanovsky wrote:
> On Tue, Jun 13, 2023 at 01:34:22PM +0300, Vladimir Oltean wrote:
> > On Tue, Jun 13, 2023 at 01:10:38PM +0300, Leon Romanovsky wrote:
> > > On Tue, Jun 13, 2023 at 12:35:01PM +0300, Vladimir Oltean wrote:
> > > > Not really sure where you're aiming with your replies at this stage.
> > > 
> > > My goal is to explain that "bus drivers may implement .shutdown() 
> > > the same way as .remove()" is wrong implementation and expectation
> > > that all drivers will add "if (!priv) return ..." now is not viable.
> > 
> > I never said that all drivers should guard against that - just that it's
> > possible and that there is no mechanism to reject such a thing - which
> > is something you've incorrectly claimed.
> 
> I was wrong in details, but in general I was correct by saying that call
> to .shutdown() and .remove() callbacks are impossible to be performed
> at the same time.
> 
> https://lore.kernel.org/all/20230612115925.GR12152@unreal
> 
> Thanks

Let's stop the conversation here, it is going nowhere. You've given me a
link to a message to which I've responded with exactly the same text as
I would respond now.

