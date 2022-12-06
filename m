Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C88643F20
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 09:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbiLFIzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 03:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiLFIzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 03:55:43 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5323DD6B
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 00:55:42 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id x22so4472467ejs.11
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 00:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dCBDYzbdoqkXlU1yQbEio1UobbeTu0eaedyoCGvJiNM=;
        b=vGu3dipQvkGrXoZJ5hzz9tbAbcbF9k4E7RzuMG8bj7XHGP5vhgEqbaoWbgaodRZYs7
         jzEa6BgiC6kZ7BbXYyiHdr+tlCftjCi4YaQ1NKQjcvCIAPlGuiZQ4pwzPL44bInYIBNP
         /weSBpV0kvCJzWitpAMe4Xg17YIxXKnrMCUM5YlWaRX3LNJF8N6mefVuA7CkO5rriq5x
         WN1Fpb9Vh0OjhejSOjoih9rqmlXx8aBNIZV+2kJdeijpHmQrX6tXQSyDzqYofjbzdMeq
         wE63tyetAyUq6kAQJtn82QO5zlIZx9dtO6dsEtERTl5CrXWmczHfxIv57sdNy2FQr31V
         s+CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dCBDYzbdoqkXlU1yQbEio1UobbeTu0eaedyoCGvJiNM=;
        b=51GC9KMr10UKk89/eKuztShIvV3H/BMHo26eEaq2rLspsIhTmYWwgxy/Cec0nxsFZC
         PAI1lzKIYstyHlGIxy5VX7kgmTuYyCCWQMVXIMyxgUF2hpa37UJnUfWIcgY/HcVKrDrh
         QmQfWQDDRRE3jBWymz5QCtOd0bAyIhqC/h63SVflbSGnYUzBXlGapcgiQ6ijkE9kuKo2
         FwBOhA07tnE3ym/ZRcd/vBwc60/D1MOtuV8s1gLwj3xYDyTG4IIPYL/p5crwEyQ6nd+V
         u1/Xq0fvb3hmpVImv/Tm3Dyut/eRtsFGlqCJCD91qYkAnLTfiwshoz6ashOVWCIf3MTU
         3YWA==
X-Gm-Message-State: ANoB5pldVrcrnb57cQTllfTOn3muaYq4ttMopFYcCmfledW1gzLyl5Ol
        FXIjENvwLRZgszIuIkJFggsvsx/BRa8jHTmORrp66w==
X-Google-Smtp-Source: AA0mqf7+Rro04WB0Nz/dSRM/VbTA25diFtq6l97hv4QcNSuRZnpihndYJS4Hy1yNCczMfpl5txJ/oQ==
X-Received: by 2002:a17:906:c458:b0:7c0:e15a:5aed with SMTP id ck24-20020a170906c45800b007c0e15a5aedmr9849937ejb.14.1670316940886;
        Tue, 06 Dec 2022 00:55:40 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id q18-20020a17090676d200b007c0e23b5615sm3144597ejn.34.2022.12.06.00.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 00:55:40 -0800 (PST)
Date:   Tue, 6 Dec 2022 09:55:39 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shannon Nelson <shnelson@amd.com>
Cc:     Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, danielj@nvidia.com,
        yishaih@nvidia.com, jiri@nvidia.com, saeedm@nvidia.com,
        parav@nvidia.com
Subject: Re: [PATCH net-next V3 7/8] devlink: Expose port function commands
 to control migratable
Message-ID: <Y48Di5gcpCpqf9CR@nanopsycho>
References: <20221204141632.201932-1-shayd@nvidia.com>
 <20221204141632.201932-8-shayd@nvidia.com>
 <7e3deb3a-a3fd-d954-3b6f-8d2547e036d5@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e3deb3a-a3fd-d954-3b6f-8d2547e036d5@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Dec 06, 2022 at 12:37:44AM CET, shnelson@amd.com wrote:
>On 12/4/22 6:16 AM, Shay Drory wrote:
>> Expose port function commands to enable / disable migratable
>> capability, this is used to set the port function as migratable.
>
>Since most or the devlink attributes, parameters, etc are named as nouns or
>verbs (e.g. roce, running, rate, err_count, enable_sriov, etc), seeing this
>term in an adjective form is a bit jarring.  This may seem like a picky
>thing, but can we use "migrate" or "migration" throughout this patch rather
>than "migratable"?

But it is about "ability to migrate". That from how I understand the
language, "migratable" describes the best, doesn't it?


>
>> 
>> Live migration is the process of transferring a live virtual machine
>> from one physical host to another without disrupting its normal
>> operation.
>> 
>> In order for a VM to be able to perform LM, all the VM components must
>> be able to perform migration. e.g.: to be migratable.
>> In order for VF to be migratable, VF must be bound to VFIO driver with
>> migration support.
>> 
>> When migratable capability is enable for a function of the port, the
>
>s/enable/enabled/
>
>
>
>> 
>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>> index 20306fb8a1d9..fdb5e8da33ce 100644
>> --- a/include/net/devlink.h
>> +++ b/include/net/devlink.h
>> @@ -1470,6 +1470,27 @@ struct devlink_ops {
>>          int (*port_function_roce_set)(struct devlink_port *devlink_port,
>>                                        bool enable,
>>                                        struct netlink_ext_ack *extack);
>> +       /**
>> +        * @port_function_mig_get: Port function's migratable get function.
>
>I would prefer to see 'mig' spelled out as 'migration'
>
>sln
