Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87A9A1246E9
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 13:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfLRMcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 07:32:17 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43964 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726916AbfLRMcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 07:32:17 -0500
Received: by mail-qk1-f195.google.com with SMTP id t129so1358864qke.10;
        Wed, 18 Dec 2019 04:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aLkpgMoG1dmYJAukFIsWDc5P77DX3n4iFGAozmJ72XM=;
        b=s+yGX02HKVXAIvvVvkgyFPZZgK5cj8wgPBT/RpOotSy/DQ0iFgAzn7YzxSOFAzoexg
         9HHk4SxZza1TPHNAdH8nssRQffv+4FKJJ6X+a5165HPzXYNm2oRHyPjTyMsahskMWpvE
         iM50X1ObuwoZE1mGRme8DmxbqPB8O0koz9nqBrbL+KDAJQAD1O0WyL0Me+n+XJuOqdVD
         PpXtqdU5KpqkiqDp68WFAEUaNB7fZ/YZIoDlpygiZoqYgXxnSQ/DQnZXfTIoFMJd2th+
         KcaAf1vYZhWv3B6AHJQjmDKzLm70G3xyRNQKMAk7xQgpa9gT/3dR8V/CKRabNBkqPJEX
         TB0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aLkpgMoG1dmYJAukFIsWDc5P77DX3n4iFGAozmJ72XM=;
        b=qAz3QuHyUC203H8QJS0ZxmgKQMXZP7aKrVMpr6MfuT0o7ubZrV+i6gqhJigGnnAQ5+
         P4muK+CoH865GJw/rLfmGUBPmqex5AusxLBPBOiLAHPzSNrPe7MI9dTLS9qqs/NvQrtY
         Vz1Th5I7YCnHw7ECPEAr2xxksYRZ9aSi8JB2Xq8EdtjSJFe1XNx+MygeJtDtqQbGLRzN
         bO6uJvxopGYXOFBaaA2gxO8jqZ4kbTFsh7rGGx4UdEGT0zEnTgcjQUaXxzG051Cr1rmL
         H/7oCMek7DnbNIxgknrsqcqGPfwKv8ouRn9nMO2lY+wL6v8fS4/SKI7XJLplWxLYZcsN
         sYyw==
X-Gm-Message-State: APjAAAX/DNCpZnn/82CU/ZLrlC7M1iv6HEeXylSzYernX+LuQRnNsrHE
        T6C3h0wk53nacviTT5yDubmUnIZsYZIU3D7tPM8PmQT3dAg=
X-Google-Smtp-Source: APXvYqy5i5/OtZydAz7LODCo++plINkkXo/KP/M5Lnip7W6nN+yfmzgG3yKqkzaeOCtBtljVmzeBxxktCtALXcHF5I8=
X-Received: by 2002:a37:63c7:: with SMTP id x190mr2167789qkb.232.1576672336605;
 Wed, 18 Dec 2019 04:32:16 -0800 (PST)
MIME-Version: 1.0
References: <20191218105400.2895-1-bjorn.topel@gmail.com> <20191218121132.4023f4f1@carbon>
 <CAJ+HfNgKsPN7V9r=N=hDoVb23-nk3q=y+Nv4jB3koPw0+4Zw9A@mail.gmail.com>
 <20191218130346.1a346606@carbon> <CAJ+HfNi+hAKY+yyW=p+xzbc=0AGu4DcmyTBGmnJFBjQnC7Nb4Q@mail.gmail.com>
In-Reply-To: <CAJ+HfNi+hAKY+yyW=p+xzbc=0AGu4DcmyTBGmnJFBjQnC7Nb4Q@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 18 Dec 2019 13:32:05 +0100
Message-ID: <CAJ+HfNhW-vUy5E2TzOQh2GHZRux1DTtMeWS7bhQFEwiN-8=baQ@mail.gmail.com>
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
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Dec 2019 at 13:18, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>=
 wrote:
>
> On Wed, 18 Dec 2019 at 13:04, Jesper Dangaard Brouer <brouer@redhat.com> =
wrote:
> >
> > On Wed, 18 Dec 2019 12:39:53 +0100
> > Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:
> >
> > > On Wed, 18 Dec 2019 at 12:11, Jesper Dangaard Brouer <brouer@redhat.c=
om> wrote:
> > > >
> > > > On Wed, 18 Dec 2019 11:53:52 +0100
> > > > Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:
> > > >
> > > > >   $ sudo ./xdp_redirect_cpu --dev enp134s0f0 --cpu 22 xdp_cpu_map=
0
> > > > >
> > > > >   Running XDP/eBPF prog_name:xdp_cpu_map5_lb_hash_ip_pairs
> > > > >   XDP-cpumap      CPU:to  pps            drop-pps    extra-info
> > > > >   XDP-RX          20      7723038        0           0
> > > > >   XDP-RX          total   7723038        0
> > > > >   cpumap_kthread  total   0              0           0
> > > > >   redirect_err    total   0              0
> > > > >   xdp_exception   total   0              0
> > > >
> > > > Hmm... I'm missing some counters on the kthread side.
> > > >
> > >
> > > Oh? Any ideas why? I just ran the upstream sample straight off.
> >
> > Looks like it happened in commit: bbaf6029c49c ("samples/bpf: Convert
> > XDP samples to libbpf usage") (Cc Maciej).
> >
> > The old bpf_load.c will auto attach the tracepoints... for and libbpf
> > you have to be explicit about it.
> >
> > Can I ask you to also run a test with --stress-mode for
> > ./xdp_redirect_cpu, to flush out any potential RCU race-conditions
> > (don't provide output, this is just a robustness test).
> >
>
> Sure! Other than that, does the command line above make sense? I'm
> blasting UDP packets to core 20, and the idea was to re-route them to
> 22.
>

No, crash with --stress-mode/-x. (Still no tracepoint output.) And
bpf_redirect_map() is executed and the cpu_map thread is running. :-P
