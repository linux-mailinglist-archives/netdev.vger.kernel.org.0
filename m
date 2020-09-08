Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F05260919
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 05:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgIHDtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 23:49:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728327AbgIHDtY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 23:49:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CA1C2080A;
        Tue,  8 Sep 2020 03:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599536963;
        bh=1JF9ErwwV+qLjfbssjhvOAA1nzkFV5n0GXMMuBk2Sa8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kv1F3mm49dkxGSDp+x5x+JDeQbZIzZ6QhGmkLA17nzvHXRe/Tj3cgl1i++Gj2z1Hu
         ogXA/0F7v0FBxAWLSz4vxShs+rbOmhQd2poEqFncqcCW7rYWe2dgAjoWOtdw84GD3u
         wClHz0qCGdRmz9/87u+HV2NPmTPM9AgJnrBA1MYY=
Date:   Mon, 7 Sep 2020 20:49:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the net-next tree
Message-ID: <20200907204921.130dd6ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200908130000.7d33d787@canb.auug.org.au>
References: <20200908130000.7d33d787@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Sep 2020 13:00:00 +1000 Stephen Rothwell wrote:
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> net/bridge/br_multicast.c: In function 'br_multicast_find_port':
> net/bridge/br_multicast.c:1818:21: warning: unused variable 'br' [-Wunused-variable]
>  1818 |  struct net_bridge *br = mp->br;
>       |                     ^~
> 
> Introduced by commit
> 
>   0436862e417e ("net: bridge: mcast: support for IGMPv3/MLDv2 ALLOW_NEW_SOURCES report")
> 
> Maybe turning mlock_dereference into a static inline function would help.

Or perhaps provide a better definition of whatever is making the
reference disappear? RCU_LOCKDEP_WARN()?

Thanks for the report!
