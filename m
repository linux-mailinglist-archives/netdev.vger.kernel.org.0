Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6245E43D73
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732483AbfFMPmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:42:15 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:34283 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731865AbfFMJtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 05:49:18 -0400
Received: by mail-vs1-f68.google.com with SMTP id q64so12229082vsd.1
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 02:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NdS6xN6Z4DlPhoXqfSjLt1MlPeGtM/DFz1IwvW9UGoo=;
        b=gRY3cBMoBbyhUq/TwCPef50CCDKrv4iYze6tdunxTeCUZpRTxfdIbcrZIu3rL9nBmA
         IKu5OYITIeL6ltUdiFp9D/dQv5KZKcAv6V+fmHeGkWIe6jriJiht2zz2XO9FjHTjfRib
         NIvsg+FMfLXlxWpsnz2tVCHJTpT0XY2bvwC63A4K1b6VMqRrNgGbsb2LGvdXDeeBaEPZ
         m4z3ddfPasyoIKb3AqQ46OdJR6zCS6DXa7xNtmQomcyAaTessCVDKoSiccxpgKSHLEJM
         v8OJqfkxY2CdFdgcNZGppzV0c9uPWuWj07PpFzImXtu18YgRdm3Z/Qdd3ycwG99TvFSh
         91pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NdS6xN6Z4DlPhoXqfSjLt1MlPeGtM/DFz1IwvW9UGoo=;
        b=ndaeiZiRsxY8KKsznnripT5fEOACojd498FTZbtTTUhU4hJairq1T/N7uBsbEvw8Pi
         vTyJZ5E6BylxOUiT6v7OnXcik6GFLHp9vFCROZ7d+Q5I6bka3K0FJ6hpMjBK6iILkWrQ
         JR8wXtnq7ZRUpc9EmsdMC1PMw/F96zo/YBIqFfI0TNhFL/QcuyCCTXscXZuRPX161uPU
         TRiguLJUB7MNmkeYJPpezml/VI2mRrMYAi2O3WyxgRI4w6OcDcjeglGyom/wZ9iwej6F
         f08Lgr9IKlXFwUpd4Ntd51Gj6HZZv/Vo2hjhttJrfcJ8DY2UbgMT70C0xx/TnkDHQbey
         y/GA==
X-Gm-Message-State: APjAAAULwFlTpEH0lB6q0Kj48wwcR4aZJiPGigHI5Isr8u3RQlKZKKkK
        SM5nQbqNCafT7S3yhrapIYnz8gxHI5ETe/NMwHP48Q==
X-Google-Smtp-Source: APXvYqzWpA6aPKAyHaL8W3hPhJ3CXshgo14ktsq5uXw9v4wanH5DWggs2K573LXj7uMjFiRLQrDiZGsE/zNplvlP1QY=
X-Received: by 2002:a67:ed8b:: with SMTP id d11mr48182216vsp.35.1560419357888;
 Thu, 13 Jun 2019 02:49:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190607223716.119277-1-dianders@chromium.org>
 <20190607223716.119277-4-dianders@chromium.org> <363DA0ED52042842948283D2FC38E4649C52F8A0@IRSMSX106.ger.corp.intel.com>
 <CAD=FV=U8eo78Ee9xjhGXJMv=8YF9o89KLX024GH3iBRnRjCRvQ@mail.gmail.com>
 <CAPDyKFo=QMRTkNYUVSE2AqiZgytkTVRXF0Mvznn6trVT4-cR=Q@mail.gmail.com>
 <c7c6d3f4-ebb1-8964-0616-973fae1ab47d@broadcom.com> <CAPDyKFpM0+FfvoMo8Z_hxM9rzSjeQZHCsA2SPa8WP+SRDhhsPA@mail.gmail.com>
 <16b4bfb39e0.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <16b4bfb39e0.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 13 Jun 2019 11:48:41 +0200
Message-ID: <CAPDyKFr+nzy4JrtSrudORfOkFvPa==UtgaokQwigo8+c1L9wbQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] brcmfmac: sdio: Disable auto-tuning around
 commands expected to fail
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Doug Anderson <dianders@chromium.org>,
        "Hunter, Adrian" <adrian.hunter@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Double Lo <double.lo@cypress.com>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Madhan Mohan R <madhanmohan.r@cypress.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        netdev@vger.kernel.org, brcm80211-dev-list@cypress.com,
        Franky Lin <franky.lin@broadcom.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jun 2019 at 15:58, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
>
> On 6/12/2019 1:48 PM, Ulf Hansson wrote:
> > On Wed, 12 Jun 2019 at 13:11, Arend Van Spriel
> > <arend.vanspriel@broadcom.com> wrote:
> >>
> >> On 6/12/2019 12:10 PM, Ulf Hansson wrote:
> >>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c:
> >>>>     mmc_set_data_timeout(md, func->card);
> >>>>     mmc_wait_for_req(func->card->host, mr);
> >>> These are not okay, none of these things calls should really be done
> >>> from an SDIO func driver.
> >>>
> >>> It tells me that the func driver is a doing workaround for something
> >>> that should be managed in a common way.
> >>
> >> We are using some low-level functions passing chain of skbuff to the
> >> device using CMD53 with scatterlist. If I recall correctly Marvell made
> >> an attempt to have a similar function for it in the mmc stack. Not sure
> >> if that ever made it in. If so I can rework our driver using that API.
> >> If not, I can make a new attempt.
> >
> > I recall there were some patches, but not sure why we didn't merge them.
> >
> > Anyway, if you want to move this forward, that would be awesome!
>
> Let's scope it before moving forward. Our use-case is to transfer a
> chain of skbuff's. I am pretty sure that is not something we want to
> deal with in mmc stack api. So I suppose passing a scatterlist is more
> sensible, right? Maybe on sdio layer of the stack we could consider
> dealing with skbuff's for network func drivers?

Passing a scatter gather list seems reasonable. Ideally we should be
highly influenced with how buffers and dealt with for mmc block
requests.

Some information that may be needed by upper SDIO layers is the
segment/block constraints set by the MMC/SDIO host controller/driver.
The below is what we have today (see include/linux/mmc/host.h):

max_seg_size;   /* see blk_queue_max_segment_size */
max_segs;       /* see blk_queue_max_segments */
max_req_size;   /* maximum number of bytes in one req */
max_blk_size;   /* maximum size of one mmc block */
max_blk_count;  /* maximum number of blocks in one req */

Ideally we don't want SDIO func drivers to access these directly from
the ->host pointer, but rather via new SDIO func APIs.

>
> Let me see if I can find those Marvell patches. Might be a good start.

Great! Thanks!

Kind regards
Uffe
