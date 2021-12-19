Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD74479ECE
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 03:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbhLSCWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 21:22:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbhLSCWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 21:22:51 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53253C061574;
        Sat, 18 Dec 2021 18:22:51 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id q16so5936158pgq.10;
        Sat, 18 Dec 2021 18:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wg5n0Yt7uV050fu+GfL9PEzo70mKWihTi3le8ja2UPQ=;
        b=d0/6QjI84IU55b1l+o7FaRjMKt2j8rfkG92Mc/CJgxwKxzQrAZocHIFAcsmUT2AcFc
         XPyETFoMyIVmRpta9rNp14dGl+EDiHACNCQgS3y3mvDQNWqmBuRZMYCOVt1OPY/36n/R
         O8GZDPWfN8Mtcwz8nb4AJdbTDffVdLgSvvtza3Y2u+5YlWthMZG8P3RzSbHTBQoX2IvK
         ZgxnMSk61dFq4EPd8cXqxO6/oVBJp/R+JClkAilhb9403pRF8MeK7R8tsVc7tyWZkOjp
         K7deHIJoeB0/gperZxvd+akURyfXhE13bPPERR03g8gNvSG7jHwroBEvsrXY0FlOchC+
         m4bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wg5n0Yt7uV050fu+GfL9PEzo70mKWihTi3le8ja2UPQ=;
        b=57UH4PxDg6f2EjwN/decki3Ffa53cUPL65zvdSd+49VDma8szAUPH24hUlBKWKXwOz
         euAavbeHpfuFSZkI7AzM6Qz/BbD6KSAfrDzji3DFwH9n7jFprohV+AO0ky+w+VVz+TmW
         nZGKakSvgkSKqeurj9JVnyIIA03I/HzlQbJBfSoe0R9koxyBfRC5cW/pPlylsRrg3m4t
         DpgFTN1bHpp7fOMY6Wwd3tSQVLUN3BLTrUnBukght6m6oKrbXdw8OpRwdSgBYal8NsD9
         rpXW9CrbwG/Grl2ioF1vaP32BwwTyDuy857pm95SClsvvuwX2bP7lhTDUJF6LBfQuwGj
         G+uA==
X-Gm-Message-State: AOAM5310l8BW/9wgDqI62Vd1q9Gs5tCdVYcBjwm3eJ2pvLp68mCi0G15
        +2c8b7sxoFJktuVixsYjwkiJHBvGmEs=
X-Google-Smtp-Source: ABdhPJyFd7/K3HU4l+Cv5fZCNjy1JDNj6ZZDIMrrI9KE3V6p6HbLpiUwfP08N9dIpCk9YiLXeBlSvw==
X-Received: by 2002:a63:7d8:: with SMTP id 207mr9216963pgh.310.1639880570877;
        Sat, 18 Dec 2021 18:22:50 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:e30])
        by smtp.gmail.com with ESMTPSA id e11sm12491517pjl.20.2021.12.18.18.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 18:22:50 -0800 (PST)
Date:   Sat, 18 Dec 2021 18:22:48 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v4 05/10] bpf: Add reference tracking support to
 kfunc
Message-ID: <20211219022248.6hqp64a4nbhyyxeh@ast-mbp>
References: <20211217015031.1278167-1-memxor@gmail.com>
 <20211217015031.1278167-6-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217015031.1278167-6-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 07:20:26AM +0530, Kumar Kartikeya Dwivedi wrote:
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 965fffaf0308..015cb633838b 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -521,6 +521,9 @@ struct bpf_verifier_ops {
>  				 enum bpf_access_type atype,
>  				 u32 *next_btf_id);
>  	bool (*check_kfunc_call)(u32 kfunc_btf_id, struct module *owner);
> +	bool (*is_acquire_kfunc)(u32 kfunc_btf_id, struct module *owner);
> +	bool (*is_release_kfunc)(u32 kfunc_btf_id, struct module *owner);
> +	bool (*is_kfunc_ret_type_null)(u32 kfunc_btf_id, struct module *owner);

Same feedback as before...

Those callbacks are not necessary.
The existing check_kfunc_call() is just as inconvenient.
When module's BTF comes in could you add it to mod's info instead of
introducing callbacks for every kind of data the module has.
Those callbacks don't server any purpose other than passing the particular
data set back. The verifier side should access those data sets directly.
