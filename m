Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727446166BD
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 16:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiKBP7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 11:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbiKBP7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 11:59:33 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097992B629
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 08:59:31 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id v124-20020a1cac82000000b003cf7a4ea2caso1567495wme.5
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 08:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0HmwDVoTDX878bFuiu5Mhipe13o11Sl5lwKQ0r0neCY=;
        b=UkQFO/+jC/3eP2DwDSMaWAqMxngNl1Q/8hz/vQ4MnJ/VF05+snfK0t/zVuei969EBd
         9eXamExZu/bMwN0EcSeaaAG0z/87t/tzRqq+03LUIuWNH71Ih/8cdO8oX9HHqxVjqU2x
         GUrayt4RD5//8cu9/17vWzZqDQTWVUZ4WaqapCvL2UsP5j3DGAWNStHwIMoB3wfEUihy
         HzQOcDkoxAaoAuSjeA6zVzjkD60xJV6xKs/ywondft+Z+4IkhEc3ZJbdH8J8KfQJx7m9
         o9nbJdQGIW36wqNPmG5d11p435X+evAOaoEXYaUc3b2X7ErWigr3Y3M+7AKzUM0Qy5hC
         9aDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0HmwDVoTDX878bFuiu5Mhipe13o11Sl5lwKQ0r0neCY=;
        b=Jqga4cmut4VHPD68q+PrwZxuk1O2B4QfoAv6dtvsSoPx08zVDPBlR53P+BJqqc1vJJ
         4Vb3lzrmPUcdvvjJYPTyK8aZ2FREKlZzatHtoY+DroO8ocKETteh/AWqzHisECOKW93d
         KCxI6jwaHkAuzA87sbQn8+BGMY9R+M6YXDRqFYZDRyMiYW4TiWEFNLW3q/iO/tFhynAy
         rsAVw2o3tYcxMLN+i+erqbbp11nJ9aUH8QT/MmGGqm2tapKA0IAz0aRX0/XIn5YM5Pj5
         wJkScjB9DTq/L5LHX4iC3jctk1lr2zKB3yybzFdg24/KrScvPJlr6+hHHzO7cUX/Gqvb
         TzGg==
X-Gm-Message-State: ACrzQf1rZ6k0iQwtKTch/+Yh5ZgN8IlNhcB232RTdQdyT4DKCP/ca+92
        xBM2Nov0ee/yPSMHxNayWgxLpA==
X-Google-Smtp-Source: AMsMyM7zWKcp/TeVAVxaVtJ8/1a12InfD2858PbjVhxuwHUTn05c8BBvmtDS829RbZz6TLXImYytHQ==
X-Received: by 2002:a05:600c:3547:b0:3cf:7a9f:d6cd with SMTP id i7-20020a05600c354700b003cf7a9fd6cdmr8395608wmq.30.1667404770346;
        Wed, 02 Nov 2022 08:59:30 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id bj12-20020a0560001e0c00b0022e55f40bc7sm13431874wrb.82.2022.11.02.08.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 08:59:29 -0700 (PDT)
Date:   Wed, 2 Nov 2022 16:59:28 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: Re: [patch net-next v3 13/13] net: expose devlink port over rtnetlink
Message-ID: <Y2KT4A6ZGVfcbsfx@nanopsycho>
References: <20221031124248.484405-1-jiri@resnulli.us>
 <20221031124248.484405-14-jiri@resnulli.us>
 <20221101091834.4dbdcbc1@kernel.org>
 <Y2JS4bBhPB1qbDi9@nanopsycho>
 <20221102081006.70a81e89@kernel.org>
 <20221102081325.2086edd8@kernel.org>
 <Y2KOnKs0fsDNihaW@nanopsycho>
 <20221102085249.3b64e29f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102085249.3b64e29f@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 02, 2022 at 04:52:49PM CET, kuba@kernel.org wrote:
>On Wed, 2 Nov 2022 16:37:00 +0100 Jiri Pirko wrote:
>> >> Maybe it's time to plumb policies thru to classic netlink, instead of
>> >> creating weird attribute constructs?  
>> >
>> >Not a blocker, FWIW, just pointing out a better alternative.  
>> 
>> Or, even better, move RTnetlink to generic netlink. Really, there is no
>> point to have it as non-generic netlink forever. We moved ethtool there,
>> why not RTnetlink?
>
>As a rewrite?  We could plug in the same callbacks into a genl family
>but the replies / notifications would have different headers depending
>on the socket type which gets hairy, no?

I mean like ethtool, completely side iface, independent, new attrs etc.
We can start with NetdevNetlink for example. Just cover netdev part of
RTNetlink. That is probably most interesting anyway.

