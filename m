Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0825F339B
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 18:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiJCQbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 12:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiJCQbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 12:31:01 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A064A233BB
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 09:30:56 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id k12so6851661qkj.8
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 09:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=28aIkdDQKcvP/iDMdvRxq6s4w7ACes8lqFEjE8LWg2U=;
        b=pYqdGYaxa8MigjkrsdXj9U7udcujE81P2GMQyLzDRUs+K9P1Y+s/Xj0YvxS/579fol
         0Exu6H2g047xTerziNxHZIcuJBP1HYFqvOkntLy5/K5vdX1YawAm52UQPrrusDdRs1l8
         bmRP4G9tobohmh3g7pVh/+PU94v/BKkMfN3vXjxJ2geJy8f2jCigIx9UL21vBqI9b9KR
         +PVo+tc5PvwzqWMlVtFXtRZjv6Vrpa0qSYbC86NywbVSTlguxiJpZFhEPzFdzg9Zrayq
         sZ+NxrJydTubnbZXG9W5FTIUHh69GKM0PXB0T33v1I66sqddIRe/tDSftECt6dHFZMvj
         xeRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=28aIkdDQKcvP/iDMdvRxq6s4w7ACes8lqFEjE8LWg2U=;
        b=zvEvT9b/jDk+loaZK1WnTUIOqMwukr/zzXxeSuuaJrx3Goaw895vndYQ4gkCTmYxom
         OkWEJpQ5/LjcQrnQ5NstP0ae2srPMTk1DeZrkX3LlHjENfceT6GtYDjhswIBvFTtYAh3
         ABJ/x5Fw7ggW3YWZwvIfj3ovYSVUfxjhTHpACxUxFyKiE4ob3rbg6m2Yp9Q9ug01Y3Ge
         9gUMkzhVtenoaFqj3fnPLTGCotAWZ5bC2RvVmWTDOB3vl/wbcwHqdSPglTbvikdDpVvI
         wpvUzBG2RvDA1fZJmYFdqOFC/6zU8uEJ23D0DziBO4d6TtCODcsNlJI1ST9tYbJpJgqU
         g2Zg==
X-Gm-Message-State: ACrzQf1ZKXXqcAgnxOVlhZDF7DeSce0aSNferiAZSgNLvbIKCKzcybue
        ssse1K2Xi6QfH435Qq60UuJr9w==
X-Google-Smtp-Source: AMsMyM6F66yasR3ryCM0HFNJA5iXaqjK5Zu95vuLwN8ccWqkmtAqgAUcCg5RdsapGzXmbT5h2BoNVA==
X-Received: by 2002:a05:620a:14bb:b0:6ce:37fc:b808 with SMTP id x27-20020a05620a14bb00b006ce37fcb808mr14173633qkj.726.1664814655819;
        Mon, 03 Oct 2022 09:30:55 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id j5-20020ac86645000000b0031f36cd1958sm9538106qtp.81.2022.10.03.09.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 09:30:54 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1ofOLG-0063Pv-AO;
        Mon, 03 Oct 2022 13:30:54 -0300
Date:   Mon, 3 Oct 2022 13:30:54 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Rohit Sajan Kumar <rohit.sajan.kumar@oracle.com>
Cc:     "leon@kernel.org" <leon@kernel.org>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Manjunath Patil <manjunath.b.patil@oracle.com>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Srinivas Eeda <srinivas.eeda@oracle.com>
Subject: Re: [External] : Re: [PATCH] IB/mlx5: Add a signature check to
 received EQEs and CQEs
Message-ID: <YzsOPllsIMCOC0ks@ziepe.ca>
References: <1663974295-2910-1-git-send-email-rohit.sajan.kumar@oracle.com>
 <BYAPR10MB29977D4DCA235EE5F91EFF29DC579@BYAPR10MB2997.namprd10.prod.outlook.com>
 <YzYfwXtLceoEw0qo@ziepe.ca>
 <BYAPR10MB29977337E0C3791BCBC6381BDC5B9@BYAPR10MB2997.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR10MB29977337E0C3791BCBC6381BDC5B9@BYAPR10MB2997.namprd10.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 03, 2022 at 04:28:48PM +0000, Rohit Sajan Kumar wrote:
>    Hey Jason,
> 
>    I resent the patch. I used the get_maintainers.pl script to get a list
>    of maintainers and mailing lists to send the patch to.
> 
>    Is there anything else that I should do ?

Until it shows up here:

https://patchwork.kernel.org/project/linux-rdma/list/

It is not sent.. I still don't see it.

Something is wrong with your mailing environment.

Jason
