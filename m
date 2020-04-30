Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E2C1BECE3
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 02:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgD3AMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 20:12:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbgD3AMk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 20:12:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF5BD20787;
        Thu, 30 Apr 2020 00:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588205560;
        bh=fk38mmy+LZopCMxGk1gZNJyPRI+3HhMUh0H6XcRwNHU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rR4eyik4D2yn9oGBMZnO/aq/aEXFfADmvMn6MWxay+/g56NNn6AooIiyQ4B1rVo3c
         /LJG7en6CwF44MAzx0Z0PYd3N1m7PwQgWS6GMWfBS/dwvST6AjDk7gSlT6pYgJgNZH
         aXH9eE09KzbfPQViMI7U7dI0mXCF1l+oWuwdql5Q=
Date:   Wed, 29 Apr 2020 17:12:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>
Subject: Re: [net 8/8] net/mlx5e: kTLS, Add resiliency to zero-size record
 frags in TX resync flow
Message-ID: <20200429171238.3f3a552a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200429225449.60664-9-saeedm@mellanox.com>
References: <20200429225449.60664-1-saeedm@mellanox.com>
        <20200429225449.60664-9-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Apr 2020 15:54:49 -0700 Saeed Mahameed wrote:
> From: Tariq Toukan <tariqt@mellanox.com>
> 
> SKBs of TLS records might have empty zero-sized frags.

Why? Let's fix that instead of adding checks to drivers.

> Posting a DUMP WQE for such frag would result an error completion.
> Add in-driver resiliency and skip such frags.
> 
> Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
