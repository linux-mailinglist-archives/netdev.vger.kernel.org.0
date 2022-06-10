Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A47A547056
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 02:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345555AbiFJXxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 19:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238092AbiFJXxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 19:53:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029C51FD9E1
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 16:53:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9286B61EFF
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 23:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FDAC3411E
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 23:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654905222;
        bh=+PeEGQ6Igb1z6F30Kxsqbhw0W2DldBykXJhhV9YHoMI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XE32XxSHmM7kCEBVrzmCbP3GJD5yppezI45/UHhlGjc67otfGOSPDPquhcubqP8qe
         8BR61WhUUdvXqFjl7Ndo+rYPRhq5M3jxkhvpinazvs2/p+T6scbS+yicTDZzL2Aoi0
         LWRZjV8kw6iRjay1cWqWBpGkCp6dqYg/xWeKoNdzI1VbO26HsHVcwmCLqmS57b+pbB
         TnO8f3JfgXaXLnr6bDR2BRZVDb6BDfupHuqZNKKpsiBV4GNAWy0PI03yCdm1ZAxBr4
         dNmWaRfPVRuZ2tUeY1uLizMIfu+CJjB27ep1YZleBL9S+PHCUrCGsHysi365RFxLrA
         okm5pcpcJdpVQ==
Received: by mail-yb1-f178.google.com with SMTP id w2so1114359ybi.7
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 16:53:41 -0700 (PDT)
X-Gm-Message-State: AOAM532iwY9G/TxgZ+htYaE//XWUSsUG3ssZvY+SVN+dsCONn7VRvrEH
        RGV7VhUN8qW1+QEFL6yvZXSg3g6g3+dpwhxu9Erzlw==
X-Google-Smtp-Source: ABdhPJwse+Or1E8emKNDEBSV3nktvRTXKzz9CodhKJHQp1njHv+UGR1luR1niIAEUtD85YNfISnuJY224T7rZaOYyzc=
X-Received: by 2002:a05:6902:1502:b0:663:3851:1aa with SMTP id
 q2-20020a056902150200b00663385101aamr35292663ybu.65.1654905220993; Fri, 10
 Jun 2022 16:53:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220610135916.1285509-1-roberto.sassu@huawei.com>
 <20220610135916.1285509-2-roberto.sassu@huawei.com> <ce56c551-019f-9e10-885f-4e88001a8f6b@iogearbox.net>
 <4b877d4877be495787cb431d0a42cbc9@huawei.com> <1a5534e6-4d63-7c91-8dcd-41b22f1ea2ba@iogearbox.net>
In-Reply-To: <1a5534e6-4d63-7c91-8dcd-41b22f1ea2ba@iogearbox.net>
From:   KP Singh <kpsingh@kernel.org>
Date:   Sat, 11 Jun 2022 01:53:30 +0200
X-Gmail-Original-Message-ID: <CACYkzJ7-b7orpuUf-Uy7zLGufi8JJFGyWeH0SKwS_GsZVdQWeg@mail.gmail.com>
Message-ID: <CACYkzJ7-b7orpuUf-Uy7zLGufi8JJFGyWeH0SKwS_GsZVdQWeg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] bpf: Add bpf_verify_signature() helper
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Roberto Sassu <roberto.sassu@huawei.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 5:14 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 6/10/22 4:59 PM, Roberto Sassu wrote:
> >> From: Daniel Borkmann [mailto:daniel@iogearbox.net]
> >> Sent: Friday, June 10, 2022 4:49 PM
> >> On 6/10/22 3:59 PM, Roberto Sassu wrote:
> >>> Add the bpf_verify_signature() helper, to give eBPF security modules the
> >>> ability to check the validity of a signature against supplied data, by
> >>> using system-provided keys as trust anchor.
> >>>
> >>> The new helper makes it possible to enforce mandatory policies, as eBPF
> >>> programs might be allowed to make security decisions only based on data
> >>> sources the system administrator approves.
> >>>
> >>> The caller should specify the identifier of the keyring containing the keys
> >>> for signature verification: 0 for the primary keyring (immutable keyring of
> >>> system keys); 1 for both the primary and secondary keyring (where keys can
> >>> be added only if they are vouched for by existing keys in those keyrings);
> >>> 2 for the platform keyring (primarily used by the integrity subsystem to
> >>> verify a kexec'ed kerned image and, possibly, the initramfs signature);
> >>> 0xffff for the session keyring (for testing purposes).
> >>>
> >>> The caller should also specify the type of signature. Currently only PKCS#7
> >>> is supported.
> >>>
> >>> Since the maximum number of parameters of an eBPF helper is 5, the keyring
> >>> and signature types share one (keyring ID: low 16 bits, signature type:
> >>> high 16 bits).
> >>>
> >>> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> >>> Reported-by: kernel test robot <lkp@intel.com> (cast warning)
> >>> ---
> >>>    include/uapi/linux/bpf.h       | 17 +++++++++++++
> >>>    kernel/bpf/bpf_lsm.c           | 46 ++++++++++++++++++++++++++++++++++
> >>>    tools/include/uapi/linux/bpf.h | 17 +++++++++++++
> >>>    3 files changed, 80 insertions(+)
> >>>
> >>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> >>> index f4009dbdf62d..97521857e44a 100644
> >>> --- a/include/uapi/linux/bpf.h
> >>> +++ b/include/uapi/linux/bpf.h
> >>> @@ -5249,6 +5249,22 @@ union bpf_attr {
> >>>     *               Pointer to the underlying dynptr data, NULL if the dynptr is
> >>>     *               read-only, if the dynptr is invalid, or if the offset and length
> >>>     *               is out of bounds.
> >>> + *
> >>> + * long bpf_verify_signature(u8 *data, u32 datalen, u8 *sig, u32 siglen, u32
> >> info)
> >>> + * Description
> >>> + *         Verify a signature of length *siglen* against the supplied data
> >>> + *         with length *datalen*. *info* contains the keyring identifier
> >>> + *         (low 16 bits) and the signature type (high 16 bits). The keyring
> >>> + *         identifier can have the following values (some defined in
> >>> + *         verification.h): 0 for the primary keyring (immutable keyring of
> >>> + *         system keys); 1 for both the primary and secondary keyring
> >>> + *         (where keys can be added only if they are vouched for by
> >>> + *         existing keys in those keyrings); 2 for the platform keyring
> >>> + *         (primarily used by the integrity subsystem to verify a kexec'ed
> >>> + *         kerned image and, possibly, the initramfs signature); 0xffff for
> >>> + *         the session keyring (for testing purposes).
> >>> + * Return
> >>> + *         0 on success, a negative value on error.
> >>>     */
> >>>    #define __BPF_FUNC_MAPPER(FN)            \
> >>>     FN(unspec),                     \
> >>> @@ -5455,6 +5471,7 @@ union bpf_attr {
> >>>     FN(dynptr_read),                \
> >>>     FN(dynptr_write),               \
> >>>     FN(dynptr_data),                \
> >>> +   FN(verify_signature),           \
> >>>     /* */
> >>>
> >>>    /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> >>> diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> >>> index c1351df9f7ee..20bd850ea3ee 100644
> >>> --- a/kernel/bpf/bpf_lsm.c
> >>> +++ b/kernel/bpf/bpf_lsm.c
> >>> @@ -16,6 +16,8 @@
> >>>    #include <linux/bpf_local_storage.h>
> >>>    #include <linux/btf_ids.h>
> >>>    #include <linux/ima.h>
> >>> +#include <linux/verification.h>
> >>> +#include <linux/module_signature.h>
> >>>
> >>>    /* For every LSM hook that allows attachment of BPF programs, declare a
> >> nop
> >>>     * function where a BPF program can be attached.
> >>> @@ -132,6 +134,46 @@ static const struct bpf_func_proto
> >> bpf_get_attach_cookie_proto = {
> >>>     .arg1_type      = ARG_PTR_TO_CTX,
> >>>    };
> >>>
> >>> +#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
> >>> +BPF_CALL_5(bpf_verify_signature, u8 *, data, u32, datalen, u8 *, sig,
> >>> +      u32, siglen, u32, info)
> >>> +{
> >>> +   unsigned long keyring_id = info & U16_MAX;
> >>> +   enum pkey_id_type id_type = info >> 16;
> >>> +   const struct cred *cred = current_cred();
> >>> +   struct key *keyring;
> >>> +
> >>> +   if (keyring_id > (unsigned long)VERIFY_USE_PLATFORM_KEYRING &&
> >>> +       keyring_id != U16_MAX)
> >>> +           return -EINVAL;
> >>> +
> >>> +   keyring = (keyring_id == U16_MAX) ?
> >>> +             cred->session_keyring : (struct key *)keyring_id;
> >>> +
> >>> +   switch (id_type) {
> >>> +   case PKEY_ID_PKCS7:
> >>> +           return verify_pkcs7_signature(data, datalen, sig, siglen,
> >>> +                                         keyring,
> >>> +
> >> VERIFYING_UNSPECIFIED_SIGNATURE,
> >>> +                                         NULL, NULL);
> >>> +   default:
> >>> +           return -EOPNOTSUPP;
> >>
> >> Question to you & KP:
> >>
> >>   > Can we keep the helper generic so that it can be extended to more types of
> >>   > signatures and pass the signature type as an enum?
> >>
> >> How many different signature types do we expect, say, in the next 6mo, to land
> >> here? Just thinking out loud whether it is better to keep it simple as with the
> >> last iteration where we have a helper specific to pkcs7, and if needed in future
> >> we add others. We only have the last reg as auxillary arg where we need to
> >> squeeze
> >> all info into it now. What if for other, future signature types this won't suffice?
> >
> > I would add at least another for PGP, assuming that the code will be
> > upstreamed. But I agree, the number should not be that high.
>
> If realistically expected is really just two helpers, what speaks against a
> bpf_verify_signature_pkcs7() and bpf_verify_signature_pgp() in that case, for
> sake of better user experience?
>
> Maybe one other angle.. if CONFIG_SYSTEM_DATA_VERIFICATION is enabled, it may
> not be clear whether verify_pkcs7_signature() or a verify_pgp_signature() are
> both always builtin. And then, we run into the issue again of more complex probing
> for availability of the algs compared to simple ...
>
> #if defined(CONFIG_SYSTEM_DATA_VERIFICATION) && defined(CONFIG_XYZ)
>         case BPF_FUNC_verify_signature_xyz:
>                 return ..._proto;
> #endif
>
> ... which bpftool and others easily understand.
>
> >>> +   }
> >>> +}
> >>> +
> >>> +static const struct bpf_func_proto bpf_verify_signature_proto = {
> >>> +   .func           = bpf_verify_signature,
> >>> +   .gpl_only       = false,
> >>> +   .ret_type       = RET_INTEGER,
> >>> +   .arg1_type      = ARG_PTR_TO_MEM,
> >>> +   .arg2_type      = ARG_CONST_SIZE_OR_ZERO,
> >>
> >> Can verify_pkcs7_signature() handle null/0 len for data* args?
> >
> > Shouldn't ARG_PTR_TO_MEM require valid memory? 0 len should
> > not be a problem.
>
> check_helper_mem_access() has:
>
>       /* Allow zero-byte read from NULL, regardless of pointer type */
>       if (zero_size_allowed && access_size == 0 &&
>           register_is_null(reg))
>               return 0;

Daniel, makes a fair point here. Alexei, what do you think?

I wonder if some "future" signature verification would need even more
/ different arguments so a unified bpf_verify_signature might get more
complex / not easy to extend.


>
> So NULL/0 pair can be passed. Maybe good to add these corner cases to the test_progs
> selftest additions then if it's needed.
>
> >>> +   .arg3_type      = ARG_PTR_TO_MEM,
> >>> +   .arg4_type      = ARG_CONST_SIZE_OR_ZERO,
> >>
> >> Ditto for sig* args?
> >>
> >>> +   .arg5_type      = ARG_ANYTHING,
> >>> +   .allowed        = bpf_ima_inode_hash_allowed,
> >>> +};
> >>> +#endif
> >>> +
> >>>    static const struct bpf_func_proto *
> >>>    bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >>>    {
> >>> @@ -158,6 +200,10 @@ bpf_lsm_func_proto(enum bpf_func_id func_id,
> >> const struct bpf_prog *prog)
> >>>             return prog->aux->sleepable ? &bpf_ima_file_hash_proto :
> >> NULL;
> >>>     case BPF_FUNC_get_attach_cookie:
> >>>             return bpf_prog_has_trampoline(prog) ?
> >> &bpf_get_attach_cookie_proto : NULL;
> >>> +#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
> >>> +   case BPF_FUNC_verify_signature:
> >>> +           return prog->aux->sleepable ? &bpf_verify_signature_proto :
> >> NULL;
> >>> +#endif
> >>>     default:
> >>>             return tracing_prog_func_proto(func_id, prog);
> >>>     }
>
