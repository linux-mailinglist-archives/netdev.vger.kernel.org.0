Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08B0D47211
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 22:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfFOUcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 16:32:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39354 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfFOUcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 16:32:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F126814EB8616;
        Sat, 15 Jun 2019 13:32:41 -0700 (PDT)
Date:   Sat, 15 Jun 2019 13:32:41 -0700 (PDT)
Message-Id: <20190615.133241.1697724537695155418.davem@davemloft.net>
To:     houjingyi647@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix double-fetch bug in sock_getsockopt()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190613104457.GA6296@hjy-HP-Notebook>
References: <20190613104457.GA6296@hjy-HP-Notebook>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 15 Jun 2019 13:32:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: JingYi Hou <houjingyi647@gmail.com>
Date: Thu, 13 Jun 2019 18:44:57 +0800

> In sock_getsockopt(), 'optlen' is fetched the first time from userspace.
> 'len < 0' is then checked. Then in condition 'SO_MEMINFO', 'optlen' is
> fetched the second time from userspace without check.
> 
> if a malicious user can change it between two fetches may cause security
> problems or unexpected behaivor.
> 
> To fix this, we need to recheck it in the second fetch.
> 
> Signed-off-by: JingYi Hou <houjingyi647@gmail.com>

THere is no reason to fetch len a second time, so please just remove
the get_user() call here instead.

Also, please format your Subject line properly with appropriate subsystem
prefixes etc.
