Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3EE42F8DC
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 18:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241720AbhJOQzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 12:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236428AbhJOQzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 12:55:41 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57FCC061762;
        Fri, 15 Oct 2021 09:53:34 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id y12so42189837eda.4;
        Fri, 15 Oct 2021 09:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DFAfhL2wTnA/x1oOiRIEIccRhRGZWYerK6em4KwuQr0=;
        b=WhznUYR2nkpwiwbTRwmHKoc047JsFdk3RvHIe/jtOLSDmdxX07MCX9Eow0Bi+yLoQp
         EyU08OzLxLG5ZCsUs7GUsgWdhql+ygc3SL2hgpQj7qkueaPaH4FCl+VEJFbTT66B35gH
         GDagaCdrbJmPFv3m1vjK25dlCo+SurtmwsJpbtn+lVZ1hUtQu8pPUJ/3APaMcce/rMb+
         gK4/JKJga2A5DLyU3cXWQ467mYYMbHs26I04bEcKD9mvTuveZ0BpijvVaw9Fg5WzWNNW
         l7COh3PfIisjI8gWM0rsyxYaukEsrZpFMim7hIuXFIwI4NkGZUXxkbzqxVTnksr3mpP4
         SUYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DFAfhL2wTnA/x1oOiRIEIccRhRGZWYerK6em4KwuQr0=;
        b=Pz66uXOYVPkKHpFryMN1vuv3PRaUUufVOktG/MXAyn+Mbnw67Hg+Y9A5/5ATuNWpbN
         2apggTaSkDPxZ0TXvlb7Yc2fkPKHAqAH6cPp0ZRCyIhRq5T/Ga+wN92BZY22KWRL0px0
         kr3ipbNNYsXFEfbnMnDFID1N0gdKA3BqLM+r9mGWrrMHp26dHnH2mwYGb/5/gQlnYc1Q
         ArLpMWvshnVXU7a8w1Gp8dngNucMAhb62ma12skWTfwT7Kljvwc42Ges/nmkAMVmyRsa
         FboJls257B2pG0z6DUpE/Rinw4YeDgbQmKpklsvYMMoCGqS84dFt7TluRpTUrsSBS1JO
         lSow==
X-Gm-Message-State: AOAM531fRDtVFQmGAgEdDX8QQ9FKZCV0/Fcr/6I7qlFhhfOBUo0iN3R/
        2HQYIpNqVOsbxTFimIu3oU9vvzetwldYc5ybjC8=
X-Google-Smtp-Source: ABdhPJw1GMYkf4/DzQ6xCdDldbViFURlmc0YnNdhDKa/6j1hrF7JWMyfM92nI6tIEj+fn7ChYTDQotvOC+uhf3cE48A=
X-Received: by 2002:a50:e188:: with SMTP id k8mr19911628edl.119.1634316813165;
 Fri, 15 Oct 2021 09:53:33 -0700 (PDT)
MIME-Version: 1.0
References: <YWbdvc7EWEZLVTHM@smile.fi.intel.com> <20211015164653.GA2108651@bhelgaas>
In-Reply-To: <20211015164653.GA2108651@bhelgaas>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 15 Oct 2021 22:52:45 +0300
Message-ID: <CAHp75VdpVwvOkjDWHcnWA-qZFm062UBp7VwdcpWbkdVR=i75Hw@mail.gmail.com>
Subject: Re: [PATCH v6 00/11] PCI: Drop duplicated tracking of a pci_dev's
 bound driver
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        linux-pci <linux-pci@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>, Ido Schimmel <idosch@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Jack Xu <jack.xu@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Michael Buesch <m@bues.ch>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Namhyung Kim <namhyung@kernel.org>,
        "Oliver O'Halloran" <oohall@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Russell Currey <ruscur@russell.cc>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Simon Horman <simon.horman@corigine.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomaszx Kowalik <tomaszx.kowalik@intel.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-perf-users@vger.kernel.org,
        "open list:LINUX FOR POWERPC PA SEMI PWRFICIENT" 
        <linuxppc-dev@lists.ozlabs.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        USB <linux-usb@vger.kernel.org>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, netdev <netdev@vger.kernel.org>,
        oss-drivers@corigine.com, qat-linux@intel.com,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        xen-devel@lists.xenproject.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 7:46 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
> On Wed, Oct 13, 2021 at 04:23:09PM +0300, Andy Shevchenko wrote:

...

> so compared to Uwe's v6, I restored that section to the original code.
> My goal here was to make the patch as simple and easy to review as
> possible.

Thanks for elaboration. I have got it.

...

> You're right, this didn't make much sense in that patch.  I moved the
> line join to the previous patch, which unindented this section and
> made space for this to fit on one line.  Here's the revised commit:
>
>   https://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/commit/?id=34ab316d7287

Side remark: default without break or return is error prone (okay, to
some extent). Perhaps adding the return statement there will make
things robust and clean.

-- 
With Best Regards,
Andy Shevchenko
