Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5176755CA5E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbiF0IfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 04:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232413AbiF0IfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 04:35:03 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B60F5FEB
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 01:35:01 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id fi2so17514161ejb.9
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 01:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WkjYqig1I2Zq2477opeLTd77ShVG9Qb5NjqluZi5OFY=;
        b=5GxvAJfjSvI9Qx7PrDW6lGqX2vErOBgbrXeYy0CBjr2NHcxA7kduwFZ+U2IbDfyUVA
         1h4S1WAq75eumiavnsQpeI2NwNBoNDtSZXMJFFQ1VJG5+RfQUKXKaUnD8WHZ2wKVyeG7
         XJx9WbX4Xs4JpKIU0O6zDoqRQS6pgNpNh/Z1vk1Xp1EfsxFBmdQ2G0ykv4pIyk6fHQCl
         nsOVx6+FAYAOTKYTBSKl5XjLZ2wFFj73Rbtab5JIrALL05+oSI790+IikWq9zLO6UePh
         GQvTh5RNoOAkC9qcS3Zba0wCsBStWYQv25A2NlARVNqV4/XS13KrMwI/lEqIHgpbV8Rx
         0EoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WkjYqig1I2Zq2477opeLTd77ShVG9Qb5NjqluZi5OFY=;
        b=iBvasgoUdyRCoe+oqx6f46u6uslNSdwXoyPU0tiEF0VO9OzUJm80Dudr2AhPWnzmKd
         Higq3NUpQoco6jtJlfCugSKhRiiWyi1LVcIJHEvqvfQkKYhIpdkOFBosIjAoPbGqcNnI
         d2HWOIzLGt8IJtzKxfweMmj2+RQ8hcWR0+nG5ge6SNSfWrrKuHWaKClxtyRPidARs49O
         +xdoSuzjj+/cSQySvITRXN8UOsEizKgwrsgAeL+2xeoK9EA32XsNS8Dp5d71VLJ/Ex1u
         gM4mnrynDTTDm00pCEPJmZRqtzqtWwWmiMAodmHbYfe/idQf/ukZvCY51rx+HGq8/mmg
         EpBA==
X-Gm-Message-State: AJIora+fmcN25PRc9Qbw96ws/talde/PB6i5uOBMMZXN7FlJ2NeK/xp8
        ASXmPQW75sLu8Z8kD50A9vPXcQ==
X-Google-Smtp-Source: AGRyM1tY87ZcQn7J3UImIiUJv34oHO2y6WBlg71SrOKGrKrva5vgH2CpG7epbfYRxz3+yNvhfFHHhA==
X-Received: by 2002:a17:906:519b:b0:722:e854:dfc2 with SMTP id y27-20020a170906519b00b00722e854dfc2mr11730100ejk.331.1656318899679;
        Mon, 27 Jun 2022 01:34:59 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g20-20020a50d5d4000000b0042617ba63c2sm7185579edj.76.2022.06.27.01.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 01:34:58 -0700 (PDT)
Date:   Mon, 27 Jun 2022 10:34:57 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next 02/11] mlxsw: core_linecards: Introduce per line
 card auxiliary device
Message-ID: <YrlrsXJXcwpmY0n2@nanopsycho>
References: <20220614123326.69745-1-jiri@resnulli.us>
 <20220614123326.69745-3-jiri@resnulli.us>
 <YqnyHcsi+GPVT9ix@shredder>
 <YqoYy/RLWaDd/6uh@nanopsycho>
 <YqrXvLY0GGCFLs4U@shredder>
 <Yqtc346Kd2AXEd/l@nanopsycho>
 <YqtrYGobjgoJr+34@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqtrYGobjgoJr+34@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jun 16, 2022 at 07:41:52PM CEST, idosch@nvidia.com wrote:
>On Thu, Jun 16, 2022 at 06:39:59PM +0200, Jiri Pirko wrote:
>> Thu, Jun 16, 2022 at 09:11:56AM CEST, idosch@nvidia.com wrote:
>> >On Wed, Jun 15, 2022 at 07:37:15PM +0200, Jiri Pirko wrote:
>> >> Wed, Jun 15, 2022 at 04:52:13PM CEST, idosch@nvidia.com wrote:
>> >> >> +int mlxsw_linecard_bdev_add(struct mlxsw_linecard *linecard)
>> >> >> +{
>> >> >> +	struct mlxsw_linecard_bdev *linecard_bdev;
>> >> >> +	int err;
>> >> >> +	int id;
>> >> >> +
>> >> >> +	id = mlxsw_linecard_bdev_id_alloc();
>> >> >> +	if (id < 0)
>> >> >> +		return id;
>> >> >> +
>> >> >> +	linecard_bdev = kzalloc(sizeof(*linecard_bdev), GFP_KERNEL);
>> >> >> +	if (!linecard_bdev) {
>> >> >> +		mlxsw_linecard_bdev_id_free(id);
>> >> >> +		return -ENOMEM;
>> >> >> +	}
>> >> >> +	linecard_bdev->adev.id = id;
>> >> >> +	linecard_bdev->adev.name = MLXSW_LINECARD_DEV_ID_NAME;
>> >> >> +	linecard_bdev->adev.dev.release = mlxsw_linecard_bdev_release;
>> >> >> +	linecard_bdev->adev.dev.parent = linecard->linecards->bus_info->dev;
>> >> >> +	linecard_bdev->linecard = linecard;
>> >> >> +
>> >> >> +	err = auxiliary_device_init(&linecard_bdev->adev);
>> >> >> +	if (err) {
>> >> >> +		mlxsw_linecard_bdev_id_free(id);
>> >> >> +		kfree(linecard_bdev);
>> >> >> +		return err;
>> >> >> +	}
>> >> >> +
>> >> >> +	err = auxiliary_device_add(&linecard_bdev->adev);
>> >> >> +	if (err) {
>> >> >> +		auxiliary_device_uninit(&linecard_bdev->adev);
>> >> >> +		return err;
>> >> >> +	}
>> >> >> +
>> >> >> +	linecard->bdev = linecard_bdev;
>> >> >> +	return 0;
>> >> >> +}
>> >> >
>> >> >[...]
>> >> >
>> >> >> +static int mlxsw_linecard_bdev_probe(struct auxiliary_device *adev,
>> >> >> +				     const struct auxiliary_device_id *id)
>> >> >> +{
>> >> >> +	struct mlxsw_linecard_bdev *linecard_bdev =
>> >> >> +			container_of(adev, struct mlxsw_linecard_bdev, adev);
>> >> >> +	struct mlxsw_linecard_dev *linecard_dev;
>> >> >> +	struct devlink *devlink;
>> >> >> +
>> >> >> +	devlink = devlink_alloc(&mlxsw_linecard_dev_devlink_ops,
>> >> >> +				sizeof(*linecard_dev), &adev->dev);
>> >> >> +	if (!devlink)
>> >> >> +		return -ENOMEM;
>> >> >> +	linecard_dev = devlink_priv(devlink);
>> >> >> +	linecard_dev->linecard = linecard_bdev->linecard;
>> >> >> +	linecard_bdev->linecard_dev = linecard_dev;
>> >> >> +
>> >> >> +	devlink_register(devlink);
>> >> >> +	return 0;
>> >> >> +}
>> >> >
>> >> >[...]
>> >> >
>> >> >> @@ -252,6 +253,14 @@ mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
>> >> >>  	linecard->provisioned = true;
>> >> >>  	linecard->hw_revision = hw_revision;
>> >> >>  	linecard->ini_version = ini_version;
>> >> >> +
>> >> >> +	err = mlxsw_linecard_bdev_add(linecard);
>> >> >
>> >> >If a line card is already provisioned and we are reloading the primary
>> >> >devlink instance, isn't this going to deadlock on the global (not
>> >> >per-instance) devlink mutex? It is held throughout the reload operation
>> >> >and also taken in devlink_register()
>> >> >
>> >> >My understanding of the auxiliary bus model is that after adding a
>> >> >device to the bus via auxiliary_device_add(), the probe() function of
>> >> >the auxiliary driver will be called. In our case, this function acquires
>> >> >the global devlink mutex in devlink_register().
>> >> 
>> >> No, the line card auxdev is supposed to be removed during
>> >> linecard_fini(). This, I forgot to add, will do in v2.
>> >
>> >mlxsw_linecard_fini() is called as part of reload with the global
>> >devlink mutex held. The removal of the auxdev should prompt the
>> >unregistration of its devlink instance which also takes this mutex. If
>> >this doesn't deadlock, then I'm probably missing something.
>> 
>> You don't miss anything, it really does. Need to remove devlink_mutex
>> first.
>
>Can you please send it separately? Will probably need thorough review
>and testing...

Sure.


>
>The comment above devlink_mutex is: "An overall lock guarding every
>operation coming from userspace. It also guards devlink devices list and
>it is taken when driver registers/unregisters it.", but devlink does not
>have "parallel_ops" enabled, so maybe it's enough to only use this lock
>to protect the devlink devices list?

I'm preparing a patchset that will answer all your questions, lets move
the discussion there.


>
>> 
>> 
>> >
>> >Can you test reload with lockdep when line cards are already
>> >provisioned/active?
>> >
>> >> 
>> >> 
>> >> >
>> >> >> +	if (err) {
>> >> >> +		linecard->provisioned = false;
>> >> >> +		mlxsw_linecard_provision_fail(linecard);
>> >> >> +		return err;
>> >> >> +	}
>> >> >> +
>> >> >>  	devlink_linecard_provision_set(linecard->devlink_linecard, type);
>> >> >>  	return 0;
>> >> >>  }
