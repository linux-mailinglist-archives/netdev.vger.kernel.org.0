Return-Path: <netdev+bounces-27-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 111F26F4C69
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 23:58:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25557280CEE
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 21:58:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF271AD50;
	Tue,  2 May 2023 21:58:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A187491
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 21:58:29 +0000 (UTC)
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616001704;
	Tue,  2 May 2023 14:58:28 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id 38308e7fff4ca-2ac6f6e159eso2217371fa.0;
        Tue, 02 May 2023 14:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683064706; x=1685656706;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=80TSuEdqOOm6cDgVdKdpN9l/A7aX+5rnJlnIpuVjK3c=;
        b=dV6eiHvnUq2EnE4XrIojbKTDFE4LaLO3hogbiq+UGggNk6lKSSRf/7m/4ocRbuXq0K
         jrBbUTaC73r/COxi36IuXrGrr48gwOrusAOXbwI67iccq9QzH7V5wpdQtTcm/C/GDkNF
         WofF9kIPGfXxo8Bk+22MLKUaZjdz1zgVa+d23mD4De2kxsm95m9Wd4Jbj9KS1wfE1+pH
         YdlkEdJB+S0qlp/KqInkxT80Iltojf2lwUAS53e1SFn20+15IMn5HU0SR5XJ2Wm2330X
         ggSXwjGFqChaCKSYheQcONsHY9qEphWm06K1kgVRn+v5L8fqUvHWSnYKa53kcveNLcj8
         2vFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683064706; x=1685656706;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=80TSuEdqOOm6cDgVdKdpN9l/A7aX+5rnJlnIpuVjK3c=;
        b=Woh2BFKcf9RuRwtUsnnxr/su7piH5vVCwii4pxR3V2ByUmh73UJwf9QGcrypJK1EyX
         HgMQElUqdYnHcwxxW+3VL1GKNIV2dgn/f9xAZ+tYsgL8Rpu4WegslzMM8+2zniX+9BUc
         xj0VHgQA1nenJ5pJ7uzbN9DSl1vM8xAQj2QBS8G6MKXT/fPmLZdDXFR8uAGBfTZTI5Yk
         nb8PlxSb7w5uYZlbFuyZ1jo+iJO11Lbg4Z27ec0qvbiOUg2gGByzu1cbhLnh7i5nASat
         KI6YEl9sXUDGl0IvsLEHkQXgMzFxUmPOHyBI9qsJQ0JJahnAFQ3IFE9T+PhRruy1n5BK
         STOQ==
X-Gm-Message-State: AC+VfDxBDgEZy/jXKLbejZMbo49BvrIs4QG3Yi2vQf1QvTgMaLcJ8rYn
	y7GBKFaONZDAyF4ZiUaMPU3p7cmvM7mXADUXsoCrPM3AJaM=
X-Google-Smtp-Source: ACHHUZ6wVoapTKq4N/FU1cu+N2vv4Zr4TDxQrO79te4N19OoaMp7nBEwQvDIMiKesQH1v4sLSHIv0nLvr5h/V+kHPEY=
X-Received: by 2002:ac2:418f:0:b0:4ed:d542:6f63 with SMTP id
 z15-20020ac2418f000000b004edd5426f63mr320003lfh.11.1683064706389; Tue, 02 May
 2023 14:58:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230430171809.124686-1-yury.norov@gmail.com> <xhsmhildak6t0.mognet@vschneid.remote.csb>
In-Reply-To: <xhsmhildak6t0.mognet@vschneid.remote.csb>
From: Yury Norov <yury.norov@gmail.com>
Date: Tue, 2 May 2023 14:58:15 -0700
Message-ID: <CAAH8bW9SBrFG+gkH2sT4O_tEQaM-bNT2++v0iyjnuf_aME2DNg@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] sched/topology: add for_each_numa_cpu() macro
To: Valentin Schneider <vschneid@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>, 
	Pawel Chmielewski <pawel.chmielewski@intel.com>, Leon Romanovsky <leon@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Heiko Carstens <hca@linux.ibm.com>, 
	Barry Song <baohua@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> LGTM, I ran the tests on a few NUMA topologies and that all seems to behave
> as expected. Thanks for working on this!
>
> Reviewed-by: Valentin Schneider <vschneid@redhat.com>

Thank you Valentin. If you spent time testing the series, why
don't you add your Tested-by?

