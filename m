Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B61A57D082
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiGUQBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 12:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGUQBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:01:45 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D5E28E09
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 09:01:42 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id h8so2934001wrw.1
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 09:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m1PEEMl22cpJGnoDWd66J4i40ZFJwMKFTIUXsHp2fkE=;
        b=THnqLTBK0d3DJcOHHHxKLaHiqx6eyZdeppAfDoXZBGlpZIiyFSlHbRoSrzkQ34Mlv9
         uuxHRulCExFjlU++xhNEOcXQ8U8G2AT+2pkxugbiPpZwAIjH5yeBXdRa6vSisyxnf4+6
         I2aRXt1zPJxbMW7WSdyUQHtPX/8OtxIv4mo4OqWGg5/xa3n0Zo1CeEUNhGRJkYX059e3
         sSMAimmYmh2HLeMVAx8hmAI3obmgkQuWnM+tQM46fCJmZlwsva2QegrosniI2l1i8JYR
         8eIvHm97wAevnm6j+jRmZKov5G7cvml1Y/Ql4/HMqxXU3bAIRmZFLwGDcpbDdEYhf8yV
         2MGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m1PEEMl22cpJGnoDWd66J4i40ZFJwMKFTIUXsHp2fkE=;
        b=jxZKe7il2l00wRITGb8Wn2p/3kXpWJtU0YyrUa1O4Rft3Os/uJQvFuziOG9VG3bHmf
         oqFImUnunWNaIY1O3cYBgMO3zUkCTE70ztYLa3rDfU+NiP5+EjK1batpVffQLtaCkrfB
         kziNYm3aD40xdMd3V+xG5DddmGch8nbKWGv9cjwDZiA/VIa5vCgNv5qSkLn89SeD8kUQ
         WB6f+ZNpWvoa/8fQ6auiuGIwZHoX/hYUutGdLKW9Eaq7sQxDvAgHHZP/clhSKKaqgJ7h
         3zVD3gzDofWjogBdanwvBnCtRn0ehepqXqAlLp3My+tCVKVYDFK3YEj9+yAcGfOGAgWg
         KBiA==
X-Gm-Message-State: AJIora/ahEI9GmAKxTYJFMVHL0xYCp2hmtBTM1YKMz0QUQ1ywpzfeA/a
        xs+5FnO5MysBguoVagcsf6ha3w==
X-Google-Smtp-Source: AGRyM1sUO6p68aqt9CcjqfOkvBtCGlBUtyKVRl38dFuKecz9S4qjLjM7RbGa/YXl5TK70363i669yQ==
X-Received: by 2002:a05:6000:98d:b0:21e:3b5d:335 with SMTP id by13-20020a056000098d00b0021e3b5d0335mr10353977wrb.148.1658419301191;
        Thu, 21 Jul 2022 09:01:41 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r17-20020adfe691000000b0020d07d90b71sm2350817wrm.66.2022.07.21.09.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 09:01:40 -0700 (PDT)
Date:   Thu, 21 Jul 2022 18:01:39 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v3 09/11] mlxsw: core_linecards: Implement line
 card device flashing
Message-ID: <Ytl4Y61M82NOSIrW@nanopsycho>
References: <20220720151234.3873008-1-jiri@resnulli.us>
 <20220720151234.3873008-10-jiri@resnulli.us>
 <YtkNicMHKuC20RIQ@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtkNicMHKuC20RIQ@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 21, 2022 at 10:25:45AM CEST, idosch@nvidia.com wrote:
>On Wed, Jul 20, 2022 at 05:12:32PM +0200, Jiri Pirko wrote:
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
>> +	if (!linecard->active) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Failed to flash non-active linecard");
>
>IMO it's not clear enough that the problem is the fact that the line
>card is inactive. Maybe:
>
>"Only active linecards can be flashed"

Fixed.

>
>Either way:
>
>Reviewed-by: Ido Schimmel <idosch@nvidia.com>
>
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
