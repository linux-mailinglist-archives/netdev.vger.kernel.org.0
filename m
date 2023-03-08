Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F716B0FD7
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 18:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjCHRI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 12:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjCHRI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 12:08:26 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E266759830;
        Wed,  8 Mar 2023 09:08:22 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id o12so68456636edb.9;
        Wed, 08 Mar 2023 09:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678295301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jmdm67PLaZg5isxdKQHRzuN2mNhJoCw8thxfgv0DLMA=;
        b=jZNEk7Z4wbMG/B9CYogHKol+xNV+dttUbokR8eMFDZI1dLW7wGBT7QS++WytTEUyLW
         gS3mgqRc8pKHUvZnuZcRwSKuGTUR76MSLSG6uVyxnjOHrQS6aYXMh9SQdBaq443a61or
         Bei99c+815v6qMSZ9WH5dMm5ySC+QxGcuCAPEBBffKNDOpw/k30lD20yttWz9lQAm2DU
         78J87NqLO85poc38cqPpJmRnbEcnvFCLoz544OQ4M/fxR9t2ZssFU6DlAjzzbi+JtN3f
         qQhb7fAVOie+/aCaeqXyXW8iuTAVStUMXX1MMJVsv7DPln+yqiQcLfo32Hsj/3FvrG0C
         MrTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678295301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jmdm67PLaZg5isxdKQHRzuN2mNhJoCw8thxfgv0DLMA=;
        b=coUDqwuGcME0/r8iSECgfbsi9WAK4ljiWuMYg8ARUFKZzJSi16HyDs3wDIf/kVOqFA
         t4COP2E6GRP0q3Uky1QVERFKEJ4PBqMvZBnGum403XXJCMs2Jdhui2w64oxr6/STRnkm
         MAEXltdTAV9TAlj87hlC9L0A7tzvJtmcmBkphGnvDiHeGHrhxZff4HSXBQhwavvxJiB1
         TVj7Jv0DxmGdTZQXYndz6gcPPC8ljBfe9mobrDb+bZ5MolCdKZw9tcN7k+EfQvIcSFnS
         qZsG/BbG3wvFZUTT08EMl18MkEVijmUVg4MFHdseDo+CxwLfhuK0YH3Nz2a0lu8K8PgP
         q3oA==
X-Gm-Message-State: AO0yUKVronfsh2GfdXGXB3FGIouQusZafMvkzfoaK6lN/IdlzOsQZt0S
        tRfn5dK1ajfDfNhbawTUmrFFNo+Wu23YIesGg1E=
X-Google-Smtp-Source: AK7set94QT/jAqpbHNOQlewTyPeVPsHZIhGIoQ/ni/cEoqcY1tWjOEcpxazaeJ+A8dFrECSHX5gJJa0+yok3ZPTzBo8=
X-Received: by 2002:a50:cd94:0:b0:4c2:1a44:642e with SMTP id
 p20-20020a50cd94000000b004c21a44642emr10753795edi.5.1678295301334; Wed, 08
 Mar 2023 09:08:21 -0800 (PST)
MIME-Version: 1.0
References: <20230301154953.641654-1-joannelkoong@gmail.com> <20230308001621.432d9a1a@kernel.org>
In-Reply-To: <20230308001621.432d9a1a@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 8 Mar 2023 09:08:09 -0800
Message-ID: <CAEf4BzZzqFW=YBkK1+PKyXPhVmhFSqU=+OHJ6_1USK22UoKEvQ@mail.gmail.com>
Subject: Re: [PATCH v13 bpf-next 00/10] Add skb + xdp dynptrs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Joanne Koong <joannelkoong@gmail.com>, bpf@vger.kernel.org,
        martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 8, 2023 at 12:16=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Wed,  1 Mar 2023 07:49:43 -0800 Joanne Koong wrote:
> > This patchset is the 2nd in the dynptr series. The 1st can be found her=
e [0].
> >
> > This patchset adds skb and xdp type dynptrs, which have two main benefi=
ts for
> > packet parsing:
> >     * allowing operations on sizes that are not statically known at
> >       compile-time (eg variable-sized accesses).
> >     * more ergonomic and less brittle iteration through data (eg does n=
ot need
> >       manual if checking for being within bounds of data_end)
> >
> > When comparing the differences in runtime for packet parsing without dy=
nptrs
> > vs. with dynptrs, there is no noticeable difference. Patch 9 contains m=
ore
> > details as well as examples of how to use skb and xdp dynptrs.
>
> Oddly I see an error trying to build net-next with clang 15.0.7,
> but I'm 90% sure that it built yesterday, has anyone seen:

yep, it was fixed in bpf-next:

2d5bcdcda879 ("bpf: Increase size of BTF_ID_LIST without
CONFIG_DEBUG_INFO_BTF again")

>
> ../kernel/bpf/verifier.c:10298:24: error: array index 16 is past the end =
of the array (which contains 16 elements) [-Werror,-Warray-bounds]
>                                    meta.func_id =3D=3D special_kfunc_list=
[KF_bpf_dynptr_slice_rdwr]) {
>                                                    ^                  ~~~=
~~~~~~~~~~~~~~~~~~~~~
> ../kernel/bpf/verifier.c:9150:1: note: array 'special_kfunc_list' declare=
d here
> BTF_ID_LIST(special_kfunc_list)
> ^
> ../include/linux/btf_ids.h:207:27: note: expanded from macro 'BTF_ID_LIST=
'
> #define BTF_ID_LIST(name) static u32 __maybe_unused name[16];
>                           ^
> 1 error generated.
