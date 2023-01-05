Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50BD65E7EF
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 10:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbjAEJgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 04:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbjAEJgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 04:36:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7677150F66;
        Thu,  5 Jan 2023 01:36:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12CA861948;
        Thu,  5 Jan 2023 09:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0252BC433EF;
        Thu,  5 Jan 2023 09:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672911401;
        bh=m5deoU/iNE9s4Vf89FWDMooWeaxz9CcPD3sBSp186Jc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=XAIF+O/OJ8hBrx0XzmPtDLuBUKq1L7we5ffh4nU0DiEwdYjDuZac51Wso30jJIXI7
         7UdB+1Up/st73efB6kDy9jSKt8fsIjDDVW1luXjxGQ3tXjnpAZYc4ZwwQqwIW05Q4M
         HhyiOXwyM4MouTVuSouy27QZk/drd+8Mt+sLauqQJLv5veN4qc2oGN/T/hG/UPoesC
         qc4lK6AhHapx5A6VflLx01e6ATIAF1fvVZDoRGsHyPZv4lse8uVPpDZsPQPzfIgfaQ
         qkr/QlxpgTMERkK/4vkOLDFNz0Gs03AYb1ySIb5XUJFd0DpUe7gUpK6NFfw+JSZaoB
         idO9R04j1Pugw==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     tong@infragraf.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.or, loongarch@lists.linux.dev,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org
Cc:     Tonghao Zhang <tong@infragraf.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Hou Tao <houtao1@huawei.com>
Subject: Re: [bpf-next v2] bpf: drop deprecated bpf_jit_enable == 2
In-Reply-To: <20230105030614.26842-1-tong@infragraf.org>
References: <20230105030614.26842-1-tong@infragraf.org>
Date:   Thu, 05 Jan 2023 10:36:38 +0100
Message-ID: <87zgaxqq55.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tong@infragraf.org writes:

> diff --git a/arch/riscv/net/bpf_jit_core.c b/arch/riscv/net/bpf_jit_core.c
> index 737baf8715da..ff168c50d46a 100644
> --- a/arch/riscv/net/bpf_jit_core.c
> +++ b/arch/riscv/net/bpf_jit_core.c
> @@ -151,9 +151,6 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*prog)
>  	}
>  	bpf_jit_build_epilogue(ctx);
>=20=20
> -	if (bpf_jit_enable > 1)
> -		bpf_jit_dump(prog->len, prog_size, pass, ctx->insns);
> -
>  	prog->bpf_func =3D (void *)ctx->insns;
>  	prog->jited =3D 1;
>  	prog->jited_len =3D prog_size;

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org> # RISC-V
