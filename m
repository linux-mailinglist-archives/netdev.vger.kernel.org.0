Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF1CD574B
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 20:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbfJMSU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 14:20:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42710 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbfJMSU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 14:20:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0906F146D8339;
        Sun, 13 Oct 2019 11:20:58 -0700 (PDT)
Date:   Sun, 13 Oct 2019 11:20:57 -0700 (PDT)
Message-Id: <20191013.112057.237383467723026890.davem@davemloft.net>
To:     mkubecek@suse.cz
Cc:     jiri@mellanox.com, johannes@sipsolutions.net,
        jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] genetlink: do not parse attributes for
 families with zero maxattr
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191011084544.91E73E378C@unicorn.suse.cz>
References: <20191011084544.91E73E378C@unicorn.suse.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 13 Oct 2019 11:20:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Fri, 11 Oct 2019 09:40:09 +0200

> Commit c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing
> to a separate function") moved attribute buffer allocation and attribute
> parsing from genl_family_rcv_msg_doit() into a separate function
> genl_family_rcv_msg_attrs_parse() which, unlike the previous code, calls
> __nlmsg_parse() even if family->maxattr is 0 (i.e. the family does its own
> parsing). The parser error is ignored and does not propagate out of
> genl_family_rcv_msg_attrs_parse() but an error message ("Unknown attribute
> type") is set in extack and if further processing generates no error or
> warning, it stays there and is interpreted as a warning by userspace.
> 
> Dumpit requests are not affected as genl_family_rcv_msg_dumpit() bypasses
> the call of genl_family_rcv_msg_attrs_parse() if family->maxattr is zero.
> Move this logic inside genl_family_rcv_msg_attrs_parse() so that we don't
> have to handle it in each caller.
> 
> v3: put the check inside genl_family_rcv_msg_attrs_parse()
> v2: adjust also argument of genl_family_rcv_msg_attrs_free()
> 
> Fixes: c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing to a separate function")
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Applied, thanks.
