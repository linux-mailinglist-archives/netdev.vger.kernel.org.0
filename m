Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1855432F0
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 16:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241704AbiFHOpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 10:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241991AbiFHOp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 10:45:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2065F3F31F
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 07:45:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3280BB827E7
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 14:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3401C36B00
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 14:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654699501;
        bh=h5nJWv2u+AKj9aRmJGu+9OGhO0n9Dn4uU2rxU1PBCxc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ObbBTeF/Le85ZPxM5o9SCi4qNrABC3YwzYTzJ7HjMtCjjPW8bokH4PeFegC0zjfKN
         SgpvCVje2DcCXVCeg8z4M5yxDu2mgh7d+2XTAMA2COY/yVDwy4kbgL/uN/qajGPS4e
         rLYrruxnSnC4gzi29iL86qWf37sCSulT2zjRqBYDowm06uPfRH59/6RLDY12kpvUsB
         bpawb+Dett7oRNKdSkwU4G+IirVU39Aelh+kGafNjGqZ6gqkYr/M1CrSpirORg34EM
         sJWN8FEfzmRZf11J/w/KESWv0iTGvHqzyzKTusbkTSXkzYpxN+XnwCKlr7IV2UmB8H
         c6Htz4RFNiXhw==
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-3137eb64b67so9917127b3.12
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 07:45:01 -0700 (PDT)
X-Gm-Message-State: AOAM532sivad2pLieLXpK+O+MQUrqXEthQG0dTCh6lsXWhoiSbCsawc2
        4Yo/7sf6RKdjGowANU0NDLnFcCNuy0Zs6Bt2N3jrIw==
X-Google-Smtp-Source: ABdhPJyXGRQscBtFbS4JH4IoQpN6OKw2x7zf/xodV78NZnTt6mvAd3qKxyM2Z7yMMlk3BFPHD1MLt95enhK8jtm+Xy4=
X-Received: by 2002:a81:190f:0:b0:313:43b8:155c with SMTP id
 15-20020a81190f000000b0031343b8155cmr8848794ywz.495.1654699500792; Wed, 08
 Jun 2022 07:45:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220608111221.373833-1-roberto.sassu@huawei.com>
 <20220608111221.373833-2-roberto.sassu@huawei.com> <1456514b-ec2e-6a79-438a-33ad1ffc509d@iogearbox.net>
In-Reply-To: <1456514b-ec2e-6a79-438a-33ad1ffc509d@iogearbox.net>
From:   KP Singh <kpsingh@kernel.org>
Date:   Wed, 8 Jun 2022 16:44:50 +0200
X-Gmail-Original-Message-ID: <CACYkzJ4VU+JQzsCZHgeAY9Aej5W_k7bJFSeDP93Nq=uM_v7c8Q@mail.gmail.com>
Message-ID: <CACYkzJ4VU+JQzsCZHgeAY9Aej5W_k7bJFSeDP93Nq=uM_v7c8Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] bpf: Add bpf_verify_pkcs7_signature() helper
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Roberto Sassu <roberto.sassu@huawei.com>, ast@kernel.org,
        andrii@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.fastabend@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 8, 2022 at 4:43 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 6/8/22 1:12 PM, Roberto Sassu wrote:
> > Add the bpf_verify_pkcs7_signature() helper, to give the ability to eBPF
> > security modules to check the validity of a PKCS#7 signature against
> > supplied data.

Can we keep the helper generic so that it can be extended to more types of
signatures and pass the signature type as an enum?

bpf_verify_signature and a type SIG_PKCS7 or something.

> >
> > Use the 'keyring' parameter to select the keyring containing the
> > verification key: 0 for the primary keyring, 1 for the primary and
> > secondary keyrings, 2 for the platform keyring.
> >
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > ---
> >   include/uapi/linux/bpf.h       |  8 ++++++++
> >   kernel/bpf/bpf_lsm.c           | 32 ++++++++++++++++++++++++++++++++
> >   tools/include/uapi/linux/bpf.h |  8 ++++++++
> >   3 files changed, 48 insertions(+)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index f4009dbdf62d..40d0fc0d9493 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -5249,6 +5249,13 @@ union bpf_attr {
> >    *          Pointer to the underlying dynptr data, NULL if the dynptr is
> >    *          read-only, if the dynptr is invalid, or if the offset and length
> >    *          is out of bounds.
> > + *
> > + * long bpf_verify_pkcs7_signature(u8 *data, u32 datalen, u8 *sig, u32 siglen, u64 keyring)
> > + *   Description
> > + *           Verify the PKCS#7 *sig* with length *siglen*, on *data* with
> > + *           length *datalen*, with key in *keyring*.
>
> Could you also add a description for users about the keyring argument and guidance on when
> they should use which in their programs? Above is a bit too terse, imho.
>
> > + *   Return
> > + *           0 on success, a negative value on error.
> >    */
> >   #define __BPF_FUNC_MAPPER(FN)               \
> >       FN(unspec),                     \
> > @@ -5455,6 +5462,7 @@ union bpf_attr {
> >       FN(dynptr_read),                \
> >       FN(dynptr_write),               \
> >       FN(dynptr_data),                \
> > +     FN(verify_pkcs7_signature),     \
> >       /* */
> >
> >   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > index c1351df9f7ee..1cda43cb541a 100644
> > --- a/kernel/bpf/bpf_lsm.c
> > +++ b/kernel/bpf/bpf_lsm.c
> > @@ -16,6 +16,7 @@
> >   #include <linux/bpf_local_storage.h>
> >   #include <linux/btf_ids.h>
> >   #include <linux/ima.h>
> > +#include <linux/verification.h>
> >
> >   /* For every LSM hook that allows attachment of BPF programs, declare a nop
> >    * function where a BPF program can be attached.
> > @@ -132,6 +133,35 @@ static const struct bpf_func_proto bpf_get_attach_cookie_proto = {
> >       .arg1_type      = ARG_PTR_TO_CTX,
> >   };
> >
> > +BPF_CALL_5(bpf_verify_pkcs7_signature, u8 *, data, u32, datalen, u8 *, sig,
> > +        u32, siglen, u64, keyring)
> > +{
> > +     int ret = -EOPNOTSUPP;
> > +
> > +#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
> > +     if (keyring > (unsigned long)VERIFY_USE_PLATFORM_KEYRING)
> > +             return -EINVAL;
> > +
> > +     ret = verify_pkcs7_signature(data, datalen, sig, siglen,
> > +                                  (struct key *)keyring,
> > +                                  VERIFYING_UNSPECIFIED_SIGNATURE, NULL,
> > +                                  NULL);
> > +#endif
> > +     return ret;
> > +}
>
> Looks great! One small nit, I would move all of the BPF_CALL and _proto under the
> #ifdef CONFIG_SYSTEM_DATA_VERIFICATION ...
>
> > +static const struct bpf_func_proto bpf_verify_pkcs7_signature_proto = {
> > +     .func           = bpf_verify_pkcs7_signature,
> > +     .gpl_only       = false,
> > +     .ret_type       = RET_INTEGER,
> > +     .arg1_type      = ARG_PTR_TO_MEM,
> > +     .arg2_type      = ARG_CONST_SIZE_OR_ZERO,
> > +     .arg3_type      = ARG_PTR_TO_MEM,
> > +     .arg4_type      = ARG_CONST_SIZE_OR_ZERO,
> > +     .arg5_type      = ARG_ANYTHING,
> > +     .allowed        = bpf_ima_inode_hash_allowed,
> > +};
> > +
> >   static const struct bpf_func_proto *
> >   bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >   {
> > @@ -158,6 +188,8 @@ bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >               return prog->aux->sleepable ? &bpf_ima_file_hash_proto : NULL;
> >       case BPF_FUNC_get_attach_cookie:
> >               return bpf_prog_has_trampoline(prog) ? &bpf_get_attach_cookie_proto : NULL;
> > +     case BPF_FUNC_verify_pkcs7_signature:
> > +             return prog->aux->sleepable ? &bpf_verify_pkcs7_signature_proto : NULL;
>
> ... same here:
>
> #ifdef CONFIG_SYSTEM_DATA_VERIFICATION
>         case BPF_FUNC_verify_pkcs7_signature:
>                 return prog->aux->sleepable ? &bpf_verify_pkcs7_signature_proto : NULL;
> #endif
>
> So that bpftool or other feature probes can check for its availability. Otherwise, apps have
> a hard time checking whether bpf_verify_pkcs7_signature() helper is available for use or not.
>
> >       default:
> >               return tracing_prog_func_proto(func_id, prog);
> >       }
> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> > index f4009dbdf62d..40d0fc0d9493 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> > @@ -5249,6 +5249,13 @@ union bpf_attr {
> >    *          Pointer to the underlying dynptr data, NULL if the dynptr is
> >    *          read-only, if the dynptr is invalid, or if the offset and length
> >    *          is out of bounds.
> > + *
> > + * long bpf_verify_pkcs7_signature(u8 *data, u32 datalen, u8 *sig, u32 siglen, u64 keyring)
> > + *   Description
> > + *           Verify the PKCS#7 *sig* with length *siglen*, on *data* with
> > + *           length *datalen*, with key in *keyring*.
> > + *   Return
> > + *           0 on success, a negative value on error.
> >    */
> >   #define __BPF_FUNC_MAPPER(FN)               \
> >       FN(unspec),                     \
> > @@ -5455,6 +5462,7 @@ union bpf_attr {
> >       FN(dynptr_read),                \
> >       FN(dynptr_write),               \
> >       FN(dynptr_data),                \
> > +     FN(verify_pkcs7_signature),     \
> >       /* */
> >
> >   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> >
>
