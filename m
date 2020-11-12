Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F9B2B12B5
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgKLXWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:22:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:58154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725929AbgKLXWn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 18:22:43 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E696216C4;
        Thu, 12 Nov 2020 23:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605223362;
        bh=HABR+gCW3tD/Zh5XW1nVWu/T+8hrcQmzKZsLDrSWzYk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FAik7gIPZNHDA1glr8SjkuUnptPJpJbkc9y2OK0VB+nYxKfKICMitTUYU10wOZQPQ
         mxCuaaUtCkAnko3LJ4cUiMF5fQrCQ8DyFDiy5Girpyfy3LuKCOrEL8ZxFg9/b7pS+u
         o5OziDbMDPrDNyob65BFlnfVUH9cZTLObYrHmCeA=
Date:   Thu, 12 Nov 2020 15:22:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joel Stanley <joel@jms.id.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andrew Jeffery <andrew@aj.id.au>,
        Ivan Mikhaylov <i.mikhaylov@yadro.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: ftgmac100: Fix crash when removing driver
Message-ID: <20201112152241.7a3acaca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112003145.831169-1-joel@jms.id.au>
References: <20201112003145.831169-1-joel@jms.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 11:01:45 +1030 Joel Stanley wrote:
> When removing the driver we would hit BUG_ON(!list_empty(&dev->ptype_specific))
> in net/core/dev.c due to still having the NC-SI packet handler
> registered.

> Fixes: bd466c3fb5a4 ("net/faraday: Support NCSI mode")
> Signed-off-by: Joel Stanley <joel@jms.id.au>

Thanks for the fix, I think there is another one of those missing in 
the error path of ftgmac100_probe(), right?  Under err_ncsi_dev?
