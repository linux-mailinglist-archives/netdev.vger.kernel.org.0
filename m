Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D946C67530E
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 12:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjATLIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 06:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjATLIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 06:08:17 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0402B4E28
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 03:08:13 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id az20so13076450ejc.1
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 03:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zuyDK3DN9YOP3n8tKmVQ9Bh9B+9zVIuZ/eHK2X/y2Eo=;
        b=O0XuaoZYSva+MfXs5JleUEt6nr4T2xi0XuAP5K3pcSexncB5ssBmmUcI/79gVyEDVs
         0qJj/j7RvSYOK/9K7e5rtifYOQEADj5jWFEtWuXZVJBFli1/q8DZp7SiDdNelq05fgO8
         U4qR7sNilbl0tnHa4DNN52JqbFbmwZjH4rYIeWuC+BK7tWOk4PwXiMnFAjhqVjBMt/VJ
         lGXn6+b8I2CSp4cEAXNFzbBklfg3Po5+J7V3aGs6sHPeQYpwSmQFGLKk5ZEDkOILKcAr
         j/aEeartx7j0ZIc9FDwKo9F7hohj1X4zfKnrrvSxYCCsV4bWEOeX1IEutvOarNaW0rjb
         tEqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zuyDK3DN9YOP3n8tKmVQ9Bh9B+9zVIuZ/eHK2X/y2Eo=;
        b=w2VyvxmLACPWsU9IA6qcaJ1WK117rcO1hmeBi/a7cxYFMXE2pKP6GB+QfgD4AIgDo7
         8nyPlYqyljhYqJpcgk8cnsAW+M97A6F0vCbXGUufVRlcDbKlZpEKRhHkkb+adThCHil9
         L+UqzOUfXsuZabyDDO+ySh1Nlz9eQAlBJ0W40dmUn9h3PEaAImDK2otdKvlA/yHAFUlu
         +xvkah39KjIp2a0Kdx6EIxTlwjS2wHzUfS/fp3BG1po/PA7sxRzdFSB0A8cc96GN7BBZ
         GpxB2nHVCuD/Altzi4fe5Gg8QNVCRpxkEUGHKPiU56oHfavbsaM3a0+DZRtnZa4y+cVH
         0zFQ==
X-Gm-Message-State: AFqh2koDwYTllhH1aavCeerynE/LZLGFqq4/n3AfPlMIsrULoy+4ZWEO
        skZSL6VN0HUHoKyTrUdCmw4K3w==
X-Google-Smtp-Source: AMrXdXsrR9Yvmtb1n4a4gvUEO+jeO7t1FArnoXMjlXNOMnd1W1TzBOLRHJzIc1ktGEi4qG9cwQ6P3g==
X-Received: by 2002:a17:907:d606:b0:86f:b541:cd02 with SMTP id wd6-20020a170907d60600b0086fb541cd02mr16967698ejc.28.1674212892493;
        Fri, 20 Jan 2023 03:08:12 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id p4-20020a170906614400b008512e1379dbsm14467999ejl.171.2023.01.20.03.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 03:08:11 -0800 (PST)
Date:   Fri, 20 Jan 2023 12:08:10 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm@gmail.com" <habetsm@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>
Subject: Re: [PATCH net-next 6/7] sfc: add support for
 port_function_hw_addr_get devlink in ef100
Message-ID: <Y8p2GjwVz1FAJ2eH@nanopsycho>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
 <20230119113140.20208-7-alejandro.lucero-palau@amd.com>
 <Y8k5glNLX1eE2iKE@nanopsycho>
 <433222dd-cea8-fa93-d0f8-1f4f4272ae91@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <433222dd-cea8-fa93-d0f8-1f4f4272ae91@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 19, 2023 at 04:09:27PM CET, alejandro.lucero-palau@amd.com wrote:
>
>On 1/19/23 12:37, Jiri Pirko wrote:
>> Thu, Jan 19, 2023 at 12:31:39PM CET, alejandro.lucero-palau@amd.com wrote:
>>> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>>>
>>> Using the builtin client handle id infrastructure, this patch adds
>>> support for obtaining the mac address linked to mports in ef100. This
>>> implies to execute an MCDI command for getting the data from the
>>> firmware for each devlink port.
>>>
>>> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>>> ---
>>> drivers/net/ethernet/sfc/ef100_nic.c   | 27 ++++++++++++++++
>>> drivers/net/ethernet/sfc/ef100_nic.h   |  1 +
>>> drivers/net/ethernet/sfc/ef100_rep.c   |  8 +++++
>>> drivers/net/ethernet/sfc/ef100_rep.h   |  1 +
>>> drivers/net/ethernet/sfc/efx_devlink.c | 44 ++++++++++++++++++++++++++
>>> 5 files changed, 81 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
>>> index f4e913593f2b..4400ce622228 100644
>>> --- a/drivers/net/ethernet/sfc/ef100_nic.c
>>> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
>>> @@ -1121,6 +1121,33 @@ static int ef100_probe_main(struct efx_nic *efx)
>>> 	return rc;
>>> }
>>>
>>> +/* MCDI commands are related to the same device issuing them. This function
>>> + * allows to do an MCDI command on behalf of another device, mainly PFs setting
>>> + * things for VFs.
>>> + */
>>> +int efx_ef100_lookup_client_id(struct efx_nic *efx, efx_qword_t pciefn, u32 *id)
>>> +{
>>> +	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CLIENT_HANDLE_OUT_LEN);
>>> +	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_CLIENT_HANDLE_IN_LEN);
>>> +	u64 pciefn_flat = le64_to_cpu(pciefn.u64[0]);
>>> +	size_t outlen;
>>> +	int rc;
>>> +
>>> +	MCDI_SET_DWORD(inbuf, GET_CLIENT_HANDLE_IN_TYPE,
>>> +		       MC_CMD_GET_CLIENT_HANDLE_IN_TYPE_FUNC);
>>> +	MCDI_SET_QWORD(inbuf, GET_CLIENT_HANDLE_IN_FUNC,
>>> +		       pciefn_flat);
>>> +
>>> +	rc = efx_mcdi_rpc(efx, MC_CMD_GET_CLIENT_HANDLE, inbuf, sizeof(inbuf),
>>> +			  outbuf, sizeof(outbuf), &outlen);
>>> +	if (rc)
>>> +		return rc;
>>> +	if (outlen < sizeof(outbuf))
>>> +		return -EIO;
>>> +	*id = MCDI_DWORD(outbuf, GET_CLIENT_HANDLE_OUT_HANDLE);
>>> +	return 0;
>>> +}
>>> +
>>> int ef100_probe_netdev_pf(struct efx_nic *efx)
>>> {
>>> 	struct ef100_nic_data *nic_data = efx->nic_data;
>>> diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
>>> index e59044072333..f1ed481c1260 100644
>>> --- a/drivers/net/ethernet/sfc/ef100_nic.h
>>> +++ b/drivers/net/ethernet/sfc/ef100_nic.h
>>> @@ -94,4 +94,5 @@ int ef100_filter_table_probe(struct efx_nic *efx);
>>>
>>> int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address,
>>> 			  int client_handle, bool empty_ok);
>>> +int efx_ef100_lookup_client_id(struct efx_nic *efx, efx_qword_t pciefn, u32 *id);
>>> #endif	/* EFX_EF100_NIC_H */
>>> diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
>>> index ff0c8da61919..974c9ff901a0 100644
>>> --- a/drivers/net/ethernet/sfc/ef100_rep.c
>>> +++ b/drivers/net/ethernet/sfc/ef100_rep.c
>>> @@ -362,6 +362,14 @@ bool ef100_mport_on_local_intf(struct efx_nic *efx,
>>> 		     mport_desc->interface_idx == nic_data->local_mae_intf;
>>> }
>>>
>>> +bool ef100_mport_is_vf(struct mae_mport_desc *mport_desc)
>>> +{
>>> +	bool pcie_func;
>>> +
>>> +	pcie_func = ef100_mport_is_pcie_vnic(mport_desc);
>>> +	return pcie_func && (mport_desc->vf_idx != MAE_MPORT_DESC_VF_IDX_NULL);
>>> +}
>>> +
>>> void efx_ef100_init_reps(struct efx_nic *efx)
>>> {
>>> 	struct ef100_nic_data *nic_data = efx->nic_data;
>>> diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
>>> index 9cca41614982..74853ccbc937 100644
>>> --- a/drivers/net/ethernet/sfc/ef100_rep.h
>>> +++ b/drivers/net/ethernet/sfc/ef100_rep.h
>>> @@ -75,4 +75,5 @@ void efx_ef100_fini_reps(struct efx_nic *efx);
>>> struct mae_mport_desc;
>>> bool ef100_mport_on_local_intf(struct efx_nic *efx,
>>> 			       struct mae_mport_desc *mport_desc);
>>> +bool ef100_mport_is_vf(struct mae_mport_desc *mport_desc);
>>> #endif /* EF100_REP_H */
>>> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
>>> index bb19d3ad7ffd..2a57c4f6d2b2 100644
>>> --- a/drivers/net/ethernet/sfc/efx_devlink.c
>>> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
>>> @@ -429,6 +429,49 @@ static int efx_devlink_add_port(struct efx_nic *efx,
>>> 	return err;
>>> }
>>>
>>> +static int efx_devlink_port_addr_get(struct devlink_port *port, u8 *hw_addr,
>>> +				     int *hw_addr_len,
>>> +				     struct netlink_ext_ack *extack)
>>> +{
>>> +	struct efx_devlink *devlink = devlink_priv(port->devlink);
>>> +	struct mae_mport_desc *mport_desc;
>>> +	efx_qword_t pciefn;
>>> +	u32 client_id;
>>> +	int rc = 0;
>>> +
>>> +	mport_desc = efx_mae_get_mport(devlink->efx, port->index);
>> I may be missing something, where do you fail with -EOPNOTSUPP
>> in case this is called for PHYSICAL port ?
>>
>
>We do not create a devlink port for the physical port.

Well, you do:

+       switch (mport->mport_type) {
+       case MAE_MPORT_DESC_MPORT_TYPE_NET_PORT:
+               attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;

                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


+               attrs.phys.port_number = mport->port_idx;
+               devlink_port_attrs_set(dl_port, &attrs);
+               break;
+       case MAE_MPORT_DESC_MPORT_TYPE_VNIC:
+               if (mport->vf_idx != MAE_MPORT_DESC_VF_IDX_NULL) {
+                       devlink_port_attrs_pci_vf_set(dl_port, 0, mport->pf_idx,
+                                                     mport->vf_idx,
+                                                     external);
+               } else {
+                       devlink_port_attrs_pci_pf_set(dl_port, 0, mport->pf_idx,
+                                                     external);
+               }
+               break;




>
>I'm aware this is not "fully compliant" with devlink design idea, just 
>trying to use it for our current urgent necessities by now.
>
>Do you think this could be a problem?

If you create port flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL and it is not
uplink, it is a problem :)



>
>
>>
>>> +	if (!mport_desc)
>>> +		return -EINVAL;
>>> +
>>> +	if (!ef100_mport_on_local_intf(devlink->efx, mport_desc))
>>> +		goto out;
>>> +
>>> +	if (ef100_mport_is_vf(mport_desc))
>>> +		EFX_POPULATE_QWORD_3(pciefn,
>>> +				     PCIE_FUNCTION_PF, PCIE_FUNCTION_PF_NULL,
>>> +				     PCIE_FUNCTION_VF, mport_desc->vf_idx,
>>> +				     PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
>>> +	else
>>> +		EFX_POPULATE_QWORD_3(pciefn,
>>> +				     PCIE_FUNCTION_PF, mport_desc->pf_idx,
>>> +				     PCIE_FUNCTION_VF, PCIE_FUNCTION_VF_NULL,
>>> +				     PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
>>> +
>>> +	rc = efx_ef100_lookup_client_id(devlink->efx, pciefn, &client_id);
>>> +	if (rc) {
>>> +		netif_err(devlink->efx, drv, devlink->efx->net_dev,
>>> +			  "Failed to get client ID for port index %u, rc %d\n",
>>> +			  port->index, rc);
>>> +		return rc;
>>> +	}
>>> +
>>> +	rc = ef100_get_mac_address(devlink->efx, hw_addr, client_id, true);
>>> +out:
>>> +	*hw_addr_len = ETH_ALEN;
>>> +
>>> +	return rc;
>>> +}
>>> +
>>> static int efx_devlink_info_get(struct devlink *devlink,
>>> 				struct devlink_info_req *req,
>>> 				struct netlink_ext_ack *extack)
>>> @@ -442,6 +485,7 @@ static int efx_devlink_info_get(struct devlink *devlink,
>>>
>>> static const struct devlink_ops sfc_devlink_ops = {
>>> 	.info_get			= efx_devlink_info_get,
>>> +	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
>>> };
>>>
>>> static struct devlink_port *ef100_set_devlink_port(struct efx_nic *efx, u32 idx)
>>> -- 
>>> 2.17.1
>>>
>
