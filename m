Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E77146D335
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 13:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbhLHMZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 07:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbhLHMZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 07:25:31 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971ADC061746;
        Wed,  8 Dec 2021 04:21:59 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id gu12so2078274qvb.6;
        Wed, 08 Dec 2021 04:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8uy0DZF7lXHvcBRiAIjRsLK9cNEa6jf/rNNhdNudo5w=;
        b=cHX2O0p2l777DDyIx13QKGz8UX24Uk7UaRJHIphrFXhWQpCdBq/STZ3JU+jBVhQXFQ
         eEK73FHRc8ykrxIkcW7EwsQYpWU6hiH7uV8aTrQq5q6z9MvamNo8ByD3T0Q1O+bwdX9d
         mrsXJpL6z7KG9Q+Tf/oWyZrkkY+sClbYwIw5oqyQ0fK7+JQrmG45imzLDKke4y2afb2Q
         fZnfzwPckqBkkd1mqT5N+uYOuijVavructJJmCmCZHWTC9gwdoAAKeI8aKLjO1IBrob+
         8x/McZkGWEFExIhOMVDwl+XJQT24Tq3BHUhgUtO0J+N9HOzAtgD0z8aYTJYyWd3YbQxd
         HpMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8uy0DZF7lXHvcBRiAIjRsLK9cNEa6jf/rNNhdNudo5w=;
        b=SgBqHCNhYLhlpFCPDif1zn63HLwkPeSV985+RUerw2ZadxthamHH9nHpZhU6JtBI1S
         l1pWX25fKYugZRdJiShbAl82FrP0Pm7Gs/TG6wxQs7c1fLPgfwdptIDb8zYvqIxLV1o3
         CQI9IY9SeYkQp2TNu0UswfvgKIdCvgTsmQ62Eic7NzA4Lot+NEdgvh11JZVbih9uxCNV
         UsO78XqD281WJjAECNjS0B6gVwXDpc4anhvcC0amCsUKKVY//MoOJOL4QV5//87CS6CI
         MKmEPekjOWgWffjY7DcU2WHR55+L7elFdUETgtEgrcUDacbKVVDRLhDceTZhlzXtQJrj
         i0tw==
X-Gm-Message-State: AOAM533GfvkG+SPGjevCeiREgxIk/8BQOhMl0WpyKA3BbwSdXdwlqocz
        f2N16j288/79i96p1iHk9AwQ2HYcZYUkL+pS0tA=
X-Google-Smtp-Source: ABdhPJw4YNDPavQA3I/O4k+Cm2sSpqxXToag596Tt+4b8OC+lHeBZ071Vp1j5+4JZaFFBqijN0cyCd68ufQr4+BQKxY=
X-Received: by 2002:a05:6214:1909:: with SMTP id er9mr6882300qvb.118.1638966118601;
 Wed, 08 Dec 2021 04:21:58 -0800 (PST)
MIME-Version: 1.0
References: <20211009221711.2315352-1-robimarko@gmail.com> <163890036783.24891.8718291787865192280.kvalo@kernel.org>
In-Reply-To: <163890036783.24891.8718291787865192280.kvalo@kernel.org>
From:   Robert Marko <robimarko@gmail.com>
Date:   Wed, 8 Dec 2021 13:21:47 +0100
Message-ID: <CAOX2RU5mqUfPRDsQNSpVPdiz6sE_68KN5Ae+2bC_t1cQzdzgTA@mail.gmail.com>
Subject: Re: [PATCH] ath10k: support bus and device specific API 1 BDF selection
To:     Kalle Valo <kvalo@kernel.org>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Dec 2021 at 19:06, Kalle Valo <kvalo@kernel.org> wrote:
>
> Robert Marko <robimarko@gmail.com> wrote:
>
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
>
> Can someone review this, please? I understand the need for this, but the board
> handling is getting quite complex in ath10k so I'm hesitant.
>
> What about QCA6390 and other devices. Will they still work?
Hi Kalle,
everything else should just continue working as before unless the
board-bus-device.bin file
exists it will just use the current method to fetch the BDF.

Also, this only applies to API1 BDF-s.

We are really needing this as currently there are devices with the
wrong BDF being loaded as
we have no way of knowing where MikroTik changed it and dynamic
loading would resolve
all of that since they are one of the rare vendors that embed the
BDF-s next to calibration data.

Regards,
Robert
>
> --
> https://patchwork.kernel.org/project/linux-wireless/patch/20211009221711.2315352-1-robimarko@gmail.com/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
>
