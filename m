Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A660954E76D
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 18:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbiFPQkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 12:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbiFPQkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 12:40:04 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5C15F78
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 09:40:02 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id n28so2952469edb.9
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 09:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rYBvkspR6vlZOcNflMW0glZB27YnSX2BI6vJdiLBAH4=;
        b=7qznNp/bdxxC5V6SyVqk4MFyM87PELJnLnqc1XWgNlC8qfNIPgG7x/4Knf/bDQ4fZe
         pKB4BGn+2J7XTkY8qUvMxkCN2DTQ9jMsWPC0I5k44iCQ+kVofsroyGtfEeT4+KLBofJ+
         IfhASYd/yhotgrITpIEIR2CqM0LCD4wQD2C4NlGoKfO5Fzf1rYoeRF8HF9I0uxXaZnZ9
         Tu70l8aaeQG3HFRZDEGNBpYYG42FqBeLRA88/Jptx6eZE6TQ9rJWDOnKmdJ+VL0+iG8L
         0y4GK+dVcg9OK/ivrvfq+o3cVeXLzdkrsApkNMkSM1+TMIR9T5j/uYcQJoiFppCOe/WP
         FlrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rYBvkspR6vlZOcNflMW0glZB27YnSX2BI6vJdiLBAH4=;
        b=ZogXsYH591+P7Z44sXCCFn5cMJdDWQF0nfeOuVf+Wcr7A2Bv4WucPxYznorrwqsqgm
         YTlml/7dfubdSuOFBO3lZ+c4OFgNonbVqp0HeJt0KDkA3JmUw5//XOGFOmUvb+Ihn1+l
         q5Jc+Bn1UFpQmz4Pugru6eYHkMoG6lT20vxMRwXSEI2/JHZ3yYTu5rNzgxM2KT7RW5sA
         3+RDAKAbABHuAuzwH1QJqRe8cvwgwG6p8w4Hp50vCXgH/6d7qpeER4u/mcmiIpxrt0Ue
         8aulzyRkPzpEM0o9gsxqN9etN3jVqYPNWfwJyQM38l/Z1kVa/OD8T359jOwZ9yblol4F
         aYKg==
X-Gm-Message-State: AJIora+PtAAHvj+08jqKl8Eq2DhuvJ86t1ubJDC2MCOgYCIRpkcBTvQ6
        4aGlaHQ0ZmiAwo2Ps5wcntOhLg==
X-Google-Smtp-Source: AGRyM1vQ2TJtmqP6O19SEEnzGRwtx7OE/+Zpi3TTBUml9Uhqguw2DfPU3HtRuXROoJf+GJPAfpbK8Q==
X-Received: by 2002:a05:6402:485:b0:433:2dfc:e886 with SMTP id k5-20020a056402048500b004332dfce886mr7679371edv.241.1655397601435;
        Thu, 16 Jun 2022 09:40:01 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id v3-20020aa7d643000000b0042bb229e81esm2121482edr.15.2022.06.16.09.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 09:40:00 -0700 (PDT)
Date:   Thu, 16 Jun 2022 18:39:59 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next 02/11] mlxsw: core_linecards: Introduce per line
 card auxiliary device
Message-ID: <Yqtc346Kd2AXEd/l@nanopsycho>
References: <20220614123326.69745-1-jiri@resnulli.us>
 <20220614123326.69745-3-jiri@resnulli.us>
 <YqnyHcsi+GPVT9ix@shredder>
 <YqoYy/RLWaDd/6uh@nanopsycho>
 <YqrXvLY0GGCFLs4U@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqrXvLY0GGCFLs4U@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jun 16, 2022 at 09:11:56AM CEST, idosch@nvidia.com wrote:
>On Wed, Jun 15, 2022 at 07:37:15PM +0200, Jiri Pirko wrote:
>> Wed, Jun 15, 2022 at 04:52:13PM CEST, idosch@nvidia.com wrote:
>> >> +int mlxsw_linecard_bdev_add(struct mlxsw_linecard *linecard)
>> >> +{
>> >> +	struct mlxsw_linecard_bdev *linecard_bdev;
>> >> +	int err;
>> >> +	int id;
>> >> +
>> >> +	id = mlxsw_linecard_bdev_id_alloc();
>> >> +	if (id < 0)
>> >> +		return id;
>> >> +
>> >> +	linecard_bdev = kzalloc(sizeof(*linecard_bdev), GFP_KERNEL);
>> >> +	if (!linecard_bdev) {
>> >> +		mlxsw_linecard_bdev_id_free(id);
>> >> +		return -ENOMEM;
>> >> +	}
>> >> +	linecard_bdev->adev.id = id;
>> >> +	linecard_bdev->adev.name = MLXSW_LINECARD_DEV_ID_NAME;
>> >> +	linecard_bdev->adev.dev.release = mlxsw_linecard_bdev_release;
>> >> +	linecard_bdev->adev.dev.parent = linecard->linecards->bus_info->dev;
>> >> +	linecard_bdev->linecard = linecard;
>> >> +
>> >> +	err = auxiliary_device_init(&linecard_bdev->adev);
>> >> +	if (err) {
>> >> +		mlxsw_linecard_bdev_id_free(id);
>> >> +		kfree(linecard_bdev);
>> >> +		return err;
>> >> +	}
>> >> +
>> >> +	err = auxiliary_device_add(&linecard_bdev->adev);
>> >> +	if (err) {
>> >> +		auxiliary_device_uninit(&linecard_bdev->adev);
>> >> +		return err;
>> >> +	}
>> >> +
>> >> +	linecard->bdev = linecard_bdev;
>> >> +	return 0;
>> >> +}
>> >
>> >[...]
>> >
>> >> +static int mlxsw_linecard_bdev_probe(struct auxiliary_device *adev,
>> >> +				     const struct auxiliary_device_id *id)
>> >> +{
>> >> +	struct mlxsw_linecard_bdev *linecard_bdev =
>> >> +			container_of(adev, struct mlxsw_linecard_bdev, adev);
>> >> +	struct mlxsw_linecard_dev *linecard_dev;
>> >> +	struct devlink *devlink;
>> >> +
>> >> +	devlink = devlink_alloc(&mlxsw_linecard_dev_devlink_ops,
>> >> +				sizeof(*linecard_dev), &adev->dev);
>> >> +	if (!devlink)
>> >> +		return -ENOMEM;
>> >> +	linecard_dev = devlink_priv(devlink);
>> >> +	linecard_dev->linecard = linecard_bdev->linecard;
>> >> +	linecard_bdev->linecard_dev = linecard_dev;
>> >> +
>> >> +	devlink_register(devlink);
>> >> +	return 0;
>> >> +}
>> >
>> >[...]
>> >
>> >> @@ -252,6 +253,14 @@ mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
>> >>  	linecard->provisioned = true;
>> >>  	linecard->hw_revision = hw_revision;
>> >>  	linecard->ini_version = ini_version;
>> >> +
>> >> +	err = mlxsw_linecard_bdev_add(linecard);
>> >
>> >If a line card is already provisioned and we are reloading the primary
>> >devlink instance, isn't this going to deadlock on the global (not
>> >per-instance) devlink mutex? It is held throughout the reload operation
>> >and also taken in devlink_register()
>> >
>> >My understanding of the auxiliary bus model is that after adding a
>> >device to the bus via auxiliary_device_add(), the probe() function of
>> >the auxiliary driver will be called. In our case, this function acquires
>> >the global devlink mutex in devlink_register().
>> 
>> No, the line card auxdev is supposed to be removed during
>> linecard_fini(). This, I forgot to add, will do in v2.
>
>mlxsw_linecard_fini() is called as part of reload with the global
>devlink mutex held. The removal of the auxdev should prompt the
>unregistration of its devlink instance which also takes this mutex. If
>this doesn't deadlock, then I'm probably missing something.

You don't miss anything, it really does. Need to remove devlink_mutex
first.


>
>Can you test reload with lockdep when line cards are already
>provisioned/active?
>
>> 
>> 
>> >
>> >> +	if (err) {
>> >> +		linecard->provisioned = false;
>> >> +		mlxsw_linecard_provision_fail(linecard);
>> >> +		return err;
>> >> +	}
>> >> +
>> >>  	devlink_linecard_provision_set(linecard->devlink_linecard, type);
>> >>  	return 0;
>> >>  }
