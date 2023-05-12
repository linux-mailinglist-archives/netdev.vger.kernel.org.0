Return-Path: <netdev+bounces-1987-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 781D26FFE29
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 02:51:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A5911C210F2
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 00:51:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AAF77EF;
	Fri, 12 May 2023 00:51:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1B67EC
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 00:51:52 +0000 (UTC)
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7AE049FA
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 17:51:50 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-645c4a0079dso1176516b3a.1
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 17:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683852710; x=1686444710;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O0aLI/OS1SNFfmuvlbqZGHmmRkm9XLNYQLMdZqfjoeQ=;
        b=a4nx2Hbhp3LbqrOSpVsh4F5ejlyejFP4AKOHDR7qvU/IlBryX4mswGtW/5sZrA+5K6
         BvtHIWET5nnUbNhCQ6E4xWtxl3sydb1DrDJyMo8cloxGe01xADuNMKjnAIfdlOMc+1WH
         AjU27XZHFVlUVcpsPbnh17NXvgB98ivDQNiCqhNsvaRugHAdTpfXisBZCSoIr2fIOkk6
         maXvyRiQWYRBt1uJatrYy7CSrJhrfi+HYJp9KaDdr6edFf8XxBDH1fcBALIB8PTO1RQK
         EAjf67+KRx3+c23RJNP9JpkFrelQI8mG89DFGfN9T33bFOZZN2uJwY7RPDZ61AcHsh8t
         r1Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683852710; x=1686444710;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O0aLI/OS1SNFfmuvlbqZGHmmRkm9XLNYQLMdZqfjoeQ=;
        b=b+0Msvso9nMs9v66afmYYNQ92gX1FhiZQXHNduQR1A9uTmE6S1rgyEz4Xqfvc+wekE
         O5cm9RCs1XsVfVIyscbfAAZy9Yv4jYANrzoFeqzcnn/3U0HHs1yui+Ee7bQN0hRBjYU2
         3eckJ/AlCNLlIEW51HEWGddmd24lPIxt2MlGmNM4Ur5ucBfIk+Jrw+G/nHgC520npwJF
         +p+AAM0ZXkVh19RjxWOBmSGhKQIfJ2VRZ7xH+eJ3okv6StnWNEQ1x2ETwR82CNBXbfLG
         jYJkUZZENTHfxD2+ZET/yfTtPXmqtZOkzF3k5mIukMEsnQsSVctvu6t9hrCjjgs/Rp4W
         z/Hg==
X-Gm-Message-State: AC+VfDy+P1gGMhnKlfcrmRa47JGiP2kIwJ/UVqfdE+5vbVs1ISAyeDKl
	/EBEgNtSOqwxq37l2uXbDsE=
X-Google-Smtp-Source: ACHHUZ7npcWAOmgFroauvM5vR1auXYm8/QcJbXTahpHfe6EZ8Tr2zYQ4tBYbsSSvvfIWaU2jjXD+pA==
X-Received: by 2002:a17:902:cec7:b0:1ac:6153:50b3 with SMTP id d7-20020a170902cec700b001ac615350b3mr23738432plg.5.1683852710048;
        Thu, 11 May 2023 17:51:50 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:e:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id y9-20020a63de49000000b0051b7bcb6162sm5599428pgi.81.2023.05.11.17.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 17:51:49 -0700 (PDT)
Date: Thu, 11 May 2023 17:51:47 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc: netdev@vger.kernel.org, Saeed Mahameed <saeed@kernel.org>,
	Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH net-next 1/9] ptp: Clarify ptp_clock_info .adjphase
 expects an internal servo to be used
Message-ID: <ZF2No6gW3HlzZscV@hoboy.vegasvil.org>
References: <20230510205306.136766-1-rrameshbabu@nvidia.com>
 <20230510205306.136766-2-rrameshbabu@nvidia.com>
 <ZFxOZM9saCVDNIqD@hoboy.vegasvil.org>
 <87ttwizkki.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ttwizkki.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 01:20:45PM -0700, Rahul Rameshbabu wrote:

> If the PHC does not restore the frequency, won't the value cached in the
> ptp stack in the kernel become inaccurate compared to the frequency
> change induced by the '.adjphase' call?

If the HW implements a PI controller, and if it has converged, then
the current frequency will be close to the remote time server's.

> This concern is why I added this
> clause in the documentation. Let me know if my understanding is off with
> regards to this. I think we had a similar conversation on this
> previously in the mailing list.
> 
> https://lore.kernel.org/netdev/Y88L6EPtgvW4tSA+@hoboy.vegasvil.org/

I guess it depends on the HW algorithm and the situation.  But I don't
think there is a "rule" that always gets the best result.

Thanks,
Richard

