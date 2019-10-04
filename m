Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 195B0CC255
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 20:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbfJDSLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 14:11:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57442 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728095AbfJDSLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 14:11:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9567A14BE9E92;
        Fri,  4 Oct 2019 11:11:36 -0700 (PDT)
Date:   Fri, 04 Oct 2019 11:11:33 -0700 (PDT)
Message-Id: <20191004.111133.1035307264097392906.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: Re: [patch net-next v3 00/15] devlink: allow devlink instances to
 change network namespace
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191003094940.9797-1-jiri@resnulli.us>
References: <20191003094940.9797-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 11:11:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Thu,  3 Oct 2019 11:49:25 +0200

> Devlink from the beginning counts with network namespaces, but the
> instances has been fixed to init_net.
> 
> Implement change of network namespace as part of "devlink reload"
> procedure like this:
> 
> $ ip netns add testns1
> $ devlink/devlink dev reload netdevsim/netdevsim10 netns testns1
> 
> This command reloads device "netdevsim10" into network
> namespace "testns1".
> 
> Note that "devlink reload" reinstantiates driver objects, effectively it
> reloads the driver instance, including possible hw reset etc. Newly
> created netdevices respect the network namespace of the parent devlink
> instance and according to that, they are created in target network
> namespace.
> 
> Driver is able to refuse to be reloaded into different namespace. That
> is the case of mlx4 right now.
> 
> FIB entries and rules are replayed during FIB notifier registration
> which is triggered during reload (driver instance init). FIB notifier
> is also registered to the target network namespace, that allows user
> to use netdevsim devlink resources to setup per-namespace limits of FIB
> entries and FIB rules. In fact, with multiple netdevsim instances
> in each network namespace, user might setup different limits.
> This maintains and extends current netdevsim resources behaviour.
 ...

Series applied, thanks Jiri.
