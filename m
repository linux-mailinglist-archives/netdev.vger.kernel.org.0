Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7345359BF76
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 14:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbiHVM0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 08:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235021AbiHVM0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 08:26:40 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA09326F3
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 05:26:37 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id bq11so6425399wrb.12
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 05:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=Gu8n8JlfOPKaH9E54+Uknfa/4AyD04nm/d7mfsj0b1o=;
        b=mBWat+AzZ9VtWJ7wpPwUcPDA2ad0TUqOgOlE40qGZdsDto5rvi8snOXnJ9+ZUWi0Sr
         KrLaFBxzasryZVT2KrOicjCHvySScdRHDU9OGaxVMTKvSn41hxVn6PEtrA+rGGSb/TyX
         cFCnm94dqQQ+bWcWDrxGwfX9pcDUIEPS4xzjsmb9T3x67V5WVyewxt+3UX0nlukjw9SX
         9l7Qs2X9VKgUIYBWbv8TrDj1Kspnfcj/XH40wkdEpbogfeAPVG6rLgv+7Uw9Ru3NsWd9
         0/QvaNR69eltRsQch1WWjd2SdIF6QqyQayMsA82/hQuCpx5q2T5jntLpN7SjtCsPwppc
         Vqkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=Gu8n8JlfOPKaH9E54+Uknfa/4AyD04nm/d7mfsj0b1o=;
        b=Rd1ABZeN1UW1ccpqdhwMOEPXa5uOQZdY2TqjwEI5FnrKM48oYjsVq/+kJ4LYIODWhH
         Yek01EDwK+6XizF12E57AnpOpKWmKf+toOTu/nNkkTAEOvivsjBgff+yBIkGmG9oOsiJ
         7jS9iz1gvSWouMn4xziBwsusMNb4cmfdtqu+tJIulxSohQRESLI9GA9uKH9RIcTJXpAa
         BWQNG/3agtefVXId+3PBa6+Y7ArQfq3Hb3JzF2BaFFMtYxp94Bw6YW8vi6nlWL0i7VDW
         cMHOHyqS2PZjc8D0VT4BwbqA2N77jywVmzCMxa5+wJxsimZN8eq1iHIaG7xOEARFKZ1x
         iMsw==
X-Gm-Message-State: ACgBeo1jylUNsfExTDvFFLaFmhJFbsXFN2268TXuEvE5mOG86jIpJmdX
        deWahtSWqB9aQFdyg+ot7qwMEA==
X-Google-Smtp-Source: AA6agR7Obi65NyQXa2JvxRAfFhM/aRfJxUyM3u2TNmf7V3wFq0RSLAWScoqzNAyCEpD0EcKAEZmOdw==
X-Received: by 2002:a5d:5289:0:b0:225:4852:4248 with SMTP id c9-20020a5d5289000000b0022548524248mr5235015wrv.228.1661171196260;
        Mon, 22 Aug 2022 05:26:36 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id e15-20020a05600c4e4f00b003a62400724bsm15174857wmq.0.2022.08.22.05.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 05:26:35 -0700 (PDT)
Date:   Mon, 22 Aug 2022 14:26:33 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, tariqt@nvidia.com,
        leon@kernel.org, moshe@nvidia.com
Subject: Re: [patch net-next 4/4] net: devlink: enable parallel ops on
 netlink interface
Message-ID: <YwN1+YZg1OyE4DXp@nanopsycho>
References: <20220729071038.983101-1-jiri@resnulli.us>
 <20220729071038.983101-5-jiri@resnulli.us>
 <20220820124459.44bf1677@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220820124459.44bf1677@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Aug 20, 2022 at 09:44:59PM CEST, kuba@kernel.org wrote:
>On Fri, 29 Jul 2022 09:10:38 +0200 Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> As the devlink_mutex was removed and all devlink instances are protected
>> individually by devlink->lock mutex, allow the netlink ops to run
>> in parallel and therefore allow user to execute commands on multiple
>> devlink instances simultaneously.
>
>Could you update the "Locking" section of
>Documentation/networking/devlink/index.rst
>with the full info and recommendations?

Will do.
