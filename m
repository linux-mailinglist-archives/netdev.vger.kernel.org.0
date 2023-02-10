Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01707691EB2
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 12:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbjBJL4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 06:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbjBJL4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 06:56:18 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B388688
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 03:56:16 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id rp23so15166745ejb.7
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 03:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RsoJhV93aSxUg6rF5+WxZGTHjWYEV4hUOoTihOuUqNQ=;
        b=KTyGgz38lHLU3X2JA2ey7jIKYG6q8mgrT9LhnhuTPhbvsd2zn/jS76Z/4xrqi6tCQg
         i7Q8sZRtPGg29/LrEqVjZHxaw5uuV5rvOv/gcPLlE5QYxa8E+Z1UKzUjMLl0JJr8Mait
         vYQpY+rmNfO5Ej2Fl9ZO74NDLrEaAevkboNw6mwcn3JSa2Z2/iG0+QLi4Q4I41XQ1YBi
         qW/z0HuGHxpQOm4MkEXlnas07iMfVbO/RCqCdABMqRLwlQfLROGBEkpVZU4oEhmJ45IZ
         Oj45BD+j9TebshjUntF2niXvkOC2hFTNyzF14w7U+ftM2VPoPhwyHYnyoqP1qY3+xPZ3
         +TMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RsoJhV93aSxUg6rF5+WxZGTHjWYEV4hUOoTihOuUqNQ=;
        b=YSblnw+S9ZRXOYHWumZ/Njxte3B/juVToaU6pwOcBo/Ztb7/kgylwgpftUcWylgtHL
         vIooixdYpJONTogRnlqwAKXAusU7HrzLrXF8JvApr9+cspiH+uR8BcwrI8xp5tjX4lLJ
         utFfrBHLGRlAnVbhN1IoVHoZCaOVWoXBnQq2B8a8KfqKagtj/CHqqH6zSsbpwm5+hgOB
         4Bzus1Zk737pkMUPZlkfbAW0Q6l1yiPFGuay9z+9+zfmLrl9rCivWAwH5C7D1Ps8nFUm
         OlMcbVzi8trI4OaM49GYee2h/LWDvQPiyKWO7rDQGHF0XFBfog7BAiWCwKQVBVwZQDWo
         tpZA==
X-Gm-Message-State: AO0yUKUGeM3+m+g6cfusYCuAaC8W+A5znkHFokZQvrH5qus22fBy6LOF
        myMOosfwdg2C3Il82+pD8PaLyaL6X9MEMrzlBBw=
X-Google-Smtp-Source: AK7set+OSl7fgcVCOKCK43T8iMsGLa5gVRS5IbYZKsuZDCKPEtigsIa2AQao5Cw9SR1L2sFyakffEQ==
X-Received: by 2002:a17:906:6b1a:b0:895:58be:954 with SMTP id q26-20020a1709066b1a00b0089558be0954mr14610849ejr.58.1676030174769;
        Fri, 10 Feb 2023 03:56:14 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id w14-20020a170906384e00b008878909859bsm2263694ejc.152.2023.02.10.03.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 03:56:14 -0800 (PST)
Date:   Fri, 10 Feb 2023 12:56:13 +0100
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
Subject: Re: [PATCH v6 net-next 2/8] sfc: add devlink info support for ef100
Message-ID: <Y+Yw3UHO9ZWzyYZa@nanopsycho>
References: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
 <20230208142519.31192-3-alejandro.lucero-palau@amd.com>
 <Y+O0A5Bk/zWur76J@nanopsycho>
 <DM6PR12MB4202FE90A833282B28053DF7C1D89@DM6PR12MB4202.namprd12.prod.outlook.com>
 <DM6PR12MB4202A784865D367996F4A3BBC1D99@DM6PR12MB4202.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR12MB4202A784865D367996F4A3BBC1D99@DM6PR12MB4202.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Feb 09, 2023 at 11:46:04AM CET, alejandro.lucero-palau@amd.com wrote:
>
>On 2/8/23 15:24, Lucero Palau, Alejandro wrote:
>> On 2/8/23 14:38, Jiri Pirko wrote:
>>> Wed, Feb 08, 2023 at 03:25:13PM CET, alejandro.lucero-palau@amd.com wrote:
>>>> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>>> [..]
>>>
>>>
>>>> +static int efx_devlink_info_get(struct devlink *devlink,
>>>> +				struct devlink_info_req *req,
>>>> +				struct netlink_ext_ack *extack)
>>>> +{
>>>> +	struct efx_devlink *devlink_private = devlink_priv(devlink);
>>>> +	struct efx_nic *efx = devlink_private->efx;
>>>> +	int rc;
>>>> +
>>>> +	/* Several different MCDI commands are used. We report first error
>>>> +	 * through extack along with total number of errors. Specific error
>>>> +	 * information via system messages.
>>> I think you forgot to remove this comment.
>>>
>>> With this nit fixed, free free to add:
>>> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
>>>
>> I'll do.
>>
>> Thanks
>
>Just wondering if this single nit deserves a v7 or better to delay it as 
>another patch.
>
>We got another patchset for ef100 ready to be sent and we would prefer 
>to not delay this one more than needed.

Cleaner would be v7, but I don't mind that much. Let the patchbot to
decide :)
