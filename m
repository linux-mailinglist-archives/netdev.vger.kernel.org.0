Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 982FE5798A5
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 13:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237259AbiGSLlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 07:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237318AbiGSLlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 07:41:16 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E763F32A
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 04:41:15 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g1so19165340edb.12
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 04:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YugmbKmCMyW+aOkxg5LKvpzPBOmzZDriKfyzn2OJ6sA=;
        b=cz/7msw0U/567eWLB+Axk9e+RUu/asOy8xQS47p8Gsm7+iLdlmag593ZUnGd9St28L
         oJMETwNB7rtk5YEYOh8E9uq7yWRw7BzbT+3E2XkEcYkcPCY817cnNL0lLKeYaZTXSMTw
         5G+psH1KC64xi/vZAAUMkMi1eyoiZAL4tVe0xh9hopV0OALFGisNxc/G5Lika7DIrI/C
         vb+d17vn+L8LjsLtR/74rCSUIpQOWzbZ2DvL2Q9UTtIsyVE3okfhQjrPHaUvBKdFf4d6
         G0FYx+6Aktu3FEZErDw/tPKskqYF1egBh0Z2gShkD7p5871FnUWJtFM8ZI9lpgIYt11J
         QMKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YugmbKmCMyW+aOkxg5LKvpzPBOmzZDriKfyzn2OJ6sA=;
        b=qbzsEBFMHHZxfLwN+W2GR8yqaENzPUY8so0fxbNxSeVGbK/lMh/uz+6XtMd0OlBRrX
         zoE0Rrz+Fp8LBSmcNpyql2n1PMoU5Ot7Vy/Y6zc3knSE/Ql5LTHWnXl8g5qU8VkkA9PG
         X+nLxe/pkktGn2ns4nbPgzDgnRGZAOV5Zbj5wqbN624MtqRY3g+/UJJmjrUJgbKGjOuD
         MDT2598qWLZ1RvTs+nZOit7uElHJxZvSD8B8zaq6TGW6SU/Aa4GFTszhjcj1CwqFuRQl
         GkYen5OK86Lhm6bWHaSWFS7H0PLHRS4XKn5LNMCMhfc2h86RVx61Wu1HhTHIzNbFQwxL
         SUuA==
X-Gm-Message-State: AJIora8z1i1FXn9oWl4yjioKjVbFLt4DcGPD9a7aucKSuiM5rspsDdVh
        k6boZQk/jJRaXVqTgFVEQ2IqxQ==
X-Google-Smtp-Source: AGRyM1ve3bAdjrAfIl3SPnmRGSnROgui0mtk1s9apJin4qz5ElVtjyoAT5i417nqdxCmHYWfNWXHRw==
X-Received: by 2002:a05:6402:26ca:b0:43a:c743:7c with SMTP id x10-20020a05640226ca00b0043ac743007cmr44012003edd.227.1658230873539;
        Tue, 19 Jul 2022 04:41:13 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id h10-20020aa7cdca000000b0043ab5939ecbsm10389856edw.59.2022.07.19.04.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 04:41:13 -0700 (PDT)
Date:   Tue, 19 Jul 2022 13:41:11 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 01/12] net: devlink: make sure that
 devlink_try_get() works with valid pointer during xarray iteration
Message-ID: <YtaYVwfAXvEH7bJt@nanopsycho>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-2-jiri@resnulli.us>
 <YtaX2536pQXe0+f1@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtaX2536pQXe0+f1@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 19, 2022 at 01:39:07PM CEST, idosch@nvidia.com wrote:
>> @@ -6511,9 +6566,11 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
>>  	int err = 0;
>>  
>>  	mutex_lock(&devlink_mutex);
>> +	rcu_read_lock();
>>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>>  		if (!devlink_try_get(devlink))
>>  			continue;
>> +		rcu_read_unlock();
>>  
>>  		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
>>  			goto retry;
>> @@ -6537,7 +6594,9 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
>>  		idx++;
>>  retry:
>>  		devlink_put(devlink);
>> +		rcu_read_lock();
>>  	}
>> +	rcu_read_unlock();
>>  	mutex_unlock(&devlink_mutex);
>>  
>>  	if (err != -EMSGSIZE)
>
>The pw CI is complaining about this:
>
>New errors added
>--- /tmp/tmp.Lx7CWX0u9n	2022-07-18 23:56:05.513142294 -0700
>+++ /tmp/tmp.SFcuLwts4X	2022-07-18 23:56:49.917188829 -0700
>@@ -0,0 +1,2 @@
>+../net/core/devlink.c: note: in included file (through ../include/linux/rculist.h, ../include/linux/dcache.h, ../include/linux/fs.h, ../include/linux/highmem.h, ../include/linux/bvec.h, ../include/linux/skbuff.h, ...):
>+../include/linux/rcupdate.h:726:9: warning: context imbalance in 'devlink_nl_cmd_info_get_dumpit' - unexpected unlock
>
>Might need something like:

Ah, yes, I missed that. Will add. Thx.


>
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 0e8274feab11..5a39a02b6ed6 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -6611,6 +6611,7 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
> 			err = 0;
> 		else if (err) {
> 			devlink_put(devlink);
>+			rcu_read_lock();
> 			break;
> 		}
> inc:
>
