Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3CFA69EF1E
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 08:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbjBVHJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 02:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbjBVHJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 02:09:37 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0602A17F
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 23:09:36 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id 76so3180790iou.9
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 23:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mopGGJRWyF6lhmZLijInHJpk0iqSNEh7TvfY6xu4PPI=;
        b=MV5ydonJf5couW8XWZh3Os3P5xphPi7lmCUVxsm9irpj5pGp+T0Wh/8DJOhjZGOYZh
         Q56nUiQNIlapJCBxPC9MF6el7nh8lItNDjUWEmCxSx8hoO2SHn2kFnO1X9Ci8+1tp/6Z
         MxHK+3CHr5aAuWZQmbGxPZliuD7LTRIqyG0uM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mopGGJRWyF6lhmZLijInHJpk0iqSNEh7TvfY6xu4PPI=;
        b=EzmLlcoGLJcab5CPKAjnWycIUErMYkfD4/5PTtMRNkaecETWBosMFc6GuCzumGcyvl
         ZW/AHTANN0UYfQJDAcVJuReCR7M5p49qNhryWLpGwFcFHhVls7PVrMbkwXphwrOjXWpV
         bF1He/RWGzA97AV58wy3bTq953zV1iiSq74A+b62roSewvQ8oE4ew+baSHP0IzHacrxT
         iK3VsBsTRIsFAMBmG3cXbipbcDJy2RK6DHf9+r0KFbPLRbfnB2tM77Wzle2lEKnaOWMj
         LAe6cz6RRvHX2xPVCwrdztQ+jVEyckMm/zfZCOZi1r4nmHVvnQNo+5LM23zwTjewHM1X
         uMlA==
X-Gm-Message-State: AO0yUKWFc2bxq5t8qp52ckihAxiUST6n8ec+RxBjpNhyzrJf49grEPoZ
        b/sOnqkaomxQxJ24sEiSYffZ1vihW09bw82b6zb8FQ==
X-Google-Smtp-Source: AK7set+tqFM6R9VNoRneOI95BWuxBGUxEVAwGo2e4OEi8THxSuZWMYnxR5HVyRIFUqGgpXQhecv7XYy9KnG7BYIS8FA=
X-Received: by 2002:a5d:990e:0:b0:71e:2d29:aa48 with SMTP id
 x14-20020a5d990e000000b0071e2d29aa48mr4437709iol.29.1677049775507; Tue, 21
 Feb 2023 23:09:35 -0800 (PST)
MIME-Version: 1.0
References: <20230203000116.v2.1.I5bb9c164a2d2025655dee810b983e01ecd81c14e@changeid>
In-Reply-To: <20230203000116.v2.1.I5bb9c164a2d2025655dee810b983e01ecd81c14e@changeid>
From:   Abhishek Kumar <kuabhs@chromium.org>
Date:   Tue, 21 Feb 2023 23:09:24 -0800
Message-ID: <CACTWRws334p0qpsZrDBULgS124Zye9D7YC3F9hzJpaFzSmn1CQ@mail.gmail.com>
Subject: Re: [PATCH v2] ath10k: snoc: enable threaded napi on WCN3990
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, ath10k@lists.infradead.org,
        quic_mpubbise@quicinc.com, netdev@vger.kernel.org, kuba@kernel.org,
        linux-wireless@vger.kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kale,

Gentle reminder for your comments.

Thanks
Abhishek

On Thu, Feb 2, 2023 at 4:02 PM Abhishek Kumar <kuabhs@chromium.org> wrote:
>
> NAPI poll can be done in threaded context along with soft irq
> context. Threaded context can be scheduled efficiently, thus
> creating less of bottleneck during Rx processing. This patch is
> to enable threaded NAPI on ath10k driver.
>
> Based on testing, it was observed that on WCN3990, the CPU0 reaches
> 100% utilization when napi runs in softirq context. At the same
> time the other CPUs are at low consumption percentage. This
> does not allow device to reach its maximum throughput potential.
> After enabling threaded napi, CPU load is balanced across all CPUs
> and following improvments were observed:
> - UDP_RX increase by ~22-25%
> - TCP_RX increase by ~15%
>
> Here are some of the additional raw data with and without threaded napi:
> ==================================================
> udp_rx(Without threaded NAPI)
> 435.98+-5.16 : Channel 44
> 439.06+-0.66 : Channel 157
>
> udp_rx(With threaded NAPI)
> 509.73+-41.03 : Channel 44
> 549.97+-7.62 : Channel 157
> ===================================================
> udp_tx(Without threaded NAPI)
> 461.31+-0.69  : Channel 44
> 461.46+-0.78 : Channel 157
>
> udp_tx(With threaded NAPI)
> 459.20+-0.77 : Channel 44
> 459.78+-1.08 : Channel 157
> ===================================================
> tcp_rx(Without threaded NAPI)
> 472.63+-2.35 : Channel 44
> 469.29+-6.31 : Channel 157
>
> tcp_rx(With threaded NAPI)
> 498.49+-2.44 : Channel 44
> 541.14+-40.65 : Channel 157
> ===================================================
> tcp_tx(Without threaded NAPI)
> 317.34+-2.37 : Channel 44
> 317.01+-2.56 : Channel 157
>
> tcp_tx(With threaded NAPI)
> 371.34+-2.36 : Channel 44
> 376.95+-9.40 : Channel 157
> ===================================================
>
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2-00696-QCAHLSWMTPL-1
> Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
> ---
>
> Changes in v2:
> - Removed the hw param checks to add dev_set_threaded() to snoc.c
> - Added some more test data in the commit message.
>
>  drivers/net/wireless/ath/ath10k/snoc.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
> index cfcb759a87de..0f6d2f67ff6b 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.c
> +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> @@ -927,6 +927,7 @@ static int ath10k_snoc_hif_start(struct ath10k *ar)
>
>         bitmap_clear(ar_snoc->pending_ce_irqs, 0, CE_COUNT_MAX);
>
> +       dev_set_threaded(&ar->napi_dev, true);
>         ath10k_core_napi_enable(ar);
>         ath10k_snoc_irq_enable(ar);
>         ath10k_snoc_rx_post(ar);
> --
> 2.39.1.519.gcb327c4b5f-goog
>
