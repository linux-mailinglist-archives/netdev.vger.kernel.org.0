Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F4E687CED
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbjBBMKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbjBBMKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:10:01 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C6189373
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 04:09:59 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id hx15so5255588ejc.11
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 04:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0RBYZxo7vxDEpuhOFNTjAkn7qs3oieyyFlO+EQUk5ZE=;
        b=nFdFW68oeoy1+tWdk2rU8H+YruHbzsbvZwh4lSg8TXBxcUPlC94XKn4AUXCB9xcwVW
         /tTBF/IvQUlotmZBaaeprl0U5dj6m5DqX1vJ/CzyHirzmJyGgk7Pjm9A0jV1kxIRgIBy
         IUQpIfWRwXTJWBV1lGDN0LtRe8xD3+WjFewHcskv4g7LuNsLgQ/c0yqSUhrp+rc7n+Ep
         NLlTfhskKhAuXvXJoMjKcR0LWyY9OJXaZRYWjMtxw/n0b6BRBHs63ML+LnO2vqr0lGr5
         4gYtB/9Y5cDi3Yzhj5ZVp5NEp5peH7Lbx/CWQZNGzzkarF9xazASqt0lZCC6+z2q8Jla
         sQGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0RBYZxo7vxDEpuhOFNTjAkn7qs3oieyyFlO+EQUk5ZE=;
        b=OlTqHR1I4CiiBszHnxr/st3HVQ+iHIJ9IESykNJ/Y01bQL7+iJZa9bfFlQvY6+6pym
         ivURiZhOxJqW+1htJfkFlKXA0izAVmOsZuwmIHILLL1FWr8raFt8/YflnY5smHhqMpSf
         6da5Pbgae5lKhdI//o0tLaFFDSBBBqIu3beOBoHjA1XCb65Z8f3x0QNdgG0O55jwKpGC
         IG9LyX15REumKL1tN9mtW0TSntNPzDLNuQMjCSM1QqJhnwK/NpQya1KzdWB7SBoi8j1r
         mKmfewLBnjBIR/vKHWHEMx5gpOCgA3lM/K5fDu46gIPtwXTfvgF3I/E9Kud7DXMGPiIJ
         XLSg==
X-Gm-Message-State: AO0yUKWgTGpdcLXggIqwYl5x3Ex6A56SO3xW2dUx5UEtYDuf+Ql7jsS6
        gc/vGQKDtFrwCC0CF1lZxTNOGQ==
X-Google-Smtp-Source: AK7set8NBacQzoknnlVSVhr3SnhQrD7A5Tj18NXGbT3mMpza5gGv1X6J/COFvdQoD+k+XgeRtLjslg==
X-Received: by 2002:a17:907:3e82:b0:878:6755:9089 with SMTP id hs2-20020a1709073e8200b0087867559089mr8406568ejc.39.1675339798307;
        Thu, 02 Feb 2023 04:09:58 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id t26-20020a17090616da00b007aee7ca1199sm11653849ejd.10.2023.02.02.04.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 04:09:57 -0800 (PST)
Date:   Thu, 2 Feb 2023 13:09:56 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com, linux-doc@vger.kernel.org, corbet@lwn.net,
        jiri@nvidia.com
Subject: Re: [PATCH v5 net-next 7/8] sfc: add support for devlink
 port_function_hw_addr_get in ef100
Message-ID: <Y9uoFNFjs1QDHt2K@nanopsycho>
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
 <20230202111423.56831-8-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202111423.56831-8-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Feb 02, 2023 at 12:14:22PM CET, alejandro.lucero-palau@amd.com wrote:
>From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>
>Using the builtin client handle id infrastructure, this patch adds

Don't talk about "this patch". Just tell the codebase what to do.


>support for obtaining the mac address linked to mports in ef100. This
>implies to execute an MCDI command for getting the data from the
>firmware for each devlink port.
>
>Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>---
> drivers/net/ethernet/sfc/ef100_nic.c   | 27 +++++++++++++
> drivers/net/ethernet/sfc/ef100_nic.h   |  1 +
> drivers/net/ethernet/sfc/ef100_rep.c   |  8 ++++
> drivers/net/ethernet/sfc/ef100_rep.h   |  1 +
> drivers/net/ethernet/sfc/efx_devlink.c | 53 ++++++++++++++++++++++++++
> 5 files changed, 90 insertions(+)
>
>diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
>index aa48c79a2149..becd21c2325d 100644
>--- a/drivers/net/ethernet/sfc/ef100_nic.c
>+++ b/drivers/net/ethernet/sfc/ef100_nic.c
>@@ -1122,6 +1122,33 @@ static int ef100_probe_main(struct efx_nic *efx)
> 	return rc;
> }
> 
>+/* MCDI commands are related to the same device issuing them. This function
>+ * allows to do an MCDI command on behalf of another device, mainly PFs setting
>+ * things for VFs.
>+ */
>+int efx_ef100_lookup_client_id(struct efx_nic *efx, efx_qword_t pciefn, u32 *id)
>+{
>+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CLIENT_HANDLE_OUT_LEN);
>+	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_CLIENT_HANDLE_IN_LEN);
>+	u64 pciefn_flat = le64_to_cpu(pciefn.u64[0]);
>+	size_t outlen;
>+	int rc;
>+
>+	MCDI_SET_DWORD(inbuf, GET_CLIENT_HANDLE_IN_TYPE,
>+		       MC_CMD_GET_CLIENT_HANDLE_IN_TYPE_FUNC);
>+	MCDI_SET_QWORD(inbuf, GET_CLIENT_HANDLE_IN_FUNC,
>+		       pciefn_flat);
>+
>+	rc = efx_mcdi_rpc(efx, MC_CMD_GET_CLIENT_HANDLE, inbuf, sizeof(inbuf),
>+			  outbuf, sizeof(outbuf), &outlen);
>+	if (rc)
>+		return rc;
>+	if (outlen < sizeof(outbuf))
>+		return -EIO;
>+	*id = MCDI_DWORD(outbuf, GET_CLIENT_HANDLE_OUT_HANDLE);
>+	return 0;
>+}
>+
> int ef100_probe_netdev_pf(struct efx_nic *efx)
> {
> 	struct ef100_nic_data *nic_data = efx->nic_data;
>diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
>index e59044072333..f1ed481c1260 100644
>--- a/drivers/net/ethernet/sfc/ef100_nic.h
>+++ b/drivers/net/ethernet/sfc/ef100_nic.h
>@@ -94,4 +94,5 @@ int ef100_filter_table_probe(struct efx_nic *efx);
> 
> int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address,
> 			  int client_handle, bool empty_ok);
>+int efx_ef100_lookup_client_id(struct efx_nic *efx, efx_qword_t pciefn, u32 *id);
> #endif	/* EFX_EF100_NIC_H */
>diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
>index 6b5bc5d6955d..0b3083ef0ead 100644
>--- a/drivers/net/ethernet/sfc/ef100_rep.c
>+++ b/drivers/net/ethernet/sfc/ef100_rep.c
>@@ -361,6 +361,14 @@ bool ef100_mport_on_local_intf(struct efx_nic *efx,
> 		     mport_desc->interface_idx == nic_data->local_mae_intf;
> }
> 
>+bool ef100_mport_is_vf(struct mae_mport_desc *mport_desc)
>+{
>+	bool pcie_func;
>+
>+	pcie_func = ef100_mport_is_pcie_vnic(mport_desc);
>+	return pcie_func && (mport_desc->vf_idx != MAE_MPORT_DESC_VF_IDX_NULL);
>+}
>+
> void efx_ef100_init_reps(struct efx_nic *efx)
> {
> 	struct ef100_nic_data *nic_data = efx->nic_data;
>diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
>index ae6add4b0855..a042525a2240 100644
>--- a/drivers/net/ethernet/sfc/ef100_rep.h
>+++ b/drivers/net/ethernet/sfc/ef100_rep.h
>@@ -76,4 +76,5 @@ void efx_ef100_fini_reps(struct efx_nic *efx);
> struct mae_mport_desc;
> bool ef100_mport_on_local_intf(struct efx_nic *efx,
> 			       struct mae_mport_desc *mport_desc);
>+bool ef100_mport_is_vf(struct mae_mport_desc *mport_desc);
> #endif /* EF100_REP_H */
>diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
>index afdb19f0c774..c44547b9894e 100644
>--- a/drivers/net/ethernet/sfc/efx_devlink.c
>+++ b/drivers/net/ethernet/sfc/efx_devlink.c
>@@ -60,6 +60,56 @@ static int efx_devlink_add_port(struct efx_nic *efx,
> 
> 	return devl_port_register(efx->devlink, &mport->dl_port, mport->mport_id);
> }
>+
>+static int efx_devlink_port_addr_get(struct devlink_port *port, u8 *hw_addr,
>+				     int *hw_addr_len,
>+				     struct netlink_ext_ack *extack)
>+{
>+	struct efx_devlink *devlink = devlink_priv(port->devlink);
>+	struct mae_mport_desc *mport_desc;
>+	efx_qword_t pciefn;
>+	u32 client_id;
>+	int rc = 0;

Pointless init.


>+
>+	mport_desc = container_of(port, struct mae_mport_desc, dl_port);
>+
>+	if (!ef100_mport_on_local_intf(devlink->efx, mport_desc)) {
>+		rc = -EINVAL;
>+		NL_SET_ERR_MSG_FMT(extack,
>+				   "Port not on local interface (mport: %u)",
>+				   mport_desc->mport_id);
>+		goto out;
>+	}
>+
>+	if (ef100_mport_is_vf(mport_desc))
>+		EFX_POPULATE_QWORD_3(pciefn,
>+				     PCIE_FUNCTION_PF, PCIE_FUNCTION_PF_NULL,
>+				     PCIE_FUNCTION_VF, mport_desc->vf_idx,
>+				     PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
>+	else
>+		EFX_POPULATE_QWORD_3(pciefn,
>+				     PCIE_FUNCTION_PF, mport_desc->pf_idx,
>+				     PCIE_FUNCTION_VF, PCIE_FUNCTION_VF_NULL,
>+				     PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
>+
>+	rc = efx_ef100_lookup_client_id(devlink->efx, pciefn, &client_id);
>+	if (rc) {
>+		NL_SET_ERR_MSG_FMT(extack,
>+				   "No internal client_ID for port (mport: %u)",
>+				   mport_desc->mport_id);
>+		goto out;
>+	}
>+
>+	rc = ef100_get_mac_address(devlink->efx, hw_addr, client_id, true);
>+	if (rc != 0)

why "if (rc)" is not enough here?

>+		NL_SET_ERR_MSG_FMT(extack,
>+				   "No available MAC for port (mport: %u)",
>+				   mport_desc->mport_id);

It is redundant to print mport_id which is exposed as devlink port id.
Please remove from the all the extack messages. No need to mention
"port" at all, as the user knows on which object he is performing the
command.

Also, perhaps it would sound better to say "No MAC available"?



>+out:
>+	*hw_addr_len = ETH_ALEN;

Odd. I think you should not touch hw_addr_len in case of error.


>+	return rc;
>+}
>+
> #endif
> 
> static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
>@@ -522,6 +572,9 @@ static int efx_devlink_info_get(struct devlink *devlink,
> 
> static const struct devlink_ops sfc_devlink_ops = {
> 	.info_get			= efx_devlink_info_get,
>+#ifdef CONFIG_SFC_SRIOV
>+	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
>+#endif
> };
> 
> #ifdef CONFIG_SFC_SRIOV
>-- 
>2.17.1
>
