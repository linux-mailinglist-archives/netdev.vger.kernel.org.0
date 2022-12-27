Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC4D656DE8
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 19:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiL0SWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 13:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiL0SWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 13:22:50 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A087A479;
        Tue, 27 Dec 2022 10:22:48 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 82so9273210pgc.0;
        Tue, 27 Dec 2022 10:22:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J8ot+Jdx+D59AwrGMZTmiCuGz/IhA+F0yQn6+KVt1YQ=;
        b=HyF6cB0mWZ2TSlFW9mAKovRNLXijf3as7pmAi1V95kZSIyWvvBplRhJlE4VVPyNqX7
         qtCoQU5sWSbILGXI6CBflgv7SX3FFmM1aVK44WsidwxsaQxJjKX8nTjsZe4rr8Wy++rm
         nsmuo/2u41S5tYXqYUnEjPhSKMNE/H6UPEyhWJ3+ieuKz20OkVevhpXLdPxu8gCC3wmW
         nKqdI9MgcKwM6ogbznoCSdmDpaA/EDby71Hq2Rj2fNXUnWiulVxbXeeycVzt4fXpS4On
         mkYQJoppWDprkpa4Mow+zxHc8zsSaEeO3afXfD0uNU/uVXgMkqrNIUbWJn4bvdAUBuOi
         Ihdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J8ot+Jdx+D59AwrGMZTmiCuGz/IhA+F0yQn6+KVt1YQ=;
        b=VtWDaM73RIINM+NP5tY2J/A4aYNOmI/PWe7uvidCQQvQPYMj1o4SOBPmUTFaOoHliO
         ZnEHjPqbH/PKXUvLKHN1pluYVgVSzwwilw6b0xRWa/nyfLuU8mO+taNTvAQpJNaYEKd8
         OzGprd4LgVsVthLMQtFjheIkBTgADuYSKQrJ5wpPBhLDjk2VpmqZAgJ4gXzeaKCfYuHe
         rVqqKidLg4v+0FcgETft6feSMF8ErQ6OwDwCXdI/qGAqE5NZOmUThk5c7hsCOsogpGnF
         H+dJcs8TIJWQW7LxgX5GbXF/s2wwPCRZohqdZyTKorLnJWyVyTrNFweh6uG5xY/o0fZM
         g2qQ==
X-Gm-Message-State: AFqh2krtgEYYF6t7VdXIH8kzvsVc04557A5hNFeB7HNGQISSyPKkMwEq
        04Vdi0tp3pYm42vktnfxvKc=
X-Google-Smtp-Source: AMrXdXtBYXeAiheD48UtMezozvp/2x4UPN1YxCG7e0vQs3SR1QOOAfCAzUkW6dNPh8BlKMBeCsux2Q==
X-Received: by 2002:a05:6a00:3217:b0:580:ffa0:bfcf with SMTP id bm23-20020a056a00321700b00580ffa0bfcfmr10572108pfb.6.1672165367602;
        Tue, 27 Dec 2022 10:22:47 -0800 (PST)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:400::5:68a7])
        by smtp.gmail.com with ESMTPSA id z7-20020a623307000000b00576d4d69909sm8886485pfz.8.2022.12.27.10.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 10:22:47 -0800 (PST)
Date:   Tue, 27 Dec 2022 10:22:42 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Quentin Deslandes <qde@naccy.de>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Dmitrii Banshchikov <me@ubique.spb.ru>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        Kernel Team <kernel-team@meta.com>, fw@strlen.de
Subject: Re: [PATCH bpf-next v3 00/16] bpfilter
Message-ID: <20221227182242.ozkc6u2lbwneoi4r@macbook-pro-6.dhcp.thefacebook.com>
References: <20221224000402.476079-1-qde@naccy.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221224000402.476079-1-qde@naccy.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 24, 2022 at 01:03:46AM +0100, Quentin Deslandes wrote:
> 
> Due to poor hardware availability on my side, I've not been able to
> benchmark those changes. I plan to get some numbers for the next iteration.

Yeah. Performance numbers would be my main question :)

> FORWARD filter chain is now supported, however, it's attached to
> TC INGRESS along with INPUT filter chain. This is due to XDP not supporting
> multiple programs to be attached. I could generate a single program
> out of both INPUT and FORWARD chains, but that would prevent another
> BPF program to be attached to the interface anyway. If a solution
> exists to attach both those programs to XDP while allowing for other
> programs to be attached, it requires more investigation. In the meantime,
> INPUT and FORWARD filtering is supported using TC.

I think we can ignore XDP chaining for now assuming that Daniel's bpf_link-tc work
will be applicable to XDP as well, so we'll have a simple chaining
for XDP eventually.

As far as attaching to TC... I think it would be great to combine bpfilter
codegen and attach to Florian's bpf hooks exactly at netfilter.
See
https://git.breakpoint.cc/cgit/fw/nf-next.git/commit/?h=nf_hook_jit_bpf_29&id=0c1ec06503cb8a142d3ad9f760b72d94ea0091fa
With nf_hook_ingress() calling either into classic iptable or into bpf_prog_run_nf
which is either generated by Florian's optimizer of nf chains or into
bpfilter generated code would be ideal.
