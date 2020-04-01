Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54FDE19B573
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 20:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732880AbgDAS1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 14:27:18 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41182 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730420AbgDAS1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 14:27:18 -0400
Received: by mail-ed1-f67.google.com with SMTP id v1so1059839edq.8;
        Wed, 01 Apr 2020 11:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qc8FdgkWFDlzCGPYLOnP9rFKt+4lOYRHOhNF4lWF83w=;
        b=h3sNiT6w5xhV7LEni1uXvK3mEPsRMhJkj6EkwmrmqhNJ3+PmaeC4pDLym0QIDqoXxj
         nXVOWLYT6+vf1kIyr3ySKn3ujiPXPq2GhWRPEWPGYYnJLC5Mt+WFdYo6sJXcQLnLRO4k
         cymwVaZhmrSxhbS4NuSNUrUvfvOV1QxQ4MTO9EMiEVXDsWSys5BTFov5jWj0n3IeCk1q
         VF0fOEBc2NIE80cWUxOb5qjfYlaeU6u22H8ao2LiQ9iq1dSAnlM0EWZkMe20+kpwi1tn
         do56udx2eWFB9Uhfr9Y+4dmYSfAoPG+/Cx2xyRQUOYzKwLTQFX8FkOje8+GLOIF3hFE5
         OXoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qc8FdgkWFDlzCGPYLOnP9rFKt+4lOYRHOhNF4lWF83w=;
        b=f8KXIp70mUZhOPD0TvN9ZOLIMGCtjueSsnUVLnY2bLICBwAkgAlAULgRQ2UBEfP9t+
         P8pFI3lfbeoaa6CHDNZNrmT60ioloHvUjDEp1dYON669QgqCxs++6ueS7MHLevcYhQNV
         NGqEIl2MljdPXbn5POnpFk2TP3xQsTp4u3FW7r6YaAenrwEsDglTsJNarrSwdBFqzbbC
         AYh0u/Eyy8e7M88FYdQ11ByVMzTHQXDdQTW7nbc/OU1vSlAXqP5gVGzDsbJycJsWC+2b
         r6PYpSQ/stXmDce4M20aZGLbSeBkGXhTNA6sKxSHQwfKvH6fSiwAq7W1qK45LttmXbam
         H/+Q==
X-Gm-Message-State: ANhLgQ3eRP+L+16frRa4BihcZnZ7seRvBEjPn9lUtJySGg1xl0Xfxz/9
        gmR5k1rnyxm+DWMPT7Wk+d9ZqrCg6M+5JOEDC8B58wv4ZWI=
X-Google-Smtp-Source: ADFU+vt4AHASmjNfRn5JQa4Gc3qglj7ra6KhGxH+2qm9C0dVE3Fxo3wYrvhP6p1JqhsehGN7/QhDVsZ76LkLt0jfxCI=
X-Received: by 2002:aa7:d602:: with SMTP id c2mr22785839edr.118.1585765635929;
 Wed, 01 Apr 2020 11:27:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200323225254.12759-1-grygorii.strashko@ti.com>
 <20200326.200136.1601946994817303021.davem@davemloft.net> <CA+h21hr8G24ddEgAbU_TfoNAe0fqUJ0_Uyp54Gxn5cvPrM6u9g@mail.gmail.com>
 <8f5e981a-193c-0c1e-1e0a-b0380b2e6a9c@ti.com> <2d305c89-601c-5dee-06be-30257a26a392@ti.com>
 <cac3d501-cc36-73c5-eea8-aaa2d10105b0@ti.com> <590f9865-ace7-fc12-05e7-0c8579785f96@ti.com>
In-Reply-To: <590f9865-ace7-fc12-05e7-0c8579785f96@ti.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 1 Apr 2020 21:27:04 +0300
Message-ID: <CA+h21hpAnWbnQihTVGyB-TyRYad+gWCdF7suzsXRFJg-nsU9xg@mail.gmail.com>
Subject: Re: [PATCH net-next v6 00/11] net: ethernet: ti: add networking
 support for k3 am65x/j721e soc
To:     David Miller <davem@davemloft.net>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Tero Kristo <t-kristo@ti.com>,
        peter.ujfalusi@ti.com, Rob Herring <robh@kernel.org>,
        netdev <netdev@vger.kernel.org>, rogerq@ti.com,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>, kishon@ti.com,
        lkml <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Mon, 30 Mar 2020 at 21:14, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
>
> Hi
>
> On 30/03/2020 11:28, Sekhar Nori wrote:
> > On 30/03/20 1:06 PM, Sekhar Nori wrote:
> >> On 30/03/20 12:45 PM, Tero Kristo wrote:
> >>> On 28/03/2020 03:53, Vladimir Oltean wrote:
> >>>> Hi David,
> >>>>
> >>>> On Fri, 27 Mar 2020 at 05:02, David Miller <davem@davemloft.net> wrote:
> >>>>>
> >>>>> From: Grygorii Strashko <grygorii.strashko@ti.com>
> >>>>> Date: Tue, 24 Mar 2020 00:52:43 +0200
> >>>>>
> >>>>>> This v6 series adds basic networking support support TI K3
> >>>>>> AM654x/J721E SoC which
> >>>>>> have integrated Gigabit Ethernet MAC (Media Access Controller) into
> >>>>>> device MCU
> >>>>>> domain and named MCU_CPSW0 (CPSW2G NUSS).
> >>>>>    ...
> >>>>>
> >>>>> Series applied, thank you.
> >>>>
> >>>> The build is now broken on net-next:
> >>>>
> >>>> arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi:303.23-309.6: ERROR
> >>>> (phandle_references):
> >>>> /interconnect@100000/interconnect@28380000/ethernet@46000000/ethernet-ports/port@1:
> >>>>
> >>>> Reference to non-existent node
> >>>> or label "mcu_conf"
> >>>>
> >>>>     also defined at
> >>>> arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts:471.13-474.3
> >>>> arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi:303.23-309.6: ERROR
> >>>> (phandle_references):
> >>>> /interconnect@100000/interconnect@28380000/ethernet@46000000/ethernet-ports/port@1:
> >>>>
> >>>> Reference to non-existent node
> >>>> or label "phy_gmii_sel"
> >>>>
> >>>>     also defined at
> >>>> arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts:471.13-474.3
> >>>>
> >>>> As Grygorii said:
> >>>>
> >>>> Patches 1-6 are intended for netdev, Patches 7-11 are intended for K3
> >>>> Platform
> >>>> tree and provided here for testing purposes.
> >>>
> >>> Yeah, I think you are missing a dependency that was applied via the K3
> >>> branch earlier. They are in linux-next now, but I am not so sure how
> >>> much that is going to help you.
> >>>
> >>> You could just drop the DT patches from this merge and let me apply them
> >>> via the platform branch.
> >>
> >> One other option would be that Dave merges your K3 tag which was sent to
> >> ARM SoC to net-next. Its based on v5.6-rc1, has no other dependencies,
> >> is already in linux-next, should be immutable and safe to merge. This
> >> has the advantage that no rebase is necessary on net-next.
> >>
> >> git://git.kernel.org/pub/scm/linux/kernel/git/kristo/linux
> >> tags/ti-k3-soc-for-v5.7
> >
> > FWIW, I was able to reproduce the build failure reported by Vladimir on
> > net-next, merge Tero's tag (above) cleanly into it, and see that ARM64
> > defconfig build on net-next succeeds after the merge.
>
> Thank you Sekhar for checking this.
>
> I'm very sorry for introducing this issue. I've tried hard to avoid such issue,
> but still missed it (probably I have had to drop DT patches from last submission
> and send them separately).
>
> Sorry again.
>
> --
> Best regards,
> grygorii

I think the ARM64 build is now also broken on Linus' master branch,
after the net-next merge? I am not quite sure if the device tree
patches were supposed to land in mainline the way they did.

Thanks,
-Vladimir
