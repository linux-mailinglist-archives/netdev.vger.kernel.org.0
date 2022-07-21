Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E725257C3D7
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 07:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiGUFvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 01:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiGUFvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 01:51:41 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5599361D7D
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 22:51:40 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id l23so1317860ejr.5
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 22:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RSUrzYyeaK0ccu6YnXVmAl5RyL3PuqAy2/pZYm794UQ=;
        b=dSwTpBOkgcWDDWTSRWRIjEMyYWuc2Z8r06603me3X3pXR0ysA2V4mplKjLtorJSjCK
         4WJf1r3JAQj+opkf6kMCoEzuhp4xNRWVMMb280ZTto3XAWwnsvISx8EX2igGpkKp0ceX
         UPvhqznsAMzRyZEKodVWxzJ90Prc6ztoktdk0Gp+Yl1HdsDBRAG+jCZlXYP3BZWezXx0
         gXHSNOM1NwDgfns1cybkl0TUo0tiP3UIUWiMNFE37VFeKDnZ9BmVPHYFoY5JcTHgwtOh
         HFbXtXkQ0//RgA/WYzHgYZbGEdsL1RENeRJnCh4vArg9wPIZjcEbkw1lehVuIUjOuOCc
         bf+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RSUrzYyeaK0ccu6YnXVmAl5RyL3PuqAy2/pZYm794UQ=;
        b=1wuqCbvM5Kg7XDy8wXIP8n3DHUZ8Pz0CKz0s3GOeSzIuXeSwLQufp26MH6HMHs2R8F
         qfEkyA82ZZjHZZnCoF2AffWoBL08aIAdH7n8+S8cL5f1Xkx6cy16Bt3SxwSVIIpHvWmP
         AVNj5yZmg/ChfmGVwu4rFIR4ZX0KC15auErBuRiMKHyOpq5prjjgKhW2Traa26XnpB3h
         dJEAMvnNFUmdkfzh+prEe+jrusoMwJjnNF1iVAzaUKvDcy/UMrR5Hx1i0uDwl0dEJEEt
         7qra9n4wMaDNiCrD8ZA6eOHETp0IhKhVgP0jfQQpvJxnugLplii+ZKNVxaSFdIJ+KHtm
         bhIA==
X-Gm-Message-State: AJIora+0pFc8ZmgvTvghUk32W1ObhPKQTo8lcFy81PaZPP1CnYOnE8Ux
        eQMDN15TCQ6eVwJBFaWOE5JY4Q==
X-Google-Smtp-Source: AGRyM1sD6vSuOj3ymZTLfFDKQloIKBDaflOEuvZXKERHTIEfiLqy3ZA4oSZcYJxzGBgAfG59vr4NBw==
X-Received: by 2002:a17:907:75ce:b0:72b:305f:5985 with SMTP id jl14-20020a17090775ce00b0072b305f5985mr38234087ejc.527.1658382698815;
        Wed, 20 Jul 2022 22:51:38 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g10-20020a1709067c4a00b00722dcb4629bsm456165ejp.14.2022.07.20.22.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 22:51:38 -0700 (PDT)
Date:   Thu, 21 Jul 2022 07:51:37 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v3 01/11] net: devlink: make sure that
 devlink_try_get() works with valid pointer during xarray iteration
Message-ID: <YtjpaRtkOwX00azI@nanopsycho>
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

I guess that the xa_lock() scheme could work, as far as I see it. But
what's wrong with the rcu scheme? I actually find it quite neat. No need
to have another odd iteration helpers. We just benefit of xa_array rcu
internals to make sure devlink pointer is valid at the time we make a
reference. Very clear.



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
>
>but I believe we'll run afoul of Leon's notification suppression.
>So I guess notify() has to go before clear_unmark(), but we should
>unmark before we wait otherwise we could live lock (once the mutex 
>is really gone, I mean).

Will check.

