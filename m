Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5417F677661
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 09:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjAWIiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 03:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjAWIiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 03:38:50 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1DD16ADE
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 00:38:47 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id tz11so28554413ejc.0
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 00:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gSZzWjs5SAvlBl6Tdc6SnI83bcgAWG76DbcxrJ2xN2g=;
        b=IKgugexzd8+wslpWmVuz2UN8FcjFufdEk2m8xiIPTNKd/uWgVEcBEPvwcCD+OnuCNr
         jKTequpUuF9fG9tnMmN2+O856yQHR5g0ouImALAst/4+MyDAKUc2c8PX9THAVk1IngFE
         wluDvJEJvtqa8/8jhBrVemN6xUdYFUiFrmQ7VdBPAndOpD1W3frC5cNlLG2knrGwd9g5
         01S9r4QICWkM3lBvjmoN2CIECTzqge3SqFZkEMeDot/i4+Tk5oyIjebncpSgC6T95QMj
         SdAaYWZeserrFD5A6xeO4XcRqEty4463py2N06TtNHAYP5gxqkw0+72myMdaIIy26+RC
         bM3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gSZzWjs5SAvlBl6Tdc6SnI83bcgAWG76DbcxrJ2xN2g=;
        b=jsm7QlSBZg/OteIR8nQ6Y7p8Xy2dRgtzfCYaFUdXXJ/RTJyXnB18MA4GCD9+zbMCcV
         tPock7eAbInqdjNw0yLpzvynOsf8GWY5QG98U7LJnVA9viEcUXUuRdWnw0t8E3ehii/q
         QlV5arvo33BiTa/6Z8tnOed5bIpHW6YUGi7RSzctE4xPyRYJvhYBwShZzbtgmw17sTRc
         K0DC2g5jorQ4KVJLTk1WSZrWrwDa6NPWo7MBPBrKN+P3vYB/HOeQPhhK/CQaKXthncdG
         xahnC156vcwfHYIi/yUmc86awbOTK0dAfF8kN892bXO+EUGx2dvWGU+Gx/mcyRe1XVx4
         Lo1w==
X-Gm-Message-State: AFqh2kobfbfhRUAAu7eHs18eVmc6k2gDEIc4uPxVaFzf91+OFwsqVi0A
        R8R8MUzJfW9ds9oheNX/v3hbVw==
X-Google-Smtp-Source: AMrXdXtKib1NiWiIickNgTI0cNL3G0eX3rOgyDW7kb4KTy8DweercNU3uWJBz6VIf/549aH3n4MNVQ==
X-Received: by 2002:a17:907:c388:b0:86e:65c8:6fe3 with SMTP id tm8-20020a170907c38800b0086e65c86fe3mr26774212ejc.7.1674463125679;
        Mon, 23 Jan 2023 00:38:45 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id kv23-20020a17090778d700b008699bacc03csm14485150ejc.14.2023.01.23.00.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 00:38:44 -0800 (PST)
Date:   Mon, 23 Jan 2023 09:38:43 +0100
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
Message-ID: <Y85Hkxb0hIgGevXu@nanopsycho>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
 <20230119113140.20208-7-alejandro.lucero-palau@amd.com>
 <Y8k5glNLX1eE2iKE@nanopsycho>
 <433222dd-cea8-fa93-d0f8-1f4f4272ae91@amd.com>
 <Y8p2GjwVz1FAJ2eH@nanopsycho>
 <ff613fdb-a812-ec30-c00e-82b510fa1df0@amd.com>
 <349dbd31-204c-b68e-9ce5-6c578bdcc4a1@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <349dbd31-204c-b68e-9ce5-6c578bdcc4a1@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jan 22, 2023 at 05:36:14PM CET, alejandro.lucero-palau@amd.com wrote:
>
>On 1/20/23 12:48, Lucero Palau, Alejandro wrote:
>> On 1/20/23 11:08, Jiri Pirko wrote:
>>> Thu, Jan 19, 2023 at 04:09:27PM CET, alejandro.lucero-palau@amd.com wrote:
>>>> On 1/19/23 12:37, Jiri Pirko wrote:
>>>>> Thu, Jan 19, 2023 at 12:31:39PM CET, alejandro.lucero-palau@amd.com wrote:
>>>>>> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>>>>>>
>>>>>> Using the builtin client handle id infrastructure, this patch adds
>>>>>> support for obtaining the mac address linked to mports in ef100. This
>>>>>> implies to execute an MCDI command for getting the data from the
>>>>>> firmware for each devlink port.
>>>>>>
>>>>>> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>>>>>> ---
>>>>>> drivers/net/ethernet/sfc/ef100_nic.c   | 27 ++++++++++++++++
>>>>>> drivers/net/ethernet/sfc/ef100_nic.h   |  1 +
>>>>>> drivers/net/ethernet/sfc/ef100_rep.c   |  8 +++++
>>>>>> drivers/net/ethernet/sfc/ef100_rep.h   |  1 +
>>>>>> drivers/net/ethernet/sfc/efx_devlink.c | 44 ++++++++++++++++++++++++++
>>>>>> 5 files changed, 81 insertions(+)
>>>>>>
>>>>>> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
>>>>>> index f4e913593f2b..4400ce622228 100644
>>>>>> --- a/drivers/net/ethernet/sfc/ef100_nic.c
>>>>>> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
>>>>>> @@ -1121,6 +1121,33 @@ static int ef100_probe_main(struct efx_nic *efx)
>>>>>> 	return rc;
>>>>>> }
>>>>>>
>>>>>> +/* MCDI commands are related to the same device issuing them. This function
>>>>>> + * allows to do an MCDI command on behalf of another device, mainly PFs setting
>>>>>> + * things for VFs.
>>>>>> + */
>>>>>> +int efx_ef100_lookup_client_id(struct efx_nic *efx, efx_qword_t pciefn, u32 *id)
>>>>>> +{
>>>>>> +	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CLIENT_HANDLE_OUT_LEN);
>>>>>> +	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_CLIENT_HANDLE_IN_LEN);
>>>>>> +	u64 pciefn_flat = le64_to_cpu(pciefn.u64[0]);
>>>>>> +	size_t outlen;
>>>>>> +	int rc;
>>>>>> +
>>>>>> +	MCDI_SET_DWORD(inbuf, GET_CLIENT_HANDLE_IN_TYPE,
>>>>>> +		       MC_CMD_GET_CLIENT_HANDLE_IN_TYPE_FUNC);
>>>>>> +	MCDI_SET_QWORD(inbuf, GET_CLIENT_HANDLE_IN_FUNC,
>>>>>> +		       pciefn_flat);
>>>>>> +
>>>>>> +	rc = efx_mcdi_rpc(efx, MC_CMD_GET_CLIENT_HANDLE, inbuf, sizeof(inbuf),
>>>>>> +			  outbuf, sizeof(outbuf), &outlen);
>>>>>> +	if (rc)
>>>>>> +		return rc;
>>>>>> +	if (outlen < sizeof(outbuf))
>>>>>> +		return -EIO;
>>>>>> +	*id = MCDI_DWORD(outbuf, GET_CLIENT_HANDLE_OUT_HANDLE);
>>>>>> +	return 0;
>>>>>> +}
>>>>>> +
>>>>>> int ef100_probe_netdev_pf(struct efx_nic *efx)
>>>>>> {
>>>>>> 	struct ef100_nic_data *nic_data = efx->nic_data;
>>>>>> diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
>>>>>> index e59044072333..f1ed481c1260 100644
>>>>>> --- a/drivers/net/ethernet/sfc/ef100_nic.h
>>>>>> +++ b/drivers/net/ethernet/sfc/ef100_nic.h
>>>>>> @@ -94,4 +94,5 @@ int ef100_filter_table_probe(struct efx_nic *efx);
>>>>>>
>>>>>> int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address,
>>>>>> 			  int client_handle, bool empty_ok);
>>>>>> +int efx_ef100_lookup_client_id(struct efx_nic *efx, efx_qword_t pciefn, u32 *id);
>>>>>> #endif	/* EFX_EF100_NIC_H */
>>>>>> diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
>>>>>> index ff0c8da61919..974c9ff901a0 100644
>>>>>> --- a/drivers/net/ethernet/sfc/ef100_rep.c
>>>>>> +++ b/drivers/net/ethernet/sfc/ef100_rep.c
>>>>>> @@ -362,6 +362,14 @@ bool ef100_mport_on_local_intf(struct efx_nic *efx,
>>>>>> 		     mport_desc->interface_idx == nic_data->local_mae_intf;
>>>>>> }
>>>>>>
>>>>>> +bool ef100_mport_is_vf(struct mae_mport_desc *mport_desc)
>>>>>> +{
>>>>>> +	bool pcie_func;
>>>>>> +
>>>>>> +	pcie_func = ef100_mport_is_pcie_vnic(mport_desc);
>>>>>> +	return pcie_func && (mport_desc->vf_idx != MAE_MPORT_DESC_VF_IDX_NULL);
>>>>>> +}
>>>>>> +
>>>>>> void efx_ef100_init_reps(struct efx_nic *efx)
>>>>>> {
>>>>>> 	struct ef100_nic_data *nic_data = efx->nic_data;
>>>>>> diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
>>>>>> index 9cca41614982..74853ccbc937 100644
>>>>>> --- a/drivers/net/ethernet/sfc/ef100_rep.h
>>>>>> +++ b/drivers/net/ethernet/sfc/ef100_rep.h
>>>>>> @@ -75,4 +75,5 @@ void efx_ef100_fini_reps(struct efx_nic *efx);
>>>>>> struct mae_mport_desc;
>>>>>> bool ef100_mport_on_local_intf(struct efx_nic *efx,
>>>>>> 			       struct mae_mport_desc *mport_desc);
>>>>>> +bool ef100_mport_is_vf(struct mae_mport_desc *mport_desc);
>>>>>> #endif /* EF100_REP_H */
>>>>>> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
>>>>>> index bb19d3ad7ffd..2a57c4f6d2b2 100644
>>>>>> --- a/drivers/net/ethernet/sfc/efx_devlink.c
>>>>>> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
>>>>>> @@ -429,6 +429,49 @@ static int efx_devlink_add_port(struct efx_nic *efx,
>>>>>> 	return err;
>>>>>> }
>>>>>>
>>>>>> +static int efx_devlink_port_addr_get(struct devlink_port *port, u8 *hw_addr,
>>>>>> +				     int *hw_addr_len,
>>>>>> +				     struct netlink_ext_ack *extack)
>>>>>> +{
>>>>>> +	struct efx_devlink *devlink = devlink_priv(port->devlink);
>>>>>> +	struct mae_mport_desc *mport_desc;
>>>>>> +	efx_qword_t pciefn;
>>>>>> +	u32 client_id;
>>>>>> +	int rc = 0;
>>>>>> +
>>>>>> +	mport_desc = efx_mae_get_mport(devlink->efx, port->index);
>>>>> I may be missing something, where do you fail with -EOPNOTSUPP
>>>>> in case this is called for PHYSICAL port ?
>>>>>
>>>> We do not create a devlink port for the physical port.
>>> Well, you do:
>>>
>>> +       switch (mport->mport_type) {
>>> +       case MAE_MPORT_DESC_MPORT_TYPE_NET_PORT:
>>> +               attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
>>>
>>>                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> Right.
>>
>> I was relying on devlink-port output which does not show the physical
>> port in my machine and completely forgot about it.
>>
>> I'm a bit confused at this point. Let me look at this further.
>>
>The reason devlink show/info does not report the PHYSICAL port is 
>simple: current code does not create a devlink port for such mport.
>
>I say current code because in my first implementation (not upstreamed) I 
>just created devlink ports when the mports where enumerated, what turned 
>out to be a bit complicated for dealing with VFs creation/destruction, 
>and after looking at how other drivers do this, just before the related 
>netdev is registered, I went for that same approach. That leaves no 
>option for the physical mport registered.
>
>I could add that creation at PF devlink port creation, if we consider 
>this a necessity. I know the ideal devlink support in our driver should 
>likely be more devlink design compliant, but it is also true drivers 
>should make use of it as decided for fulfilling their necessities as 
>long as it does not create confusion to users. Our current devlink 
>necessity is for dealing with setting VFs mac address as required during 
>previous representors patchset review:
>
>https://lore.kernel.org/netdev/20220728092008.2117846e@kernel.org/
>
>Do you see a problem not creating such a devlink port by now?

You don't have to create it. But loose the code setting PHYSICAL
flavour.



>
>>> +               attrs.phys.port_number = mport->port_idx;
>>> +               devlink_port_attrs_set(dl_port, &attrs);
>>> +               break;
>>> +       case MAE_MPORT_DESC_MPORT_TYPE_VNIC:
>>> +               if (mport->vf_idx != MAE_MPORT_DESC_VF_IDX_NULL) {
>>> +                       devlink_port_attrs_pci_vf_set(dl_port, 0, mport->pf_idx,
>>> +                                                     mport->vf_idx,
>>> +                                                     external);
>>> +               } else {
>>> +                       devlink_port_attrs_pci_pf_set(dl_port, 0, mport->pf_idx,
>>> +                                                     external);
>>> +               }
>>> +               break;
>>>
>>>
>>>
>>>
>>>> I'm aware this is not "fully compliant" with devlink design idea, just
>>>> trying to use it for our current urgent necessities by now.
>>>>
>>>> Do you think this could be a problem?
>>> If you create port flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL and it is not
>>> uplink, it is a problem :)
>>>
>>>
>>>
>>>>>> +	if (!mport_desc)
>>>>>> +		return -EINVAL;
>>>>>> +
>>>>>> +	if (!ef100_mport_on_local_intf(devlink->efx, mport_desc))
>>>>>> +		goto out;
>>>>>> +
>>>>>> +	if (ef100_mport_is_vf(mport_desc))
>>>>>> +		EFX_POPULATE_QWORD_3(pciefn,
>>>>>> +				     PCIE_FUNCTION_PF, PCIE_FUNCTION_PF_NULL,
>>>>>> +				     PCIE_FUNCTION_VF, mport_desc->vf_idx,
>>>>>> +				     PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
>>>>>> +	else
>>>>>> +		EFX_POPULATE_QWORD_3(pciefn,
>>>>>> +				     PCIE_FUNCTION_PF, mport_desc->pf_idx,
>>>>>> +				     PCIE_FUNCTION_VF, PCIE_FUNCTION_VF_NULL,
>>>>>> +				     PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
>>>>>> +
>>>>>> +	rc = efx_ef100_lookup_client_id(devlink->efx, pciefn, &client_id);
>>>>>> +	if (rc) {
>>>>>> +		netif_err(devlink->efx, drv, devlink->efx->net_dev,
>>>>>> +			  "Failed to get client ID for port index %u, rc %d\n",
>>>>>> +			  port->index, rc);
>>>>>> +		return rc;
>>>>>> +	}
>>>>>> +
>>>>>> +	rc = ef100_get_mac_address(devlink->efx, hw_addr, client_id, true);
>>>>>> +out:
>>>>>> +	*hw_addr_len = ETH_ALEN;
>>>>>> +
>>>>>> +	return rc;
>>>>>> +}
>>>>>> +
>>>>>> static int efx_devlink_info_get(struct devlink *devlink,
>>>>>> 				struct devlink_info_req *req,
>>>>>> 				struct netlink_ext_ack *extack)
>>>>>> @@ -442,6 +485,7 @@ static int efx_devlink_info_get(struct devlink *devlink,
>>>>>>
>>>>>> static const struct devlink_ops sfc_devlink_ops = {
>>>>>> 	.info_get			= efx_devlink_info_get,
>>>>>> +	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
>>>>>> };
>>>>>>
>>>>>> static struct devlink_port *ef100_set_devlink_port(struct efx_nic *efx, u32 idx)
>>>>>> -- 
>>>>>> 2.17.1
>>>>>>
>
