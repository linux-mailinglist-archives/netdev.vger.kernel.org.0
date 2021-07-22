Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4E83D2E7A
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 22:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbhGVUO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 16:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbhGVUOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 16:14:38 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B83C061389;
        Thu, 22 Jul 2021 13:54:03 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id m16so10494151lfg.13;
        Thu, 22 Jul 2021 13:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pbh/CQb2PiIrUcgbLx8/JBOtgKdjS9UoSA27WAOPs/0=;
        b=KEOEEuiQX1cSdQyCB198KYTz8rFJXRF8IEOZDp9ej0LDHIr1/BdK+m08lMNqwgkzeZ
         B8aVbSu7c0+0slJDLOJTH/uusay1g4ofQBEUN+0kcifCALwG7is073MLDTkEB4HpMPzI
         zZkDWwa+XV/G3lLhd8R97FYBDlB7MtQgkYWIHUM+X1/LpQyB4emE9PIFFb5dSk1iWo9F
         FkiNXF9LYgzypKV0hS73PuvejKb9TabhidELIK7YdgEjSpC5tHJ+nSu/fVQmqueLJemX
         w2TZ5KnTgE7PQw2X8Azjpts92mtoJWZki+nNcTrfYLRxbPvJXZqHsYGRDsgpIksL7RAc
         37PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pbh/CQb2PiIrUcgbLx8/JBOtgKdjS9UoSA27WAOPs/0=;
        b=qelEMLJESEUiA/mEro9iQrLtZPkJUw9iqIwRP67qAbbjd8YqixKaLcpfurjsJ/13M5
         fjpGQur/DVP6dQBjicRqW1A80jV3pTIafLZItY8FDQAWyzbsqori28aCdy6mGB7bTnp3
         ZCsDVa1PAXs0bSnz+Ggaq62XdVbX5gM8eaMP+IFCzr0iEE+SEZ0tNfocJ0ffTqPFYw/g
         QDsSquM958SnPSsgqjT6y/leOJ5VRXoCwGuTk1fhB3GPEzUeZNuYMG/Bkaz10QE8uxY+
         cmfCIUB2D+JCVSzuJxxPmNRqSXtyEEX/JdSxEn+7cERrvA/9E09DtbhVGZ0U/l+TTUIG
         rWQw==
X-Gm-Message-State: AOAM531LezyAzN0SKBUifj2/6Ys6SRwX0QWY8QnY+H7g6VXReF4bq0Rg
        3zze562a6KDymBdlIM3oQII=
X-Google-Smtp-Source: ABdhPJwOpxaaBDmcH39ZAXRkIuVLhHCstAIiEDCDfVWy+hjkjlV+YWR2JXfbXf85gwgTQ/fu0yg2Hg==
X-Received: by 2002:a05:6512:98a:: with SMTP id w10mr845492lft.76.1626987242339;
        Thu, 22 Jul 2021 13:54:02 -0700 (PDT)
Received: from [192.168.1.102] ([31.173.84.209])
        by smtp.gmail.com with ESMTPSA id z13sm1586708lfd.49.2021.07.22.13.54.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 13:54:02 -0700 (PDT)
Subject: Re: [PATCH net-next 00/18] Add Gigabit Ethernet driver support
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <b295ec23-f8b2-0432-83e6-16078754e5e3@gmail.com>
Date:   Thu, 22 Jul 2021 23:53:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/21 5:13 PM, Biju Das wrote:

> The DMAC and EMAC blocks of Gigabit Ethernet IP is almost similar to Ethernet AVB.
> 
> The Gigabit Etherner IP consists of Ethernet controller (E-MAC), Internal TCP/IP Offload Engine (TOE) and Dedicated Direct memory access controller (DMAC).
> 
> With few changes in driver, we can support Gigabit ethernet driver as well.
> 
> This patch series is aims to support the same
> 
> RFC->V1
>   * Incorporated feedback from Andrew, Sergei, Geert and Prabhakar
>   * https://patchwork.kernel.org/project/linux-renesas-soc/list/?series=515525
> 
> Biju Das (18):
>   dt-bindings: net: renesas,etheravb: Document Gigabit Ethernet IP
>   drivers: clk: renesas: rzg2l-cpg: Add support to handle MUX clocks
>   drivers: clk: renesas: r9a07g044-cpg: Add ethernet clock sources
>   drivers: clk: renesas: r9a07g044-cpg: Add GbEthernet clock/reset


   It's not a good idea to have the patch to the defferent subsystems lumped
all together in a single series...

>   ravb: Replace chip type with a structure for driver data

   I was expecting some real changes on how the gen2/3 diff. features in this patch,
but I only saw new info having no real changes where they were needed and having the
changes that did not need to be converted yet...
   Anwyay, I have stopped here for today.

>   ravb: Factorise ptp feature
>   ravb: Add features specific to R-Car Gen3
>   ravb: Add R-Car common features
>   ravb: Factorise ravb_ring_free function
>   ravb: Factorise ravb_ring_format function
>   ravb: Factorise ravb_ring_init function
>   ravb: Factorise {emac,dmac} init function
>   ravb: Factorise ravb_rx function
>   ravb: Factorise ravb_adjust_link function
>   ravb: Factorise ravb_set_features
>   ravb: Add reset support
>   ravb: Add GbEthernet driver support
>   arm64: dts: renesas: r9a07g044: Add GbEther nodes
> 
[...]

MBR, Sergei
