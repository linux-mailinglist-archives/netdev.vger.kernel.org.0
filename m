Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B06F6738D1
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 13:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjASMlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 07:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjASMkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 07:40:46 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA9D7CCD7
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 04:37:25 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id c10-20020a05600c0a4a00b003db0636ff84so1180578wmq.0
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 04:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ylez/URaCHbDujhfctL2GdLIOiG7Ub/NPhv1HW6ogaQ=;
        b=b2m5qF2H7mnsVr4KO0W8hiKV1cXXYdcM4vjU17NwSGv8s61D3wTQ0VW8+MLoM61m80
         fT9ZY/X/eJdvYL/0L75iy94VSiDHWwKdLLgthUudREIQYk3UTl0osMMKjxLN6Aut7cpb
         +w6YrK/1jmwl5dXdwYo0QnR5u8L0JAEgBwUEJA0j4mRUdM8HmpfgJHeBFWGUYb4qq3ww
         f2mR+g/1BbflxLu/ogY78noxz7U81y3WumuazMTRAWO81/aDvjNgbj1RcoGwL8MC8Kbl
         BhYZDIpY7HfLn7CSq4+C9oaJvjxX76k4BsHX8y0Xj4ENw40YsW1TBCmgBO8to0rjtn2p
         WJKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ylez/URaCHbDujhfctL2GdLIOiG7Ub/NPhv1HW6ogaQ=;
        b=CvCXU7hwsAItQEpBman2xKX1RWImb5ZNmKDlpwPVgcvVSu3BTUjSNRa/RFCvbiKPCM
         8WwypPBIhf5U3HkB8IKgSsd9HiEWfbDFIdsMnwW1mDxHJpbdoWAF784jfIqe6gLFZHYw
         e2GpO78NRxTIu+W5T4tWmCDE7y2ZzpbZa0A7RsEk5GYOv+XKr3clliO+vslsInKGCTfp
         VXGlJ3KpQx2et1hC+SERber+8E7F3aZ6gQzKLADSYEx5kUuDmPd77iIPaVU1jNyZoKn1
         3Z7OHThs+gjlgmbvctmbu8dID0PiJ9/hVDmHJqP4yUUskjnKijcL5TRzrQthLyrO6lub
         AlxQ==
X-Gm-Message-State: AFqh2kqR2eyitn1LPdRptVnEWYISQzphx78nqVi2RxYGJQf6YtNrF1yu
        QptZOjLUrPmn7rGnZmUGM1XIXA==
X-Google-Smtp-Source: AMrXdXsJbH92F76/WwFg/shpX/OBZabi7CSglRSHmMeT6S9BNTWDDnpYTojfGbQPTLINxhwqvQZT3A==
X-Received: by 2002:a05:600c:540f:b0:3da:f6fe:ba6 with SMTP id he15-20020a05600c540f00b003daf6fe0ba6mr10405275wmb.38.1674131843758;
        Thu, 19 Jan 2023 04:37:23 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id k14-20020a05600c1c8e00b003d9ed40a512sm6682681wms.45.2023.01.19.04.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 04:37:23 -0800 (PST)
Date:   Thu, 19 Jan 2023 13:37:22 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm@gmail.com, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next 6/7] sfc: add support for
 port_function_hw_addr_get devlink in ef100
Message-ID: <Y8k5glNLX1eE2iKE@nanopsycho>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
 <20230119113140.20208-7-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119113140.20208-7-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 19, 2023 at 12:31:39PM CET, alejandro.lucero-palau@amd.com wrote:
>From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>
>Using the builtin client handle id infrastructure, this patch adds
>support for obtaining the mac address linked to mports in ef100. This
>implies to execute an MCDI command for getting the data from the
>firmware for each devlink port.
>
>Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>---
> drivers/net/ethernet/sfc/ef100_nic.c   | 27 ++++++++++++++++
> drivers/net/ethernet/sfc/ef100_nic.h   |  1 +
> drivers/net/ethernet/sfc/ef100_rep.c   |  8 +++++
> drivers/net/ethernet/sfc/ef100_rep.h   |  1 +
> drivers/net/ethernet/sfc/efx_devlink.c | 44 ++++++++++++++++++++++++++
> 5 files changed, 81 insertions(+)
>
>diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
>index f4e913593f2b..4400ce622228 100644
>--- a/drivers/net/ethernet/sfc/ef100_nic.c
>+++ b/drivers/net/ethernet/sfc/ef100_nic.c
>@@ -1121,6 +1121,33 @@ static int ef100_probe_main(struct efx_nic *efx)
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
>index ff0c8da61919..974c9ff901a0 100644
>--- a/drivers/net/ethernet/sfc/ef100_rep.c
>+++ b/drivers/net/ethernet/sfc/ef100_rep.c
>@@ -362,6 +362,14 @@ bool ef100_mport_on_local_intf(struct efx_nic *efx,
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
>index 9cca41614982..74853ccbc937 100644
>--- a/drivers/net/ethernet/sfc/ef100_rep.h
>+++ b/drivers/net/ethernet/sfc/ef100_rep.h
>@@ -75,4 +75,5 @@ void efx_ef100_fini_reps(struct efx_nic *efx);
> struct mae_mport_desc;
> bool ef100_mport_on_local_intf(struct efx_nic *efx,
> 			       struct mae_mport_desc *mport_desc);
>+bool ef100_mport_is_vf(struct mae_mport_desc *mport_desc);
> #endif /* EF100_REP_H */
>diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
>index bb19d3ad7ffd..2a57c4f6d2b2 100644
>--- a/drivers/net/ethernet/sfc/efx_devlink.c
>+++ b/drivers/net/ethernet/sfc/efx_devlink.c
>@@ -429,6 +429,49 @@ static int efx_devlink_add_port(struct efx_nic *efx,
> 	return err;
> }
> 
>+static int efx_devlink_port_addr_get(struct devlink_port *port, u8 *hw_addr,
>+				     int *hw_addr_len,
>+				     struct netlink_ext_ack *extack)
>+{
>+	struct efx_devlink *devlink = devlink_priv(port->devlink);
>+	struct mae_mport_desc *mport_desc;
>+	efx_qword_t pciefn;
>+	u32 client_id;
>+	int rc = 0;
>+
>+	mport_desc = efx_mae_get_mport(devlink->efx, port->index);

I may be missing something, where do you fail with -EOPNOTSUPP
in case this is called for PHYSICAL port ?



>+	if (!mport_desc)
>+		return -EINVAL;
>+
>+	if (!ef100_mport_on_local_intf(devlink->efx, mport_desc))
>+		goto out;
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
>+		netif_err(devlink->efx, drv, devlink->efx->net_dev,
>+			  "Failed to get client ID for port index %u, rc %d\n",
>+			  port->index, rc);
>+		return rc;
>+	}
>+
>+	rc = ef100_get_mac_address(devlink->efx, hw_addr, client_id, true);
>+out:
>+	*hw_addr_len = ETH_ALEN;
>+
>+	return rc;
>+}
>+
> static int efx_devlink_info_get(struct devlink *devlink,
> 				struct devlink_info_req *req,
> 				struct netlink_ext_ack *extack)
>@@ -442,6 +485,7 @@ static int efx_devlink_info_get(struct devlink *devlink,
> 
> static const struct devlink_ops sfc_devlink_ops = {
> 	.info_get			= efx_devlink_info_get,
>+	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
> };
> 
> static struct devlink_port *ef100_set_devlink_port(struct efx_nic *efx, u32 idx)
>-- 
>2.17.1
>
