Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F91A54D017
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 19:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347595AbiFORhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 13:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244148AbiFORhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 13:37:22 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A60E393DC
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 10:37:19 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id z17so6710607wmi.1
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 10:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mtNDpZ/MIP0xtuEpaiq42cBt2tLH0BVkH9I1SBIuG7w=;
        b=JtOtFvUgMRvvqIy9giDpT+FJhI7lVvC0pU0KzVoizi8yp/AEBLVv2+O0nLlGqlhSui
         aMhBlbhDfoH0XgBlP+gQGKFy4HtCny9WVwfEuNCTfGcilACZrgVJqN23ltusxxTS3Exr
         9U+Xqo32psGMqeQe4etbjSGpmsP4manF+C7KNe7K0BI8uOn9NicjpJpN1xGIwAAt9LMC
         cVcbwzmVKywbpjov5+BuNKPNA+a2ipP4yQYyvVrt6WZz2ftFpYFMQFo51Kt3v/rzstbA
         yXerd1JtTYvtMcLzaUrKVrktTnY5w2Up52RZqm5dxjiLDlzGqHK30+g/17jxBjZup22N
         PWvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mtNDpZ/MIP0xtuEpaiq42cBt2tLH0BVkH9I1SBIuG7w=;
        b=u7D+x8rDpmW7A+1P27YwG4dI8cFtfQ7Cagxf/kSBEXp8+RmisdBlOfdXfqazWkLT22
         rr437ge1mv8mE0QvmnO8Jn+0nwy5zOugZQOI6hAMyB8aKW3cj84QBJBy5VKE5ovCY27v
         eokL2anANoxRTElV7pSHcNCXxvn49k5QCmZnCzKzAVAWAooGEy5DRvQW8UJLN7TeGWDn
         At5ftNtNs09IZaKaGcTdt20xkEMQmWs1DXk5hQ4LcYgWfPccjcYP8qUKaDJmC7GKteWI
         ch74+gYdwGWm8o5UT/nOBhXEkGXKZ9BTbf2v9bOBUe9WTk0/uXxFXUaRmcudz2o9IDP1
         WN3w==
X-Gm-Message-State: AJIora+VLJup8xHi+KrjtUgY3g1swPusBKlFMnQEOm2yYWuyBHh0CvRz
        VJdHQmDFmiHLquGoYeZqlbNlKJjzJCuLSO3e
X-Google-Smtp-Source: AGRyM1snj3vUmsFUS2K5rjzO7ywFr//39p247B2raPAOlv8y8RPTLcXaNnctKUWc3vkPl6dud0ixlA==
X-Received: by 2002:a05:600c:1e09:b0:39c:5351:789a with SMTP id ay9-20020a05600c1e0900b0039c5351789amr562952wmb.177.1655314638034;
        Wed, 15 Jun 2022 10:37:18 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f2-20020adfb602000000b002185c6dc5b1sm17361664wre.108.2022.06.15.10.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 10:37:17 -0700 (PDT)
Date:   Wed, 15 Jun 2022 19:37:15 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next 02/11] mlxsw: core_linecards: Introduce per line
 card auxiliary device
Message-ID: <YqoYy/RLWaDd/6uh@nanopsycho>
References: <20220614123326.69745-1-jiri@resnulli.us>
 <20220614123326.69745-3-jiri@resnulli.us>
 <YqnyHcsi+GPVT9ix@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqnyHcsi+GPVT9ix@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jun 15, 2022 at 04:52:13PM CEST, idosch@nvidia.com wrote:
>> +int mlxsw_linecard_bdev_add(struct mlxsw_linecard *linecard)
>> +{
>> +	struct mlxsw_linecard_bdev *linecard_bdev;
>> +	int err;
>> +	int id;
>> +
>> +	id = mlxsw_linecard_bdev_id_alloc();
>> +	if (id < 0)
>> +		return id;
>> +
>> +	linecard_bdev = kzalloc(sizeof(*linecard_bdev), GFP_KERNEL);
>> +	if (!linecard_bdev) {
>> +		mlxsw_linecard_bdev_id_free(id);
>> +		return -ENOMEM;
>> +	}
>> +	linecard_bdev->adev.id = id;
>> +	linecard_bdev->adev.name = MLXSW_LINECARD_DEV_ID_NAME;
>> +	linecard_bdev->adev.dev.release = mlxsw_linecard_bdev_release;
>> +	linecard_bdev->adev.dev.parent = linecard->linecards->bus_info->dev;
>> +	linecard_bdev->linecard = linecard;
>> +
>> +	err = auxiliary_device_init(&linecard_bdev->adev);
>> +	if (err) {
>> +		mlxsw_linecard_bdev_id_free(id);
>> +		kfree(linecard_bdev);
>> +		return err;
>> +	}
>> +
>> +	err = auxiliary_device_add(&linecard_bdev->adev);
>> +	if (err) {
>> +		auxiliary_device_uninit(&linecard_bdev->adev);
>> +		return err;
>> +	}
>> +
>> +	linecard->bdev = linecard_bdev;
>> +	return 0;
>> +}
>
>[...]
>
>> +static int mlxsw_linecard_bdev_probe(struct auxiliary_device *adev,
>> +				     const struct auxiliary_device_id *id)
>> +{
>> +	struct mlxsw_linecard_bdev *linecard_bdev =
>> +			container_of(adev, struct mlxsw_linecard_bdev, adev);
>> +	struct mlxsw_linecard_dev *linecard_dev;
>> +	struct devlink *devlink;
>> +
>> +	devlink = devlink_alloc(&mlxsw_linecard_dev_devlink_ops,
>> +				sizeof(*linecard_dev), &adev->dev);
>> +	if (!devlink)
>> +		return -ENOMEM;
>> +	linecard_dev = devlink_priv(devlink);
>> +	linecard_dev->linecard = linecard_bdev->linecard;
>> +	linecard_bdev->linecard_dev = linecard_dev;
>> +
>> +	devlink_register(devlink);
>> +	return 0;
>> +}
>
>[...]
>
>> @@ -252,6 +253,14 @@ mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
>>  	linecard->provisioned = true;
>>  	linecard->hw_revision = hw_revision;
>>  	linecard->ini_version = ini_version;
>> +
>> +	err = mlxsw_linecard_bdev_add(linecard);
>
>If a line card is already provisioned and we are reloading the primary
>devlink instance, isn't this going to deadlock on the global (not
>per-instance) devlink mutex? It is held throughout the reload operation
>and also taken in devlink_register()
>
>My understanding of the auxiliary bus model is that after adding a
>device to the bus via auxiliary_device_add(), the probe() function of
>the auxiliary driver will be called. In our case, this function acquires
>the global devlink mutex in devlink_register().

No, the line card auxdev is supposed to be removed during
linecard_fini(). This, I forgot to add, will do in v2.


>
>> +	if (err) {
>> +		linecard->provisioned = false;
>> +		mlxsw_linecard_provision_fail(linecard);
>> +		return err;
>> +	}
>> +
>>  	devlink_linecard_provision_set(linecard->devlink_linecard, type);
>>  	return 0;
>>  }
