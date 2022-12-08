Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC74646A6B
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiLHIYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiLHIYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:24:52 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7EF5B5AE;
        Thu,  8 Dec 2022 00:24:51 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id h10so726793wrx.3;
        Thu, 08 Dec 2022 00:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DGfqcKN0EKj3DjpjD2xAqcbHzXrOY5zUtcTb4l9ZgME=;
        b=iLOGlZoOCu6/7i3peWL0ZGt/4uUg6pWDJ5qICXHN869dAxt415XsKkU8GRo3gOMlf9
         6w3bqJ7Hm15w5O5MR/RQ91WsRcW6neOpjkHzlKmXHo6oVatY1X2EPuDiUkctDfKobdNP
         yu7vhcrdrsGz0YA07uyS9xRZMExCmPEKc8TEiueJXPnAsXtl3aQg6gq5DFh6qNwGLR89
         MUraZsI/yRlhrDcfwBlQMryD3eWO9m0VeJtJ9oEq9VGwrCtf+m+XC69jwsjDUnxE6rqs
         vVj2cu5w7ugeIL4A80WBVIVQYI+xwu7c1QFrDHVHHcRBckVQ3QgoV9A3N3nbzKHF2fsR
         bP5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DGfqcKN0EKj3DjpjD2xAqcbHzXrOY5zUtcTb4l9ZgME=;
        b=nlbpBd/da1AbqR36ooNPmSgdJByxYBGJYsYl5zwHStANdqu0ShJIa+6UGeAtxo5fUK
         UZw+7tYwBIQrMogqU0DRkrtWYIOWdlirxx2aq25gcx25XqSfIBrbubEqsQOLq+9fnXiJ
         pK1LREr6pHHOgmeVa3aJbccREWm/w56yyjFK7rEZ4AeY5zLHSIWdG+jFkiX1xJj8a8Hw
         NZQjCUbw/gDK1lktQLwKo5m7TSqEMf02c9AC1fTqDrEq38kQPuG+2vpHec4/OjsWkzKv
         RhSNPthY/tGztq/PH8N7acCwq/7d66q2O9w+dKCPLEkYlc1Kp1JbG2GVEaNp3m2/hXAR
         wOjw==
X-Gm-Message-State: ANoB5pmu7KDRzhLJYSR5uhhG1eaPR/I0v70nmXIJjlogMwqkwrx4y5s4
        jtv4yx13OdqoweO4N5XD6ws=
X-Google-Smtp-Source: AA0mqf4knDHs/KstdpUtv8wqNiT7qI+ECp/nknRTc/Zw2xC7dtqMbSOsY1DUzCGyYWdM2br48A4Ssg==
X-Received: by 2002:adf:e690:0:b0:242:f43:8e3f with SMTP id r16-20020adfe690000000b002420f438e3fmr1022601wrm.25.1670487889738;
        Thu, 08 Dec 2022 00:24:49 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id n5-20020adff085000000b00236c1f2cecesm26150996wro.81.2022.12.08.00.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 00:24:49 -0800 (PST)
Date:   Thu, 8 Dec 2022 08:24:47 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     ye.xingchen@zte.com.cn
Cc:     kuba@kernel.org, ecree.xilinx@gmail.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, wangxiang@cdjrlc.com,
        dossche.niels@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] sfc: Convert to use sysfs_emit_at() API
Message-ID: <Y5GfT32YyoZHgQDG@gmail.com>
Mail-Followup-To: ye.xingchen@zte.com.cn, kuba@kernel.org,
        ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, wangxiang@cdjrlc.com, dossche.niels@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <202212081523277319144@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202212081523277319144@zte.com.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 03:23:27PM +0800, ye.xingchen@zte.com.cn wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> Follow the advice of the Documentation/filesystems/sysfs.rst and show()
> should only use sysfs_emit() or sysfs_emit_at() when formatting the
> value to be returned to user space.

That advice is for sysfs but this output is going into dmesg. So it
does not apply here.

Martin

> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
> ---
>  drivers/net/ethernet/sfc/mcdi.c       | 14 ++++----------
>  drivers/net/ethernet/sfc/siena/mcdi.c | 14 ++++----------
>  2 files changed, 8 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
> index af338208eae9..73269db3ca39 100644
> --- a/drivers/net/ethernet/sfc/mcdi.c
> +++ b/drivers/net/ethernet/sfc/mcdi.c
> @@ -210,14 +210,10 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
>  		 * progress on a NIC at any one time.  So no need for locking.
>  		 */
>  		for (i = 0; i < hdr_len / 4 && bytes < PAGE_SIZE; i++)
> -			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
> -					   " %08x",
> -					   le32_to_cpu(hdr[i].u32[0]));
> +			bytes += sysfs_emit_at(buf, bytes, " %08x", le32_to_cpu(hdr[i].u32[0]));
> 
>  		for (i = 0; i < inlen / 4 && bytes < PAGE_SIZE; i++)
> -			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
> -					   " %08x",
> -					   le32_to_cpu(inbuf[i].u32[0]));
> +			bytes += sysfs_emit_at(buf, bytes, " %08x", le32_to_cpu(inbuf[i].u32[0]));
> 
>  		netif_info(efx, hw, efx->net_dev, "MCDI RPC REQ:%s\n", buf);
>  	}
> @@ -302,15 +298,13 @@ static void efx_mcdi_read_response_header(struct efx_nic *efx)
>  		 */
>  		for (i = 0; i < hdr_len && bytes < PAGE_SIZE; i++) {
>  			efx->type->mcdi_read_response(efx, &hdr, (i * 4), 4);
> -			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
> -					   " %08x", le32_to_cpu(hdr.u32[0]));
> +			bytes += sysfs_emit_at(buf, bytes, " %08x", le32_to_cpu(hdr.u32[0]));
>  		}
> 
>  		for (i = 0; i < data_len && bytes < PAGE_SIZE; i++) {
>  			efx->type->mcdi_read_response(efx, &hdr,
>  					mcdi->resp_hdr_len + (i * 4), 4);
> -			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
> -					   " %08x", le32_to_cpu(hdr.u32[0]));
> +			bytes += sysfs_emit_at(buf, bytes, " %08x", le32_to_cpu(hdr.u32[0]));
>  		}
> 
>  		netif_info(efx, hw, efx->net_dev, "MCDI RPC RESP:%s\n", buf);
> diff --git a/drivers/net/ethernet/sfc/siena/mcdi.c b/drivers/net/ethernet/sfc/siena/mcdi.c
> index 3f7899daa86a..4e10d4594c3a 100644
> --- a/drivers/net/ethernet/sfc/siena/mcdi.c
> +++ b/drivers/net/ethernet/sfc/siena/mcdi.c
> @@ -213,14 +213,10 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
>  		 * progress on a NIC at any one time.  So no need for locking.
>  		 */
>  		for (i = 0; i < hdr_len / 4 && bytes < PAGE_SIZE; i++)
> -			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
> -					   " %08x",
> -					   le32_to_cpu(hdr[i].u32[0]));
> +			bytes += sysfs_emit_at(buf, bytes, " %08x", le32_to_cpu(hdr[i].u32[0]));
> 
>  		for (i = 0; i < inlen / 4 && bytes < PAGE_SIZE; i++)
> -			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
> -					   " %08x",
> -					   le32_to_cpu(inbuf[i].u32[0]));
> +			bytes += sysfs_emit_at(buf, bytes, " %08x", le32_to_cpu(inbuf[i].u32[0]));
> 
>  		netif_info(efx, hw, efx->net_dev, "MCDI RPC REQ:%s\n", buf);
>  	}
> @@ -305,15 +301,13 @@ static void efx_mcdi_read_response_header(struct efx_nic *efx)
>  		 */
>  		for (i = 0; i < hdr_len && bytes < PAGE_SIZE; i++) {
>  			efx->type->mcdi_read_response(efx, &hdr, (i * 4), 4);
> -			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
> -					   " %08x", le32_to_cpu(hdr.u32[0]));
> +			bytes += sysfs_emit_at(buf, bytes, " %08x", le32_to_cpu(hdr.u32[0]));
>  		}
> 
>  		for (i = 0; i < data_len && bytes < PAGE_SIZE; i++) {
>  			efx->type->mcdi_read_response(efx, &hdr,
>  					mcdi->resp_hdr_len + (i * 4), 4);
> -			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
> -					   " %08x", le32_to_cpu(hdr.u32[0]));
> +			bytes += sysfs_emit_at(buf, bytes, " %08x", le32_to_cpu(hdr.u32[0]));
>  		}
> 
>  		netif_info(efx, hw, efx->net_dev, "MCDI RPC RESP:%s\n", buf);
> -- 
> 2.25.1
