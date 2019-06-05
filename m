Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32E1336866
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 01:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfFEXzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 19:55:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42494 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfFEXzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 19:55:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1D041136E16AB;
        Wed,  5 Jun 2019 16:55:46 -0700 (PDT)
Date:   Wed, 05 Jun 2019 16:55:45 -0700 (PDT)
Message-Id: <20190605.165545.1484056704164319975.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] nfp: flower: use struct_size() helper
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190605203827.GA22786@embeddedor>
References: <20190605203827.GA22786@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 16:55:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Wed, 5 Jun 2019 15:38:27 -0500

> One of the more common cases of allocation size calculations is finding
> the size of a structure that has a zero-sized array at the end, along
> with memory for some number of elements for that array. For example:
> 
> struct nfp_tun_active_tuns {
> 	...
>         struct route_ip_info {
>                 __be32 ipv4;
>                 __be32 egress_port;
>                 __be32 extra[2];
>         } tun_info[];
> };
> 
> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes.
> 
> So, replace the following form:
> 
> sizeof(struct nfp_tun_active_tuns) + sizeof(struct route_ip_info) * count
> 
> with:
> 
> struct_size(payload, tun_info, count)
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Applied.
