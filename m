Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BCD4E4545
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 18:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239768AbiCVRk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 13:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239764AbiCVRk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 13:40:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2313D887BB
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 10:39:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD5C4B81D2C
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 17:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762DFC36AE5
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 17:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647970766;
        bh=8q6r8juMrDBnbfWTc+rVHMGsrIAAdRTfUtHXinUmhWc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jKoC8utb6vQC7JxzlBEup2+AX7aBbfyHynQsN5+F+64vE408VhuXBoRLdaIp0onHX
         cLVDZCmqzqjmX62Q8geT5nkGkzIvYJj7GfEDuc09mj859qR4C9jfFKWPJybqcxZDmR
         T9Uz8MPJdezD1UANrBMb7yai0hiMCB2PxpC5yP++t/SHOHAueZAAWwAFVjnLeNjJxm
         kXRBpt95lK1sBvfcluiTroBzd760fbW31+v/a5nb46bklZWpOqQTLu2EDu3kml/QSG
         mEdWP2lJ4q16hiixMgSKCzwKenbKqgbtTbuTCgs6aqHJ3EXKT1B1cuuw0eYy3aNctn
         1/RBOpbLaXqsg==
Received: by mail-ed1-f51.google.com with SMTP id k10so8854862edj.2
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 10:39:26 -0700 (PDT)
X-Gm-Message-State: AOAM530CnrdiFFYqJLGFxRvDZvQsae3tq3o/OCHfoHQuoE33UlOBWcN8
        ugewWhDpwr1yp7yiwN7Ob/P2wLD7ZPX11Dp5ZhwenQ==
X-Google-Smtp-Source: ABdhPJz7l0qlFBKeBFie+TrVzQ/TBK3pBt0oidyYtw1ppUgJq/0zjb7jE93WaRMBlLa2DXZ0Fd5SSnrUxfju6EPJzCQ=
X-Received: by 2002:a50:cf48:0:b0:415:df40:9e3d with SMTP id
 d8-20020a50cf48000000b00415df409e3dmr29229293edk.185.1647970764645; Tue, 22
 Mar 2022 10:39:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220322145012.1315376-1-milan@mdaverde.com> <ca7b331c-bd35-7d51-3df4-723bc36676f8@isovalent.com>
In-Reply-To: <ca7b331c-bd35-7d51-3df4-723bc36676f8@isovalent.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Tue, 22 Mar 2022 18:39:13 +0100
X-Gmail-Original-Message-ID: <CACYkzJ49NibikDxgq9BudWu6ieW4ZkiEWCy_yAsJUFtEiS9CEg@mail.gmail.com>
Message-ID: <CACYkzJ49NibikDxgq9BudWu6ieW4ZkiEWCy_yAsJUFtEiS9CEg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf/bpftool: add unprivileged_bpf_disabled check
 against value of 2
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Milan Landaverde <milan@mdaverde.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Paul Chaignon <paul@isovalent.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 4:54 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2022-03-22 10:49 UTC-0400 ~ Milan Landaverde <milan@mdaverde.com>
> > In [1], we added a kconfig knob that can set
> > /proc/sys/kernel/unprivileged_bpf_disabled to 2
> >
> > We now check against this value in bpftool feature probe
> >
> > [1] https://lore.kernel.org/bpf/74ec548079189e4e4dffaeb42b8987bb3c852eee.1620765074.git.daniel@iogearbox.net
> >
> > Signed-off-by: Milan Landaverde <milan@mdaverde.com>
>
> Acked-by: Quentin Monnet <quentin@isovalent.com>

Acked-by: KP Singh <kpsingh@kernel.org>

Thanks, this is very useful!
