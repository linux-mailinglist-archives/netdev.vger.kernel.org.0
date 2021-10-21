Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A9D435EF4
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 12:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbhJUKYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 06:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbhJUKYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 06:24:02 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4063AC06161C
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 03:21:45 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id g25so308058wrb.2
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 03:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3MQjAVKLomZqee+yM+RGgiOiA3npKQjMdRsvEUjLk/A=;
        b=vuIyDkJNq6FrVSCwT9vhJscgf2YoNdztrvTYNNc1o/75r67I8k9QXMlWv2QrHbGSNY
         Ect1yadoPKv1bGQPU3m75hatYduxDvVtRwLBF1xa0Vql6y3DHI9G3uXuxp7jgSzwn1Ph
         ydNzfmpXuK3cSPJVE3TQUKkQj3MFf931CmwSRSoVgydfvKKD3+6Xvl1DI25ugm9qodOK
         40AOnGFMxJsirsLOOw3xEqfKICXN20IB8J/r3WSo8LjdrAVUDlxkKB5/rdZhoXzmNMFq
         WkRpL4T4aiYcD8xlxDFSokjHXiU4lPY1GGGqNvKRxsa65h6XMgIEUX+1eA3u/WIbDxtu
         HVLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3MQjAVKLomZqee+yM+RGgiOiA3npKQjMdRsvEUjLk/A=;
        b=oioA8ezmoikHgXAkXin5fIaCg+y/P7ncYpQVN/Pe70nbxM/yUXaFxjuHMwJRdQ0KPp
         bmKtzbvPyAQLyaVOY+PsIvsChQzlYh+lfdKsD0Jz3uPUe2DNXaq9RHrDPSGTrEXXrzCB
         K6JAffiHOHC8XO+19B1JCQ7cEyzjCBGLTf9UurH5x/A9GdRWDFpD51vHtcqMYCYBly0c
         mRaZ1FejcsW/RryKFVfKeSMOkoSQjg97nHWCnLvaKau/XWv+obDOckEK0MLRPtt3JrEI
         xC9RTSOgbnDBW/Ti19E9ZouJdpMPmlH1yXK0M59zYc3TwGFFuGCBPCDTM88UedR4CZZA
         77ww==
X-Gm-Message-State: AOAM530mS7EVMPLTkM1bMu2DoS+x+1lW2HLwgh/2B9zcy+GLy9Oyyoj8
        6LbsVEd2IbLUM28wqsNUgNvbNRmay5LqYeT2
X-Google-Smtp-Source: ABdhPJyyREbMqJ/keot/LTfQ1u9FaNy1q3fjRB+7AvFmEuMvRUHx3/5nxkVgvprXfRKtJAbJHFi5fw==
X-Received: by 2002:adf:f2cd:: with SMTP id d13mr1939120wrp.18.1634811703827;
        Thu, 21 Oct 2021 03:21:43 -0700 (PDT)
Received: from [192.168.1.8] ([149.86.71.75])
        by smtp.gmail.com with ESMTPSA id i9sm153441wmb.22.2021.10.21.03.21.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 03:21:43 -0700 (PDT)
Message-ID: <51b14dc8-90ae-6d87-06bf-436ea9947ec1@isovalent.com>
Date:   Thu, 21 Oct 2021 11:21:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH bpf-next v3 1/3] libbpf: use func name when pinning
 programs with LIBBPF_STRICT_SEC_NAME
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
References: <20211020225005.2986729-1-sdf@google.com>
 <20211020225005.2986729-2-sdf@google.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20211020225005.2986729-2-sdf@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-10-20 15:50 UTC-0700 ~ Stanislav Fomichev <sdf@google.com>
> We can't use section name anymore because they are not unique
> and pinning objects with multiple programs with the same
> progtype/secname will fail.
> 
> Closes: https://github.com/libbpf/libbpf/issues/273
> Fixes: 33a2c75c55e2 ("libbpf: add internal pin_name"0

s/0$/)/

> Cc: Quentin Monnet <quentin@isovalent.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/lib/bpf/libbpf.c        | 13 +++++++++++--
>  tools/lib/bpf/libbpf_legacy.h |  3 +++
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 760c7e346603..7f48eeb3ca82 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -285,7 +285,7 @@ struct bpf_program {
>  	size_t sub_insn_off;
>  
>  	char *name;
> -	/* sec_name with / replaced by _; makes recursive pinning
> +	/* name with / replaced by _; makes recursive pinning
>  	 * in bpf_object__pin_programs easier
>  	 */
>  	char *pin_name;
> @@ -614,7 +614,16 @@ static char *__bpf_program__pin_name(struct bpf_program *prog)
>  {
>  	char *name, *p;
>  
> -	name = p = strdup(prog->sec_name);
> +	if (libbpf_mode & LIBBPF_STRICT_SEC_NAME)
> +		name = strdup(prog->name);
> +	else
> +		name = strdup(prog->sec_name);
> +
> +	if (!name)
> +		return NULL;
> +
> +	p = name;
> +
>  	while ((p = strchr(p, '/')))
>  		*p = '_';
>  
> diff --git a/tools/lib/bpf/libbpf_legacy.h b/tools/lib/bpf/libbpf_legacy.h
> index 74e6f860f703..a51f34637442 100644
> --- a/tools/lib/bpf/libbpf_legacy.h
> +++ b/tools/lib/bpf/libbpf_legacy.h
> @@ -52,6 +52,9 @@ enum libbpf_strict_mode {
>  	 * allowed, with LIBBPF_STRICT_SEC_PREFIX this will become
>  	 * unrecognized by libbpf and would have to be just SEC("xdp") and
>  	 * SEC("xdp") and SEC("perf_event").
> +	 *
> +	 * Note, in this mode the program pin path will based on the

"will based" -> "will be based"

> +	 * function name instead of section name.
>  	 */
>  	LIBBPF_STRICT_SEC_NAME = 0x04,
>  
> 

Looks good otherwise
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
