Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4512AE4C9
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 01:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731610AbgKKAQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 19:16:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:58068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbgKKAQr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 19:16:47 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96D432064B;
        Wed, 11 Nov 2020 00:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605053806;
        bh=tkQOmZyD57FSF59MGwykqJxbqghJvMAwyf3uH7u6D6A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TyUmjpJsoFEHvtOK6s1oaY2KZkPjx8Va1PVyflnyjIb/Xa2GoVW636iqKhB3tZyBy
         lHNCKklzDzBwOQaHTYlVAHe2Hz9/FkPX2E+YKjhFLg+eBDMU3HIo3zFCcRDWUgjgqI
         2BOyP/HXHwxKel3jMzaFagMjsiI74URoK7tg8V0Y=
Date:   Tue, 10 Nov 2020 16:16:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wenxu@ucloud.cn
Cc:     marcelo.leitner@gmail.com, dcaratti@redhat.com, vladbu@nvidia.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v6 net-next 3/3] net/sched: act_frag: add implict packet
 fragment support.
Message-ID: <20201110161640.05ebc52c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604989686-8171-4-git-send-email-wenxu@ucloud.cn>
References: <1604989686-8171-1-git-send-email-wenxu@ucloud.cn>
        <1604989686-8171-4-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 14:28:06 +0800 wenxu@ucloud.cn wrote:
> +static int (*tcf_xmit_hook)(struct sk_buff *skb,
> +			    int (*xmit)(struct sk_buff *skb));

missing the rcu annotation on this

net/sched/act_api.c:35:17: error: incompatible types in comparison expression (different address spaces):
net/sched/act_api.c:35:17:    int ( [noderef] __rcu * )( ... )
net/sched/act_api.c:35:17:    int ( * )( ... )
net/sched/act_api.c:52:17: error: incompatible types in comparison expression (different address spaces):
net/sched/act_api.c:52:17:    int ( [noderef] __rcu * )( ... )
net/sched/act_api.c:52:17:    int ( * )( ... )
net/sched/act_api.c:64:21: error: incompatible types in comparison expression (different address spaces):
net/sched/act_api.c:64:21:    int ( [noderef] __rcu * )( ... )
net/sched/act_api.c:64:21:    int ( * )( ... )
