Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08B12102C10
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 19:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbfKSSw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 13:52:56 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:32962 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfKSSwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 13:52:55 -0500
Received: by mail-qk1-f193.google.com with SMTP id 71so18836008qkl.0;
        Tue, 19 Nov 2019 10:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EPnRZnPz0SVNZy49cNCXUGzrr5PJ4Bk/OZcFQYiIX58=;
        b=ALQNf6ElapHnlZ8CAOBpqvAONNqxktpr2nppUCOqrqgo1FsNYe87poisUEk3GtczQb
         zEpHO7/iDaC7UB07vmrk8w5S5ytRMTEJ1ltgYXmqO5a7LQOANMDZJg7ZqZvqXvB2L5FS
         56qcEaXJdxKMh0XzQMRpqhBvsA/wCu0mXwqR7VBasMgNV7f5AFwA3cuJlJCakQFXdiqn
         bY7rNKcOZTEJuFM0jtOlrar0IRtUzlkUT3sC5ff9orb5bKkCihF5HUY7mmC4sbbJgeqT
         CXAYF3f+3HrEgmDZHS2AWtkxDMuSbKc1GdZTrUOAjTfvXSTEaT+8f1tcUHyH5qkaF+wU
         f1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EPnRZnPz0SVNZy49cNCXUGzrr5PJ4Bk/OZcFQYiIX58=;
        b=VNPkAfEIvRvL9HtbkydMCc3S99E3GR66RyJhOqoPPnKx7+vPGHwQLeZwM0sHpmM/4c
         47Xy/NKsGWH/Xt/k+x2SKyh1LBFe3+Hk5hefGb7g6N7AIV5Dn7YF9JtJfIBfAOTJ6eqF
         pCCw0bpkaNv4eHKTaWI9xW8HPHFNaS6ezvQdVGqLTcyQ1LDmSHsQE354Rez+jYV411xh
         pQNXb/9WqiqVxq1IY9STy6xR1pYy1TKlteZftaH7xM13PxYe0C6I+SRbr36RHC0gCV1m
         VJ6b5IPFD6r/OCPx5Oy49OjScdYrxcXOLLBA4ootfYtEB5sx5NY48jry5P7O0lWYUjEi
         nDtA==
X-Gm-Message-State: APjAAAUz2HKm0Vwv7qkAuVzWuKtomeTHeo9U8u1YZ+YLheowD7TINpZr
        pdF0LpxUvA5yxdEDOjp4oJNQNjbb38lesCycJQM=
X-Google-Smtp-Source: APXvYqxE7s91L2D3A9hFwBx009jfeBn54/nQS+1eUtpeLD2LKmepWf3dtAG+2mgkqF5yLS1/7ueh7bz2GLqz8z/I51c=
X-Received: by 2002:a37:aa8b:: with SMTP id t133mr18650892qke.449.1574189573030;
 Tue, 19 Nov 2019 10:52:53 -0800 (PST)
MIME-Version: 1.0
References: <20191119142113.15388-1-yuehaibing@huawei.com>
In-Reply-To: <20191119142113.15388-1-yuehaibing@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 19 Nov 2019 10:52:42 -0800
Message-ID: <CAEf4BzbVj2VLEOEMbiqnDGBYUX=E-edcx6gXgj1S9RqrDpj0-w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Make array_map_mmap static
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 6:22 AM YueHaibing <yuehaibing@huawei.com> wrote:
>
> Fix sparse warning:
>
> kernel/bpf/arraymap.c:481:5: warning:
>  symbol 'array_map_mmap' was not declared. Should it be static?
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---

Yes it should, thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]
