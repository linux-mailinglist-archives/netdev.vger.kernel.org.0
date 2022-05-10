Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E380520A1A
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 02:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbiEJA2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 20:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiEJA2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 20:28:40 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CEB729C89;
        Mon,  9 May 2022 17:24:45 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id i22so10396773ila.1;
        Mon, 09 May 2022 17:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gNVj1bVEL6aKSUi4/hHbvFhxiVbMHNx71LPdSMc37mY=;
        b=Bll/6C2VDAE0GxA0M8QoATWx8Mqv4FeGGh+8ZZU4cxnRVcY5aiwsz33NtC0uQaNds4
         35Bh3fgW8S5n8Lc2NFM1a/hvhhhV+9P2lLGswEVHLwf6dAqhmXjx0/ITKHi6qZuWMD86
         EOygNTZT5tLX6kwI5og6vye+gXAGJq2PvXwQMOOyzD9N8malhmMa+L2jAS39ZmUSUBJg
         WFNCJRROuzXtpORTI9jzY6FNQQihwXg3L/RLIzU34p3GodPuC5kTFJwqEMn8CTr8nmM1
         6OFzpa94l0pNRzAU+W59PwEfW1bByZB2eMasgLDKtw27hFhccyKAsgrhrPXTlvaFUsUr
         4Nwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gNVj1bVEL6aKSUi4/hHbvFhxiVbMHNx71LPdSMc37mY=;
        b=lXqRi8bgfXhrooJVbu6UPwhCMuqDo6+R+ZKr0YajcRY/pd5/ac3OkEEdlHX+UEfwvC
         HZX9MkhNNchVtUf60tFegFhWLczpBMfXxwm3vD/sOcVrOJncBrrE+QCcknNfbTKwKizb
         L05IeBxC7KosBEqKRKd5QsynvhiIgR342WweetTYydLFWn9JY6AlGnp4H4BuBotrAmVR
         ZDL2VQDWKGgb+8TzCRi8DV1cvOFO8shsImsGCFEj5F2L0yuQJULcJwasFLOMd0PYyZwH
         6nCnrWiBOuaJNf6IoKbLCwo3I1C8V1G3tPZJ48vwexV5Rag2BW+7sS1nm6+1VSDu79Pf
         eSfg==
X-Gm-Message-State: AOAM531PabG08/W3T8WeZdT+wxI7FxgMGGdQwnMTa2nKQE5zcSCoq+wH
        eViRsFv7W4hPorqQGtM/i5/FAR+uJZycre2lCg8=
X-Google-Smtp-Source: ABdhPJzJZHkuxuV+CroH1dy6hXZk31Irh7Sf94R+6RiBIbcAY0lLVNPNI8rl6CUjfwZcn0xVPxLiuYFR0OpcRmtMJEw=
X-Received: by 2002:a05:6e02:1c03:b0:2cf:2a1d:d99c with SMTP id
 l3-20020a056e021c0300b002cf2a1dd99cmr7829321ilh.98.1652142284415; Mon, 09 May
 2022 17:24:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220505130507.130670-1-larysa.zaremba@intel.com>
In-Reply-To: <20220505130507.130670-1-larysa.zaremba@intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 9 May 2022 17:24:33 -0700
Message-ID: <CAEf4BzZ=_C6pOjoLKpbZaWB0=28YhbPvU3f9sS5P1W3Lc_NQHQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpftool: Use sysfs vmlinux when dumping BTF
 by ID
To:     Larysa Zaremba <larysa.zaremba@intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 5, 2022 at 6:17 AM Larysa Zaremba <larysa.zaremba@intel.com> wrote:
>
> Currently, dumping almost all BTFs specified by id requires
> using the -B option to pass the base BTF. For kernel module
> BTFs the vmlinux BTF sysfs path should work.
>
> This patch simplifies dumping by ID usage by attempting to
> use vmlinux BTF from sysfs, if the first try of loading BTF by ID
> fails with certain conditions and the ID corresponds to a kernel
> module BTF.

It feels sloppy to first try without base BTF and then fallback to
base BTF. When specified ID of BTF object, let's just get its struct
bpf_btf_info with bpf_obj_get_info_by_fd() and then check that
kernel_btf is set and name isn't "vmlinux". This will mean it's kernel
module, so load base BTF from /sys/kernel/btf/vmlinux. If that fails,
there is no way that kernel module BTF will be successfully loaded, so
there is no point in trying.

>
> Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
>  tools/bpf/bpftool/btf.c | 67 +++++++++++++++++++++++++++++++++++------
>  1 file changed, 58 insertions(+), 9 deletions(-)
>

[...]
