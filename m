Return-Path: <netdev+bounces-6278-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 034D97157D9
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:02:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B23182810B6
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 08:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C4E612B61;
	Tue, 30 May 2023 08:02:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AAA125DA
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 08:02:29 +0000 (UTC)
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C03DA8
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:02:28 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-969f90d71d4so592907866b.3
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685433747; x=1688025747;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xwR6Wu22KumKpt+V33UqOp7Mdg6vQFjb4wCxUlMDLEc=;
        b=B92hwELfGDIPd7CV2CcRjSG3E3GWKfrR3aizWV2F11nmdw7XfaLrfIUJboDgk9ht1x
         w95CmDzT5HOcQhe6DLv/ifnuggLbd1ht70hLPXP/fbhviauK2dbo1kdwfAO6YslCmfcI
         MbqJeCBAh9Td8JFjQQd9cNqlofin/jdLkFtHKpY0VrkV9/+keHq2DbGpHYhLyjlCoMbW
         YWxA7EeAVc+eHAtS+gxvjxtLVn/bUJZMtI9kRCJWlmhFw/FymvPxs5SgRqkBYu6pP9mv
         uSo+IDt8Fjz8D4UnDYMcjNBmx7TcO5vNBxLz+b6/vMUu15v/PuzxxWpR9Z4OgLqet462
         3xCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685433747; x=1688025747;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xwR6Wu22KumKpt+V33UqOp7Mdg6vQFjb4wCxUlMDLEc=;
        b=ho9Ev2jYPbBAWsMYIFihN5A7q5ytrGRieJAlxP96eYSeCB530f3BcH2/FczfF2DlqJ
         d4dVacrxmbGx8QCjNld4pYRVTlvmv+o7bmTpsL1zsPgavJkLURVK3Bvjpr0sQmDY14gI
         asjhr2TlJDCW5ePGADp28Ju1DNFVAYyvgzlieru0C8wMpFFysJ1YnrkrS1JMfTWxiVs8
         XGRRqAAFb9D+0VJaFjTEvW4SO57IJYy7bt6C8ke8WHwZtaXg+DiAvUQlCThjdu25AmUC
         rlees9rl+tEKL9vqyc7WDO+OZUYI3PggXzMIQRzjUvdQ/6QeC2m3MynIIH15m0Dw92Nm
         uIhQ==
X-Gm-Message-State: AC+VfDyNS9d1C7+qIoUr7cUYuAYcHRpEmhe+Etu5+MHEDyDHNQ2BIXFu
	4WF+ktt5kJvvw7dSEpVyl4o=
X-Google-Smtp-Source: ACHHUZ6wnGHVdN9tlN9TWhbB5D6IAOWoyqzvYnQd21aEVItfsrilnPTGJCmWm8grXBoMLuTG3HcKFQ==
X-Received: by 2002:a17:907:d25:b0:968:1102:1fb7 with SMTP id gn37-20020a1709070d2500b0096811021fb7mr2028159ejc.6.1685433746871;
        Tue, 30 May 2023 01:02:26 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id k10-20020aa7c04a000000b00514aef7daacsm633335edo.76.2023.05.30.01.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 01:02:26 -0700 (PDT)
Date: Tue, 30 May 2023 09:02:23 +0100
From: Martin Habets <habetsm.xilinx@gmail.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	davem@davemloft.net, edumazet@google.com, leon@kernel.org,
	saeedm@nvidia.com, moshe@nvidia.com, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, tariqt@nvidia.com, idosch@nvidia.com,
	petrm@nvidia.com, simon.horman@corigine.com, ecree.xilinx@gmail.com,
	michal.wilczynski@intel.com, jacob.e.keller@intel.com
Subject: Re: [patch net-next v2 08/15] sfc: register devlink port with ops
Message-ID: <ZHWtjypFWqM37xyy@gmail.com>
Mail-Followup-To: Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
	kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
	edumazet@google.com, leon@kernel.org, saeedm@nvidia.com,
	moshe@nvidia.com, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, tariqt@nvidia.com, idosch@nvidia.com,
	petrm@nvidia.com, simon.horman@corigine.com, ecree.xilinx@gmail.com,
	michal.wilczynski@intel.com, jacob.e.keller@intel.com
References: <20230526102841.2226553-1-jiri@resnulli.us>
 <20230526102841.2226553-9-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526102841.2226553-9-jiri@resnulli.us>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 12:28:34PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Use newly introduce devlink port registration function variant and
> register devlink port passing ops.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/efx_devlink.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
> index ef9971cbb695..e74f74037405 100644
> --- a/drivers/net/ethernet/sfc/efx_devlink.c
> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
> @@ -25,6 +25,10 @@ struct efx_devlink {
>  };
>  
>  #ifdef CONFIG_SFC_SRIOV
> +
> +static const struct devlink_port_ops sfc_devlink_port_ops = {
> +};
> +
>  static void efx_devlink_del_port(struct devlink_port *dl_port)
>  {
>  	if (!dl_port)
> @@ -57,7 +61,9 @@ static int efx_devlink_add_port(struct efx_nic *efx,
>  
>  	mport->dl_port.index = mport->mport_id;
>  
> -	return devl_port_register(efx->devlink, &mport->dl_port, mport->mport_id);
> +	return devl_port_register_with_ops(efx->devlink, &mport->dl_port,
> +					   mport->mport_id,
> +					   &sfc_devlink_port_ops);
>  }
>  
>  static int efx_devlink_port_addr_get(struct devlink_port *port, u8 *hw_addr,
> -- 
> 2.39.2

