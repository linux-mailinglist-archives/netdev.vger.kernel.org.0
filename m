Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5FF14AE9C
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 01:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbfFRXOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 19:14:46 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43745 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfFRXOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 19:14:45 -0400
Received: by mail-qk1-f193.google.com with SMTP id m14so9726907qka.10;
        Tue, 18 Jun 2019 16:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nUJyTOBr07ElnYs2HQoC3oZAyTFmNy4t0+c6Ubqs298=;
        b=NDMCCdze0gFOkQ60x6zFr65ftnyxHP33PrJH+KcRfyDqDK1NhEtmoPb8lJuutFUYvl
         JbLtXi5+ff7ep3ucukea2w82+34X6EEbzww/SshiNmQFc3SwPMBkG1kml0752KTYpVM1
         qXjD4jO1e9x/Il3JHMAtXmnd3xYsXdegCCT0ffkegX5FQx23pdVcyJs6SRBe11T4MS95
         mCprD6JYyYjATvrnOm8/yiUpqvMlBgq9vikdc9Aff/0ENcD/gcFiq+0Q0eTcV8htPew7
         jqPSeyvnFYKc7+fSBzUXxsnWnZc/lnZxbDMfgs58tfo98L46ZDVeYrJPCBMbKMixmeQq
         DpiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nUJyTOBr07ElnYs2HQoC3oZAyTFmNy4t0+c6Ubqs298=;
        b=TO1J29ckOrPxbFmxjTQB1768PbVKp0kLFL2KEZDKVBBtJ2y64QxVLSvDdludhlLMJx
         1CbVk/YWY4LQr83vTcomsw6K0kqVfp+kyT7NKXwu7x0+vxYwvFxnw0zVmbOv8hOaJWMo
         hOzxHCCH9J9+L3oVGbdFOurECDbKc75D/tFLj24ym14Wirki42OOH9ZEtlTr7JrG4W9H
         apM+IXxWSH4ivqeH37i8P3kKXISJ8FOzF4P4fusb7jh9yPJZMgAX8YjiDSBHCguyWjFx
         yeoxrPH5L4ClqhkqoGGxDlp2J81wrXE4G6mnJVOBfaivQzVEj1uivX7h7gBGnBKdemNA
         UXHw==
X-Gm-Message-State: APjAAAVTkZ0w4ubqzXbwpGxIr+5DK3AyYLSfJL7Dg5zrwxVAFEGk1mV/
        3gI5pnFuyA2uW6rHB1H8Y28BiuYVe9c4ALLs/rQ=
X-Google-Smtp-Source: APXvYqz14D0hxIO4S8XyjBXRe9lvqOakozyAV4Q4rcpuW9Rv3Jp7+06zY+zcOZuTR5LJMHuEJYxfthyS7uEuA7kNlGw=
X-Received: by 2002:a05:620a:147:: with SMTP id e7mr95845692qkn.247.1560899684493;
 Tue, 18 Jun 2019 16:14:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190618181338.24145-1-mrostecki@opensuse.org>
In-Reply-To: <20190618181338.24145-1-mrostecki@opensuse.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 18 Jun 2019 16:14:33 -0700
Message-ID: <CAEf4BzYbo2_mTUzBRETecvuofwbDTX-48OEB96OzRMDghrA_6g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples: bpf: Remove bpf_debug macro in favor of bpf_printk
To:     Michal Rostecki <mrostecki@opensuse.org>
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-rdma@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 11:13 AM Michal Rostecki <mrostecki@opensuse.org> wrote:
>
> ibumad example was implementing the bpf_debug macro which is exactly the
> same as the bpf_printk macro available in bpf_helpers.h. This change
> makes use of bpf_printk instead of bpf_debug.
>
> Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  samples/bpf/ibumad_kern.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
>

<snip>
