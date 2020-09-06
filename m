Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9B125F0BD
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 23:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbgIFVcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 17:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726971AbgIFVcE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 17:32:04 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BB972078E;
        Sun,  6 Sep 2020 21:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599427924;
        bh=x7lb0UZTlIWVHwJpwneuTZolf6e4+q5mL7jqqbRFG+U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X0XL8nBRkYfyOYoNewrQJsLl35GLAbka8CG0Hrqf0DCajJT1rt1d0T57DAvQlQ7/y
         N8kZM8plfpUFuZp0VC5hRSBMpMYtKOCUVgxe6o2YaQA/hua2umyVNp6+E+3WStBtri
         iYUqScPl323ZMmfheBOdpwmShY8eBUXoRvj2d2hI=
Date:   Sun, 6 Sep 2020 14:32:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net
Subject: Re: [PATCH net-next v3 06/15] net: bridge: mcast: add support for
 group query retransmit
Message-ID: <20200906143203.011eb7ea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <4f8ec4f0-6311-3b18-c7c4-a3a49b8d94b4@cumulusnetworks.com>
References: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
        <20200905082410.2230253-7-nikolay@cumulusnetworks.com>
        <20200906140136.77ae178d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <4f8ec4f0-6311-3b18-c7c4-a3a49b8d94b4@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Sep 2020 00:14:51 +0300 Nikolay Aleksandrov wrote:
> On 9/7/20 12:01 AM, Jakub Kicinski wrote:
> > On Sat,  5 Sep 2020 11:24:01 +0300 Nikolay Aleksandrov wrote:  
> >> We need to be able to retransmit group-specific and group-and-source
> >> specific queries. The new timer takes care of those.  
> > 
> > What guarantees that timer will not use pg after free? Do timer
> > callbacks hold the RCU read lock?
> 
> See the last patch, it guarantees no entry timer will be used when it's freed.

Ack.
