Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB19920200F
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 05:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732325AbgFTDNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 23:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732271AbgFTDNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 23:13:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275F5C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 20:13:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5E6C0127853AD;
        Fri, 19 Jun 2020 20:13:43 -0700 (PDT)
Date:   Fri, 19 Jun 2020 20:13:42 -0700 (PDT)
Message-Id: <20200619.201342.2288126609984082133.davem@davemloft.net>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, vladbu@mellanox.com,
        simon.horman@netronome.com
Subject: Re: [PATCH net v5 0/4] several fixes for indirect flow_blocks
 offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1592484551-16188-1-git-send-email-wenxu@ucloud.cn>
References: <1592484551-16188-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Jun 2020 20:13:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu@ucloud.cn
Date: Thu, 18 Jun 2020 20:49:07 +0800

> From: wenxu <wenxu@ucloud.cn>
> 
> v2:
> patch2: store the cb_priv of representor to the flow_block_cb->indr.cb_priv
> in the driver. And make the correct check with the statments
> this->indr.cb_priv == cb_priv
> 
> patch4: del the driver list only in the indriect cleanup callbacks
> 
> v3:
> add the cover letter and changlogs.
> 
> v4:
> collapsed 1/4, 2/4, 4/4 in v3 to one fix
> Add the prepare patch 1 and 2
> 
> v5:
> patch1: place flow_indr_block_cb_alloc() right before
> flow_indr_dev_setup_offload() to avoid moving flow_block_indr_init()
> 
> This series fixes commit 1fac52da5942 ("net: flow_offload: consolidate
> indirect flow_block infrastructure") that revists the flow_block
> infrastructure.
> 
> patch #1 #2: prepare for fix patch #3
> add and use flow_indr_block_cb_alloc/remove function
> 
> patch #3: fix flow_indr_dev_unregister path
> If the representor is removed, then identify the indirect flow_blocks
> that need to be removed by the release callback and the port representor
> structure. To identify the port representor structure, a new 
> indr.cb_priv field needs to be introduced. The flow_block also needs to
> be removed from the driver list from the cleanup path
> 
> 
> patch#4 fix block->nooffloaddevcnt warning dmesg log.
> When a indr device add in offload success. The block->nooffloaddevcnt
> should be 0. After the representor go away. When the dir device go away
> the flow_block UNBIND operation with -EOPNOTSUPP which lead the warning
> demesg log. 
> The block->nooffloaddevcnt should always count for indr block.
> even the indr block offload successful. The representor maybe
> gone away and the ingress qdisc can work in software mode.

Series applied, thank you.
