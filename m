Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 587D84B9013
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 19:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236925AbiBPSVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 13:21:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236606AbiBPSVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 13:21:02 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96941C65D4;
        Wed, 16 Feb 2022 10:20:49 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id o10so476471ilh.0;
        Wed, 16 Feb 2022 10:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bFuiGzhJTE4YwjynEmN3K3dMaFsaqOvKs9OdZhzpfFw=;
        b=FCBRlTesYDONAGKfQ/T5rssSBNLqig4HB4Di2QYhTsiyzv4Cb2ZZjXwB+Bx8j8YJkJ
         FnARa3o8EEXN2Mddk5691HdeNi2tOURDdfO0BTgsZghm4i4lddK0oDZq7aEk+EimRkkI
         XhGLQS2tkg29cuQ7aJKAD1AQgGeC4iZ40Lt3nEed6xKgTXTiyvrv4P8Cci9V5RD9jcem
         I4jNMTjdFsGiBvZu5ryQmIXrM70aZZhrCYY5sT4sO3CzkNjklmzVtmwcE9ztGYfOOJ/y
         gM1DG9Sbpi1LHJ4ER9QU/gnZzkpzlxMo4V/8Ttme96lX4qAW9aim09A4JUR8TPDMyH5m
         9fSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bFuiGzhJTE4YwjynEmN3K3dMaFsaqOvKs9OdZhzpfFw=;
        b=bMzYMm6vl+Hph9hcW9y63QtCUuhin9Kcfuc+CMJbHHEFe8CjWV5u19c70f2S+IyW9W
         uBmwKAuZ6ezksnFDIryznyEMnDZE/b/OTQKnJ20gDPtyJjlIdUrtc7qE6RJ/MuyDwdA1
         40tqpoWEF4SSEFAefORT8Zgol3J4LYIV5sJBUkLgrAbiCm7TYFv2F9hmilZbwZS5ddyu
         d8vKqXij4PNYfwKFX7j88htBEDDohRsfIBeAGqpF/XoJA7GU9sz+M1f77ptO2HvIg0VZ
         QcKYiE2M8rWgRXPt7xbhBjrlz4Om4LdHiaRZHzrdhkHy2XeFCZtZoh6CrgiTMdkEejlG
         VibA==
X-Gm-Message-State: AOAM530eviakb/iEkS/CkSHGoIBSc503lQ3zH7tvHeako5jkhQohpiX8
        19k1ZF2upNAnVC31/scQKq4mC+IRGyX1CuH2E1g=
X-Google-Smtp-Source: ABdhPJxPJvk4A3g1QT3VBe9eqeEExQYFt97tuypsGjCb+Batd1KAiMB3/pQY7uwtLFhlnpPxNofFWv5P6kuFvM/oj/o=
X-Received: by 2002:a92:d208:0:b0:2c1:1a3c:7b01 with SMTP id
 y8-20020a92d208000000b002c11a3c7b01mr2563665ily.71.1645035649148; Wed, 16 Feb
 2022 10:20:49 -0800 (PST)
MIME-Version: 1.0
References: <20220215225856.671072-1-mauricio@kinvolk.io> <20220215225856.671072-6-mauricio@kinvolk.io>
In-Reply-To: <20220215225856.671072-6-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Feb 2022 10:20:37 -0800
Message-ID: <CAEf4BzakR4cbe7aT09y5tnGebrixj8RnZsg13G+VLqpgQoWa7Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 5/7] bpftool: Implement btfgen_get_btf()
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 2:59 PM Mauricio V=C3=A1squez <mauricio@kinvolk.io>=
 wrote:
>
> The last part of the BTFGen algorithm is to create a new BTF object with
> all the types that were recorded in the previous steps.
>
> This function performs two different steps:
> 1. Add the types to the new BTF object by using btf__add_type(). Some
> special logic around struct and unions is implemented to only add the
> members that are really used in the field-based relocations. The type
> ID on the new and old BTF objects is stored on a map.
> 2. Fix all the type IDs on the new BTF object by using the IDs saved in
> the previous step.
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  tools/bpf/bpftool/gen.c | 100 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 99 insertions(+), 1 deletion(-)
>

[...]

> +                       cloned_m =3D btf_members(cloned_type);
> +                       m =3D btf_members(type);
> +                       vlen =3D btf_vlen(cloned_type);
> +                       for (idx_src =3D 0; idx_src < vlen; idx_src++, cl=
oned_m++, m++) {
> +                               /* add only members that are marked as us=
ed */
> +                               if (cloned_m->name_off !=3D MARKED)
> +                                       continue;
> +
> +                               name =3D btf__str_by_offset(info->src_btf=
, m->name_off);
> +                               err =3D btf__add_field(btf_new, name, m->=
type,
> +                                                    BTF_MEMBER_BIT_OFFSE=
T(m->offset),
> +                                                    BTF_MEMBER_BITFIELD_=
SIZE(m->offset));

BTF_MEMBER_BIT_OFFSET() and BTF_MEMBER_BIT_OFFSET() shouldn't be used
unconditionally, only if kflag is set. It's better to use
btf_member_bit_offset() and btf_member_bitfield_size() helpers here,
they handle this transparently.

> +                               if (err < 0)
> +                                       goto err_out;
> +                       }
> +               } else {
> +                       err =3D btf__add_type(btf_new, info->src_btf, typ=
e);
> +                       if (err < 0)
> +                               goto err_out;
> +                       new_id =3D err;
> +               }
> +
> +               /* add ID mapping */
> +               ids[i] =3D new_id;
> +       }
> +

[...]
