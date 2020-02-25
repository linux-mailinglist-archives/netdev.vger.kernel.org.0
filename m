Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A91316EE1C
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 19:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731461AbgBYShI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 13:37:08 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48442 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727983AbgBYShI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 13:37:08 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A09ED136485BE;
        Tue, 25 Feb 2020 10:37:07 -0800 (PST)
Date:   Tue, 25 Feb 2020 10:37:04 -0800 (PST)
Message-Id: <20200225.103704.704767230548147269.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     netdev@vger.kernel.org, tgraf@suug.ch
Subject: Re: [bug report] dcbnl: Shorten all command handling functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200225071408.gbrnwkr7q5kcj33v@kili.mountain>
References: <20200225071408.gbrnwkr7q5kcj33v@kili.mountain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Feb 2020 10:37:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 25 Feb 2020 10:14:08 +0300

> The patch 7be994138b18: "dcbnl: Shorten all command handling
> functions" from Jun 13, 2012, leads to the following static checker
> warning:
> 
> 	net/dcb/dcbnl.c:1509 dcbnl_ieee_set()
> 	warn: passing signed to unsigned: 'err'

The problem exists before this commit, it's just that the u8 truncated
'err' is passed into dcbnl_reply().

Yeah this is quite a mess.
