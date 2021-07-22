Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32DD03D1EC3
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 09:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhGVGeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 02:34:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46010 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229547AbhGVGef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 02:34:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626938110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HbeaBbCKHLyJ4xr48Gzl+y+Ld5Xe5na7a5Nw+NIBfBE=;
        b=dLA4PE71qi0Ph3I/uqZL7ISZYd23yn+XqCocdn8FUcI4riojHKf95LnNgnhnE2Rx75QE/x
        NDiWubRJJuikNs5L4siUtq+0aIsjFxmZzxx9E2oLgaTjcWGopQAenklwvWiTX4LV7UVQKk
        Ox9C5fxiSeo7R0UbtYBJqOisI9htlvY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-BEkPwydZOhyJq74bOH11Hw-1; Thu, 22 Jul 2021 03:15:09 -0400
X-MC-Unique: BEkPwydZOhyJq74bOH11Hw-1
Received: by mail-ej1-f71.google.com with SMTP id bl17-20020a170906c251b029052292d7c3b4so1513697ejb.9
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 00:15:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HbeaBbCKHLyJ4xr48Gzl+y+Ld5Xe5na7a5Nw+NIBfBE=;
        b=Jb07625sCn3uqBkp8C8xSI4WkIpx99gOKQfNmoqqCl8NXXt2GAJ7pDT4wO4cS3o5oF
         nwErQpKxEWGQmv97RA/09yvDY/hsdVfkXfkJHprNT8PM1x74QZo444kZn/Z9HA46Q/yI
         hleIUJeQNUWwuClHBrjtaJDeUbezR9354/jKoFFcvOTfGXGnqnWt9UsAkyDnxIvTq7QY
         /1yViqDpaWsEpzXZwCJ1q3JcmFXgX+Sbc1m+okgdQImj3hzYhGywAfmg8I7EsHioD1x4
         RYfrzAQSmA4xD4XoRj2nYnJ5bmb5+BeR+T7t14HPbfoB+zZul7jLuGKW0kH0jtX1MC2d
         vCIg==
X-Gm-Message-State: AOAM533taalla2nKlnnuKJ4FxWlAGMUtnJ6YGcCRyt4n9S94L7R4Mpj3
        WuDa2hOic81NeWAq5NHeuKvKJ6npP1lV/BQn7Ge/3kmxEYldx/gWkTGVf5Um+9djT1jc3jHWoGy
        4NmESVkbeq/wpP70u
X-Received: by 2002:a17:906:f11:: with SMTP id z17mr42752660eji.385.1626938108186;
        Thu, 22 Jul 2021 00:15:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxy6xfgeset5dZus4WoJj5fvONkpQK/Ym4JM4fnth0Ivfcf1Q/QMLHjsq53HiTg5oXsndk2Ug==
X-Received: by 2002:a17:906:f11:: with SMTP id z17mr42752647eji.385.1626938108042;
        Thu, 22 Jul 2021 00:15:08 -0700 (PDT)
Received: from krava ([83.240.60.59])
        by smtp.gmail.com with ESMTPSA id lw1sm8064787ejb.92.2021.07.22.00.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 00:15:07 -0700 (PDT)
Date:   Thu, 22 Jul 2021 09:15:05 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: Fix func leak in attach_kprobe
Message-ID: <YPka+SuGAQAAhez/@krava>
References: <20210721215810.889975-1-jolsa@kernel.org>
 <20210721215810.889975-2-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721215810.889975-2-jolsa@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 11:58:08PM +0200, Jiri Olsa wrote:
> Adding missing free for func pointer in attach_kprobe function.
> 

and of course..

Fixes: a2488b5f483f ("libbpf: Allow specification of "kprobe/function+offset"")

jirka

> Reported-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 4c153c379989..d46c2dd37be2 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -10431,6 +10431,7 @@ static struct bpf_link *attach_kprobe(const struct bpf_sec_def *sec,
>  		return libbpf_err_ptr(err);
>  	}
>  	if (opts.retprobe && offset != 0) {
> +		free(func);
>  		err = -EINVAL;
>  		pr_warn("kretprobes do not support offset specification\n");
>  		return libbpf_err_ptr(err);
> -- 
> 2.31.1
> 

