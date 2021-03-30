Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD7634E477
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 11:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbhC3JcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 05:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231708AbhC3Jb4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 05:31:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 190F86195D;
        Tue, 30 Mar 2021 09:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617096715;
        bh=BpKzBVeqnwaVwGkM7DZHfqbqAkT3YLrMqWKYlAvZR1M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gvBRyFV/PWB+wQSDwH8nwqBlxgOVa8DUFhq3UF3TVrddNOKU0Wi1QbmuCoA2FI7Q8
         i36qG8lZzYsO7Vx4SsRYdOTSm7Jv6RpaKCSDG1OOvjF+E0tbznAltY7VpbA0BfRRuj
         xV2C6ArN+oJ7+wWyx6RK+6roOUUHmRFc2elS1K6ZAKbCxPwS5XHJRtDOfD1WdaBwMh
         0TDZZxLxDDt3lt+YSRzUy/RWr4Rp0V7C4+SJl5ebjCHr2omWfvKTQGb8AGXmP7sq0V
         l7DVDcThU2qlny0HChdZtRA7RC7kqzHZNHmwwSivcOVD5NiPftTI+NoZ1jt0lw2Axi
         9R7NIlxYjKMag==
Date:   Tue, 30 Mar 2021 10:31:49 +0100
From:   Will Deacon <will@kernel.org>
To:     Jianlin Lv <Jianlin.Lv@arm.com>
Cc:     bpf@vger.kernel.org, zlim.lnx@gmail.com, catalin.marinas@arm.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iecedge@gmail.com
Subject: Re: [PATCH bpf-next] bpf: arm64: Redefine MOV consistent with arch
 insn
Message-ID: <20210330093149.GA5281@willie-the-truck>
References: <20210330074235.525747-1-Jianlin.Lv@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330074235.525747-1-Jianlin.Lv@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 03:42:35PM +0800, Jianlin Lv wrote:
> A64_MOV is currently mapped to Add Instruction. Architecturally MOV
> (register) is an alias of ORR (shifted register) and MOV (to or from SP)
> is an alias of ADD (immediate).
> This patch redefines A64_MOV and uses existing functionality
> aarch64_insn_gen_move_reg() in insn.c to encode MOV (register) instruction.
> For moving between register and stack pointer, rename macro to A64_MOV_SP.

What does this gain us? There's no requirement for a BPF "MOV" to match an
arm64 architectural "MOV", so what's the up-side of aligning them like this?

Cheers,

Will
