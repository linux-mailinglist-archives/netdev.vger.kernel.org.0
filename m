Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12D35803F1
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 20:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235245AbiGYSUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 14:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233651AbiGYSUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 14:20:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCF913F07
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 11:20:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C9EAB810AF
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 18:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E0AC341C6;
        Mon, 25 Jul 2022 18:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658773243;
        bh=1RtMlzoGuJ0QrtrVBSs2qZYDTPuLz/5DP/cFx09AW/s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jzUYAI+oCx/LCH6Ub+gkcriGg4avIN2NbXwVyfLLuoTBf+pY7QHK28XK6guiAp89r
         mGLaCDMz4U7cnijdwRGlppdm9TzkPFqnXzBN0+cjP8ZcrI8jy96RKGpk1YIHwfyWY5
         cLQqBCZQeRZuEg72C/LyF1WQX7X2CCTEEQb93P9HiF9HZtRJeDcxsGQKvo0r9qrByP
         yJGestH3g4XtlOkhS95NtK8p/5j3ZghoaWJX8Cdsakn70/6KZZ2K133hlE22xakskY
         PMA+Ngifn0MOj3yF2vrT7i+JopNPZeRt6xVDxq7qCjYSaPwjuacPhTtt3/L8/clEjK
         HvMxqjhxrKCzw==
Date:   Mon, 25 Jul 2022 11:20:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH net-next V3 0/3] Introduce and use NUMA distance metrics
Message-ID: <20220725112041.79ffe702@kernel.org>
In-Reply-To: <09038324-65ed-8529-2f6c-671a15a8fb84@gmail.com>
References: <20220719162339.23865-1-tariqt@nvidia.com>
        <09038324-65ed-8529-2f6c-671a15a8fb84@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Jul 2022 15:09:11 +0300 Tariq Toukan wrote:
> On 7/19/2022 7:23 PM, Tariq Toukan wrote:
> > Hi,
> > 
> > Implement and expose CPU spread API based on the scheduler's
> > sched_numa_find_closest().  Use it in mlx5 and enic device drivers.  This
> > replaces the binary NUMA preference (local / remote) with an improved one
> > that minds the actual distances, so that remote NUMAs with short distance
> > are preferred over farther ones.
> > 
> > This has significant performance implications when using NUMA-aware
> > memory allocations, improving the throughput and CPU utilization.
>
> Comments on V2 were addressed.
> Please let me now of any other comments on this V3.

Good enough from my POV, just waiting for PeterZ's re-ack since patch 1
has changed.
