Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6FE57DA1F
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 08:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbiGVGPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 02:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbiGVGPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 02:15:09 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA427B2E
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 23:15:06 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id m8so4632089edd.9
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 23:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nH/aitoO2NmRJOj+IlcVO6Rbmnvh0euZ8zrQIHQJ1eg=;
        b=0sksq2Mot2wwQGgq2df+VeuFMGoIzhVTGqufDZaEZo6q6L0whwl8mdy0Ey1JUJ7wsp
         GUv4FiPtryHwKxx9XE5UD0YtCgynRPs0KzrY0srPm9dLMN4iyGRGVBa/TFxHFUtmFEjB
         Ph4BZkGImvwpe6pnoBwVWJyLi5LafgEYADkFrRnfoWfOszIJpf+gZdgUdZSeo3P9d+Gj
         Q9pQpOim6mNJzk8wlH7hH28w+OH4Nw7OHPXuWKxuIhoAG16NI0KCmKHxHwmJ9HbcMsF9
         Pd2VPoVDxnFX8ef9tfcF6nO/p9gimUJxKqlzepSYrnVg1sKTgFYPJy6oWHSHLaWrdfLz
         uEOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nH/aitoO2NmRJOj+IlcVO6Rbmnvh0euZ8zrQIHQJ1eg=;
        b=0OzuzLczzNFzg6RKNWfF+gVegJFEg0OUxuzwlA9d5W/iBBZchFY7U2G7TOl+QleLGC
         Wg44ifzwK5cCK/GNZiQG816gyshcbiKRQ5kl+wTi9J9fKm+3v7BbU+Ngftnd2iNg/6xv
         eI1QeuRebMSQFQEkIdoxHYnYS11mgllEDrBeEElVFy+aqn3venGYf0caavJdA0moE/w8
         e34wZL/tEXxntLmQbRiuLbaU3MJsBTBuDKxt6H8xDcvHZKuUOukNQE9qXqaT56svBCl0
         1qeb8MLPye6DVcQ4oX/ueFJILq3pb4WkA9UwMC5eyX6zbqm7zqfGnA2BjHpZf8riFe6a
         BG4w==
X-Gm-Message-State: AJIora9Vvtj9+RcsN7fpo5Wa8Xyk4AN/OtrXMFNy63c91620rEXHUnSj
        TWahXxe6LvoPBuR2i6YzstHTZzZQM9DbY21e
X-Google-Smtp-Source: AGRyM1sigv4xx2bvRIIIqSPNFfNEWQm32/nKBqMljVcr8x6Hco1KTWw3iLEDqB2WfpIKr2nQglbY4Q==
X-Received: by 2002:a05:6402:2992:b0:43b:7929:475b with SMTP id eq18-20020a056402299200b0043b7929475bmr1921744edb.58.1658470505303;
        Thu, 21 Jul 2022 23:15:05 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 11-20020a170906310b00b00722fc0779e3sm1612353ejx.85.2022.07.21.23.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 23:15:04 -0700 (PDT)
Date:   Fri, 22 Jul 2022 08:15:03 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v3 01/11] net: devlink: make sure that
 devlink_try_get() works with valid pointer during xarray iteration
Message-ID: <YtpAZ6NFPyVmf3At@nanopsycho>
References: <20220720151234.3873008-1-jiri@resnulli.us>
 <20220720151234.3873008-2-jiri@resnulli.us>
 <20220720174953.707bcfa9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720174953.707bcfa9@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 21, 2022 at 02:49:53AM CEST, kuba@kernel.org wrote:
>On Wed, 20 Jul 2022 17:12:24 +0200 Jiri Pirko wrote:
>> +static void __devlink_put_rcu(struct rcu_head *head)
>> +{
>> +	struct devlink *devlink = container_of(head, struct devlink, rcu);
>> +
>> +	complete(&devlink->comp);
>> +}
>> +
>>  void devlink_put(struct devlink *devlink)
>>  {
>>  	if (refcount_dec_and_test(&devlink->refcount))
>> -		complete(&devlink->comp);
>> +		/* Make sure unregister operation that may await the completion
>> +		 * is unblocked only after all users are after the end of
>> +		 * RCU grace period.
>> +		 */
>> +		call_rcu(&devlink->rcu, __devlink_put_rcu);
>>  }
>
>Hm. I always assumed we'd just use the xa_lock(). Unmarking the
>instance as registered takes that lock which provides a natural 
>barrier for others trying to take a reference.
>
>Something along these lines (untested):
>
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 98d79feeb3dc..6321ea123f79 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -278,6 +278,38 @@ void devl_unlock(struct devlink *devlink)
> }
> EXPORT_SYMBOL_GPL(devl_unlock);
> 
>+static struct devlink *devlink_iter_next(unsigned long *index)
>+{
>+	struct devlink *devlink;
>+
>+	xa_lock(&devlinks);
>+	devlink = xa_find_after(&devlinks, index, ULONG_MAX,
>+				DEVLINK_REGISTERED);
>+	if (devlink && !refcount_inc_not_zero(&devlink->refcount))
>+		devlink = NULL;
>+	xa_unlock(&devlinks);
>+
>+	return devlink ?: devlink_iter_next(index);
>+}
>+
>+static struct devlink *devlink_iter_start(unsigned long *index)
>+{
>+	struct devlink *devlink;
>+
>+	xa_lock(&devlinks);
>+	devlink = xa_find(&devlinks, index, ULONG_MAX, DEVLINK_REGISTERED);
>+	if (devlink && !refcount_inc_not_zero(&devlink->refcount))
>+		devlink = NULL;
>+	xa_unlock(&devlinks);
>+
>+	return devlink ?: devlink_iter_next(index);
>+}
>+
>+#define devlink_for_each_get(index, entry)			\
>+	for (index = 0, entry = devlink_iter_start(&index);	\
>+	     entry; entry = devlink_iter_next(&index))
>+
> static struct devlink *devlink_get_from_attrs(struct net *net,
> 					      struct nlattr **attrs)
> {
>@@ -1329,10 +1361,7 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
> 	int err = 0;
> 
> 	mutex_lock(&devlink_mutex);
>-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>-		if (!devlink_try_get(devlink))
>-			continue;
>-
>+	devlink_for_each_get(index, devlink) {
> 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
> 			goto retry;
> 
>etc.
>
>Plus we need to be more careful about the unregistering order, I
>believe the correct ordering is:
>
>	clear_unmark()
>	put()
>	wait()
>	notify()

Fixed.

>
>but I believe we'll run afoul of Leon's notification suppression.
>So I guess notify() has to go before clear_unmark(), but we should
>unmark before we wait otherwise we could live lock (once the mutex 
>is really gone, I mean).
