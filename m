Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5DD4B3227
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 01:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354460AbiBLAmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 19:42:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239705AbiBLAmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 19:42:38 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56765D7F;
        Fri, 11 Feb 2022 16:42:36 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id s18so13366718ioa.12;
        Fri, 11 Feb 2022 16:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OJVxo4JNnS/4axGudV79g4q+WeD1P0JW46g2J1aBTQw=;
        b=V7cLVENsFn8qZOkgisasD4BhWmBOnZr+xRHsjJcw72s771FUMR8TzRwHtcwqd/Kqi6
         rgzxgcfRYG+zdFigZchfG67y8MdaHI2rXrb0ESmURUn3UrnLqsyHuOSq3oeDqL+FafsF
         y5RLkYaUeLIqnbdEBzMz8OLigCbBOE6iw/lzBSWdsfIsHlKfEFeyA9eokA1Kan3ifvZ1
         gVOJZTEyQY05TbiY18GuM46o6l/ZUCKlbSIARY4r1ZgR5kspcq0YD6H4PQ9RfUrvXzFx
         //dQuMYcHLI0DHjZAymAQZEv3TtTSk8hGXAGgteKZVfklhjgDleUOFTi7M7ZvhMQzw1v
         D+Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OJVxo4JNnS/4axGudV79g4q+WeD1P0JW46g2J1aBTQw=;
        b=nZJ2y6roGyFQj+vaDcWNSJlkpwELoy6VPsp5f9BmPg8EqTfFWOzoZAGG7UbGb21hac
         LgNZKsSfy62K5Fu3QVf1Iy1uXWbGNzb1IsQO7UWCzpyNN2X7Ckf3ESMVKkeih9jwEk2B
         Rk9OtmJy6KHZ4d4r5fn9g9UbBPiSWVzjXBcGK1bL4Evn55LXRf8dIPJa+ulqtqBlECDx
         oUE2qG7iETZY/3enWgo84rQ04aZE2EDujsNEsj8yEGNvvFfO6qdkydwxvKuFlIzWlOVR
         gejeuutlaSri87bE/Mn1VAxlupi4K/3GdWzox6BkirbIoAobSqn4kmZu6DFwlg68qfi/
         LNYA==
X-Gm-Message-State: AOAM533sJ2QwmLThSdub6rwGJytdJHW0w+4p4Gr8ATC/IY6JxO5j0gMb
        0Ajg4a5VUVqfKrHvKvye5gn6vQCfwCtWGVRhlgY=
X-Google-Smtp-Source: ABdhPJxtfxYM1uiwPQMvq5a4WavxN2MaGCdU5/2lnCXEyHuX1Vq59ItSwi7Mywe2dvxEFHpbGSF7cym2Er3myXbV4WI=
X-Received: by 2002:a02:7417:: with SMTP id o23mr2324771jac.145.1644626555753;
 Fri, 11 Feb 2022 16:42:35 -0800 (PST)
MIME-Version: 1.0
References: <20220209222646.348365-1-mauricio@kinvolk.io> <20220209222646.348365-3-mauricio@kinvolk.io>
In-Reply-To: <20220209222646.348365-3-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Feb 2022 16:42:24 -0800
Message-ID: <CAEf4BzYYzv99OSNdMF_UX=mGSSPuCuk3jd1W-7pHf50Bs7k5_g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 2/7] libbpf: Expose bpf_core_{add,free}_cands()
 to bpftool
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
> Expose bpf_core_add_cands() and bpf_core_free_cands() to handle
> candidates list.
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/lib/bpf/libbpf.c          | 17 ++++++++++-------
>  tools/lib/bpf/libbpf_internal.h |  9 +++++++++
>  2 files changed, 19 insertions(+), 7 deletions(-)
>

[...]
