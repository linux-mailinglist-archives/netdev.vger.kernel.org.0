Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752101CB9BB
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 23:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgEHVYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 17:24:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbgEHVYg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 17:24:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8823214D8;
        Fri,  8 May 2020 21:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588973076;
        bh=vFL4918CBQE8qWR6nE4dBwVdBJZTJ5MsC8qe5CpPzgo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Dh5r1XtFCMuehqdt+G1QyxjEoBzdUqQTqy2IrJygOgsi4DMqBTJy5icYOJxhlXtQ9
         SOP3qZOeYGRG4piU8Jd6llDECICIUeN1a3amZSJX5JPigAJfJaxLUzfy0Qy9fs1W1n
         2gLlXIsxpioMwuW8OolfX15MTXfPW3uF7DJ+UnW0=
Date:   Fri, 8 May 2020 14:24:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: Re: [PATCH net v1] hinic: fix a bug of ndo_stop
Message-ID: <20200508142434.0c437e43@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200507182227.20553-1-luobin9@huawei.com>
References: <20200507182227.20553-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 May 2020 18:22:27 +0000 Luo bin wrote:
> if some function in ndo_stop interface returns failure because of
> hardware fault, must go on excuting rest steps rather than return
> failure directly, otherwise will cause memory leak
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>

The code looks good, but would it make sense to split this patch into
two? First one that ignores the return values on close path with these
fixes tags:

Fixes: e2585ea77538 ("net-next/hinic: Add Rx handler")
Fixes: c4d06d2d208a ("net-next/hinic: Add Rx mode and link event handler")

And a separate patch which bumps the timeout for SET_FUNC_STATE? Right
now you don't even mention the timeout changes in the commit message.
