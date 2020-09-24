Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7064277613
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 17:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbgIXP7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 11:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728381AbgIXP7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 11:59:48 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A505C0613CE;
        Thu, 24 Sep 2020 08:59:48 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id t76so4153991oif.7;
        Thu, 24 Sep 2020 08:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=qYYqLO5rrBj3F3Lv6FQhtSM3fobUZEnBhC277ef4YHM=;
        b=t/PJ4N38sRhSTRDCCaRn2eSpVrvp0fTsAwGzojlNMPMma7XF/vIlwrW/mQET4aeHuV
         t9L4WYS0nPnb7VSK1Onnb8XSKtLSJM4Ee2S10XW5fOjB2HwA3TU39oxohLV9WNUUq2Dp
         pt4jL7Z+uZJ49r1v7x2rvSkn/oBRQYEVwK1vcqKl683t4YZ9+KECLnvFE9K+dLQD3J5K
         EzgTAe9P5wZIEEv7VR1MIYhjC3vsyntt4bfAs46DaCaYwWWDkSHC9g+/FSPL7tWwrFOn
         vfas7Ja4S/JKxCO9jfAMViBQeJW9A+V7nsUeBFhlBsJPu2Br+6/NbQilWYjZFbYFOuoh
         kDXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=qYYqLO5rrBj3F3Lv6FQhtSM3fobUZEnBhC277ef4YHM=;
        b=GPh3iviQ064uUpg2Hd1+h076i5pa6bxCRi41gDcWX0VpPU4tOIPczbRBYiwjVOmjdd
         nLfw1sDVBxvcLPbEnn1Bt7WDddodlBKXeWZ25aXS9cPJxoGvR+S8+QFUwmuM78iDHNKL
         bx6fTsHb2Un8dVg3zRiT/B5eFhvhtWT/hQcQevzTXEKjNgNTx0BJmCpNtBXV7BNk24lD
         UhGmfI6TYJ+XN5rMuEJD7YdfFCekYEu6itDww7ybHhebAQ57q6LAFqyTJHaKuXwaiEbW
         G5JAdkXCdV2HAfjJ4H+VC28vHTenmFe/Hdhj47gxAbwPhOYCvHRh9Xu6Co5G/l3Ie8jO
         vPmw==
X-Gm-Message-State: AOAM532oMGEZ7t45H+3mQ0ENKM9Aqlz5r/D7mX0KC2z/SDjRyKrwa8fQ
        Yik1Nb5AJxuH9sfVh/gDRFU=
X-Google-Smtp-Source: ABdhPJx/u7tHF+kfbGG7uOOUSXFS59f4Bkime7I6rhLUjG5ZeLluBDECDmPThKFGYnC5I/wn7bRnPg==
X-Received: by 2002:aca:dcd7:: with SMTP id t206mr55498oig.134.1600963187574;
        Thu, 24 Sep 2020 08:59:47 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id h14sm888819otr.21.2020.09.24.08.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 08:59:46 -0700 (PDT)
Date:   Thu, 24 Sep 2020 08:59:40 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <5f6cc26c7f500_4939c20811@john-XPS-13-9370.notmuch>
In-Reply-To: <20200923155436.2117661-8-andriin@fb.com>
References: <20200923155436.2117661-1-andriin@fb.com>
 <20200923155436.2117661-8-andriin@fb.com>
Subject: RE: [PATCH bpf-next 7/9] libbpf: add BTF writing APIs
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Add APIs for appending new BTF types at the end of BTF object.
> 
> Each BTF kind has either one API of the form btf__append_<kind>(). For types
> that have variable amount of additional items (struct/union, enum, func_proto,
> datasec), additional API is provided to emit each such item. E.g., for
> emitting a struct, one would use the following sequence of API calls:
> 
> btf__append_struct(...);
> btf__append_field(...);
> ...
> btf__append_field(...);
> 
> Each btf__append_field() will ensure that the last BTF type is of STRUCT or
> UNION kind and will automatically increment that type's vlen field.
> 
> All the strings are provided as C strings (const char *), not a string offset.
> This significantly improves usability of BTF writer APIs. All such strings
> will be automatically appended to string section or existing string will be
> re-used, if such string was already added previously.
> 
> Each API attempts to do all the reasonable validations, like enforcing
> non-empty names for entities with required names, proper value bounds, various
> bit offset restrictions, etc.
> 
> Type ID validation is minimal because it's possible to emit a type that refers
> to type that will be emitted later, so libbpf has no way to enforce such
> cases. User must be careful to properly emit all the necessary types and
> specify type IDs that will be valid in the finally generated BTF.
> 
> Each of btf__append_<kind>() APIs return new type ID on success or negative
> value on error. APIs like btf__append_field() that emit additional items
> return zero on success and negative value on error.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

[...]

> +	/* deconstruct BTF, if necessary, and invalidate raw_data */
> +	if (btf_ensure_modifiable(btf))
> +		return -ENOMEM;
> +
> +	sz = sizeof(struct btf_type) + sizeof(int);
> +	t = btf_add_type_mem(btf, sz);
> +	if (!t)
> +		return -ENOMEM;
> +
> +	/* if something goes wrong later, we might end up with extra an string,

nit typo, 'with an extra string'

> +	 * but that shouldn't be a problem, because BTF can't be constructed
> +	 * completely anyway and will most probably be just discarded
> +	 */
> +	name_off = btf__add_str(btf, name);
> +	if (name_off < 0)
> +		return name_off;
> +
> +	t->name_off = name_off;
> +	t->info = btf_type_info(BTF_KIND_INT, 0, 0);
> +	t->size = byte_sz;
> +	/* set INT info, we don't allow setting legacy bit offset/size */
> +	*(__u32 *)(t + 1) = (encoding << 24) | (byte_sz * 8);
> +
> +	err = btf_add_type_idx_entry(btf, btf->hdr->type_len);
> +	if (err)
> +		return err;
> +
> +	btf->hdr->type_len += sz;
> +	btf->hdr->str_off += sz;
> +	btf->nr_types++;
> +	return btf->nr_types;
> +}
> +
