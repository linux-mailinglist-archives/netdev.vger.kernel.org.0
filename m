Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C128564D9D
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 08:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbiGDGTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 02:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiGDGTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 02:19:22 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FE55FD7
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 23:19:21 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id u12so14854508eja.8
        for <netdev@vger.kernel.org>; Sun, 03 Jul 2022 23:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ykXto2O+ATOK+WQsd44YKA6aegouDwSgRQSkpmx4HS0=;
        b=R/P8IOmULlqoJcKgSI8cF0CrHBUkB3Qdi0ynamZFok6vzVemiv1ny9hS75Mwr2J2KT
         4dhvDzz+x7yFnElMe0IfCESRp/Y1ukAQ9vFOR3Fnhh+B/N8T+iyF9OlcTA01Y+F/UHC0
         Dsbe6shjeG2J3zaqk1xm2xIyr1toCgZJlmMEk4kLtraaH9aznzt1cWi8EXsBCnC4KnLz
         A4UkM+pQut9ZYYtcvGWDfKJ2vM3MpIQhD93ulZqbfkX88nRmKj7fl7kY5kYrA6L6kwlJ
         J3SO3f8lUYVk8CJMxtM5LwlSpNDg81rx4pbPTFmpJIo/UdP+rxmweoiMALh/zNQi3kvS
         L3jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ykXto2O+ATOK+WQsd44YKA6aegouDwSgRQSkpmx4HS0=;
        b=RKDdBSyhAI8qEIYqFSa3Gfk2wozt7GakxsepaXQD/5HQbouqqmPj8sUipSrBHvgTMS
         OuPzm+13YCj7mUBOEnBYFUUGga5UgEixOwx+8tIpdanWx2UO6qt3mJG6Egfsu/GWBo+J
         mq8Sj/wOPhm4xO6ome96b4IKzbc0Ovrmd3xrWfISOC5JVBBFZj4VKweny4LER6+F0rH/
         Z22XLXT/qqO5wcK9cUDgLawNw23G9s26ziYz3j/1BT0dyVvwFCornI1xcTZzF4XpTrYU
         3a1crVTVZySRsdoKTDejfm6dtCZHGtvoqZfY1grgpnWWWpF6aT+4xUsjYYSUwe/vGN8v
         Aqlg==
X-Gm-Message-State: AJIora9a1NqevzzAXT1ah0XDNAk4MW1mWIVYh9mfHLJF7kX2UVVBcFVx
        yJSl3YkkvYgqnlIG89PqOQNSxQ==
X-Google-Smtp-Source: AGRyM1sZ612B7tQppJXeoaC+t9+JCtXM3GeILj1jR/InzXpe07lM/h3FMilCUHgIYoVUT/haTANePQ==
X-Received: by 2002:a17:907:1b1e:b0:6d7:31b0:e821 with SMTP id mp30-20020a1709071b1e00b006d731b0e821mr26279364ejc.334.1656915559518;
        Sun, 03 Jul 2022 23:19:19 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id s2-20020a170906454200b006fe9ec4ba9esm13911171ejq.52.2022.07.03.23.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jul 2022 23:19:18 -0700 (PDT)
Date:   Mon, 4 Jul 2022 08:19:17 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: Re: [patch net-next 2/3] net: devlink: call lockdep_assert_held()
 for devlink->lock directly
Message-ID: <YsKGZZ8ZggAf+jGT@nanopsycho>
References: <20220701095926.1191660-1-jiri@resnulli.us>
 <20220701095926.1191660-3-jiri@resnulli.us>
 <20220701093316.410157f3@kernel.org>
 <YsBrDhZuV4j3uCk3@nanopsycho>
 <20220702122946.7bfc387a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220702122946.7bfc387a@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jul 02, 2022 at 09:29:46PM CEST, kuba@kernel.org wrote:
>On Sat, 2 Jul 2022 17:58:06 +0200 Jiri Pirko wrote:
>> Fri, Jul 01, 2022 at 06:33:16PM CEST, kuba@kernel.org wrote:
>> >On Fri,  1 Jul 2022 11:59:25 +0200 Jiri Pirko wrote:  
>> >> In devlink.c there is direct access to whole struct devlink so there is
>> >> no need to use helper. So obey the customs and work with lock directly
>> >> avoiding helpers which might obfuscate things a bit.  
>> >  
>> >> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> >> index 25b481dd1709..a7477addbd59 100644
>> >> --- a/net/core/devlink.c
>> >> +++ b/net/core/devlink.c
>> >> @@ -10185,7 +10185,7 @@ int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
>> >>  	struct devlink *devlink = devlink_port->devlink;
>> >>  	struct devlink_rate *devlink_rate;
>> >>  
>> >> -	devl_assert_locked(devlink_port->devlink);
>> >> +	lockdep_assert_held(&devlink_port->devlink->lock);  
>> >
>> >I don't understand why. Do we use lockdep asserts directly on rtnl_mutex
>> >in rtnetlink.c?  
>> 
>> Well:
>> 
>> 1) it's been a long time policy not to use helpers for locks if not
>>    needed. There reason is that the reader has easier job in seeing what
>>    the code is doing. And here, it is not needed to use helper (we can
>>    access the containing struct)
>
>AFAIU the policy is not to _create_ helpers for locks for no good
>reason. If the helper already exists it's better to consistently use
>it.
>
>> 2) lock/unlock for devlink->lock is done here w/o helpers as well
>
>Existing code, I didn't want to cause major code churn until the
>transition is finished.
>
>> 3) there is really no gain of using helper here.
>
>Shorter, easier to type and remember, especially if the author is
>already using the exported assert in the driver.
>
>> 4) rtnl_mutex is probably not good example, it has a lot of ancient
>>    history behind it.
>
>It's our main lock so we know it best. Do you have other examples?
>
>Look, I don't really care, I just want to make sure we document the
>rules of engagement clearly for everyone to see and uniformly enforce. 
>So we either need to bash out exactly what we want (and I think our
>views differ) or you should switch the commit message to say "I feel
>like" rather than referring to "customs" 😁

Jakub, I don't really care. If you say we should do it differently, I
will do it differently. I just want the use to be consistent. From the
earlier reactions of DaveM on such helpers, I got an impression we don't
want them if possible. If this is no longer true, I'm fine with it. Just
tell me what I should do.

Thanks!
