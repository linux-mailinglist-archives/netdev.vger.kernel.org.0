Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C115B3427B0
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhCSVZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 17:25:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30148 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230343AbhCSVZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 17:25:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616189135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xlMXIzOr8B3xAAPOEAkY5g/fup/JgIzMYSjDQhEndBQ=;
        b=RfBVWRyczrexLqA1tFcP+pJXKBfN9+RL5KoR2YznwkCZXlCGr+3C6SG6bMlMxTnMAsiSKU
        urxJ3+YJkV4HQ1ak14wzb1lrvwe7lYRosRJONqAyl38WqHivXRlVCLyNgR05floO2CJbgH
        KPMfsq+PRS0qD8/YYwYZySs5UISMxVM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-dVnOBXKIPsyyHwVq8gZ2mg-1; Fri, 19 Mar 2021 17:25:31 -0400
X-MC-Unique: dVnOBXKIPsyyHwVq8gZ2mg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4790881744F;
        Fri, 19 Mar 2021 21:25:29 +0000 (UTC)
Received: from krava (unknown [10.40.195.94])
        by smtp.corp.redhat.com (Postfix) with SMTP id B6B4260C04;
        Fri, 19 Mar 2021 21:25:27 +0000 (UTC)
Date:   Fri, 19 Mar 2021 22:25:26 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 2/3] libbpf: skip BTF fixup if object file has
 no BTF
Message-ID: <YFUWxkbBjgSgwE3t@krava>
References: <20210319205909.1748642-1-andrii@kernel.org>
 <20210319205909.1748642-3-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319205909.1748642-3-andrii@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 01:59:08PM -0700, Andrii Nakryiko wrote:
> Skip BTF fixup step when input object file is missing BTF altogether.
> 
> Reported-by: Jiri Olsa <jolsa@redhat.com>
> Fixes: 8fd27bf69b86 ("libbpf: Add BPF static linker BTF and BTF.ext support")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Tested-by: Jiri Olsa <jolsa@redhat.com>

thanks for the quick fix,
jirka

> ---
>  tools/lib/bpf/linker.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
> index b4fff912dce2..5e0aa2f2c0ca 100644
> --- a/tools/lib/bpf/linker.c
> +++ b/tools/lib/bpf/linker.c
> @@ -1313,6 +1313,9 @@ static int linker_fixup_btf(struct src_obj *obj)
>  	struct src_sec *sec;
>  	int i, j, n, m;
>  
> +	if (!obj->btf)
> +		return 0;
> +
>  	n = btf__get_nr_types(obj->btf);
>  	for (i = 1; i <= n; i++) {
>  		struct btf_var_secinfo *vi;
> -- 
> 2.30.2
> 

