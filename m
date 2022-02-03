Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C844A8856
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352087AbiBCQHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:07:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiBCQHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:07:49 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C8AC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 08:07:49 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id l27so2213393lfe.1
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 08:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U8C94DRdIZGAroYerjdGjoFnF/GC8q7KFZokkTOxUZs=;
        b=gDpiugQBFCZYvMpY47vTeHN5scolnvYBOB4bSGLZnNX3gB7Mf/6B1iTEQQ3UCu7D1K
         jw1x3PlIPKkZ5sv4//YSSWYiMc59xSiVaTDkx8PMqwhfbC292fbKu0dy8NVXPuSOY3jj
         N5alIlpk1mTLEtAfHFIjo9SS807hGfxRYRFtU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U8C94DRdIZGAroYerjdGjoFnF/GC8q7KFZokkTOxUZs=;
        b=GtGVqr+R+9Mo8CI87nxPFbPlp9PRnPInG3XmFB57pcrmeS3mPWEoY3ZcQZjXGekYLU
         rLxVK/ENDXwh7m6dtJ3z2lu+7S3VjhCkPXxGJxMv1qN3yijw7jm95jz0astzMESlrQFT
         T2vmjthe/v2ukCth3NiTaXcf9WduReK5wuh6edfvUQJZj6osSwa4rZ/LxHABG7etQkf7
         S8ovfbuUybBmu/t4zjU27oIn/zoR/kkY33r6J/Ct4242vNJ67Gm8TgZ0eqTBtiIf6ssA
         20GBfTuDLqVYgNDn7FZm5E6S2A//dOZdi/2XG3dxfqC24+sBxPS5HbNPuOX1jdGdXCkv
         BXJQ==
X-Gm-Message-State: AOAM533kIw/DjX20tRywWjQEbT4l5hphmcTkt7SuHlE+6kCPMzkbtK9N
        Lnb2HxxrLyjmr+KIS3sTZKBznSZfw2TZmZKZLSB26YJbAqKJkg==
X-Google-Smtp-Source: ABdhPJwWN6XUZynoQwdD2Uk4RznsvF2cwOFpad/pcBwo8RfeX5K/zELXa30kkC2ev6EIldXn8xHa8+DW+ArbBJaqW00=
X-Received: by 2002:a05:6512:2342:: with SMTP id p2mr27218556lfu.382.1643904467469;
 Thu, 03 Feb 2022 08:07:47 -0800 (PST)
MIME-Version: 1.0
References: <20220128223312.1253169-1-mauricio@kinvolk.io> <20220128223312.1253169-4-mauricio@kinvolk.io>
 <CAEf4BzYW54DRsJxgeXKcHPLSXs45DsCVKumV7WNd2UH=1G4MPA@mail.gmail.com>
In-Reply-To: <CAEf4BzYW54DRsJxgeXKcHPLSXs45DsCVKumV7WNd2UH=1G4MPA@mail.gmail.com>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Thu, 3 Feb 2022 11:07:36 -0500
Message-ID: <CAHap4zumCF_pC6-J+dpSiT+qzZVt=scb-AMdpcFSFfz6iSx1HQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 3/9] bpftool: Implement btf_save_raw()
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The logic looks good, but you need to merge adding this static
> function with the patch that's using that static function. Otherwise
> you will break bisectability because compiler will warn about unused
> static function.
>

It only emits a warning but it compiles fine. Is that still an issue?
