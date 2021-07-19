Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D4A3CD186
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 12:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236011AbhGSJZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 05:25:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235676AbhGSJZI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 05:25:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 390B9610FB;
        Mon, 19 Jul 2021 10:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626689148;
        bh=elq9AwtXUXxwMlcmvki583LUA+hdla6CBUE7hm+4Oh8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qVYPhN33f05z2J82OSgEZ9dkcOewkhvON70Rd1k+FZZAUr9DnVGp9oCl+pUAVXf4K
         sZLbBWVb3w51VvIpLNZFsiOVtMKcp9NFbnKb7YnMiV9ATGF+nRRhHYVmLC8Tf/80hN
         NT18uS20a42oauGNoY5Af7rqWU2wD/22gtuxCBzvdeTLtlH+65vhfBQQo/8zXqqXgN
         FRoXltH2QExRuZbt+SlPg51/t7w4w4/YMf9MYb9XJ4Fczrl5lb0UcBlauNaX38SlKp
         s67f2TLanfXt1wR+mEjPouh75lERlwLQLLe+u0FDkCQYlJ1yyIZQ79q0yUyUTfEidt
         H/IUNC6WyjuGA==
Date:   Mon, 19 Jul 2021 12:05:41 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+13ad608e190b5f8ad8a8@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: 802: fix memory leak in garp_uninit_applicant
Message-ID: <20210719120541.7262fc70@cakuba>
In-Reply-To: <20210718210006.26212-1-paskripkin@gmail.com>
References: <20210718210006.26212-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Jul 2021 00:00:06 +0300, Pavel Skripkin wrote:
> Syzbot reported memory leak in garp_uninit_applicant(). The problem was
> in missing clean up function in garp_uninit_applicant().

Looks like it's fixed in net by commit 42ca63f98084 ("net/802/garp: fix
memleak in garp_request_join()"), would you mind double checking that fix 
and closing the syzbot report manually?

Similar with your MRP patch and commit 996af62167d0 ("net/802/mrp: fix
memleak in mrp_request_join()").
