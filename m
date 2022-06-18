Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C953055029F
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 06:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbiFREN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 00:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiFREN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 00:13:56 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA3860BB5;
        Fri, 17 Jun 2022 21:13:55 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id c4so670978ilj.7;
        Fri, 17 Jun 2022 21:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=y+vyOEdq3OiKKyr88imZLMREIzkAehWVmx3urHTS3LY=;
        b=NRgIlefOqcke0tnkQ43EBWC8BvsQMCmT3cauYKD+OUINd3vZjoLfpBQPZkPMXneRir
         iyhoMpwkzMvxd+rtXacu6cbc4kQt2zeAsygLQdwpAE2gD4UEhScrK4B2Gmk7/H8H8v36
         aQSADm54eCHiqnPVbS4K4/VQ9UvbXgK+DzTPQhLKKsQt82aMHWBo0gV93s7IWt1QuRf7
         APPduv+esD0gK7QcbMKsTdo/K6uKnCxQx+BMDWyhkNHR4DMc69fRfuZWubqaIVgBOX/0
         Wrp3ZpaTUgEyL5BfB6zNt8C1HQGY55M2YF34ZUtRdju0VqyfMcaZh4gdO9h+OqT/1a4d
         ZjoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=y+vyOEdq3OiKKyr88imZLMREIzkAehWVmx3urHTS3LY=;
        b=n+1t9xJzF4Q8Y+vg1kWLfv5TwnpEEiL93Qn2OLPBdvyEWKYnMw82bJLzgDENR4YmUS
         4JqANtXUUm7gLMFi75b9NYifgCD/+MRBXLs7CKQFWw9XpjRp9ffGoFqNyqk0CQVES69k
         o8/f1WGwzKxPwFG0S8E/76aWxY+j4qHYijWXjNMYJMfUUlgWZ3bRiOzWIIECzJHv3oND
         nLhsObla+/P5T/cr1iQVZ5TWj6hvMdiyMhHmrC8hCe0TWO3YpSiokFQC2q/hQWbEyDMk
         Ry4294P+U5bpk0TO0pK3T44a0pdwBWQqGz1OlE/iiJYCWnahG+OZXWJPesoyW6AXLpTt
         ajGA==
X-Gm-Message-State: AJIora8+i8mGwghYGBU3EaZeFSVRywhKfCde8RRhBSjJ+yoF8d9JZxLR
        ZCCxDl0btTx2VQs0BI2G+BY=
X-Google-Smtp-Source: AGRyM1vjWfBtV27HJB5mj92weeZvqAKQEy/lwq28Tn9M4ISBXlArgR6oDZupkcobqYxlCv9lt3IT1w==
X-Received: by 2002:a05:6e02:20c6:b0:2d8:e62f:349f with SMTP id 6-20020a056e0220c600b002d8e62f349fmr2921107ilq.160.1655525634503;
        Fri, 17 Jun 2022 21:13:54 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id e62-20020a6bb541000000b00669384fcf88sm3505408iof.1.2022.06.17.21.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 21:13:54 -0700 (PDT)
Date:   Fri, 17 Jun 2022 21:13:46 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Chuang W <nashuiliang@gmail.com>
Cc:     Chuang W <nashuiliang@gmail.com>,
        Jingren Zhou <zhoujingren@didiglobal.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <62ad50fa9d42d_24b34208d6@john.notmuch>
In-Reply-To: <20220614084930.43276-1-nashuiliang@gmail.com>
References: <20220614084930.43276-1-nashuiliang@gmail.com>
Subject: RE: [PATCH] libbpf: Remove kprobe_event on failed kprobe_open_legacy
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chuang W wrote:
> In a scenario where livepatch and aggrprobe coexist, the creating
> kprobe_event using tracefs API will succeed, a trace event (e.g.
> /debugfs/tracing/events/kprobe/XX) will exist, but perf_event_open()
> will return an error.

This seems a bit strange from API side. I'm not really familiar with
livepatch, but I guess this is UAPI now so fixing add_kprobe_event_legacy
to fail is not an option?

> 
> Signed-off-by: Chuang W <nashuiliang@gmail.com>
> Signed-off-by: Jingren Zhou <zhoujingren@didiglobal.com>
> ---
>  tools/lib/bpf/libbpf.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 0781fae58a06..d0a36350e22a 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -10809,10 +10809,11 @@ static int perf_event_kprobe_open_legacy(const char *probe_name, bool retprobe,
>  	}
>  	type = determine_kprobe_perf_type_legacy(probe_name, retprobe);
>  	if (type < 0) {
> +		err = type;
>  		pr_warn("failed to determine legacy kprobe event id for '%s+0x%zx': %s\n",
>  			kfunc_name, offset,
> -			libbpf_strerror_r(type, errmsg, sizeof(errmsg)));
> -		return type;
> +			libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> +		goto clear_kprobe_event;
>  	}
>  	attr.size = sizeof(attr);
>  	attr.config = type;
> @@ -10826,9 +10827,14 @@ static int perf_event_kprobe_open_legacy(const char *probe_name, bool retprobe,
>  		err = -errno;
>  		pr_warn("legacy kprobe perf_event_open() failed: %s\n",
>  			libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> -		return err;
> +		goto clear_kprobe_event;
>  	}
>  	return pfd;
> +
> +clear_kprobe_event:
> +	/* Clear the newly added kprobe_event */
> +	remove_kprobe_event_legacy(probe_name, retprobe);
> +	return err;
>  }
>  
>  struct bpf_link *
> -- 
> 2.34.1
> 


