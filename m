Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C561E6BD56E
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 17:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjCPQWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 12:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCPQWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 12:22:12 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F6D619B;
        Thu, 16 Mar 2023 09:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678983731; x=1710519731;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iImao4I7FTxTgDMyeHkCyoDdECSP8/GLuTLheEeH1Rc=;
  b=HCZIGs56BH/xIELvhCYXrzO/aATxC3qEmKgOvNwyXsc73IED84zO3DOj
   Su9h5kwpj/Cimc/fVi0ZecfkX3B5eiBvD9yIx29jK703uIi6o0+XzUZ2v
   abBJnP8DCXVROoJH1d15eKi4Kps/1+SmaBUz850hFcQberpBBUceL2wla
   Kxzo/CTA/eW3YPZVCSiSIbunnTd0H8ScgeWGkTQpGGzCD/7yNq9NqDWrS
   o6qlnbogRNbkQqZaUUdj0aokBRMtDsSWNCh3khgu5XsrA/tvqu5L707bw
   gImcvKRcaNgn5rPJnSRp1c6dRuNRo5bNEvUP+0ncf/nCa8oN1D70ueiES
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,265,1673938800"; 
   d="scan'208";a="202008008"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Mar 2023 09:22:11 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 09:22:10 -0700
Received: from [10.171.246.59] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 16 Mar 2023 09:22:08 -0700
Message-ID: <ae8e8b61-b00a-1ec1-8212-7194c5ae4b30@microchip.com>
Date:   Thu, 16 Mar 2023 17:22:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next] net: macb: Increase halt timeout to accommodate
 10Mbps link
Content-Language: en-US
To:     Harini Katakam <harini.katakam@amd.com>, <davem@davemloft.net>,
        <claudiu.beznea@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@amd.com>, <harinikatakamlinux@gmail.com>
References: <20230316083050.2108-1-harini.katakam@amd.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
In-Reply-To: <20230316083050.2108-1-harini.katakam@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/03/2023 at 09:30, Harini Katakam wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> From: Harini Katakam <harini.katakam@xilinx.com>
> 
> Increase halt timeout to accommodate for 16K SRAM at 10Mbps rounded.
> 
> Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

Fine with me:
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Best regards,
   Nicolas

> ---
>   drivers/net/ethernet/cadence/macb_main.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 51c9fd6f68a4..96fd2aa9ee90 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -94,8 +94,7 @@ struct sifive_fu540_macb_mgmt {
>   /* Graceful stop timeouts in us. We should allow up to
>    * 1 frame time (10 Mbits/s, full-duplex, ignoring collisions)
>    */
> -#define MACB_HALT_TIMEOUT      1230
> -
> +#define MACB_HALT_TIMEOUT      14000
>   #define MACB_PM_TIMEOUT  100 /* ms */
> 
>   #define MACB_MDIO_TIMEOUT      1000000 /* in usecs */
> --
> 2.17.1
> 

-- 
Nicolas Ferre

