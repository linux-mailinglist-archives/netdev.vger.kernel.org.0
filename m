Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFA61DDC7A
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 03:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgEVBNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 21:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgEVBNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 21:13:39 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711C4C061A0E;
        Thu, 21 May 2020 18:13:39 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id z15so1719234pjb.0;
        Thu, 21 May 2020 18:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J9OXor2pPR7PP8VQa8yXLtkwnTg82Scyd6bPXPcXmDk=;
        b=qN0KGzZqI707WQjb07sWVwT7X/PMuejPeVb+WSP4rg2699uWXxdfC5ig06e4+gufkR
         AkjRvaUOCtozWRyFmPLgKRXyNawhxWnTGKtGpE+T490XjB0/terp3sfP8Xia7pAU4Dv+
         iRvK4B3Fc9AuHkiY6FnQ9V663OvpQzI74/zG+lnvcDJk7OGw+VvxLEjHUnnortqe2+db
         OMEBiBnC8EdNo1FeN26kd9aeYoEb7SHWV6MO0xP9adl9uivxbX77OAiwprQD1StGOotW
         f63WmEijWQZFG/r1LtGdf2YoujCGC3Z/7qMYnmlLYOeZTgrJgeMmnKcV9q0I8tHYpORh
         jftQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J9OXor2pPR7PP8VQa8yXLtkwnTg82Scyd6bPXPcXmDk=;
        b=fWq6cbizlzj/J0fnmsMiL7zk3n/jdl8rccw2H5QqxdHhAWpWeWvr+/kdsdSTzE8BuO
         /ylxBFOsCF+Z2JPpEVLOGeKHP1NdNC2WMn/XnlMFtejlR0NoMpGrJN+jyUH17mguI0S9
         soZmxVcrbAqCqHA8zlAx8m80PhUGng6rZEMiH9LbeL+6muwcgwHMJkIEee8FqVUdXANI
         6sS5gnAhFQCRjpxNfSjsQmzpENnwJqzhLBjLhALlEvKhfV1mBloBdC7g2k00Z0oZBKMa
         s26qyNELTYml/gXeGPL6cw9kC1LAZgVkSZPTJBGbvfo688ci0RT0if88JRCsGwKquAS9
         nfVA==
X-Gm-Message-State: AOAM532M2N2dX68uphAXXiT0ta1J6dnC4Yoicpitor0hwA8bAMA52+dc
        HjogPhRKrmwwvlekg/B0QE4=
X-Google-Smtp-Source: ABdhPJz1QpDU2Py3iBGb0zzwIny2bOfpiXzpaluMN8ji3anZIhtYTmhxC7YcSkPG1w7PBxSGcrTIzA==
X-Received: by 2002:a17:90a:fe0d:: with SMTP id ck13mr1438757pjb.182.1590110018954;
        Thu, 21 May 2020 18:13:38 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e680])
        by smtp.gmail.com with ESMTPSA id s94sm5595792pjb.20.2020.05.21.18.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 18:13:38 -0700 (PDT)
Date:   Thu, 21 May 2020 18:13:35 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/7] bpf: track reference type in verifier
Message-ID: <20200522011335.f4bfabh32puptotu@ast-mbp.dhcp.thefacebook.com>
References: <20200517195727.279322-1-andriin@fb.com>
 <20200517195727.279322-4-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200517195727.279322-4-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 17, 2020 at 12:57:23PM -0700, Andrii Nakryiko wrote:
>  
> +static enum bpf_ref_type get_release_ref_type(enum bpf_func_id func_id)
> +{
> +	switch (func_id) {
> +	case BPF_FUNC_sk_release:
> +		return BPF_REF_SOCKET;
> +	case BPF_FUNC_ringbuf_submit:
> +	case BPF_FUNC_ringbuf_discard:
> +		return BPF_REF_RINGBUF;
> +	default:
> +		return BPF_REF_INVALID;
> +	}
> +}
> +
>  static bool may_be_acquire_function(enum bpf_func_id func_id)
>  {
>  	return func_id == BPF_FUNC_sk_lookup_tcp ||
> @@ -464,6 +477,28 @@ static bool is_acquire_function(enum bpf_func_id func_id,
>  	return false;
>  }
>  
> +static enum bpf_ref_type get_acquire_ref_type(enum bpf_func_id func_id,
> +					      const struct bpf_map *map)
> +{
> +	enum bpf_map_type map_type = map ? map->map_type : BPF_MAP_TYPE_UNSPEC;
> +
> +	switch (func_id) {
> +	case BPF_FUNC_sk_lookup_tcp:
> +	case BPF_FUNC_sk_lookup_udp:
> +	case BPF_FUNC_skc_lookup_tcp:
> +		return BPF_REF_SOCKET;
> +	case BPF_FUNC_map_lookup_elem:
> +		if (map_type == BPF_MAP_TYPE_SOCKMAP ||
> +		    map_type == BPF_MAP_TYPE_SOCKHASH)
> +			return BPF_REF_SOCKET;
> +		return BPF_REF_INVALID;
> +	case BPF_FUNC_ringbuf_reserve:
> +		return BPF_REF_RINGBUF;
> +	default:
> +		return BPF_REF_INVALID;
> +	}
> +}

Two switch() stmts to convert helpers to REF is kinda hacky.
I think get_release_ref_type() could have got the ref's type as btf_id from its
arguments which would have made it truly generic and 'enum bpf_ref_type' would
be unnecessary, but sk_lookup_* helpers return u64 and don't have btf_id of
return value. I think we better fix that. Then btf_id would be that ref type.
