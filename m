Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0989C6325EA
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 15:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiKUOdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 09:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbiKUOc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 09:32:56 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E817A12093;
        Mon, 21 Nov 2022 06:32:53 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id cl5so20144931wrb.9;
        Mon, 21 Nov 2022 06:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oMxdVkeJC7Qwe+UUVslk9eQ8uzs6tVkGa4HBt7gnyb4=;
        b=ZOjpOzhQo2ic2GJnJkbCH5xkCL0Sdr8XTsqnc9P1S69AWNxuW8W32NyDAWWIeRCJ7r
         /40w2NhsNbLANSx2XQepOwvXjNZkqof8uynIDVGTElF+zTlFpvMs9Hk1aCiZkw+//hnc
         e/5tazEjfXiQ17cLxZ12U4YIZhleuHgBGpv+sAQgHLa+0kYgpc2Wzp1xuE4t1npC7iMx
         anm/z7kT08j8Bo941QLRZ4D7MuaBPu4P26wEXsH9Pe7NOG+UWnKL+BuJnHRcwFvP2UEj
         mH7bp5SsfQcTZUOEdur0iy25nwlBsbqbev+ykA5TnQeBaOC24DRo86K355Vs1+MKec0t
         Odgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oMxdVkeJC7Qwe+UUVslk9eQ8uzs6tVkGa4HBt7gnyb4=;
        b=w0Is6LSjGMW8c+z6IbwV+QA3VI7vtBPkUaMWwI7GTa6p6fcfgY+pBartOXYrtA55ar
         m1vkufv5Qya8/yKj8M98f/scZW0OCfc6t4kYlA170ZnebU2xOSlZBV/pVf6JJM3MUJ1c
         L5HsAjNc+XBBAHR8P+6NkgULZ+Kf2ZBAGtU4Hl1LAH55EPeKsqDiR9lRHj3gO2PvYC/V
         IWB2eLdaMonmUKqX/myCRnFaKHxMciFtpH8xX+gVP6hUyt7c0t+8F8qNv869njgDGU36
         4miQBAktfbdVzRQzrORjF0uSd5Y6mEFxhz91LTN8rItd9CqtSJLg/dmut3pKhsVy941o
         T/NQ==
X-Gm-Message-State: ANoB5pnDldJtSih/o0WtAIOBXWweJJsmjvwOAreAHFpQQXNJNxb0RQDd
        F7lm3YLqi7enZt/L1UAxUWU=
X-Google-Smtp-Source: AA0mqf76+QGXGrfSvNDhsW0eKQIaujeQqyDpknKfxZrImyFR+63eC+B87mOQlqZFTqTF/e12bEN8ow==
X-Received: by 2002:a5d:6a08:0:b0:241:da26:bddf with SMTP id m8-20020a5d6a08000000b00241da26bddfmr2160381wru.591.1669041172361;
        Mon, 21 Nov 2022 06:32:52 -0800 (PST)
Received: from krava (2001-1ae9-1c2-4c00-726e-c10f-8833-ff22.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:726e:c10f:8833:ff22])
        by smtp.gmail.com with ESMTPSA id z11-20020a05600c0a0b00b003c6f1732f65sm20663146wmp.38.2022.11.21.06.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 06:32:51 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 21 Nov 2022 15:32:49 +0100
To:     Chen Hu <hu1.chen@intel.com>
Cc:     jpoimboe@kernel.org, memxor@gmail.com, bpf@vger.kernel.org,
        Pengfei Xu <pengfei.xu@intel.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH bpf] selftests/bpf: Fix "missing ENDBR" BUG for
 destructor kfunc
Message-ID: <Y3uMEdvKVl7nSrgD@krava>
References: <20221121085113.611504-1-hu1.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121085113.611504-1-hu1.chen@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 12:51:13AM -0800, Chen Hu wrote:
> With CONFIG_X86_KERNEL_IBT enabled, the test_verifier triggers the
> following BUG:
> 
>   traps: Missing ENDBR: bpf_kfunc_call_test_release+0x0/0x30
>   ------------[ cut here ]------------
>   kernel BUG at arch/x86/kernel/traps.c:254!
>   invalid opcode: 0000 [#1] PREEMPT SMP
>   <TASK>
>    asm_exc_control_protection+0x26/0x50
>   RIP: 0010:bpf_kfunc_call_test_release+0x0/0x30
>   Code: 00 48 c7 c7 18 f2 e1 b4 e8 0d ca 8c ff 48 c7 c0 00 f2 e1 b4 c3
> 	0f 1f 44 00 00 66 0f 1f 00 0f 1f 44 00 00 0f 0b 31 c0 c3 66 90
>        <66> 0f 1f 00 0f 1f 44 00 00 48 85 ff 74 13 4c 8d 47 18 b8 ff ff ff
>    bpf_map_free_kptrs+0x2e/0x70
>    array_map_free+0x57/0x140
>    process_one_work+0x194/0x3a0
>    worker_thread+0x54/0x3a0
>    ? rescuer_thread+0x390/0x390
>    kthread+0xe9/0x110
>    ? kthread_complete_and_exit+0x20/0x20
> 
> This is because there are no compile-time references to the destructor
> kfuncs, bpf_kfunc_call_test_release() for example. So objtool marked
> them sealable and ENDBR in the functions were sealed (converted to NOP)
> by apply_ibt_endbr().

nice :) thanks for the fix, some suggestions below

> 
> This fix creates dummy compile-time references to destructor kfuncs so
> ENDBR stay there.
> 
> Signed-off-by: Chen Hu <hu1.chen@intel.com>
> Tested-by: Pengfei Xu <pengfei.xu@intel.com>
> ---
>  include/linux/btf_ids.h | 7 +++++++
>  net/bpf/test_run.c      | 2 ++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
> index 2aea877d644f..6c6b520ea58f 100644
> --- a/include/linux/btf_ids.h
> +++ b/include/linux/btf_ids.h
> @@ -266,4 +266,11 @@ MAX_BTF_TRACING_TYPE,
>  
>  extern u32 btf_tracing_ids[];
>  
> +#if defined(CONFIG_X86_KERNEL_IBT) && !defined(__DISABLE_EXPORTS)
> +#define BTF_IBT_NOSEAL(name)					\
> +	asm(IBT_NOSEAL(#name));
> +#else
> +#define BTF_IBT_NOSEAL(name)
> +#endif /* CONFIG_X86_KERNEL_IBT */

this is not BTF or BTF ID specific, instead should we add some generic macro like:

  FUNC_IBT_NOSEAL(...)

> +
>  #endif
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 13d578ce2a09..465952e5de11 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -1653,6 +1653,8 @@ BTF_ID(struct, prog_test_ref_kfunc)
>  BTF_ID(func, bpf_kfunc_call_test_release)
>  BTF_ID(struct, prog_test_member)
>  BTF_ID(func, bpf_kfunc_call_memb_release)
> +BTF_IBT_NOSEAL(bpf_kfunc_call_test_release)
> +BTF_IBT_NOSEAL(bpf_kfunc_call_memb_release)

same here, it looks like it's part of the list above, I think this would be better
after function body like:

  noinline void bpf_kfunc_call_memb_release(struct prog_test_member *p)
  {
  }
  FUNC_IBT_NOSEAL(bpf_kfunc_call_memb_release)


thanks,
jirka
