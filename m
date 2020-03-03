Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBBD4178406
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 21:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730517AbgCCUar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 15:30:47 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34879 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731151AbgCCUaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 15:30:46 -0500
Received: by mail-qk1-f195.google.com with SMTP id 145so4847985qkl.2
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 12:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=123P9xQGjDkfvy5FsfzCO+UHa3rPS90oX4YiNtrqhWw=;
        b=oMnlxAfaYeplW2vLS+DWelhhqH2WlAWDjWhlmOpKI/Duis+KxRNZz0/D21oxnIgULq
         zgeFL7J09p5zRhZuEiKU0A44Iu5zo8t+DAT7bnK0R6jWCKxZu9EiFF2RPSzmDmGj4VrH
         tf7m31BweTtKuVIIt2STCEMTZ0cceLF+cd7HOfySR6MP55Rp/mbHm7fZqGKtobukvEcU
         ljoVaZjkKpl/W7a8I7QTI0PglgMnhhQyWFvFFnxXtVcWM7zeIZhJC8+X3vYRqswNkfOY
         cu3Mfw6hiICbp67BUYQ7hRzo6QPjj/cdCqCUkIxbss5FMfZP/R8F0zE6KUY4z567HMKm
         HPcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=123P9xQGjDkfvy5FsfzCO+UHa3rPS90oX4YiNtrqhWw=;
        b=kUXNn8noaq13NL92VlT++cvJAowfdf5n1/PCmRFpXVynOTXLRVROh/zspGIWxUVxfk
         TLiwVEBUHsfMU7wEFxVOlPJtrlvw1riJi0NeUvFxnp1/gmWoMM/14xgVZVFaGC5NO/mX
         28B6peBGSwXGGRUP1u8qOJGDf95z2SoILqWgbTBJfjwNwmPTb0TZvp/lpJsBbkmM9YkN
         7CkQjohMG9u/yS0QotDlRd/dCRY0lWXrPoOXRtcUSzgQnNY6Wi9390iTKUOi5lYbOBCi
         U5lyoK2X1WLrr2Vgfij/MECrsXH2bVvFI4hpBYUijfpqHCnz6+lVtMuqh8/Ug4nr25ei
         RfpA==
X-Gm-Message-State: ANhLgQ3AaVHLqkcgN00rYwo5QLsnBsavKiKyoDHjU0uW4XvwLDDr0IPc
        jw9FWjHmoeyuFX898L6KWFcvVw==
X-Google-Smtp-Source: ADFU+vvHp3YJ4Y5ualAljJKts6XGmz1AJG7ZhH+LdzPqAcNANHKw/6O07c7kM42eTFtS7Agx619UJA==
X-Received: by 2002:a37:67d3:: with SMTP id b202mr5746959qkc.496.1583267445778;
        Tue, 03 Mar 2020 12:30:45 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id t29sm13453204qtt.20.2020.03.03.12.30.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 03 Mar 2020 12:30:45 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j9EBg-0001xh-AJ; Tue, 03 Mar 2020 16:30:44 -0400
Date:   Tue, 3 Mar 2020 16:30:44 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     syzbot <syzbot+46fe08363dbba223dec5@syzkaller.appspotmail.com>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        syzkaller-bugs@googlegroups.com,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: general protection fault in kobject_get
Message-ID: <20200303203044.GD31668@ziepe.ca>
References: <000000000000c4b371059fd83a92@google.com>
 <20200303072558.GF121803@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303072558.GF121803@unreal>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 09:25:58AM +0200, Leon Romanovsky wrote:
> +RDMA
> 
> On Sun, Mar 01, 2020 at 09:12:11PM -0800, syzbot wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    3b3e808c Merge tag 'mac80211-next-for-net-next-2020-02-24'..
> > git tree:       net-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=15e20a2de00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=6ec9623400ee72
> > dashboard link: https://syzkaller.appspot.com/bug?extid=46fe08363dbba223dec5
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >
> > Unfortunately, I don't have any reproducer for this crash yet.
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+46fe08363dbba223dec5@syzkaller.appspotmail.com

Hum, most probably something like this.. Will send a proper
patch. If it is this I am very surprised that it didn't get a
reproducer, as the fault should be pretty easy to hit, no race required..

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index d1407fa378e832..e43ec710092a94 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -1129,17 +1129,30 @@ static const struct file_operations umad_sm_fops = {
 	.llseek	 = no_llseek,
 };
 
+static struct ib_umad_port *get_port(struct ib_device *ibdev,
+				     struct ib_umad_device *umad_dev,
+				     unsigned int port)
+{
+	if (!umad_dev)
+		return ERR_PTR(-EOPNOTSUPP);
+	if (!rdma_is_port_valid(ibdev, port))
+		return ERR_PTR(-EINVAL);
+	if (!rdma_cap_ib_mad(ibdev, port))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	return &umad_dev->ports[port - rdma_start_port(ibdev)];
+}
+
 static int ib_umad_get_nl_info(struct ib_device *ibdev, void *client_data,
 			       struct ib_client_nl_info *res)
 {
-	struct ib_umad_device *umad_dev = client_data;
+	struct ib_umad_port *port = get_port(ibdev, client_data, res->port);
 
-	if (!rdma_is_port_valid(ibdev, res->port))
-		return -EINVAL;
+	if (IS_ERR(port))
+		return PTR_ERR(port);
 
 	res->abi = IB_USER_MAD_ABI_VERSION;
-	res->cdev = &umad_dev->ports[res->port - rdma_start_port(ibdev)].dev;
-
+	res->cdev = &port->dev;
 	return 0;
 }
 
@@ -1154,15 +1167,13 @@ MODULE_ALIAS_RDMA_CLIENT("umad");
 static int ib_issm_get_nl_info(struct ib_device *ibdev, void *client_data,
 			       struct ib_client_nl_info *res)
 {
-	struct ib_umad_device *umad_dev =
-		ib_get_client_data(ibdev, &umad_client);
+	struct ib_umad_port *port = get_port(ibdev, client_data, res->port);
 
-	if (!rdma_is_port_valid(ibdev, res->port))
-		return -EINVAL;
+	if (IS_ERR(port))
+		return PTR_ERR(port);
 
 	res->abi = IB_USER_MAD_ABI_VERSION;
-	res->cdev = &umad_dev->ports[res->port - rdma_start_port(ibdev)].sm_dev;
-
+	res->cdev = &port->sm_dev;
 	return 0;
 }
 
