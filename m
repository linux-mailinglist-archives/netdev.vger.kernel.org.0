Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9CB546A61
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 18:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349597AbiFJQaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240625AbiFJQap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:30:45 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C5D5676F;
        Fri, 10 Jun 2022 09:30:42 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id bg6so34671888ejb.0;
        Fri, 10 Jun 2022 09:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dsz7BLFfG2oDPkvGvetFh42i9n6sbqi6LYnQ4Q8V5Nw=;
        b=iVQ5rq62texvFkMsTIBY380T29UAa1mfCM5uJRzZfThalwM7JfUG6a61eWKvURYPxN
         3zp2AUnuu3MGfVljxTr77/XBl643VdY4Be/qlSqXv9QCDyaqf7rEtTbtZpfCLsxbCr8K
         3jBNfvOpKUrG+frMXcqgWnJ3pgXph8F9UaEob2wfVPDynCd7pUlJtBOkTV+ZAjQcGQx2
         SPZCE+ZNq9a1xOiwab8cpCTJtGPG/ucqQlqkgnu1Xw5qx83NHFOhCFT3UIbSEYlYqY5o
         Dpm+pDbLjq8/NPqWaOBT4LezSGCgAANlBLOAz0V1cHeIHhuCRfl75AZHKxlkjSYl0MHp
         SY+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dsz7BLFfG2oDPkvGvetFh42i9n6sbqi6LYnQ4Q8V5Nw=;
        b=h4bk5GCgaUSPVQl7GNtD/Hi88ey6lxNu5IvVrTkoitLisRKuSMuUs4/pITl5V5Vdtt
         2qBo6cyB+vhihrEvbqLZ3IYAoXEwYwZk5bX5fEujB4QbvXHQQZsM1H7e7hXQdcUkNFRG
         jq5d5EXhFs/Pb57b4tDGEOmZBa7PN1C4rhBiKHfgS0dE75gp8LluMW8IYrm3ET5DIA8o
         cOe85op9y0fI17t1jRHiLvg57x7jJeb0OnXgSa+81pzmsarUvLlChFvjFIeJHYkPmdSA
         Etlg5QgvUiwhHvyYKn4+bz3P1th9m87bi3QUjI/yrnqgXTfvo5O1Gr/VMuq5XsX7SE1j
         87Uw==
X-Gm-Message-State: AOAM530ZMOKPTWv/b1vrVjJpxixeyhDNjLTqy2FQwPZKjGwR7eBZyvdU
        shSe9SKRhj5Ld0Jzir8pBx56N99vTkmKXPBkL6g=
X-Google-Smtp-Source: ABdhPJxxETMbtYHXdaNXqDm0kkF8eBxec4mWAMVfVoFyWU1k2p2uWimGmAJ4WZNQ6S2p2b6vni3i4dOrlgcuxR8007Q=
X-Received: by 2002:a17:906:14d5:b0:711:c55a:998 with SMTP id
 y21-20020a17090614d500b00711c55a0998mr27458446ejc.708.1654878638548; Fri, 10
 Jun 2022 09:30:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220610135916.1285509-1-roberto.sassu@huawei.com> <20220610135916.1285509-2-roberto.sassu@huawei.com>
In-Reply-To: <20220610135916.1285509-2-roberto.sassu@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 10 Jun 2022 09:30:26 -0700
Message-ID: <CAADnVQKWS5kQ-ekzDFV=2+y9kkCYCKaAStNJhAr6G2G-N6Q+9w@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] bpf: Add bpf_verify_signature() helper
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <lkp@intel.com>
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

On Fri, Jun 10, 2022 at 6:59 AM Roberto Sassu <roberto.sassu@huawei.com> wrote:
> +       keyring = (keyring_id == U16_MAX) ?
> +                 cred->session_keyring : (struct key *)keyring_id;

This is too limiting.
bpf prog should be able to do what *key syscalls can do.
By doing lookup_user_key(id) -> keyring.
Maybe it's ok to have a special reserved id that does
cred->sessions_keyring as a shortcut, but that's an optimization.
