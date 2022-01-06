Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A572486237
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 10:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237352AbiAFJkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 04:40:25 -0500
Received: from mail.netfilter.org ([217.70.188.207]:34702 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237471AbiAFJkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 04:40:24 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C7A7263F4F;
        Thu,  6 Jan 2022 10:37:35 +0100 (CET)
Date:   Thu, 6 Jan 2022 10:40:18 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Xiong <xiongx18@fudan.edu.cn>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuanxzhang@fudan.edu.cn, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: Re: [PATCH] netfilter: ipt_CLUSTERIP: fix refcount leak in
 clusterip_tg_check()
Message-ID: <Yda5AhpTTnsTnNp5@salvia>
References: <20211223024811.4519-1-xiongx18@fudan.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211223024811.4519-1-xiongx18@fudan.edu.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 23, 2021 at 10:48:12AM +0800, Xin Xiong wrote:
> The issue takes place in one error path of clusterip_tg_check(). When
> memcmp() returns nonzero, the function simply returns the error code,
> forgetting to decrease the reference count of a clusterip_config
> object, which is bumped earlier by clusterip_config_find_get(). This
> may incur reference count leak.
> 
> Fix this issue by decrementing the refcount of the object in specific
> error path.

Applied
