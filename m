Return-Path: <netdev+bounces-134-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C20D6F5581
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 12:00:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3F5E1C20E40
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07043BA55;
	Wed,  3 May 2023 10:00:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE16BA3F
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 10:00:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6FD268B
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 03:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683108037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/6nW/ulj6fgmoP9Hji3Y8JXnyxUQC9ywV4YbenugH1I=;
	b=QMUmp2wq9rEOFMRszGBiIsNkeBeAUlmMB9Bg2xbWTnnw7F0NKSQ7vODggV1wfhQc/pGhEw
	FaaH/3UGMddG60r8w46S0oXWzR69N68Q/kM1wsbG23U2CBHCFWMVwx3+gnXHrmywXeXWS2
	gDjHPokn+OTi0N2cRLwYZZjBfosdSww=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-ADvnQnE1O9qN-6NdavcVhg-1; Wed, 03 May 2023 06:00:35 -0400
X-MC-Unique: ADvnQnE1O9qN-6NdavcVhg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-30635d18e55so765898f8f.2
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 03:00:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683108034; x=1685700034;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/6nW/ulj6fgmoP9Hji3Y8JXnyxUQC9ywV4YbenugH1I=;
        b=TSeyl0QlXLTEBwKO/U7k+ZSlq1gbGMH75Xf4yL4aQu9jiBZK4U3fADgXVKFePgpLom
         V/lMnJhYcAb04Pz7s52liRYKp3YOpKf2NnzwHAwA+J8DiH0XRnl+KxSd4VN6d2NpGqKx
         0IpkOP4cVHRcBNMAVqYbj2pfvcwWNL/WgrSvEc/2eod2YZhDVCQhNFBLNd4Nog7eswMp
         pnv/cUIWGk3YrsbjibHLygKZtJc7ztHudtLjpzcmPTazLL5PXtcHScA//MRVoXGdflFF
         6abkp4a1CWLFg84SBAbA9VQGfJTgn9a1J4ujZVinKFnAOLDpav8YyOjkdpb+nrqI5nrT
         USCA==
X-Gm-Message-State: AC+VfDwrN67aKZUW8ES3fumoh7c9R2OTLnaxOPOh7E6fm3mtzamTHXCb
	N69qExHW81y186Os+3wWzwEe24pTPMan8JoanKvZCUiQnmHI/Xfm4JnGbUCJvXFfIzGf2Kgpi97
	ADcUFAtPWKbcxxweE
X-Received: by 2002:a5d:4f90:0:b0:2f8:f144:a22c with SMTP id d16-20020a5d4f90000000b002f8f144a22cmr14188536wru.62.1683108034790;
        Wed, 03 May 2023 03:00:34 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5sZP/W3eAA1sD5mGDayMPgI7uxdRqkhgoaxqYxdWD5TDfzw7oHq1zZ2xQsVtBHq7cLgK1BLg==
X-Received: by 2002:a5d:4f90:0:b0:2f8:f144:a22c with SMTP id d16-20020a5d4f90000000b002f8f144a22cmr14188495wru.62.1683108034475;
        Wed, 03 May 2023 03:00:34 -0700 (PDT)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id l18-20020a05600012d200b002ceacff44c7sm33457472wrx.83.2023.05.03.03.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 03:00:34 -0700 (PDT)
From: Valentin Schneider <vschneid@redhat.com>
To: Yury Norov <yury.norov@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Saeed Mahameed
 <saeedm@nvidia.com>, Pawel Chmielewski <pawel.chmielewski@intel.com>, Leon
 Romanovsky <leon@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Andy
 Shevchenko <andriy.shevchenko@linux.intel.com>, Rasmus Villemoes
 <linux@rasmusvillemoes.dk>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra
 <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent
 Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben
 Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot
 de Oliveira <bristot@redhat.com>, Tariq Toukan <tariqt@nvidia.com>, Gal
 Pressman <gal@nvidia.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Heiko Carstens <hca@linux.ibm.com>, Barry
 Song <baohua@kernel.org>
Subject: Re: [PATCH v2 0/8] sched/topology: add for_each_numa_cpu() macro
In-Reply-To: <CAAH8bW9SBrFG+gkH2sT4O_tEQaM-bNT2++v0iyjnuf_aME2DNg@mail.gmail.com>
References: <20230430171809.124686-1-yury.norov@gmail.com>
 <xhsmhildak6t0.mognet@vschneid.remote.csb>
 <CAAH8bW9SBrFG+gkH2sT4O_tEQaM-bNT2++v0iyjnuf_aME2DNg@mail.gmail.com>
Date: Wed, 03 May 2023 11:00:32 +0100
Message-ID: <xhsmhfs8dka4f.mognet@vschneid.remote.csb>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 02/05/23 14:58, Yury Norov wrote:
>> LGTM, I ran the tests on a few NUMA topologies and that all seems to behave
>> as expected. Thanks for working on this!
>>
>> Reviewed-by: Valentin Schneider <vschneid@redhat.com>
>
> Thank you Valentin. If you spent time testing the series, why
> don't you add your Tested-by?

Well, I only ran the test_bitmap stuff and checked the output of the
iterator then, I didn't get to test on actual hardware with a mellanox card
:-)

But yeah, I suppose that does count for the rest, so feel free to add to
all patches but #5:

Tested-by: Valentin Schneider <vschneid@redhat.com>


