Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCD533F991
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 20:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbhCQTvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 15:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbhCQTvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 15:51:40 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAE7C06174A;
        Wed, 17 Mar 2021 12:51:40 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 15so4781826ljj.0;
        Wed, 17 Mar 2021 12:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VzQBD837Zk1zEE5Iz7CRU5SLWREGhnXHICCVYkscOfc=;
        b=No5LWjJXssMUs0UXhpwbVW0DuHSXGjX1P2/w7D3hj4mYl3VvTG3P5VAmH0SM62x/dT
         PqrG00moq/L7hqU6fXua3oramWcVCzElc/GzyDOJ9e7udlSeaStUw5CHq6fSGBJaza4p
         TohikbLMye+bT7zmNfG+PVUvnKXDt/wquXD969rer5t3QB+NFex0DD64oshMyLHfAYtM
         n1g3axMAGsi6NbsB7wc6N87VW2Pu6wjhaobYZ2puA20/0me5dy9Q6VK/86Om1cU/5hJP
         cHHvnb/P/dkOZ6KYzIlihzhLvmT96jUg5QskD6XvOxYajvr2ZUe8mzuZgyMeHFf7fqfX
         Ma3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VzQBD837Zk1zEE5Iz7CRU5SLWREGhnXHICCVYkscOfc=;
        b=hrVQonJGX7KmVFuyRceNeZdisnjZJaDRzPxpvmyH3LuS1w5h7A3QzUPWl66aQ4vnYV
         W6WvVrEm4QPSvYlf0ZSo2EKv8sJesVKVzI50CxXvCFoz0aWylvhASuCmZiwKz+KC2N1q
         SMLXzesEeOhGetzxS9j9ijE21UoFbKxIETa6v+L9jZY/ER5sPuEal6M58jBoVKJ4a+Bi
         ykZJ8c0RBRNLOSiPECAQqJoY8+Mj6ND9zzRvmmNgJUiCUS5nR97U3dFdwcVsFAvQT+MK
         ttfVA8DHl/l5/FdRYmdqldWlXEquGEQ73hpbSczTp2mImuIVC+pdMT/h7OKDQfwYwzOU
         l1hQ==
X-Gm-Message-State: AOAM531W7Qu2scdPlQvKDchVG6jbdkhK5JWJx6GnK+jYgpK0meTe4tuj
        q+7STHn27r8oCC9bR3nO+IJGTUoQ1ifY4CRIo5Y=
X-Google-Smtp-Source: ABdhPJyDl038EMrMS8D0eUwFstC4lVMlO1PBhSPXP5inoBsNmAyT40HGMm8TW7qZ156bRzt7NxGocN1usLMO4lmkz7Y=
X-Received: by 2002:a2e:900b:: with SMTP id h11mr3340022ljg.258.1616010698713;
 Wed, 17 Mar 2021 12:51:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210317125147.2159512-1-Jianlin.Lv@arm.com>
In-Reply-To: <20210317125147.2159512-1-Jianlin.Lv@arm.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 17 Mar 2021 12:51:27 -0700
Message-ID: <CAADnVQLB1MoqHekQa1FrjybqmA9gBHcBcaezULb=v5PgthRB6A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Simplify expression for identify bpf mem type
To:     Jianlin Lv <Jianlin.Lv@arm.com>
Cc:     bpf <bpf@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        OSS Drivers <oss-drivers@netronome.com>,
        Linux API <linux-api@vger.kernel.org>, iecedge@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 5:52 AM Jianlin Lv <Jianlin.Lv@arm.com> wrote:
>         return BPF_CLASS(meta->insn.code);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 2d3036e292a9..5d77675e7112 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -21,6 +21,7 @@
>  #define BPF_DW         0x18    /* double word (64-bit) */
>  #define BPF_ATOMIC     0xc0    /* atomic memory ops - op type in immediate */
>  #define BPF_XADD       0xc0    /* exclusive add - legacy name */
> +#define BPF_SIZE_MASK  0x18    /* mask of size modifier */

Pls don't add kernel internal defines to uapi.
