Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F40D3BF425
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 05:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhGHDCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 23:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbhGHDCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 23:02:44 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E241C061574;
        Wed,  7 Jul 2021 20:00:02 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id q18so10414681lfc.7;
        Wed, 07 Jul 2021 20:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mC/f+QSHDMCqJrFCFmbwSJ3aarcLfRODUMWoBq8+yIc=;
        b=norYH35CDzEHDF0uor9MmTTBuIFAMx4HLjWNM2Q4iNxbSqdyy8iSzFvqxnRm3bfHgh
         ZFdzMlgqtcYtOCp8d6qYKwQPo/y4wVBeHoz5lTNVNlUEydAosUqZh5r7Z22P1yZsGhLr
         txRN/75fQEXWM8zi1+h80xHm9NUW4zpvTsGRCx8MawKmxs33z4hIkHiS5M22LUDn28np
         GZPwlVOggOm/0SNjsjDpEHX5kpTJCgMP77NgNfJ0jH5eILU4KrphKKx9yP/WvutZYzcM
         8YmGRRoYFQgC0fiBUQpiSdP2SB8K/KkyjGlEbuEQNzlCP0HARE0CKTqvj6eKJTQi16UX
         WQNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mC/f+QSHDMCqJrFCFmbwSJ3aarcLfRODUMWoBq8+yIc=;
        b=isJFD6DhAvGIoN5f2u7Zh2Ua6oZhUJs6XxhNzLSXPQ4m+PEqOYHalmgd2S/DYYDTnK
         2RfmIKvDRBh+OirC9lfzAuE5Uih1uTlGdsjLqD4IlPV2PQvZ/4CrvMEJxHRHZOr0vXsQ
         OPeBPyoVwrw2s7p69pQbs4Bzrx9l725PkDCbUKpzZD/weojweDmtdCq/TZIp6aqSFFPK
         1XEmkt0qyby7FbTb7t4bWhnSfWW0k0ddZFtIhhT+LHXBbSVGJknjljJw1sHmnTOfpOLp
         kdWnDUFgaZPWu5vFtkhQj2y0OXOX+qC+Z4j7MGlZMdrEZmrlx0/8y660MGN43iIDDiFp
         iTPA==
X-Gm-Message-State: AOAM532D81WqsE46cKP6paWtAUgpQjxAp0vRwiDR7ylb+cEDjpjkSEq8
        k6C1iG/jrIeJSatEy9bGoSw0c9CeYzH5G65IyAI=
X-Google-Smtp-Source: ABdhPJw4lMaCj7uhWVqnI2lIvB257JQzz+UgagHG25KZgkjSbVWTwr+pQFqOCktx2BalKwbmRhiSscF+zfzyKyt2c9g=
X-Received: by 2002:a2e:3302:: with SMTP id d2mr5033059ljc.32.1625713200455;
 Wed, 07 Jul 2021 20:00:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210707221657.3985075-1-zeffron@riotgames.com>
In-Reply-To: <20210707221657.3985075-1-zeffron@riotgames.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 7 Jul 2021 19:59:48 -0700
Message-ID: <CAADnVQK4HHSYDsR5Bjsn7k7nGP6bWwzmXAfr=R+6TSjD030_GQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 0/4] bpf: support input xdp_md context in BPF_PROG_TEST_RUN
To:     Zvi Effron <zeffron@riotgames.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Song Liu <songliubraving@fb.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 3:17 PM Zvi Effron <zeffron@riotgames.com> wrote:
>
> This patchset adds support for passing an xdp_md via ctx_in/ctx_out in
> bpf_attr for BPF_PROG_TEST_RUN of XDP programs.
>
> Patch 1 adds a function to validate XDP meta data lengths.
>
> Patch 2 adds initial support for passing XDP meta data in addition to
> packet data.
>
> Patch 3 adds support for also specifying the ingress interface and
> rx queue.
>
> Patch 4 adds selftests to ensure functionality is correct.
>
> Changelog:
> ----------
> v7->v8
> v7: https://lore.kernel.org/bpf/20210624211304.90807-1-zeffron@riotgames.com/

Applied. Thanks
