Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7911E23F14F
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 18:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgHGQfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 12:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgHGQfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 12:35:09 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02217C061756;
        Fri,  7 Aug 2020 09:35:08 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id u10so1287854plr.7;
        Fri, 07 Aug 2020 09:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0BTPkp970y7NtcMqII6NW4zFGpHMrV7uMB1ni6PaU8g=;
        b=pNP+absCGWS6pJnWHWGD0mq+wYn4SYn9ivYeAfHLMq9wX5aIQBsb59V6jrpXo40+LR
         WDL3oyUHbtGFDLCfXkW8nlCOfP4nTRzS+YKK2f1w3W5B0lEbPpvZoGD2a2Fhdg42ot2u
         s4pIHXUy+nj768j8k6ZCbqg/mdIcD56qKuKDnklUfqzqwnaZlTqS3/7ZI2hVvREcSx/X
         TUSHNtWiDo/NaSsF/FNPeo6o1SSQJkYwyttIksh/ieGy1Xoy0FEGTL/PeQ9bflatkRNu
         RhGLTrfZrThwtMc6FiW8i5Ed4CwJ69aTxe1EQ2XW7fDmwJh/l3omBLGI+NTl+ZpyXtZ8
         l73g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0BTPkp970y7NtcMqII6NW4zFGpHMrV7uMB1ni6PaU8g=;
        b=DcEUDdHJhiLLO+vzlleufuPkf64BZ0tZdjtX3xcckgSIHwFAyBvdd7X+pQ2+KZzXmp
         Pgjd2d8VV2W/LHU9Hbcx1f9tRAMnYWMqLBbNx5aBvPvcXN2Bwq3WzCPXI9obG5IF3ia6
         hr1gPS4kwHBcvaL1+zkJmbq4thgAkvoCZT6G4gcvZsCokwB6Utl+Rnd2NSW4aV6Dn3bD
         fXBk+6W85xNDx6D4lOc4nj5MjEPTpJI8ZUjd7rMJwXEQakF9E9DiAKgymH+GZg2nfHUv
         YXGumAlI/WvT3ywsrOFdLtWCphFZRFpzjwdT2Qt52XH7HTN9zgslhHqGUeYdhiSvo/XI
         EkAg==
X-Gm-Message-State: AOAM531pxi1PI3k3HmOy4nH/tg67slxCEjh/wkhyTFm9Clj20BDTiTus
        a513LuQt/qLH0o49DUV3pvc=
X-Google-Smtp-Source: ABdhPJy1iKawDKtqh/FkaLLKHIk4+roaW9FuDclDO2BPGq9xwE7PxCam4v8CB6QQBCALjE7vZu2A/w==
X-Received: by 2002:a17:902:7c8e:: with SMTP id y14mr4767085pll.200.1596818107218;
        Fri, 07 Aug 2020 09:35:07 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:f74])
        by smtp.gmail.com with ESMTPSA id f20sm14562845pfk.36.2020.08.07.09.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 09:35:06 -0700 (PDT)
Date:   Fri, 7 Aug 2020 09:35:03 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v10 bpf-next 00/14] bpf: Add d_path helper
Message-ID: <20200807163503.ytoej6qxsjuedty7@ast-mbp.dhcp.thefacebook.com>
References: <20200807094559.571260-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200807094559.571260-1-jolsa@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 07, 2020 at 11:45:45AM +0200, Jiri Olsa wrote:
> hi,
> adding d_path helper function that returns full path for
> given 'struct path' object, which needs to be the kernel
> BTF 'path' object. The path is returned in buffer provided
> 'buf' of size 'sz' and is zero terminated.
> 
>   long bpf_d_path(struct path *path, char *buf, u32 sz);
> 
> The helper calls directly d_path function, so there's only
> limited set of function it can be called from.
> 
> The patchset also adds support to add set of BTF IDs for
> a helper to define functions that the helper is allowed
> to be called from.
> 
> Also available at:
>   https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   bpf/d_path
> 
> v10 changes:
>   - added few acks
>   - returned long instead of int in bpf_d_path helper [Alexei]
>   - used local cnt variable in d_path test [Andrii]
>   - fixed tyo in d_path comment [Andrii]
>   - get rid of reg->off condition in check_func_arg [Andrii]

bpf-next is closed.
I still encourage developers to submit new features for review, but please tag
them as RFC, so the purpose is clear to both maintainers and authors.
