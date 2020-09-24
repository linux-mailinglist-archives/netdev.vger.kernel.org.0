Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62322775FF
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 17:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbgIXP4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 11:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728139AbgIXP4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 11:56:24 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD6FC0613CE;
        Thu, 24 Sep 2020 08:56:24 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id 185so4106937oie.11;
        Thu, 24 Sep 2020 08:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=/4xdNrkwUSuMSV46GdCgOrG1zks0NPpQjLTKi8zYrVQ=;
        b=H+uPvnNSlZTyToldPVH8O5gF4XgJpjyxNb2OEqak+0fVbU5wcIqbEJC/uvCJXExPjn
         no/s+ylAajg2cVPgE09FDSdAoNDjvjqC5bRX1iKLCUsyIYpoZtEY9c3/QHDLE8cayc/Q
         qb9al581I0/KIjc6PVNW3rx3niOsoZVMdGmkvLfw1l7P5Zujv5cUtAixnaqrxx6NZIbk
         zzokJraq0LFXZlt+ZOvi3FcebMOMvPdZCT1j1Dm+YphblE9gU9OnnRMlXsa8Bm4wLTWd
         /qfh8k10P80MuUPpeT9YWzUGCXmWZB4xnjfJbERqf4Ms6D+2jXlqBkt6WOLZfbSgs9BM
         HsCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=/4xdNrkwUSuMSV46GdCgOrG1zks0NPpQjLTKi8zYrVQ=;
        b=KE9N4LtJEtT79rKUNO1dBIdCc2Ka836Qg7yYPQV02pdkJjm8itutGx/w8AH8qpORoM
         EDAuSvQOFokMrbYTOX6gzSi3TmL10fybO5QRQI+vlgOZy3D2Yp7R+d8YEWjC7prO3ckt
         YhZtbSrvTsIJM0FqK2PjWDlCX7clexzurJoMjbGf7cMZyojpGAoTJCXBYxWWSKLFKFiO
         ObkBYlKqNvK2kEROByGSHvOwTLNp98ioxwkhhGALyuskHI9q+kjhktTT8tAjGWMcfNHK
         wVFymbxWp0Tvr365dT6VWqYuNYweJJkXdcRmttRRUkWVVdNrsGrLZAjPjnvW73bx5VPv
         M3OQ==
X-Gm-Message-State: AOAM530A2ufv2nhEEm3x5RSYBHX79Z8aTGXJkAsmb89uYxKZKwad3NSJ
        Hcyj5O8+N9zb/k2qD9dO0mA=
X-Google-Smtp-Source: ABdhPJxstb9ASTPDPQi+4KTrpAuJEI7sKfkhYDb8D3sIr7IgZUQ5RP6bq07HiM+ckVOJaCdVQfrF7g==
X-Received: by 2002:aca:1311:: with SMTP id e17mr35964oii.43.1600962984206;
        Thu, 24 Sep 2020 08:56:24 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t22sm879939otq.44.2020.09.24.08.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 08:56:23 -0700 (PDT)
Date:   Thu, 24 Sep 2020 08:56:17 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <5f6cc1a188bdf_4939c208e1@john-XPS-13-9370.notmuch>
In-Reply-To: <20200923155436.2117661-6-andriin@fb.com>
References: <20200923155436.2117661-1-andriin@fb.com>
 <20200923155436.2117661-6-andriin@fb.com>
Subject: RE: [PATCH bpf-next 5/9] libbpf: allow modification of BTF and add
 btf__add_str API
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Allow internal BTF representation to switch from default read-only mode, in
> which raw BTF data is a single non-modifiable block of memory with BTF header,
> types, and strings layed out sequentially and contiguously in memory, into
> a writable representation with types and strings data split out into separate
> memory regions, that can be dynamically expanded.
> 
> Such writable internal representation is transparent to users of libbpf APIs,
> but allows to append new types and strings at the end of BTF, which is
> a typical use case when generating BTF programmatically. All the basic
> guarantees of BTF types and strings layout is preserved, i.e., user can get
> `struct btf_type *` pointer and read it directly. Such btf_type pointers might
> be invalidated if BTF is modified, so some care is required in such mixed
> read/write scenarios.
> 
> Switch from read-only to writable configuration happens automatically the
> first time when user attempts to modify BTF by either adding a new type or new
> string. It is still possible to get raw BTF data, which is a single piece of
> memory that can be persisted in ELF section or into a file as raw BTF. Such
> raw data memory is also still owned by BTF and will be freed either when BTF
> object is freed or if another modification to BTF happens, as any modification
> invalidates BTF raw representation.
> 
> This patch adds the first BTF writing API: btf__add_str(), which allows to
> add arbitrary strings to BTF string section. All the added strings are
> automatically deduplicated. This is achieved by maintaining an additional
> string lookup index for all unique strings. Such index is built when BTF is
> switched to modifiable mode. If at that time BTF strings section contained
> duplicate strings, they are not de-duplicated. This is done specifically to
> not modify the existing content of BTF (types, their string offsets, etc),
> which can cause confusion and is especially important property if there is
> struct btf_ext associated with struct btf. By following this "imperfect
> deduplication" process, btf_ext is kept consitent and correct. If
> deduplication of strings is necessary, it can be forced by doing BTF
> deduplication, at which point all the strings will be eagerly deduplicated and
> all string offsets both in struct btf and struct btf_ext will be updated.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

[...]

> +/* Ensure BTF is ready to be modified (by splitting into a three memory
> + * regions for header, types, and strings). Also invalidate cached
> + * raw_data, if any.
> + */
> +static int btf_ensure_modifiable(struct btf *btf)
> +{
> +	void *hdr, *types, *strs, *strs_end, *s;
> +	struct hashmap *hash = NULL;
> +	long off;
> +	int err;
> +
> +	if (btf_is_modifiable(btf)) {
> +		/* any BTF modification invalidates raw_data */
> +		if (btf->raw_data) {

I missed why this case is needed? Just being cautious? It looks like
we get btf->hdr != btf->raw_data (aka btf_is_modifiable) below, but
by the tiime we do this set it looks like we will always null btf->raw_data
as well. Again doesn't appear harmful just seeing if I missed a path.

> +			free(btf->raw_data);
> +			btf->raw_data = NULL;
> +		}
> +		return 0;
> +	}
> +
> +	/* split raw data into three memory regions */
> +	hdr = malloc(btf->hdr->hdr_len);
> +	types = malloc(btf->hdr->type_len);
> +	strs = malloc(btf->hdr->str_len);
> +	if (!hdr || !types || !strs)
> +		goto err_out;
> +
> +	memcpy(hdr, btf->hdr, btf->hdr->hdr_len);
> +	memcpy(types, btf->types_data, btf->hdr->type_len);
> +	memcpy(strs, btf->strs_data, btf->hdr->str_len);
> +
> +	/* build lookup index for all strings */
> +	hash = hashmap__new(strs_hash_fn, strs_hash_equal_fn, btf);
> +	if (IS_ERR(hash)) {
> +		err = PTR_ERR(hash);
> +		hash = NULL;
> +		goto err_out;
> +	}
> +

[...]

Thanks,
John
