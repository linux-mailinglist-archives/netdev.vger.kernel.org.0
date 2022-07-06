Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F10D56968F
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbiGFXts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233947AbiGFXtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:49:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538092D1C5
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:49:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFC25B81E4E
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A1AC341CE
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657151379;
        bh=fQu2htsFT44q478MOdi5pVGALEfmok32wUDouba7C8E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nkDjswnwK+ss4/QExIKXU5HhnNG/+9N0dGaZVJytJSUxtxFm0h98mcQd/dvsU1V7G
         bnJHSfuH1dbVWBTh/g9g20Xo7ME5vQW2FmYal448H1eNXRxehbglDY6/+v5cLBJlQc
         z47zzkOpvkZydwSSYT1hvzwosQ4zi4lyn9fmwdrOPT9yr/UKeNmpwXk2yo4ZHcVnS7
         jhdWpMQyfKG1w9G+vcBzd624sgDYWjlUcCSGLgllWyAK55wBUKF1AUfVv4OvZeSDMX
         CL/3i5H2wyq/W5v/V5e+0AqRPnlSY3mgAiohANfO7YJfumWagmu1wKWyLZnrDaOcEO
         K+qc2OxqTTy7g==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-317a66d62dfso155199767b3.7
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 16:49:39 -0700 (PDT)
X-Gm-Message-State: AJIora/A1ryN5ERXPpYLF6/crY5JAaL2UnsxdnaD8hU9DGDuyF3V5Euy
        analYScJcrnE7YPzqfJCIGN5Y0Qt8bw5zFHjp9iwvQ==
X-Google-Smtp-Source: AGRyM1scb85wOqxPw547s6M27o6xFWA7hxGa2bjDyeXOU2HGlYReTCcDvnEf221P4RtTBZHZo6v/XPG0yBTjNLiffAE=
X-Received: by 2002:a81:3d1:0:b0:31c:9b70:ba8a with SMTP id
 200-20020a8103d1000000b0031c9b70ba8amr20225796ywd.204.1657151378426; Wed, 06
 Jul 2022 16:49:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220628122750.1895107-1-roberto.sassu@huawei.com>
 <20220628122750.1895107-5-roberto.sassu@huawei.com> <903b1b6c-b0fd-d624-a24b-5983d8d661b7@iogearbox.net>
In-Reply-To: <903b1b6c-b0fd-d624-a24b-5983d8d661b7@iogearbox.net>
From:   KP Singh <kpsingh@kernel.org>
Date:   Thu, 7 Jul 2022 01:49:27 +0200
X-Gmail-Original-Message-ID: <CACYkzJ4iR=FurW2UZdgycTdu54kNoFrw4uvmDrpTd3xuvpvVTw@mail.gmail.com>
Message-ID: <CACYkzJ4iR=FurW2UZdgycTdu54kNoFrw4uvmDrpTd3xuvpvVTw@mail.gmail.com>
Subject: Re: [PATCH v6 4/5] bpf: Add bpf_verify_pkcs7_signature() helper
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Roberto Sassu <roberto.sassu@huawei.com>, ast@kernel.org,
        andrii@kernel.org, john.fastabend@gmail.com, songliubraving@fb.com,
        kafai@fb.com, yhs@fb.com, dhowells@redhat.com,
        keyrings@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 6, 2022 at 6:04 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 6/28/22 2:27 PM, Roberto Sassu wrote:
> > Add the bpf_verify_pkcs7_signature() helper, to give eBPF security modules
> > the ability to check the validity of a signature against supplied data, by
> > using user-provided or system-provided keys as trust anchor.
> >
> > The new helper makes it possible to enforce mandatory policies, as eBPF
> > programs might be allowed to make security decisions only based on data
> > sources the system administrator approves.
> >
> > The caller should provide both the data to be verified and the signature as
> > eBPF dynamic pointers (to minimize the number of parameters).
> >
> > The caller should also provide a trusted keyring serial, together with key
> > lookup-specific flags, to determine which keys can be used for signature
> > verification. Alternatively, the caller could specify zero as serial value
> > (not valid, serials must be positive), and provide instead a special
> > keyring ID.
> >
> > Key lookup flags are defined in include/linux/key.h and can be: 1, to
> > request that special keyrings be created if referred to directly; 2 to
> > permit partially constructed keys to be found.
> >
> > Special IDs are defined in include/linux/verification.h and can be: 0 for
> > the primary keyring (immutable keyring of system keys); 1 for both the
> > primary and secondary keyring (where keys can be added only if they are
> > vouched for by existing keys in those keyrings); 2 for the platform keyring
> > (primarily used by the integrity subsystem to verify a kexec'ed kerned
> > image and, possibly, the initramfs signature).
> >
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > Reported-by: kernel test robot <lkp@intel.com> (cast warning)
>
> nit: Given this a new feature not a fix to existing code, there is no need to
>       add the above reported-by from kbuild bot.
>
> > ---
> >   include/uapi/linux/bpf.h       | 24 +++++++++++++
> >   kernel/bpf/bpf_lsm.c           | 63 ++++++++++++++++++++++++++++++++++
> >   tools/include/uapi/linux/bpf.h | 24 +++++++++++++
> >   3 files changed, 111 insertions(+)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index e81362891596..b4f5ad863281 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -5325,6 +5325,29 @@ union bpf_attr {
> >    *          **-EACCES** if the SYN cookie is not valid.
> >    *
> >    *          **-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
> > + *
> > + * long bpf_verify_pkcs7_signature(struct bpf_dynptr *data_ptr, struct bpf_dynptr *sig_ptr, u32 trusted_keyring_serial, unsigned long lookup_flags, unsigned long trusted_keyring_id)
>
> nit: for the args instead of ulong, just do u64
>
> > + *   Description
> > + *           Verify the PKCS#7 signature *sig_ptr* against the supplied
> > + *           *data_ptr* with keys in a keyring with serial
> > + *           *trusted_keyring_serial*, searched with *lookup_flags*, if the
> > + *           parameter value is positive, or alternatively in a keyring with
> > + *           special ID *trusted_keyring_id* if *trusted_keyring_serial* is
> > + *           zero.
> > + *
> > + *           *lookup_flags* are defined in include/linux/key.h and can be: 1,
> > + *           to request that special keyrings be created if referred to
> > + *           directly; 2 to permit partially constructed keys to be found.
> > + *
> > + *           Special IDs are defined in include/linux/verification.h and can
> > + *           be: 0 for the primary keyring (immutable keyring of system
> > + *           keys); 1 for both the primary and secondary keyring (where keys
> > + *           can be added only if they are vouched for by existing keys in
> > + *           those keyrings); 2 for the platform keyring (primarily used by
> > + *           the integrity subsystem to verify a kexec'ed kerned image and,
> > + *           possibly, the initramfs signature).
> > + *   Return
> > + *           0 on success, a negative value on error.
> >    */
> >   #define __BPF_FUNC_MAPPER(FN)               \
> >       FN(unspec),                     \
> > @@ -5535,6 +5558,7 @@ union bpf_attr {
> >       FN(tcp_raw_gen_syncookie_ipv6), \
> >       FN(tcp_raw_check_syncookie_ipv4),       \
> >       FN(tcp_raw_check_syncookie_ipv6),       \
> > +     FN(verify_pkcs7_signature),     \
>
> (Needs rebase)
>
> >       /* */
> >
> >   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > index c1351df9f7ee..401bda01ad84 100644
> > --- a/kernel/bpf/bpf_lsm.c
> > +++ b/kernel/bpf/bpf_lsm.c
> > @@ -16,6 +16,8 @@
> >   #include <linux/bpf_local_storage.h>
> >   #include <linux/btf_ids.h>
> >   #include <linux/ima.h>
> > +#include <linux/verification.h>
> > +#include <linux/key.h>
> >
> >   /* For every LSM hook that allows attachment of BPF programs, declare a nop
> >    * function where a BPF program can be attached.
> > @@ -132,6 +134,62 @@ static const struct bpf_func_proto bpf_get_attach_cookie_proto = {
> >       .arg1_type      = ARG_PTR_TO_CTX,
> >   };
> >
> > +#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
> > +BPF_CALL_5(bpf_verify_pkcs7_signature, struct bpf_dynptr_kern *, data_ptr,
> > +        struct bpf_dynptr_kern *, sig_ptr, u32, trusted_keyring_serial,
> > +        unsigned long, lookup_flags, unsigned long, trusted_keyring_id)
> > +{
> > +     key_ref_t trusted_keyring_ref;
> > +     struct key *trusted_keyring;
> > +     int ret;
> > +
> > +     /* Keep in sync with defs in include/linux/key.h. */
> > +     if (lookup_flags > KEY_LOOKUP_PARTIAL)
> > +             return -EINVAL;
>
> iiuc, the KEY_LOOKUP_* is a mask, so you could also combine the two, e.g.
> KEY_LOOKUP_CREATE | KEY_LOOKUP_PARTIAL. I haven't seen you mentioning anything
> specific on why it is not allowed. What's the rationale, if it's intentional
> if should probably be documented?

I think this was a part of the digilim threat model (only allow
limited lookup operations),
but this seems to be conflating the policy into the implementation of
the helper.

Roberto, can this not be implemented in digilim as a BPF LSM check
that attaches to the key_permission LSM hook?

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/lsm_hooks.h#n1158

>
> At minimum I also think the helper description needs to be improved for people
> to understand enough w/o reading through the kernel source, e.g. wrt lookup_flags
> since I haven't seen it in your selftests either ... when does a user need to
> use the given flags.
>
> nit: when both trusted_keyring_serial and trusted_keyring_id are passed to the
> helper, then this should be rejected as invalid argument? (Kind of feels a bit
> like we're cramming two things in one helper.. KP, thoughts? :))

EINVAL when both are passed seems reasonable. The signature (pun?) of the
does seem to get bloated, but I am not sure if it's worth adding two
helpers here.

>
> > +     /* Keep in sync with defs in include/linux/verification.h. */
> > +     if (trusted_keyring_id > (unsigned long)VERIFY_USE_PLATFORM_KEYRING)
> > +             return -EINVAL;
> > +
> > +     if (trusted_keyring_serial) {
> > +             trusted_keyring_ref = lookup_user_key(trusted_keyring_serial,
> > +                                                   lookup_flags,
> > +                                                   KEY_NEED_SEARCH);
> > +             if (IS_ERR(trusted_keyring_ref))
> > +                     return PTR_ERR(trusted_keyring_ref);
> > +
> > +             trusted_keyring = key_ref_to_ptr(trusted_keyring_ref);
> > +             goto verify;
> > +     }
> > +
> > +     trusted_keyring = (struct key *)trusted_keyring_id;
> > +verify:
> > +     ret = verify_pkcs7_signature(data_ptr->data,
> > +                                  bpf_dynptr_get_size(data_ptr),
> > +                                  sig_ptr->data,
> > +                                  bpf_dynptr_get_size(sig_ptr),
> > +                                  trusted_keyring,
> > +                                  VERIFYING_UNSPECIFIED_SIGNATURE, NULL,
> > +                                  NULL);
> > +     if (trusted_keyring_serial)
> > +             key_put(trusted_keyring);
> > +
> > +     return ret;
> > +}
> > +
> > +static const struct bpf_func_proto bpf_verify_pkcs7_signature_proto = {
> > +     .func           = bpf_verify_pkcs7_signature,
> > +     .gpl_only       = false,
> > +     .ret_type       = RET_INTEGER,
> > +     .arg1_type      = ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_LOCAL,
> > +     .arg2_type      = ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_LOCAL,
> > +     .arg3_type      = ARG_ANYTHING,
> > +     .arg4_type      = ARG_ANYTHING,
> > +     .arg5_type      = ARG_ANYTHING,
> > +     .allowed        = bpf_ima_inode_hash_allowed,
> > +};
> > +#endif /* CONFIG_SYSTEM_DATA_VERIFICATION */
> > +
