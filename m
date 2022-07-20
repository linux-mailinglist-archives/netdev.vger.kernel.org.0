Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1DA57B4E1
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 12:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239777AbiGTKyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 06:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240314AbiGTKxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 06:53:54 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E52C6EE83
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 03:53:51 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id oy13so32267143ejb.1
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 03:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DToKmnYd83h60Xnz9eurKa8Zg+H7Mt/b4hhs0pCPFVc=;
        b=pwDL0YX8vYZcP1xBl0N7uZUa7MS1X1G/ahYCh4rUqupBovoF0kgw6f174MqlFJaIZn
         qbUh8u1O/ZtB5dRaxSLOHiGa1jiAM3nMJ3N8CS1C6OI+p4oBvKkzvlDUbaL4YAL5VQoa
         0YpfYW+WLmSogB0cieqih3QZmgow7jxrfSWncr01zrdJtMG5D0S8CiVUPhELTS3Elelc
         XrrPoMg7C6idGbhuKAux/T27a8gn+/gzou+8TE7tJUOkPNwAZye1sKl16MdSAErM1C33
         dU8ugpMqEJMQWJIstl4+zu0WtsqxjlXNAQ+1VkmrCtF+L5jmzXT09uEqYEA0/SH+1UQh
         dn4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DToKmnYd83h60Xnz9eurKa8Zg+H7Mt/b4hhs0pCPFVc=;
        b=ARrga9dfUK8RPgXRAbekzOPxDFBNrOD6RiLQ5fCgdIjdAXkHBbpbCytTu/fSc6cJhd
         bF/Y92iRlvk274iNfY6kR9p0KqmcmWJjhs6bb2EMKx5XEjhGSF7cJxYJakRjATEB8r67
         kP7GOtmuf9EVuN0cwWhGTwdCUGpfjcsKSEyNObwkgJve1nJ9VUku1jEgQjHNzWcPAS2d
         FtdiGKKocDI2YZ+2FM8nRsKS+SMoJtcRr5DHx0Z+P1GvadVk8X76WwtOW0nwg58p6963
         tPSo+iSvuLHrj27UzdeNIw33sANTRVQXltYPwB99hBhffuIrn8ZGQRAl7/9UjqokTJM/
         Yt5g==
X-Gm-Message-State: AJIora8AYaIOMC+hxmave5DsZ58Gr4sq+gwdKkzDqZdE9r0s2FklTK5C
        n4a5M9Y2kltRLx8pDtRkUwmfEw==
X-Google-Smtp-Source: AGRyM1vYHD1n9ingmGrJjl4RDfYQVCUZa9XoQzbdr4lOUih2W6bUCEf5yoI5WxLyLK+Dj2zr9jAn+w==
X-Received: by 2002:a17:906:478d:b0:72e:e902:587 with SMTP id cw13-20020a170906478d00b0072ee9020587mr26306969ejc.548.1658314429625;
        Wed, 20 Jul 2022 03:53:49 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id o7-20020aa7c507000000b0043ab81e4230sm12184133edq.50.2022.07.20.03.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 03:53:49 -0700 (PDT)
Date:   Wed, 20 Jul 2022 12:53:47 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 10/12] mlxsw: core_linecards: Implement line
 card device flashing
Message-ID: <Ytfeu1QFOyP5s+UF@nanopsycho>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-11-jiri@resnulli.us>
 <YtfdAenTfUa+EyL2@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtfdAenTfUa+EyL2@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 20, 2022 at 12:46:25PM CEST, idosch@nvidia.com wrote:
>On Tue, Jul 19, 2022 at 08:48:45AM +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Implement flash_update() devlink op for the line card devlink instance
>> to allow user to update line card gearbox FW using MDDT register
>> and mlxfw.
>> 
>> Example:
>> $ devlink dev flash auxiliary/mlxsw_core.lc.0 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2
>
>Need to mention that this is only possible when line card is
>active/ready

I don't see the need. This is an example. When user issues it and device
is not ready, he gets back an error. As with any other example.


>
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>
>[...]
>
>> +int mlxsw_linecard_flash_update(struct devlink *linecard_devlink,
>> +				struct mlxsw_linecard *linecard,
>> +				const struct firmware *firmware,
>> +				struct netlink_ext_ack *extack)
>> +{
>> +	struct mlxsw_core *mlxsw_core = linecard->linecards->mlxsw_core;
>> +	struct mlxsw_linecard_device_fw_info info = {
>> +		.mlxfw_dev = {
>> +			.ops = &mlxsw_linecard_device_dev_ops,
>> +			.psid = linecard->device.info.psid,
>> +			.psid_size = strlen(linecard->device.info.psid),
>> +			.devlink = linecard_devlink,
>> +		},
>> +		.mlxsw_core = mlxsw_core,
>> +		.linecard = linecard,
>> +	};
>> +	int err;
>> +
>> +	mutex_lock(&linecard->lock);
>> +	if (WARN_ON(!linecard->ready)) {
>
>Can't this be easily triggered from user space when executing the above
>command for a provisioned line card? If so, please remove the WARN_ON()
>and add an extack

Yep, you are correct, this is leftover I missed to fix. Will do.


>
>> +		err = -EINVAL;
>> +		goto unlock;
>> +	}
>> +	err = mlxsw_core_fw_flash(mlxsw_core, &info.mlxfw_dev,
>> +				  firmware, extack);
>> +unlock:
>> +	mutex_unlock(&linecard->lock);
>> +	return err;
>> +}
