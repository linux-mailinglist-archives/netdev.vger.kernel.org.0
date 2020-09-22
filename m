Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC1A273A67
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 07:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbgIVFyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 01:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgIVFyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 01:54:38 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B8AC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 22:54:37 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id z17so16628392lfi.12
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 22:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7XjamktTFiiABVccdX9/BPNTROsE62VEwylXIdyGLMQ=;
        b=CW9+EdTjllO/WF3g/810Xyk+a3n8TwKrLgGkduK/RVLC/XSw0YPDafCnImeg/rk1CA
         9+GcPAzbrgl4TBkTGPSrtI6G1Vviq+Psn14fG/rmN8Iv5nSdgbCViF3tlMNXxOeYJ3wV
         42j2LoREq1zD5Y7Pd/QiETTzjtVnEHpBR3eYQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7XjamktTFiiABVccdX9/BPNTROsE62VEwylXIdyGLMQ=;
        b=t1Y7lwu4KgGoZtWIgzNosE2Wq2dLjiOYvXHx5v22s2LpskohZ57jFINnhH91j2ehtT
         5QAsg16+65KlOQQWoDNMrFUmIa2OZKLCu1+HIoy9pyU4wKFvUktmnUSBufSd7JjiRqc6
         Vt/eCAxmEw8PXHOITDGB0SUDEmCVsOXxcnfWFbpTdnPIAJSvGhvSbFosU94lOY9sB/P2
         zX5aAtdonfUzwSHQk0QnGPt7ZxkPvdBV4NQPHJOSP/MrC/W4gDgeI3r6S2bWDHy0dJY5
         92jcJs1Egr0lcDtoXTvlJ+S2K5F/naUh5u52ksCGvzR2gdmSYbX/dXwGnvxtHXRnSJec
         akMA==
X-Gm-Message-State: AOAM531YmsETa+TSlo/q8qKMwix9QaQGAQvdA/Ln9ae7SapibkjWgyiB
        vTGZTPxZWAj0kSMBi/jgbJdJ4pCpNlHfpEKT6N+9KA==
X-Google-Smtp-Source: ABdhPJz9B4pIuG5bDoRIMw0JxqiQ/Ie6oBbkk+jwN3YyPGjA6nWldlgTX+tC0N1EaoEbGe1PKSCx2VMOXdeMJi/kJIU=
X-Received: by 2002:ac2:53b3:: with SMTP id j19mr1209917lfh.101.1600754075961;
 Mon, 21 Sep 2020 22:54:35 -0700 (PDT)
MIME-Version: 1.0
References: <1600670391-5533-1-git-send-email-vasundhara-v.volam@broadcom.com> <20200921091820.hiulkidpedzgl4lz@lion.mk-sys.cz>
In-Reply-To: <20200921091820.hiulkidpedzgl4lz@lion.mk-sys.cz>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Tue, 22 Sep 2020 11:24:24 +0530
Message-ID: <CAACQVJo1YCFsxTeUi7T_+0AtrDzYGAY-CRZXvm31NXbQ41CCTQ@mail.gmail.com>
Subject: Re: [PATCH ethtool] bnxt: Add Broadcom driver support.
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 2:48 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Mon, Sep 21, 2020 at 12:09:51PM +0530, Vasundhara Volam wrote:
> > This patch adds the initial support for parsing registers dumped
> > by the Broadcom driver. Currently, PXP and PCIe registers are
> > parsed.
> >
> > Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
> > Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
> > Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> > ---
> >  Makefile.am |  2 +-
> >  bnxt.c      | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  ethtool.c   |  1 +
> >  internal.h  |  3 +++
> >  4 files changed, 91 insertions(+), 1 deletion(-)
> >  create mode 100644 bnxt.c
> >
> > diff --git a/Makefile.am b/Makefile.am
> > index 0e237d0..e3e311d 100644
> > --- a/Makefile.am
> > +++ b/Makefile.am
> > @@ -17,7 +17,7 @@ ethtool_SOURCES += \
> >                 smsc911x.c at76c50x-usb.c sfc.c stmmac.c      \
> >                 sff-common.c sff-common.h sfpid.c sfpdiag.c   \
> >                 ixgbevf.c tse.c vmxnet3.c qsfp.c qsfp.h fjes.c lan78xx.c \
> > -               igc.c qsfp-dd.c qsfp-dd.h
> > +               igc.c qsfp-dd.c qsfp-dd.h bnxt.c
> >  endif
> >
> >  if ENABLE_BASH_COMPLETION
> > diff --git a/bnxt.c b/bnxt.c
> > new file mode 100644
> > index 0000000..91ed819
> > --- /dev/null
> > +++ b/bnxt.c
> > @@ -0,0 +1,86 @@
> > +/* Code to dump registers for NetXtreme-E/NetXtreme-C Broadcom devices.
> > + *
> > + * Copyright (c) 2020 Broadcom Inc.
> > + */
> > +#include <stdio.h>
> > +#include "internal.h"
> > +
> > +#define BNXT_PXP_REG_LEN     0x3110
> > +#define BNXT_PCIE_STATS_LEN  (12 * sizeof(u64))
> > +
> > +struct bnxt_pcie_stat {
> > +     const char *name;
> > +     u16 offset;
> > +     u8 size;
> > +     const char *format;
> > +};
> > +
> > +static const struct bnxt_pcie_stat bnxt_pcie_stats[] = {
> > +     { .name = "PL Signal integrity errors     ", .offset = 0, .size = 4, .format = "%lld" },
> > +     { .name = "DL Signal integrity errors     ", .offset = 4, .size = 4, .format = "%lld" },
> > +     { .name = "TLP Signal integrity errors    ", .offset = 8, .size = 4, .format = "%lld" },
> > +     { .name = "Link integrity                 ", .offset = 12, .size = 4, .format = "%lld" },
> > +     { .name = "TX TLP traffic rate            ", .offset = 16, .size = 4, .format = "%lld" },
> > +     { .name = "RX TLP traffic rate            ", .offset = 20, .size = 4, .format = "%lld" },
> > +     { .name = "TX DLLP traffic rate           ", .offset = 24, .size = 4, .format = "%lld" },
> > +     { .name = "RX DLLP traffic rate           ", .offset = 28, .size = 4, .format = "%lld" },
>
> Are all of these really interpreted as signed? Moreover, you are always
> passing a u64 varable to printf().
These are unsigned only. I will fix the format. Thanks.
>
> > +     { .name = "Equalization Phase 0 time(ms)  ", .offset = 33, .size = 1, .format = "0x%lx" },
> > +     { .name = "Equalization Phase 1 time(ms)  ", .offset = 32, .size = 1, .format = "0x%lx" },
> > +     { .name = "Equalization Phase 2 time(ms)  ", .offset = 35, .size = 1, .format = "0x%lx" },
> > +     { .name = "Equalization Phase 3 time(ms)  ", .offset = 34, .size = 1, .format = "0x%lx" },
>
> Again, you are always passing a u64 variable so the format should rather
> be "0x%llx".
okay.
>
> > +     { .name = "PHY LTSSM Histogram 0          ", .offset = 36, .size = 2, .format = "0x%llx"},
> > +     { .name = "PHY LTSSM Histogram 1          ", .offset = 38, .size = 2, .format = "0x%llx"},
> > +     { .name = "PHY LTSSM Histogram 2          ", .offset = 40, .size = 2, .format = "0x%llx"},
> > +     { .name = "PHY LTSSM Histogram 3          ", .offset = 42, .size = 2, .format = "0x%llx"},
> > +     { .name = "Recovery Histogram 0           ", .offset = 44, .size = 2, .format = "0x%llx"},
> > +     { .name = "Recovery Histogram 1           ", .offset = 46, .size = 2, .format = "0x%llx"},
> > +};
>
> I don't really like the trailing spaces in register names; why don't you
> use printf() format for column alignment?
Okay, I will use tabs "\t". I cannot really use width specifiers as I
have to use 0x in front of the values.
>
> > +
> > +int bnxt_dump_regs(struct ethtool_drvinfo *info __maybe_unused, struct ethtool_regs *regs)
> > +{
> > +     const struct bnxt_pcie_stat *stats = bnxt_pcie_stats;
> > +     u16 *pcie_stats;
> > +     u64 pcie_stat;
> > +     u32 reg, i;
> > +
> > +     if (regs->len < BNXT_PXP_REG_LEN) {
> > +             fprintf(stdout, "Length too short, expected atleast %x\n",
> > +                     BNXT_PXP_REG_LEN);
>
> This will show "...atleast 3110" which is rather confusing without the
> "0x" prefix. (Also, a space is missing in "atleast".)
Okay.
>
> > +             return -1;
> > +     }
> > +
> > +     fprintf(stdout, "PXP Registers\n");
> > +     fprintf(stdout, "Offset\tValue\n");
> > +     fprintf(stdout, "------\t-------\n");
> > +     for (i = 0; i < BNXT_PXP_REG_LEN; i += sizeof(reg)) {
> > +             memcpy(&reg, &regs->data[i], sizeof(reg));
> > +             if (reg)
> > +                     fprintf(stdout, "0x%04x\t0x%08x\n", i, reg);
> > +     }
> > +     fprintf(stdout, "\n");
> > +
> > +     if (!regs->version)
> > +             return 0;
> > +
> > +     if (regs->len < (BNXT_PXP_REG_LEN + BNXT_PCIE_STATS_LEN)) {
> > +             fprintf(stdout, "Length is too short, expected %lx\n",
> > +                     BNXT_PXP_REG_LEN + BNXT_PCIE_STATS_LEN);
>
> The same problem here, "3170" actually meaning 0x3170 or 12656.
Okay.
>
> > +             return -1;
> > +     }
> > +
> > +     pcie_stats = (u16 *)(regs->data + BNXT_PXP_REG_LEN);
> > +     fprintf(stdout, "PCIe statistics:\n");
> > +     fprintf(stdout, "----------------\n");
> > +     for (i = 0; i < ARRAY_SIZE(bnxt_pcie_stats); i++) {
> > +             pcie_stat = 0;
> > +             memcpy(&pcie_stat, &pcie_stats[stats[i].offset],
> > +                    stats[i].size * sizeof(u16));
>
> This will only work on little endian architectures.
Data is already converted to host endian order by ETHTOOL_REGS, so it
will not be an issue.
>
> Michal
>
> > +
> > +             fprintf(stdout, "%s", stats[i].name);
> > +             fprintf(stdout, stats[i].format, pcie_stat);
> > +             fprintf(stdout, "\n");
> > +     }
> > +
> > +     fprintf(stdout, "\n");
> > +     return 0;
> > +}
> > diff --git a/ethtool.c b/ethtool.c
> > index ab9b457..89bd15c 100644
> > --- a/ethtool.c
> > +++ b/ethtool.c
> > @@ -1072,6 +1072,7 @@ static const struct {
> >       { "dsa", dsa_dump_regs },
> >       { "fec", fec_dump_regs },
> >       { "igc", igc_dump_regs },
> > +     { "bnxt_en", bnxt_dump_regs },
> >  #endif
> >  };
> >
> > diff --git a/internal.h b/internal.h
> > index d096a28..935ebac 100644
> > --- a/internal.h
> > +++ b/internal.h
> > @@ -396,4 +396,7 @@ int fec_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
> >  /* Intel(R) Ethernet Controller I225-LM/I225-V adapter family */
> >  int igc_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
> >
> > +/* Broadcom Ethernet Controller */
> > +int bnxt_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
> > +
> >  #endif /* ETHTOOL_INTERNAL_H__ */
> > --
> > 1.8.3.1
> >
