Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0415838F678
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 01:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhEXXuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 19:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhEXXui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 19:50:38 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15856C061574;
        Mon, 24 May 2021 16:49:09 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id kr9so7714156pjb.5;
        Mon, 24 May 2021 16:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lXSossPE8LL2zSSzWvGnCKDe1LODnHw6QGXeKjFzKYc=;
        b=AYVWuhkb1CIqQDqQVCWs4WKp1o3sxouZqTk/1+1FnRviGV8UAcV2V9zwwzpgbTBarG
         SS6wOrEH9fLSDE0AEKRpLWYnQPSdJoOyiiIkqa9/DZbZMKzwUK0caeYVOwN6rganYk7Y
         Cf1m7cdrWlP4WB8UIgvF/F7+6ql7bV3RPqixaIWSj14CU1EYvJO8ck2TBk3fH1Hvj/7f
         Ek2x7cLZ7yldxsr+Y7FPmLo0Ti+n29EPY+9wkrxq0qyOjPARQbaj/cGFJ/iGS8OyJxFn
         nVgMgM/3V1Pv1/Lkp9DandEKkxuGNiKKlwjB/4Bo+Rk93XC7msnfP1lvt9I3f4t2XGY9
         j7TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lXSossPE8LL2zSSzWvGnCKDe1LODnHw6QGXeKjFzKYc=;
        b=Vv62fl4dr7yAtlQKdS48ShtfQEgg/24EZC3Xj4vBFMTiexXy5exgwC4+gNGJSyboP7
         x7fSTZJmMPrjqY+z89W4mAuogzv0Y+DDCVujXtOM5+QQQO1JWcWong2oukjQqgYgS4w1
         aXqRflQ42ud5srgUfLUCmCgl8reuQbL5aAIKWr58AcSaZJv0Pt+yewWelZrL1NoWUmra
         iA27c6Ugke54Pnv7jVQkxVUbdk76UCAiSLVTETt7TBGZLpsClHXqpB30BCK+atnr3jmS
         MkVsfqtdaDFeqJAQcaG2dy+hdMzKSw5B1RDKaWvhMEykBfxCS/w/2S2pLFUwsZhtKyyc
         fZYg==
X-Gm-Message-State: AOAM533h+zdG78umal4E5so2ZCCmrYRafT9jZrqO6PjrGeRyY/sZFJ06
        EJpEoqtUM3Y+v8VwLq0pGItwhBUp+Ag=
X-Google-Smtp-Source: ABdhPJxMxl45/19A75W9GcfsT+g7VlXU1s3FuCLwIZ22Dm8IjMMPlVgjEekH8Z86S5UdN/hxHzmmkQ==
X-Received: by 2002:a17:902:aa4c:b029:ee:ec17:89f with SMTP id c12-20020a170902aa4cb02900eeec17089fmr27662794plr.11.1621900148453;
        Mon, 24 May 2021 16:49:08 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:f6f4])
        by smtp.gmail.com with ESMTPSA id 5sm11400962pfe.32.2021.05.24.16.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:49:07 -0700 (PDT)
Date:   Mon, 24 May 2021 16:49:05 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 4/5] libbpf: streamline error reporting for
 high-level APIs
Message-ID: <20210524234905.n6ycfsmgqhn5ai3p@ast-mbp>
References: <20210521234258.1289307-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521234258.1289307-1-andrii@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 04:42:58PM -0700, Andrii Nakryiko wrote:
>  
> +/* this goes away in libbpf 1.0 */
> +enum libbpf_strict_mode libbpf_mode = LIBBPF_STRICT_NONE;
> +
> +int libbpf_set_strict_mode(enum libbpf_strict_mode mode)
> +{
> +	/* __LIBBPF_STRICT_LAST is the last power-of-2 value used + 1, so to
> +	 * get all possible values we compensate last +1, and then (2*x - 1)
> +	 * to get the bit mask
> +	 */
> +	if (mode != LIBBPF_STRICT_ALL
> +	    && mode & ~((__LIBBPF_STRICT_LAST - 1) * 2 - 1))
> +		return libbpf_err(-EINVAL);
> +
> +	libbpf_mode = mode;
> +	return 0;
> +}

This hunk should be in patch 1, right?
Otherwise bisection will be broken.
