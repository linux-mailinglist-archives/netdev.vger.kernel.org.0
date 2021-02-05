Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE67D310262
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 02:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhBEBrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 20:47:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232678AbhBEBrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 20:47:49 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE79C0613D6;
        Thu,  4 Feb 2021 17:47:08 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id q12so7520226lfo.12;
        Thu, 04 Feb 2021 17:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HFUlgfa0yv/MLmEQsXGfPFb3G6FL4A5NprSd5CvPpMk=;
        b=r0yzv6pS19Vm35q0pMRBx8aAia/+6IDUR1k5NL6AYrf79UDYfw6vMbNRN5ecjSlKmx
         B6eo54PGuK7/ON0tEVH3reuY0J7Cr5FpKy46tt8coqUGsldoRWyUb4ReUJJjVmJsocPR
         zkDlzn5a/0VknhuBCwp/GGgkzGNaRoSlzXfLCHFQ+PNs7QdNhGp8iN7JgiP6myAZxJ/9
         kf8gvqmM3KqpYnAsAUmRPWviV/eaOgNinIsseJtJbmx6ucxLiu8TDWdYX++yoh7KyCvN
         I4l0yiOJfnll0dJMyRNN9OZpDtXqVm6NjvzBfMy+fkoKnlIuIwxKZ23wmg6z05CvAf3h
         rc6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HFUlgfa0yv/MLmEQsXGfPFb3G6FL4A5NprSd5CvPpMk=;
        b=AOcw7Dcqq3TaVRoXwuUFyDE7TcmZ1GMPils3GQrRu0RcSPYrz0WOg8xO5qU/Ggky4p
         8TRe6p+AGktWgS93pLHoEiFFQk+atTIY+44D7QRX9gKVtNh0RtsK1+wU56sHVDGqQ44o
         UQtaozZfRDMn3Iyp0CJfta9ue/3plu4C13yyzjPlkBOSt6QbzfBBPa81mQagxOktUn1z
         UaoJ/DF9lKCr0iY8tQvXUDxCBo7fkM1AAdZoIYcTwllLe0E8PtrcT97FmShQT3fQ4E48
         QCPGMOOBYOCWEIMmai01ipCGxmXmLZFAVVFN26LSPnR/TeFVhgZZ8k1WTvaBx/PNZcU6
         KPMw==
X-Gm-Message-State: AOAM53331V6JTF6KgeVVzfdwcypkRxeT/dIVTdreAH14zwCV/JRlPZy8
        pNcdnsId7pAKiGk6+YoZ6oZdnhNR1aS+7WIm9Kw=
X-Google-Smtp-Source: ABdhPJzN6nDTfTI5N6Ze/d63acaPTf5IvURc4EmTRMRKa0cicEA0x9aDrF8Vv70X+2ElBIPK216DaYBJuex8iam1x9A=
X-Received: by 2002:a19:787:: with SMTP id 129mr1276232lfh.540.1612489627417;
 Thu, 04 Feb 2021 17:47:07 -0800 (PST)
MIME-Version: 1.0
References: <20210205015219.2939361-1-xujia39@huawei.com>
In-Reply-To: <20210205015219.2939361-1-xujia39@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 4 Feb 2021 17:46:55 -0800
Message-ID: <CAADnVQL5NBY2E2iGCYZAeGN5gtcK0uyM1UpDNaZ28Ukrrb8tGA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: clean up for 'const static' in bpf_lsm.c
To:     Xu Jia <xujia39@huawei.com>
Cc:     bpf <bpf@vger.kernel.org>, KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Florent Revest <revest@chromium.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 4, 2021 at 5:40 PM Xu Jia <xujia39@huawei.com> wrote:
>
> Prefer 'static const' over 'const static' here
>
> Signed-off-by: Xu Jia <xujia39@huawei.com>
> ---
>  kernel/bpf/bpf_lsm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> index 1622a44d1617..75b1c678d558 100644
> --- a/kernel/bpf/bpf_lsm.c
> +++ b/kernel/bpf/bpf_lsm.c
> @@ -67,7 +67,7 @@ BPF_CALL_2(bpf_bprm_opts_set, struct linux_binprm *, bprm, u64, flags)
>
>  BTF_ID_LIST_SINGLE(bpf_bprm_opts_set_btf_ids, struct, linux_binprm)
>
> -const static struct bpf_func_proto bpf_bprm_opts_set_proto = {
> +static const struct bpf_func_proto bpf_bprm_opts_set_proto = {

I totally agree that it's more canonical this way, but I don't think
such git history noise
is worth it.
