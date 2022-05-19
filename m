Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F3652D42E
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 15:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238795AbiESNkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 09:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238806AbiESNkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 09:40:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 03EE2BDA0B
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 06:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652967634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xt+aN/3TTM6whRIIXGp3XXNl6AMYbySHQ4hGqaG4JYM=;
        b=fwetRaXZybf7Hs271nmGqiePr6rc4S8Bxgq6KmFfiuAxBwDaK7q39ADUCE1tU1yvtlhOxC
        la8M+D/MOat9t99mNZLENHR0ji+uhb4MWeVr8ccKFxnl5XJuiMQKFTnxc7yJQUA/GIs5BY
        GxkLs8qCTm2ZC65VWqm13LKDoNilwbU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-FvEsijReMOa24BrhmF9VCw-1; Thu, 19 May 2022 09:40:33 -0400
X-MC-Unique: FvEsijReMOa24BrhmF9VCw-1
Received: by mail-wr1-f69.google.com with SMTP id s16-20020adfeb10000000b0020cc4e5e683so1574436wrn.6
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 06:40:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Xt+aN/3TTM6whRIIXGp3XXNl6AMYbySHQ4hGqaG4JYM=;
        b=x9KSrU10Lb8huq/3eG9yCXLlLhOgHpn0/bszKzHpslOYBhjYWh3fiEUl+iIxe8dLhC
         GHS56cm88bNueiGWVwxqx9+APmum4koDpF4NU9UyMDwq7lGV0MXiU54PkzubAo3rIKxR
         EiJnX5N3EPJRunD1pC0J26OI6m9qcqcWa7YAj4xjDzfTKSKj3LEaPLqWoj/uhHSKouVC
         XUHB2ZVbjY+lE+K0p5rsBzWgrg/5PjmLmHuvm2Cnp9SAqCRpAAZsQdj6pjzHZNtszeig
         w/ApAzXbQozEm7JAcddZinivl8bihK3jX7fWe8d4iM3Yn+RnwvZWCQqKnuQqLn7mTex2
         Wb8g==
X-Gm-Message-State: AOAM532ZmJGDoBcb08fDqjSn5/xCTj8Xiq6Ehm2Hu0XSE0cYkeqA/gsI
        DTn+bhK16hLeXrvtnG3gxVTMK0Gi7JipjUca49iguRSxyUIxw8ZOGTdMSA/DdK5htZxOO+ay9Ch
        bVtOmN+OIOK8OWKBA
X-Received: by 2002:a05:6000:cd:b0:20e:5e59:b4b3 with SMTP id q13-20020a05600000cd00b0020e5e59b4b3mr3917641wrx.519.1652967631423;
        Thu, 19 May 2022 06:40:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylQV7Bg96J1uKsR9MJp5ioWkT7mLUM0KTOCKauI8ylT/N5BFrRyuaa4PSrICwdei2VnytMbA==
X-Received: by 2002:a05:6000:cd:b0:20e:5e59:b4b3 with SMTP id q13-20020a05600000cd00b0020e5e59b4b3mr3917622wrx.519.1652967631184;
        Thu, 19 May 2022 06:40:31 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id c13-20020adfc04d000000b0020d0351dbb6sm5254098wrf.80.2022.05.19.06.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 06:40:30 -0700 (PDT)
Message-ID: <a4438af4d2a45b137172ed24f4ca362f8e4bf143.camel@redhat.com>
Subject: Re: [PATCH net-next 2/3] ice: add i2c write command
From:   Paolo Abeni <pabeni@redhat.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com
Cc:     Karol Kolacinski <karol.kolacinski@intel.com>,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        Gurucharan <gurucharanx.g@intel.com>
Date:   Thu, 19 May 2022 15:40:29 +0200
In-Reply-To: <20220517211935.1949447-3-anthony.l.nguyen@intel.com>
References: <20220517211935.1949447-1-anthony.l.nguyen@intel.com>
         <20220517211935.1949447-3-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-05-17 at 14:19 -0700, Tony Nguyen wrote:
> From: Karol Kolacinski <karol.kolacinski@intel.com>
> 
> Add the possibility to write to connected i2c devices using the AQ
> command. FW may reject the write if the device is not on allowlist.
> 
> Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
> Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  7 +--
>  drivers/net/ethernet/intel/ice/ice_common.c   | 51 ++++++++++++++++++-
>  drivers/net/ethernet/intel/ice/ice_common.h   |  4 ++
>  3 files changed, 58 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
> index b25e27c4d887..bedc19f12cbd 100644
> --- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
> +++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
> @@ -1401,7 +1401,7 @@ struct ice_aqc_get_link_topo {
>  	u8 rsvd[9];
>  };
>  
> -/* Read I2C (direct, 0x06E2) */
> +/* Read/Write I2C (direct, 0x06E2/0x06E3) */
>  struct ice_aqc_i2c {
>  	struct ice_aqc_link_topo_addr topo_addr;
>  	__le16 i2c_addr;
> @@ -1411,7 +1411,7 @@ struct ice_aqc_i2c {
>  
>  	u8 rsvd;
>  	__le16 i2c_bus_addr;
> -	u8 rsvd2[4];
> +	u8 i2c_data[4]; /* Used only by write command, reserved in read. */
>  };
>  
>  /* Read I2C Response (direct, 0x06E2) */
> @@ -2130,7 +2130,7 @@ struct ice_aq_desc {
>  		struct ice_aqc_get_link_status get_link_status;
>  		struct ice_aqc_event_lan_overflow lan_overflow;
>  		struct ice_aqc_get_link_topo get_link_topo;
> -		struct ice_aqc_i2c read_i2c;
> +		struct ice_aqc_i2c read_write_i2c;
>  		struct ice_aqc_read_i2c_resp read_i2c_resp;
>  	} params;
>  };
> @@ -2247,6 +2247,7 @@ enum ice_adminq_opc {
>  	ice_aqc_opc_set_mac_lb				= 0x0620,
>  	ice_aqc_opc_get_link_topo			= 0x06E0,
>  	ice_aqc_opc_read_i2c				= 0x06E2,
> +	ice_aqc_opc_write_i2c				= 0x06E3,
>  	ice_aqc_opc_set_port_id_led			= 0x06E9,
>  	ice_aqc_opc_set_gpio				= 0x06EC,
>  	ice_aqc_opc_get_gpio				= 0x06ED,
> diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
> index 9619bdb9e49a..1999c19a786e 100644
> --- a/drivers/net/ethernet/intel/ice/ice_common.c
> +++ b/drivers/net/ethernet/intel/ice/ice_common.c
> @@ -4823,7 +4823,7 @@ ice_aq_read_i2c(struct ice_hw *hw, struct ice_aqc_link_topo_addr topo_addr,
>  	int status;
>  
>  	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_read_i2c);
> -	cmd = &desc.params.read_i2c;
> +	cmd = &desc.params.read_write_i2c;
>  
>  	if (!data)
>  		return -EINVAL;
> @@ -4850,6 +4850,55 @@ ice_aq_read_i2c(struct ice_hw *hw, struct ice_aqc_link_topo_addr topo_addr,
>  	return status;
>  }
>  
> +/**
> + * ice_aq_write_i2c
> + * @hw: pointer to the hw struct
> + * @topo_addr: topology address for a device to communicate with
> + * @bus_addr: 7-bit I2C bus address
> + * @addr: I2C memory address (I2C offset) with up to 16 bits
> + * @params: I2C parameters: bit [4] - I2C address type, bits [3:0] - data size to write (0-7 bytes)
> + * @data: pointer to data (0 to 4 bytes) to be written to the I2C device
> + * @cd: pointer to command details structure or NULL
> + *
> + * Write I2C (0x06E3)
> + *
> + * * Return:
> + * * 0             - Successful write to the i2c device
> + * * -EINVAL       - Data size greater than 4 bytes
> + * * -EIO          - FW error
> + */
> +int
> +ice_aq_write_i2c(struct ice_hw *hw, struct ice_aqc_link_topo_addr topo_addr,
> +		 u16 bus_addr, __le16 addr, u8 params, u8 *data,
> +		 struct ice_sq_cd *cd)
> +{
> +	struct ice_aq_desc desc = { 0 };
> +	struct ice_aqc_i2c *cmd;
> +	unsigned int i;
> +	u8 data_size;
> +
> +	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_write_i2c);
> +	cmd = &desc.params.read_write_i2c;
> +
> +	data_size = FIELD_GET(ICE_AQC_I2C_DATA_SIZE_M, params);
> +
> +	/* data_size limited to 4 */
> +	if (data_size > 4)
> +		return -EINVAL;
> +
> +	cmd->i2c_bus_addr = cpu_to_le16(bus_addr);
> +	cmd->topo_addr = topo_addr;
> +	cmd->i2c_params = params;
> +	cmd->i2c_addr = addr;
> +
> +	for (i = 0; i < data_size; i++) {
> +		cmd->i2c_data[i] = *data;
> +		data++;
> +	}

Why not:
	memcpy(cmd->i2c_data, data, data_size);

	?

Thanks!

Paolo

