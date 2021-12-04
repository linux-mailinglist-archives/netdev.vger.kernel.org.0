Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3449468191
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 01:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383924AbhLDAvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 19:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354618AbhLDAvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 19:51:12 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4BBC061751;
        Fri,  3 Dec 2021 16:47:47 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id r130so4465006pfc.1;
        Fri, 03 Dec 2021 16:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1NXW96FULaq9MCh+MikxqVORQr2ZBOfCRWVjuh1Jzis=;
        b=Djbf+mJRsfMrGfOHRmNHs1aF9bv5dEmaVVNI8EEYjqDGWPfG+Jampf9GTMubipT3/z
         sQBazHZTHH+9bifmmiQaeVtqA5TYAaNnLQQZvR/LQkmzyxx8Jwz5eTRYtrapJCBrUORB
         TyWZ3D1800bAM3QaOF+Ip5Y808ZsGLdYI6JzTG5IBU/uzHYSRURLH5EtuCiZ0dgGEUpp
         o1aXIhu4IzEeCo8GXMza+BI7WvvJwwFPVq8Xq7AdN9oT1iiee4EUiLdY6UOymks48qDp
         f3kudYtZHxH7MIqWuWONqkciAhgWLpcvdWxzTDXjigfWme8quV3uRh5AFpSZme7PjUmz
         6kGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1NXW96FULaq9MCh+MikxqVORQr2ZBOfCRWVjuh1Jzis=;
        b=zHoeWmXwTsqx27ABB6QHIV0h3NHMEg+olGV+BbFS7iZ2uzSqQcaUX/RbAKqJbmapAp
         YebFLmZLp8ShnB6GK1yiDGyF5s6eNL9W89dkfzEea53/B46x4pNzP+WG7WkZEmVU5Xu0
         aShKYzw3i85zksq9q0Dcse9Vm+EPsvugSAWlP5ug5SDQm12Gei8wRC/PPDSRSWUaoyxv
         ZXwWjDmR/tbrYRCuxSDAOC+dx1gQYLXHpFqfXXTEWsyhaLvUTcjRa5SZC2XVJoxoX4I+
         GU/KKeJ/hgpSvmoYHT4SRd9CRz5xC1RPTsLB19hhq6a9Xy0E/Dr2vDPEIlDPlbNcfln+
         OOlg==
X-Gm-Message-State: AOAM533FXVYT1PLcyrQDaG0gURIWHv0MeOoAe7SBzfUqVYrJmNCkRSgl
        cX7vwzGiWjCgg46TFy45iPY=
X-Google-Smtp-Source: ABdhPJwsr7y5BMX5/TVxi4p7OUi6OqtQU4pwpl0F6RZSVT4tTF8u9D27X0kG2fXgW/DTbSlhh19OPw==
X-Received: by 2002:a63:8bc7:: with SMTP id j190mr6955899pge.240.1638578867239;
        Fri, 03 Dec 2021 16:47:47 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:502e:73f4:8af1:9522])
        by smtp.gmail.com with ESMTPSA id t3sm4856500pfg.94.2021.12.03.16.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 16:47:46 -0800 (PST)
Date:   Sat, 4 Dec 2021 06:17:44 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH bpf 2/2] samples: bpf: fix 'unknown warning group' build
 warning on Clang
Message-ID: <20211204004744.eqakjotrfu4ceksp@apollo.legion>
References: <20211203195004.5803-1-alexandr.lobakin@intel.com>
 <20211203195004.5803-3-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211203195004.5803-3-alexandr.lobakin@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 04, 2021 at 01:20:04AM IST, Alexander Lobakin wrote:
> Clang doesn't have 'stringop-truncation' group like GCC does, and
> complains about it when building samples which use xdp_sample_user
> infra:
>
>  samples/bpf/xdp_sample_user.h:48:32: warning: unknown warning group '-Wstringop-truncation', ignored [-Wunknown-warning-option]
>  #pragma GCC diagnostic ignored "-Wstringop-truncation"
>                                 ^
> [ repeat ]
>
> Those are harmless, but avoidable when guarding it with ifdef.
> I could guard push/pop as well, but this would require one more
> ifdef cruft around a single line which I don't think is reasonable.
>
> Fixes: 156f886cf697 ("samples: bpf: Add basic infrastructure for XDP samples")
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---

Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

> [...]

--
Kartikeya
