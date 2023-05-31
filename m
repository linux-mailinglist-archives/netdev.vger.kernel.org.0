Return-Path: <netdev+bounces-6918-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3D09718A65
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 21:45:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CC2A2815B7
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 19:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CFF234CDF;
	Wed, 31 May 2023 19:45:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40957805
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 19:45:26 +0000 (UTC)
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2F5126
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 12:45:23 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-517bad1b8c5so51001a12.0
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 12:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685562323; x=1688154323;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PpDJlNrnAO4fvUz0RfTCu45Wzom8uht2t6b0Eby6tSU=;
        b=CvwTOcZ+TPBW93dVo+GG+czxQgBJ4WRtQUZ1hKODLz7NuLQPGgy7BYqE7Y9Tdkzjs2
         y9tozNN7oF4sU7BsyHzJbWPgNPvoSqYlMRj7uvKxy2fkxrWhoH/SmrTTamAvlmKzi73n
         W8mGe+0pczU1OXBLkd9m6kH3YhP81peoXSGI7ypFYEQjAIAOGwvke5aVDbsNuxKBxx3g
         MOnvBekiaK0TO9D2/JhS+c/l+b0tzOEqCm96tealv8uLdXS4aRGyO8bnFdb0QJST5yjO
         WtjQXe1h3uwVrRpHfxidaBd5zAxB8fKm6q3xgsTzuj02HlikkhGtotuFCckThw1vLK4o
         eh0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685562323; x=1688154323;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PpDJlNrnAO4fvUz0RfTCu45Wzom8uht2t6b0Eby6tSU=;
        b=PeCg+5KdvKV8gXtpDhJwaGZWdj5icKj9oaeXADgN3w5SrFUG5mFBrU+fwIX11KNBCJ
         Wbv9IjBsuS3cGcbsEgFQ+cStDH38qu6r1EZ4qyc0UHbLidGS2yBmabGqxeNM+yzKv3Gz
         8jru7x+M6me4TPZTEKphyElQWqRVai6gnFAkWRg/41x1VmemX/fV0rOpPLipROTu4Svd
         A0spcuH/t3Ow9FN99OnXozwahvwNeiWEha3U4kLF9r+h8k28lMYcBz+wwaoahoO3nHSI
         ESO4PW7rwQICDduhBnvQIf8hCL1Id864W0frlGWWMfdLDJ+xTXWFEZ9t6EfpojHLTerX
         kjew==
X-Gm-Message-State: AC+VfDytuRXiYv9DRWoAwUHIwHK4EvUnAnC0BxTn0LKT8xcBcXxKQs1D
	5PYkk72VMgsTCO029kkRnFBPpKDbSQqB0A==
X-Google-Smtp-Source: ACHHUZ7EFiKlZ4gS71wAZQDIsRXSnDj9UCINMOrYFP75CVF1jUuIsU9mLwwAaZXYcFWu4QQgX0+DtXdtklf0Dg==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:262e])
 (user=shakeelb job=sendgmr) by 2002:a63:48c:0:b0:53f:a2d1:99d4 with SMTP id
 134-20020a63048c000000b0053fa2d199d4mr1385933pge.1.1685562322852; Wed, 31 May
 2023 12:45:22 -0700 (PDT)
Date: Wed, 31 May 2023 19:45:20 +0000
In-Reply-To: <ZHcJUF4f9VcnyGVt@xsang-OptiPlex-9020>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
 <20230512171702.923725-1-shakeelb@google.com> <CH3PR11MB7345035086C1661BF5352E6EFC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod7n2yHU8PMn5b39w6E+NhLtBynDKfo1GEfXaa64_tqMWQ@mail.gmail.com>
 <CH3PR11MB7345E9EAC5917338F1C357C0FC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod6txDQ9kOHrNFL64XiKxmbVHqMtWNiptUdGt9UuhQVLOQ@mail.gmail.com>
 <ZGMYz+08I62u+Yeu@xsang-OptiPlex-9020> <20230517162447.dztfzmx3hhetfs2q@google.com>
 <ZHcJUF4f9VcnyGVt@xsang-OptiPlex-9020>
Message-ID: <20230531194520.qhvibyyaqg7vwi6s@google.com>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
From: Shakeel Butt <shakeelb@google.com>
To: Oliver Sang <oliver.sang@intel.com>
Cc: Zhang Cathy <cathy.zhang@intel.com>, Yin Fengwei <fengwei.yin@intel.com>, 
	Feng Tang <feng.tang@intel.com>, Eric Dumazet <edumazet@google.com>, Linux MM <linux-mm@kvack.org>, 
	Cgroups <cgroups@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org" <kuba@kernel.org>, 
	Brandeburg Jesse <jesse.brandeburg@intel.com>, Srinivas Suresh <suresh.srinivas@intel.com>, 
	Chen Tim C <tim.c.chen@intel.com>, You Lizhen <lizhen.you@intel.com>, 
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, philip.li@intel.com, 
	yujie.liu@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Oliver,

On Wed, May 31, 2023 at 04:46:08PM +0800, Oliver Sang wrote:
[...]
> 
> we applied below patch upon v6.4-rc2, so far, we didn't spot out performance
> impacts of it to other tests.
> 
> but we found -7.6% regression of netperf.Throughput_Mbps
> 

Thanks, this is what I was looking for. I will dig deeper and decide how
to proceed (i.e. improve this patch or work on long term approach).


