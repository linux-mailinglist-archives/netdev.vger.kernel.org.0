Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6D43EF5A6
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 00:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236374AbhHQWSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 18:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236287AbhHQWSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 18:18:15 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3739BC061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 15:17:41 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id f2so1374091ljn.1
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 15:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mljevfVZg9W0PLYDtlwlbBEhr+6DfsuJN2uRRXLrTdA=;
        b=BlNQ0+OPM7VpucPeXAVKTheEGDOKJKISIjmvrHvb2xsF6E7cF0gr65rpm1HkTdmyCW
         /PaDVAFwU6CnZuYF4AkYyeDyIZ/V2qz5SIkjC8RUccrLzMU/PVRg0ktt4nQoP9fQvM7o
         F20nrp58qEjRG8/UWa23IdxKak2IZyhUSojIFHEx3YZSLFznUPqJ3e9WVu9MDGAxXuJD
         hRCDySvAnQKN1lxFLYWFk42iee1GeYWNJlXcgsbTJLnfURgt/Z7DIVtWj5Y5WvzdwA+m
         qyvlIQE7EcBL92a3HiAyYtA++E4hhFlZ/ckmwA9Vp+dXH6nt82gnFF3bW0MTKr0k9Xqp
         MibQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mljevfVZg9W0PLYDtlwlbBEhr+6DfsuJN2uRRXLrTdA=;
        b=R6IojsvwvPsjuObSsMFrq1LiWulR3jzGcdy2pCK6LNpJndsP+KUNlNj8GqtHLfcuqh
         48YBM3Ath5abdDj/Sg8ACw0nGYLuiKxIpnQ4Mugi0w3soj521+0UujSbPbliPyLCD5v7
         EWN8lIHPfu/G2Y1EN3b6aiirbqIdyjtg4/rNL5VmuG1jzcBoqFb1hxLI8lnHPIaZu2fX
         gVN/NQGzWCEq3bNNS8SIKyNwI/eUfSin6P5iSJ1629FqbrEvw5NwkNl/BP+amVlUy1ag
         TKCjg4Wr7ImiXrI6xRYntixOcNXmjgXjm1muFuCSGBQBQnnazBUgfojXJJHrBBFykNBm
         sd1w==
X-Gm-Message-State: AOAM531Qo6i6hLEKSJ0hnIjNE/GbLRaEbzPljw0ig03q13CVNOla0z/j
        icVUvb3MEAiTH8Qeg8nM8EEznlk7xGeH7y29qNii3A==
X-Google-Smtp-Source: ABdhPJyOsx6fldPI8jZn+B4589wZE8MEMjiOG+m2SvuPSWP0CMpm4aA/M0awDYuLOkj+sIUI0G9clcH3wZdiN4yinXI=
X-Received: by 2002:a2e:a4d1:: with SMTP id p17mr5020868ljm.82.1629238658796;
 Tue, 17 Aug 2021 15:17:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210810190159.4103778-1-richardsonnick@google.com>
 <20210810190159.4103778-3-richardsonnick@google.com> <CA+G9fYszRMoz-FKDJKzOuw7VkEyy-YQF1NR_0q4dc5Dpvb6ykw@mail.gmail.com>
In-Reply-To: <CA+G9fYszRMoz-FKDJKzOuw7VkEyy-YQF1NR_0q4dc5Dpvb6ykw@mail.gmail.com>
From:   Nick Richardson <richardsonnick@google.com>
Date:   Tue, 17 Aug 2021 18:17:23 -0400
Message-ID: <CAGr-3gmgzr2KGJq5hBUzxEOhFp0_sibpY9HfXS5rMVwtSK16rg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] pktgen: Add imix distribution bins
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, nrrichar@ncsu.edu,
        Philip Romanov <promanov@google.com>,
        Arun Kalyanasundaram <arunkaly@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Di Zhu <zhudi21@huawei.com>, Leesoo Ahn <dev@ooseel.net>,
        Ye Bin <yebin10@huawei.com>,
        Yejune Deng <yejune.deng@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Mark Brown <broonie@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Aug 2021 at 00:32, Nicholas Richardson
<richardsonnick@google.com> wrote:
>
> From: Nick Richardson <richardsonnick@google.com>
>
> In order to represent the distribution of imix packet sizes, a
> pre-computed data structure is used. It features 100 (IMIX_PRECISION)
> "bins". Contiguous ranges of these bins represent the respective
> packet size of each imix entry. This is done to avoid the overhead of
> selecting the correct imix packet size based on the corresponding weights.
>
> Example:
> imix_weights 40,7 576,4 1500,1
> total_weight = 7 + 4 + 1 = 12
>
> pkt_size 40 occurs 7/total_weight = 58% of the time
> pkt_size 576 occurs 4/total_weight = 33% of the time
> pkt_size 1500 occurs 1/total_weight = 9% of the time
>
> We generate a random number between 0-100 and select the corresponding
> packet size based on the specified weights.
> Eg. random number = 358723895 % 100 = 65
> Selects the packet size corresponding to index:65 in the pre-computed
> imix_distribution array.
> An example of the  pre-computed array is below:
>
> The imix_distribution will look like the following:
> 0        ->  0 (index of imix_entry.size == 40)
> 1        ->  0 (index of imix_entry.size == 40)
> 2        ->  0 (index of imix_entry.size == 40)
> [...]    ->  0 (index of imix_entry.size == 40)
> 57       ->  0 (index of imix_entry.size == 40)
> 58       ->  1 (index of imix_entry.size == 576)
> [...]    ->  1 (index of imix_entry.size == 576)
> 90       ->  1 (index of imix_entry.size == 576)
> 91       ->  2 (index of imix_entry.size == 1500)
> [...]    ->  2 (index of imix_entry.size == 1500)
> 99       ->  2 (index of imix_entry.size == 1500)
>
> Create and use "bin" representation of the imix distribution.
>
> Signed-off-by: Nick Richardson <richardsonnick@google.com>
> ---
>  net/core/pktgen.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>
> diff --git a/net/core/pktgen.c b/net/core/pktgen.c
> index a7e45eaccef7..ac1de15000e2 100644
> --- a/net/core/pktgen.c
> +++ b/net/core/pktgen.c
> @@ -177,6 +177,7 @@
>  #define MPLS_STACK_BOTTOM htonl(0x00000100)
>  /* Max number of internet mix entries that can be specified in imix_weights. */
>  #define MAX_IMIX_ENTRIES 20
> +#define IMIX_PRECISION 100 /* Precision of IMIX distribution */
>
>  #define func_enter() pr_debug("entering %s\n", __func__);
>
> @@ -354,6 +355,8 @@ struct pktgen_dev {
>         /* IMIX */
>         unsigned int n_imix_entries;
>         struct imix_pkt imix_entries[MAX_IMIX_ENTRIES];
> +       /* Maps 0-IMIX_PRECISION range to imix_entry based on probability*/
> +       __u8 imix_distribution[IMIX_PRECISION];
>
>         /* MPLS */
>         unsigned int nr_labels; /* Depth of stack, 0 = no MPLS */
> @@ -483,6 +486,7 @@ static void pktgen_stop_all_threads(struct pktgen_net *pn);
>
>  static void pktgen_stop(struct pktgen_thread *t);
>  static void pktgen_clear_counters(struct pktgen_dev *pkt_dev);
> +static void fill_imix_distribution(struct pktgen_dev *pkt_dev);

Linux next 20210813 tag arm builds failed due to following build errors.

Regressions found on arm:

 - build/gcc-10-ixp4xx_defconfig
 - build/gcc-10-orion5x_defconfig
 - build/gcc-10-multi_v5_defconfig

net/core/pktgen.c:489:13: warning: 'fill_imix_distribution' used but
never defined
 static void fill_imix_distribution(struct pktgen_dev *pkt_dev);
             ^~~~~~~~~~~~~~~~~~~~~~
ERROR: modpost: "fill_imix_distribution" [net/core/pktgen.ko] undefined!
make[2]: *** [scripts/Makefile.modpost:150: modules-only.symvers] Error 1
make[2]: *** Deleting file 'modules-only.symvers'
make[2]: Target '__modpost' not remade because of errors.
make[1]: *** [Makefile:1918: modules] Error 2

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Steps to reproduce:

# TuxMake is a command line tool and Python library that provides
# portable and repeatable Linux kernel builds across a variety of
# architectures, toolchains, kernel configurations, and make targets.
#
# TuxMake supports the concept of runtimes.
# See https://docs.tuxmake.org/runtimes/, for that to work it requires
# that you install podman or docker on your system.
#
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.

tuxmake --runtime podman --target-arch arm --toolchain gcc-10
--kconfig orion5x_defconfig


On Sat, Aug 14, 2021 at 1:13 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> On Wed, 11 Aug 2021 at 00:32, Nicholas Richardson
> <richardsonnick@google.com> wrote:
> >
> > From: Nick Richardson <richardsonnick@google.com>
> >
> > In order to represent the distribution of imix packet sizes, a
> > pre-computed data structure is used. It features 100 (IMIX_PRECISION)
> > "bins". Contiguous ranges of these bins represent the respective
> > packet size of each imix entry. This is done to avoid the overhead of
> > selecting the correct imix packet size based on the corresponding weights.
> >
> > Example:
> > imix_weights 40,7 576,4 1500,1
> > total_weight = 7 + 4 + 1 = 12
> >
> > pkt_size 40 occurs 7/total_weight = 58% of the time
> > pkt_size 576 occurs 4/total_weight = 33% of the time
> > pkt_size 1500 occurs 1/total_weight = 9% of the time
> >
> > We generate a random number between 0-100 and select the corresponding
> > packet size based on the specified weights.
> > Eg. random number = 358723895 % 100 = 65
> > Selects the packet size corresponding to index:65 in the pre-computed
> > imix_distribution array.
> > An example of the  pre-computed array is below:
> >
> > The imix_distribution will look like the following:
> > 0        ->  0 (index of imix_entry.size == 40)
> > 1        ->  0 (index of imix_entry.size == 40)
> > 2        ->  0 (index of imix_entry.size == 40)
> > [...]    ->  0 (index of imix_entry.size == 40)
> > 57       ->  0 (index of imix_entry.size == 40)
> > 58       ->  1 (index of imix_entry.size == 576)
> > [...]    ->  1 (index of imix_entry.size == 576)
> > 90       ->  1 (index of imix_entry.size == 576)
> > 91       ->  2 (index of imix_entry.size == 1500)
> > [...]    ->  2 (index of imix_entry.size == 1500)
> > 99       ->  2 (index of imix_entry.size == 1500)
> >
> > Create and use "bin" representation of the imix distribution.
> >
> > Signed-off-by: Nick Richardson <richardsonnick@google.com>
> > ---
> >  net/core/pktgen.c | 41 +++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 41 insertions(+)
> >
> > diff --git a/net/core/pktgen.c b/net/core/pktgen.c
> > index a7e45eaccef7..ac1de15000e2 100644
> > --- a/net/core/pktgen.c
> > +++ b/net/core/pktgen.c
> > @@ -177,6 +177,7 @@
> >  #define MPLS_STACK_BOTTOM htonl(0x00000100)
> >  /* Max number of internet mix entries that can be specified in imix_weights. */
> >  #define MAX_IMIX_ENTRIES 20
> > +#define IMIX_PRECISION 100 /* Precision of IMIX distribution */
> >
> >  #define func_enter() pr_debug("entering %s\n", __func__);
> >
> > @@ -354,6 +355,8 @@ struct pktgen_dev {
> >         /* IMIX */
> >         unsigned int n_imix_entries;
> >         struct imix_pkt imix_entries[MAX_IMIX_ENTRIES];
> > +       /* Maps 0-IMIX_PRECISION range to imix_entry based on probability*/
> > +       __u8 imix_distribution[IMIX_PRECISION];
> >
> >         /* MPLS */
> >         unsigned int nr_labels; /* Depth of stack, 0 = no MPLS */
> > @@ -483,6 +486,7 @@ static void pktgen_stop_all_threads(struct pktgen_net *pn);
> >
> >  static void pktgen_stop(struct pktgen_thread *t);
> >  static void pktgen_clear_counters(struct pktgen_dev *pkt_dev);
> > +static void fill_imix_distribution(struct pktgen_dev *pkt_dev);
>
> Linux next 20210813 tag arm builds failed due to following build errors.
>
> Regressions found on arm:
>
>  - build/gcc-10-ixp4xx_defconfig
>  - build/gcc-10-orion5x_defconfig
>  - build/gcc-10-multi_v5_defconfig
>
> net/core/pktgen.c:489:13: warning: 'fill_imix_distribution' used but
> never defined
>  static void fill_imix_distribution(struct pktgen_dev *pkt_dev);
>              ^~~~~~~~~~~~~~~~~~~~~~
> ERROR: modpost: "fill_imix_distribution" [net/core/pktgen.ko] undefined!
> make[2]: *** [scripts/Makefile.modpost:150: modules-only.symvers] Error 1
> make[2]: *** Deleting file 'modules-only.symvers'
> make[2]: Target '__modpost' not remade because of errors.
> make[1]: *** [Makefile:1918: modules] Error 2
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> Steps to reproduce:
>
> # TuxMake is a command line tool and Python library that provides
> # portable and repeatable Linux kernel builds across a variety of
> # architectures, toolchains, kernel configurations, and make targets.
> #
> # TuxMake supports the concept of runtimes.
> # See https://docs.tuxmake.org/runtimes/, for that to work it requires
> # that you install podman or docker on your system.
> #
> # To install tuxmake on your system globally:
> # sudo pip3 install -U tuxmake
> #
> # See https://docs.tuxmake.org/ for complete documentation.
>
> tuxmake --runtime podman --target-arch arm --toolchain gcc-10
> --kconfig orion5x_defconfig
>
> --
> Linaro LKFT
> https://lkft.linaro.org

Thanks for the reply Naresh. Do you have any ideas on how to resolve
this error? Pktgen already defines a couple of function prototypes
before they are declared and that seems to be the cause of this error
message.
