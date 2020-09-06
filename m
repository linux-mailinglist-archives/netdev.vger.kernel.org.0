Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A423925F08D
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 23:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgIFVBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 17:01:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726154AbgIFVBj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 17:01:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE64420760;
        Sun,  6 Sep 2020 21:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599426098;
        bh=AUZ/2jkw3ge8yjc1a8PiX5fWdFUU6aD/oCLWbA0734k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LBKh9F2hTcvYB3ARX6ZwaseOZOrUrDgCqir96n5JHPs6agXDa0p2EiDiWxSrJYuyF
         Lj3jIvfilxO4MF9xETaFZAUDQsJ1p3BnIdHLRh/pLM45iPt+FvzsX+pMiARbpjhwwH
         Nm6FfYGakfqepkH52Ur0zq9ILJDmQT0j3+DkdYj8=
Date:   Sun, 6 Sep 2020 14:01:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net
Subject: Re: [PATCH net-next v3 06/15] net: bridge: mcast: add support for
 group query retransmit
Message-ID: <20200906140136.77ae178d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200905082410.2230253-7-nikolay@cumulusnetworks.com>
References: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
        <20200905082410.2230253-7-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Sep 2020 11:24:01 +0300 Nikolay Aleksandrov wrote:
> We need to be able to retransmit group-specific and group-and-source
> specific queries. The new timer takes care of those.

What guarantees that timer will not use pg after free? Do timer
callbacks hold the RCU read lock?
