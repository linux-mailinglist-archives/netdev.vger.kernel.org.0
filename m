Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1F88149754
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 20:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgAYTE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 14:04:56 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:40655 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbgAYTE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 14:04:56 -0500
Received: by mail-yb1-f196.google.com with SMTP id l197so2810977ybf.7
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 11:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Lx6zoF9l+s8fFKaF/OITBTPQQ6pnY4nPkFOxXyCiQfs=;
        b=U50eu7Suc7wAyLlSOZPzcyaaIb7hfweFWL8mIHWg3XcgM+/2CfddjZjX85B6AgfcdL
         wlm9hoWmUi4F8079oXizn2SKFlnWbB9E4n1NKiCED/AYQ8I8k9EdF7D0povlbHUc2g6/
         pWoWblg2z/fmaOqGUOJjiqxbf2tg9OHNjSDiT+WTDvePDIOE2V9We7WFs7UzzZuzLU4u
         GqfdBRyBsmIEfpVzIwx9AGQvT6haU3adTXVLE0Xu72VVztQJ+kr5bi/Q5x+oFnlCQQ2J
         BqykTVZRwJ7u5Zne7of8/BDdSs6xftUL6Qvj4U3jB6nlmimUwT70CYpPzw2/BqoMtDAG
         Dk3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Lx6zoF9l+s8fFKaF/OITBTPQQ6pnY4nPkFOxXyCiQfs=;
        b=LSsmy0SOO6rBu5/84ZkcT7vBRvSmnK2dE4b05Wv2vsf4lzGoNsnQmoxnp0sFMwpI3O
         YLP8oC9Db9VzL17AmErUfTHHv0MTx9HvUJGRZ/Lho7ARzg7Sc71de5bBH+O/QIJk2NkW
         BtRN9r00SRp5mti5SS4xmI6WwD/5cjmYHRlXOST8vJmetOBzFzDCJ/FvtgFWNY6AnvVn
         B337CPLwJBA+ie4Nb4VbGlkFIHtUsZhNfh/0tjLqGdHJrgbyzQClMkP2pzMErvaEIkq+
         waopbAXTfoT+8U97nHP6V9MUPfWte6/zZrXZYQTwSf3tIJzmPAFime26vvqAg2IyQa6x
         zHxg==
X-Gm-Message-State: APjAAAXYcRr0c0pP4C6BvhN0a5N8svtZDlXk4S2CP3V4gj8qSV3cSH4e
        YymdVAAT2GeBV6TOZEULqRnRaQ==
X-Google-Smtp-Source: APXvYqxwXxweGUcUNslBAGMjeZhE+jBgUQybSM4sA4z1hphuYWKnqXtnv4+AStFcEym0r1P+NOCAsw==
X-Received: by 2002:a25:8486:: with SMTP id v6mr7109125ybk.409.1579979094874;
        Sat, 25 Jan 2020 11:04:54 -0800 (PST)
Received: from ziepe.ca ([199.167.24.140])
        by smtp.gmail.com with ESMTPSA id u127sm3754607ywb.68.2020.01.25.11.04.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 25 Jan 2020 11:04:54 -0800 (PST)
Received: from jgg by jggl.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1ivQjh-0007qt-L1; Sat, 25 Jan 2020 15:04:49 -0400
Date:   Sat, 25 Jan 2020 15:04:49 -0400
From:   Jason <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Danit Goldberg <danitg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next] IB/mlx5: Return the administrative GUID if
 exists
Message-ID: <20200125190449.GA30147@jggl>
References: <20200116120048.12744-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116120048.12744-1-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 02:00:48PM +0200, Leon Romanovsky wrote:
> From: Danit Goldberg <danitg@mellanox.com>
> 
> A user can achieve the operational GUID (a.k.a affective GUID) through
> link/infiniband. Therefore it is preferred to return the administrative
> GUID if exists instead of the operational.
> This way the PF can query which VF GUID will be set in the next bind.
> In order to align with MAC address, zero is returned if
> administrative GUID is not set.
> 
> For example:
> - Before setting administrative GUID:
> ip link show
> ib0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 4092 qdisc mq state UP mode DEFAULT group default qlen 256
> link/infiniband 00:00:00:08:fe:80:00:00:00:00:00:00:52:54:00:c0:fe:12:34:55 brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
> vf 0     link/infiniband 00:00:00:08:fe:80:00:00:00:00:00:00:52:54:00:c0:fe:12:34:55 brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff,
> spoof checking off, NODE_GUID 00:00:00:00:00:00:00:00, PORT_GUID 00:00:00:00:00:00:00:00, link-state auto, trust off, query_rss off
> 
> ip link set ib0 vf 0 node_guid 11:00:af:21:cb:05:11:00
> ip link set ib0 vf 0 port_guid 22:11:af:21:cb:05:11:00
> 
> - After setting administrative GUID:
> ip link show
> ib0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 4092 qdisc mq state UP mode DEFAULT group default qlen 256
> link/infiniband 00:00:00:08:fe:80:00:00:00:00:00:00:52:54:00:c0:fe:12:34:55 brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
> vf 0     link/infiniband 00:00:00:08:fe:80:00:00:00:00:00:00:52:54:00:c0:fe:12:34:55 brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff,
> spoof checking off, NODE_GUID 11:00:af:21:cb:05:11:00, PORT_GUID 22:11:af:21:cb:05:11:00, link-state auto, trust off, query_rss off
> 
> Fixes: 9c0015ef0928 ("IB/mlx5: Implement callbacks for getting VFs GUID attributes")
> Signed-off-by: Danit Goldberg <danitg@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/ib_virt.c | 28 ++++++++++++----------------
>  include/linux/mlx5/driver.h          |  5 +++++
>  2 files changed, 17 insertions(+), 16 deletions(-)

Applied to for-next, thanks

Jason
