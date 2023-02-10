Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF58691965
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 08:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbjBJHxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 02:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbjBJHxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 02:53:22 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4047E7AE23
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 23:53:20 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id lu11so13585470ejb.3
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 23:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bqc9OLP6HVAiRKxZfo2V9LbYFTMy+uowDaMJvCMgpXc=;
        b=4hXmkC5MAq6G9otC6kdZO380wdWgeUKhbhtTazUXx+j2H92D/fkD6Y7IVLRRDZjrNc
         cIRR+NNzVWQbl0BBA2qI/k1IW3wGLxUZ/DWBHD7JXby1/NLzY3rLrDikI01UyxsEFV2A
         ypulkT8M+EN8hZByIv0k3aEhsM3CnvIVQ82voQ2yYr6XGTsR3obw5XQtuZi//YnYuTlh
         Le7ShFtB1pzAGOrYtyHlpdv7cstItMy98hnN+7oJxAd7QKs6VBGoA2+Jws3Fg4h2EoXa
         l9bVZ+cDC6KX3j6oOToxpZxFZpTbXjh3ul3G+Issi9/JDsDCRpcsxevUJFfrBUI1QnON
         LVPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bqc9OLP6HVAiRKxZfo2V9LbYFTMy+uowDaMJvCMgpXc=;
        b=LtJPXWAww7gJXkr2ccUFM5fTeS2H4HeGjprMY1g+Qf2iJkAHWXQxD1tvpHRF/LChhw
         JUjJSqAAx9mD2T/W3PXlsMYHRxXk5k5TosgTSwdGpnwvMzk2pzWgoGZXeML81S4imvlU
         YdMdZldq2ghTy8Tk2SATUm3BTMHiLWxVjhRSwNcdiQLs1mMKHwfTzOPb7Gv0SRcvHLaH
         rx8E2RqiVXo9Q+rOmMWgFR2rl83WwzGNdqPX5z4N9eV2+x6+ejvrYeQL7sXWAiEP0kjc
         s6+BI4jXMuv+GHkKRGhEqdhdGtE6lvqaoVsn+hg6/9p0W/kAQe9bQWrKporeY8ACzesE
         73yw==
X-Gm-Message-State: AO0yUKXCDnIKy/ea+3LAkcEkSI1Dfi13TUFcM6h72295LTde3dKXnWDz
        oo8APiDlQ/uNtcFLxuEW+1wCaA==
X-Google-Smtp-Source: AK7set9weJZ52bDw/0bcMSJ3L7gpGYMIz1ZBlYEOb2R+cVZOp5PoSGHviw2P++FB8GaCLHyVKJBiww==
X-Received: by 2002:a17:906:85d2:b0:879:767f:6e45 with SMTP id i18-20020a17090685d200b00879767f6e45mr14764391ejy.17.1676015598685;
        Thu, 09 Feb 2023 23:53:18 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id x27-20020a170906135b00b007ae32daf4b9sm2016151ejb.106.2023.02.09.23.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 23:53:17 -0800 (PST)
Date:   Fri, 10 Feb 2023 08:53:16 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, tariqt@nvidia.com,
        saeedm@nvidia.com, jacob.e.keller@intel.com, gal@nvidia.com,
        kim.phillips@amd.com, moshe@nvidia.com
Subject: Re: [patch net-next 5/7] devlink: convert param list to xarray
Message-ID: <Y+X37DzDakgVVAZL@nanopsycho>
References: <20230209154308.2984602-1-jiri@resnulli.us>
 <20230209154308.2984602-6-jiri@resnulli.us>
 <Y+UjMZre+qzqO4Th@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+UjMZre+qzqO4Th@corigine.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Feb 09, 2023 at 05:45:37PM CET, simon.horman@corigine.com wrote:
>On Thu, Feb 09, 2023 at 04:43:06PM +0100, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Loose the linked list for params and use xarray instead.
>
>I gather this is related to:
>
>[patch net-next 6/7] devlink: allow to call
>        devl_param_driverinit_value_get() without holding instance lock
>
>Perhaps it is worth mentioning that here.

Well I do that in the cover letter. But I will make a note here and in
the other patch too.

Thanks!

>
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>
>Irregardless, this looks good to me.
>
>Reviewed-by: Simon Horman <simon.horman@corigine.com>
>
>...
>
>> diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
>> index bbace07ff063..805c2b7ff468 100644
>> --- a/net/devlink/leftover.c
>> +++ b/net/devlink/leftover.c
>> @@ -3954,26 +3954,22 @@ static int devlink_param_driver_verify(const struct devlink_param *param)
>
>...
>
>>  static struct devlink_param_item *
>> -devlink_param_find_by_id(struct list_head *param_list, u32 param_id)
>> +devlink_param_find_by_id(struct xarray *params, u32 param_id)
>>  {
>> -	struct devlink_param_item *param_item;
>> -
>> -	list_for_each_entry(param_item, param_list, list)
>> -		if (param_item->param->id == param_id)
>> -			return param_item;
>> -	return NULL;
>> +	return xa_load(params, param_id);
>>  }
>
>This change is particularly pleasing :)
>
>...
