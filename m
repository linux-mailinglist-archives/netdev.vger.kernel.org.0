Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6EB567385B
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 13:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjASM2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 07:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbjASM1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 07:27:53 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DC67494F
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 04:27:18 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id g10so1398598wmo.1
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 04:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9tce2LINhtKzl0RcdBACLaNn9BYaMfCdoOy7lkj0dXE=;
        b=R53wb85U+6vwHyNJiI/tiU7VbMEeGuyawDFMwLrTxD5hp/Sfw7za8jPPKa+rN21/Ue
         bX34H3ViV7qsYWBvtSTqf8Q5gL258SN6aYt607x9lMfnYf3lXe1zFMXLcU+o/yPeCM9O
         HHYfh9eRlAUKBHOTgxHNbsxQIIlHCf0WydH+VgcSLikRtxdFxwAYeS5ejhG10nZKnqQ4
         C4uMAMjjSJp1ZCq5b8fqqGrFbPwiIZIxM9OdVT+3p+lD6JUMU7IjEbXw2149qdzzMe3g
         GGY1HbpDoefpyN84a9k2z9JRevmQVB2JZNZ0pzp+2K8zw6aCYxWUeJWDSgl585KDITV3
         yHxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9tce2LINhtKzl0RcdBACLaNn9BYaMfCdoOy7lkj0dXE=;
        b=BCil6HNDUn8nDhlqc6QPJJj6ApM6hsqcPjA6nl5HPIfBqUE3zut9eeKws9oJoUfGRI
         WnBXl/V0pfZ6PBpfNHULMbU5slJlgKCrTx6N1BV2lm0zFiLBfFOOu3ps0aBEbeIBGHdj
         Wt7vCFPuPvbAKywB4wyVM5w/V/1kR2EhOuASS2HBHx9XJmGdRorAZ6fm0lbK6d9aVexB
         +jXcVE3tWLI8WzADoxrLymETJ0EPaWvyLcrG6jtjQ1ate2axmegVqNx/VYV8xx/aE447
         e3HfAoyY/WPyUEFOSCRHEcbVA86Zuw9gqQPRE5Juh89z4jpUG36rbG0/7jJKI3qeJVvs
         Nwrg==
X-Gm-Message-State: AFqh2koZM7CrWCq1GV6Mdz+37BCjxPwcM38xL7bpaIFwqNN36iKpM1HS
        NJbdLGll5MHl9PLnKWRLvzXQIw==
X-Google-Smtp-Source: AMrXdXt5A2LkAfoQdFO2N3O9epxqqRFoXaU5n1EQiJ4x4Pdq9fkQ/LGu+X1rUjpfuh6gV7fh9PW15A==
X-Received: by 2002:a05:600c:5025:b0:3db:14dc:8cff with SMTP id n37-20020a05600c502500b003db14dc8cffmr5330144wmr.33.1674131236858;
        Thu, 19 Jan 2023 04:27:16 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id r6-20020a1c2b06000000b003a6125562e1sm4582526wmr.46.2023.01.19.04.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 04:27:16 -0800 (PST)
Date:   Thu, 19 Jan 2023 13:27:15 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm@gmail.com, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next 7/7] sfc: add support for devlink
 port_function_hw_addr_set in ef100
Message-ID: <Y8k3I2Ibd+xYlC5o@nanopsycho>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
 <20230119113140.20208-8-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119113140.20208-8-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 19, 2023 at 12:31:40PM CET, alejandro.lucero-palau@amd.com wrote:
>From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>
>Using the builtin client handle id infrastructure, this patch adds
>support for setting the mac address linked to mports in ef100. This
>implies to execute an MCDI command for giving the address to the
>firmware for the specific devlink port.
>
>Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>---
> drivers/net/ethernet/sfc/efx_devlink.c | 44 ++++++++++++++++++++++++++
> 1 file changed, 44 insertions(+)
>
>diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
>index 2a57c4f6d2b2..a85b2d4e54ab 100644
>--- a/drivers/net/ethernet/sfc/efx_devlink.c
>+++ b/drivers/net/ethernet/sfc/efx_devlink.c
>@@ -472,6 +472,49 @@ static int efx_devlink_port_addr_get(struct devlink_port *port, u8 *hw_addr,
> 	return rc;
> }
> 
>+static int efx_devlink_port_addr_set(struct devlink_port *port,

Similar comments here as for the _get callback: embed devlink_port
struct, use extack.


>+				     const u8 *hw_addr, int hw_addr_len,
>+				     struct netlink_ext_ack *extack)
>+{
>+	MCDI_DECLARE_BUF(inbuf, MC_CMD_SET_CLIENT_MAC_ADDRESSES_IN_LEN(1));
>+	struct efx_devlink *devlink = devlink_priv(port->devlink);
>+	struct mae_mport_desc *mport_desc;
>+	efx_qword_t pciefn;
>+	u32 client_id;
>+	int rc;
>+
>+	mport_desc = efx_mae_get_mport(devlink->efx, port->index);
>+	if (!mport_desc)
>+		return -EINVAL;
>+
>+	if (!ef100_mport_is_vf(mport_desc))
>+		return -EPERM;
>+
>+	EFX_POPULATE_QWORD_3(pciefn,
>+			     PCIE_FUNCTION_PF, PCIE_FUNCTION_PF_NULL,
>+			     PCIE_FUNCTION_VF, mport_desc->vf_idx,
>+			     PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
>+
>+	rc = efx_ef100_lookup_client_id(devlink->efx, pciefn, &client_id);
>+	if (rc) {
>+		netif_err(devlink->efx, drv, devlink->efx->net_dev,
>+			  "Failed to get client ID for port index %u, rc %d\n",
>+			  port->index, rc);
>+		return rc;
>+	}
>+
>+	MCDI_SET_DWORD(inbuf, SET_CLIENT_MAC_ADDRESSES_IN_CLIENT_HANDLE,
>+		       client_id);
>+
>+	ether_addr_copy(MCDI_PTR(inbuf, SET_CLIENT_MAC_ADDRESSES_IN_MAC_ADDRS),
>+			hw_addr);
>+
>+	rc = efx_mcdi_rpc(devlink->efx, MC_CMD_SET_CLIENT_MAC_ADDRESSES, inbuf,
>+			  sizeof(inbuf), NULL, 0, NULL);
>+
>+	return rc;
>+}
>+
> static int efx_devlink_info_get(struct devlink *devlink,
> 				struct devlink_info_req *req,
> 				struct netlink_ext_ack *extack)
>@@ -486,6 +529,7 @@ static int efx_devlink_info_get(struct devlink *devlink,
> static const struct devlink_ops sfc_devlink_ops = {
> 	.info_get			= efx_devlink_info_get,
> 	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
>+	.port_function_hw_addr_set	= efx_devlink_port_addr_set,
> };
> 
> static struct devlink_port *ef100_set_devlink_port(struct efx_nic *efx, u32 idx)
>-- 
>2.17.1
>
