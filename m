Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D97369C39A
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 01:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjBTA0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 19:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjBTA0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 19:26:53 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3E1DBDD;
        Sun, 19 Feb 2023 16:26:42 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id mi8-20020a17090b4b4800b002349579949aso1461464pjb.5;
        Sun, 19 Feb 2023 16:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Aid80AoOgCsKIYJRxx6R1vr764XoE7wsH0DMzj93pss=;
        b=IqACJvhr0i6zNfKHTJ6BvotylZrVYfiF1AziQ+cPMZ/Dukw+C8urjmv6hHyR2mifva
         KH+EZMOgs87tqz7Bav5pjX7DAZI+G/STnl5LvRlNiC4p2lgi3zrMzoEVyOrqvJRtWUSf
         bJw6z+DVanfDkElhowvrVWlHNOdr4r1b1a/EeBsIw1p1dP3kJ9o88IYGUfUcJcOkT9ns
         zRSFa66sUikycVD95JTSMZwDtf9miW4u5NwxueSgh7mG78UpQoU/I85O7wPfiPKCTTcf
         lpiUf6x47PaO2oC8c99y6zR3ewFJFU8mDjUibMvve6Yf0FRdF9UukCmklmsNBjLExMjx
         ytCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Aid80AoOgCsKIYJRxx6R1vr764XoE7wsH0DMzj93pss=;
        b=OhRTKQ1C1HJSKF5N/+csMuu4NTlRb4aSsEfK+HbH1Xx37aUY03QcvZZFyVevVDmsi9
         LyaYIU75kMtSq/GJTSgCuZA7pl+ZCwbvkMcjOcqHcEsteuYY+VswsyyL0x+bcK/Orzcb
         u45SqfzONRKIOox2GGIPB8cqbnZuXrQO+MIM14eATvEYQDZ/uv3iDjsiQ5A0YzeQulcY
         wWP0GxgD9LaO7g756HyFLVpwEkGZ/ZkDlqzpy83OJamZIMTA9+uNtPFtUgNUKU32PSw1
         4JRWCnUKBQN4FC8p5O/jSqvMTsQHVTH9P1GudrxdEtkFu4U6vXPIZRbtJrQKiZoi7gs5
         gBqw==
X-Gm-Message-State: AO0yUKWi1spn982rctZm09YBW8L657iCCtIl5tNZI/1HQOnGDnvX0mDU
        TFw6XwxJKERJujYVfSPc5mceRujSfUY=
X-Google-Smtp-Source: AK7set+pf7457cTW0y7+VZcatqwqZXsAkRdUhZcgSKYc0YtiagY6dsxMHtAPgHzUVvsT/gxGl5ZPoA==
X-Received: by 2002:a17:902:fa83:b0:198:e393:dbf5 with SMTP id lc3-20020a170902fa8300b00198e393dbf5mr1955043plb.22.1676852801421;
        Sun, 19 Feb 2023 16:26:41 -0800 (PST)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:400::5:4542])
        by smtp.gmail.com with ESMTPSA id p23-20020a170902a41700b0018099c9618esm1451849plq.231.2023.02.19.16.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Feb 2023 16:26:40 -0800 (PST)
Date:   Sun, 19 Feb 2023 16:26:37 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf@vger.kernel.org, martin.lau@kernel.org, andrii@kernel.org,
        memxor@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v10 bpf-next 8/9] bpf: Add bpf_dynptr_slice and
 bpf_dynptr_slice_rdwr
Message-ID: <20230220002637.xmmarcm5fxeyiotn@macbook-pro-6.dhcp.thefacebook.com>
References: <20230216225524.1192789-1-joannelkoong@gmail.com>
 <20230216225524.1192789-9-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216225524.1192789-9-joannelkoong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 02:55:23PM -0800, Joanne Koong wrote:
> +
> +/**
> + * bpf_dynptr_slice_rdwr - Obtain a pointer to the dynptr data.
> + *
> + * For non-skb and non-xdp type dynptrs, there is no difference between
> + * bpf_dynptr_slice and bpf_dynptr_data.
> + *
> + * @ptr: The dynptr whose data slice to retrieve
> + * @offset: Offset into the dynptr
> + * @buffer: User-provided buffer to copy contents into
> + * @buffer__sz: Size (in bytes) of the buffer. This is the length of the
> + * requested slice
> + *
> + * @returns: NULL if the call failed (eg invalid dynptr), pointer to a
> + * data slice (can be either direct pointer to the data or a pointer to the user
> + * provided buffer, with its contents containing the data, if unable to obtain
> + * direct pointer)

The doc probably should say that the returned pointer is writeable and
the user must do if (ptr != buffer) bpf_dynptr_write() to reflect the changes.

Maybe document all kfuncs similar to Documentation/bpf/cpumasks.rst ?

Should we also document that bpf_dynptr_slice[_rdwr] do not change skb
configuration and because of that the ctx->data/data_end pointers are not invalidated
by either skb_header_pointer or bpf_xdp_pointer ?

> + */
> +__bpf_kfunc void *bpf_dynptr_slice_rdwr(const struct bpf_dynptr_kern *ptr, u32 offset,
> +					void *buffer, u32 buffer__sz)
> +{
> +	if (!ptr->data || bpf_dynptr_is_rdonly(ptr))
> +		return 0;
> +
> +	/* bpf_dynptr_slice_rdwr is the same logic as bpf_dynptr_slice.
> +	 *
> +	 * For skb-type dynptrs, the verifier has already ensured that the skb
> +	 * head is writable (see bpf_unclone_prologue()).
> +	 */

This is way too terse. It needs much more detailed comment explaining why it's safe
to write into the returned pointer.
For example it's far from obvious that bpf_dynptr_slice()->skb_header_pointer()
returns a pointer to a head or copies into a buffer. _only_. and no other logic.
Without looking into implementation details one could come up with skb_header_pointer()
behavior that returns a pointer to a middle part of a frag if {offset, len} combination allows.
And in such case it will not be safe to write into such pointer.
Because bpf_unclone_prologue() only makes sure that the head is writeable.
One can look at bpf_unclone_prologue() and see that it's doing bpf_skb_pull_data(skb, 0);
But without looking further it's also not at all obvious that arg2 == 0 means
'make head writeable'.

Also 'For skb-type dynptrs, the verifier has already ensured that the skb head is writable'
is partially true.
skb-type dynptrs are available to cgroup-scoped skb hooks and there bpf_dynptr_slice_rdwr()
will always be failing, since bpf_dynptr_is_rdonly() will be true.
It probably will be better user experience if the verifier rejects
bpf_dynptr_slice_rdwr() in hooks where may_access_direct_pkt_data() returns false.

> +	return bpf_dynptr_slice(ptr, offset, buffer, buffer__sz);
> +}
> +
...
> +			} else if (meta.func_id == special_kfunc_list[KF_bpf_dynptr_slice] ||
> +				   meta.func_id == special_kfunc_list[KF_bpf_dynptr_slice_rdwr]) {
> +				enum bpf_type_flag type_flag = get_dynptr_type_flag(meta.initialized_dynptr.type);
> +
> +				mark_reg_known_zero(env, regs, BPF_REG_0);
> +
> +				if (!tnum_is_const(regs[BPF_REG_4].var_off)) {
> +					verbose(env, "mem_size must be a constant\n");
> +					return -EINVAL;
> +				}
> +				regs[BPF_REG_0].mem_size = regs[BPF_REG_4].var_off.value;
> +
> +				/* PTR_MAYBE_NULL will be added when is_kfunc_ret_null is checked */
> +				regs[BPF_REG_0].type = PTR_TO_MEM | type_flag;
> +
> +				if (meta.func_id == special_kfunc_list[KF_bpf_dynptr_slice])
> +					regs[BPF_REG_0].type |= MEM_RDONLY;
> +				else
> +					env->seen_direct_write = true;

This bit kinda makes it that bpf_dynptr_slice_rdwr() will "fail" in cg-skb hook,
but it will do so with:
        if (ops->gen_prologue || env->seen_direct_write) {
                if (!ops->gen_prologue) {
                        verbose(env, "bpf verifier is misconfigured\n");
                        return -EINVAL;
                }

which will confuse users.
