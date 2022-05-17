Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131A952A76D
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 17:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350675AbiEQPyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 11:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350662AbiEQPyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 11:54:02 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62D950B26;
        Tue, 17 May 2022 08:53:54 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 137so17293266pgb.5;
        Tue, 17 May 2022 08:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rmBZXjHGe6pjrZrcbSckkH/iPjlINFANkKf9gszWPYU=;
        b=mCL2WZQfUMWu4xy6yy7X1+ebSif5rAu/jKymgNsJYYzZFnA9ugCrwiihsPYjvzThIU
         DFn5Lk91C0tZGoeUNkgplThRXBMayt2xcmaeF/kI+0KvGVR+kIISN5RmRdDJqe7Oadm+
         ApJfECbPyywghswoV+jBSpOdkrBps9EXktTRVf3Url5a8fO/0L7wfegdHmd2rnO/VKqr
         5aIFJRbhhBTCl8CG9Fz4O9HHJKwwrK9Rxg2vuvpaHSd9SFQ95LPDBKs/Xs2D02Uy/oXT
         ZFn7YQQsYYxadnuLDDRi0dvdKAfQu/UzUbSJrsKeXA9Nrm8fbp9Bp3m1fdX1C87JU/JQ
         FXxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rmBZXjHGe6pjrZrcbSckkH/iPjlINFANkKf9gszWPYU=;
        b=Ib3dDUlTM04ry+BsbBJCGicKyfD0/9WIB+k0j8S6lgvmCrayRA2OM/3KYcnpChQHEa
         YHGfzKJpQtQXXyWQlFXSCjnZOUVRV5qVeVqfERpxWHgm+3PqUfnhgt1SwnfYLoZKPh0Z
         RSQOSYxo2Q5qO7xOHRKvsdOD/HjG46gWHysagO571KmfEWVkVA6zBf+TgVSw6CX0YF+L
         QztLEkEaBOsZGsi5N7WMW7ixsMCoWMeyK1E4RrbNXpi+Ucb9F3Wqfqpq3dTdHhMfdnOw
         LFC/Auv2sMTNW8+jV0Hrid8yRvHxMqj1/1oPNo5pNyk52iMC611MEgxS5TjxT+H32dht
         iTsQ==
X-Gm-Message-State: AOAM530j5FON1Djz9qZ5xcdpYGD1PkNHYtIYQpBTuyFwixC/CdWCkh77
        HQ83wXMvDO4/v0SbDbDPquk=
X-Google-Smtp-Source: ABdhPJxrXCSmhatJuzbkg3Oy+emIhom0t5nAYkNpvRG00a6Wimvdurd952Xq+8TaFxwV35QJJRu07A==
X-Received: by 2002:a63:8442:0:b0:3c6:4271:cad with SMTP id k63-20020a638442000000b003c642710cadmr20242021pgd.275.1652802834212;
        Tue, 17 May 2022 08:53:54 -0700 (PDT)
Received: from MacBook-Pro.local ([2620:10d:c090:500::2:c22a])
        by smtp.gmail.com with ESMTPSA id d14-20020a62f80e000000b0050dc76281fdsm6932pfh.215.2022.05.17.08.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 08:53:53 -0700 (PDT)
Date:   Tue, 17 May 2022 08:53:49 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        hpa@zytor.com, Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Mark Brown <broonie@kernel.org>,
        Delyan Kratunov <delyank@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH bpf-next v4 3/6] bpf: Move is_valid_bpf_tramp_flags() to
 the public trampoline code
Message-ID: <20220517155349.4jk5oymnjvrasw2p@MacBook-Pro.local>
References: <20220517071838.3366093-1-xukuohai@huawei.com>
 <20220517071838.3366093-4-xukuohai@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517071838.3366093-4-xukuohai@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 03:18:35AM -0400, Xu Kuohai wrote:
>  
> +static bool is_valid_bpf_tramp_flags(unsigned int flags)
> +{
> +	if ((flags & BPF_TRAMP_F_RESTORE_REGS) &&
> +	    (flags & BPF_TRAMP_F_SKIP_FRAME))
> +		return false;
> +
> +	/* BPF_TRAMP_F_RET_FENTRY_RET is only used by bpf_struct_ops,
> +	 * and it must be used alone.
> +	 */
> +	if ((flags & BPF_TRAMP_F_RET_FENTRY_RET) &&
> +	    (flags & ~BPF_TRAMP_F_RET_FENTRY_RET))
> +		return false;
> +
> +	return true;
> +}
> +
> +int bpf_prepare_trampoline(struct bpf_tramp_image *tr, void *image,
> +			   void *image_end, const struct btf_func_model *m,
> +			   u32 flags, struct bpf_tramp_links *tlinks,
> +			   void *orig_call)
> +{
> +	if (!is_valid_bpf_tramp_flags(flags))
> +		return -EINVAL;
> +
> +	return arch_prepare_bpf_trampoline(tr, image, image_end, m, flags,
> +					   tlinks, orig_call);
> +}

It's an overkill to introduce a new helper function just to validate
flags that almost compile time constants.
The flags are not user supplied.
Please move /* BPF_TRAMP_F_RET_FENTRY_RET is only used by bpf_struct_ops ... */
comment to bpf_struct_ops.c right before it calls arch_prepare_bpf_trampoline()
And add a comment to trampoline.c saying that BPF_TRAMP_F_RESTORE_REGS
and BPF_TRAMP_F_SKIP_FRAME should not be set together.
We could add a warn_on there or in arch code, but feels like overkill.
