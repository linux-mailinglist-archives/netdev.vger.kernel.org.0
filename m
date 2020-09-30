Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C3D27F427
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730304AbgI3VXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbgI3VXZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 17:23:25 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C53C72072E;
        Wed, 30 Sep 2020 21:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601501004;
        bh=l12F6fn5NBkQDy/HRwFY3zeLDl+aZOA/yCelyYzONwg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a6diYOBXxE8eFcH78AUBosVpk3e4eQpIPv3Zrvs8tIkfWmgdK45qR/2oBcwBNCCh7
         eGtEvoQuqu8lY/vQlFETu4NZemSG3O7wwSC/X6Q1b9a93kwwc8nV5NKM49o+uyPaMv
         rusuKBJbJCryFBUvvEsMWmBebHA8A+ghu03Xyy4g=
Date:   Wed, 30 Sep 2020 14:23:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/4] gve: Rx Buffer Recycling
Message-ID: <20200930142323.00aa8329@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAL9ddJeFSg2onpa7O9PXt8rqHS7WUFCnpJYu+scHTiQtHRTQig@mail.gmail.com>
References: <20200924010104.3196839-1-awogbemila@google.com>
        <20200924010104.3196839-4-awogbemila@google.com>
        <20200924160055.1e7be259@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAL9ddJeFSg2onpa7O9PXt8rqHS7WUFCnpJYu+scHTiQtHRTQig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Sep 2020 09:10:02 -0700 David Awogbemila wrote:
> > What if the queue runs completely dry during memory shortage?
> > You need some form of delayed work to periodically refill
> > the free buffers, right?  
> 
> Thanks, this looks like it will require modifications that will need
> to be well tested.
> Just for my own curiosity, how common of an occurrence are such memory
> shortages?

Depends on the workload. For some apps they are very common.
