Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0850C1E538
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 00:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfENWkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 18:40:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59758 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfENWkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 18:40:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D05A814C043F2;
        Tue, 14 May 2019 15:40:44 -0700 (PDT)
Date:   Tue, 14 May 2019 15:40:44 -0700 (PDT)
Message-Id: <20190514.154044.1522144907282124471.davem@davemloft.net>
To:     sd@queasysnail.net
Cc:     netdev@vger.kernel.org, danw@redhat.com, nicolas.dichtel@6wind.com
Subject: Re: [PATCH net v3] rtnetlink: always put IFLA_LINK for links with
 a link-netnsid
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3ce6c14decb494908bd516698ec7f4de6001eef3.1557829576.git.sd@queasysnail.net>
References: <3ce6c14decb494908bd516698ec7f4de6001eef3.1557829576.git.sd@queasysnail.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 May 2019 15:40:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>
Date: Tue, 14 May 2019 15:12:19 +0200

> Currently, nla_put_iflink() doesn't put the IFLA_LINK attribute when
> iflink == ifindex.
> 
> In some cases, a device can be created in a different netns with the
> same ifindex as its parent. That device will not dump its IFLA_LINK
> attribute, which can confuse some userspace software that expects it.
> For example, if the last ifindex created in init_net and foo are both
> 8, these commands will trigger the issue:
> 
>     ip link add parent type dummy                   # ifindex 9
>     ip link add link parent netns foo type macvlan  # ifindex 9 in ns foo
> 
> So, in case a device puts the IFLA_LINK_NETNSID attribute in a dump,
> always put the IFLA_LINK attribute as well.
> 
> Thanks to Dan Winship for analyzing the original OpenShift bug down to
> the missing netlink attribute.
> 
> v2: change Fixes tag, it's been here forever, as Nicolas Dichtel said
>     add Nicolas' ack
> v3: change Fixes tag
>     fix subject typo, spotted by Edward Cree
> 
> Analyzed-by: Dan Winship <danw@redhat.com>
> Fixes: d8a5ec672768 ("[NET]: netlink support for moving devices between network namespaces.")
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Applied and queued up for -stable, thank you.
