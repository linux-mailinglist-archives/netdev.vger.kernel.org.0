Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 732761A38B6
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 19:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgDIRN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 13:13:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33264 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgDIRN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 13:13:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 95A1C128C1250;
        Thu,  9 Apr 2020 10:13:56 -0700 (PDT)
Date:   Thu, 09 Apr 2020 10:13:55 -0700 (PDT)
Message-Id: <20200409.101355.534685961785562180.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net] net/ipv6: allow token to be set when accept_ra
 disabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200409065604.817-1-liuhangbin@gmail.com>
References: <20200409065604.817-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Apr 2020 10:13:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Thu,  9 Apr 2020 14:56:04 +0800

> The token setting should not depend on whether accept_ra is enabled or
> disabled. The user could set the token at any time. Enable or disable
> accept_ra only affects when the token address take effective.
> 
> On the other hand, we didn't remove the token setting when disable
> accept_ra. So let's just remove the accept_ra checking when user want
> to set token address.
> 
> Fixes: f53adae4eae5 ("net: ipv6: add tokenized interface identifier support")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

It is dangerous to change this, because now people can write bootup
and configuration scripts that will work with newer kernels yet fail
unexpectedly in older kernels.

I think requiring that RA be enabled in order to set the token is
an absolutely reasonable requirement.
