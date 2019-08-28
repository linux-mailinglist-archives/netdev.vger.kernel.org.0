Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E31A0C7C
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfH1ViN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:38:13 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34836 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbfH1ViN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:38:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id g7so1299638wrx.2;
        Wed, 28 Aug 2019 14:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sGjhjuh8luS+aqRBrfS7bHWA5KJ+QKi4i3rS6Cai6WY=;
        b=SiERiSw553Kaxk/tRLH5J9b4vOVe5PEhITDMHzFEy2/8RX+K5wXHNtNLCnw4SbRJDk
         JCCiIjdQLrIoZA/CfHjgVs42XEDgAWj4hn7afiVHrFw8LJtdpynYnsoxpBqKbSqTqfJd
         HNKWuEzo2ini90T5kpyxNSKb+8ForNyAOwc/MVmCzxKfCGPiRbo466ilnhXU68kB1bA3
         EhqYXDVTNeccNDqqIA7pYJlVX3RC/R8qfQnLNqoxVjSsXOio6D72LFOvsXoI14FflENV
         wapdyA8ef8PQbXzGRWwhRRf3ISJ1p8DISLOgSWn54ygagD1I+Y5zRELj7YNRL6Zba8BR
         qYwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sGjhjuh8luS+aqRBrfS7bHWA5KJ+QKi4i3rS6Cai6WY=;
        b=WRkPN+kakvwxC+mu/Dm1fIbftsBCSl93ykeqz8HlCDQ2py12fYG5XU5czwS17odAHl
         6nubPsiL0QeNtdwIYBVqeKUJ5GHa7bBvK/rYZ3bQcNna3z7szfsKuYwrmJdtdOtyHjGV
         vi9h1V20qQKiNeBLR69l9KJ6PTreQqsizPNWhLDgi+pIL7aKvWjTT+4DhlFxV/bilA1t
         hTDOnmxwEvrYab2Gj237G+lAxFoeNbcn3yZkM7y++jcR+8IjSZRZG0Fuk+hz62DRtskl
         RKOE5/UNFrAHHVzrEbL0GFEaa3HHcfzBW6kgK6ScL8Rdo2+S33mGq4tQ/h5PGLEb6nwu
         q0xA==
X-Gm-Message-State: APjAAAUsCtrsEjw0AWHVyLLyHEen1a3f6LSkyo1vhdNSTKea32LUfQ3O
        +8gHqwksAnlCevWGbxeY/fV7UWmneQMV++DEwfw=
X-Google-Smtp-Source: APXvYqy0U65XUAnttf145xEP+EHodRd9s98VxWubDUuMO7oGhPo6lBhmmd2Vbn44BFVHtYxXeHabTrxP5Dn2X0NcIS4=
X-Received: by 2002:a5d:51c6:: with SMTP id n6mr7299855wrv.206.1567028290871;
 Wed, 28 Aug 2019 14:38:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190822205533.4877-1-david.abdurachmanov@sifive.com> <201908251451.73C6812E8@keescook>
In-Reply-To: <201908251451.73C6812E8@keescook>
From:   David Abdurachmanov <david.abdurachmanov@gmail.com>
Date:   Wed, 28 Aug 2019 14:37:34 -0700
Message-ID: <CAEn-LToB1atxDvehBanVaxg6sk8zDkMe_CbqeTVgKNzOvD9-Sw@mail.gmail.com>
Subject: Re: [PATCH v2] riscv: add support for SECCOMP and SECCOMP_FILTER
To:     Kees Cook <keescook@chromium.org>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 28, 2019 at 10:36 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Aug 22, 2019 at 01:55:22PM -0700, David Abdurachmanov wrote:
> > This patch was extensively tested on Fedora/RISCV (applied by default on
> > top of 5.2-rc7 kernel for <2 months). The patch was also tested with 5.3-rc
> > on QEMU and SiFive Unleashed board.
>
> Oops, I see the mention of QEMU here. Where's the best place to find
> instructions on creating a qemu riscv image/environment?

Examples from what I personally use:
https://github.com/riscv/meta-riscv
https://fedoraproject.org/wiki/Architectures/RISC-V/Installing#Boot_with_libvirt
(might be outdated)

If you are running machine with a properly working libvirt/QEMU setup:

VIRTBUILDER_IMAGE=fedora-rawhide-developer-20190703n0
FIRMWARE=fw_payload-uboot-qemu-virt-smode.elf
wget https://dl.fedoraproject.org/pub/alt/risc-v/disk-images/fedora/rawhide/20190703.n.0/Developer/$FIRMWARE
echo riscv > /tmp/rootpw
virt-builder \
    --verbose \
    --source https://dl.fedoraproject.org/pub/alt/risc-v/repo/virt-builder-images/images/index
\
    --no-check-signature \
    --arch riscv64 \
    --size 10G \
    --format raw \
    --hostname fedora-riscv \
    -o disk \
    --root-password file:/tmp/rootpw \
    ${VIRTBUILDER_IMAGE}

sudo virt-install \
    --name fedora-riscv \
    --arch riscv64 \
    --vcpus 4 \
    --memory 3048 \
    --import \
    --disk path=$PWD/disk \
    --boot kernel=$PWD/${FIRMWARE} \
    --network network=default \
    --graphics none \
    --serial log.file=/tmp/fedora-riscv.serial.log \
    --noautoconsole

The following does incl. SECCOMP v2 patch on top of 5.2-rc7 kernel.

>
> > There is one failing kernel selftest: global.user_notification_signal
>
> This test has been fragile (and is not arch-specific), so as long as
> everything else is passing, I would call this patch ready to go. :)
>
> Reviewed-by: Kees Cook <keescook@chromium.org>
>
> --
> Kees Cook
