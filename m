Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499DA54E8A3
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 19:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbiFPRae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 13:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbiFPRaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 13:30:30 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B9127B0F
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 10:30:30 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y6so2056449pfr.13
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 10:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RlfIQALGU9mh4pnp7eTv+QSWg9ykNh3VabMffxsAIfU=;
        b=xu2hUzirJbxPfvgsMVAuDM8izVlSeA1nW8Yc+AxYcpf+sM6JNRNhF4iHzRR9pq8QSK
         OMCYxWFKBvmm8zbFMhEXAjRjL5TvY6cS5VT0xHbYXh/PJibC1dgxKVlrc/L9H0OL4WCr
         onEbzQUXApbjvzuS6gil/w4De/DEclCOO8gQJdYykDowCQqjiVA9GHfVnl+hNxiw827d
         fYVRwJUK8Uj2oiCZZSRel6EEBcbYX1xvZYMBP2lZ9vDk34bmRFJKWJUKnS9gtZlTtpi7
         oem1b13MC5Ow6X91QGoHeXP+F7dMZlzewQJ1yFegRGazmKt8L7sxaj7KjgSOdS2Tnolv
         EGsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RlfIQALGU9mh4pnp7eTv+QSWg9ykNh3VabMffxsAIfU=;
        b=L7bHVypVYANc1S9B9f4jiT6BVi6CBgnp1T7azDqlKkXUCOKVbX7YhPXPZDFKWIj2Hb
         amA3YUYZDZWfPY3FMap0mhJ0DKLkjUmruZkxp21DK7W5qqkLN47Z05xeRfnAHucmeQNQ
         fRUE57VccskbUcZgbucNjq3zsYZmScTU5L+7mCgAb8/Dzfgw77c4QMdcyeteulYNakCd
         1z3ZjHZBOCdOpamMZHKV0VdTo/0lEKF5MaD3K0apQ15RkgUfs7LqS8AY4nhDIF2h1lM3
         Voc1DNMOM1ngUPkAtJeul5D3bn3IvwS0hrW+k2Cssh93IBEpa8Lo8nyCseQ7l+bEbCCd
         RO3g==
X-Gm-Message-State: AJIora9eB/R95lN2AaLidVttMoacAw0tVztWbN8gKyHd3c9tD9oZ9t3n
        YUdMcaJ4GjMt3RzfN1AAvHj209OsSmk6gQntguOPqA==
X-Google-Smtp-Source: AGRyM1sodbT2R6m3loUEGXdk4rJtpQCNjdew+/h0RyPtJfwsANtECPCZx9IEz9Mb7G0O0AOBD9xyQbjax/gs0V6QC9k=
X-Received: by 2002:a05:6a00:ad2:b0:4f1:2734:a3d9 with SMTP id
 c18-20020a056a000ad200b004f12734a3d9mr5882169pfl.61.1655400629409; Thu, 16
 Jun 2022 10:30:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220614205756.6792-1-moises.veleta@linux.intel.com>
In-Reply-To: <20220614205756.6792-1-moises.veleta@linux.intel.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 16 Jun 2022 19:29:53 +0200
Message-ID: <CAMZdPi8cdgDUtDN=Oqz7Po+_XsKS=tRmx-Hg=_Mix9ftKQ5b3A@mail.gmail.com>
Subject: Re: [PATCH net-next 1/1] net: wwan: t7xx: Add AP CLDMA and GNSS port
To:     Moises Veleta <moises.veleta@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, ricardo.martinez@linux.intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        ilpo.jarvinen@linux.intel.com, moises.veleta@intel.com,
        Madhusmita Sahu <madhusmita.sahu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Moises,

On Tue, 14 Jun 2022 at 22:58, Moises Veleta
<moises.veleta@linux.intel.com> wrote:
>
> From: Haijun Liu <haijun.liu@mediatek.com>
>
> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
> communicate with AP and Modem processors respectively. So far only
> MD-CLDMA was being used, this patch enables AP-CLDMA and the GNSS
> port which requires such channel.
>
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
> Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>
> ---
[...]
>
>  static const struct t7xx_port_conf t7xx_md_port_conf[] = {
>         {
> +               .tx_ch = PORT_CH_AP_GNSS_TX,
> +               .rx_ch = PORT_CH_AP_GNSS_RX,
> +               .txq_index = Q_IDX_CTRL,
> +               .rxq_index = Q_IDX_CTRL,
> +               .path_id = CLDMA_ID_AP,
> +               .ops = &wwan_sub_port_ops,
> +               .name = "t7xx_ap_gnss",
> +               .port_type = WWAN_PORT_AT,

Is it really AT protocol here? wouldn't it be possible to expose it
via the existing GNSS susbsystem?

Regards,
Looic
