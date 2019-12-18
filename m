Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 446381245F5
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfLRLkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:40:05 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42562 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbfLRLkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:40:05 -0500
Received: by mail-qk1-f193.google.com with SMTP id z14so12023qkg.9;
        Wed, 18 Dec 2019 03:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VF7M74iFDEHbLjZXvVpR+B4z1bMLQ5N+ZnbxO5V4x1M=;
        b=sr3hQCaUK6+I78wkwY2fL5lSYcDA3pM2lHkQQAWHZx2gTcjVPS5ruYxv6NaiP+xAO7
         Yh/vZdNmDxu+b3A4V17ssylpAv8ILdm+tX5u4VvfNLXm2+SR7DLSg1tezQIDRF3FByR2
         Fv8AAoqIjgh75B1R7/8foCqTFeBr1nvfrXW89LUfju1NbO9J5/Yi0RFMiLnfWF9/UdDZ
         kKAPa8JStIsAbxCagI/aopUoqupGoRoXzr1AF2tVDvpxHMJwzxVNK/LMQOq5pmzeCISV
         Cyr6a9SZEeIN4RzPMLhKi98NMlAOEVADrjwAWYsv8no10yxqJP3Jfrv9hdjMTMLIrg6b
         GPvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VF7M74iFDEHbLjZXvVpR+B4z1bMLQ5N+ZnbxO5V4x1M=;
        b=WmkzKFGlcjHrztSduxXwZMrvYgAE0NIB8TKFDNiil23XojKFm2vKyl4Pminjl7WCks
         GXrdhoT/530y+DeW6TY2XA0FEEUxgFFVI47G8x3S3ONaP6s6XSWRbxBOxEEIZF/Bnk39
         SWWlZSRNisZc5zHt6LRGvaMuQoBAFG4EYt2GeZFNj+Ein6tNHMa6UXRh4ysoF632n50q
         oZO1ahQb7hkyUOyJDQg7xBJtRltZio9kLzXwYKmpnpU2cCzXABu4nF4LAEayMgI2eI1F
         V5pbSFKP+Xig3Trt47kU1C3IBYzryA8iOYVBZKFqfaN1yLuClcAgkZFG3LJqyrscrVIA
         Qq2A==
X-Gm-Message-State: APjAAAVfSc+/jq2V7fwCnJtwU3qwlcaFYWUtQ4ObNIvqd7QbH4AaxCDD
        5WTHj/vOl2FZXVs5vatUKkKRIJ2cNhrTp5rrW2c=
X-Google-Smtp-Source: APXvYqwqnREVQhP8q0TvGBJAlWnsBJhh54GWFwZh0nhNX7SdWgQkCeD+Mq9q9Rt+0VPy5o6a/RI2MF7ffei7zSvzkvI=
X-Received: by 2002:a37:9c0f:: with SMTP id f15mr1958886qke.297.1576669204235;
 Wed, 18 Dec 2019 03:40:04 -0800 (PST)
MIME-Version: 1.0
References: <20191218105400.2895-1-bjorn.topel@gmail.com> <20191218121132.4023f4f1@carbon>
In-Reply-To: <20191218121132.4023f4f1@carbon>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 18 Dec 2019 12:39:53 +0100
Message-ID: <CAJ+HfNgKsPN7V9r=N=hDoVb23-nk3q=y+Nv4jB3koPw0+4Zw9A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/8] Simplify xdp_do_redirect_map()/xdp_do_flush_map()
 and XDP maps
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Dec 2019 at 12:11, Jesper Dangaard Brouer <brouer@redhat.com> wr=
ote:
>
> On Wed, 18 Dec 2019 11:53:52 +0100
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:
>
> >   $ sudo ./xdp_redirect_cpu --dev enp134s0f0 --cpu 22 xdp_cpu_map0
> >
> >   Running XDP/eBPF prog_name:xdp_cpu_map5_lb_hash_ip_pairs
> >   XDP-cpumap      CPU:to  pps            drop-pps    extra-info
> >   XDP-RX          20      7723038        0           0
> >   XDP-RX          total   7723038        0
> >   cpumap_kthread  total   0              0           0
> >   redirect_err    total   0              0
> >   xdp_exception   total   0              0
>
> Hmm... I'm missing some counters on the kthread side.
>

Oh? Any ideas why? I just ran the upstream sample straight off.
