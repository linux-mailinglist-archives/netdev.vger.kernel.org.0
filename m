Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 535475C5BD
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 00:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbfGAWnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 18:43:33 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:40029 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfGAWnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 18:43:33 -0400
Received: by mail-ot1-f65.google.com with SMTP id e8so15151556otl.7;
        Mon, 01 Jul 2019 15:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H+FNw+NOlut6naomTH3Jaosx9D2x6bZue6jd4dsjEec=;
        b=k5sA5zL3ucaqPtCjjSF7aojXfe6ajpmsNM4fd0lVnKYEcKKoQPJe21C/a1CyVBdraN
         db2pL5M85fQLAqZkff/n44BrT5YkOLFqfqDCw01JOB6Lukm2BAKlUboh1LgM3qvCVnTq
         1C7pR8xk76zE0Pq/BrZmMTqC5UH6i2yJP3f1Pa/ow4t5NjrNQA3uhVxeFK7eAgDaryaY
         V0UrQfn2yn9hISC34eOIgM7p/fRy2LeeaspKBC1mFCZ91lqQqPPzgZjyRlSRst1hkcI8
         EVbUDjlR+DBjMb+lZZ/qOqJsra1/JKILag2e/Be5yBF+DbasnaBShlfMRYhN8L6mB04y
         MVpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H+FNw+NOlut6naomTH3Jaosx9D2x6bZue6jd4dsjEec=;
        b=H19Bs8nh/jok4t5TIRPUI+UOhpAUCcavPEukYpd6KTjEfoyGFEEJzQjuLrpUaZlfZH
         U/+GY41g8ee00xgotg/9P5UFmF8hptWgg/hcrBX/SPjTPlm2AQy/VD3Dwyzn1B5PnjIs
         Rfw8TWGXteDqpcwg2yRYXxmOgh0gIJvG3aw8vocJ/UAZVXSBuHkuxOocIM8ju4t6A+Yj
         0VG1SPCceojtM+W7FO6Dlz2prc0YTDIPIHpzVbfOVw3ClNSWdCOpojpl/VGdZFWobZin
         be+JgZpxDqalSNx9mmR7cZzi9uVIyAOBS+R/e/KKdWGV4QUyDw53VH2ztBzWT+JjMst2
         Tafg==
X-Gm-Message-State: APjAAAVdqKDWSY2FWpavj6MFhiEUlh4+dd0jfqmIkymI74ygcUplTzdr
        vRSoWShQsCB9NFun3GxP0ybJcmPKSG1rXRYr3sA=
X-Google-Smtp-Source: APXvYqwmovHM5voAuTylzInGXDPJ/PcyDtIGDZIX7k36UfXqOEDyHSTNd1MplXuOwNAuC5VUWb/c/0g8bRoj7Iou7SM=
X-Received: by 2002:a9d:23ca:: with SMTP id t68mr21564574otb.98.1562021012050;
 Mon, 01 Jul 2019 15:43:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190617165836.4673-1-colin.king@canonical.com>
 <20190619051308.23582-1-martin.blumenstingl@googlemail.com>
 <92f9e5a6-d2a2-6bf2-ff8a-2430fe977f93@canonical.com> <CAFBinCDmYVPDMcwAAYhMfxxuTsG=xunduN58_8e20zE_Mhmb7Q@mail.gmail.com>
 <CAFBinCC-LLpfXQRFcKBbUpCfKc0S9Xtt60QrhEThsOFV-T7vFw@mail.gmail.com>
 <c46d2d17-c35b-46f0-0674-0c55bea3a272@canonical.com> <CAFBinCBk5aPVE+vq5px3QKS1T_R=WGXXxEJMC9X676KGvi9jdg@mail.gmail.com>
 <26646ff1-059f-fb2d-e05d-43009aeb2150@canonical.com> <CAFBinCAx5qrPK1z68bF-tGKpJQfKLnee65qBOxMS4nj8t381+Q@mail.gmail.com>
In-Reply-To: <CAFBinCAx5qrPK1z68bF-tGKpJQfKLnee65qBOxMS4nj8t381+Q@mail.gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 2 Jul 2019 00:43:21 +0200
Message-ID: <CAFBinCCpJLSQiUeqpQTKQDgjy7-ROgjYa913Xe1My_oc6miTzw@mail.gmail.com>
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

On Fri, Jun 28, 2019 at 6:05 PM Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
>
> Hi Colin,
>
> On Fri, Jun 28, 2019 at 10:32 AM Colin Ian King
> <colin.king@canonical.com> wrote:
> >
> > On 28/06/2019 05:15, Martin Blumenstingl wrote:
> > > On Tue, Jun 25, 2019 at 9:58 AM Colin Ian King <colin.king@canonical.com> wrote:
> > >>
> > >> On 25/06/2019 05:44, Martin Blumenstingl wrote:
> > >>> Hi Colin,
> > >>>
> > >>> On Thu, Jun 20, 2019 at 3:34 AM Martin Blumenstingl
> > >>> <martin.blumenstingl@googlemail.com> wrote:
> > >>>>
> > >>>> Hi Colin,
> > >>>>
> > >>>> On Wed, Jun 19, 2019 at 8:55 AM Colin Ian King <colin.king@canonical.com> wrote:
> > >>>>>
> > >>>>> On 19/06/2019 06:13, Martin Blumenstingl wrote:
> > >>>>>> Hi Colin,
> > >>>>>>
> > >>>>>>> Currently the call to device_property_read_u32_array is not error checked
> > >>>>>>> leading to potential garbage values in the delays array that are then used
> > >>>>>>> in msleep delays.  Add a sanity check to the property fetching.
> > >>>>>>>
> > >>>>>>> Addresses-Coverity: ("Uninitialized scalar variable")
> > >>>>>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > >>>>>> I have also sent a patch [0] to fix initialize the array.
> > >>>>>> can you please look at my patch so we can work out which one to use?
> > >>>>>>
> > >>>>>> my concern is that the "snps,reset-delays-us" property is optional,
> > >>>>>> the current dt-bindings documentation states that it's a required
> > >>>>>> property. in reality it isn't, there are boards (two examples are
> > >>>>>> mentioned in my patch: [0]) without it.
> > >>>>>>
> > >>>>>> so I believe that the resulting behavior has to be:
> > >>>>>> 1. don't delay if this property is missing (instead of delaying for
> > >>>>>>    <garbage value> ms)
> > >>>>>> 2. don't error out if this property is missing
> > >>>>>>
> > >>>>>> your patch covers #1, can you please check whether #2 is also covered?
> > >>>>>> I tested case #2 when submitting my patch and it worked fine (even
> > >>>>>> though I could not reproduce the garbage values which are being read
> > >>>>>> on some boards)
> > >>> in the meantime I have tested your patch.
> > >>> when I don't set the "snps,reset-delays-us" property then I get the
> > >>> following error:
> > >>>   invalid property snps,reset-delays-us
> > >>>
> > >>> my patch has landed in the meantime: [0]
> > >>> how should we proceed with your patch?
> >
> > Your fix is good, so I think we should just drop/forget about my fix.
> thank you for looking at the situation
>
> as far I understand the -net/-net-next tree all commits are immutable
> so if we want to remove your patch we need to send a revert
> do you want me to do that (I can do it on Monday) or will you take care of that?
I just sent the patch: [0]


[0] https://patchwork.ozlabs.org/patch/1125686/
