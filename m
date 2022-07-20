Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B13257B907
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 16:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiGTO7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 10:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241093AbiGTO7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 10:59:07 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1EC459A1
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 07:59:07 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id va17so33614136ejb.0
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 07:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+8lvdYWq6lhkE9Go/LQdac06KhVXKs8WOg9hTuIqQUM=;
        b=IsSltDdIgQYTmWIDA2UMvrszhNzdt0Mrw3Hcq9474NMUFDfVxPCMffSpfQwGW4nVYt
         NY8o9abuyetHeeD3iNIflpQa4/44tWz+NfpFUTdld9Uq4hiwrOnpPgHnFRosRTNco7Wi
         SfiVAC+t8MSOS2UVvL5CzZ3UqZJrWk35ZCXHq/iaSuvIapaePu7Q04hTfM9f0eukhWyj
         uVoVAL/tmA6m4aPTUnnQhf80c41NmksZTRUkurvW55kgW6MScB7zg6+paLrNK4lDnoWn
         bFjX7l8KIGIl6MhgmLdZVkh6fw1gQG9RiVI7n24YxM/ERdll1u3PHJE7T6xoZX7l5dHX
         AgDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+8lvdYWq6lhkE9Go/LQdac06KhVXKs8WOg9hTuIqQUM=;
        b=PAfiEVQlpNMX3Ikl6fLpxKJ9ngqVKxfEOh3wc1DcyORzIlrXTkXRhztCqyAjQmKDSX
         vXpcRoWS6OPpHVplno/XgR1qEaCN6rJrLM+SBQBanN1C9y9VBVYScUhtqfrqfYjgGuat
         c96In6nqpCvQiIVh+B3xUIYWGRW2jKzTFwtvLWsmlacHHvlllwcVwVYz+/m4AUlhKlqZ
         jV2Gu9SEIuZ3QlJzNm1hOEPVXEm4bIC7ulWLYI6NINe2rXEVlaybMMBg+XdIJtd0U9EX
         hDR6m3L9R0YSYWj1VmvhcL0bUdvOBIHAKilWZeWLYlxuVs6CEfrCBYTKGwauL/DbnMJN
         AbQg==
X-Gm-Message-State: AJIora9y7RuwL6qwjns9Pm5ZGUeNJlenh+UXJKqme8sLjyfbXEtvURhM
        fPRAPonH3tPB5fR+VBeI2CeoFA==
X-Google-Smtp-Source: AGRyM1v87DhpOmzEqYmeP41TWIJvM8NYHkttE1SENh7MwYlBThx+SQWGyjYLIGPE1Mhw0y6MdpsInA==
X-Received: by 2002:a17:907:75ce:b0:72b:305f:5985 with SMTP id jl14-20020a17090775ce00b0072b305f5985mr35270070ejc.527.1658329144844;
        Wed, 20 Jul 2022 07:59:04 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id v15-20020a17090606cf00b0072f60e25d48sm1428617ejb.94.2022.07.20.07.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 07:59:04 -0700 (PDT)
Date:   Wed, 20 Jul 2022 16:59:03 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 05/12] mlxsw: core_linecards: Expose HW
 revision and INI version
Message-ID: <YtgYN3vi6MyTTT0K@nanopsycho>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-6-jiri@resnulli.us>
 <YtfDQ6hpGKXFKfCD@shredder>
 <Ytf0vDVH7+05f0IS@nanopsycho>
 <Ytf4ZaJdJY20ULfw@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ytf4ZaJdJY20ULfw@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 20, 2022 at 02:43:17PM CEST, idosch@nvidia.com wrote:
>On Wed, Jul 20, 2022 at 02:27:40PM +0200, Jiri Pirko wrote:
>> Wed, Jul 20, 2022 at 10:56:35AM CEST, idosch@nvidia.com wrote:
>> >On Tue, Jul 19, 2022 at 08:48:40AM +0200, Jiri Pirko wrote:
>> >> +int mlxsw_linecard_devlink_info_get(struct mlxsw_linecard *linecard,
>> >> +				    struct devlink_info_req *req,
>> >> +				    struct netlink_ext_ack *extack)
>> >> +{
>> >> +	char buf[32];
>> >> +	int err;
>> >> +
>> >> +	mutex_lock(&linecard->lock);
>> >> +	if (WARN_ON(!linecard->provisioned)) {
>> >> +		err = 0;
>> >
>> >Why not:
>> >
>> >err = -EINVAL;
>> >
>> >?
>> 
>> Well, a) this should not happen. No need to push error to the user for
>> this as the rest of the info message is still fine.
>
>Not sure what you mean by "the rest of the info message is still fine".
>Which info message? If the line card is not provisioned, then it
>shouldn't even have a devlink instance and it will not appear in
>"devlink dev info" dump.
>
>I still do not understand why this error is severe enough to print a
>WARNING to the kernel log, but not emit an error code to user space.

As I wrote, WARN_ON was a leftover.

>
>> 
>> 
>> >
>> >> +		goto unlock;
>> >> +	}
>> >> +
>> >> +	sprintf(buf, "%d", linecard->hw_revision);
>> >> +	err = devlink_info_version_fixed_put(req, "hw.revision", buf);
>> >> +	if (err)
>> >> +		goto unlock;
>> >> +
>> >> +	sprintf(buf, "%d", linecard->ini_version);
>> >> +	err = devlink_info_version_running_put(req, "ini.version", buf);
>> >> +	if (err)
>> >> +		goto unlock;
>> >> +
>> >> +unlock:
>> >> +	mutex_unlock(&linecard->lock);
>> >> +	return err;
>> >> +}
>> >> +
>> >>  static int
>> >>  mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
>> >>  			     u16 hw_revision, u16 ini_version)
>> >> -- 
>> >> 2.35.3
>> >> 
