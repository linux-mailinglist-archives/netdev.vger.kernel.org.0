Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7CE4B02DD
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbiBJB55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 20:57:57 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233732AbiBJB4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 20:56:13 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535E42AA97;
        Wed,  9 Feb 2022 17:38:03 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id i186so7627270pfe.0;
        Wed, 09 Feb 2022 17:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=R8E1uIi3+8OQz5EH8bcJFCimfA9i/IShFnqKSrhw+jA=;
        b=DnxCQevBUHlaiRVxA8S2V5t0STdyWdb7vCOz1MZmbNfdaAqnQHJ9xL7o+NxwQZJ06i
         U2SgAyQqMZEqsV1VTgBDMGitHbzXmTCFU2jM7T5dvWJf+cz1vtaTFiHww9lItWJo8viM
         pjL7Wat8NcOtWXfcnZc4VWTvjR1Yjqcqd8785aC2FBl5fM6nBe5T6YVrGjNl77Ufw1sM
         ovuNGw5CSdjDbv3qpnqzdHHLUx8bpKJFrb9wJxlbjbhiK9QJi2qvbfttqZ7RBTfnLyKY
         1Z4aUe+PUJ5x6mfyptluFdpoCHQ/oTADlScIwYVDvJNk1+CbnSD49NCZ5IQUqAI6BIi8
         CrXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=R8E1uIi3+8OQz5EH8bcJFCimfA9i/IShFnqKSrhw+jA=;
        b=sX0CFX5sDXuR6ez/wRloDn18Xfz9Pf6IFkVtmoQbC8plg2HlS9l0uXPzRs0eA0xIcC
         LXcMYjafm8VE0KVfOGjRUSl3xm5Vo72FyLXjGGMjXDXygHjyF7CStV+tiqjZw2Gb0fBA
         JYWvxXz+77rFE35mNPbf3i+nDlKu5mgYlc/6fRqvIpOrD5iOQRlZ6akMETSoP9+TzQ8d
         ze0RpzvIBWgAhTumCYx7TXELRT5BR9n4yN4gg+mGXgMljDfV5cEjSBM66BR5rz3upmPd
         YeQDSfkBa5r9/fszXBdkoPyrHIRX/WoeEf3Ht3H8J6aXUAcdKD0HsXaKFAXVr7fPR3+Z
         Q5Aw==
X-Gm-Message-State: AOAM531Z2N8YJHgxCdhn5OWKR2BPUKhvy3Gi8qrtthkIkpOE9HLmEyA+
        +6s/FimfblBqvG5COhjywXkUmQLjlMo=
X-Google-Smtp-Source: ABdhPJy5Fomf6P+kFMcts/ExMC8D+CDsh8XGL9w5xwGkTidzggtLHQyJTHmFq92PBjsNDE0+LNZUeg==
X-Received: by 2002:a63:5166:: with SMTP id r38mr4138254pgl.99.1644455592404;
        Wed, 09 Feb 2022 17:13:12 -0800 (PST)
Received: from [192.168.86.21] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id s14sm21770334pfk.174.2022.02.09.17.13.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 17:13:11 -0800 (PST)
Message-ID: <3d13bcf4-8d20-0f06-5c00-3880b79363af@gmail.com>
Date:   Wed, 9 Feb 2022 17:13:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH bpf-next 2/2] bpf: fix bpf_prog_pack build HPAGE_PMD_SIZE
Content-Language: en-US
To:     Song Liu <song@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kernel-team@fb.com, kernel test robot <lkp@intel.com>
References: <20220208220509.4180389-1-song@kernel.org>
 <20220208220509.4180389-3-song@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220208220509.4180389-3-song@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/8/22 14:05, Song Liu wrote:
> Fix build with CONFIG_TRANSPARENT_HUGEPAGE=n with BPF_PROG_PACK_SIZE as
> PAGE_SIZE.
>
> Fixes: 57631054fae6 ("bpf: Introduce bpf_prog_pack allocator")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>   kernel/bpf/core.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 306aa63fa58e..9519264ab1ee 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -814,7 +814,11 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
>    * allocator. The prog_pack allocator uses HPAGE_PMD_SIZE page (2MB on x86)
>    * to host BPF programs.
>    */
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>   #define BPF_PROG_PACK_SIZE	HPAGE_PMD_SIZE
> +#else
> +#define BPF_PROG_PACK_SIZE	PAGE_SIZE
> +#endif
>   #define BPF_PROG_CHUNK_SHIFT	6
>   #define BPF_PROG_CHUNK_SIZE	(1 << BPF_PROG_CHUNK_SHIFT)
>   #define BPF_PROG_CHUNK_MASK	(~(BPF_PROG_CHUNK_SIZE - 1))

BTW, I do not understand with module_alloc(HPAGE_PMD_SIZE) would 
necessarily allocate a huge page.

I am pretty sure it does not on x86_64 and dual socket host (NUMA)

It seems you need to multiply this by num_online_nodes()  or change the 
way __vmalloc_node_range()

works, because it currently does:

     if (vmap_allow_huge && !(vm_flags & VM_NO_HUGE_VMAP)) {
         unsigned long size_per_node;

         /*
          * Try huge pages. Only try for PAGE_KERNEL allocations,
          * others like modules don't yet expect huge pages in
          * their allocations due to apply_to_page_range not
          * supporting them.
          */

         size_per_node = size;
         if (node == NUMA_NO_NODE)
<*>          size_per_node /= num_online_nodes();
         if (arch_vmap_pmd_supported(prot) && size_per_node >= PMD_SIZE)
             shift = PMD_SHIFT;
         else
             shift = arch_vmap_pte_supported_shift(size_per_node);




