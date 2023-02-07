Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0842668DC55
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 15:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbjBGO7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 09:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbjBGO6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 09:58:54 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDAB1352B
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 06:58:42 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id p26so43687263ejx.13
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 06:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wN/KmcWvC+g0rh8netV1xvNHoPshMB2frZ8aZYdI71A=;
        b=7xx3heBEKb1UFkq+GMecG30p+lzfOg8OPYf8e7eCscqw8EjPCCnOhrWHkajaBYmrAA
         7PXSRBDVm9zXAHAp/d5z4CqftVk7r+tyuUHBdrx5bxd/kA/v6y2Cvmb3SC+97rnhnQAM
         jv/lvkxZrZjqFuEFbznx40GrVG2KqEVtgPSn5aDX9hfOAzGW+3cidYeYzH2kIlQIIj/D
         aalKaNg1wZvrJJFWgW3Xk7zZwQvooTQnDWaMnZzID6dIR9SYE2u57LuTlh10TpHBgskr
         NC1xKMUH5bsnPHJBbvGacpppFE2puOFTP8MerUyPYun/A3XZpzOy8a+ZkXtwbylKTReE
         4V5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wN/KmcWvC+g0rh8netV1xvNHoPshMB2frZ8aZYdI71A=;
        b=wDNwCudnieV2UA13WYsfUMB/IYmL9JaYgYvqCzrkl4Gvn7w78dTAQSGEy9lQaUnI6L
         FwHRgeaiefJWCQN9wj/JeOfiFGlwgeU5SpFGErFt0Mp48fM9TaZDiHTLgkMETDkEY9zC
         8j6bQURR2KB0FO/MCQj3bXhTBno6yu8LdBWTCrSg27fFPF3R4RinljbRgjo1E9Li0h4F
         kBpv3Y27/uxD0DII6BRi8aknSI5AT1wIOyf/MedF48fBgeWTQ0CUUj+Tnc/hvITHtUhm
         EY3sGi40WdGp4HZaN7GHhdBalTp81pJwFfx7zDm683ti8tcEZD6dKFuh4dPL1zUVlnN9
         105A==
X-Gm-Message-State: AO0yUKUgBi4JObvFadeX9sPs80WI84FxpD4SQiyPvU35+JwDal0d0XRa
        2Q/mKfqu8k2JtM1/TCiyHBQCQQ==
X-Google-Smtp-Source: AK7set9lEdbNsyS9O2NKR6o46QFdkJfU81OwA7Wjw+kDzfTIwRj4zIlKFjBxC9km4LslfPt9H1CC4Q==
X-Received: by 2002:a17:906:7251:b0:887:dadb:95d9 with SMTP id n17-20020a170906725100b00887dadb95d9mr3838392ejk.45.1675781921210;
        Tue, 07 Feb 2023 06:58:41 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id p15-20020a05640210cf00b00499e5659988sm6459389edu.68.2023.02.07.06.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 06:58:40 -0800 (PST)
Date:   Tue, 7 Feb 2023 15:58:39 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH v5 net-next 2/8] sfc: add devlink info support for ef100
Message-ID: <Y+JnH+ecdTGgYqAf@nanopsycho>
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
 <20230202111423.56831-3-alejandro.lucero-palau@amd.com>
 <Y9ulUQyScL3xUDKZ@nanopsycho>
 <DM6PR12MB4202DC0B50437D82E28EAAC2C1DB9@DM6PR12MB4202.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DM6PR12MB4202DC0B50437D82E28EAAC2C1DB9@DM6PR12MB4202.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 07, 2023 at 03:42:45PM CET, alejandro.lucero-palau@amd.com wrote:
>
>On 2/2/23 11:58, Jiri Pirko wrote:
>> Thu, Feb 02, 2023 at 12:14:17PM CET, alejandro.lucero-palau@amd.com wrote:
>>> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>>>
>>> Support for devlink info command.
>> You are quite brief for couple hundred line patch. Care to shed some
>> more details for the reader? Also, use imperative mood (applies to the
>> rest of the pathes)
>>
>> [...]
>>
>
>OK. I'll be more talkative and imperative here.
>
>>> +static int efx_devlink_info_get(struct devlink *devlink,
>>> +				struct devlink_info_req *req,
>>> +				struct netlink_ext_ack *extack)
>>> +{
>>> +	struct efx_devlink *devlink_private = devlink_priv(devlink);
>>> +	struct efx_nic *efx = devlink_private->efx;
>>> +	char msg[NETLINK_MAX_FMTMSG_LEN];
>>> +	int errors_reported = 0;
>>> +	int rc;
>>> +
>>> +	/* Several different MCDI commands are used. We report first error
>>> +	 * through extack along with total number of errors. Specific error
>>> +	 * information via system messages.
>>> +	 */
>>> +	rc = efx_devlink_info_board_cfg(efx, req);
>>> +	if (rc) {
>>> +		sprintf(msg, "Getting board info failed");
>>> +		errors_reported++;
>>> +	}
>>> +	rc = efx_devlink_info_stored_versions(efx, req);
>>> +	if (rc) {
>>> +		if (!errors_reported)
>>> +			sprintf(msg, "Getting stored versions failed");
>>> +		errors_reported += rc;
>>> +	}
>>> +	rc = efx_devlink_info_running_versions(efx, req);
>>> +	if (rc) {
>>> +		if (!errors_reported)
>>> +			sprintf(msg, "Getting board info failed");
>>> +		errors_reported++;
>>
>> Under which circumstances any of the errors above happen? Is it a common
>> thing? Or is it result of some fatal event?
>
>They are not common at all. If any of those happen, it is a bad sign, 
>and it is more than likely there are more than one because something is 
>not working properly. That is the reason I only report first error found 
>plus the total number of errors detected.
>
>
>>
>> You treat it like it is quite common, which seems very odd to me.
>> If they are rare, just return error right away to the caller.
>
>Well, that is done now. And as I say, I'm not reporting all but just the 
>first one, mainly because the buffer limitation with NETLINK_MAX_FMTMSG_LEN.
>
>If errors trigger, a more complete information will appear in system 
>messages, so that is the reason with:
>
>+               NL_SET_ERR_MSG_FMT(extack,
>+                                  "%s. %d total errors. Check system messages",
>+                                  msg, errors_reported);
>
>I guess you are concerned with the extack report being overwhelmed, but 
>I do not think that is the case.

No, I'm wondering why you just don't put error message into exack and
return -ESOMEERROR right away.

>
>>
>>
>>> +	}
>>> +
>>> +	if (errors_reported)
>>> +		NL_SET_ERR_MSG_FMT(extack,
>>> +				   "%s. %d total errors. Check system messages",
>>> +				   msg, errors_reported);
>>> +	return 0;
>>> +}
>>> +
>>> static const struct devlink_ops sfc_devlink_ops = {
>>> +	.info_get			= efx_devlink_info_get,
>>> };
>> [...]
