Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95E54DCD43
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 20:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505635AbfJRSEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 14:04:20 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39347 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbfJRSEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 14:04:20 -0400
Received: by mail-lf1-f66.google.com with SMTP id 195so5369219lfj.6
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 11:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BKUjV+Z8EIWRr9XKRO16itwdybPjb2TppEvKOrPVvaY=;
        b=RGBHDUmUZ1ITmUUSLWhZSbMyeS1zLC77pOvNV86RZhHJ4rLio+98SI7eTJucghGHUX
         OHjo4WueJbBqHPXFXTRDiAsSl93WmsVtdPScnk4x39sUHe1/ER0DJ/AkiZ7Vjn0BdLO9
         OZj+ty0J1oUr4YOWyT8kK8FkIFfLGr5P4fa7VeF4kAvxxBq9NFMPfdBXK00yu2Xahce6
         i0ftmLvPzUwx7xPP9u1roJnxu3bzV3NezAIiK8Qv3WBchtu4GpEJ+8pbWRAqiwStVCOG
         ViFIbeA3OcZojZOh75ieZja2oX2WjulFr0miTXiZ62ML4iv6PTf8mgQx1K8RjL5/KqVM
         LLRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BKUjV+Z8EIWRr9XKRO16itwdybPjb2TppEvKOrPVvaY=;
        b=RNGP97RkqhqMXLOdcsPoqCqjUs4X4IcERpa/oUlC+n6uXIk5e6sdGbzBT2XX1hUITG
         iWcd4pFVFzCyTrcW+Nt1F4ycQeyqqFU1ly4IW6cNFHcAibzN+s7OPax7yqgzn92o+kED
         yqLaBynUKe9RWfMUU+K/22fjtp0bnA0EAnlxmhK7KYa1OAK2yvSDhbNXdQ61Iob5MNNU
         iR0h7fjf8x3o/V7PP5DyeA/LBVY6As1rHirIv/HVf/MCnfTI7Evfjwnbnhxn0FbbxN5l
         jXqQ4GrT7t5UpaK4ecmCqqL32rdVPZ1FVst37bV55Lhh/dGwNI9Th0GfnxApjYllNd3f
         i9LA==
X-Gm-Message-State: APjAAAXLlw/E+4BmhWeJqU8XLx9ni2ToTcpp+kua59NFH/y3Ac5KEtRH
        WIPSVNszDUGFtauJkdnDodikby+q88pxeJLHc9k=
X-Google-Smtp-Source: APXvYqydKQ3XrOVK/Viv5spkgoZJQQDzIeJevGNMor/Piny/H+CH0zei+4sdepQYFtFE9RP13lOzaaNIESAO2DNvg/0=
X-Received: by 2002:a19:c192:: with SMTP id r140mr2742158lff.48.1571421858326;
 Fri, 18 Oct 2019 11:04:18 -0700 (PDT)
MIME-Version: 1.0
References: <1570812820-20052-1-git-send-email-johunt@akamai.com>
 <1570812820-20052-3-git-send-email-johunt@akamai.com> <a99acf6128404c54ba837e2b0afe1d98@intel.com>
In-Reply-To: <a99acf6128404c54ba837e2b0afe1d98@intel.com>
From:   Josh Hunt <joshhunt00@gmail.com>
Date:   Fri, 18 Oct 2019 11:04:06 -0700
Message-ID: <CAKA=qzZcO9vuJeuBhXd+25WHuMVHz1LbyCBngqhd0mQ3a0LF0g@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH v3 2/3] ixgbe: Add UDP segmentation
 offload support
To:     "Bowers, AndrewX" <andrewx.bowers@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 5:33 AM Bowers, AndrewX
<andrewx.bowers@intel.com> wrote:
>
> > -----Original Message-----
> > From: Intel-wired-lan [mailto:intel-wired-lan-bounces@osuosl.org] On
> > Behalf Of Josh Hunt
> > Sent: Friday, October 11, 2019 9:54 AM
> > To: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org; Kirsher,
> > Jeffrey T <jeffrey.t.kirsher@intel.com>
> > Cc: Duyck, Alexander H <alexander.h.duyck@intel.com>;
> > willemb@google.com; Josh Hunt <johunt@akamai.com>;
> > alexander.h.duyck@linux.intel.com
> > Subject: [Intel-wired-lan] [PATCH v3 2/3] ixgbe: Add UDP segmentation
> > offload support
> >
> > Repost from a series by Alexander Duyck to add UDP segmentation offload
> > support to the igb driver:
> > https://lore.kernel.org/netdev/20180504003916.4769.66271.stgit@localhost.l
> > ocaldomain/
> >
> > CC: Alexander Duyck <alexander.h.duyck@intel.com>
> > CC: Willem de Bruijn <willemb@google.com>
> > Suggested-by: Alexander Duyck <alexander.h.duyck@intel.com>
> > Signed-off-by: Josh Hunt <johunt@akamai.com>
> > ---
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 24
> > ++++++++++++++++++------
> >  1 file changed, 18 insertions(+), 6 deletions(-)
>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
>
>
Andrew, thanks for testing. Were you able to validate the igb driver?

Thanks
-- 
Josh
