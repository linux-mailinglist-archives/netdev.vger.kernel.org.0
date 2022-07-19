Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39FF057A69C
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 20:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiGSShw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 14:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235311AbiGSShu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 14:37:50 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CBF4D832;
        Tue, 19 Jul 2022 11:37:49 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id c3so13465063pfb.13;
        Tue, 19 Jul 2022 11:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wJ5Ojd6kShb79O9mahIFggm0V7bnmYUCaYihQuOlx0s=;
        b=FpMZ70NauUPMpfgQmItV9B90OGWaHQsY2HLseqWTlLaWajPpT6v4f+kMTdMhbAHEca
         GPm11Zq/deIN5Peuvwr9o47o0zRCnHVMwI+AZjEsg35DaeLIu+Rhq0O8O4Qvs3hjGieT
         qeTAwEU4PNmQn+5vCyVBMFgZf92Xy98/lXd6gjC8/fSl9idr4tvJcSDIrjBCs01LkW3i
         y75FU/AwVspg9K54QrdDDV7TpgtUALZWGplZwK2b3RLwKo+gj+BQ1Ktc5y5N/SE+Sw6w
         w8Em0XzSHJzMBnzfQaD69z7Ux4VpxBKXm/Vbb9Yng1lk1N55SnBzi1Q6sFMsG6sxmO6g
         Vyag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wJ5Ojd6kShb79O9mahIFggm0V7bnmYUCaYihQuOlx0s=;
        b=5cCSKmGwggeYaay27o7DYQMnjGk10hQrG/0I5eqPNFrqNvcBwgLx9gPHcSj8ErZT9I
         jjejemMEPH2O09Pz6QYrXwNm/T66ANoFxWLLp3ZKDRzGil249JuZd4Jv/L+ZU12tLA/J
         elF+EtLxbNs0LWl6Ob7MDmfVoiIgqCaWwxB+etbW+UsRpW14DUQMlMO7gIFpLVYI26Rm
         g5k+Ml3GNcCMpbWYAr0fEdcEpQIGNNnJLmJ/3KrKL98TxKHTZroxwERMW6GoqYprLyf6
         WdxGC5t+U01VToGmX8OV6EtbfkHkptljDxEqmkRuqM/9VQ7dWyRO3oiHwb8HGH0NpFIZ
         Jr1g==
X-Gm-Message-State: AJIora9Ixr2r1CS/Q6KNE/PhFbtRPO2NTdGDTjorLKc7Tic/npCvkmk5
        BT8J3QA4bpTeEDEhkqSD52jwkGHo3lQ=
X-Google-Smtp-Source: AGRyM1uqPxX4R64vBZ0PZOQRY4f/yJyDgiD+Gxu5WENAvfeZJN2S9JvQNz64HK+j1ZtDzgGy2GcdMg==
X-Received: by 2002:a63:1a4c:0:b0:416:1821:733d with SMTP id a12-20020a631a4c000000b004161821733dmr30128624pgm.444.1658255868680;
        Tue, 19 Jul 2022 11:37:48 -0700 (PDT)
Received: from MacBook-Pro-3.local ([2620:10d:c090:500::1:8aa3])
        by smtp.gmail.com with ESMTPSA id x89-20020a17090a6c6200b001e2f892b352sm13979540pjj.45.2022.07.19.11.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 11:37:48 -0700 (PDT)
Date:   Tue, 19 Jul 2022 11:37:45 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH bpf-next v6 01/13] bpf: Introduce BTF ID flags and 8-byte
 BTF set
Message-ID: <20220719183745.4ojhwpuo7ookjvvk@MacBook-Pro-3.local>
References: <20220719132430.19993-1-memxor@gmail.com>
 <20220719132430.19993-2-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719132430.19993-2-memxor@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 03:24:18PM +0200, Kumar Kartikeya Dwivedi wrote:
>  
> +#define ____BTF_ID_FLAGS_LIST(_0, _1, _2, _3, _4, _5, N, ...) _1##_##_2##_##_3##_##_4##_##_5##__
> +#define __BTF_ID_FLAGS_LIST(...) ____BTF_ID_FLAGS_LIST(0x0, ##__VA_ARGS__, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
> +
> +#define __FLAGS(prefix, ...) \
> +	__PASTE(prefix, __BTF_ID_FLAGS_LIST(__VA_ARGS__))
> +
> +#define BTF_ID_FLAGS(prefix, name, ...) \
> +	BTF_ID(prefix, name)		\
> +	__BTF_ID(__ID(__FLAGS(__BTF_ID__flags__, ##__VA_ARGS__)))
> +
>  /*
>   * The BTF_ID_LIST macro defines pure (unsorted) list
>   * of BTF IDs, with following layout:
> @@ -145,10 +164,53 @@ asm(							\
>  ".popsection;                                 \n");	\
>  extern struct btf_id_set name;
>  
> +/*
> + * The BTF_SET8_START/END macros pair defines sorted list of
> + * BTF IDs and their flags plus its members count, with the
> + * following layout:
> + *
> + * BTF_SET8_START(list)
> + * BTF_ID_FLAGS(type1, name1, flags...)
> + * BTF_ID_FLAGS(type2, name2, flags...)
> + * BTF_SET8_END(list)
> + *
> + * __BTF_ID__set8__list:
> + * .zero 8
> + * list:
> + * __BTF_ID__type1__name1__3:
> + * .zero 4
> + * __BTF_ID__flags__0x0_0x0_0x0_0x0_0x0__4:
> + * .zero 4

Overall looks great,
but why encode flags into a name?
Why reuse ____BTF_ID for flags and complicate resolve_btfid?
Instead of .zero 4 insert the actual flags as .word ?

The usage will be slightly different.
Instead of:
BTF_ID_FLAGS(func, bpf_get_task_pid, KF_ACQUIRE, KF_RET_NULL)
it will be
BTF_ID_FLAGS(func, bpf_get_task_pid, KF_ACQUIRE | KF_RET_NULL)
