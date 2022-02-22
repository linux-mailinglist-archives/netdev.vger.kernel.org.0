Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C564C04CE
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 23:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236122AbiBVWmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 17:42:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234378AbiBVWmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 17:42:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52190369C3;
        Tue, 22 Feb 2022 14:42:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5CF5B81CD6;
        Tue, 22 Feb 2022 22:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745F1C340E8;
        Tue, 22 Feb 2022 22:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645569738;
        bh=rMgMgokrpk6FyD3WBiWGdnS0QFcCr1VmoAyHyOWoV2E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QbK2ugHOeYZURrVKV3NEbaq7GOKHKgTqhfqJJW0hUP3kRasUFFC2QkH1YWedDBiUJ
         JVNRGYHLWzXYD+bxkGqP7jofYNnPSlyeBNX4c27EHnbI3i2yndwEM2+uk9Wrh0dY+c
         kqH5DLAu2jmrLJczyEHhLyTeHCcfiPRCNoXpYeISfB4AH3D3OJExXka7XfklJIRmod
         dVSRhZjAViuZJvhWqbNCEdEdgsgy8Q/K0SiMm0cWxyCt8IdnMKwceSlluRnHM+DJVm
         W4AKs9QShzKaiDzM8y7MJHNOpWXoUBA1q/Wdfja/fmC+tcwM9gb31kyQ5rpiLtISTr
         z7EyWz4PQqpYg==
Date:   Tue, 22 Feb 2022 22:42:11 +0000
From:   Will Deacon <will@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>, Hou Tao <houtao1@huawei.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Jakub Kicinski <kuba@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>, netdev@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH bpf-next v4 0/4] bpf, arm64: support more atomic ops
Message-ID: <20220222224211.GB16976@willie-the-truck>
References: <20220217072232.1186625-1-houtao1@huawei.com>
 <164556514968.1490345.10884104309048795776.b4-ty@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164556514968.1490345.10884104309048795776.b4-ty@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 10:38:02PM +0000, Will Deacon wrote:
> On Thu, 17 Feb 2022 15:22:28 +0800, Hou Tao wrote:
> > Atomics support in bpf has already been done by "Atomics for eBPF"
> > patch series [1], but it only adds support for x86, and this patchset
> > adds support for arm64.
> > 
> > Patch #1 & patch #2 are arm64 related. Patch #1 moves the common used
> > macro AARCH64_BREAK_FAULT into insn-def.h for insn.h. Patch #2 adds
> > necessary encoder helpers for atomic operations.
> > 
> > [...]
> 
> Applied to arm64 (for-next/insn), thanks!
> 
> [1/4] arm64: move AARCH64_BREAK_FAULT into insn-def.h
>       https://git.kernel.org/arm64/c/97e58e395e9c
> [2/4] arm64: insn: add encoders for atomic operations
>       https://git.kernel.org/arm64/c/fa1114d9eba5

Daniel -- let's give this a day or so in -next, then if nothing catches
fire you're more than welcome to pull this branch as a base for the rest
of the series.

Cheers,

Will
