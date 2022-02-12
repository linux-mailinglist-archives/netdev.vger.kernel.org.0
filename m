Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03CA44B322A
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 01:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354461AbiBLAmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 19:42:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345478AbiBLAmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 19:42:43 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CBFDC;
        Fri, 11 Feb 2022 16:42:40 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id d188so13412068iof.7;
        Fri, 11 Feb 2022 16:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sUVknTbHe6joXnKS+OLGF34LjVRJcgObsuNsgbapY2A=;
        b=EkOrvhOoqqamUW25OQhbCdsZ0eawtGu6EibvKFjOXcP1C9UcvfqT6qlknVoae7vudB
         gS4UJSXQW3IRpLJCumZLcIx/X4RMrs2v/QF0dhMQpophSf+LHlNa4ksiTEGBs687Udbp
         dBgz+LiCv/JVvPdnoqHKoABmdQFi6Liy36secPpelyHeD2HzZzrbfZB18zetRFe8+On+
         WaJGBG+FNiAtFlLG7QOOedXzhbU7XKv58AmfXi0Ty1zBVGPV5xqmZopwiE1f4cZTkb8x
         JAGBGlWMs+4uEVTWu4JSkPPPnD/2VVOLdkiFuVVLYQFyZR0V4ZAnsUKUhv7mG55d0N7I
         +GSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sUVknTbHe6joXnKS+OLGF34LjVRJcgObsuNsgbapY2A=;
        b=JmnW4zXccXJzU06of2CmSyXrTMOY48vvFf0ViXUsTazbQJvi2YThw0mzBt5ADzA7BJ
         xeTWJ8Gg72zE50Ck5BdoxToGaSDcZ5Pn4u+JCDU0QAYuTmgn0XL+i7qfCDUcKHFqpkJK
         LTMhHSRCoI23RDM0Z0J9XJBYdgjB7D2VI43dIllMvopdPL5HGtS8Hb2HESOpQwIPOh6N
         ZqVslEQfAW/eSU7rPme79n5LJY+57Tx+g23IBuppGrqkU+Lpim9OPBfO8c0txamRbY3t
         Xywa9bTg9Y6dB7B41Gcql0ybco/76NkaR/0gk+q7rIG5s5nXk7mw2RIiubkm58yjqej2
         banQ==
X-Gm-Message-State: AOAM532/+EYws9a3VroxAMxzn0DBuRhcJ1lXg1FPVq9Q1KoOdX6vZDQi
        ScAn11f4h2l5pwQMXgz0G66edSSFGQ71biMv3K8=
X-Google-Smtp-Source: ABdhPJzxJ6nc5TUEdfvKoiO1fRn7VgPdvqAMx9O+CdAL96UmvRurWopDYoOTy7hxPpjOM6NCCXvb4wbfWIUelgetNLU=
X-Received: by 2002:a05:6638:304d:: with SMTP id u13mr2284267jak.103.1644626560176;
 Fri, 11 Feb 2022 16:42:40 -0800 (PST)
MIME-Version: 1.0
References: <20220209222646.348365-1-mauricio@kinvolk.io> <20220209222646.348365-4-mauricio@kinvolk.io>
In-Reply-To: <20220209222646.348365-4-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Feb 2022 16:42:29 -0800
Message-ID: <CAEf4BzbL4xoc8NkCwUYH6mTg-QaGi42=Uzgn63ThyZrux+EeNg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 3/7] bpftool: Add gen min_core_btf command
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

On Wed, Feb 9, 2022 at 2:27 PM Mauricio V=C3=A1squez <mauricio@kinvolk.io> =
wrote:
>
> This command is implemented under the "gen" command in bpftool and the
> syntax is the following:
>
> $ bpftool gen min_core_btf INPUT OUTPUT OBJECT [OBJECT...]
>
> INPUT is the file that contains all the BTF types for a kernel and
> OUTPUT is the path of the minimize BTF file that will be created with
> only the types needed by the objects.
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---

LGTM. So much simpler interface.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/bpf/bpftool/bash-completion/bpftool |  6 +++-
>  tools/bpf/bpftool/gen.c                   | 42 +++++++++++++++++++++--
>  2 files changed, 44 insertions(+), 4 deletions(-)
>

[...]
