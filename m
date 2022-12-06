Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECEAF6440E9
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbiLFKEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235446AbiLFKEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:04:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8F92F000;
        Tue,  6 Dec 2022 01:55:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E002EB818E2;
        Tue,  6 Dec 2022 09:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D380CC433D6;
        Tue,  6 Dec 2022 09:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320476;
        bh=ergxUz1Dsju0bznEJWaLN0PnmSqY7BqDm2qD+xi3qKE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h7F25LViZSIVsNdTSCCnNDFIKQ1xUlUA4NHaxJNssDLhzfrRlqkZz4C6kZQqtntDO
         ECbWtP+nmaSxQSaWlfkeb3HNd31/xWQUxcLguB1HgZvsUJZKq9gCHr/WBUN8Mtvdou
         qtnTQ+QHNN0MB7glgYhDPtvhcyEkihPJTybYRigmY5+0WspOURn2siSG0Rt3ARk19i
         zK1dYUG0+GdKk68ePUH6FTXiqpRwxjGZ+hvzfRE2pGSWGraAQKL7TS6yDUqOE0vwqr
         Etkh2D/W6RqRNQYelTyGR73Tj6sZtNHwgz39Kw8Mud3rzGS39YaDQFnWouRi/FXlMR
         dRxau1O+UOpAA==
Date:   Tue, 6 Dec 2022 11:54:31 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     wangchuanlei <wangchuanlei@inspur.com>, alexandr.lobakin@intel.com,
        pabeni@redhat.com, pshelar@ovn.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, wangpeihui@inspur.com,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PATCH v7 net-next] net: openvswitch: Add support to
 count upcall packets
Message-ID: <Y48RV9j4WRUcsuYV@unreal>
References: <20221205030024.3990061-1-wangchuanlei@inspur.com>
 <E969E975-1D24-48F1-949E-3D5EE27AFA02@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E969E975-1D24-48F1-949E-3D5EE27AFA02@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 09:12:01AM +0100, Eelco Chaudron wrote:
> 
> 
> On 5 Dec 2022, at 4:00, wangchuanlei wrote:
> 
> > Add support to count upall packets, when kmod of openvswitch
> > upcall to userspace , here count the number of packets for
> > upcall succeed and failed, which is a better way to see how
> > many packets upcalled to userspace(ovs-vswitchd) on every
> > interfaces.
> 
> Thanks for including my suggestions, one more comment below.
> 
> > Here modify format of code used by comments of v6.
> >
> > Changes since v4 & v5 & v6:
> > - optimize the function used by comments
> >
> > Changes since v3:
> > - use nested NLA_NESTED attribute in netlink message
> >
> > Changes since v2:
> > - add count of upcall failed packets
> >
> > Changes since v1:
> > - add count of upcall succeed packets

Please put changelog after "---". It doesn't belong to commit message.

Thanks

> >
> > Signed-off-by: wangchuanlei <wangchuanlei@inspur.com>
> > ---
