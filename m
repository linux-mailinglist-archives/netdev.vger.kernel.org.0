Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E93742D8B5
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 14:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhJNMEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 08:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbhJNMEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 08:04:15 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F5DC061570;
        Thu, 14 Oct 2021 05:02:10 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id k29so3556101qve.6;
        Thu, 14 Oct 2021 05:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LCGYTM8PrlK3nTDqb32h7V9GbZN6iE4UEGwF+ksTF7g=;
        b=LHxfpUO5m1fZ68k4WTsL3KrR/mn3qL0AwvVMvG+QVzQt1YyGm+dA2VgCHpPiJy3JWB
         OTGTrR8pegPXPLXT8M71FeDuvPUMnX/zhbJoztwC/akn4KGWzVyZC1gjM4yg5XbqHdkc
         3aGT7wfBhacqBakv9JsOjVTpSQUzv4bkaQrojCaY+eHH8zKYB3EPtI+LMNxhPU8Cg1yM
         Ua2SL+0hMsOF1ItVfZtoq+ZdNGJQgJAAborNSCO0zLGgpcPQDuWEDnoB6Jwpu2a3nK8B
         3W6yxM++UPDX8rLA2qyVJvdDoFLPbqHh8GKM4bDAmW6RyiJ+3U2cr6z8rm4O6/qmjDig
         /PlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LCGYTM8PrlK3nTDqb32h7V9GbZN6iE4UEGwF+ksTF7g=;
        b=EE2/QZEA3l/PQHvrruP5vkpCCgcWZNXbJshXO5eHy36R2lDnFPzBUg66y5GgXNPska
         uQJrKnvShjLTvlHEdZ34PhAF7jpzRRHBKjdE9sdkb9KgZnGxZGDxWJiZqhQCEC+I/h8u
         fpKPUsI5RJok3Lq0dXNArb9Ds0iO7FXPPjfNH0tQRbtYFR2bLv7M3fY1vOP5bMhDPMOK
         Sz+WLbPBOhhcD/88sWm/OTMjpRLlM23FaXJwuGIFEKi8HH8ob/s/bfjsffVNpxAjf2wv
         SpjCVUovZMTfJ2Px6kgPUxhR8VTMn0aEDcBlaxDv3Doz1ynAjYymSJIubPVNhUNFMDwW
         2sYA==
X-Gm-Message-State: AOAM5300jGE0NY8GBHva7qImozT6gyX3Pdd3SsPX+ayRpCMiI/5vhn7q
        RlGjBbe/gCJelaO8ZpsS5zgPoofxw9RlA1fTj5Qxgdi3dJsr2g==
X-Google-Smtp-Source: ABdhPJywqS5I4lc7tpAbXjXvHGk7VgfSjByPwdbpbD31qdl77TMxwCQTAXtbZL791keVv8Hu9089h+xd7nsTbThQtgU=
X-Received: by 2002:a0c:c24c:: with SMTP id w12mr4849547qvh.48.1634212929738;
 Thu, 14 Oct 2021 05:02:09 -0700 (PDT)
MIME-Version: 1.0
References: <20211009221711.2315352-1-robimarko@gmail.com> <ba520cf0-480e-245b-395f-7d3a5f771521@gmail.com>
In-Reply-To: <ba520cf0-480e-245b-395f-7d3a5f771521@gmail.com>
From:   Robert Marko <robimarko@gmail.com>
Date:   Thu, 14 Oct 2021 14:01:58 +0200
Message-ID: <CAOX2RU7VaxdU3VykTZER-pdpu6pnk3tbVrBmkGU=jPQo6rL3Xg@mail.gmail.com>
Subject: Re: [PATCH] ath10k: support bus and device specific API 1 BDF selection
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Oct 2021 at 13:54, Christian Lamparter <chunkeey@gmail.com> wrote:
>
> On 10/10/2021 00:17, Robert Marko wrote:
> > Some ath10k IPQ40xx devices like the MikroTik hAP ac2 and ac3 require the
> > BDF-s to be extracted from the device storage instead of shipping packaged
> > API 2 BDF-s.
> >
> > This is required as MikroTik has started shipping boards that require BDF-s
> > to be updated, as otherwise their WLAN performance really suffers.
> > This is however impossible as the devices that require this are release
> > under the same revision and its not possible to differentiate them from
> > devices using the older BDF-s.
> >
> > In OpenWrt we are extracting the calibration data during runtime and we are
> > able to extract the BDF-s in the same manner, however we cannot package the
> > BDF-s to API 2 format on the fly and can only use API 1 to provide BDF-s on
> > the fly.
> > This is an issue as the ath10k driver explicitly looks only for the
> > board.bin file and not for something like board-bus-device.bin like it does
> > for pre-cal data.
> > Due to this we have no way of providing correct BDF-s on the fly, so lets
> > extend the ath10k driver to first look for BDF-s in the
> > board-bus-device.bin format, for example: board-ahb-a800000.wifi.bin
> > If that fails, look for the default board file name as defined previously.
> >
> > Signed-off-by: Robert Marko <robimarko@gmail.com>
> > ---
>
> As mentioned in Robert's OpenWrt Pull request:
> https://github.com/openwrt/openwrt/pull/4679
>
> It looks like the data comes from an mtd-partition parser.
> So the board data takes an extra detour through userspace
> for this.
>
> Maybe it would be great, if that BDF (and likewise pre-cal)
> files could be fetched via an nvmem-consumer there?
> (Kalle: like the ath9k-nvmem patches)

Christian, in this case, NVMEM wont work as this is not just read from
an MTD device, it first needs to be parsed from the MikroTik TLV, and
then decompressed as they use LZO with RLE to compress the caldata
and BDF-s.

>
> This would help with many other devices as well, since currently
> in OpenWrt all pre-cal data has to be extracted by userspace
> helpers, while it could be easily accessible through nvmem.

Yeah, for non-MikroTik stuff pre-cal data via NVMEM would be great.

Regards,
Robert
>
> What do you think?
>
> Cheers,
> Christian
