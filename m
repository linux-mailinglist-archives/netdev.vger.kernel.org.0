Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154595F67A2
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 15:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJFNTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 09:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiJFNTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 09:19:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA05A8CFF;
        Thu,  6 Oct 2022 06:19:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EC3BB82014;
        Thu,  6 Oct 2022 13:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1232C433D6;
        Thu,  6 Oct 2022 13:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665062340;
        bh=RrJsD0iAaTRNbkimB6aSC77ZLqLuBNt0ZHqGiuN8f5Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ISrogB//e0X5dFVPGg1aR7KjOESFQCv8tDZkU+Z1+Nd8k4rGmMMR02HxqLyLUWRqB
         OHRPBB0oj4Uv6XP4Kr0cWw06jlVU6wTxHEJH3VN+e6BtksA4W8GVu8vOBmZhoTkq2c
         Vc5kXefE4KXHJrD9fig8rgd6rbIus7cQ+LIe6CVPNgZfMVXkwfsEi3UzpCf6QIpkym
         cNv6Vky/lp8k+ncN4LsNJnsF5Kj5+5+O9wB0qzCDvAHkommESyXritIrIlO8dHHkXw
         10BntDoYkwR0PWIr97O1eiM1+cKWt1riESMcROFwxIFCzycMQhPKDwcdCJ3P0DZjmY
         a1LA0YofGHmFw==
Date:   Thu, 6 Oct 2022 16:18:55 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Rohit Sajan Kumar <rohit.sajan.kumar@oracle.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
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
Message-ID: <Yz7VvyONUYRcMBQq@unreal>
References: <1663974295-2910-1-git-send-email-rohit.sajan.kumar@oracle.com>
 <BYAPR10MB29977D4DCA235EE5F91EFF29DC579@BYAPR10MB2997.namprd10.prod.outlook.com>
 <YzYfwXtLceoEw0qo@ziepe.ca>
 <BYAPR10MB29977337E0C3791BCBC6381BDC5B9@BYAPR10MB2997.namprd10.prod.outlook.com>
 <YzsOPllsIMCOC0ks@ziepe.ca>
 <BYAPR10MB2997F4E3E1588E2D003E65FFDC5B9@BYAPR10MB2997.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR10MB2997F4E3E1588E2D003E65FFDC5B9@BYAPR10MB2997.namprd10.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 03, 2022 at 04:34:31PM +0000, Rohit Sajan Kumar wrote:
> Hey Jason,
> 
> I just resent it. Does it show up on that list instantly or is there a time delay involved ?

Like Jason, I never received any patches from you.

> 
> Thanks.
> 
> Best,
> Rohit
> 
> ________________________________
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Monday, October 3, 2022 9:30 AM
> To: Rohit Sajan Kumar <rohit.sajan.kumar@oracle.com>
> Cc: leon@kernel.org <leon@kernel.org>; saeedm@nvidia.com <saeedm@nvidia.com>; davem@davemloft.net <davem@davemloft.net>; edumazet@google.com <edumazet@google.com>; kuba@kernel.org <kuba@kernel.org>; pabeni@redhat.com <pabeni@redhat.com>; linux-rdma@vger.kernel.org <linux-rdma@vger.kernel.org>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>; netdev@vger.kernel.org <netdev@vger.kernel.org>; Manjunath Patil <manjunath.b.patil@oracle.com>; Rama Nichanamatlu <rama.nichanamatlu@oracle.com>; Srinivas Eeda <srinivas.eeda@oracle.com>
> Subject: Re: [External] : Re: [PATCH] IB/mlx5: Add a signature check to received EQEs and CQEs
> 
> On Mon, Oct 03, 2022 at 04:28:48PM +0000, Rohit Sajan Kumar wrote:
> >    Hey Jason,
> >
> >    I resent the patch. I used the get_maintainers.pl script to get a list
> >    of maintainers and mailing lists to send the patch to.
> >
> >    Is there anything else that I should do ?
> 
> Until it shows up here:
> 
> https://urldefense.com/v3/__https://patchwork.kernel.org/project/linux-rdma/list/__;!!ACWV5N9M2RV99hQ!JGo_WKRd4h6QVeyFOwjTXY6ACT155qierf9er6lRr7jfmnUgQK0l8REGWHsmR5bUreKHpRY6cFra3J8dOg$
> 
> It is not sent.. I still don't see it.
> 
> Something is wrong with your mailing environment.
> 
> Jason
