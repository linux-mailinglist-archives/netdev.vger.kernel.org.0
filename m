Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F4857CCCC
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 16:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiGUOCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 10:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiGUOCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 10:02:21 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C503D5B7;
        Thu, 21 Jul 2022 07:02:20 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id os14so3361640ejb.4;
        Thu, 21 Jul 2022 07:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jVFPBqUH4CP3bZyK8ezfuKjTdPdnvbLrBY0GTGcqTYo=;
        b=e7C8fTzfObVJ4yjtD/YkDrrhwadB9/tBEXwJLxdLa+ErOnEtKJBHN9Gl7amPCdntXf
         /EtCOrcrmStofQNzzlJEi0mDCF8jetEdEllVFXsil4bWjPOMQZLz2RqNXs3pjqZ4T3BG
         Ofzd1ab67YvTjKBtJzcYa5mTtRY9Njhe/Q95p/itrMb3h0+yI7TOQDvdxkOLv3CmSmkB
         +b23+JGAv7aMwPRJE/AqPK9UeojM7TYU6oSpyrBivVqkDLDc1BEK2nc6xxGRlwH/KEiD
         tcoY1ZpwbDZJGJV+N8l7KInXY6Dh+PYCxDb15+eOCUJSqSGo+hgTiHlAE2JqfA/jKeDO
         jDKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jVFPBqUH4CP3bZyK8ezfuKjTdPdnvbLrBY0GTGcqTYo=;
        b=uSgoeDcM+op3RyNc2K6eorjs2O4mcGfWtxip7z31UORd5SEOYB1JWvZvrqndYpZaiI
         aTZLvOnmOK6dV6+OMq184ru6qmfxgiyYN+OIaNpqFFfnNtIe0jkEfWT39VdOeTYmRE9l
         GOb8mGz3ZuFHqcV8ICfEQdlWpqnifZ4okIKshQjwMo6CLX9MlthDhkmhhzoXgueYSzOb
         DdRsL4dosofRa0JjrRPjAbaLM7nrJzIBXeg7VvCYWsVPGeYwndAUGpIga2P2YMk9yFyI
         CJSxb5af+Tba3B+0j7oYwxfkI68fQre7ZPw1pseuFWTTt40FYQdE1l86P4tSh9SUf3Q6
         Go1Q==
X-Gm-Message-State: AJIora9P6gA745PKrpwEkxVVtZvbbMT6ZnbhPMlqlT5yWgJuuDGavEIJ
        FS7eD1lM5KJTfIgFv5n50no9pvMmGKC22yZGR6A=
X-Google-Smtp-Source: AGRyM1u8/7fifE505BM62HBP6toE/0yq0Y6gu53cPsyFffFAcSVPumAQ1OFIwQKoifby/NmpWVCoQNF5C+wuz0kjNTE=
X-Received: by 2002:a17:907:3f07:b0:72b:54b2:f57f with SMTP id
 hq7-20020a1709073f0700b0072b54b2f57fmr39743031ejc.502.1658412139195; Thu, 21
 Jul 2022 07:02:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220720114652.3020467-1-asavkov@redhat.com> <20220720114652.3020467-2-asavkov@redhat.com>
In-Reply-To: <20220720114652.3020467-2-asavkov@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 21 Jul 2022 07:02:07 -0700
Message-ID: <CAADnVQ+mt1iEsXUGBeL-dgXRoRwPxoz+G=aRcZTkhx2AA10R-A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: add BPF_F_DESTRUCTIVE flag for BPF_PROG_LOAD
To:     Artem Savkov <asavkov@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 4:47 AM Artem Savkov <asavkov@redhat.com> wrote:
>
> +/* If BPF_F_DESTRUCTIVE is used in BPF_PROG_LOAD command, the loaded program
> + * will be able to perform destructive operations such as calling bpf_panic()
> + * helper.
> + */
> +#define BPF_F_DESTRUCTIVE      (1U << 6)

I don't understand what value this flag provides.

bpf prog won't be using kexec accidentally.
Requiring user space to also pass this flag seems pointless.
