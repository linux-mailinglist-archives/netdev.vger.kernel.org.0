Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0094F2A1A43
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 20:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgJaT3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 15:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbgJaT3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 15:29:39 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A435FC0617A6
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 12:29:39 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id x11so2674643vsx.12
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 12:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n6Z8457/8QknWaEROSHXVf5kekUp6vYwpAMUIe4diPo=;
        b=uRHht+AbUIjNDnhapX4bNNBIIDW35CNm8ygayElxwZ66Kg60acomojUo11FjbNlBLn
         EE/qWzzvryg1aZDIR4uDwv5kUsOBAWY1GOhzL9GkGX+48CpshdsilpOSbpnKytaQxeGv
         cG8fcm37JTsKYi/8NsTDo3RTgIiZsX/IlBah01Un9wjIrjhx2gQjKqymn2EBLRwt4zOf
         sG+uJ5GnQVOJAMKbR3h9TZAJqbhNyNT1acVOfCg3hJF5dby8Rnq3PotT9k3MZI2oYV9J
         KcxiyuNbC335ZIgqSAHVuKqzCkItEHXjXQHvAyTPJLmOSa7KvEBQSI09hVEZlYO6Yg70
         hP9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n6Z8457/8QknWaEROSHXVf5kekUp6vYwpAMUIe4diPo=;
        b=Wv3Co0UEaXqYLQbqxw6/TAdGTGH4hPYwPvXvW0Y6F9SN0w6f3lQRSVVvOgUe4Rtyus
         q1epegnbMvE8vy+xS/PEfS5kbPrs8LqvP+blGJgYPozF0FU3ilX0BN6IPlYYJd0SbIAV
         VEqQstVeGR2wWWjznLE7Js010uLXl/qO/Zn0qWoaBe1qyrpN7DmgsCDGCWN/oCQUel23
         yl7kQ9QNXZ9rxsRTUsyj7+iwyDCbJLYKTxY9ed9U99Q7IF42D6RownNC1qYgV2Gacjrm
         iu1XrE+x19RU4/GKWsHG/bBjODiPq4HEoDOIrUGCkRlcNc4ot3wVnYMaFf5z7K5KD4HN
         x6Pw==
X-Gm-Message-State: AOAM532C7OJZnGzDQCDdYKgNOPMXnfTm1iVMsdX0NYz1ZqfvOgBka6DU
        Y7yjkSoctfWk5E1FBHl4BWiTdH+eORI=
X-Google-Smtp-Source: ABdhPJzHFOra0C8wHC6Tu/FEzpNM0gvO+/3vWWh5yheoWV3aAWRzH1/AlDJakrR1Tf/AHbyfAdbw8g==
X-Received: by 2002:a67:f3d7:: with SMTP id j23mr10642687vsn.54.1604172577729;
        Sat, 31 Oct 2020 12:29:37 -0700 (PDT)
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com. [209.85.221.169])
        by smtp.gmail.com with ESMTPSA id l6sm1227763vkk.56.2020.10.31.12.29.36
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 12:29:36 -0700 (PDT)
Received: by mail-vk1-f169.google.com with SMTP id z10so2185838vkn.0
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 12:29:36 -0700 (PDT)
X-Received: by 2002:a1f:3f4d:: with SMTP id m74mr9957874vka.12.1604172575710;
 Sat, 31 Oct 2020 12:29:35 -0700 (PDT)
MIME-Version: 1.0
References: <20201028145015.19212-1-schalla@marvell.com>
In-Reply-To: <20201028145015.19212-1-schalla@marvell.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 31 Oct 2020 15:28:59 -0400
X-Gmail-Original-Message-ID: <CA+FuTSc9KJg+MSWvXDCMaNSMkXxxKEW6JkDa9wNvQ9xg_7RS5Q@mail.gmail.com>
Message-ID: <CA+FuTSc9KJg+MSWvXDCMaNSMkXxxKEW6JkDa9wNvQ9xg_7RS5Q@mail.gmail.com>
Subject: Re: [PATCH v8,net-next,00/12] Add Support for Marvell OcteonTX2
To:     Srujana Challa <schalla@marvell.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-crypto@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        schandran@marvell.com, pathreya@marvell.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 6:50 PM Srujana Challa <schalla@marvell.com> wrote:
>
> This series introduces crypto(CPT) drivers(PF & VF) for Marvell OcteonTX2
> CN96XX Soc.
>
> OcteonTX2 SOC's resource virtualization unit (RVU) supports multiple
> physical and virtual functions. Each of the PF/VF's functionality is
> determined by what kind of resources are attached to it. When the CPT
> block is attached to a VF, it can function as a security device.
> The following document provides an overview of the hardware and
> different drivers for the OcteonTX2 SOC:
> https://www.kernel.org/doc/Documentation/networking/device_drivers/marvell/octeontx2.rst
>
> The CPT PF driver is responsible for:
> - Forwarding messages to/from VFs from/to admin function(AF),
> - Enabling/disabling VFs,
> - Loading/unloading microcode (creation/deletion of engine groups).
>
> The CPT VF driver works as a crypto offload device.
>
> This patch series includes:
> - Patch to update existing Marvell sources to support the CPT driver.
> - Patch that adds mailbox messages to the admin function (AF) driver,
> to configure CPT HW registers.
> - CPT PF driver patches that include AF<=>PF<=>VF mailbox communication,
> sriov_configure, and firmware load to the acceleration engines.
> - CPT VF driver patches that include VF<=>PF mailbox communication and
> crypto offload support through the kernel cryptographic API.
>
> This series is tested with CRYPTO_EXTRA_TESTS enabled and
> CRYPTO_DISABLE_TESTS disabled.
>
> Changes since v7:
>  * Removed writable entries in debugfs.
>  * Dropped IPsec support.
> Changes since v6:
>  * Removed driver version.
> Changes since v4:
>  * Rebased the patches onto net-next tree with base
>    'commit bc081a693a56 ("Merge branch 'Offload-tc-vlan-mangle-to-mscc_ocelot-switch'")'
> Changes since v3:
>  * Splitup the patches into smaller patches with more informartion.
> Changes since v2:
>  * Fixed C=1 warnings.
>  * Added code to exit CPT VF driver gracefully.
>  * Moved OcteonTx2 asm code to a header file under include/linux/soc/
> Changes since v1:
>  * Moved Makefile changes from patch4 to patch2 and patch3.
>
> Srujana Challa (12):
>   octeontx2-pf: move lmt flush to include/linux/soc
>   octeontx2-af: add mailbox interface for CPT
>   octeontx2-af: add debugfs entries for CPT block
>   drivers: crypto: add Marvell OcteonTX2 CPT PF driver
>   crypto: octeontx2: add mailbox communication with AF
>   crypto: octeontx2: enable SR-IOV and mailbox communication with VF
>   crypto: octeontx2: load microcode and create engine groups
>   crypto: octeontx2: add LF framework
>   crypto: octeontx2: add support to get engine capabilities
>   crypto: octeontx2: add virtual function driver support
>   crypto: octeontx2: add support to process the crypto request
>   crypto: octeontx2: register with linux crypto framework
>
>  MAINTAINERS                                   |    2 +
>  drivers/crypto/marvell/Kconfig                |   14 +
>  drivers/crypto/marvell/Makefile               |    1 +
>  drivers/crypto/marvell/octeontx2/Makefile     |   10 +
>  .../marvell/octeontx2/otx2_cpt_common.h       |  123 ++
>  .../marvell/octeontx2/otx2_cpt_hw_types.h     |  464 +++++
>  .../marvell/octeontx2/otx2_cpt_mbox_common.c  |  202 ++
>  .../marvell/octeontx2/otx2_cpt_reqmgr.h       |  197 ++
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.c |  426 +++++
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.h |  351 ++++
>  drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   52 +
>  .../marvell/octeontx2/otx2_cptpf_main.c       |  570 ++++++
>  .../marvell/octeontx2/otx2_cptpf_mbox.c       |  331 ++++
>  .../marvell/octeontx2/otx2_cptpf_ucode.c      | 1533 +++++++++++++++
>  .../marvell/octeontx2/otx2_cptpf_ucode.h      |  162 ++
>  drivers/crypto/marvell/octeontx2/otx2_cptvf.h |   28 +
>  .../marvell/octeontx2/otx2_cptvf_algs.c       | 1665 +++++++++++++++++
>  .../marvell/octeontx2/otx2_cptvf_algs.h       |  170 ++
>  .../marvell/octeontx2/otx2_cptvf_main.c       |  401 ++++
>  .../marvell/octeontx2/otx2_cptvf_mbox.c       |  139 ++
>  .../marvell/octeontx2/otx2_cptvf_reqmgr.c     |  539 ++++++
>  .../ethernet/marvell/octeontx2/af/Makefile    |    3 +-
>  .../net/ethernet/marvell/octeontx2/af/mbox.h  |   33 +
>  .../net/ethernet/marvell/octeontx2/af/rvu.c   |    2 +-
>  .../net/ethernet/marvell/octeontx2/af/rvu.h   |    2 +
>  .../ethernet/marvell/octeontx2/af/rvu_cpt.c   |  229 +++
>  .../marvell/octeontx2/af/rvu_debugfs.c        |  304 +++
>  .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   63 +-
>  .../marvell/octeontx2/nic/otx2_common.h       |   13 +-
>  include/linux/soc/marvell/octeontx2/asm.h     |   29 +
>  30 files changed, 8038 insertions(+), 20 deletions(-)
>  create mode 100644 drivers/crypto/marvell/octeontx2/Makefile
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
>  create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
>  create mode 100644 include/linux/soc/marvell/octeontx2/asm.h

For netdrv review. I don't have a lot of detailed feedback. Overall it
looks sensible to me.

It is obviously a big beast of a patchset. Looking at previous review
comments, the documentation is now a lot better, which helps follow
the thread.

The point about parsing tar files remains open. In general error-prone
parsing is better left to userspace. In practice this is not a lot of
code, nor terribly complex.

The other point is that some files are very close to their oncteontx
counterparts. With minor cleanups, such as using in-place cpu_to_be64s
swap. Those cleanups probably make sense to the older device, too. One
option would be to apply them there first, then copy the files and use
coccinelle for mass renaming. But frankly that is a lot of extra work
to arrive at the same state. I just used --color-words=. --no-index to
perform an iterative review, which works well enough.
