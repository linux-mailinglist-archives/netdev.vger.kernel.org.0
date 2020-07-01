Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54953211228
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 19:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732681AbgGARqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 13:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbgGARqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 13:46:13 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3046C08C5C1;
        Wed,  1 Jul 2020 10:46:13 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id h4so4106554plt.9;
        Wed, 01 Jul 2020 10:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HEqG52CUEnM+8vwdYDVzUK9ua6L+n8SD8EC+WKINw+I=;
        b=fDnitKQfr0XQaFrGa+7DgYagvn5IdmVUszjCl+j9Q6CIEdN/J22tA7tWAn/dhh8ShB
         wq0S5FVW0SlPQTmKle1aiT1tasaPPAkyY0k/6k1o4snX5o9lOVRWqbE8/QE4rinVo75o
         250vsiWnaWteAPwrX0T8mej9ZHrIXdmbbYTQq8qBIeZsMFcams0IcF4EXm/lSj1bcfSt
         9QZNTnSOkWxDKBjvSKAa6QOGRpBlO362Hj2cXOaGdfSP/2+9kC0d5F/mcgHERurh1VVK
         na3jE3B3N+hF7XWV0qEkfihV0+M+jDwDlkS/zufzd8gsB73OgQ6uK/2Rpq0acVz1M8Aq
         6dkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HEqG52CUEnM+8vwdYDVzUK9ua6L+n8SD8EC+WKINw+I=;
        b=jCUsVm5ZXW6zNxxZlwSsoX3q1IHt+YupBzwzCyyzxrRKe73Y3QyzHS3rZW5QoTvBrY
         pXJ+VMgRdqfOkateSPKdXrrpveZIDv6vYiffke22+cRdCBRfqbSVNMhMMyJOoFHaKuFl
         Zii2Fv2ok926tZtDrib7ZXanxoAJNAEqae2Rq/dC+SfZ+HuzcPXSbwM7obR84Rl4AjgY
         fJDLyvd+WHR6HKwVTy+eHk8IWOfXTekRzAphG8TYgx7a7VU7qTgPjL2xbNqDoRWjAikI
         UEj3vOt78QXlff+2Q4RQrq/yVy7hVnEY1k+YO1Sc1mqx/Fso2DNYWrs+yeA/82r4+kWT
         ioZQ==
X-Gm-Message-State: AOAM5331f1ATHibMVjVcSpY1bzeQXwDF3deJNGLqpdTllkluTTF6s0ku
        zXtzSYXDFLyPlcNB+kRTqi8=
X-Google-Smtp-Source: ABdhPJzDIJ8xlQpJZvWHkS75pbagg38NZVKP850h0t1R8fnLwUVY+58F5C9jlGqU3BN1DxFLZTsS+Q==
X-Received: by 2002:a17:902:b786:: with SMTP id e6mr12325987pls.88.1593625573184;
        Wed, 01 Jul 2020 10:46:13 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:7882])
        by smtp.gmail.com with ESMTPSA id z1sm6309135pgk.89.2020.07.01.10.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 10:46:12 -0700 (PDT)
Date:   Wed, 1 Jul 2020 10:46:09 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Michal Kubecek <mkubecek@suse.cz>,
        linux-kernel@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Song Liu <songliubraving@fb.com>,
        Valdis Kl =?utf-8?B?xJM=?= tnieks <valdis.kletnieks@vt.edu>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH] bpfilter: allow to build bpfilter_umh as a module
 without static library
Message-ID: <20200701174609.mw5ovqe7d5o6ptel@ast-mbp.dhcp.thefacebook.com>
References: <20200701092644.762234-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701092644.762234-1-masahiroy@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 01, 2020 at 06:26:44PM +0900, Masahiro Yamada wrote:
> Originally, bpfilter_umh was linked with -static only when
> CONFIG_BPFILTER_UMH=y.
> 
> Commit 8a2cc0505cc4 ("bpfilter: use 'userprogs' syntax to build
> bpfilter_umh") silently, accidentally dropped the CONFIG_BPFILTER_UMH=y
> test in the Makefile. Revive it in order to link it dynamically when
> CONFIG_BPFILTER_UMH=m.
> 
> Since commit b1183b6dca3e ("bpfilter: check if $(CC) can link static
> libc in Kconfig"), the compiler must be capable of static linking to
> enable CONFIG_BPFILTER_UMH, but it requires more than needed.
> 
> To loosen the compiler requirement, I changed the dependency as follows:
> 
>     depends on CC_CAN_LINK
>     depends on m || CC_CAN_LINK_STATIC
> 
> If CONFIG_CC_CAN_LINK_STATIC in unset, CONFIG_BPFILTER_UMH is restricted
> to 'm' or 'n'.
> 
> In theory, CONFIG_CC_CAN_LINK is not required for CONFIG_BPFILTER_UMH=y,
> but I did not come up with a good way to describe it.
> 
> Fixes: 8a2cc0505cc4 ("bpfilter: use 'userprogs' syntax to build bpfilter_umh")
> Reported-by: Michal Kubecek <mkubecek@suse.cz>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

lgtm
Do you mind I'll take it into bpf-next tree?
Eric is working on a bunch of patches in this area. I'll take his set
into bpf-next as well and then can apply this patch.
Just to make sure there are no conflicts.
