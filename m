Return-Path: <netdev+bounces-5395-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9776C711164
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:53:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B66262815BE
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:52:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08226156F5;
	Thu, 25 May 2023 16:52:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB773D7C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 16:52:56 +0000 (UTC)
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2220135
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:52:54 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-510d6e1f1abso5147331a12.2
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685033573; x=1687625573;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xH4UmUwe1ddt6BWOnlLuQ5rDsIxj5iWcbYBCRyV7Ox4=;
        b=zgmvAoYUoeNegHAgVezgRL9kUuRLre73R1EtylH0sqCVgwBa4H1NVS+Ni6z8ipvgVy
         AChGacMFuOv5c4ocnL4+3abYpLKLRTIEDOhJfd8s8g11CFuuenx+Ug0BRJIRUp01ni66
         q3v6xKY8+fGBZiLANmzz1wsYFJcOjNVLSfIh6RMpLeEDUN1coiEDEeQMT7BB9+LqqdCI
         v7aA9qFSZvRNBCTYG+u/3szIbDKWm7virMRl+aUdACp4u2x2OiEEHbQXdJIYhm6WznnZ
         /8E5Lb6L3QkE8xectOqFoZjxOGWyh1e+t1Jktvz01alnkxSR6jbdT9s4zRE6zsH0Mbls
         YjxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685033573; x=1687625573;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xH4UmUwe1ddt6BWOnlLuQ5rDsIxj5iWcbYBCRyV7Ox4=;
        b=SEIrFvTrOd6lH10xvxfmnfVbK5oy8V8LWGKqOY7JXVQl2oy1RQRxUA/dKOw1B+dXOA
         sJTYJtTOsv58+cuSOWGPCuDqzH6O3sqSTAFVYtP5I5oFSIOIRzCrV/3B5nRqe9ivWKRd
         Ixtsj8IWuIDpvec421mzzgX4qB4I+lT+XWHqm1yXY8+SVYYpu37S5pA3DoAORuUS35EM
         PnevcyAo48TlUqe7i7RJ0hq1VfjY/fIZ2EHueSWwn0E89ZTYe7tc2whDC9lr/ztzh579
         D/U2ndDIXCdzOLII2UbGo+lR4a8UO9VUCLTDznNis6xIE11XgRgc4sxf2Qmu8cyoMjNx
         Q5hw==
X-Gm-Message-State: AC+VfDyV2GcPjujIgUYnpybxbSwllTvFPqb2CcbOXhWhlxsFBQHinEYE
	kEi7pDPMLHaXGb2Lg6aBZEuH5g==
X-Google-Smtp-Source: ACHHUZ7qqTYpBUMfzKee9x57TywA+/7LeFilmCFgiRXeqphexZVj4AKkcKiEwfAAApEjN89/XEJINw==
X-Received: by 2002:a17:907:961a:b0:96f:e7cf:5015 with SMTP id gb26-20020a170907961a00b0096fe7cf5015mr3143645ejc.17.1685033573308;
        Thu, 25 May 2023 09:52:53 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id d27-20020a056402517b00b0050c0d651fb1sm725543ede.75.2023.05.25.09.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 09:52:52 -0700 (PDT)
Date: Thu, 25 May 2023 18:52:51 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Alejandro Lucero Palau <alucerop@amd.com>
Cc: netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	davem@davemloft.net, edumazet@google.com, leon@kernel.org,
	saeedm@nvidia.com, moshe@nvidia.com, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, tariqt@nvidia.com, idosch@nvidia.com,
	petrm@nvidia.com, simon.horman@corigine.com, ecree.xilinx@gmail.com,
	habetsm.xilinx@gmail.com, michal.wilczynski@intel.com,
	jacob.e.keller@intel.com
Subject: Re: [patch net-next 08/15] sfc: register devlink port with ops
Message-ID: <ZG+SY1rfCaBsbp6K@nanopsycho>
References: <20230524121836.2070879-1-jiri@resnulli.us>
 <20230524121836.2070879-9-jiri@resnulli.us>
 <24213696-eb18-90ad-8e96-1c26bc1136aa@amd.com>
 <90e4c411-4159-2836-acbd-c1e7a9c7ce37@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <90e4c411-4159-2836-acbd-c1e7a9c7ce37@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thu, May 25, 2023 at 05:13:57PM CEST, alucerop@amd.com wrote:
>
>On 5/24/23 18:57, Alejandro Lucero Palau wrote:
>> Hi Jiri,
>> 
>> On 5/24/23 13:18, Jiri Pirko wrote:
>> > 
>> > From: Jiri Pirko <jiri@nvidia.com>
>> > 
>> > Use newly introduce devlink port registration function variant and
>> > register devlink port passing ops.
>> > 
>> > Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> > ---
>> >   drivers/net/ethernet/sfc/efx_devlink.c | 8 +++++++-
>> >   1 file changed, 7 insertions(+), 1 deletion(-)
>> > 
>> > diff --git a/drivers/net/ethernet/sfc/efx_devlink.c
>> > b/drivers/net/ethernet/sfc/efx_devlink.c
>> > index 381b805659d3..f93437757ba3 100644
>> > --- a/drivers/net/ethernet/sfc/efx_devlink.c
>> > +++ b/drivers/net/ethernet/sfc/efx_devlink.c
>> > @@ -25,6 +25,10 @@ struct efx_devlink {
>> >   };
>> > 
>> >   #ifdef CONFIG_SFC_SRIOV
>> > +
>> > +static const struct devlink_port_ops sfc_devlink_port_ops = {
>> > +};
>> > +
>> 
>> We can have devlink port without SRIOV, so we need this outside the
>> previous ifdef.
>> 
>> Apart from that, it looks OK. I'll test it and report back.
>> 
>Apart from the change requested:

Did you see the reply to your email?

>
>Reviewed-by: Alejandro Lucero<alucerop@amd.com>
>Tested-by: Alejandro Lucero<alucerop@amd.com>
>
>> >   static void efx_devlink_del_port(struct devlink_port *dl_port)
>> >   {
>> >          if (!dl_port)
>> > @@ -57,7 +61,9 @@ static int efx_devlink_add_port(struct efx_nic *efx,
>> > 
>> >          mport->dl_port.index = mport->mport_id;
>> > 
>> > -       return devl_port_register(efx->devlink, &mport->dl_port,
>> > mport->mport_id);
>> > +       return devl_port_register_with_ops(efx->devlink,
>> > &mport->dl_port,
>> > +                                          mport->mport_id,
>> > + &sfc_devlink_port_ops);
>> >   }
>> > 
>> >   static int efx_devlink_port_addr_get(struct devlink_port *port, u8
>> > *hw_addr,
>> > -- 
>> > 2.39.2
>> > 
>> > 
>> 

