Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BE11B25A0
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 14:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgDUMK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 08:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728680AbgDUMKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 08:10:24 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3CAC061A10
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 05:10:24 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id ep1so384087qvb.0
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 05:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=J8kMnoTAf5N/1/mqlMzmP0TcaVH3d2tPygufRLATZSc=;
        b=K3aWlbF5pgAeUL9C5H05pCE+cFLJ8DOJz7Y4/soPQoNTvHjxJMCQ/5syH3SfTgvvJE
         P4+TL/Qm2q/ZvbVWwuF42VgGzkO1sBd/3lYPyWe/nUcNnVWYlmRVXrkEqAqWhUXO8V6i
         2etxUBOOWMncFghUdV03KYof2saAARy2dDK8Bd2FdFHSlZAji89iqCUUryh19t+QfJ5e
         OIAORAf86jOKsCK2Gp/U5eO+CtUUd5NjGZdMD2w6VlId/FMHgTkzshD8nqZzwfafOjJj
         3/024sLc+tCuzKtnXx4oEZOJzoxHt82v5+73uVen3jnrKXvfQDC9Lib3wVbOGIySPkBP
         5o1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=J8kMnoTAf5N/1/mqlMzmP0TcaVH3d2tPygufRLATZSc=;
        b=eOWYosdRRTdex3tvXPG3NwgvOvfDW45puZg8yEzb7qLKQ/YLRzURzxiA9VQBbeKJSw
         99b0u3I4bTJwpsdiozLlROUqE7aOk9yAsHBmoA0Qx435E61UdDJEP+exrsNFNRorzW07
         0agvVkvT2qG7sWiw3qVXaWY5DvBhJmmYU2Ak3SLzWvoDs+/esbmqM6mp2IdWLiXAUQG2
         B2DjDCenbH9mKlXr8CFxYl2zQhJm5H8RPHSRJZqVeAb+Jr2VyD+5aTCnUdHFDYn8VU8B
         SBEbdH2UzxlS4hucXRD8025MMRdhVfcuhKD0JQz/7uhnMTvBMhZl4EQJicOumuePkmv1
         CFDQ==
X-Gm-Message-State: AGi0PuZwBTE0iX4RhUylsMWHDe+oFJISMdyIGMuIQGVNkVHuXNtJeGIp
        qBnZcKc1FzNrc3RwYziJbF8+GA==
X-Google-Smtp-Source: APiQypLISq769By5rj05kVgIJcl0/1iuN+LwoiI8fYSSVn/+qmWJ+fURRXGWwooSQQvq4PA8hgdxGA==
X-Received: by 2002:ad4:4966:: with SMTP id p6mr12953272qvy.161.1587471023421;
        Tue, 21 Apr 2020 05:10:23 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id 103sm1582932qte.82.2020.04.21.05.10.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Apr 2020 05:10:22 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jQrjK-0007wM-2b; Tue, 21 Apr 2020 09:10:22 -0300
Date:   Tue, 21 Apr 2020 09:10:22 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, parav@mellanox.com,
        galpress@amazon.com, selvin.xavier@broadcom.com,
        sriharsha.basavapatna@broadcom.com, benve@cisco.com,
        bharat@chelsio.com, xavier.huwei@huawei.com, yishaih@mellanox.com,
        leonro@mellanox.com, mkalderon@marvell.com, aditr@vmware.com,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com
Subject: Re: [net-next v2 0/9][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-04-20
Message-ID: <20200421121022.GS26002@ziepe.ca>
References: <20200421080235.6515-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421080235.6515-1-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 01:02:26AM -0700, Jeff Kirsher wrote:
> This series contains the initial implementation of the Virtual Bus,
> virtbus_device, virtbus_driver, updates to 'ice' and 'i40e' to use the new
> Virtual Bus.
> 
> The primary purpose of the Virtual bus is to put devices on it and hook the
> devices up to drivers.  This will allow drivers, like the RDMA drivers, to
> hook up to devices via this Virtual bus.
> 
> This series currently builds against net-next tree.
> 
> Revision history:
> v2: Made changes based on community feedback, like Pierre-Louis's and
>     Jason's comments to update virtual bus interface.

A lot of stuff has been ignored, why?

Jason
