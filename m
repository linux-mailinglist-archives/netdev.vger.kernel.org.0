Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E216752FB
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 12:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjATLF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 06:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjATLF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 06:05:57 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2C9B27B9
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 03:05:56 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id b4so6390870edf.0
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 03:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k8rhYIFp5k3jfcxxoRDM+Fh/fp6UIIdbOl02xwUWFno=;
        b=LnQ/tLbH+WiKejCdOi52LZldU5znntWZuBFjb9WGPdDlHwNyOxpX7lGhKi4xO+wYB4
         n87D0Hw8ZeQnnv+RrQUQ888tauVECSJSDChkNOJ+7PoqUTLbQinf7Wuj0zPgVbUsSJnv
         6Z6snB6EVey5B7gjbiZiZdfbVtxyn7sXyZN71k3ttU4R+OiCFEXTzPP3EpK0un12pvIp
         yxaof8zxfEVW7k7WELakQSkyKspED0YMfkynSqbAhBFNWPksALRix3g1hdyV8q9UAxry
         07UJ7qF8dTXpq+ma+JbyTt0mYJtMwJx79XiTm7UpH8dStqJOrmEg8w8tC6s2WxkaKwfU
         XOqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k8rhYIFp5k3jfcxxoRDM+Fh/fp6UIIdbOl02xwUWFno=;
        b=xX8qti9wQ3eoIObOPm8gZH0eFB9RKdE+fcr/+sfRdYB7l6a8EBf9sEOaesiuAsKYii
         JvmymLNYkOl3hYIzgoIQEWLQSpAoEME2pfgBgQJoWQsfF7uo27F55xtk6G9CSUq7P1sb
         ylZN9PlHoIw2OkUOOpWnqE7cnINjsmmWJolZ9d/0b5EmiFB+Q9FOzg+AjdxpRdwzwzLP
         B+2+u5pUF2qw9ND3yyf6EjfNuzscS+qs4x1MtiDzXODtnGWK0fVWnZwjeInSt14XOJO2
         BCD2qVZOHLRA2f+uQgpkpcVAEVMhQs2XsZAd9k347kaANewb0WsBNoxbDzMDRqcqBqzn
         CyuA==
X-Gm-Message-State: AFqh2krGW6MTzEs2gyTEb+CCFHZ27jc/Q6k31CmR/lQf+rWOBabTY3mt
        8HCfEJr7semQsVb/euLjWx/TEw==
X-Google-Smtp-Source: AMrXdXtFgBikpJLVn4utF3/gBHjbc+u8wuQICCLs7JDK1CDObs7BOBMz0Cj7QucBtydaZaX3vPrBIw==
X-Received: by 2002:a05:6402:44:b0:497:233d:3ef6 with SMTP id f4-20020a056402004400b00497233d3ef6mr14333536edu.17.1674212754589;
        Fri, 20 Jan 2023 03:05:54 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id q5-20020aa7d445000000b00482b3d0e1absm17084364edr.87.2023.01.20.03.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 03:05:54 -0800 (PST)
Date:   Fri, 20 Jan 2023 12:05:52 +0100
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
Message-ID: <Y8p1kNvS4ofl1g2h@nanopsycho>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
 <20230119113140.20208-7-alejandro.lucero-palau@amd.com>
 <Y8k2wkaNX+BPqmq6@nanopsycho>
 <5db90827-a93b-d876-a312-420278c8caa5@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5db90827-a93b-d876-a312-420278c8caa5@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 19, 2023 at 03:59:40PM CET, alejandro.lucero-palau@amd.com wrote:
>
>On 1/19/23 12:25, Jiri Pirko wrote:
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
>> Dont use port->index, never. It's devlink internal. You have port
>> pointer passed here. Usually, what drivers do is to embed
>> the struct devlink_port in the driver port struct. Then you do just
>> simple container of to get it here. Mlxsw example:
>
>I do not understand this. Port index is set by the driver not by the 
>devlink interface implementation.
>
>Why can I not use it?

Well you can, but things could be done much nicer, when you use
devlink_port pointer. Also, better not to access devlink_port struct
internals, driver should never need it.


>
>> static void *__dl_port(struct devlink_port *devlink_port)
>> {
>>          return container_of(devlink_port, struct mlxsw_core_port, devlink_port);
>> }
>>
>> static int mlxsw_devlink_port_split(struct devlink *devlink,
>>                                      struct devlink_port *port,
>>                                      unsigned int count,
>>                                      struct netlink_ext_ack *extack)
>> {
>>          struct mlxsw_core_port *mlxsw_core_port = __dl_port(port);
>> ...
>>
>>
>>
>>> +	if (!mport_desc)
>> Tell the user what's wrong, extack is here for that.
>>
>I'll do.
>>
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
>> Don't write to dmesg, use extack msg instead.
>
>
>I'll do.
>
>Thanks
>
>>
>>> +		return rc;
>>> +	}
>>> +
>>> +	rc = ef100_get_mac_address(devlink->efx, hw_addr, client_id, true);
>> Again, extack would be nice here if (rc)
>>
>Again, I'll do.
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
