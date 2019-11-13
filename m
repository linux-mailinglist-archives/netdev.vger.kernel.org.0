Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93895FBBA8
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 23:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfKMWdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 17:33:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39328 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbfKMWdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 17:33:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4C275128F3858;
        Wed, 13 Nov 2019 14:33:42 -0800 (PST)
Date:   Wed, 13 Nov 2019 14:33:39 -0800 (PST)
Message-Id: <20191113.143339.63552073098179182.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     irusskikh@marvell.com, ndanilov@marvell.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: atlantic: Signedness bug in aq_vec_isr_legacy()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191113183158.rogxsza632ppeen3@kili.mountain>
References: <20191113183158.rogxsza632ppeen3@kili.mountain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 Nov 2019 14:33:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 13 Nov 2019 21:31:58 +0300

> irqreturn_t type is an enum and in this context it's unsigned, so "err"
> can't be irqreturn_t or it breaks the error handling.  In fact the "err"
> variable is only used to store integers (never irqreturn_t) so it should
> be declared as int.
> 
> I removed the initialization because it's not required.  Using a bogus
> initializer turns off GCC's uninitialized variable warnings.  Secondly,
> there is a GCC warning about unused assignments and we would like to
> enable that feature eventually so we have been trying to remove these
> unnecessary initializers.
> 
> Fixes: 7b0c342f1f67 ("net: atlantic: code style cleanup")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
