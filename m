Return-Path: <netdev+bounces-5236-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E234710596
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:11:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 480A32814B8
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 06:11:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3D699479;
	Thu, 25 May 2023 06:11:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9687D6FBF
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 06:11:10 +0000 (UTC)
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F39183
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 23:10:57 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-510b6a24946so3471778a12.0
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 23:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684995055; x=1687587055;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uIhSMKH9uqwbOIJHcQ6Iy8wF6VPBStljM3z9WbMMwE0=;
        b=PBqqHlxc+25JKCf72b1f1tgusX5+v5IZcDx5dYOh9rprsDt0hjvb+tAxbjRJZmb+pS
         mr1sd0WuUZCXUPYp13jNDsHEfl6ykBCH7RczfN06nBWB+Dh4epmX7GDDzKsVLWXxbX94
         ns9JiMrYHTuOgkxbRB+w4Hw9ijd7K7nuF0vIkigW/I1H91nwUVF0oAsBGXnUiXxpkS7Y
         wkhxXBmyQEyeh0s5WRYL5wnoRHWX6nA1u2E20Kto0hPsah1N5QibtlrDDRQF70NDf0GN
         1OkM1IdZFpmisRs2mRp123J8UJg0VoVc3v/YhISc9BWYJ81puG+ptaW7y5H4oj8d9lqM
         GPBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684995055; x=1687587055;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uIhSMKH9uqwbOIJHcQ6Iy8wF6VPBStljM3z9WbMMwE0=;
        b=egpUD2FsEu6DPZtp5PyrpcEOHBuMhKDlryfb/stJTbiooGn//R04PXMlC4vXFuj0Ud
         MKrRAd2bTHdAQRcE3A6315ab02122Cb4xmcCqfUUu775F8p+NfXg0MvaTz6tzjEAzgGB
         RU03d4midexdTvuufngPTCPyRYRfMtiVaR6wHTjRqweFq7sIKISjsMc4G8Y7LUCnGUyk
         FaLMHThSnnZIbF7SuY944dXCiVoBZAfXXvQZHVSwVrpttDUfr7yJIb6DtjXReQspm4SO
         XepeUSSaesWFjXKGNXTFlkB94CwOfXDvFrSpAxfpo7vSBoIBeWSBsH1kZ5Y/mdXTn13E
         cEnA==
X-Gm-Message-State: AC+VfDyaUo1VisbyjdVIroSxdDpvMdZ0TQvREhwf2Bw04r3IfCnf5oMI
	J6n3f4CYMEWpVWeEksJMQMp+Iw==
X-Google-Smtp-Source: ACHHUZ4FY4Bbq0Z1vLXdmH892PF505A0IUWZg8qKajKHOjD4LOdO+kB7fuhKkmdkW7PcFuvg3PMgLw==
X-Received: by 2002:a17:907:7291:b0:96f:e7cf:5004 with SMTP id dt17-20020a170907729100b0096fe7cf5004mr403014ejc.73.1684995055305;
        Wed, 24 May 2023 23:10:55 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id mj22-20020a170906af9600b00971433ed5fesm358032ejb.184.2023.05.24.23.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 23:10:54 -0700 (PDT)
Date: Thu, 25 May 2023 08:10:53 +0200
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
Message-ID: <ZG777R0b631bkN54@nanopsycho>
References: <20230524121836.2070879-1-jiri@resnulli.us>
 <20230524121836.2070879-9-jiri@resnulli.us>
 <24213696-eb18-90ad-8e96-1c26bc1136aa@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24213696-eb18-90ad-8e96-1c26bc1136aa@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Wed, May 24, 2023 at 07:57:50PM CEST, alucerop@amd.com wrote:
>Hi Jiri,
>
>On 5/24/23 13:18, Jiri Pirko wrote:
>> CAUTION: This message has originated from an External Source. Please use proper judgment and caution when opening attachments, clicking links, or responding to this email.

Awesome, could you manage to remove this irrelevant text in your mailer?


>> 
>> 
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Use newly introduce devlink port registration function variant and
>> register devlink port passing ops.
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>>   drivers/net/ethernet/sfc/efx_devlink.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
>> index 381b805659d3..f93437757ba3 100644
>> --- a/drivers/net/ethernet/sfc/efx_devlink.c
>> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
>> @@ -25,6 +25,10 @@ struct efx_devlink {
>>   };
>> 
>>   #ifdef CONFIG_SFC_SRIOV
>> +
>> +static const struct devlink_port_ops sfc_devlink_port_ops = {
>> +};
>> +
>
>We can have devlink port without SRIOV, so we need this outside the previous
>ifdef.

Nope, in the original code, efx_devlink_add_port() is under this ifdef
too. So ifdef-wise, this patch does not change anything. Why do you
think so?


>
>Apart from that, it looks OK. I'll test it and report back.
>
>>   static void efx_devlink_del_port(struct devlink_port *dl_port)
>>   {
>>          if (!dl_port)
>> @@ -57,7 +61,9 @@ static int efx_devlink_add_port(struct efx_nic *efx,
>> 
>>          mport->dl_port.index = mport->mport_id;
>> 
>> -       return devl_port_register(efx->devlink, &mport->dl_port, mport->mport_id);
>> +       return devl_port_register_with_ops(efx->devlink, &mport->dl_port,
>> +                                          mport->mport_id,
>> +                                          &sfc_devlink_port_ops);
>>   }
>> 
>>   static int efx_devlink_port_addr_get(struct devlink_port *port, u8 *hw_addr,
>> --
>> 2.39.2
>> 
>> 

