Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8A98B26A
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 10:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbfHMI1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 04:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727777AbfHMI1w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 04:27:52 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CE3820663;
        Tue, 13 Aug 2019 08:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565684871;
        bh=ijpfiLD9sMLgqwaHAQaKtfQ0oW53gq9SgIUsFx/EV8w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QkIvwE5tYT09KkCFtpJwm7HZLlHqi7YtD2t9dHzFHHbudHhT6m3fHElv7f/famL6V
         6RX2sDey0FfjTlcVcY0xV4h11w9BZ4L3bLfmClSBlRNoJ3iznV5dNmefm1i0ut2eGV
         BMQdBYfRU1YgwtqKokZT9Mj2zs7yUdAEeZEiu9ds=
Date:   Tue, 13 Aug 2019 09:27:44 +0100
From:   Will Deacon <will@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     akpm@linux-foundation.org, sedat.dilek@gmail.com,
        jpoimboe@redhat.com, yhs@fb.com, miguel.ojeda.sandonis@gmail.com,
        clang-built-linux@googlegroups.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Enrico Weigelt <info@metux.net>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Allison Randal <allison@lohutok.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 12/16] arm64: prefer __section from compiler_attributes.h
Message-ID: <20190813082744.xmzmm4j675rqiz47@willie-the-truck>
References: <20190812215052.71840-1-ndesaulniers@google.com>
 <20190812215052.71840-12-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812215052.71840-12-ndesaulniers@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nick,

On Mon, Aug 12, 2019 at 02:50:45PM -0700, Nick Desaulniers wrote:
> GCC unescapes escaped string section names while Clang does not. Because
> __section uses the `#` stringification operator for the section name, it
> doesn't need to be escaped.
> 
> This antipattern was found with:
> $ grep -e __section\(\" -e __section__\(\" -r
> 
> Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  arch/arm64/include/asm/cache.h     | 2 +-
>  arch/arm64/kernel/smp_spin_table.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Does this fix a build issue, or is it just cosmetic or do we end up with
duplicate sections or something else?

Happy to route it via arm64, just having trouble working out whether it's
5.3 material!

Will
