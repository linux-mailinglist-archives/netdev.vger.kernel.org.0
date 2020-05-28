Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465891E6E6F
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436909AbgE1WOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436883AbgE1WOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 18:14:02 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE8EC08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:14:02 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id r7so1113088wro.1
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Tt0Tg3GLkWHkJ4q+k/gu/XYcvqOHbgKe/WyfRdpAP/U=;
        b=NIRVprwfOqmaFPY2/MsnPb2FBS7znrCdz9xh0fbhHmsYVeMjGHTDSK9OKZL97YPxyP
         DAipmlwnZ1w9h7bw2rV+phj5v36UMhCXKZSvD2E1auUvIJB6jaXiJUvNDmOmpKNs9n2v
         wixHY+rGyxwaPhFExshTNmHgt6FUP/iiNW9kE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Tt0Tg3GLkWHkJ4q+k/gu/XYcvqOHbgKe/WyfRdpAP/U=;
        b=OVUXdG3WO4Tk5Gese120GrOOtXIt/CnB45+OUjMI1sC9AN9c1dMSQpPeVQq4Brby1V
         lJQ63xr1kDN/7jkLIR499VXR0yIBdlr7KqkrTniZpsrgxfizvaDER0wvaPNywnARN+q0
         jPLkfCH8Xoff6c3oBj+JEIeDEqVmEGvyI64ix0rspkS7PjYaOneQ5QCAuArsCyrIaVEe
         RsHO+02+KHnXhOt7FdEnfOGdYfyi7LzSZGB8vVc84acztHEbUeh9C9Ku/+R3ejho0nmN
         8hjo4xuAfF72zQUVjjiSy2+otl3dRf2xJ3SWoGzyrJfypzY7AJJF/wIQ1dWikeITMU7E
         v8Ew==
X-Gm-Message-State: AOAM531a0jNQycJZOD5ZGpRhu1mlmems124esweRbTkuGfRB4qoPHtN0
        QssL+S5xkqD4A5zUo3XzrbMBbw==
X-Google-Smtp-Source: ABdhPJwfAgrEzcAXD3IXN5g8f8HN7as/5MyOVRQimV416kIZ2vLW4lxys2MDPVjtah5gG0Us2mXIYA==
X-Received: by 2002:a5d:4a8a:: with SMTP id o10mr5433935wrq.222.1590704040991;
        Thu, 28 May 2020 15:14:00 -0700 (PDT)
Received: from google.com ([81.6.44.51])
        by smtp.gmail.com with ESMTPSA id 10sm8559672wmw.26.2020.05.28.15.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 15:14:00 -0700 (PDT)
From:   KP Singh <kpsingh@chromium.org>
X-Google-Original-From: KP Singh <kpsingh>
Date:   Fri, 29 May 2020 00:13:59 +0200
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 2/3] libbpf: support sleepable progs
Message-ID: <20200528221359.GB217782@google.com>
References: <20200528053334.89293-1-alexei.starovoitov@gmail.com>
 <20200528053334.89293-3-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528053334.89293-3-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27-May 22:33, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Pass request to load program as sleepable via ".s" suffix in the section name.
> If it happens in the future that all map types and helpers are allowed with
> BPF_F_SLEEPABLE flag "fmod_ret/" and "lsm/" can be aliased to "fmod_ret.s/" and
> "lsm.s/" to make all lsm and fmod_ret programs sleepable by default. The fentry
> and fexit programs would always need to have sleepable vs non-sleepable
> distinction, since not all fentry/fexit progs will be attached to sleepable
> kernel functions.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: KP Singh <kpsingh@google.com>

> ---
>  tools/lib/bpf/libbpf.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)

[...]

> -		prog->prog_flags = attr->prog_flags;
> +		prog->prog_flags |= attr->prog_flags;
>  		if (!first_prog)
>  			first_prog = prog;
>  	}
> -- 
> 2.23.0
> 
