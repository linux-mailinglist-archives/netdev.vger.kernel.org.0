Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02804A08FB
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 19:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfH1RwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 13:52:08 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38338 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbfH1RwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 13:52:08 -0400
Received: by mail-pg1-f193.google.com with SMTP id e11so126426pga.5
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 10:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=jQX3yoLyPfk/0j+lt93BtL/GBDo4w3swgacBIDakXXQ=;
        b=XhlIuiCrJiPd178mhAYLbMaCFhZdbbqbwaKU3q6uJ30qMagqqTw/bFQdZlNUymLTK8
         dAlhmcyR3vP0ZtDqdiHYyudCImcd6mGVQj44mv4tr0vwZxX8d6TFobwdN4uxlZ1uDl/t
         X/kt1Ft483Gh0bH+NGznab4xcFdJ/6TYS+9Yo3rpExBYeqGDHZD6RaHPArHNC3kr2rgJ
         NxILOLue3/+PKN00bZKV+tNBQ8D4tNvwKWRAPKMbVtIL1UD4Gr4sqUnHjy2NZtrlK7hv
         Jg6WoKH+rCjRnSUQMig8d9M/n0qExNh5AHuPyAICyXxTEnIuGS65lVHCT01gHzZmPOSt
         MLHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=jQX3yoLyPfk/0j+lt93BtL/GBDo4w3swgacBIDakXXQ=;
        b=YTpXQaf0zcGqG0NEIVzAqJkD5CR7Exn3JuN4wepg7vGT846V1c2H60VekbkDyOv+cy
         35kYootenW8PWeyFHh5k9EfrGuql0Y2jAosvS4XF7CaWQEQZt/GWPI2qhZTyvmwDEAR7
         Pj8dH0v+MQ90dFaCsRpp2KjzDlInQgcSNQsx7tLrL5pVuLvHaRqw6DPu529C2EzEwAXK
         m5jX/IfQdC0m9ZXlyuW2QSQZnaxvEGSjwsKQtnFTZBjy3ATD46L3IYg2LBu3bzXpm20a
         Mc1S+z1kLxtnuW5Q7oQ6ly4Lsa01CioYedopzsHPR5T5Yclm3yb8/GkfiKjks89MxjBb
         zyLA==
X-Gm-Message-State: APjAAAWNx7fmHV2k5hZE05l7VVjcXAfGouIOmZGuk0BTfPtfaAHHE7r9
        jvTiLF7ejLaXWq8iyrh69Yjw5w==
X-Google-Smtp-Source: APXvYqxOrLR3mQwFe9lP+xvQ8UaEwRlRzDb4ILg8zRF5qtKWo+EbZYY96fc4AyXGZBZM2GL8Qh83Qw==
X-Received: by 2002:a17:90a:9905:: with SMTP id b5mr2493871pjp.117.1567014727512;
        Wed, 28 Aug 2019 10:52:07 -0700 (PDT)
Received: from ?IPv6:2600:1012:b023:28ef:14c8:9cc:b602:d8f? ([2600:1012:b023:28ef:14c8:9cc:b602:d8f])
        by smtp.gmail.com with ESMTPSA id x10sm2728615pjo.4.2019.08.28.10.52.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 10:52:06 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2] riscv: add support for SECCOMP and SECCOMP_FILTER
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16G77)
In-Reply-To: <201908251451.73C6812E8@keescook>
Date:   Wed, 28 Aug 2019 10:52:05 -0700
Cc:     David Abdurachmanov <david.abdurachmanov@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Abdurachmanov <david.abdurachmanov@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        Vincent Chen <vincentc@andestech.com>,
        Alan Kao <alankao@andestech.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, me@carlosedp.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <419CB0D1-E51C-49D5-9745-7771C863462F@amacapital.net>
References: <20190822205533.4877-1-david.abdurachmanov@sifive.com> <201908251451.73C6812E8@keescook>
To:     Kees Cook <keescook@chromium.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 25, 2019, at 2:59 PM, Kees Cook <keescook@chromium.org> wrote:
>=20
>> On Thu, Aug 22, 2019 at 01:55:22PM -0700, David Abdurachmanov wrote:
>> This patch was extensively tested on Fedora/RISCV (applied by default on
>> top of 5.2-rc7 kernel for <2 months). The patch was also tested with 5.3-=
rc
>> on QEMU and SiFive Unleashed board.
>=20
> Oops, I see the mention of QEMU here. Where's the best place to find
> instructions on creating a qemu riscv image/environment?

I don=E2=80=99t suppose one of you riscv folks would like to contribute risc=
v support to virtme?  virtme-run =E2=80=94arch=3Driscv would be quite nice, a=
nd the total patch should be just a couple lines.  Unfortunately, it helps a=
 lot to understand the subtleties of booting the architecture to write those=
 couple lines :)

