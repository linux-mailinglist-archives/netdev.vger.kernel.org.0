Return-Path: <netdev+bounces-6851-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2456F71869E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:44:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DD17281565
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45424174D1;
	Wed, 31 May 2023 15:43:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7D8174CF
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:43:55 +0000 (UTC)
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E23B12E;
	Wed, 31 May 2023 08:43:48 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-5689335d2b6so38950167b3.3;
        Wed, 31 May 2023 08:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685547828; x=1688139828;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7KHwUydY+5zoS1848/zD6XL7je/tk9XrUsLE3UP54E8=;
        b=nKeihe+KQntJ2aHbe/LB66GoLLSJjdinttWW5cPlEHIrchO1LZkFH7hO5RGBYnVDh7
         lWZwS4EbpqWQux8cFgmXz+nZdhZRose8bWa82rhReNfmKGgizuxV3FAmmWF9NngprLZC
         aAV/9tpDlaTaJBLWldna5OPEN86vAoNiVLl1ufK3pJ38ZhFbtqbHmp8cx/SPiqwpMn1l
         uQha1sX6IEixqC2rHoc8wXIZLyvnpOB33ae8KwBRzqmGlKVndJrvIIzAoVtuyBD/uA90
         vdazQamE24W/6GiAuYxvqZcWvwWxcup3zXXhw+uP8qGvqqxMwuq4GCKlflUFMaQAD/na
         NjWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685547828; x=1688139828;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KHwUydY+5zoS1848/zD6XL7je/tk9XrUsLE3UP54E8=;
        b=iOYyK0at3OrdfSahhLsO2uGG6sdZcfQvin/Xosb1qrzdXHC0MLY7dLZ+rG5kH1Ox0S
         OvgJAl+wbXgstfufdpMIo0YGEp3rA76Sv60hXErcmSbImfVz5NS7eGySKb3TfjQKznkg
         fohZAHxwnaNvhWKkQKx5JbryLX4fADK1Dvx8DfXPmPk0x1d/aefZXKEkgRgljPNe42g1
         MhKbHbEwKLmkTXBZpZpjpF3XN1YZ9qHNDIJA3SPSJx00rp8lSTqWT4T/Ewme4Pb+gh7q
         ENbT7ata0wgmpvOdV40O0GX8N/SQqXmtE19S8WYvRvGAUfAxiF2AvpmH6VRXc6qJYjrb
         ewyg==
X-Gm-Message-State: AC+VfDw2k5hCAPwQ/C1QFEPDB8AvkBFgQ8p2aNIimjJZSec+1ZxcMT+v
	MN8O7eu6xECrgUG7XLE50wM=
X-Google-Smtp-Source: ACHHUZ7T7XA+lEzMzdwLBHp1uaXoX/tLHf43qXSnLsFppT7I1XsQnulfFw9oacGR57nUycbK+LzjNA==
X-Received: by 2002:a0d:d412:0:b0:55a:5dce:aa19 with SMTP id w18-20020a0dd412000000b0055a5dceaa19mr5139747ywd.51.1685547827699;
        Wed, 31 May 2023 08:43:47 -0700 (PDT)
Received: from localhost (128-092-077-170.biz.spectrum.com. [128.92.77.170])
        by smtp.gmail.com with ESMTPSA id n5-20020a819c45000000b00545a081847fsm5453436ywa.15.2023.05.31.08.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 08:43:47 -0700 (PDT)
Date: Wed, 31 May 2023 08:43:46 -0700
From: Yury Norov <yury.norov@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	Pawel Chmielewski <pawel.chmielewski@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Heiko Carstens <hca@linux.ibm.com>, Barry Song <baohua@kernel.org>
Subject: Re: [PATCH v2 0/8] sched/topology: add for_each_numa_cpu() macro
Message-ID: <ZHdrMiVSrPdM3xGn@yury-ThinkPad>
References: <20230430171809.124686-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230430171809.124686-1-yury.norov@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Apr 30, 2023 at 10:18:01AM -0700, Yury Norov wrote:
> for_each_cpu() is widely used in kernel, and it's beneficial to create
> a NUMA-aware version of the macro.
> 
> Recently added for_each_numa_hop_mask() works, but switching existing
> codebase to it is not an easy process.
> 
> This series adds for_each_numa_cpu(), which is designed to be similar to
> the for_each_cpu(). It allows to convert existing code to NUMA-aware as
> simple as adding a hop iterator variable and passing it inside new macro.
> for_each_numa_cpu() takes care of the rest.

Hi Jakub,

Now that the series reviewed, can you consider taking it in sched
tree?

Thanks,
Yury

