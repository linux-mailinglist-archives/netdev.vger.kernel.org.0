Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF01267979E
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 13:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbjAXMT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 07:19:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233698AbjAXMSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 07:18:33 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF13442F1
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 04:18:31 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id v13so18050245eda.11
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 04:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ayy6beGyUd9EN8g4tJl0P0CDI0BSMkhvWlpcMDE4JW4=;
        b=f+I9n+y3lPUBuS7sl9u2pyChET1MhKle/0KCEXYQ+WspPAySxfJu8S5FPl47s1MxSe
         NsA4GEHzH8485RwCS8XRmD6WQTnRmPy2VHwwxPCP97eBJQ9BXMNzc3XaGWIGrAMCVKUF
         DhyZ3E+eOKjubPRq9HOxey2ze/gJmcFcrZ4XmRHJRi0sbbIpJF5b4u5ngtfaJWXYVUf4
         ThAm6G+3REAn1xfpZnlAXZvpD6hTgc7z2i5g5hOGo7G5jGrJhlV8e7VoREtM1b4Diqg9
         uQI4RB4Jg5YYIdcbrQ4fyMzm8VKuKqBT0w9A5ujEaUKQxUZ11fJFt7vWqoNzvRQxyk68
         E5kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ayy6beGyUd9EN8g4tJl0P0CDI0BSMkhvWlpcMDE4JW4=;
        b=j+5uq9ZzUnx9nMUWdbXX9JEXjONjFb0WRKpmwgtwD1mN+2DRyveb0Kk6Z36umJ7tn0
         VLjBCUoj7FEfwzK59Yx+777MXWVkvvR7kB1Gi6FwEi29wkzwPkqYEGun7vps4hqYK9hu
         g9lqRGZVmbMLz9CuJp6uQkA3EqX+nSMTRWZtOTVIJIefUrRz4qJedLT3W5ywE9Sbusre
         HmhtITHic3Dnw5yBTza/cL3Rq+Nh/w+LjXPufJrkEbuefoepWfJ62tWSIpEKyMxvsCUZ
         zop6joxRWvZ7pDiqq6vbVPcs/mhNIh348rJYv3ue1LlSkO7NZDVKnWBEbu9VcUJOkQJW
         GFfw==
X-Gm-Message-State: AFqh2kpTvT7CvJkg4uVP72XeCwMP2wuxLAKnyKhaNuS/4JienZcUpajB
        cGfrvvUMTRSDJefc8JsWfJUF5A==
X-Google-Smtp-Source: AMrXdXvchWDTOd5UAdR+11QcHIG1Bzlj8R/wIoFrKw98gHb8GOKNDTcIGsWlfe5y/HYNa1qAAzwXZw==
X-Received: by 2002:a05:6402:449a:b0:49e:210a:65f3 with SMTP id er26-20020a056402449a00b0049e210a65f3mr30170994edb.0.1674562709814;
        Tue, 24 Jan 2023 04:18:29 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id r9-20020a056402018900b0049e09105705sm960533edv.62.2023.01.24.04.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 04:18:28 -0800 (PST)
Date:   Tue, 24 Jan 2023 13:18:28 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next] devlink: remove a dubious assumption in fmsg
 dumping
Message-ID: <Y8/MlMWmkVBjQlfZ@nanopsycho>
References: <20230124035231.787381-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124035231.787381-1-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 24, 2023 at 04:52:31AM CET, kuba@kernel.org wrote:
>Build bot detects that err may be returned uninitialized in
>devlink_fmsg_prepare_skb(). This is not really true because
>all fmsgs users should create at least one outer nest, and
>therefore fmsg can't be completely empty.
>
>That said the assumption is not trivial to confirm, so let's
>follow the bots advice, anyway.
>
>This code does not seem to have changed since its inception in
>commit 1db64e8733f6 ("devlink: Add devlink formatted message (fmsg) API")
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
