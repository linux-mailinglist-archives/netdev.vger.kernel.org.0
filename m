Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE2128A84B
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 18:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730246AbgJKQyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 12:54:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729764AbgJKQyi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 12:54:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF3E321655;
        Sun, 11 Oct 2020 16:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602435278;
        bh=4zVGZfkfDuY637X0Q4hSpEFjVbRI9H7278GF/Bv9XmI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JpW78wvBb7iHONUXHd/t/YcDsDNgaWLHk1NdI7Hu7D/OTwU4QdvuKe8Lj619mfh3X
         GcIhwdgp6nHHtsC9obVC48zXg949YwaoC50ZhkXmNocIot2ddR3zzlRvKx+jA+JCGS
         DboGB2xxjjK2CcuRspFEU/qdGb2ovX9swSneNoFY=
Date:   Sun, 11 Oct 2020 09:54:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anmol Karn <anmol.karan123@gmail.com>
Cc:     davem@davemloft.net, mkubecek@suse.cz, andrew@lunn.ch,
        f.fainelli@gmail.com, dan.carpenter@oracle.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com,
        syzbot+9d1389df89299fa368dc@syzkaller.appspotmail.com
Subject: Re: [Linux-kernel-mentees] [PATCH net] ethtool: strset: Fix out of
 bound read in strset_parse_request()
Message-ID: <20201011095436.06131ff3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201010210929.620244-1-anmol.karan123@gmail.com>
References: <20201010210929.620244-1-anmol.karan123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Oct 2020 02:39:29 +0530 Anmol Karn wrote:
> Flag ``ETHTOOL_A_STRSET_COUNTS_ONLY`` tells the kernel to only return the string 
> counts of the sets, but, when req_info->counts_only tries to read the 
> tb[ETHTOOL_A_STRSET_COUNTS_ONLY] it gets out of bound. 
> 
> - net/ethtool/strset.c
> The bug seems to trigger in this line:
> 
> req_info->counts_only = tb[ETHTOOL_A_STRSET_COUNTS_ONLY];
> 
> Fix it by NULL checking for req_info->counts_only while 
> reading from tb[ETHTOOL_A_STRSET_COUNTS_ONLY].
> 
> Reported-by: syzbot+9d1389df89299fa368dc@syzkaller.appspotmail.com 
> Link: https://syzkaller.appspot.com/bug?id=730deff8fe9954a5e317924d9acff98d9c64a770 
> Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>

I think the correct fix for this was already applied to net-next as:

 commit db972e532518 ("ethtool: strset: allow ETHTOOL_A_STRSET_COUNTS_ONLY attr")
