Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1E261EC4A
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiKGHlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbiKGHk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:40:58 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F3A6242
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 23:40:56 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id y14so27704186ejd.9
        for <netdev@vger.kernel.org>; Sun, 06 Nov 2022 23:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+lfqb3ol7Bxs1iGAL3+ufgu0TErNNc1giAdMYt6uKPM=;
        b=cW1t/VwiMKWxA4SN2v1Y0mHvJ1cXEz7U//6W6hF0Z4EtLbf0OdZC6e3CkDmCKlz8wN
         lgi8jsuJ0R4QE4Z4bcwdn0A8voLCw4n8+ElyD7iWVR43HFlzk6JTZJtFh+JdfcDueWwZ
         qKoIrTcHDp1H5hTnya3I8VfNR9e/L/c7rtYQZoukJK0n2ZmhqDG8054NLk5etk+u8Y8g
         4Lm5smnAk1WwT5sD+y0S/uCjfE3N2FAWHRVXC3z0JXCRN34fhnsFNbaEi+jcmoNLyzkE
         7JMydLUs8vDwsVmJSZRajJ0YQSoxWKYRhkVA4+2SPdUZKjh/P2sne3QY2wn2mL4jhaWL
         SS5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+lfqb3ol7Bxs1iGAL3+ufgu0TErNNc1giAdMYt6uKPM=;
        b=CbQu2qnn0yCXA49MTsbfRzLVWgd9/YcCPLQtWrihfeZDLY0KhxIVJQrGFJsAR2/3h1
         cLoBmI3e1/xbmY6jL1Ljio9JwJnzTfYQOUhSdV4CY7Pu9lcxCdy5HmzgoK/rw89Nhb2m
         hIuAIOfr8YAbOnGtrpyUY+LNL7p4xjrWAblBDYzWpx7fS5kXpEP35Uh0sKgCd79VPYNj
         IkdPAnvvXqiF4P9gViQgy7Mr4EFd61NMj+dJiF/iybqkK2B52dbCDPDu3qOncendoZmz
         XBCmlREGQOmxhy4K/NzsyBFVbKPuoNBCGFSL1O5iOyX34k57+vB1/+m4wfHc/B927D4c
         L9zw==
X-Gm-Message-State: ACrzQf2jgGONNHwtCLpSVCTKI+dJ4hsbOA1N2vQ9qdsSVahXXkPBJbck
        fAoL/4Epu50PwhyhuzgDOVLQBw==
X-Google-Smtp-Source: AMsMyM7NNxcrWFoAkGOeywH6FbaQtbGu/aIFcEvDK8+Tjs7QAXpU+sMoWM4xhFKVLMpV+B4QHixSaA==
X-Received: by 2002:a17:907:2063:b0:7ad:fa6b:e84b with SMTP id qp3-20020a170907206300b007adfa6be84bmr28298711ejb.69.1667806854713;
        Sun, 06 Nov 2022 23:40:54 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id eh9-20020a0564020f8900b004587f9d3ce8sm3711460edb.56.2022.11.06.23.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Nov 2022 23:40:53 -0800 (PST)
Date:   Mon, 7 Nov 2022 08:40:53 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: Re: [patch net-next v4 05/13] net: devlink: track netdev with
 devlink_port assigned
Message-ID: <Y2i2hTt2txFoo2aR@nanopsycho>
References: <20221102160211.662752-1-jiri@resnulli.us>
 <20221102160211.662752-6-jiri@resnulli.us>
 <Y2d51izTZV1rThOc@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2d51izTZV1rThOc@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Nov 06, 2022 at 10:09:42AM CET, idosch@idosch.org wrote:
>On Wed, Nov 02, 2022 at 05:02:03PM +0100, Jiri Pirko wrote:
>> @@ -9645,10 +9649,13 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
>>  
>>  	ret = xa_alloc_cyclic(&devlinks, &devlink->index, devlink, xa_limit_31b,
>>  			      &last_id, GFP_KERNEL);
>> -	if (ret < 0) {
>> -		kfree(devlink);
>> -		return NULL;
>> -	}
>> +	if (ret < 0)
>> +		goto err_xa_alloc;
>> +
>> +	devlink->netdevice_nb.notifier_call = devlink_netdevice_event;
>> +	ret = register_netdevice_notifier_net(net, &devlink->netdevice_nb);
>> +	if (ret)
>> +		goto err_register_netdevice_notifier;
>>  
>>  	devlink->dev = dev;
>>  	devlink->ops = ops;
>> @@ -9675,6 +9682,12 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
>>  	init_completion(&devlink->comp);
>>  
>>  	return devlink;
>> +
>> +err_register_netdevice_notifier:
>> +	xa_erase(&devlinks, devlink->index);
>> +err_xa_alloc:
>> +	kfree(devlink);
>> +	return NULL;
>>  }
>>  EXPORT_SYMBOL_GPL(devlink_alloc_ns);
>>  
>> @@ -9828,6 +9841,10 @@ void devlink_free(struct devlink *devlink)
>>  	WARN_ON(!list_empty(&devlink->port_list));
>>  
>>  	xa_destroy(&devlink->snapshot_ids);
>> +
>> +	unregister_netdevice_notifier_net(devlink_net(devlink),
>> +					  &devlink->netdevice_nb);
>> +
>>  	xa_erase(&devlinks, devlink->index);
>>  
>>  	kfree(devlink);
>
>The network namespace of the devlink instance can change throughout the
>lifetime of the devlink instance, but the notifier block is always
>registered in the initial namespace. This leads to
>unregister_netdevice_notifier_net() failing to unregister the notifier
>block, which leads to use-after-free. Reproduce (with KASAN enabled):
>
># echo "10 0" > /sys/bus/netdevsim/new_device
># ip netns add bla
># devlink dev reload netdevsim/netdevsim10 netns bla
># echo 10 > /sys/bus/netdevsim/del_device
># ip link add dummy10 up type dummy
>
>I see two possible solutions:
>
>1. Use register_netdevice_notifier() instead of
>register_netdevice_notifier_net().
>
>2. Move the notifier block to the correct namespace in devlink_reload().

Yep, this was my intension, slipped my mind. Thanks! Will send a
follow-up.
