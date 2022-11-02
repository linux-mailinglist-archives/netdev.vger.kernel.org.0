Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14856156C2
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 01:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiKBAvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 20:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiKBAvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 20:51:12 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1EE1AF09;
        Tue,  1 Nov 2022 17:51:11 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id f205so19399412yba.2;
        Tue, 01 Nov 2022 17:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=A7bdpItY6zMrQfq3Fk0140q6BMh/8jsZnXOJ8IRi9hs=;
        b=Gmi9a+uMFhbPWcnoH3zqWVn+7UXZxBPVP1UMdo86TSfyIUW37LqQqMjPy5h9jU/2t5
         jSaOV/vshA01CU3Pk563SuNdVgolrvwIIlrpfDGEUJ/6SyLEF8ySdjeVBfKqivDnU5bA
         tVYwEqrafZvzZqY3+wSJFnmBws6cywLdaJLjBQfOwaPSijQTorMaDIR4wsL3I6NrkDnp
         VXCwFo7GNx+A4Em2ptdQdNLf5UhTQUJeIfUkN2Mvq5srDEfSMjIvZ1Zu4tQNDI7AoutN
         ruyoocdUbprkN3vUZ0RQUep28eE2Iy5VfgjCsbKSY3+SePy84+Knkpo4kHPfFsIV67nI
         KPaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A7bdpItY6zMrQfq3Fk0140q6BMh/8jsZnXOJ8IRi9hs=;
        b=0+gXwhTb+zTcJmd5vvzX7HIGUx9m5kE4w+amGb3bPcYT20tkFISO1MldKsvNRsex2m
         nnTm1zTWPKZocBOOgAqFC57bFoXiO8MjrD88Os1EbhHPG0ngkyKKmROprsZc8Y0weIqs
         F9Clyun+asKvlGUW7FnnPs+YGrtn3Y8HwnZUz2mOK2vwROGNjLRyDL1RO5vVC0aQWwmc
         zOQpEEClMp1PHKVFUPdkx2xZwXs4nkjzje9cs1Owjd1O/dU55PF1OmGUVJ00tSEOLT9H
         JezXgEvN8K/hyagCMkuEiDDC4EK4zPmOGp3+Lm4zWK5YePYoa32Pc+qJ/sacqx/PBZin
         Fm7g==
X-Gm-Message-State: ACrzQf328CqFQUZ63kr5zrVnlmPgUhEQl7QledMDkFWqyENgrpR9Gfdt
        99f42eLAKaHv3wkzXJw3g4j3ubLNG2LrWUSaSUznVAf+
X-Google-Smtp-Source: AMsMyM6Bl7z/WCUocKt+tS46j4uSPrShaq6DanRRmDuqRd9Wk+hHsvqAiNeOlUffW1TJAxiJm+6gzQ+G4pCzB885cbw=
X-Received: by 2002:a25:7e04:0:b0:6b3:9cc2:e1c8 with SMTP id
 z4-20020a257e04000000b006b39cc2e1c8mr21556209ybc.439.1667350270619; Tue, 01
 Nov 2022 17:51:10 -0700 (PDT)
MIME-Version: 1.0
References: <20221022042728.43015-1-stachecki.tyler@gmail.com> <87y1sug2bl.fsf@kernel.org>
In-Reply-To: <87y1sug2bl.fsf@kernel.org>
From:   Tyler Stachecki <stachecki.tyler@gmail.com>
Date:   Tue, 1 Nov 2022 20:51:22 -0400
Message-ID: <CAC6wqPXjtkiP8pZ_nTXdZva6JnQLWbW7p+ukyAZO6scF5CR7Rw@mail.gmail.com>
Subject: Re: [PATCH] ath11k: Fix QCN9074 firmware boot on x86
To:     Kalle Valo <kvalo@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:QUALCOMM ATHEROS ATH11K WIRELESS DRIVER" 
        <ath11k@lists.infradead.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 1, 2022 at 10:46 AM Kalle Valo <kvalo@kernel.org> wrote:
>
> "Tyler J. Stachecki" <stachecki.tyler@gmail.com> writes:
>
> > The 2.7.0 series of QCN9074's firmware requests 5 segments
> > of memory instead of 3 (as in the 2.5.0 series).
> >
> > The first segment (11M) is too large to be kalloc'd in one
> > go on x86 and requires piecemeal 1MB allocations, as was
> > the case with the prior public firmware (2.5.0, 15M).
> >
> > Since f6f92968e1e5, ath11k will break the memory requests,
> > but only if there were fewer than 3 segments requested by
> > the firmware. It seems that 5 segments works fine and
> > allows QCN9074 to boot on x86 with firmware 2.7.0, so
> > change things accordingly.
> >
> > Signed-off-by: Tyler J. Stachecki <stachecki.tyler@gmail.com>
>
> Ouch, that's pretty bad. Thanks for fixing this!
>
> Does the 2.5.0.1 firmware branch still work with this patch? It's
> important that we don't break the old firmware.
>
> --
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

Yep, tested the patch with all 3 combinations, below:

QCN9074:
WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1
WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1

WCN6855:
WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.16
