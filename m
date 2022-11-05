Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B721C61A672
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 01:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiKEAkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 20:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiKEAkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 20:40:12 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127F02983B;
        Fri,  4 Nov 2022 17:40:11 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m6-20020a17090a5a4600b00212f8dffec9so5903430pji.0;
        Fri, 04 Nov 2022 17:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5UShT6hdueBiRdAV7jVMEI7CsgXCqm/S1eXi9m2GGnc=;
        b=arIslphXQrB8c9btvdBdRAdFgXMzjaIkBLhhffsOcH9DrsQ4T5Jot68rWWlzKH9W6o
         qYc9xywf11IJu04wjguIKyE7/YtsGTig9BNr/yax5WkTzDrX1Vwc1C1beIqizT8ejkj6
         /CNx/wF7WW0E4VOeCW11rFQjZy44sr1Z26cTFQ0Rx/gaIa4ePKtQoHfPPMkiSu1fnNHD
         xvVK+2WWrSd5Qp4vXKz/Ho84htLyPCcoJHUgRqjQr8MAt/X6aWn5yUb41KIa7GotKz+9
         YZawMsOEfM0YIppEIZW5dQoJYvEWaxRzJbYcundDC7iKNmy7CACzlVxfZgn7atNUWuMr
         7z7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5UShT6hdueBiRdAV7jVMEI7CsgXCqm/S1eXi9m2GGnc=;
        b=xHpAUWa2trsQvFKTaO4/JVij/ofRxcWf0yYJgAPs0Ysw9kTtG3MwUWvZh/TpUWlcqA
         26vkYBvR06Qo1g04AKMDZsiUB2IteBpiyb9VHDeIoF3sCqUtzs9+LNh3JuGFHL5t8DPd
         wSfox8p9Yb3yvpAEFT5R4ZJC3SzTNuLlGykQtDY/T0U7Pk5trtpwDMTgGhyfNPJL2cfZ
         H7guhWuikPaz9isK6KiKtitGE2WVKn47C6s50ptnQLnXmkbHyxpsDnjB6ogTXdsf0J5o
         ZpU2MCUDva8JjZRpkte4VCWdfAklx9p/EZaRvxILj4OervGC3iVOR4AgEpLZZkp+Psb8
         56CA==
X-Gm-Message-State: ACrzQf0IDrgsJjNjuw2U+cbdU1ZMQq9mDCsjnwdAttp3jcXFP4/ZwR5e
        G1xsX8SK9uc+rpUFQan4nz8aoRyDeU8=
X-Google-Smtp-Source: AMsMyM4Ca7HMgqKRlFHz9Gpflsx7i84XS07B6VYQhdOaRMU1IpPU6nqmpSrcf1JzMsBqQzDeQXKNZw==
X-Received: by 2002:a17:902:ab8f:b0:185:46d3:8c96 with SMTP id f15-20020a170902ab8f00b0018546d38c96mr39531149plr.136.1667608810381;
        Fri, 04 Nov 2022 17:40:10 -0700 (PDT)
Received: from macbook-pro-5.dhcp.thefacebook.com ([2620:10d:c090:400::5:49d4])
        by smtp.gmail.com with ESMTPSA id x29-20020aa7941d000000b0056bf4f8d542sm203168pfo.74.2022.11.04.17.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 17:40:09 -0700 (PDT)
Date:   Fri, 4 Nov 2022 17:40:05 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [RFC bpf-next v2 08/14] bpf: Helper to simplify calling kernel
 routines from unrolled kfuncs
Message-ID: <20221105004005.pfdsaitg6phb6vxm@macbook-pro-5.dhcp.thefacebook.com>
References: <20221104032532.1615099-1-sdf@google.com>
 <20221104032532.1615099-9-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104032532.1615099-9-sdf@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 08:25:26PM -0700, Stanislav Fomichev wrote:
> When we need to call the kernel function from the unrolled
> kfunc, we have to take extra care: r6-r9 belong to the callee,
> not us, so we can't use these registers to stash our r1.
> 
> We use the same trick we use elsewhere: ask the user
> to provide extra on-stack storage.
> 
> Also, note, the program being called has to receive and
> return the context.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> Cc: Maryam Tahhan <mtahhan@redhat.com>
> Cc: xdp-hints@xdp-project.net
> Cc: netdev@vger.kernel.org
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/net/xdp.h |  4 ++++
>  net/core/xdp.c    | 24 +++++++++++++++++++++++-
>  2 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 8c97c6996172..09c05d1da69c 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -440,10 +440,14 @@ static inline u32 xdp_metadata_kfunc_id(int id)
>  	return xdp_metadata_kfunc_ids.pairs[id].id;
>  }
>  void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch);
> +void xdp_kfunc_call_preserving_r1(struct bpf_patch *patch, size_t r0_offset,
> +				  void *kfunc);
>  #else
>  #define xdp_metadata_magic 0
>  static inline u32 xdp_metadata_kfunc_id(int id) { return 0; }
>  static void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch) { return 0; }
> +static void xdp_kfunc_call_preserving_r1(struct bpf_patch *patch, size_t r0_offset,
> +					 void *kfunc) {}
>  #endif
>  
>  #endif /* __LINUX_NET_XDP_H__ */
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 8204fa05c5e9..16dd7850b9b0 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -737,6 +737,7 @@ BTF_SET8_START_GLOBAL(xdp_metadata_kfunc_ids)
>  XDP_METADATA_KFUNC_xxx
>  #undef XDP_METADATA_KFUNC
>  BTF_SET8_END(xdp_metadata_kfunc_ids)
> +EXPORT_SYMBOL(xdp_metadata_kfunc_ids);
>  
>  /* Make sure userspace doesn't depend on our layout by using
>   * different pseudo-generated magic value.
> @@ -756,7 +757,8 @@ static const struct btf_kfunc_id_set xdp_metadata_kfunc_set = {
>   *
>   * The above also means we _cannot_ easily call any other helper/kfunc
>   * because there is no place for us to preserve our R1 argument;
> - * existing R6-R9 belong to the callee.
> + * existing R6-R9 belong to the callee. For the cases where calling into
> + * the kernel is the only option, see xdp_kfunc_call_preserving_r1.
>   */
>  void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch)
>  {
> @@ -832,6 +834,26 @@ void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *p
>  
>  	bpf_patch_resolve_jmp(patch);
>  }
> +EXPORT_SYMBOL(xdp_metadata_export_to_skb);
> +
> +/* Helper to generate the bytecode that calls the supplied kfunc.
> + * The kfunc has to accept a pointer to the context and return the
> + * same pointer back. The user also has to supply an offset within
> + * the context to store r0.
> + */
> +void xdp_kfunc_call_preserving_r1(struct bpf_patch *patch, size_t r0_offset,
> +				  void *kfunc)
> +{
> +	bpf_patch_append(patch,
> +		/* r0 = kfunc(r1); */
> +		BPF_EMIT_CALL(kfunc),
> +		/* r1 = r0; */
> +		BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
> +		/* r0 = *(r1 + r0_offset); */
> +		BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, r0_offset),
> +	);
> +}
> +EXPORT_SYMBOL(xdp_kfunc_call_preserving_r1);

That's one twisted logic :)
I guess it works for preserving r1, but r2-r5 are gone and r6-r9 cannot be touched.
So it works for the most basic case of returning single value from that additional
kfunc while preserving single r1.
I'm afraid that will be very limiting moving forward.
imo we need push/pop insns. It shouldn't difficult to add to the interpreter and JITs.
Since this patching is done after verificaiton they will be kernel internal insns.
Like we have BPF_REG_AX internal reg.
