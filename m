Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7CD51FFDC
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237250AbiEIOfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237264AbiEIOfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:35:43 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE065213339
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 07:31:42 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 4so17266363ljw.11
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 07:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qgqai7f9lS7Suf9yllivg2gEv4Ncv7OAyyOiWFDdECA=;
        b=FXUtX9olu2gnzr5+poKYzCqa1xf+HtK7HT8GWzxXNTZQQ0b3ARcqDZJOQYAhIcDYa6
         tSNK0mszQInhPge7jIBsKqDPKonFCgRNMxkXfYEHDFoxV3TZu1FNqoNEAFH3IsWuI1ud
         K/E2cFscnCJ29CYpu0trerQ4nGSpuN5A8OxYO4vooZzADOldblqrHTiG3VaHEuQmMNi4
         a+VakUC9OX1hu6YUAYQtXlXLD4lkvnQzB1503B7FMHfLgLYL7B2YWYlW3nyDXcZklTL1
         gyA4FQeQODZjQOKEnFxMKw2MMf+tgrFYKrcYlPV7M0fahH3fk/uVoG5VCw7Vo1Yk+WPJ
         BIYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qgqai7f9lS7Suf9yllivg2gEv4Ncv7OAyyOiWFDdECA=;
        b=Inz6Fuxh9hUc0Msix7y8UXZSEesdoI2/enBRrXRZreSQt3r9j32NjFeBysBR3pSuyv
         lJUc8wp5tH2nskJAO0niY4plZdS4giGn0MEp7/R6xkfnZ96aP921t2qhhoyFVyxBAHC1
         uHr2enIskDdUlpngoelO9aVA2sP8vy71oO6zUFpzjllBJYmtTqh3dbhclXbXuRh7Rz96
         Oy4JsgTqaO6+MCA9buE3r2uTPW0xEzv8OIH0iArLpAaWtuS0pVSfS/QkXPQ2qpuASR7G
         FwFWuLr5MI0xJTwGunk9Gza3snCsxRa0aCxHEi4kBZbDOJ2xu64muztToGU8rrSegZH0
         XZ9Q==
X-Gm-Message-State: AOAM533BZNT1S3muF2VMO6MZfIH+zMkXpItCYjQcRKSjP5Wo8asx3Tdh
        FtkwU+x0ar+VxO1QJxBCcMOpjVBXW29fMVIQy6N2Kw==
X-Google-Smtp-Source: ABdhPJxqNtTSR5nUh0j/WBFU0R3eaENvnpD4iIqG+qWiuhvFJCsrpYSaREgd8um7eiuFAM8z3dXvXyDW12lIggdNIoU=
X-Received: by 2002:a2e:9581:0:b0:24f:2dc9:6275 with SMTP id
 w1-20020a2e9581000000b0024f2dc96275mr10284304ljh.486.1652106700628; Mon, 09
 May 2022 07:31:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220506025134.794537-1-kuba@kernel.org> <20220506025134.794537-4-kuba@kernel.org>
In-Reply-To: <20220506025134.794537-4-kuba@kernel.org>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Mon, 9 May 2022 16:31:28 +0200
Message-ID: <CAPv3WKehhJgOFJRiGSsEb3FeOkm3iBSbSO-N39z8+n=7PWtxHA@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4] net: make drivers set the TSO limit not the
 GSO limit
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, pabeni@redhat.com,
        alexander.duyck@gmail.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        chris.snook@gmail.com, dchickles@marvell.com, sburla@marvell.com,
        fmanlunas@marvell.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        qiangqing.zhang@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        gakula@marvell.com, sbhatta@marvell.com, hkelam@marvell.com,
        simon.horman@corigine.com, Heiner Kallweit <hkallweit1@gmail.com>,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, woojung.huh@microchip.com,
        wintera@linux.ibm.com, roopa@nvidia.com, razor@blackwall.org,
        cai.huoqing@linux.dev, fei.qin@corigine.com,
        niklas.soderlund@corigine.com, yinjun.zhang@corigine.com,
        marcinguy@gmail.com, jesionowskigreg@gmail.com, jannh@google.com,
        hayeswang@realtek.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HI,

[snip]

> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index f6a54c7f0c69..384f5a16753d 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -5617,7 +5617,7 @@ static int mvneta_probe(struct platform_device *pdev)
>         dev->hw_features |= dev->features;
>         dev->vlan_features |= dev->features;
>         dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
> -       netif_set_gso_max_segs(dev, MVNETA_MAX_TSO_SEGS);
> +       netif_set_tso_max_segs(dev, MVNETA_MAX_TSO_SEGS);
>
>         /* MTU range: 68 - 9676 */
>         dev->min_mtu = ETH_MIN_MTU;
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 1a835b48791b..2b7eade373be 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -6861,7 +6861,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
>                 mvpp2_set_hw_csum(port, port->pool_long->id);
>
>         dev->vlan_features |= features;
> -       netif_set_gso_max_segs(dev, MVPP2_MAX_TSO_SEGS);
> +       netif_set_tso_max_segs(dev, MVPP2_MAX_TSO_SEGS);
>         dev->priv_flags |= IFF_UNICAST_FLT;
>

For mvpp2:
Reviewed-by: Marcin Wojtas <mw@semihalf.com>

Thanks,
Marcin

[snip]
