Return-Path: <netdev+bounces-10355-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ECE972DFA1
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:34:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDE45280F3C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 10:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DDEC1775A;
	Tue, 13 Jun 2023 10:34:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231663D8C
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 10:34:35 +0000 (UTC)
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B8226BC
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 03:34:27 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-5149c76f4dbso9283524a12.1
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 03:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686652465; x=1689244465;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MzYL7llwNam84OEj5A8iQE741bEg2vYCuXl3E1ypd1I=;
        b=m2wz8IgeGTPDhBLHlGjaLUKuKf+3vMO/5LqQqVUPVPdwEk+1QRLD3yeD8TlBDSoRPw
         DTb9PSsrAd5vU3iPLlmriO8FVgmcJmuQiMBt3xsUD+XxhFXWV0uFHhhd03TqYb9hdoda
         bEFFgnx+VCYTjN9ckV8/NxIVaa68lZg9pETXQmFTTJyQByfciop1HKmu3nwCI4CZVEv/
         wmsSkHs8dvf6mdeLntrVNFuRhDjyS3hOhVDRrNmNyRajnHS4wScTLgPwJlWj4PjJPV3R
         W4Kpxtfb/0JmiTM/uVtxMEvGEmiMJ0WDyt+w3pVMsVqAvauVrNak0tA4Umeq2Sn73k2K
         G/dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686652465; x=1689244465;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MzYL7llwNam84OEj5A8iQE741bEg2vYCuXl3E1ypd1I=;
        b=Nk2QvExkLlA/VuFQJtnrbGNK+LiierFPteLsV4AsbZTNx98jEqxKmUyoOlXyfBKjY+
         oUvo9pT7YHCjzMl71zFtMKTjU+0pa/JytqEQq7iB3akhUzyUJdh0535zXh5XGx0M179T
         jwzkJIhsNaQhjmMCl/DzGe0iIiDpRXonXH2q8xgj5UTpg+X+N6mYnus2YA4KOX75II5G
         vplmexVCLU9gQ9giV2QJHBXXiINzIEZy5XEykdHvYzuzTb+6zoVIYYo5RnChBzAwNN5W
         hgFQGjij7xwkwo8rU9MKnthZnhJXrZ/7jHesAihnBwIAKRDgUThMuHnSpynb+HTv8hqi
         ebMg==
X-Gm-Message-State: AC+VfDxnkQkYoFhcwGlhUE2AEpWrkujIGpR+Pg7hw17h1dQsiGNBjPz8
	uHCddrO9DXRMSbZGRtmA+8o=
X-Google-Smtp-Source: ACHHUZ5R03KIaO9Q7GASKfnUPFs+WRsJ0R8mfBEjEWdSGFS3LyWCLImmP9D50eAryT5IDuKFRWQgBg==
X-Received: by 2002:aa7:d70b:0:b0:514:8d88:7b70 with SMTP id t11-20020aa7d70b000000b005148d887b70mr6329448edq.6.1686652465150;
        Tue, 13 Jun 2023 03:34:25 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id k10-20020a056402048a00b005149e012658sm6253072edv.34.2023.06.13.03.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 03:34:24 -0700 (PDT)
Date: Tue, 13 Jun 2023 13:34:22 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, cai.huoqing@linux.dev, brgl@bgdev.pl,
	chenhao288@hisilicon.com, huangguangbin2@huawei.com,
	David Thompson <davthompson@nvidia.com>
Subject: Re: [PATCH net v2 1/1] mlxbf_gige: Fix kernel panic at shutdown
Message-ID: <20230613103422.ppjeigcugva4gnks@skbuf>
References: <20230612123718.u6cfggybbtx4owbq@skbuf>
 <20230612131707.GS12152@unreal>
 <20230612132841.xcrlmfhzhu5qazgk@skbuf>
 <20230612133853.GT12152@unreal>
 <20230612140521.tzhgliaok5u3q67o@skbuf>
 <20230613071959.GU12152@unreal>
 <20230613083002.pjzsno2tzbewej7o@skbuf>
 <20230613090920.GW12152@unreal>
 <20230613093501.46x4rvyhhyx5wo3b@skbuf>
 <20230613101038.GY12152@unreal>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613101038.GY12152@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 01:10:38PM +0300, Leon Romanovsky wrote:
> On Tue, Jun 13, 2023 at 12:35:01PM +0300, Vladimir Oltean wrote:
> > Not really sure where you're aiming with your replies at this stage.
> 
> My goal is to explain that "bus drivers may implement .shutdown() 
> the same way as .remove()" is wrong implementation and expectation
> that all drivers will add "if (!priv) return ..." now is not viable.

I never said that all drivers should guard against that - just that it's
possible and that there is no mechanism to reject such a thing - which
is something you've incorrectly claimed.

The top-level platform bus for MMIO devices should not be do this, at
least as of now - so drivers written for just that should be fine.
However, platform devices created and probed by other drivers, such as
MFD, are worth double-checking.

