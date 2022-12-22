Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7FF7653E92
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 11:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235274AbiLVKyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 05:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiLVKyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 05:54:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3089286DD
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 02:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671706398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8G2t4EncMzIPIeZuX+4iivTLgYuFur9QluEHx6LDvQ8=;
        b=WEY2hsgPJLd1TlsqjaQR6N94/9hVUU45kT04QZfGXdQC+SoM/cIqprNr8QTX17PqmSKFKQ
        3dUS2XDC29sotvv8BbYDxmnFje/L8Utx2UMcz4vOXjdxlMlAJpO4e+xOSLP2MuOEQWZpIv
        34Wuwy/oZ2nk5TTncoQt3bu5R2INg7c=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-398-MejOQGNqN2ynVAp1JZ3ppA-1; Thu, 22 Dec 2022 05:53:16 -0500
X-MC-Unique: MejOQGNqN2ynVAp1JZ3ppA-1
Received: by mail-wr1-f72.google.com with SMTP id g18-20020adfa492000000b0027174820fdbso186929wrb.4
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 02:53:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8G2t4EncMzIPIeZuX+4iivTLgYuFur9QluEHx6LDvQ8=;
        b=6bUbKnie26flJ73EER1VdeBP71OgzGyXuxWoQ7vLA/uGR0vcFcArZ9WmZjHuWDd8HC
         6rwVvYEA5gECt4puemmJmZLXu8Z7V1hwQS5m/28fhSBf2WMbncN3CkBB13uIHdSx8Nbo
         ehHmRqO8Bc2QpltiQDwUUjLjlGo8o1kJFsJOrHL0C6x5hPiceRSRFPDpEs1ZLydhueIH
         rxfqFUtayXvXBMyf+NV50fhF+gYt1QWYv+HNXXzTOWdY9LtRr48rci81NeE5S99yBLkH
         Tqw9l8B8FO1BJ4CVk46PWHfDj85v5C6Wfuj2KOn6NpHFAQ4v1laO7YlvumqpVdIxtD3R
         UjJQ==
X-Gm-Message-State: AFqh2koxB+xEEDMm6Jew/cm96ipFSymPYcEllbRqIRNf6ClsenRpP2MA
        RjOjGeF5Pwcu9Id4KfQvNwJfFew6/9OnGoOiMksadJ/vM/fn9sB9UANSgA4v9Sf7kbw9offidsj
        Xt5bruxPkH3EbYIga
X-Received: by 2002:a7b:cb89:0:b0:3d2:2101:1f54 with SMTP id m9-20020a7bcb89000000b003d221011f54mr4088296wmi.4.1671706395603;
        Thu, 22 Dec 2022 02:53:15 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuWy0Wp+keurAyyZDEg4bOQUbTq2wJRgZQKCZGHKk9AOq3sK2SNmvUXsdQwg+ta4Y0Xv7buqg==
X-Received: by 2002:a7b:cb89:0:b0:3d2:2101:1f54 with SMTP id m9-20020a7bcb89000000b003d221011f54mr4088281wmi.4.1671706395348;
        Thu, 22 Dec 2022 02:53:15 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-101-173.dyn.eolo.it. [146.241.101.173])
        by smtp.gmail.com with ESMTPSA id ay39-20020a05600c1e2700b003cfa80443a0sm554729wmb.35.2022.12.22.02.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 02:53:14 -0800 (PST)
Message-ID: <a198f9fa6737b22ed2839a5dbfbcfdf6c6d7508d.camel@redhat.com>
Subject: Re: [PATCH 3/3] net/ncsi: Add NC-SI 1.2 Get MC MAC Address command
From:   Paolo Abeni <pabeni@redhat.com>
To:     Peter Delevoryas <peter@pjd.dev>
Cc:     sam@mendozajonas.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, joel@jms.id.au, gwshan@linux.vnet.ibm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 22 Dec 2022 11:53:13 +0100
In-Reply-To: <20221221052246.519674-4-peter@pjd.dev>
References: <20221221052246.519674-1-peter@pjd.dev>
         <20221221052246.519674-4-peter@pjd.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-12-20 at 21:22 -0800, Peter Delevoryas wrote:
> This change adds support for the NC-SI 1.2 Get MC MAC Address command,
> specified here:
> 
> https://www.dmtf.org/sites/default/files/standards/documents/DSP0222_1.2WIP90_0.pdf
> 
> It serves the exact same function as the existing OEM Get MAC Address
> commands, so if a channel reports that it supports NC-SI 1.2, we prefer
> to use the standard command rather than the OEM command.
> 
> Verified with an invalid MAC address and 2 valid ones:
> 
> [   55.137072] ftgmac100 1e690000.ftgmac eth0: NCSI: Received 3 provisioned MAC addresses
> [   55.137614] ftgmac100 1e690000.ftgmac eth0: NCSI: MAC address 0: 00:00:00:00:00:00
> [   55.138026] ftgmac100 1e690000.ftgmac eth0: NCSI: MAC address 1: fa:ce:b0:0c:20:22
> [   55.138528] ftgmac100 1e690000.ftgmac eth0: NCSI: MAC address 2: fa:ce:b0:0c:20:23
> [   55.139241] ftgmac100 1e690000.ftgmac eth0: NCSI: Unable to assign 00:00:00:00:00:00 to device
> [   55.140098] ftgmac100 1e690000.ftgmac eth0: NCSI: Set MAC address to fa:ce:b0:0c:20:22
> 
> IMPORTANT NOTE:
> 
> The code I'm submitting here is parsing the MAC addresses as if they are
> transmitted in *reverse* order.
> 
> This is different from how every other NC-SI command is parsed in the
> Linux kernel, even though the spec describes the format in the same way
> for every command.
> 
> The *reason* for this is that I was able to test this code against the
> new 200G Broadcom NIC, which reports that it supports NC-SI 1.2 in Get
> Version ID and successfully responds to this command. It transmits the
> MAC addresses in reverse byte order.
> 
> Nvidia's new 200G NIC doesn't support NC-SI 1.2 yet. I don't know how
> they're planning to implement it.

All the above looks like a good reason to wait for at least a
stable/documented H/W implementation, before pushing code to the
networking core.

>  net/ncsi/ncsi-cmd.c    |  3 ++-
>  net/ncsi/ncsi-manage.c |  9 +++++++--
>  net/ncsi/ncsi-pkt.h    | 10 ++++++++++
>  net/ncsi/ncsi-rsp.c    | 45 +++++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 63 insertions(+), 4 deletions(-)
> 
> diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
> index dda8b76b7798..7be177f55173 100644
> --- a/net/ncsi/ncsi-cmd.c
> +++ b/net/ncsi/ncsi-cmd.c
> @@ -269,7 +269,8 @@ static struct ncsi_cmd_handler {
>  	{ NCSI_PKT_CMD_GPS,    0, ncsi_cmd_handler_default },
>  	{ NCSI_PKT_CMD_OEM,   -1, ncsi_cmd_handler_oem     },
>  	{ NCSI_PKT_CMD_PLDM,   0, NULL                     },
> -	{ NCSI_PKT_CMD_GPUUID, 0, ncsi_cmd_handler_default }
> +	{ NCSI_PKT_CMD_GPUUID, 0, ncsi_cmd_handler_default },
> +	{ NCSI_PKT_CMD_GMCMA,  0, ncsi_cmd_handler_default }
>  };
>  
>  static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
> diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
> index f56795769893..bc1887a2543d 100644
> --- a/net/ncsi/ncsi-manage.c
> +++ b/net/ncsi/ncsi-manage.c
> @@ -1038,11 +1038,16 @@ static void ncsi_configure_channel(struct ncsi_dev_priv *ndp)
>  	case ncsi_dev_state_config_oem_gma:
>  		nd->state = ncsi_dev_state_config_clear_vids;
>  
> -		nca.type = NCSI_PKT_CMD_OEM;
>  		nca.package = np->id;
>  		nca.channel = nc->id;
>  		ndp->pending_req_num = 1;
> -		ret = ncsi_gma_handler(&nca, nc->version.mf_id);
> +		if (nc->version.major >= 1 && nc->version.minor >= 2) {
> +			nca.type = NCSI_PKT_CMD_GMCMA;
> +			ret = ncsi_xmit_cmd(&nca);
> +		} else {
> +			nca.type = NCSI_PKT_CMD_OEM;
> +			ret = ncsi_gma_handler(&nca, nc->version.mf_id);
> +		}
>  		if (ret < 0)
>  			schedule_work(&ndp->work);
>  
> diff --git a/net/ncsi/ncsi-pkt.h b/net/ncsi/ncsi-pkt.h
> index c9d1da34dc4d..f2f3b5c1b941 100644
> --- a/net/ncsi/ncsi-pkt.h
> +++ b/net/ncsi/ncsi-pkt.h
> @@ -338,6 +338,14 @@ struct ncsi_rsp_gpuuid_pkt {
>  	__be32                  checksum;
>  };
>  
> +/* Get MC MAC Address */
> +struct ncsi_rsp_gmcma_pkt {
> +	struct ncsi_rsp_pkt_hdr rsp;
> +	unsigned char           address_count;
> +	unsigned char           reserved[3];
> +	unsigned char           addresses[][ETH_ALEN];
> +};
> +
>  /* AEN: Link State Change */
>  struct ncsi_aen_lsc_pkt {
>  	struct ncsi_aen_pkt_hdr aen;        /* AEN header      */
> @@ -398,6 +406,7 @@ struct ncsi_aen_hncdsc_pkt {
>  #define NCSI_PKT_CMD_GPUUID	0x52 /* Get package UUID                 */
>  #define NCSI_PKT_CMD_QPNPR	0x56 /* Query Pending NC PLDM request */
>  #define NCSI_PKT_CMD_SNPR	0x57 /* Send NC PLDM Reply  */
> +#define NCSI_PKT_CMD_GMCMA	0x58 /* Get MC MAC Address */
>  
>  
>  /* NCSI packet responses */
> @@ -433,6 +442,7 @@ struct ncsi_aen_hncdsc_pkt {
>  #define NCSI_PKT_RSP_GPUUID	(NCSI_PKT_CMD_GPUUID + 0x80)
>  #define NCSI_PKT_RSP_QPNPR	(NCSI_PKT_CMD_QPNPR   + 0x80)
>  #define NCSI_PKT_RSP_SNPR	(NCSI_PKT_CMD_SNPR   + 0x80)
> +#define NCSI_PKT_RSP_GMCMA	(NCSI_PKT_CMD_GMCMA  + 0x80)
>  
>  /* NCSI response code/reason */
>  #define NCSI_PKT_RSP_C_COMPLETED	0x0000 /* Command Completed        */
> diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
> index 7a805b86a12d..28a042688d0b 100644
> --- a/net/ncsi/ncsi-rsp.c
> +++ b/net/ncsi/ncsi-rsp.c
> @@ -1140,6 +1140,48 @@ static int ncsi_rsp_handler_netlink(struct ncsi_request *nr)
>  	return ret;
>  }
>  
> +static int ncsi_rsp_handler_gmcma(struct ncsi_request *nr)
> +{
> +	struct ncsi_dev_priv *ndp = nr->ndp;
> +	struct net_device *ndev = ndp->ndev.dev;
> +	struct ncsi_rsp_gmcma_pkt *rsp;
> +	struct sockaddr saddr;
> +	int ret = -1;
> +	int i;
> +	int j;
> +
> +	rsp = (struct ncsi_rsp_gmcma_pkt *)skb_network_header(nr->rsp);
> +	saddr.sa_family = ndev->type;
> +	ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
> +
> +	netdev_warn(ndev, "NCSI: Received %d provisioned MAC addresses\n",
> +		    rsp->address_count);
> +	for (i = 0; i < rsp->address_count; i++) {
> +		netdev_warn(ndev, "NCSI: MAC address %d: "
> +			    "%02x:%02x:%02x:%02x:%02x:%02x\n", i,
> +			    rsp->addresses[i][5], rsp->addresses[i][4],
> +			    rsp->addresses[i][3], rsp->addresses[i][2],
> +			    rsp->addresses[i][1], rsp->addresses[i][0]);
> +	}

You must avoid this kind of debug messages on 'warn' level (more
below). You could consider pr_debug() instead or completely drop the
message.

Cheers,

Paolo

