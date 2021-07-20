Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E933CFA38
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237186AbhGTMcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 08:32:09 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:59554 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234665AbhGTMbz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 08:31:55 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9A1F049E66;
        Tue, 20 Jul 2021 13:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-transfer-encoding:mime-version:user-agent:content-type
        :content-type:organization:references:in-reply-to:date:date:from
        :from:subject:subject:message-id:received:received:received; s=
        mta-01; t=1626786733; x=1628601134; bh=LuLCNzNGfwt8kUnjnEU2g04t0
        RI3nJrdJh13nMXTK8A=; b=ksN3YhX+Fg/zsZANJD6UiHWdKmjSTDlGAtQ1dP0L7
        XIdazaxIRVXB9IZscT2IzpjYCmzlkzRi7z1JEgo6pWS3ukKCkII9+TWs/lvGN8+h
        Slo1iNCgYOP6BnV/6P3vfynPyoCnZ7AmR3An2VabO5s2iqqmx6ElXWBglVmM95+V
        UY=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DrbFyumWL7I5; Tue, 20 Jul 2021 16:12:13 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id D81FA49E35;
        Tue, 20 Jul 2021 16:12:09 +0300 (MSK)
Received: from [10.199.0.81] (10.199.0.81) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 20
 Jul 2021 16:12:09 +0300
Message-ID: <b1da28a76c249637d6f094b046d851c7622e71d4.camel@yadro.com>
Subject: Re: [PATCH v2 3/3] net/ncsi: add dummy response handler for Intel
 boards
From:   Ivan Mikhaylov <i.mikhaylov@yadro.com>
To:     Paul Fertser <fercerpav@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "Joel Stanley" <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <openbmc@lists.ozlabs.org>
Date:   Tue, 20 Jul 2021 16:21:31 +0300
In-Reply-To: <20210720094113.GA4789@home.paul.comp>
References: <20210708122754.555846-1-i.mikhaylov@yadro.com>
         <20210708122754.555846-4-i.mikhaylov@yadro.com>
         <20210720094113.GA4789@home.paul.comp>
Organization: YADRO
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.199.0.81]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-07-20 at 12:41 +0300, Paul Fertser wrote:
> Hello,
> 
> On Thu, Jul 08, 2021 at 03:27:54PM +0300, Ivan Mikhaylov wrote:
> > Add the dummy response handler for Intel boards to prevent incorrect
> > handling of OEM commands.
> 
> It would be much nicer if it wasn't dummy but provide means of
> obtaining the MAC properly, in a similar way to the other supported
> network cards.
> 
> I have a patch I can share but not ready to send for proper mainlining
> due to time constraints. Feel free to take it over and send as part of
> your patch series.
> 
> From 6c717bbb75442c83bd11b37b7644f9ce187ee7e9 Mon Sep 17 00:00:00 2001
> From: Brad Ho <Brad_Ho@phoenix.com>
> Date: Thu, 25 Feb 2021 00:53:03 -0800
> Subject: [PATCH] Add get MAC address through NCSI command to get INTEL i210
>  MAC address
> 
> Signed-off-by: Brad Ho <Brad_Ho@phoenix.com>
> Signed-off-by: Paul Fertser <fercerpav@gmail.com>
> ---
>  net/ncsi/internal.h    |  5 ++++
>  net/ncsi/ncsi-manage.c | 25 ++++++++++++++++-
>  net/ncsi/ncsi-pkt.h    |  6 ++++
>  net/ncsi/ncsi-rsp.c    | 62 +++++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 96 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
> index e37102546be6..8a6a8127156b 100644
> --- a/net/ncsi/internal.h
> +++ b/net/ncsi/internal.h
> @@ -78,6 +78,7 @@ enum {
>  /* OEM Vendor Manufacture ID */
>  #define NCSI_OEM_MFR_MLX_ID             0x8119
>  #define NCSI_OEM_MFR_BCM_ID             0x113d
> +#define NCSI_OEM_MFR_INTEL_ID           0x0157
>  /* Broadcom specific OEM Command */
>  #define NCSI_OEM_BCM_CMD_GMA            0x01   /* CMD ID for Get MAC */
>  /* Mellanox specific OEM Command */
> @@ -85,16 +86,20 @@ enum {
>  #define NCSI_OEM_MLX_CMD_GMA_PARAM      0x1b   /* Parameter for GMA  */
>  #define NCSI_OEM_MLX_CMD_SMAF           0x01   /* CMD ID for Set MC Affinity
> */
>  #define NCSI_OEM_MLX_CMD_SMAF_PARAM     0x07   /* Parameter for SMAF        
> */
> +/* Intel specific OEM Command */
> +#define NCSI_OEM_INTEL_CMD_GMA          0x06   /* CMD ID for Get MAC */
>  /* OEM Command payload lengths*/
>  #define NCSI_OEM_BCM_CMD_GMA_LEN        12
>  #define NCSI_OEM_MLX_CMD_GMA_LEN        8
>  #define NCSI_OEM_MLX_CMD_SMAF_LEN        60
> +#define NCSI_OEM_INTEL_CMD_GMA_LEN      5
>  /* Offset in OEM request */
>  #define MLX_SMAF_MAC_ADDR_OFFSET         8     /* Offset for MAC in SMAF   
> */
>  #define MLX_SMAF_MED_SUPPORT_OFFSET      14    /* Offset for medium in SMAF
> */
>  /* Mac address offset in OEM response */
>  #define BCM_MAC_ADDR_OFFSET             28
>  #define MLX_MAC_ADDR_OFFSET             8
> +#define INTEL_MAC_ADDR_OFFSET           1
>  
>  
>  struct ncsi_channel_version {
> diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
> index 1f387be7827b..fb25ae22ea3d 100644
> --- a/net/ncsi/ncsi-manage.c
> +++ b/net/ncsi/ncsi-manage.c
> @@ -760,13 +760,36 @@ static int ncsi_oem_smaf_mlx(struct ncsi_cmd_arg *nca)
>         return ret;
>  }
>  
> +static int ncsi_oem_gma_handler_intel(struct ncsi_cmd_arg *nca)
> +{
> +       unsigned char data[NCSI_OEM_INTEL_CMD_GMA_LEN];
> +       int ret = 0;
> +
> +       nca->payload = NCSI_OEM_INTEL_CMD_GMA_LEN;
> +
> +       memset(data, 0, NCSI_OEM_INTEL_CMD_GMA_LEN);
> +       *(unsigned int *)data = ntohl(NCSI_OEM_MFR_INTEL_ID);
> +       data[4] = NCSI_OEM_INTEL_CMD_GMA;
> +
> +       nca->data = data;
> +
> +       ret = ncsi_xmit_cmd(nca);
> +       if (ret)
> +               netdev_err(nca->ndp->ndev.dev,
> +                          "NCSI: Failed to transmit cmd 0x%x during
> configure\n",
> +                          nca->type);
> +
> +       return ret;
> +}
> +
>  /* OEM Command handlers initialization */
>  static struct ncsi_oem_gma_handler {
>         unsigned int    mfr_id;
>         int             (*handler)(struct ncsi_cmd_arg *nca);
>  } ncsi_oem_gma_handlers[] = {
>         { NCSI_OEM_MFR_BCM_ID, ncsi_oem_gma_handler_bcm },
> -       { NCSI_OEM_MFR_MLX_ID, ncsi_oem_gma_handler_mlx }
> +       { NCSI_OEM_MFR_MLX_ID, ncsi_oem_gma_handler_mlx },
> +       { NCSI_OEM_MFR_INTEL_ID, ncsi_oem_gma_handler_intel }
>  };
>  
>  static int ncsi_gma_handler(struct ncsi_cmd_arg *nca, unsigned int mf_id)
> diff --git a/net/ncsi/ncsi-pkt.h b/net/ncsi/ncsi-pkt.h
> index 80938b338fee..ba66c7dc3a21 100644
> --- a/net/ncsi/ncsi-pkt.h
> +++ b/net/ncsi/ncsi-pkt.h
> @@ -178,6 +178,12 @@ struct ncsi_rsp_oem_bcm_pkt {
>         unsigned char           data[];      /* Cmd specific Data */
>  };
>  
> +/* Intel Response Data */
> +struct ncsi_rsp_oem_intel_pkt {
> +       unsigned char           cmd;         /* OEM Command ID    */
> +       unsigned char           data[];      /* Cmd specific Data */
> +};
> +
>  /* Get Link Status */
>  struct ncsi_rsp_gls_pkt {
>         struct ncsi_rsp_pkt_hdr rsp;        /* Response header   */
> diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
> index a94bb59793f0..b36c22ec4c3f 100644
> --- a/net/ncsi/ncsi-rsp.c
> +++ b/net/ncsi/ncsi-rsp.c
> @@ -699,12 +699,72 @@ static int ncsi_rsp_handler_oem_bcm(struct ncsi_request
> *nr)
>         return 0;
>  }
>  
> +/* Response handler for Intel command Get Mac Address */
> +static int ncsi_rsp_handler_oem_intel_gma(struct ncsi_request *nr)
> +{
> +       struct ncsi_dev_priv *ndp = nr->ndp;
> +       struct net_device *ndev = ndp->ndev.dev;
> +       const struct net_device_ops *ops = ndev->netdev_ops;
> +       struct ncsi_rsp_oem_pkt *rsp;
> +       struct sockaddr saddr;
> +       int ret = 0;
> +
> +       /* Get the response header */
> +       rsp = (struct ncsi_rsp_oem_pkt *)skb_network_header(nr->rsp);
> +
> +       saddr.sa_family = ndev->type;
> +       ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
> +       memcpy(saddr.sa_data, &rsp->data[INTEL_MAC_ADDR_OFFSET], ETH_ALEN);
> +       /* Increase mac address by 1 for BMC's address */
> +       eth_addr_inc((u8 *)saddr.sa_data);
> +       if (!is_valid_ether_addr((const u8 *)saddr.sa_data))
> +               return -ENXIO;
> +
> +       /* Set the flag for GMA command which should only be called once */
> +       ndp->gma_flag = 1;
> +
> +       ret = ops->ndo_set_mac_address(ndev, &saddr);
> +       if (ret < 0)
> +               netdev_warn(ndev, "NCSI: 'Writing mac address to device
> failed\n");
> +
> +       return ret;
> +}
> +
> +/* Response handler for Intel card */
> +static int ncsi_rsp_handler_oem_intel(struct ncsi_request *nr)
> +{
> +       struct ncsi_rsp_oem_intel_pkt *intel;
> +       struct ncsi_rsp_oem_pkt *rsp;
> +
> +       /* Get the response header */
> +       rsp = (struct ncsi_rsp_oem_pkt *)skb_network_header(nr->rsp);
> +       intel = (struct ncsi_rsp_oem_intel_pkt *)(rsp->data);
> +
> +#if 0 //For debug use
> +    #define NCSI_INTEL_GMA_LEN 6
> +    int i = 0;
> +
> +    printk("[Error] %s, %d, intel->cmd = %x\n", __func__, __LINE__, intel-
> >cmd);
> +    for(i ; i < NCSI_INTEL_GMA_LEN; i++)
> +    {
> +        printk("[Error] %s, %d, rsp->data[%d] = %x\n", __func__, __LINE__, i,
> rsp->data[i]);
> +        printk("[Error] %s, %d, intel_rsp->data[%d] = %x\n", __func__,
> __LINE__, i, intel->data[i]);
> +    }
> +#endif
> +    
> +       if (intel->cmd == NCSI_OEM_INTEL_CMD_GMA)
> +               return ncsi_rsp_handler_oem_intel_gma(nr);
> +
> +       return 0;
> +}
> +
>  static struct ncsi_rsp_oem_handler {
>         unsigned int    mfr_id;
>         int             (*handler)(struct ncsi_request *nr);
>  } ncsi_rsp_oem_handlers[] = {
>         { NCSI_OEM_MFR_MLX_ID, ncsi_rsp_handler_oem_mlx },
> -       { NCSI_OEM_MFR_BCM_ID, ncsi_rsp_handler_oem_bcm }
> +       { NCSI_OEM_MFR_BCM_ID, ncsi_rsp_handler_oem_bcm },
> +       { NCSI_OEM_MFR_INTEL_ID, ncsi_rsp_handler_oem_intel }
>  };
>  
>  /* Response handler for OEM command */
> 

Paul, I know about 'get mac address' and it was in my todo list. You can put it
before or after this patch series whenever you want, it doesn't interfere with
this one. Anyways, thanks for sharing it.

Thanks.

