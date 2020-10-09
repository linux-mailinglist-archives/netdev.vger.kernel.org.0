Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B591289133
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732446AbgJISgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731643AbgJISgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 14:36:12 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569EEC0613D2;
        Fri,  9 Oct 2020 11:36:11 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id l8so11036389ioh.11;
        Fri, 09 Oct 2020 11:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=LxGXnht7XM0f6Lg4juMi6AxmK12FOvrzP0jaYwfGoXs=;
        b=WmCkRtF/KDdhWmebGvaBbCvnOAadAWP2H+4466n01VlOUzD2ZGixgVDy12v/t/IZmy
         KH0iCL1aHPsvd5fKgs2yKvmT0TIw7oZuBQD9TDmPoo1MLUemjQzOS1PmPthGhqXyni1J
         K0a47T47Hx5lci2VwGGjnuvGVdSFrRIqIWOJMGq8LBGcaRMvOS4Xh5wShVVpA9AfahSk
         XZMyLXunAHgUhbF3WL+k/fQmQHugWA1rM8eYsIVcDjlz7sYkgTI81UhHbR702HTAyKOw
         fHPsp6kiTqM4n5erC8I3IPrj2f7bdyhgiHjfwIVCqDqlv8cdHxoxMlWy9GONgA+b/5Yl
         5rdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=LxGXnht7XM0f6Lg4juMi6AxmK12FOvrzP0jaYwfGoXs=;
        b=N1bx/Pd5zfbxhZEUpEY+054uf/Vceb49SNjdEd16cSZH3zuTPCn6XxpZ0vwfbzlLLe
         y/Y3QEPXSsAXd1IayGRSMjFUAuwNJdWm7/YwECogxYumMiOCwv6XoALllSLPHYNKAOI8
         8Us4lea+XmWL7I6Hevw8cxWDDM7tkIXln8FEC4q6FX9WYmKDilo3KUPOanGHPHs/o/q5
         wyM2g07XJQFbR7dUwMq3KbwqtDJNkcG3q7iIgZOwik9AFFZH4lbC9ZlUXFtAvs8edB1C
         KTOxb6X0KITwnfuqfc6c9xm26UovyEBDQ8qPb13Vwymkrt3moDAcePxE9NJwgDP1sQ7l
         KU8Q==
X-Gm-Message-State: AOAM5303soN5qxx5APBTYTRUC3hsbBbIChO+gBNFgZm730Jd24/rRjK0
        ZBIj+2yeCkrBXHqS/UpvnQM=
X-Google-Smtp-Source: ABdhPJxXdrhcb7+pl7bfO/nRgINvDOo5lxZJtfAf7MbIDFin6FaN2kbwKl+o9zgqXOr5sghX5CZdGw==
X-Received: by 2002:a05:6602:14c8:: with SMTP id b8mr10040399iow.170.1602268570660;
        Fri, 09 Oct 2020 11:36:10 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z200sm3827979iof.47.2020.10.09.11.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 11:36:10 -0700 (PDT)
Subject: [bpf-next PATCH v2 0/6] sockmap/sk_skb program memory acct fixes
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Fri, 09 Oct 2020 11:35:53 -0700
Message-ID: <160226839426.5692.13107801574043388675.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Users of sockmap and skmsg trying to build proxys and other tools
have pointed out to me the error handling can be problematic. If
the proxy is under-provisioned and/or the BPF admin does not have
the ability to update/modify memory provisions on the sockets
its possible data may be dropped. For some things we have retries
so everything works out OK, but for most things this is likely
not great. And things go bad.

The original design dropped memory accounting on the receive
socket as early as possible. We did this early in sk_skb
handling and then charged it to the redirect socket immediately
after running the BPF program.

But, this design caused a fundamental problem. Namely, what should we do
if we redirect to a socket that has already reached its socket memory
limits. For proxy use cases the network admin can tune memory limits.
But, in general we punted on this problem and told folks to simply make
your memory limits high enough to handle your workload. This is not a
really good answer. When deploying into environments where we expect this
to be transparent its no longer the case because we need to tune params.
In fact its really only viable in cases where we have fine grained
control over the application. For example a proxy redirecting from an
ingress socket to an egress socket. The result is I get bug
reports because its surprising for one, but more importantly also breaks
some use cases. So lets fix it.

This series cleans up the different cases so that in many common
modes, such as passing packet up to receive socket, we can simply
use the underlying assumption that the TCP stack already has done
memory accounting.

Next instead of trying to do memory accounting against the socket
we plan to redirect into we keep memory accounting on the receive
socket until the skb can be put on the redirect socket. This means
if we do an egress redirect to a socket and sock_writable() returns
EAGAIN we can requeue the skb on the workqueue and try again. The
same scenario plays out for ingress. If the skb can not be put on
the receive queue of the redirect socket than we simply requeue and
retry. In both cases memory is still accounted for against the
receiving socket.

This also handles head of line blocking. With the above scheme the
skb is on a queue associated with the socket it will be sent/recv'd
on, but the memory accounting is against the received socket. This
means the receive socket can advance to the next skb and avoid head
of line blocking. At least until its receive memory on the socket
runs out. This will put some maximum size on the amount of data any
socket can enqueue giving us bounds on the skb lists so they can't grow
indefinitely.

Overall I think this is a win. Tested with test_sockmap.

These are fixes, but I tagged it for bpf-next considering we are
at -rc8.

v1->v2: Fix uninitialized/unused variables (kernel test robot)
v2->v3: fix typo in patch2 err=0 needs to be <0 so use err=-EIO

---

John Fastabend (6):
      bpf, sockmap: skb verdict SK_PASS to self already checked rmem limits
      bpf, sockmap: On receive programs try to fast track SK_PASS ingress
      bpf, sockmap: remove skb_set_owner_w wmem will be taken later from sendpage
      bpf, sockmap: remove dropped data on errors in redirect case
      bpf, sockmap: Remove skb_orphan and let normal skb_kfree do cleanup
      bpf, sockmap: Add memory accounting so skbs on ingress lists are visible


 net/core/skmsg.c |   83 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 45 insertions(+), 38 deletions(-)

--
Signature
