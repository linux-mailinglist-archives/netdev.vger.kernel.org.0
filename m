Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3B91797C9
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 19:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730078AbgCDSYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 13:24:13 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40762 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgCDSYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 13:24:13 -0500
Received: by mail-qk1-f193.google.com with SMTP id m2so2613779qka.7
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 10:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7uGKfMEoQma2YTmYindpAJZ+6Dd9e8pZRREodN0XilM=;
        b=Mia0eqxiqiZ+f66hq7l6dJh58ejISZYPQsbp5h2zfh7vp/vvIx56r1xShga41jPdFM
         e087spTKJZixh1I+cmplDpNzi7uP35TRbI1WyoV55iFHQD4y3aa6Uo2Qu0p2vZwEm2oU
         BRwcjvdDuzGLgSRxdxHfjKtJb+I2IfhjPZsOtLFRERV44TCfb8vgRINjDujDhZCBL1Mq
         8YVUWjbZl7bQOQtQy8+7vDn0tuTUhfGryD1aZ7KDHPo2Aenypv0LbCQ5WMge9hDq26G5
         nheK73Rsky6AO2srjk5QIAx2fj2tGoYcKvDjnWOBiJIX4MtqPoKvSOkAsok1NVDRiJdf
         Y6Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7uGKfMEoQma2YTmYindpAJZ+6Dd9e8pZRREodN0XilM=;
        b=Iwnk7PWSAfo5Y6pYw0y7qfzAq2hPGTGTlPc7jS9evVbxLG0njBmFBtUW+YJ2G03IQP
         +Wg/P4EmSTQD+o9gabZZAX+7xLPjj32UASDv6pdRoOBe7XyXVn307J23ZhRt6QyhmBI6
         EeeX9xZnf56k977MPN2SSTEzpwQWaYnxfrVnqXSj3ZZcprmj/p9wBjVFpMgsGpKbXMtZ
         4dXeeSO8hSAiW1482q9vDPvczsDXCw6h5VsOozI1EoTt49Ojb0+klX7HmZA6dZNE/U76
         k9aQx+wQp05JK+KORnRTHgUonbYcZ2SC8ZfEy3leKXskyhoNtSMzAp1vtIspXFRhqUp0
         jpFg==
X-Gm-Message-State: ANhLgQ0jo4ZOzA3dNL+IUzYd1+QQFyV1cHj0Q4pFUguRbwavoO+tP5At
        R7umbhtM+rOHWeBNORBQIH7awA==
X-Google-Smtp-Source: ADFU+vtRodrQGutbTEE2PU9HNmEC1IZAyA11ZBYfVhgiKLz7nf/pB721n80U6tbbZtje9FYX/xbyrw==
X-Received: by 2002:a05:620a:2012:: with SMTP id c18mr3760545qka.242.1583346252226;
        Wed, 04 Mar 2020 10:24:12 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id 133sm14361291qkh.109.2020.03.04.10.24.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Mar 2020 10:24:11 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j9Ygl-0000KJ-CH; Wed, 04 Mar 2020 14:24:11 -0400
Date:   Wed, 4 Mar 2020 14:24:11 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Bernard Metzler <bmt@zurich.ibm.com>
Cc:     chuck.lever@oracle.com, dledford@redhat.com, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, parav@mellanox.com,
        syzkaller-bugs@googlegroups.com, willy@infradead.org
Subject: Re: [PATCH for-rc] RDMA/siw: Fix passive connection establishment
Message-ID: <20200304182411.GA1201@ziepe.ca>
References: <20200228173534.26815-1-bmt@zurich.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228173534.26815-1-bmt@zurich.ibm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 06:35:34PM +0100, Bernard Metzler wrote:
> Holding the rtnl_lock while iterating a devices interface
> address list potentially causes deadlocks with the
> cma_netdev_callback. While this was implemented to
> limit the scope of a wildcard listen to addresses
> of the current device only, a better solution limits
> the scope of the socket to the device. This completely
> avoiding locking, and also results in significant code
> simplification.
> 
> Reported-by: syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Bernard Metzler <bmt@zurich.ibm.com>
> ---
>  drivers/infiniband/sw/siw/siw_cm.c | 137 +++++++----------------------
>  1 file changed, 31 insertions(+), 106 deletions(-)

Applied to for-next, the possibility of hitting the locking inversion
found by syzkaller is really remote as you'd have to run siw on top of
bond and then do horrible things to the bond.

Jason
