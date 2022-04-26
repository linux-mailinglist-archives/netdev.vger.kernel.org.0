Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB0450F12A
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 08:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236606AbiDZGkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 02:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245428AbiDZGkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 02:40:11 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B86F8ED4;
        Mon, 25 Apr 2022 23:36:53 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id t4so10793585ilo.12;
        Mon, 25 Apr 2022 23:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wECC4R+QuVfiSAeYQyQoWz/cNQFjmW/f1KrV57yGY/s=;
        b=ifo0pjVVCOEi0N8CXzwwLKldAR4kaNVU01B1FoDWmzqF4Ths7o4tP4kKaFG0QcqfMF
         M/B7hcDS7zk4cbwpBjhznPTd78IaDCMYtyo/MwZLlGxmJumZEVQynjxsMOpj4vBKo+F2
         eXGgYv+7tdiTnbDmSMTjEX3yPGNKE3rB0OXDcclsdNLFwAeYaphBqnicCjK2HKElo128
         Wpwop2fKK36XXmLS1ZYsYDci8Tnd9yhsxeSKnD51QLZqUZwTYo2/VsvY/eEp/ohZQznp
         0cPgwbU0NweccsO22jPnnNrRPswqTQpeyGLpsVunWTcsyrRhoyfRuMG/8fpRPXsnOI/D
         7wbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wECC4R+QuVfiSAeYQyQoWz/cNQFjmW/f1KrV57yGY/s=;
        b=EpL4VW6JgpbCTmmJw18wPXqwjFoS3LzGvHBI8UxM6ZaE1hpddkesFCCPxnMVh9WYJ2
         BcCu41Mj7hZIbxbVhKw1Xr/kZRabBQvq7en4hSNhZxu1IjmGX/Kp1l8PZt30omobzcbW
         vxUkTUIp9yBEBBHxli8YMb7MuevHY1g8UgemXUXk6F0ojwYdi6IggVQNPym3LHoYp6hR
         +G0XQa24GS6YRbTE7v5PWCFsqc1crIIrvY84Lpyqd04w1RCUNi4UG69knOmEFYbdmW0m
         crGRuHtEr0ZE/e8d/4SODwb9Gg4GMX+BJnW5ZpFwAJhwY96h9ctKQCVQstaKGIUDygiv
         ipDg==
X-Gm-Message-State: AOAM5323vehq8Ie01c09JvYJU8uSEO/HtEDykBPSSNCRDcd4O9iEWfxI
        WRuopp1uFRSKq7VHDAgG6kx1gLG/nWeNKlnJamzIT2xi
X-Google-Smtp-Source: ABdhPJwbSL2NV4RgfA/38RWAWWiVALA0Rp/QI1vPmKztG+nn4vIhfpMk+RBTR7/dnBcNfBl30W3eRlEjnj93HFZHTcs=
X-Received: by 2002:a92:c247:0:b0:2cc:1798:74fe with SMTP id
 k7-20020a92c247000000b002cc179874femr8318736ilo.239.1650955012791; Mon, 25
 Apr 2022 23:36:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220420222459.307649-1-mathew.j.martineau@linux.intel.com>
 <20220420222459.307649-3-mathew.j.martineau@linux.intel.com>
 <903108df-161e-515b-da3d-bff4fb49de39@iogearbox.net> <779c3a31-381d-75b4-5f7b-be36e9816068@iogearbox.net>
In-Reply-To: <779c3a31-381d-75b4-5f7b-be36e9816068@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 Apr 2022 23:36:41 -0700
Message-ID: <CAEf4BzYzCCFRj2Bvv+7kv5AT2WM_Vb6hLYyNGP7FAT9mkG2afw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/7] bpf: add bpf_skc_to_mptcp_sock_proto
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, mptcp@lists.linux.dev,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
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

On Mon, Apr 25, 2022 at 7:29 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 4/25/22 4:26 PM, Daniel Borkmann wrote:
> [...]
> >
> > Looking at bpf_skc_to_tcp6_sock(), do we similarly need a BTF_TYPE_EMIT() here?
>
> (Plus, CONFIG_MPTCP should be enabled in CI config (Andrii).)

Should be done once [0] is merged in.

  [0] https://github.com/kernel-patches/vmtest/pull/77

>
> Cheers,
> Daniel
