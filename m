Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3D94C04BE
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 23:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbiBVWil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 17:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234535AbiBVWik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 17:38:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4C7123400;
        Tue, 22 Feb 2022 14:38:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0570260A2B;
        Tue, 22 Feb 2022 22:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B940C340F1;
        Tue, 22 Feb 2022 22:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645569493;
        bh=eznyyFPWZsjRNoz+3ocqrHVP65LBVpsg/41+l5g3tmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+cVumIwyedmsw9roq+HPnEHoOcsX35w7kNR1b0KwEMvYlxc75U0S0h8I0HqeUhWd
         04j7vhjALMig4mkYWdCW0zH3CmRDY6T0qUrjqeKZfSOE3XOo6Rrt1iFiiYYYC9HZoy
         w27Nust3sbVqPqpxDbOHdJe+gpfwnAcwLdYyeDOa8bFKuJ7BFgwEnVtJkJRoB5g/lZ
         Ogtlx3acN2PPj5fBp2owLTF9VeQJ1U4b/Xhy+f8qWb2SxpnQHDEzVZRloyHq1yyoJ2
         xTVS9tyGgeCdaVCbzbVjHEYRlWuIOL8R6LFRIJUkFpy5EXmbX3yMFYLEQ85y1azKnM
         YnPUi8JuLRGGA==
From:   Will Deacon <will@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>, Hou Tao <houtao1@huawei.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>,
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
Date:   Tue, 22 Feb 2022 22:38:02 +0000
Message-Id: <164556514968.1490345.10884104309048795776.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220217072232.1186625-1-houtao1@huawei.com>
References: <20220217072232.1186625-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Feb 2022 15:22:28 +0800, Hou Tao wrote:
> Atomics support in bpf has already been done by "Atomics for eBPF"
> patch series [1], but it only adds support for x86, and this patchset
> adds support for arm64.
> 
> Patch #1 & patch #2 are arm64 related. Patch #1 moves the common used
> macro AARCH64_BREAK_FAULT into insn-def.h for insn.h. Patch #2 adds
> necessary encoder helpers for atomic operations.
> 
> [...]

Applied to arm64 (for-next/insn), thanks!

[1/4] arm64: move AARCH64_BREAK_FAULT into insn-def.h
      https://git.kernel.org/arm64/c/97e58e395e9c
[2/4] arm64: insn: add encoders for atomic operations
      https://git.kernel.org/arm64/c/fa1114d9eba5
[3/4] bpf, arm64: support more atomic operations
      (no commit info)
[4/4] selftests/bpf: use raw_tp program for atomic test
      (no commit info)

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
