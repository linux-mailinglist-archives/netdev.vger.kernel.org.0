Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA68687D01
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbjBBMN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbjBBMN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:13:27 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29CC6A732
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 04:13:25 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id n6so1761614edo.9
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 04:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T64wIly3JgXKeZGQTtomPB0cowSiEfpWOPNkgWqeDgI=;
        b=odFxcjYJWUe0X2g6ae60sR5SMNvVhaXHWNE2gohQ/SUVFbxZy6Uc8nTjIzE5tLnlGr
         BIsq+kk3U7OSx48KOtBXCE9/4CbSVoAsMkCWne2ptb58v3Nbmmh0Yl6N9widUyuj64gx
         we5mjCcERGjD7f7hdPDsZN0XHLpfQmRHb5AtQwvXQ+pTq4zwNB/1wgg03bSDju/+puD/
         yX1uwNoRRcoLsUn5fIoqACmMdgzKdDAL1+dk3fLns1pAkGwDl4ebRwUGRjuHY7r2J/8z
         0EPMawfuswSEAZ4jxcmNXoL38DpGOi2Synz3wF0gI9W8lffTkFtwPvjotZX9VKv7jlPk
         9QJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T64wIly3JgXKeZGQTtomPB0cowSiEfpWOPNkgWqeDgI=;
        b=usSReIKm2o4QqNQGbHGjYum/Wdkz7fraKokUPVfmsQS1ODPZCk5zFjCfXylcLeNljy
         +H8idzigbyZxBp5uuo/6w6rvw/rtGrBcKWj9T9NuI1IKh9OfEmSMUxUqDwm4p5ZKb00x
         ehTPecLHNTvXXqUzWvC8iYDo8E3m966Rgvvl8HvgsWLPzTIqRQ2u0t71FcyMNBjeof+N
         e5zbmJ7xcfD95WlNGYtKp2y607j6YuV0z4T5aHLD89N1LkPsiyMSl56+m8NbBMs3S4g/
         ZSYgtMeAjYD5qgpHneAjoFJA50/Dj1EkkPXxrWTuk/gQjUJPjn8ePK1v6fwM9B/3afnr
         3HDg==
X-Gm-Message-State: AO0yUKUj6161vTzL8zqnTJvOUHI5m8laVuTKvOEhlwBS9MuS3aPmTHAA
        ZDmAhM2j/gDZVUG4Tnj1k+UyCQ==
X-Google-Smtp-Source: AK7set8BWglGf6tEUiFuTJMUKP+yUa+kiHA+TEjW9ve3Ii0bgd5eyYoT3xPbRxxPXv2dbTJM/fbrWw==
X-Received: by 2002:a50:c31a:0:b0:4a2:3d7f:dbc4 with SMTP id a26-20020a50c31a000000b004a23d7fdbc4mr5965743edb.16.1675340004196;
        Thu, 02 Feb 2023 04:13:24 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id z3-20020a50eb43000000b0045b4b67156fsm11054865edp.45.2023.02.02.04.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 04:13:23 -0800 (PST)
Date:   Thu, 2 Feb 2023 13:13:22 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com, linux-doc@vger.kernel.org, corbet@lwn.net,
        jiri@nvidia.com
Subject: Re: [PATCH v5 net-next 8/8] sfc: add support for devlink
 port_function_hw_addr_set in ef100
Message-ID: <Y9uo4t2J3T87yLg4@nanopsycho>
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
 <20230202111423.56831-9-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202111423.56831-9-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Feb 02, 2023 at 12:14:23PM CET, alejandro.lucero-palau@amd.com wrote:
>From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>
>Using the builtin client handle id infrastructure, this patch adds
>support for setting the mac address linked to mports in ef100. This
>implies to execute an MCDI command for giving the address to the
>firmware for the specific devlink port.
>
>Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Please check my notes to the previuous patch, most of them applies on
this one as well. Couple more below.



>---
> drivers/net/ethernet/sfc/efx_devlink.c | 50 ++++++++++++++++++++++++++
> 1 file changed, 50 insertions(+)
>
>diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
>index c44547b9894e..bcb8543b43ba 100644
>--- a/drivers/net/ethernet/sfc/efx_devlink.c
>+++ b/drivers/net/ethernet/sfc/efx_devlink.c
>@@ -110,6 +110,55 @@ static int efx_devlink_port_addr_get(struct devlink_port *port, u8 *hw_addr,
> 	return rc;
> }
> 
>+static int efx_devlink_port_addr_set(struct devlink_port *port,
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
>+	mport_desc = container_of(port, struct mae_mport_desc, dl_port);
>+
>+	if (!ef100_mport_is_vf(mport_desc)) {
>+		NL_SET_ERR_MSG_FMT(extack,
>+				   "port mac change not allowed (mport: %u)",

"Port" with "P"? Be consistent with extack messages.
Also "MAC", as you used that in the previous patch.



>+				   mport_desc->mport_id);
>+		return -EPERM;
>+	}
>+
>+	EFX_POPULATE_QWORD_3(pciefn,
>+			     PCIE_FUNCTION_PF, PCIE_FUNCTION_PF_NULL,
>+			     PCIE_FUNCTION_VF, mport_desc->vf_idx,
>+			     PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
>+
>+	rc = efx_ef100_lookup_client_id(devlink->efx, pciefn, &client_id);
>+	if (rc) {
>+		NL_SET_ERR_MSG_FMT(extack,
>+				   "No internal client_ID for port (mport: %u)",
>+				   mport_desc->mport_id);
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
>+	if (rc)
>+		NL_SET_ERR_MSG_FMT(extack,
>+				   "sfc MC_CMD_SET_CLIENT_MAC_ADDRESSES mcdi error (mport: %u)",

I have no clue why to put name of the driver in the extack. Don't do it.
Also, what does "MC_CMD_SET_CLIENT_MAC_ADDRESSES" tell to the user?


>+				   mport_desc->mport_id);
>+
>+	return rc;
>+}
>+
> #endif
> 
> static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
>@@ -574,6 +623,7 @@ static const struct devlink_ops sfc_devlink_ops = {
> 	.info_get			= efx_devlink_info_get,
> #ifdef CONFIG_SFC_SRIOV
> 	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
>+	.port_function_hw_addr_set	= efx_devlink_port_addr_set,
> #endif
> };
> 
>-- 
>2.17.1
>
