Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DE648CAB4
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356095AbiALSKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356135AbiALSJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:09:54 -0500
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD84DC06118A
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 10:09:38 -0800 (PST)
Received: by mail-ua1-x929.google.com with SMTP id o1so6442725uap.4
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 10:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RrVsAsvO3D7WLJP8VoagnnBtokXlR5KaoCYpWZZ+S6g=;
        b=QyT7lmiM4MWwNqhlQNOfaW9erGjhLEq4pdbvMCDGT5LsOgfCXPMxi4APOTDRsYnGoB
         pPcR7M09KhL3RPgClDMnlMcD0iTO71mYDe7lCuVoo4NPukAM0KdbP8rIVUA7F0edC+CY
         E4rTVVbP/a/5qTtPBlw1YdRgkjI9JSUbBKb+lhE2wsa00TBuk90wDjRkLZZzLQxwsfFa
         /sSKyFQxrxZutMKUd1Rz2A7LRE3XDC47DRPm4jJF64DBxWofkY5OZl2mv5QOwixecbLu
         3v9yW40BRmo0MmJxvFrLvLvfglDXXFkrJ/b+T/dbA8F8Xig+CnlHmRNKT2tpK1J/rj9x
         mw6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RrVsAsvO3D7WLJP8VoagnnBtokXlR5KaoCYpWZZ+S6g=;
        b=FD7QpnpTs1NGbIYes3zbtC8DJv1u5NxeMUpMltbnj3egAXqdLUymwgtc+DCchnm9jk
         SKzvAcBcts98H/MsYbuxhb+r3IUlvDhvhnWoUBPDbJdxh4yEJFz01XnD0U7GWhAL1jTN
         nQjkLuppjL0gDFVrYMjS0Nxbp/lJNq79Pyc6wLxTWdS0myNRpiec4HF6vBPkRl3y4ZWx
         IndRjfe4FaGsksjLSWCowY1YQYwgO0kmRVpG1LrCNLit6QnrAuatTt4aa/aN7XriKVRM
         g87atPLrFgTRFNz/ZFVxJnLqgdalvrHKiecKOkA0bobBcrpuCN8ydoWsPxmmQ3gYJ1r5
         kS4g==
X-Gm-Message-State: AOAM531fcc3sdg3wsQj4DFqeeSTO650HXwAtLudaIML2DoPKH3u6aQGd
        9517PrKKZU4xN1TTGTMwJZfTtiM3qAdHAw==
X-Google-Smtp-Source: ABdhPJwrdnXS74LH2P//Rph783Mk3d+YCMDm6hkSUTni5HY9pRQEPXpGP4gADoLr57ZeR6srN9wtOA==
X-Received: by 2002:a67:ba17:: with SMTP id l23mr638199vsn.33.1642010977839;
        Wed, 12 Jan 2022 10:09:37 -0800 (PST)
Received: from [192.168.1.8] ([149.86.74.57])
        by smtp.gmail.com with ESMTPSA id d4sm275686vkf.39.2022.01.12.10.09.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 10:09:37 -0800 (PST)
Message-ID: <c902c194-06f9-52e5-abf1-a96682eca519@isovalent.com>
Date:   Wed, 12 Jan 2022 18:09:35 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH bpf-next v4 7/8] bpftool: Implement relocations recording
 for BTFGen
Content-Language: en-GB
To:     =?UTF-8?Q?Mauricio_V=c3=a1squez?= <mauricio@kinvolk.io>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
References: <20220112142709.102423-1-mauricio@kinvolk.io>
 <20220112142709.102423-8-mauricio@kinvolk.io>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20220112142709.102423-8-mauricio@kinvolk.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-01-12 09:27 UTC-0500 ~ Mauricio Vásquez <mauricio@kinvolk.io>
> This commit implements the logic to record the relocation information
> for the different kind of relocations.
> 
> btfgen_record_field_relo() uses the target specification to save all the
> types that are involved in a field-based CO-RE relocation. In this case
> types resolved and added recursively (using btfgen_put_type()).
> Only the struct and union members and their types) involved in the
> relocation are added to optimize the size of the generated BTF file.
> 
> On the other hand, btfgen_record_type_relo() saves the types involved in
> a type-based CO-RE relocation. In this case all the members for the
> struct and union types are added. This is not strictly required since
> libbpf doesn't use them while performing this kind of relocation,
> however that logic could change on the future. Additionally, we expect
> that the number of this kind of relocations in an BPF object to be very
> low, hence the impact on the size of the generated BTF should be
> negligible.
> 
> Finally, btfgen_record_enumval_relo() saves the whole enum type for
> enum-based relocations.
> 
> Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  tools/bpf/bpftool/gen.c | 260 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 257 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> index cef0ea99d4d9..8c13dde0b74d 100644
> --- a/tools/bpf/bpftool/gen.c
> +++ b/tools/bpf/bpftool/gen.c
> @@ -1207,19 +1228,252 @@ btfgen_new_info(const char *targ_btf_path)

> +static struct btfgen_type *
> +_btfgen_put_type(struct btf *btf, struct btfgen_info *info, struct btf_type *btf_type,
> +		 unsigned int id, bool all_members)
> +{
> +	struct btfgen_type *btfgen_type, *tmp;
> +	struct btf_array *array;
> +	unsigned int child_id;
> +	struct btf_member *m;
> +	int err, i, n;
> +
> +	/* check if we already have this type */
> +	if (hashmap__find(info->types, uint_as_hash_key(id), (void **) &btfgen_type)) {
> +		if (!all_members || btfgen_type->all_members)
> +			return btfgen_type;
> +	} else {
> +		btfgen_type = calloc(1, sizeof(*btfgen_type));
> +		if (!btfgen_type)
> +			return NULL;
> +
> +		btfgen_type->type = btf_type;
> +		btfgen_type->id = id;
> +
> +		/* append this type to the types list before anything else */
> +		err = hashmap__add(info->types, uint_as_hash_key(btfgen_type->id), btfgen_type);
> +		if (err) {
> +			free(btfgen_type);
> +			return NULL;
> +		}
> +	}
> +
> +	/* avoid infinite recursion and yet be able to add all
> +	 * fields/members for types also managed by this function
> +	 */
> +	btfgen_type->all_members = all_members;
> +
> +

Nit: double blank line.

> +	/* recursively add other types needed by it */
> +	switch (btf_kind(btfgen_type->type)) {
> +	case BTF_KIND_UNKN:
> +	case BTF_KIND_INT:

>  static int btfgen_record_field_relo(struct btfgen_info *info, struct bpf_core_spec *targ_spec)
>  {
> -	return -EOPNOTSUPP;
> +	struct btf *btf = (struct btf *) info->src_btf;
> +	struct btfgen_type *btfgen_type;
> +	struct btf_member *btf_member;
> +	struct btf_type *btf_type;
> +	struct btf_array *array;
> +	unsigned int id;
> +	int idx, err;
> +
> +	btf_type = (struct btf_type *) btf__type_by_id(btf, targ_spec->root_type_id);
> +
> +	/* create btfgen_type for root type */
> +	btfgen_type = btfgen_put_type(btf, info, btf_type, targ_spec->root_type_id);
> +	if (!btfgen_type)
> +		return -errno;
> +
> +	/* add types for complex types (arrays, unions, structures) */
> +	for (int i = 1; i < targ_spec->raw_len; i++) {
> +		/* skip typedefs and mods */
> +		while (btf_is_mod(btf_type) || btf_is_typedef(btf_type)) {
> +			id = btf_type->type;
> +			btfgen_type = btfgen_get_type(info, id);
> +			if (!btfgen_type)
> +				return -ENOENT;
> +			btf_type = (struct btf_type *) btf__type_by_id(btf, id);
> +		}
> +
> +		switch (btf_kind(btf_type)) {
> +		case BTF_KIND_STRUCT:
> +		case BTF_KIND_UNION:
> +			idx = targ_spec->raw_spec[i];
> +			btf_member = btf_members(btf_type) + idx;
> +			btf_type = (struct btf_type *) btf__type_by_id(btf, btf_member->type);
> +
> +			/* add member to relocation type */
> +			err = btfgen_add_member(btfgen_type, btf_member, idx);
> +			if (err)
> +				return err;
> +			/* put btfgen type */
> +			btfgen_type = btfgen_put_type(btf, info, btf_type, btf_member->type);
> +			if (!btfgen_type)
> +				return -errno;
> +			break;
> +		case BTF_KIND_ARRAY:
> +			array = btf_array(btf_type);
> +			btfgen_type = btfgen_get_type(info, array->type);
> +			if (!btfgen_type)
> +				return -ENOENT;
> +			btf_type = (struct btf_type *) btf__type_by_id(btf, array->type);
> +			break;
> +		default:
> +			p_err("spec type wasn't handled");

This message might benefit from a bit more context (step, type number?).

> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
>  }
>  
>  static int btfgen_record_type_relo(struct btfgen_info *info, struct bpf_core_spec *targ_spec)
>  {
> -	return -EOPNOTSUPP;
> +	struct btf *btf = (struct btf *) info->src_btf;
> +	struct btfgen_type *btfgen_type;
> +	struct btf_type *btf_type;
> +
> +	btf_type = (struct btf_type *) btf__type_by_id(btf, targ_spec->root_type_id);
> +
> +	btfgen_type = btfgen_put_type_all(btf, info, btf_type, targ_spec->root_type_id);
> +	return btfgen_type ?  0 : -errno;

Nit: double space in "?  0".

>  }
>  
>  static int btfgen_record_enumval_relo(struct btfgen_info *info, struct bpf_core_spec *targ_spec)
>  {
> -	return -EOPNOTSUPP;
> +	struct btf *btf = (struct btf *) info->src_btf;
> +	struct btfgen_type *btfgen_type;
> +	struct btf_type *btf_type;
> +
> +	btf_type = (struct btf_type *) btf__type_by_id(btf, targ_spec->root_type_id);
> +
> +	btfgen_type = btfgen_put_type_all(btf, info, btf_type, targ_spec->root_type_id);
> +	return btfgen_type ?  0 : -errno;

Nit: double space in "?  0".

>  }
>  
>  static int btfgen_record_reloc(struct btfgen_info *info, struct bpf_core_spec *res)

