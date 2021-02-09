Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83A8314F7F
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 13:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhBIMui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 07:50:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230223AbhBIMtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 07:49:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612874868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kYIvfF1pbKCmOCnTFNppgDKGi8/ozAzP6ifos3X5+bI=;
        b=hn4YMAWRPrz2bVct0IzZSkAqedhj9b8Jy6kRWuoG/cwCGLzqZdSCpROqIQkNg76IuRi9cZ
        e+6hEM67TOgOsYN61jKkNGCq+W5Ap7MxnLxq6XjgxAjSMAzj/000I4GvIPw4iKcLlhYybu
        UqzBEsv/iDFT5CAwI8LVFqpidFym+NY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-m6qM_HJHMzypie8_HItsqg-1; Tue, 09 Feb 2021 07:47:46 -0500
X-MC-Unique: m6qM_HJHMzypie8_HItsqg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92D63801981;
        Tue,  9 Feb 2021 12:47:44 +0000 (UTC)
Received: from krava (unknown [10.40.196.4])
        by smtp.corp.redhat.com (Postfix) with SMTP id 26BB660C04;
        Tue,  9 Feb 2021 12:47:40 +0000 (UTC)
Date:   Tue, 9 Feb 2021 13:47:40 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     daniel@iogearbox.net, peterz@infradead.org, mingo@redhat.com,
        acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, namhyung@kernel.org,
        ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2] perf script: Simplify bool conversion
Message-ID: <YCKEbN52Z+a4+mhd@krava>
References: <1612773936-98691-1-git-send-email-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612773936-98691-1-git-send-email-yang.lee@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 04:45:36PM +0800, Yang Li wrote:
> Fix the following coccicheck warning:
> ./tools/perf/builtin-script.c:2789:36-41: WARNING: conversion to bool
> not needed here
> ./tools/perf/builtin-script.c:3237:48-53: WARNING: conversion to bool
> not needed here
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka

> ---
> 
> Change in v2:
> -Change the subject to "perf script"
> 
>  tools/perf/builtin-script.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 42dad4a..3646a1c 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -2786,7 +2786,7 @@ static int parse_output_fields(const struct option *opt __maybe_unused,
>  				break;
>  		}
>  		if (i == imax && strcmp(tok, "flags") == 0) {
> -			print_flags = change == REMOVE ? false : true;
> +			print_flags = change != REMOVE;
>  			continue;
>  		}
>  		if (i == imax) {
> @@ -3234,7 +3234,7 @@ static char *get_script_path(const char *script_root, const char *suffix)
>  
>  static bool is_top_script(const char *script_path)
>  {
> -	return ends_with(script_path, "top") == NULL ? false : true;
> +	return ends_with(script_path, "top") != NULL;
>  }
>  
>  static int has_required_arg(char *script_path)
> -- 
> 1.8.3.1
> 

