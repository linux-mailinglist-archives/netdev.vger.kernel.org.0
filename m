Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9014CEDFF
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 22:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbiCFVv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 16:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiCFVv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 16:51:27 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BAA5DE41
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 13:50:35 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id e13so12173140plh.3
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 13:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3ULEMLQ3wj/r2S3ryDNOHkvkbW6ztvIs49OUeoSJhQU=;
        b=QhheF0pxp5DGuISJ9xRRbvWOOjkAzJ0vEIYOSTDs57XPr8MhO+djyvmaElU0aITdtx
         AOx+ogZW5CIRlct6+xIpQUZEdnQ+6oMZWzuBVanQ7BkkOGZTuY4gBkJyG0bql1NCH2AZ
         pOR+Wlv/NRWXOnSsmwuK5x+T9zsRg8ogj3YjoLTtyAOvtiaJiuDwjURz6eu4NwnngaPq
         gsS5OsrzxJ1JOZS5prhidujZgoJTvCwqCruLINioQfU58QFLfVRJYj1JGipMYCzg0NVo
         9LJA1E66irfRLrwxH8kSCpg+ui4/SozpgCiPWhvXhlsF2RAFttVn9aS5xHETpPWm5R7V
         pGqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3ULEMLQ3wj/r2S3ryDNOHkvkbW6ztvIs49OUeoSJhQU=;
        b=ZihJZ/k1T3JU9cxA8MUgl+R4RPu7CrNnpnURQjBQHEP1xp3Pvu3ZBKQuh2MHG0vZcx
         FOnaH1qZOv425MkoxYw+JOCDG4zZiMhuoGwBlp0xWdxlfRWGg80gdqILNa8I+gumI62m
         fYdPWBq+zNNoXt9ypxR18w9izMv0t7H8VXxKL54KGA0F4USxNq7xTbC2PZ74gp7O+TZ+
         jeiInsWKmoj7VsiuSYPVbTXtJVnvNQeee7yVu/4dIXhAMZmKw75ccByF1lMVxh/elCFw
         5tnUyn9ZNzPf68heKLbieN+7AgDdyqZwKrHyj1FqrsEty65xt5ZTVt4PAUWxha9jfhgX
         +pAg==
X-Gm-Message-State: AOAM532sF5nX0Vk5/EyKQ5eexZxjYyOiWU/QNY7cr8OzbTkcj65WmGp7
        ahMIwrTAKqqK5PHqoLn8T4Q=
X-Google-Smtp-Source: ABdhPJwGu5YZrsxsjY1IZAieC9djTCU1cSNGFvYB7J263oEpuPS4ia9Gfudjlhhi23fsYrjFd0xd6Q==
X-Received: by 2002:a17:90b:388e:b0:1bf:49ca:2fc0 with SMTP id mu14-20020a17090b388e00b001bf49ca2fc0mr6072727pjb.226.1646603434817;
        Sun, 06 Mar 2022 13:50:34 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id x14-20020a17090ab00e00b001bf2d30ee9dsm7038149pjq.3.2022.03.06.13.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 13:50:34 -0800 (PST)
Date:   Sun, 6 Mar 2022 13:50:32 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     yangbo.lu@nxp.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/6] ptp: Support hardware clocks with
 additional free running time
Message-ID: <20220306215032.GA10311@hoboy.vegasvil.org>
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
 <20220306170504.GE6290@hoboy.vegasvil.org>
 <CANr-f5wNJM4raaXrMA8if8gkUgMRrK7+5beCnpGOzoLu59zwsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANr-f5wNJM4raaXrMA8if8gkUgMRrK7+5beCnpGOzoLu59zwsg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 06, 2022 at 07:38:55PM +0100, Gerhard Engleder wrote:
> How can I cover my use case with the existing API? I had no idea so far.

Okay, so 2 PHCs doesn't help, but still all you need is:

1. a different method to convert time stamps to vclock time base

2. a different method for vclocks' gettime

So let me suggest a much smaller change to the phc/vclock api... stay tuned

Thanks,
Richard
