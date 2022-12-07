Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37456645301
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 05:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiLGE3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 23:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiLGE3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 23:29:11 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833CC31DEC;
        Tue,  6 Dec 2022 20:29:10 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id y17so15966729plp.3;
        Tue, 06 Dec 2022 20:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=knx8DaVvtyDcuxnveWkSC62UfBFfV/ZPUHXvqeSZbhk=;
        b=qKSRoOkKZvSi03MYpIH21wqK4csKSh7stYYVO+HWa3D5z8nInC/dnzgsX7p3dfdkUZ
         XlgO69svgZECoUEGDv5+u18HKvKvapjaSyrXh+TF7g+2Qq4mwFPlAxjwXBMTtjIEFYcm
         QZSlomcksXTcPzIl52gu3kue++XLSaAr/NZpv5CPnfLWrgi2eRjMRP3AcrjfcqYK4UQ2
         0HjVAp5ica1eQi+UNvmAWz5AySZxVqNLmB57I5Zz+TXKrnvdQONisAyVHFm959F0NhhV
         iUC/fSe80E6lvYRMdPYpl7nyZHDOjzkr8Hf/VaV5YrrMHBMXCsOCQ+14E7gp8yJG1xt0
         HZVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=knx8DaVvtyDcuxnveWkSC62UfBFfV/ZPUHXvqeSZbhk=;
        b=OIFhi7/wGmGTXKMYGxz2CPzxtgeECJqO9hPGWhs2WkCOZn2iC6fYylYTzfNF3oFrFw
         cQTOT9Yo9niVpN+vQ93h3pvcyhfnHYsJKDoY0gp6Uw64LT63uegyQDP3oJttwwwggPOk
         7idlZrimnbkE9SreY04UWscBCGh9hPRPcVltkPA6/ne4BfquUvKEgWPe4q09hjJNMgfx
         1FyyCF3ZExO0Mbz37oMeCvTbYoYLvklfJA69qcOGLeSZ2AEuQpBv7likDQ5a7toyw0QN
         45vNRL0oRZSiiPOrGejHpEX6o0U8YXZOlPwxIQPoLS6UtRy89m7xvvBHvUP2MVONS/+L
         DylQ==
X-Gm-Message-State: ANoB5pljyRciwSnBW4Cit0lp6kvd5BYniEI2GmgtvUAMggsWfgkdOncf
        2Rp7/pNN0+oRz8HAFDS3jv8=
X-Google-Smtp-Source: AA0mqf5JPVFdrLMv51rSvIAapBM/PfRj7vwMyIVEmO8Jl0DmI+bSZurPBn++JyBej4o9IFJ9a7pxyw==
X-Received: by 2002:a05:6a20:9f43:b0:a9:d06b:ef2 with SMTP id ml3-20020a056a209f4300b000a9d06b0ef2mr678003pzb.36.1670387349972;
        Tue, 06 Dec 2022 20:29:09 -0800 (PST)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:400::5:11da])
        by smtp.gmail.com with ESMTPSA id x17-20020aa79ad1000000b005736209dc01sm12424279pfp.47.2022.12.06.20.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 20:29:09 -0800 (PST)
Date:   Tue, 6 Dec 2022 20:29:04 -0800
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
Subject: Re: [PATCH bpf-next v3 03/12] bpf: XDP metadata RX kfuncs
Message-ID: <Y5AWkAYVEBqi5jy3@macbook-pro-6.dhcp.thefacebook.com>
References: <20221206024554.3826186-1-sdf@google.com>
 <20221206024554.3826186-4-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206024554.3826186-4-sdf@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 06:45:45PM -0800, Stanislav Fomichev wrote:
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index fc4e313a4d2e..00951a59ee26 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -15323,6 +15323,24 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
>  		return -EINVAL;
>  	}
>  
> +	*cnt = 0;
> +
> +	if (resolve_prog_type(env->prog) == BPF_PROG_TYPE_XDP) {
> +		if (bpf_prog_is_offloaded(env->prog->aux)) {
> +			verbose(env, "no metadata kfuncs offload\n");
> +			return -EINVAL;
> +		}

If I'm reading this correctly than this error will trigger
for any XDP prog trying to use a kfunc?

I was hoping that BPF CI can prove my point, but it failed to
build your newly added xdp_hw_metadata.c test.
