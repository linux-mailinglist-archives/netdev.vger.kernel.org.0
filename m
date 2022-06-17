Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5851F54EFCE
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 05:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379503AbiFQDqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 23:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiFQDqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 23:46:23 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6241665D09;
        Thu, 16 Jun 2022 20:46:22 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id w29so2984586pgl.8;
        Thu, 16 Jun 2022 20:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zMFxF1dps3FFy1Csp9JLYJx8ndjCnJRCu+jFZkoArKo=;
        b=HtTeHOo9BHWbZoHy/pEv3QUVXbb9ShKGBsOT1QulYweyqQk7hyNpRHeLGVzEKQ98rT
         JhESAdD0IYdJimorX5NKxFe9s6hye5CCDY+Un/+vEUROS708QRbZQOWC2o1kxdgBm5pw
         /1N7/Vr/YANbYYjYq5vlCVzOMKTQtofoHcFL64hezXuz71Jh1eggkn7SEzeQE//zfp9k
         zahhZYHZSTE3gj/+a9dVJcp2gKFmaz+hr2BGMB8vFcDAfknHXgxOxQkWh88KN3cQYEZm
         E68Iy9ragbxNdALvT5l1T1dp6Djpv3d8Ah6/mgAt/V+4/F9An7m5PMKOLg4TpxbXyobD
         Tb7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zMFxF1dps3FFy1Csp9JLYJx8ndjCnJRCu+jFZkoArKo=;
        b=yCoKoAYxIN7UgG3dH5PnLkJ4jVsdqg4kg1Sxy9+gIabcAcJbgKc9zV0sGozys2WGDS
         ug8rdX971vMXnQVLJ3eok0ToWp+SBv5GMKC7xCYRDJwfig3mP0Y5kurph8h5lfPb6UA9
         X2p089iuW/reVuTSIWEesYvssyOUjLaltZqgzd8fvytQXfCLYO/S+6WyIbIql9/1vcyY
         fohpRv8hoCBapMPen34vMogZXbBlhzzS0pJ49oPp4ydpisCUTd5jqxIgo7EXB10gWs/v
         YpiWgFdIctAMByGZkQPfi4zWSSHKslRT/JZpUc3gITLEJ7RJKnN7CT8LYw27bbCMv8I4
         YPHg==
X-Gm-Message-State: AJIora/DcD6qmYPKR3m4MJJ8A+DKMNRyRO+Bsm+6M3OO6Udh8RGlN4b3
        tiuExH8+sxdLFJZJcZbeTzM=
X-Google-Smtp-Source: AGRyM1tNfMAJ6rxox42YsjqzmdmTHXZxY7Lk4uwn4jVj4c3LfYwcHs1HZUCuTQFAQRMDLD1Wm8zIzA==
X-Received: by 2002:a05:6a00:24c1:b0:518:c52f:f5 with SMTP id d1-20020a056a0024c100b00518c52f00f5mr8045022pfv.15.1655437581704;
        Thu, 16 Jun 2022 20:46:21 -0700 (PDT)
Received: from MacBook-Pro-3.local ([2620:10d:c090:400::5:29cb])
        by smtp.gmail.com with ESMTPSA id i135-20020a62878d000000b0051baeb06c0bsm2481532pfe.168.2022.06.16.20.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 20:46:20 -0700 (PDT)
Date:   Thu, 16 Jun 2022 20:46:17 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kpsingh@kernel.org, john.fastabend@gmail.com,
        songliubraving@fb.com, kafai@fb.com, yhs@fb.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH v4 2/4] bpf: Add bpf_request_key_by_id() helper
Message-ID: <20220617034617.db23phfavuhqx4vi@MacBook-Pro-3.local>
References: <20220614130621.1976089-1-roberto.sassu@huawei.com>
 <20220614130621.1976089-3-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614130621.1976089-3-roberto.sassu@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 03:06:19PM +0200, Roberto Sassu wrote:
> Add the bpf_request_key_by_id() helper, so that an eBPF program can obtain
> a suitable key pointer to pass to the bpf_verify_pkcs7_signature() helper,
> to be introduced in a later patch.
> 
> The passed identifier can have the following values: 0 for the primary
> keyring (immutable keyring of system keys); 1 for both the primary and
> secondary keyring (where keys can be added only if they are vouched for by
> existing keys in those keyrings); 2 for the platform keyring (primarily
> used by the integrity subsystem to verify a kexec'ed kerned image and,
> possibly, the initramfs signature); ULONG_MAX for the session keyring (for
> testing purposes).
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  include/uapi/linux/bpf.h       | 17 +++++++++++++++++
>  kernel/bpf/bpf_lsm.c           | 30 ++++++++++++++++++++++++++++++
>  scripts/bpf_doc.py             |  2 ++
>  tools/include/uapi/linux/bpf.h | 17 +++++++++++++++++
>  4 files changed, 66 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index f4009dbdf62d..dfd93e0e0759 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5249,6 +5249,22 @@ union bpf_attr {
>   *		Pointer to the underlying dynptr data, NULL if the dynptr is
>   *		read-only, if the dynptr is invalid, or if the offset and length
>   *		is out of bounds.
> + *
> + * struct key *bpf_request_key_by_id(unsigned long id)
> + *	Description
> + *		Request a keyring by *id*.
> + *
> + *		*id* can have the following values (some defined in
> + *		verification.h): 0 for the primary keyring (immutable keyring of
> + *		system keys); 1 for both the primary and secondary keyring
> + *		(where keys can be added only if they are vouched for by
> + *		existing keys in those keyrings); 2 for the platform keyring
> + *		(primarily used by the integrity subsystem to verify a kexec'ed
> + *		kerned image and, possibly, the initramfs signature); ULONG_MAX
> + *		for the session keyring (for testing purposes).

It's never ok to add something like this to uapi 'for testing purposes'.
If it's not useful in general it should not be a part of api.

> + *	Return
> + *		A non-NULL pointer if *id* is valid and not 0, a NULL pointer
> + *		otherwise.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -5455,6 +5471,7 @@ union bpf_attr {
>  	FN(dynptr_read),		\
>  	FN(dynptr_write),		\
>  	FN(dynptr_data),		\
> +	FN(request_key_by_id),		\
>  	/* */
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> index c1351df9f7ee..e1911812398b 100644
> --- a/kernel/bpf/bpf_lsm.c
> +++ b/kernel/bpf/bpf_lsm.c
> @@ -16,6 +16,7 @@
>  #include <linux/bpf_local_storage.h>
>  #include <linux/btf_ids.h>
>  #include <linux/ima.h>
> +#include <linux/verification.h>
>  
>  /* For every LSM hook that allows attachment of BPF programs, declare a nop
>   * function where a BPF program can be attached.
> @@ -132,6 +133,31 @@ static const struct bpf_func_proto bpf_get_attach_cookie_proto = {
>  	.arg1_type	= ARG_PTR_TO_CTX,
>  };
>  
> +#ifdef CONFIG_KEYS
> +BTF_ID_LIST_SINGLE(bpf_request_key_by_id_btf_ids, struct, key)
> +
> +BPF_CALL_1(bpf_request_key_by_id, unsigned long, id)
> +{
> +	const struct cred *cred = current_cred();
> +
> +	if (id > (unsigned long)VERIFY_USE_PLATFORM_KEYRING && id != ULONG_MAX)
> +		return (unsigned long)NULL;
> +
> +	if (id == ULONG_MAX)
> +		return (unsigned long)cred->session_keyring;
> +
> +	return id;

It needs to do a proper lookup.
Why cannot it do lookup_user_key ?
The helper needs 'flags' arg too.
Please think hard of extensibility and long term usefulness of api.
At present this api feels like it was 'let me just hack something quickly'. Not ok.
