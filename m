Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA9064C4FF
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 03:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731073AbfFTBeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 21:34:31 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:41615 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfFTBea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 21:34:30 -0400
Received: by mail-oi1-f196.google.com with SMTP id g7so885533oia.8;
        Wed, 19 Jun 2019 18:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nYuOW5lyxxT0zsgk7qqZi/7w20Oi72vHiGCqLTnTrl8=;
        b=XxxTCKxD/5Hh4mP6+R4KSzkOEhkkx9EXfAH8omqHrIeXVmLMBa406JF09S5I9/dOxR
         wc9h4G7Dflde6RcyDAZnRIMTkl43HRI69tjffugAWRVlUFXSiEWEbbvf1v8Dkv333ACz
         fPBTlaPJtNz1tic4Y8+juQsuQ6mnFj5eYHNiMilXbbr3elf5dvc2xJrALVZVKGSFd1iZ
         efEFfZAArnZa7GOg/IseyJDpc7KuRCJF8XYefzt5VhBC48jDwJGyC0kRcJOnDLUKC0In
         eFPF3hEUJBXxsibzw51TwqvsjDFIP78hjGH3zMbetl9Rq5+bOJEMbbz3Y1EtDIbZufot
         ZLMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nYuOW5lyxxT0zsgk7qqZi/7w20Oi72vHiGCqLTnTrl8=;
        b=BNEsDTidFziHEymSbkUyEdskkuyBeBVCwziwa7rvAqOIrSG4eWjQmmVQRyUab2orZx
         zxXuwZkUEH9/ObfyEqpl5lo+HUwsCu6cKMUFXBL5OKadPQIO9RSab+5rtXoi4fiW4WRP
         gaIM8mmk1XlSA9kiSUecIQ3A3ikCuA8ixUNodUc6e3ax9LALBF4LruvmQ53Iym6Ar+Ws
         87jnzSdlyDcUQRO4pIeAAbpolXwcZgUmFZX5veAKUK223JZwMJ2fcPr9+f38iHVI0Q/u
         oAJMt+6+wMXL11JDT8yvu0jAUb/vzf7yfMPfb1dBHXLgjUR3FI+4L1EexMGCWyaAMdxF
         xApQ==
X-Gm-Message-State: APjAAAVhVyePyzMFVsj/BNAvEbOQe0LSxwyVEQhXR/A6aTrfzovv39li
        wcL7KPZ9hpOlMc7LE4DnPmjtMijzQx2SBhMPaXE=
X-Google-Smtp-Source: APXvYqwrykrLtbD0pG9V8vBrsbsTo35v6Soy95FKONjQ0aI87GQhODvgpXAK5RhK2mM0+AszFXum8RjavMf7MOSMXic=
X-Received: by 2002:aca:4403:: with SMTP id r3mr4853308oia.39.1560994469747;
 Wed, 19 Jun 2019 18:34:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190617165836.4673-1-colin.king@canonical.com>
 <20190619051308.23582-1-martin.blumenstingl@googlemail.com> <92f9e5a6-d2a2-6bf2-ff8a-2430fe977f93@canonical.com>
In-Reply-To: <92f9e5a6-d2a2-6bf2-ff8a-2430fe977f93@canonical.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Thu, 20 Jun 2019 03:34:18 +0200
Message-ID: <CAFBinCDmYVPDMcwAAYhMfxxuTsG=xunduN58_8e20zE_Mhmb7Q@mail.gmail.com>
Subject: Re: [PATCH] net: stmmac: add sanity check to device_property_read_u32_array
 call
To:     Colin Ian King <colin.king@canonical.com>
Cc:     alexandre.torgue@st.com, davem@davemloft.net, joabreu@synopsys.com,
        kernel-janitors@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        peppe.cavallaro@st.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

On Wed, Jun 19, 2019 at 8:55 AM Colin Ian King <colin.king@canonical.com> wrote:
>
> On 19/06/2019 06:13, Martin Blumenstingl wrote:
> > Hi Colin,
> >
> >> Currently the call to device_property_read_u32_array is not error checked
> >> leading to potential garbage values in the delays array that are then used
> >> in msleep delays.  Add a sanity check to the property fetching.
> >>
> >> Addresses-Coverity: ("Uninitialized scalar variable")
> >> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > I have also sent a patch [0] to fix initialize the array.
> > can you please look at my patch so we can work out which one to use?
> >
> > my concern is that the "snps,reset-delays-us" property is optional,
> > the current dt-bindings documentation states that it's a required
> > property. in reality it isn't, there are boards (two examples are
> > mentioned in my patch: [0]) without it.
> >
> > so I believe that the resulting behavior has to be:
> > 1. don't delay if this property is missing (instead of delaying for
> >    <garbage value> ms)
> > 2. don't error out if this property is missing
> >
> > your patch covers #1, can you please check whether #2 is also covered?
> > I tested case #2 when submitting my patch and it worked fine (even
> > though I could not reproduce the garbage values which are being read
> > on some boards)
> >
> >
> > Thank you!
> > Martin
> >
> >
> > [0] https://lkml.org/lkml/2019/4/19/638
> >
> Is that the correct link?
sorry, that is a totally unrelated link
the correct link is: https://patchwork.ozlabs.org/patch/1118313/
