Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F54D9D52E
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 19:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387487AbfHZRsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 13:48:21 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37017 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732551AbfHZRsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 13:48:21 -0400
Received: by mail-ed1-f65.google.com with SMTP id f22so27596941edt.4
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 10:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=MTQwf/CDwbIB7+wU7NaceiqLpfuhNTx13sDEGJqI6gY=;
        b=V5rLZHEn2eB4+p7LiIy0h0zGGZW/W2E2kgx0j5UMMKTKz0CkaZdjfIAt4bYFGq6Bcq
         txpHsoswiVWqdwQqPE203+W0yvk40mSBYrb20gzWf7/pjk3wPpd775XCpqIMIwpZ65GT
         GV9LrAjetuHiwK3+T2gZPD44qTerwBrnj8yUrH0Wbmb0w5jVNNILC9yJL4XFMiG8zYek
         DP34JnsBjSkGQmPafGD8hCwxbYeUAPvTHwsUIux2GTHGe+NaxVmJXyCMmD6rODyU3QOS
         endF5g9ScNoGc68o/W445/QQXy+Qthz9pAIAkx+O6Pr9FjOrurwS3FVMdlH4ZFnc3mtG
         Jx1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=MTQwf/CDwbIB7+wU7NaceiqLpfuhNTx13sDEGJqI6gY=;
        b=NgbhFvDOqOWp0pH6sSdmcQxRNWTySzjDXKXNLYCTVStdaUij4rz/cND/B7kzoIFTwK
         LwFOA/0QrmRL1fcvoA/5oOEjQI77gp7MItMn7Snw/VBMS+IeV0PsHhS5nKhi8wWiNvcm
         0eFwjOJbVsIp7T5lUPHDBG2UYJrxODj7uIE2qu6EC5gklKx6zEN76s6C00X6ZFH78BbQ
         +3JqRStiAoD4y1uB7/xfwOjCfO4N9j7+AEBGNWpWNsraQHtw044e05ydad5j9tu1zIUh
         XOGuvVnKKeOl0tM6bawOddE25mcheYUsyZD23nWvj9iqztTkI4ssKSqk3iHS6WW0jg/5
         TnPw==
X-Gm-Message-State: APjAAAXHpugW7+2l9CaRIDhd4Fnhjpx5npTLDsOx6+OVhcwhPO1cwCKt
        w+MxSI609H1MUC80s4TRNjKVoQ==
X-Google-Smtp-Source: APXvYqyelDfdWyciKmt1NNVplo0NESWi53c7teX3SDiVsGpa6EOkA48j7i1rXNhbiDif8XkoEc6O1A==
X-Received: by 2002:a17:906:c785:: with SMTP id cw5mr17648826ejb.215.1566841699381;
        Mon, 26 Aug 2019 10:48:19 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p20sm3066323eja.59.2019.08.26.10.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 10:48:19 -0700 (PDT)
Date:   Mon, 26 Aug 2019 10:48:01 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, pablo@netfilter.org
Subject: Re: [PATCH net-next v3 00/10] Refactor cls hardware offload API to
 support rtnl-independent drivers
Message-ID: <20190826104801.70b5edaa@cakuba.netronome.com>
In-Reply-To: <20190826134506.9705-1-vladbu@mellanox.com>
References: <20190826134506.9705-1-vladbu@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Aug 2019 16:44:56 +0300, Vlad Buslov wrote:
> Currently, all cls API hardware offloads driver callbacks require caller
> to hold rtnl lock when calling them. This patch set introduces new API
> that allows drivers to register callbacks that are not dependent on rtnl
> lock and unlocked classifiers to offload filters without obtaining rtnl
> lock first, which is intended to allow offloading tc rules in parallel.
> 
> Recently, new rtnl registration flag RTNL_FLAG_DOIT_UNLOCKED was added.
> TC rule update handlers (RTM_NEWTFILTER, RTM_DELTFILTER, etc.) are
> already registered with this flag and only take rtnl lock when qdisc or
> classifier requires it. Classifiers can indicate that their ops
> callbacks don't require caller to hold rtnl lock by setting the
> TCF_PROTO_OPS_DOIT_UNLOCKED flag. Unlocked implementation of flower
> classifier is now upstreamed. However, this implementation still obtains
> rtnl lock before calling hardware offloads API.
> 
> Implement following cls API changes:
> 
> - Introduce new "unlocked_driver_cb" flag to struct flow_block_offload
>   to allow registering and unregistering block hardware offload
>   callbacks that do not require caller to hold rtnl lock. Drivers that
>   doesn't require users of its tc offload callbacks to hold rtnl lock
>   sets the flag to true on block bind/unbind. Internally tcf_block is
>   extended with additional lockeddevcnt counter that is used to count
>   number of devices that require rtnl lock that block is bound to. When
>   this counter is zero, tc_setup_cb_*() functions execute callbacks
>   without obtaining rtnl lock.
> 
> - Extend cls API single hardware rule update tc_setup_cb_call() function
>   with tc_setup_cb_add(), tc_setup_cb_replace(), tc_setup_cb_destroy()
>   and tc_setup_cb_reoffload() functions. These new APIs are needed to
>   move management of block offload counter, filter in hardware counter
>   and flag from classifier implementations to cls API, which is now
>   responsible for managing them in concurrency-safe manner. Access to
>   cb_list from callback execution code is synchronized by obtaining new
>   'cb_lock' rw_semaphore in read mode, which allows executing callbacks
>   in parallel, but excludes any modifications of data from
>   register/unregister code. tcf_block offloads counter type is changed
>   to atomic integer to allow updating the counter concurrently.
> 
> - Extend classifier ops with new ops->hw_add() and ops->hw_del()
>   callbacks which are used to notify unlocked classifiers when filter is
>   successfully added or deleted to hardware without releasing cb_lock.
>   This is necessary to update classifier state atomically with callback
>   list traversal and updating of all relevant counters and allows
>   unlocked classifiers to synchronize with concurrent reoffload without
>   requiring any changes to driver callback API implementations.
> 
> New tc flow_action infrastructure is also modified to allow its user to
> execute without rtnl lock protection. Function tc_setup_flow_action() is
> modified to conditionally obtain rtnl lock before accessing action
> state. Action data that is accessed by reference is either copied or
> reference counted to prevent concurrent action overwrite from
> deallocating it. New function tc_cleanup_flow_action() is introduced to
> cleanup/release all such data obtained by tc_setup_flow_action().
> 
> Flower classifier (only unlocked classifier at the moment) is modified
> to use new cls hardware offloads API and no longer obtains rtnl lock
> before calling it.

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
