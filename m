Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D3F1A7E9D
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 15:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732709AbgDNNmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 09:42:04 -0400
Received: from mail.v3.sk ([167.172.186.51]:54832 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728028AbgDNNmC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 09:42:02 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 27FADE03A9;
        Tue, 14 Apr 2020 13:42:25 +0000 (UTC)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Kf1VxHPKjDDi; Tue, 14 Apr 2020 13:42:23 +0000 (UTC)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id C5C6BE043F;
        Tue, 14 Apr 2020 13:42:23 +0000 (UTC)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id nLR6T56V68z8; Tue, 14 Apr 2020 13:42:23 +0000 (UTC)
Received: from localhost (unknown [109.183.109.54])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 54494E03A9;
        Tue, 14 Apr 2020 13:42:23 +0000 (UTC)
Date:   Tue, 14 Apr 2020 15:41:55 +0200
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        colin.king@canonical.com, dan.carpenter@oracle.com,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libertas: make lbs_init_mesh() void
Message-ID: <20200414134155.GA166011@furthur.local>
References: <20200410090942.27239-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200410090942.27239-1-yanaijie@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 05:09:42PM +0800, Jason Yan wrote:
> Fix the following coccicheck warning:
> 
> drivers/net/wireless/marvell/libertas/mesh.c:833:5-8: Unneeded variable:
> "ret". Return "0" on line 874
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Reviewed-by: Lubomir Rintel <lkundrak@v3.sk>

Thank you
Lubo

> ---
>  drivers/net/wireless/marvell/libertas/mesh.c | 6 +-----
>  drivers/net/wireless/marvell/libertas/mesh.h | 2 +-
>  2 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/libertas/mesh.c b/drivers/net/wireless/marvell/libertas/mesh.c
> index 44c8a550da4c..f5b78257d551 100644
> --- a/drivers/net/wireless/marvell/libertas/mesh.c
> +++ b/drivers/net/wireless/marvell/libertas/mesh.c
> @@ -828,10 +828,8 @@ static void lbs_persist_config_remove(struct net_device *dev)
>   * Check mesh FW version and appropriately send the mesh start
>   * command
>   */
> -int lbs_init_mesh(struct lbs_private *priv)
> +void lbs_init_mesh(struct lbs_private *priv)
>  {
> -	int ret = 0;
> -
>  	/* Determine mesh_fw_ver from fwrelease and fwcapinfo */
>  	/* 5.0.16p0 9.0.0.p0 is known to NOT support any mesh */
>  	/* 5.110.22 have mesh command with 0xa3 command id */
> @@ -870,8 +868,6 @@ int lbs_init_mesh(struct lbs_private *priv)
>  
>  	/* Stop meshing until interface is brought up */
>  	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_STOP, 1);
> -
> -	return ret;
>  }
>  
>  void lbs_start_mesh(struct lbs_private *priv)
> diff --git a/drivers/net/wireless/marvell/libertas/mesh.h b/drivers/net/wireless/marvell/libertas/mesh.h
> index 1561018f226f..d49717b20c09 100644
> --- a/drivers/net/wireless/marvell/libertas/mesh.h
> +++ b/drivers/net/wireless/marvell/libertas/mesh.h
> @@ -16,7 +16,7 @@
>  
>  struct net_device;
>  
> -int lbs_init_mesh(struct lbs_private *priv);
> +void lbs_init_mesh(struct lbs_private *priv);
>  void lbs_start_mesh(struct lbs_private *priv);
>  int lbs_deinit_mesh(struct lbs_private *priv);
>  
> -- 
> 2.17.2
> 
