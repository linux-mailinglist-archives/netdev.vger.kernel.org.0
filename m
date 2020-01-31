Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17E0414EF7E
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgAaPYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:24:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:36772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728839AbgAaPYz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 10:24:55 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FAF3206D5;
        Fri, 31 Jan 2020 15:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580484294;
        bh=6eUfGgz3kBEIseVijgM/54BogfoQn6rLjOMr0aFBNS4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BJ0IZAnpiNXUyO3b5AiQ0cLwWIKDijZXcmZZItkasz9i4p7L8HgVbG2PftuoKzabo
         l/923c5NGap4iKOx+Lx4rISD87YCnY+rgCRm0MX6lJznbhBm5MfJcFoXC287RZY/T1
         epoYGnK5kvY1FQYQfqAhi78TLihUqfKmGtcww9SQ=
Date:   Fri, 31 Jan 2020 07:24:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, vladimir.oltean@nxp.com,
        po.liu@nxp.com
Subject: Re: [PATCH net v3 1/2] taprio: Fix enabling offload with wrong
 number of traffic classes
Message-ID: <20200131072453.454930eb@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200130013721.33812-2-vinicius.gomes@intel.com>
References: <20200130013721.33812-1-vinicius.gomes@intel.com>
        <20200130013721.33812-2-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jan 2020 17:37:20 -0800, Vinicius Costa Gomes wrote:
> If the driver implementing taprio offloading depends on the value of
> the network device number of traffic classes (dev->num_tc) for
> whatever reason, it was going to receive the value zero. The value was
> only set after the offloading function is called.
> 
> So, moving setting the number of traffic classes to before the
> offloading function is called fixes this issue. This is safe because
> this only happens when taprio is instantiated (we don't allow this
> configuration to be changed without first removing taprio).
> 
> Fixes: 9c66d1564676 ("taprio: Add support for hardware offloading")
> Reported-by: Po Liu <po.liu@nxp.com>
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>

What about Dave's question about resetting the tc state with
netdev_reset_tc()?
