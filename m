Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E8D104590
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 22:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKTVOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 16:14:44 -0500
Received: from mail-pl1-f182.google.com ([209.85.214.182]:46915 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbfKTVOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 16:14:44 -0500
Received: by mail-pl1-f182.google.com with SMTP id l4so368792plt.13;
        Wed, 20 Nov 2019 13:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=COG6DsnVNaOCHNRSDnl2L5H5v9MU63f0nM97Eh//R+0=;
        b=d9l64wJLH4HdFyihtUjfnM3PPh8wd7lr52K+STdPVwsLLdNHra7/qPKoB7gayVfbiW
         Mrd0jWJy2Ib63MPpkNLCW0gDs8Ji3ygPPCEhu/P9ZSDnGrinxvkb0eGInf1hhZ1gWRNo
         vWx/uPKZ7VZKOTp1Px2jBB0aqzfPQGPxel0AOoiyycnxC5LXiMS+GQT8VKerXDSg/vRM
         6c/ZR8kvaz+Pf+dHMS68F8+bGyL/nAGIu2CuY5WwW57KdaUSvT80FsqUzbYU8aF0B2xD
         WAa/d995oCRBznCxSldddYWxbWX6MuOaVQZCT5tMdIMmpo5ucqhWs4ACAVHJAyPU9RdB
         oSGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=COG6DsnVNaOCHNRSDnl2L5H5v9MU63f0nM97Eh//R+0=;
        b=iPrtbJSdZKuR4RULmqcm1hVgG0rrJckNxwHL4WGt81G6FP/xKmRi3Dz4zyBws/VoHX
         f1mTyQzBRBBc64L876tAKTHsEU+BULEx8rKDhg3nkqbfE+m2L2OAi5Qw73IaoiisLi3l
         zBPfyA49WzgBBmXFycISu8v8MRrUsdIsWNI1IojQ7qgX244gE3KpZNZZJbrIGqk/QKIB
         HQzYI2/lbj32JhKnVZyyM28JcnTqtR60OfyZMEz75Ro7zGhUFegppokVRPkU00cTsHMo
         WKNnYMpopF+1l4MYPthDi0axu8H27qQ76hzRScjwK5SYnNPIFyGtQiHQyFQKyrgZvEz3
         6j9Q==
X-Gm-Message-State: APjAAAWO4jCqou1dJxz7hC2rYMCDXdMGZNZbtMvVmnEFyW3wKGj69nEr
        n5/+egg5nqcKqctjXYsyZjU=
X-Google-Smtp-Source: APXvYqwdDfPc5ff8hEQnEmXi7bvCs1Uv1wYI42MSFTvzRwKf/IyG6VIfEiQqj/v0GzsGxtgq7abmcw==
X-Received: by 2002:a17:902:8690:: with SMTP id g16mr5250716plo.194.1574284483369;
        Wed, 20 Nov 2019 13:14:43 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:9773])
        by smtp.gmail.com with ESMTPSA id r16sm135220pgl.77.2019.11.20.13.14.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Nov 2019 13:14:42 -0800 (PST)
Date:   Wed, 20 Nov 2019 13:14:40 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Miller <davem@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
Subject: Re: [RFC] bpf: emit audit messages upon successful prog load and
 unload
Message-ID: <20191120211438.x5dn2ns755bv3q63@ast-mbp.dhcp.thefacebook.com>
References: <20191120143810.8852-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120143810.8852-1-jolsa@kernel.org>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 03:38:10PM +0100, Jiri Olsa wrote:
> 
> The only info really needed from BPF side is the globally unique
> prog ID where then audit user space tooling can query / dump all
> info needed about the specific BPF program right upon load event
> and enrich the record, thus these changes needed here can be kept
> small and non-intrusive to the core.

...

> +static void bpf_audit_prog(const struct bpf_prog *prog, enum bpf_event event)
> +{
> +	bool has_task_context = event == BPF_EVENT_LOAD;
> +	struct audit_buffer *ab;
> +
> +	if (audit_enabled == AUDIT_OFF)
> +		return;
> +	ab = audit_log_start(audit_context(), GFP_ATOMIC, AUDIT_BPF);
> +	if (unlikely(!ab))
> +		return;
> +	if (has_task_context)
> +		audit_log_task(ab);
> +	audit_log_format(ab, "%sprog-id=%u event=%s",
> +			 has_task_context ? " " : "",
> +			 prog->aux->id, bpf_event_audit_str[event]);
> +	audit_log_end(ab);

Single prog ID is enough for perf_event based framework to track everything
about the programs and should be enough for audit.
Could you please resend as proper patch with explicit 'From:' ?
Since I'm not sure what is the proper authorship of the patch.. Daniel's or yours.

