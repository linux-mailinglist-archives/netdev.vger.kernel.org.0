Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD071FA95F
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 09:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgFPHBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 03:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgFPHBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 03:01:36 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16032C05BD43;
        Tue, 16 Jun 2020 00:01:36 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id c8so20784383iob.6;
        Tue, 16 Jun 2020 00:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=gfWOtJmAuKzy0/adAae/4szOh4OfnUS7wZP9kpJR7bw=;
        b=e3Qyy981NcHQ5TKXw92ISB9PBm7DX/ADlMIESviTtLtVuAehT3xHFoeXEKXR1C7DOA
         6d3gdDuyG0RyvaS8moYHRpWOHhlA89eB1czDdMhntLpLWo5V20RH963WWrJKn/UadmJZ
         JZhFl7R/KYvjoko53qtFg562YhDQK0zidnL8sMU9i6fd8L56yDfl22ezYhZJoe3QPsZa
         DKLAmWAnytENsXz4goZyc82txgVCASYm5VjW+eEtKQATcmYQlqnfY3K1RzoaJEDcirBO
         6/t4IIs7hgB1Eg4pg69EHu0njcKUyB/crETKeOvWev0yMMQDJ9X1Sk/BHIj26l1qURoj
         ZHxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=gfWOtJmAuKzy0/adAae/4szOh4OfnUS7wZP9kpJR7bw=;
        b=JxFxekWG5ST0naisV+nSHdRliDLz5yEs6CtQYEX+qzOJT4Gt1X6d0jrDrL/akQhY18
         q2xopQNPsnhz445sf4sx1CgTdLy6bN8gERznlIeGUxl6SmuH/Mx9+PHdGPIZ+5ap/Y8o
         wq23F4QJsDxlj/1VnC/jm8oVWcF+wEdqhLTK1CDL70LWz5BOhKKoVD0IGftGO2svRm+2
         aHK3jTQbRkk2rSOAYoCWLXerRLoi6FMw0b7CaAO3CQoAfPZJjo6mvNlPlHK9gLGCcULh
         cdmCSPqnqWvHiXLAQbOYnVSDp3E0/+ZIFSnbYuRFGR55H8sjSmmkGd/i4H4J2fArdmwA
         m+oA==
X-Gm-Message-State: AOAM530fF5bqd1g7bu499pQMilAYdy+yRoxfqHTG0318XbFjRQB12uC4
        F38T/CQl8dGOxeJiJE/4QJc=
X-Google-Smtp-Source: ABdhPJyPjxsHOybrD8KP9INBaOeOj2FGmJCvZnnRUb939Ss81dG9U1pMsdYUMwvK38vWJzyMC4slWg==
X-Received: by 2002:a5e:8703:: with SMTP id y3mr1253050ioj.61.1592290893151;
        Tue, 16 Jun 2020 00:01:33 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id p5sm9225053ilg.88.2020.06.16.00.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 00:01:32 -0700 (PDT)
Date:   Tue, 16 Jun 2020 00:01:22 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>,
        Christoph Hellwig <hch@lst.de>
Message-ID: <5ee86e42810c7_4be02ab1b668a5b430@john-XPS-13-9370.notmuch>
In-Reply-To: <20200616050432.1902042-1-andriin@fb.com>
References: <20200616050432.1902042-1-andriin@fb.com>
Subject: RE: [PATCH bpf 1/2] bpf: bpf_probe_read_kernel_str() has to return
 amount of data read on success
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> During recent refactorings, bpf_probe_read_kernel_str() started returning 0 on
> success, instead of amount of data successfully read. This majorly breaks
> applications relying on bpf_probe_read_kernel_str() and bpf_probe_read_str()
> and their results. Fix this by returning actual number of bytes read.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Fixes: 8d92db5c04d1 ("bpf: rework the compat kernel probe handling")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  kernel/trace/bpf_trace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index e729c9e587a0..a3ac7de98baa 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -241,7 +241,7 @@ bpf_probe_read_kernel_str_common(void *dst, u32 size, const void *unsafe_ptr)
>  	if (unlikely(ret < 0))
>  		goto fail;
>  
> -	return 0;
> +	return ret;
>  fail:
>  	memset(dst, 0, size);
>  	return ret;
> -- 
> 2.24.1
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
