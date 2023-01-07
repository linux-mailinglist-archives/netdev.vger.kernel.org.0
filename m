Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F09660D1F
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 10:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjAGJFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 04:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjAGJFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 04:05:41 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA4A81D6E
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 01:05:39 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id r18so2683974pgr.12
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 01:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ySuTU3/2ve7nbb0FFI005zdxYhuuq4YkutjLx2Ct+0Y=;
        b=RW6yEYLuXYPoOVSnuNT5J3HpuWbpn4DO0DffQLL7uqgnlDKHsF4s4wx+N18PdHuN9W
         voi3rblqUq5k3UXEiNwpVLMZ0wplL19gCzK9r7lZqt8u5t/Y6fqMfC4epFDxeiOHwdTR
         vie3f/BCe0Ov2I6isVR/eslig6i2bl1FNm7nQggdD2NXNQE1qbMGlRSOcAqVelGbN31P
         2jbb6B3RmRzfrBslhiSCv40h00W6ZSQEK2CyL3QE3PTa8rM65xEY9ScMzy2RJRVYkqfO
         dRCOv5+gisi7Q4eeheoZqmX7BZmlie926BNEqxAkFX/b4jPj/cYcsEoJU0EsjP9mxvpj
         Tf3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ySuTU3/2ve7nbb0FFI005zdxYhuuq4YkutjLx2Ct+0Y=;
        b=ArZYcYDZpfWSQn8EYmGYOjmD4ohBhC9kknrm6pzYMzjiCK3QS9jYoCEVUmfF477zws
         40DeHGx2Uw6AOjPO1ty4CZryGLscyZe6rVLnUWE7LwR3/76ZqSKIxzlk0NdElciW0qUp
         SpH9FxAzn1y4+IShHQxCb1aTHUzUW59yX/aUHN58LPNGjreZf+3Q4B09f1SwXoTnJxqK
         Woojq7i67TaZWotGRBGglaLgbz9XVkzK9NyQs1RoPT7DQoWRCoGVcqwYmGMaAIzzpx+m
         omcwzZuygSfoaWFIgQ5r2dM/haKxI+nvTXaXAIieCDIY3/2cVNwnni0TkSJ2eznouQM5
         iiVA==
X-Gm-Message-State: AFqh2kpZnNkOxl/5iPhCJJQi3TeCl5MAfhVgvEa3MLQQ9jvy2Xz68Eq1
        dlsne5Idrl8BzhkHjSoLzLkrYw==
X-Google-Smtp-Source: AMrXdXte8Gy+C55Km8MWjs7rRsg9m2ErEEBD9ktU5WeVaroWWQFXJmF4Gsh8fAHhw2GYjHcO7qQGIw==
X-Received: by 2002:a05:6a00:1255:b0:576:b8e1:862b with SMTP id u21-20020a056a00125500b00576b8e1862bmr71940483pfi.14.1673082338488;
        Sat, 07 Jan 2023 01:05:38 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id u64-20020a627943000000b00581816425f3sm2019386pfc.112.2023.01.07.01.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 01:05:37 -0800 (PST)
Date:   Sat, 7 Jan 2023 10:05:35 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 4/9] devlink: always check if the devlink
 instance is registered
Message-ID: <Y7k13+lkw2o0Qiva@nanopsycho>
References: <20230106063402.485336-1-kuba@kernel.org>
 <20230106063402.485336-5-kuba@kernel.org>
 <9f408a8c-4e23-9de5-0ee8-5deccd901543@intel.com>
 <20230106131934.14e7a900@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106131934.14e7a900@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 06, 2023 at 10:19:34PM CET, kuba@kernel.org wrote:
>On Fri, 6 Jan 2023 09:03:18 -0800 Jacob Keller wrote:
>> > +static inline bool devl_is_registered(struct devlink *devlink)
>> > +{
>> > +	/* To prevent races the caller must hold the instance lock
>> > +	 * or another lock taken during unregistration.
>> > +	 */  
>> 
>> Why not just lockdep_assert here on the instance lock? I guess this
>> comment implies that another lock could be used instead but it seems
>> weird to allow that? I guess because of things like the linecards_lock
>> as opposed to the instance lock?
>
>Yup, as discussed on the RFC - removing the regions lock specifically 
>is quite tricky.

I will submit in a jiff. Will add the assert here as a part
of the patchset.

