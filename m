Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B41669123D
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 21:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjBIUvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 15:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbjBIUun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 15:50:43 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9760068AEC;
        Thu,  9 Feb 2023 12:50:41 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id p26so10161010ejx.13;
        Thu, 09 Feb 2023 12:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=16FEumpbkgL1MCG/IVXi8cJSa5wU9goiP6cIWmoP7F4=;
        b=Gh9a8uG0WIdgAQFXBDEUSdZ7S1K86OT6H1iU4sahvmhqa55CnTVXKVd8wMt2BTOnj2
         NvcrAzKOhYK9HCHFw97nMkR8AVPfCav6p2EmZ7Mh6fF8AAfqAPp1IcZdWGQ7nrl8Z2qy
         0wHWrIW8WPjK2MqRNi0qeuD+TgJtbm331iwRkx3iIT7sBOijAR3V4nqd7L3WcLMJOlkW
         9gliPZDQpG242NjQRZdu6uWTwh3oS8UxJWi+wyQ1JY8jABZFJYTHNVUXShEqPAfNwS7X
         FeOgnifYuUOKFr6LBcAvKRVCHlhM+GtOc2zr9BzBVfNcJ0+3fp13bKZkYjnHposTO+mN
         R55w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=16FEumpbkgL1MCG/IVXi8cJSa5wU9goiP6cIWmoP7F4=;
        b=Zn5h07SihWGpKcGKRCoIP5ogkfQhmmfyp3oxPVUrKtERAp/gLM7mXgOJz7zdm0vtH2
         Y7QuxfUMByqg6zQq46EWzVszGC8tiWPluJkaJbpjBFcygwFhASoALQ9IL1ZZjtRQQNas
         PZEjQMmHcb5fAk3RZq8Y8OklufKz47j99SrL9wejTR85os5cLMKrsqRwNEVKWW7TO61g
         JuFv+RccUT4gh+XkomfPzZIo0vuig+Nqv/EjdPGz99l6OpJz0BMojSwpuOdTu68/TeFn
         FBr+03MenoNgcA/e/jPNCsEcf5E8sXw2vLzeg2XVTrFpV2eRghwk6+DPFbrSUNbDDb3u
         rJeA==
X-Gm-Message-State: AO0yUKWunjmWleKewH57vEdCIGdC4Inc7P6A532msu9jo8T7ddGwXagq
        nBoqxyHDNSYdOARHMStOB2v3wZ0ynnm++l8Iw8A=
X-Google-Smtp-Source: AK7set+p5mLQGphNYZB7dnhNqdO21SQcEKpkwXk0xEbzZMF4iA+oCC60QJo2PoyrdEwk2ZZkmnVRGCMKWTd9t4QQN1k=
X-Received: by 2002:a17:906:eb8f:b0:878:786e:8c39 with SMTP id
 mh15-20020a170906eb8f00b00878786e8c39mr2906402ejb.105.1675975840025; Thu, 09
 Feb 2023 12:50:40 -0800 (PST)
MIME-Version: 1.0
References: <20230209192337.never.690-kees@kernel.org> <CAEf4BzZXrf48wsTP=2H2gkX6T+MM0B45o0WNswi50DQ_B-WG4Q@mail.gmail.com>
 <63e5521a.170a0220.297d7.3a80@mx.google.com>
In-Reply-To: <63e5521a.170a0220.297d7.3a80@mx.google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 9 Feb 2023 12:50:28 -0800
Message-ID: <CAADnVQKsB2n0=hShYpYnTr5yFYRt5MX2QMWo3V9SB9JrM6GhTg@mail.gmail.com>
Subject: Re: [PATCH] bpf: Deprecate "data" member of bpf_lpm_trie_key
To:     Kees Cook <keescook@chromium.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, Mykola Lysenko <mykolal@fb.com>,
        Shuah Khan <shuah@kernel.org>,
        Haowen Bai <baihaowen@meizu.com>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        clang-built-linux <llvm@lists.linux.dev>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 9, 2023 at 12:05 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Feb 09, 2023 at 11:52:10AM -0800, Andrii Nakryiko wrote:
> > Do we need to add a new type to UAPI at all here? We can make this new
> > struct internal to kernel code (e.g. struct bpf_lpm_trie_key_kern) and
> > point out that it should match the layout of struct bpf_lpm_trie_key.
> > User-space can decide whether to use bpf_lpm_trie_key as-is, or if
> > just to ensure their custom struct has the same layout (I see some
> > internal users at Meta do just this, just make sure that they have
> > __u32 prefixlen as first member).
>
> The uses outside the kernel seemed numerous enough to justify a new UAPI
> struct (samples, selftests, etc). It also paves a single way forward
> when the userspace projects start using modern compiler options (e.g.
> systemd is usually pretty quick to adopt new features).

I don't understand how the new uapi struct bpf_lpm_trie_key_u8 helps.
cilium progs and progs/map_ptr_kern.c
cannot do s/bpf_lpm_trie_key/bpf_lpm_trie_key_u8/.
They will fail to build, so they're stuck with bpf_lpm_trie_key.

Can we do just
struct bpf_lpm_trie_key_kern {
  __u32   prefixlen;
  __u8    data[];
};
and use it in the kernel?
What is the disadvantage?
