Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA2333E915
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 06:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhCQFZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 01:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhCQFZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 01:25:54 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC71C06174A;
        Tue, 16 Mar 2021 22:25:43 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id z5so219210plg.3;
        Tue, 16 Mar 2021 22:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KcqxUj3j8T6ryjGM00EU1zzWeKnK/QJs+4fS2qE40zs=;
        b=TQmTSTT3xntrzkN9Cc3zlKcpReObbFirA5zEksBM698bDFZNw06S6uFVgaKI/Cf8JM
         dZ7XpzasZJ+ApaFTSDIm70WpDs95NHIkZxmBUAcNr2nXRKY8DKyaFbmQwT7OVL3xuubX
         4fp9oJKkQwzKqadnUpXk20JMTbT9PiNLtQQp8l/TQb158CIDZFwOAyx7txuk2e3L7y2s
         euVkpjn/hjtsMlnvlmzSgeYMHIPjIjZccVtMShErsnvvkrrxIRA34ICF76OK7P4RFsg2
         1ydKZy/ak3tPMiUXJxuc+qKV8O8SFIPMrxgb6TXevuzrYqjPKbFfOwghSnUVeyhjc7Kz
         CN8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KcqxUj3j8T6ryjGM00EU1zzWeKnK/QJs+4fS2qE40zs=;
        b=VthwBi9CY7dnP9MUsHCYaA/F+Iq+1oHuP/VdbYsYG3Dl0LbEH6mOPsS7/wk9SHFY7R
         5tNQjP73CxDi+7Ta6ZeTWcnkhXmshfGHj968TWZtNKQfeGKdoXZmIKeVWPwk7IbXcAiR
         nTf0LuPLCV6DmyA81bWA9Fg0bachGX86JMIS/K3gF8EUAHNbtqewWla+04mWa+Rii1+a
         UDexjA6NhR/6r2SInqt7pNdpg515hw62sAxJ95g1sLi9AAT4YNvYFlAOE6m7tifjtei2
         kkj3Nty010yYxU1+fkCv/FVtm/qyUslkLyUkmAadJR+78btQQukOvqE6S9bPT7gJmg8j
         LW2w==
X-Gm-Message-State: AOAM533hheMBjUlYwob0n5oX2f7sk1r6PN/Piihi9joU2/aMMw902cnK
        hFSqwPFKnKT3AmbC+y26UyQHfVVxW7Y=
X-Google-Smtp-Source: ABdhPJwfCQ1Mp9xn6qb7NTlh2tnbYvUaBNzuXyPqLWVW+oEzMxD0qvGERWMX/tLUOflve4fx0NAuGw==
X-Received: by 2002:a17:902:e884:b029:e5:fece:3bb0 with SMTP id w4-20020a170902e884b02900e5fece3bb0mr2933414plg.61.1615958742661;
        Tue, 16 Mar 2021 22:25:42 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:4c29])
        by smtp.gmail.com with ESMTPSA id j22sm1083194pjz.3.2021.03.16.22.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 22:25:42 -0700 (PDT)
Date:   Tue, 16 Mar 2021 22:25:40 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 07/11] libbpf: add BPF static linker BTF and
 BTF.ext support
Message-ID: <20210317052540.3f6epwcm6o5zwsdi@ast-mbp>
References: <20210313193537.1548766-1-andrii@kernel.org>
 <20210313193537.1548766-8-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210313193537.1548766-8-andrii@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 13, 2021 at 11:35:33AM -0800, Andrii Nakryiko wrote:
> +		for (j = 0; j < n; j++, src_var++) {
> +			void *sec_vars = dst_sec->sec_vars;
> +
> +			sec_vars = libbpf_reallocarray(sec_vars,
> +						       dst_sec->sec_var_cnt + 1,
> +						       sizeof(*dst_sec->sec_vars));
> +			if (!sec_vars)
> +				return -ENOMEM;
> +
> +			dst_sec->sec_vars = sec_vars;
> +			dst_sec->sec_var_cnt++;
> +
> +			dst_var = &dst_sec->sec_vars[dst_sec->sec_var_cnt - 1];
> +			dst_var->type = obj->btf_type_map[src_var->type];
> +			dst_var->size = src_var->size;
> +			dst_var->offset = src_sec->dst_off + src_var->offset;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void *add_btf_ext_rec(struct btf_ext_sec_data *ext_data, const void *src_rec)
> +{
> +	size_t new_sz = (ext_data->rec_cnt + 1) * ext_data->rec_sz;
> +	void *tmp;
> +
> +	tmp = realloc(ext_data->recs, new_sz);
> +	if (!tmp)
> +		return NULL;
> +
> +	ext_data->recs = tmp;
> +	ext_data->rec_cnt++;
> +
> +	tmp += new_sz - ext_data->rec_sz;
> +	memcpy(tmp, src_rec, ext_data->rec_sz);

while reading this and previous patch the cnt vs sz difference was
constantly throwing me off. Not a big deal, of course.
Did you consider using _cnt everywhere and use finalize method
to convert everything to size?
Like in this function libbpf_reallocarray() instead of realloc() would
probably be easier to read and more consistent, since btf_ext_sec_data
is measuring things in _cnt.
In the previous patch the section is in _sz which I guess is necessary
because sections can contain differently sized objects?

btw, strset abstraction is really nice. It made the patches much easier
to read.
