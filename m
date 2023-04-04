Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE726D66F2
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 17:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbjDDPPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 11:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbjDDPPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 11:15:08 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2134.outbound.protection.outlook.com [40.107.220.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3059A4699;
        Tue,  4 Apr 2023 08:15:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DKdTYMxa5CtFFHbgO8kjHxmRM0KpnJhi2F4pW54igxv2RF38+esFRpC8yyxyHdLyTLw4F3LCIBzm7k1X0j3Cg+JY2ihGbN7MqGjd5V3+IZGuokDwNrTR8xB+yA5ehuxszFOHvl0gBU+yZ2VyzM5mcu8FZ/tBHEtva5hEKdbTpBoCecs3smqWpFlIB0K8KV313szaa12HgT0U0mPFEaNCMiywBR0SNdQhydmZ1hDP0xhDoXh2ivd/F/bEo+8YqRdo+bmP9yF62Mm7H/tMRNg2zkuUMtukQkDo/A8uOddDZ/lkdfrRHCADqUJfg3RlQdaSVOwxzmt6nLar7Gxamax63w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hmLAwow4v66wXrl5E7YSdlzoyOYho1/4K9qPWLh8RS4=;
 b=SLbZ80qToRml2VLhzsVmsk0WFDA2EtGEeDowOB1pZ4j80W+IyBKqynV1O3oy2p9gm6BBMPNSPzaqyBugJasy1DQqHLfoRQzRebjmeq9XmYhFYyRxQrptzmwTzDgNx5/S+8zIiYjyUtIT/K0IAsoLFPcSyMlAplJeR0uenoYyEkX24/wnmwEMJjjzjdYU1qzfuxT6rakwqRzJuFCvwcSlsW9oOZjdy9wLz+ggDome9NLDbrp6BqLlIimcDl4+owjiGVSsPRdm+As010bLkMwbcdccePreUiXUZOqk0emFuLY1HXvJrUGm7X6N+tdyjR7v9hK3Av9TQeqnN4ObPuKMKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hmLAwow4v66wXrl5E7YSdlzoyOYho1/4K9qPWLh8RS4=;
 b=nmhOLhBPU9dGxhycikeNyL5cofKdofqWHTvmr0763T5XqTsPGldLQn15F9jk/LfVPUr2B0toXtWqjfzkA+m/2tywzusqDnjTi41Rr53/a2cH4VND2ii+arxkW2eOxBCene+38sdMnLzuon9XvNFoXAwuPbjQ+StpgSYJVOJMSqo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4717.namprd13.prod.outlook.com (2603:10b6:5:38c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Tue, 4 Apr
 2023 15:14:56 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 15:14:56 +0000
Date:   Tue, 4 Apr 2023 17:14:49 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Morgan <macroalpha82@gmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
Subject: Re: [PATCH v4 2/9] wifi: rtw88: sdio: Add HCI implementation for
 SDIO based chipsets
Message-ID: <ZCw+6QC230iydL9A@corigine.com>
References: <20230403202440.276757-1-martin.blumenstingl@googlemail.com>
 <20230403202440.276757-3-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403202440.276757-3-martin.blumenstingl@googlemail.com>
X-ClientProxiedBy: AM9P250CA0004.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4717:EE_
X-MS-Office365-Filtering-Correlation-Id: 39840a2b-367a-4234-ff22-08db351f5962
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sYCy/h2a/43dBDHWgcPu6ccezjksc7W46xGOQ9izifVW8oxOJqnN7b2nPX1EkvcmSzPXhXrzPY5a92Z7pt+qTKmb0qp8VeetzMcIZKLPhl9SfoChWl+l6nLAKYsgF1oY0ZSI/WeJDSVj5qdQP9L97hCWI6shWQmP8bA/F20WnELQ+N/AqtEZDt/efxAPxY60vUD0n8STupL4qYtosQj6r4hJKjC+Tkir+yCoiVD/5xsmsDEB6Mb9+P6cKT2+fSmH5yrv4LbSp9VdB0KEoBCYu+eomuaDZlQFJO2v/WAzEPLUbz2+DN5AJdcSK0J/pnl+gjVFTbzFfiIyOPkh5j0+I8nsn5eW3FO4rdNG1eyR7ESGJ/6meaiX5XXXJW65NSMRWtfaaRhE8QQWlOuTV1OfD++w/Sjp/kW8VHHha/F2zcB2Xv/Qx8QTIAHg8guft43U8wR8LIQsXuiBLbhCTO2QCbfsyM22977UGnszQ1y0XkjMcLWlFzqmQrySFeOD1NVUZ5b6CQ/HiCng0mfWPlB17YTHYpLdvcdMaT0wLViGqPPR3SN8lUGaEI0meDnZzt+vxX/C3Scbr2LtMnpUm3ehRjYrWI0GcR6A40IMEBN7uocKCJAk0Bt7LdoyT7znx/+0tCJwSObgzUPzXbZ7ofUP546tpCO7nQ6pJLleaOjx9JA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(376002)(39830400003)(396003)(346002)(451199021)(2906002)(8936002)(8676002)(41300700001)(7416002)(44832011)(38100700002)(5660300002)(36756003)(6486002)(86362001)(54906003)(6666004)(6506007)(83380400001)(478600001)(2616005)(4326008)(6512007)(186003)(6916009)(66476007)(66946007)(66556008)(316002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fk0h0V/2uvtIPGtYYbGYc5Jw2y5UwgNaatXhnzpTfdLTv5odY+/HIY04O7/A?=
 =?us-ascii?Q?fCIZkTD3+MwTV8CzK1ZMUh+B32Efdr1wyN4BJf5vEbl3HQLqC1es1ht90M0L?=
 =?us-ascii?Q?b+xH0+QinRsBCja2EJXItKPikxa/IcDhQNyNxs8kpmkOk4joPs54bR3N3Afq?=
 =?us-ascii?Q?8u00Kej0imEbH3DPiAZSZhmA3VtZmD0LgIGLdbRLksqdtbH5+nb+OGoaIEWw?=
 =?us-ascii?Q?x0sY1fj0EaWintANLhXTQIHyJFPl/AaWqPGr9D7vtTGXJygfZ4bTfZKgbj7q?=
 =?us-ascii?Q?g6SZ2kL5dKptwN2V0uNIxA979bu12gsnxaHCZHWBkoIo2OAmOAqc+Lvijg7v?=
 =?us-ascii?Q?cICQv6W87Lzy1JLQzpw1teMiiSLQ475sFe00YvFRqsLYPFd38Bzheup3THcn?=
 =?us-ascii?Q?4WvhIl9BRvmiR/QzMyRj7K0yt/muaB+f/wTUNpezzncxG26VCOSAFehkiHor?=
 =?us-ascii?Q?GOWlrdN9gQWx+2zDAJuLMcSnuvHEaq/ktuR2QT314UO22E1QB4NpWRmIURQC?=
 =?us-ascii?Q?w+Zber8zV6yy2fzmb1UQzmoVvw4URAbs6UF839MduDxTURpOb9IZ/ScFll1l?=
 =?us-ascii?Q?Z7cWOPu6/nU2ilJ2TDqO2cx3yZ1EiIA8C6o+JXQHOXqDMII4fb7TNJNbXvCd?=
 =?us-ascii?Q?+ctxjI7VinYA5eIAfocjiDBORXtV2zS6EcLHskSwBZ6q9LmehqrWutayXpbe?=
 =?us-ascii?Q?u3EJHPoy6e4j7dn5TmdaRoGzrzPAMVnByQdomNi6u3BoRtRZuitv1KJZxIan?=
 =?us-ascii?Q?RciMuGc1deGa/xHDHxs8tGCJtcOBteN6ntD5g/KHRbOMfsyCxtSxcLtEEjPN?=
 =?us-ascii?Q?7mSp/jCBISIaqXfAKId3G2M3Yoc7YG/d6KrBDf3F3bcBhhk6DPngPn6E7KXz?=
 =?us-ascii?Q?Iw8TMBqHDsb4/u+hAsfpBksO5sq/GbtP4ZXnq56JvEpREIx8aMsobz1Zapen?=
 =?us-ascii?Q?GvXScDjfOLX7LAhaMIWrshNKtwcN370S3rEBEBWjbTKlwST2vMDRxG+fBUNF?=
 =?us-ascii?Q?MBnwsBK0w9bA5jxQH/9JxgvCbjKjEvwrD1LRt/zCIvPWqtN0Q/G1hAH094pC?=
 =?us-ascii?Q?/ddcI28j3tesdn7bA7o54mtV9aj0OFpAyaqHC3pq5b8wzKJXQlgKwLUdUUsR?=
 =?us-ascii?Q?9zAh84/G49P8mec6RCm7/NKqxq4o6DEuBr/M1zjwSaz63SduNnxCas6aGhPR?=
 =?us-ascii?Q?2ciRbYq0XrzUOZ4Fm3+BFPe3BrD3hxQvh4I9QTMLN9QbgAX9WGijT8l2Gc7d?=
 =?us-ascii?Q?HjU596QuIO7c77pSqglSUnG9deDJ/mttAwteUMSFs1PvWkWgwBiY2i47JaW6?=
 =?us-ascii?Q?Vk8iV7yzoLYHm/J7EpdC9NJbiGMZ4UH6UOUSfU6f102uHINvocEVFTwO2M+P?=
 =?us-ascii?Q?H53JJSBwYs4+wiZ1MT4eU5JQNcHKxgCQZTb1y0zRw08s7fRJ75xOYpjUjAuf?=
 =?us-ascii?Q?PJxLUZBQQOy64IFVysV1lpLZ12q76yqlzzyXH4Lne8tEQp8Nnf7oO4oRMiWc?=
 =?us-ascii?Q?GvoM/7EmjWYdNBTZUbi+S6Tm6YuSH1upZcF37nKfRlco4rFunrUMfG624bQ7?=
 =?us-ascii?Q?CX3hnHCCaIokZeaTfXEiYGZFfXxsdAf2ThqiCb4754LkB1K737a/AmFkp865?=
 =?us-ascii?Q?3SW8eoCGBiTwj8JO8s8C+3NjlRT55h3tATMS/fxGaAV2wPbhKDhSZwpHt/FR?=
 =?us-ascii?Q?rR0rDA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39840a2b-367a-4234-ff22-08db351f5962
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 15:14:56.5049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SOZsvlWr9qFQirKvPk4U66cchm8b5B9q7ve8isFTQzdFAEeEKum3av1y8themav4iFRWs/nMfEWWnixe+8Nd6vj76Ah5kMjzBGu9QhA5cfs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4717
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 10:24:33PM +0200, Martin Blumenstingl wrote:
> Add a sub-driver for SDIO based chipsets which implements the following
> functionality:
> - register accessors for 8, 16 and 32 bits for all states of the card
>   (including usage of 4x 8 bit access for one 32 bit buffer if the card
>   is not fully powered on yet - or if it's fully powered on then 1x 32
>   bit access is used)
> - checking whether there's space in the TX FIFO queue to transmit data
> - transfers from the host to the device for actual network traffic,
>   reserved pages (for firmware download) and H2C (host-to-card)
>   transfers
> - receiving data from the device
> - deep power saving state
> 
> The transmit path is optimized so DMA-capable SDIO host controllers can
> directly use the buffers provided because the buffer's physical
> addresses are 8 byte aligned.
> 
> The receive path is prepared to support RX aggregation where the
> chipset combines multiple MAC frames into one bigger buffer to reduce
> SDIO transfer overhead.
> 
> Co-developed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
> Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
> Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Hi Martin,

some minor nits from my side that you may wish to consider
if you need to respin the series for some other reason.

> diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
> new file mode 100644
> index 000000000000..038e209e6107
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/sdio.c
> @@ -0,0 +1,1387 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +/* Copyright (C) 2021 Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> + * Copyright (C) 2021 Jernej Skrabec <jernej.skrabec@gmail.com>
> + *
> + * Based on rtw88/pci.c:
> + *   Copyright(c) 2018-2019  Realtek Corporation
> + */
> +
> +#include <linux/module.h>
> +#include <linux/mmc/host.h>
> +#include <linux/mmc/sdio_func.h>
> +#include "main.h"
> +#include "debug.h"
> +#include "fw.h"
> +#include "ps.h"
> +#include "reg.h"
> +#include "rx.h"
> +#include "sdio.h"
> +#include "tx.h"
> +
> +#define RTW_SDIO_INDIRECT_RW_RETRIES			50
> +
> +static bool rtw_sdio_is_bus_addr(u32 addr)
> +{
> +	return (addr & RTW_SDIO_BUS_MSK) != 0;
> +}

nit: this could be.

	return !!(addr & RTW_SDIO_BUS_MSK)

...

> +static void rtw_sdio_handle_interrupt(struct sdio_func *sdio_func)
> +{
> +	struct ieee80211_hw *hw = sdio_get_drvdata(sdio_func);
> +	struct rtw_dev *rtwdev = hw->priv;
> +	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
> +	u32 hisr;

nit: reverse xmas tree - longest line to shortest - for local variable
     declarations.

     So I guess (*completely untested*):

	struct ieee80211_hw *hw = sdio_get_drvdata(sdio_func);
	struct rtw_dev *rtwdev = hw->priv;
	struct rtw_sdio *rtwsdio;
	u32 hisr;

	rtwsdio = (struct rtw_sdio *)rtwdev->priv;

...

> +static void rtw_sdio_tx_handler(struct work_struct *work)
> +{
> +	struct rtw_sdio_work_data *work_data =
> +		container_of(work, struct rtw_sdio_work_data, work);
> +	struct rtw_dev *rtwdev = work_data->rtwdev;
> +	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
> +	int limit, queue;

Reverse xmas tree again.

...

> +void rtw_sdio_shutdown(struct device *dev)
> +{
> +	struct sdio_func *sdio_func = dev_to_sdio_func(dev);
> +	struct ieee80211_hw *hw = sdio_get_drvdata(sdio_func);
> +	const struct rtw_chip_info *chip;
> +	struct rtw_dev *rtwdev;

Ditto.

...

> diff --git a/drivers/net/wireless/realtek/rtw88/sdio.h b/drivers/net/wireless/realtek/rtw88/sdio.h

...

> +/* Free Tx Page Sequence */
> +#define REG_SDIO_FREE_TXPG_SEQ			(SDIO_LOCAL_OFFSET + 0x0028)
> +/* HTSF Informaion */

nit: s/Informaion/Information/

...
