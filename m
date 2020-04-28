Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB04A1BB28D
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 02:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgD1AKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 20:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726282AbgD1AKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 20:10:36 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9286FC03C1A9
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 17:10:36 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id y19so9552554qvv.4
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 17:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+SvbcRM+D8Hoa6IrST25It7oQmI1YKKGE8UvIYsd3j4=;
        b=egsqS2uaZQ0GqvuGL0dUXYrCAQ34rUZ7q4SKDLz3KYfTgCwcsf5vUKXxMBovxwsQJR
         9V9FdJpN5GX9QGqu6QlMkbhg+VFg/ZPNDC3T9lEm9VG1y8mCW3+FLp3MCpuwPXte4sWy
         EyN47YLP+7s7+GqENKpIiRrZ5UjNjRZNufDzGdOWOzmlgNdZ6KhQLT3ZFR419K8TfQdL
         uD+ODP8FUSOZyCAjeuq38WK2BnicfgYd9rvH8K+nV3jLkqUZgfRfksPvxdMqT++wLBtd
         kdHp/LlbAQyi+otXveuXhsh+trZa9qp/1i8GMo/fQGUT2OSnBwtx2w7hOtz6CluqI3fZ
         LoWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+SvbcRM+D8Hoa6IrST25It7oQmI1YKKGE8UvIYsd3j4=;
        b=nNL6PVEXmB0tfpIpsICmira2ny6mvNRr/MT9UqBS4rhGtNb8TLgh8dxIGNxnPcsDe2
         BxzzAhiWzRAS/zidBGi0nnJzh4W9kWyGXeqKo6AlCnnjTt/qeBtkEe/jkQ6vgu4rM2Tt
         pa/KosYsQnl8kXyrLT7mEJYZw7irFGd14l21WsPquzWAvFo72POJGSJFvxd3sMxh5eCq
         gxA5JsiIH3BJjdVGMQJZC8gKhcKZf+PwOiV5a8hSvrMNDIgT6rp4IqE/jJZD886R9Lie
         /Lfumr/0s7qP4+5IQnUDmZhDSuXjv64MvGt6FZmqltzdiQSGoQw+lL9647Mj/6niu7V6
         xOow==
X-Gm-Message-State: AGi0PuZLwKgCZk5qIaK+HRqkLB2FrbfTmKl7K86AQ/l8HOUDQvDimNXS
        cy8KscPTWGGNDJgzJe1cB4QO9Q==
X-Google-Smtp-Source: APiQypJXnyTV0OcNdko5OBsfPbZLy53Ghm/5PHAA7ooZmHNZVFoHsm0r3ONTDRpVr8v2Sdv0o97Isg==
X-Received: by 2002:a0c:f004:: with SMTP id z4mr25173331qvk.29.1588032635506;
        Mon, 27 Apr 2020 17:10:35 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id p80sm12120531qka.134.2020.04.27.17.10.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 Apr 2020 17:10:34 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jTDpa-0002Q4-8l; Mon, 27 Apr 2020 21:10:34 -0300
Date:   Mon, 27 Apr 2020 21:10:34 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     syzbot <syzbot+4088ed905e4ae2b0e13b@syzkaller.appspotmail.com>
Cc:     dledford@redhat.com, kamalheib1@gmail.com, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, parav@mellanox.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: WARNING in ib_unregister_device_queued
Message-ID: <20200428001034.GQ26002@ziepe.ca>
References: <000000000000aa012505a431c7d9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000aa012505a431c7d9@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 26, 2020 at 06:43:13AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    b9663b7c net: stmmac: Enable SERDES power up/down sequence
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=166bf717e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5d351a1019ed81a2
> dashboard link: https://syzkaller.appspot.com/bug?extid=4088ed905e4ae2b0e13b
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+4088ed905e4ae2b0e13b@syzkaller.appspotmail.com
> 
> rdma_rxe: ignoring netdev event = 10 for netdevsim0
> infiniband  yz2: set down
> WARNING: CPU: 0 PID: 22753 at drivers/infiniband/core/device.c:1565 ib_unregister_device_queued+0x122/0x160 drivers/infiniband/core/device.c:1565

The only thing I can think of for this is that ib_register_driver()
is racing with __ib_unregister_device() and took the special error
unwind.

I suspect this is not a bug, but over complexity triggering a
pre-condition WARN_ON..

Maybe the solution is to swap the dealloc_driver = NULL for some other flag.

Jason
