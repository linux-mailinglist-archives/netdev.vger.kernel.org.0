Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE27792CA
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 20:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbfG2SII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 14:08:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37058 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727482AbfG2SII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 14:08:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 65B9014051852;
        Mon, 29 Jul 2019 11:08:07 -0700 (PDT)
Date:   Mon, 29 Jul 2019 11:08:07 -0700 (PDT)
Message-Id: <20190729.110807.1476818178420042682.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, xemul@virtuozzo.com, edumazet@google.com,
        pabeni@redhat.com, idosch@mellanox.com, petrm@mellanox.com,
        sd@queasysnail.net, f.fainelli@gmail.com,
        stephen@networkplumber.org, mlxsw@mellanox.com, jiri@mellanox.com
Subject: Re: [patch net] net: fix ifindex collision during namespace removal
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190728125636.13895-1-jiri@resnulli.us>
References: <20190728125636.13895-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 11:08:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Sun, 28 Jul 2019 14:56:36 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Commit aca51397d014 ("netns: Fix arbitrary net_device-s corruptions
> on net_ns stop.") introduced a possibility to hit a BUG in case device
> is returning back to init_net and two following conditions are met:
> 1) dev->ifindex value is used in a name of another "dev%d"
>    device in init_net.
> 2) dev->name is used by another device in init_net.
> 
> Under real life circumstances this is hard to get. Therefore this has
> been present happily for over 10 years. To reproduce:
 ...
> Fix this by checking if a device with the same name exists in init_net
> and fallback to original code - dev%d to allocate name - in case it does.
> 
> This was found using syzkaller.
> 
> Fixes: aca51397d014 ("netns: Fix arbitrary net_device-s corruptions on net_ns stop.")
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Very interesting :)

Applied and queued up for -stable, thanks.
