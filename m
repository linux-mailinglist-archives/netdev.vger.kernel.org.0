Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A46A61618D
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 12:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiKBLN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 07:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiKBLNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 07:13:51 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B3765CE
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 04:13:22 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ud5so44397952ejc.4
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 04:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MUIESL+1+DwuIMcTsQ3+aDYHD/nwg99A2cgXEHg+X6s=;
        b=QmmjTMzlqaBlsGVyBEYtLugJkLYZMg/UK1Fc3Ur1WCyA1uFyHiDQkm4MrgcncZS1LD
         qOUF1FGXr/0MDR2ocKxNx8+aoSJlszXWOlAy3REuYzB4IMClo3zLHgNMpU5Q2YPdqtdZ
         aUIkc3iGWgEbdz6zxmpt/3TCAgDWrwoOhQkWThTbVqu3qS55CRnKzW3OWopiLcXlShtf
         z3LU8bdsKeng0sBgNaivKNkdKGwDbk2y9f+nIWuCMeYoFoZqukovYGSrqFekwWMo01ms
         QCRMEGum5Xy+EpIHZydGj2lhHgOh3usQ6b7/qedcvUEvIbw36y7CtIyFUKDSZ03wIk79
         lyHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MUIESL+1+DwuIMcTsQ3+aDYHD/nwg99A2cgXEHg+X6s=;
        b=VWuWO0NOcpNfp2Re6UqYdXXUtB5l5xVxzwvGms/BDZ18mV5Q9KRiYP1LwGOsLh1HUv
         fVFN/20ib0NyObAa6yW1rfGrQuVmx3jsiz5WSYLvfb453RxBX1yKwlNaKtIpD+wts4pL
         QdItSr09ED2rFCI7uUONfbYw21CtcOcoeZNsU5LNjQyQEz+s8LiAb2OWIAtWsnfwM7PN
         xm8KeoVFW8mRD+oYcWtKEH9FuelubWs5Xo9vYqV6TrLiOldJfRDg8EuZgTTQ6/mtVdqS
         gNCEUYfQM+93ua6uBdgRwmgY7oTQMZ9RXa7cJMRCfZt92TuBIiuV1mJEQlvyluoDSpD3
         Ivcg==
X-Gm-Message-State: ACrzQf3kS8zudUP1vx4p4Fs3DYam2CYZGDlfM1CjeggKWvOC76Wqo6fp
        GYrbsgJms2ylS/DSbnpx3XkQSw==
X-Google-Smtp-Source: AMsMyM5CxO5OME4PTY5fNbu/YNGtM3H9itwLcaTn+YoO2w0oyJBp2fNp4BTliX+QaQyCYovg9jQvTQ==
X-Received: by 2002:a17:906:8469:b0:7ad:dd13:571c with SMTP id hx9-20020a170906846900b007addd13571cmr13157832ejc.141.1667387601070;
        Wed, 02 Nov 2022 04:13:21 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l1-20020a1709063d2100b007aa9156f7e9sm5282503ejf.32.2022.11.02.04.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 04:13:20 -0700 (PDT)
Date:   Wed, 2 Nov 2022 12:13:18 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: Re: [patch net-next v3 05/13] net: devlink: track netdev with
 devlink_port assigned
Message-ID: <Y2JQzvMlu8RRaijJ@nanopsycho>
References: <20221031124248.484405-1-jiri@resnulli.us>
 <20221031124248.484405-6-jiri@resnulli.us>
 <20221101092542.26c66235@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101092542.26c66235@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 01, 2022 at 05:25:42PM CET, kuba@kernel.org wrote:
>On Mon, 31 Oct 2022 13:42:40 +0100 Jiri Pirko wrote:
>> +/*
>> + * Driver should use this to assign devlink port instance to a netdevice
>> + * before it registers the netdevice. Therefore devlink_port is static
>> + * during the netdev lifetime after it is registered.
>> + */
>> +#define SET_NETDEV_DEVLINK_PORT(dev, _devlink_port)		\
>> +({								\
>> +	WARN_ON(dev->reg_state != NETREG_UNINITIALIZED);	\
>> +	((dev)->devlink_port = (_devlink_port));		\
>> +})
>
>The argument wrapping is inconsistent here - dev is in brackets
>on the second line but not on the first. _devlink_port is prefixed 
>with underscore and dev is not. Let's make this properly secure
>and define a local var for dev.

"_" is there because the struct field is named the same. I will change
this to "port" if you don't like "_", no problem.

I will put the first dev to (). Not sure what you mean by "local var",
but I believe that "(dev)" is secure.

>
>> @@ -10107,6 +10107,7 @@ int register_netdevice(struct net_device *dev)
>>  	return ret;
>>  
>>  err_uninit:
>> +	call_netdevice_notifiers(NETDEV_PRE_UNINIT, dev);
>
>I think we should make this symmetric with POST_INIT.
>IOW PRE_UNINIT should only be called if POST_INIT was called.
