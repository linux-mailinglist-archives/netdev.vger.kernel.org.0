Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD31C5853FE
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 18:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236495AbiG2Qvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 12:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbiG2Qvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 12:51:39 -0400
Received: from zeeaster.vergenet.net (zeeaster.vergenet.net [206.189.110.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D66588E1D
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 09:51:38 -0700 (PDT)
Received: from madeliefje.horms.nl (unknown [31.124.144.221])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by zeeaster.vergenet.net (Postfix) with ESMTPSA id 9910720008;
        Fri, 29 Jul 2022 16:51:06 +0000 (UTC)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id DC1413A38; Fri, 29 Jul 2022 17:51:05 +0100 (BST)
Date:   Fri, 29 Jul 2022 17:51:05 +0100
From:   Simon Horman <horms@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
Subject: Re: [net-next 06/15] net/mlx5e: TC, Support tc action api for police
Message-ID: <YuQP+cBUkyR1V1GT@vergenet.net>
References: <20220728205728.143074-1-saeed@kernel.org>
 <20220728205728.143074-7-saeed@kernel.org>
 <20220728221852.432ff5a7@kernel.org>
 <YuN6v+L7LQNQdbQf@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuN6v+L7LQNQdbQf@corigine.com>
Organisation: Horms Solutions BV
X-Virus-Scanned: clamav-milter 0.103.6 at zeeaster
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 08:14:23AM +0200, Simon Horman wrote:
> On Thu, Jul 28, 2022 at 10:18:52PM -0700, Jakub Kicinski wrote:
> > On Thu, 28 Jul 2022 13:57:19 -0700 Saeed Mahameed wrote:
> > > From: Roi Dayan <roid@nvidia.com>
> > > 
> > > Add support for tc action api for police.
> > > Offloading standalone police action without
> > > a tc rule and reporting stats.
> > 
> > Do you already support shared actions? I don't see anything later 
> > in the series that'd allow the binding of rules.
> > 
> > The metering in this series is for specific flower flows or the entire
> > port?
> > 
> > 
> > Simon, Baowen, would you be willing to look thru these patches to make
> > sure the action sharing works as expected?
> 
> Certainly, we will review them.

Hi Jakub,

my reading of things is that the handling of offload of police (meter)
actions in flower rules by the mlx5 driver is such that it can handle
offloading actions by index - actions that it would now be possible
to add to hardware with this patch in place.

My reasoning assumes that mlx5e_tc_add_flow_meter() is called to offload
police (meter) actions in flower rules. And that it calls
mlx5e_tc_meter_get(), which can find actions based on an index.

I could, however, be mistaken as I have so much knowledge of the mlx5
driver. And rather than dive deeper I wanted to respond as above - I am
mindful of the point we are in the development cycle.

I would be happy to dive deeper into this as a mater of priority if
desired.
