Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2A9C96DF5
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 01:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfHTX5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 19:57:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53098 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfHTX5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 19:57:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9F80614DB4E8E;
        Tue, 20 Aug 2019 16:57:30 -0700 (PDT)
Date:   Tue, 20 Aug 2019 16:57:28 -0700 (PDT)
Message-Id: <20190820.165728.2062957580528299761.davem@davemloft.net>
To:     willy@infradead.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 23/38] cls_api: Convert tcf_net to XArray
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190820223259.22348-24-willy@infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
        <20190820223259.22348-24-willy@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 20 Aug 2019 16:57:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthew Wilcox <willy@infradead.org>
Date: Tue, 20 Aug 2019 15:32:44 -0700

> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> This module doesn't use the allocating functionality; convert it to a
> plain XArray instead of an allocating one.  I've left struct tcf_net
> in place in case more objects are added to it in future, although
> it now only contains an XArray.  We don't need to call xa_destroy()
> if the array is empty, so I've removed the contents of tcf_net_exit()
> -- if it can be called with entries still in place, then it shoud call
> xa_destroy() instead.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

I don't know if the net exit can be invoked with entires still in place,
however if the tcf_net_exit() function is made empty it should be removed
along with the assignment to the per-netns ops.
