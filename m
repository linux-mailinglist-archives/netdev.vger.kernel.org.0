Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E335E5883DD
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 00:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbiHBWJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 18:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231793AbiHBWJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 18:09:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C350F21256
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 15:09:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A68561574
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 22:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43D2C43141
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 22:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659478144;
        bh=FcdHNfXuQiJB9HM66+G68cqs7BlM13zGpj+qnB1hK7Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mwc0mJ/Uagxs63fdJ+TLVG3mhnFR4VGPxxOjmn5oiMB8BQud58sGsuAPuA24OkUhF
         997xHQkIq6P2In0oUqnXvW4avG4GxfsQHBbJFkWAu1yF6ZIMcGOg93CoxQga5vSR+o
         eTgI07G4JLKJ9kETODLdvZX3i8ZmDlIctv7rmJF5CrNIirBCAxjwvhHeUzFZeeRmfH
         U2zDHnBz/u+RSon9OzX+HeJEo2qB9OK/IOJu75UWUMcMd6XHp5rSPUF1rL+ORpz55I
         rfJA0UzdiKngh2f145eitGYoz/MvP1S68gKxsIDgTHjhGDFPFqkObZxaYIQuP5jzlo
         Asq0za7Wvsvtg==
Received: by mail-yb1-f177.google.com with SMTP id o15so25556266yba.10
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 15:09:04 -0700 (PDT)
X-Gm-Message-State: ACgBeo1peaASBAYqEHmXDitrK6IV+eiEs6/2ji89n5zrbbqXnoQCtGum
        8UBTg787qU2CkKvk1HDpMBS9rDDmbcpESmEhehSwIA==
X-Google-Smtp-Source: AA6agR6ZWQQsYK03aDTp4UgsRj0FlS39f5Llvh0WRP0M8eyLjhhx3O7M9XERlWsQl+Kc/FPxwU7DIeUW6BkyNdZDstw=
X-Received: by 2002:a81:14c7:0:b0:328:25f0:9c89 with SMTP id
 190-20020a8114c7000000b0032825f09c89mr2602862ywu.476.1659478133089; Tue, 02
 Aug 2022 15:08:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220801180146.1157914-1-fred@cloudflare.com> <20220801180146.1157914-4-fred@cloudflare.com>
In-Reply-To: <20220801180146.1157914-4-fred@cloudflare.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Wed, 3 Aug 2022 00:08:42 +0200
X-Gmail-Original-Message-ID: <CACYkzJ4_MrbS-2S_R3KSZnL8h9pWnP6ih5ccKPGYxZTaESMZ2g@mail.gmail.com>
Message-ID: <CACYkzJ4_MrbS-2S_R3KSZnL8h9pWnP6ih5ccKPGYxZTaESMZ2g@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] selftests/bpf: Add tests verifying bpf lsm
 userns_create hook
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        shuah@kernel.org, brauner@kernel.org, casey@schaufler-ca.com,
        ebiederm@xmission.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        cgzones@googlemail.com, karl@bigbadwolfsecurity.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 1, 2022 at 8:02 PM Frederick Lawler <fred@cloudflare.com> wrote:
>
> The LSM hook userns_create was introduced to provide LSM's an
> opportunity to block or allow unprivileged user namespace creation. This
> test serves two purposes: it provides a test eBPF implementation, and
> tests the hook successfully blocks or allows user namespace creation.
>
> This tests 3 cases:
>
>         1. Unattached bpf program does not block unpriv user namespace
>            creation.
>         2. Attached bpf program allows user namespace creation given
>            CAP_SYS_ADMIN privileges.
>         3. Attached bpf program denies user namespace creation for a
>            user without CAP_SYS_ADMIN.
>
> Signed-off-by: Frederick Lawler <fred@cloudflare.com>

Looks good to me (Also checked it on vmtest.sh)

Acked-by: KP Singh <kpsingh@kernel.org>
