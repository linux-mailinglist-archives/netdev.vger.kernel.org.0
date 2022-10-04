Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F3B5F3B1C
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 04:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiJDCHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 22:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJDCHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 22:07:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8181233E09;
        Mon,  3 Oct 2022 19:07:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C33E161242;
        Tue,  4 Oct 2022 02:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E00C433C1;
        Tue,  4 Oct 2022 02:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664849249;
        bh=GrIeasiJuVaprQD27vGwfGnBfgThFVrHTF2uXis4t5k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GNXl/tSMi1TDSOsQpmWStL3UCrm6D4Dd/txbssqmC5Gf0IakHrHznbq9ThlHkrQFp
         y64qLBQpv5wyhKNkekKc/TSxtlK6Wx/VV1jmevD2r1Ah1A8jdJVbBvlEDBSiNNZUnO
         Q3GxQ8szAOZ8PEbPGgmiUJ2FwaLqhuXAaYibLpTpGBLxkUq36Bh/begA4mPHw1ShTT
         35oC7RyZAx/KS24/3QUQ0cz+XeV1Vf6Zl/WMk26SmuouqMJjeRDvgUdpzTNHt1MbbQ
         a9oRC578VKZTUp4eaUTeRhMKe3Bl7aCB7Rjuu3l+vSBkKYTfYLEdZ0JWiPVYu8ZlaW
         Xlrt2NoKBh9cA==
Date:   Mon, 3 Oct 2022 19:07:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        David Vernet <void@manifault.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: linux-next: manual merge of the net-next tree with the bpf tree
Message-ID: <20221003190727.0921e479@kernel.org>
In-Reply-To: <20221004122428.653bd5cd@canb.auug.org.au>
References: <20221004122428.653bd5cd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Oct 2022 12:24:28 +1100 Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got a conflict in:
> 
>   kernel/bpf/helpers.c
> 
> between commit:
> 
>   8addbfc7b308 ("bpf: Gate dynptr API behind CAP_BPF")
> 
> from the bpf tree and commits:
> 
>   8a67f2de9b1d ("bpf: expose bpf_strtol and bpf_strtoul to all program types")
>   5679ff2f138f ("bpf: Move bpf_loop and bpf_for_each_map_elem under CAP_BPF")
>   205715673844 ("bpf: Add bpf_user_ringbuf_drain() helper")

Thanks! 

Unrelated to the conflict but do you see this when building the latest
by any chance? Is it just me and my poor old gcc 8.5?

vmlinux.o: warning: objtool: ___ksymtab+bpf_dispatcher_xdp_func+0x0: data relocation to !ENDBR: bpf_dispatcher_xdp_func+0x0
vmlinux.o: warning: objtool: bpf_dispatcher_xdp+0xa0: data relocation to !ENDBR: bpf_dispatcher_xdp_func+0x0
