Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64382350B8
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 08:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgHAGGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 02:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgHAGGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 02:06:51 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59900C06174A
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 23:06:51 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id l17so16910571ilq.13
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 23:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lc+KMyIhUWVI5G7cYRRHYkKwizFAx8XHRjl6tJdzvuU=;
        b=t6vS3gqeAzM3WESInAd6KqAHgasCgzOLgw/oj5xPJRpz+vr14nDpRqQJJJLJV5AsT0
         vTtB+sQQg2qxxxn5eIQJ3+pcXL/wzyplpc9a77lic6NJTRixRJSwu9X+gk2o2Npyyc7y
         8gpSL/ItnwE1QAOfVHyzfJrgh3Dd6/9Zf7H+BC6pYDF6/sDb+zjmw4+Nj3r5Ttdpf5pT
         JXis85C6vqXoIKfzSeBi+37t0OVJ1s3/upCsZZGhMXfeGRZqL/At0AO9M6u9e0WiZiwW
         WQiZDCipMI+gwLjHd96PgBBF1Ah78R8v380DfwwQdzEE1/Y4o1878Ra7B9CKIctlWq7e
         3WCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lc+KMyIhUWVI5G7cYRRHYkKwizFAx8XHRjl6tJdzvuU=;
        b=JMD0+8n2gp36LZaYXXDqhW1vsN/ZiAEwYK0+hVNsMOnt9cjo6yuXUrRQztd9gF5/X7
         uMS41nEkcIP18E0O+e4ocU62HKI0cvNdWt/evzRz6AQprrBwTIu1pefyq1USjbPJjLXD
         OxYuQHIM3EfMKxrpk+95d8c7bcePTbrlt87c5sRaf6yl2BYprFpKoRrun62cuBkrB7WH
         OXPwEjBxA7E4FG78QOX/2PN2RSP56F14i41o6RO17hy5wjdghUDseCJ7N0pQ5eeoVtzV
         H0CieXBxCz9/owEV9b2YDCDflGQDqsA+9QNJEMeeiB7potHzsDFqYRFhAy1Zn9P693gq
         zacw==
X-Gm-Message-State: AOAM532H4K9k5WKOm8y3VpBhixW0Su1RvzjJbvj0wyfuIJY1RFbhNrOI
        pJ1r/TyStIBmjdpyVf7nD08+p6cfPdcdm7NmEvrkaehm
X-Google-Smtp-Source: ABdhPJzUTT+fugQuYj2A6pT2sD8jwsHVBK4EHTTc26QePyUuTQp2qy/ehB+o6VA5ok058moAXB5ZTQZvce1Rq77mkpk=
X-Received: by 2002:a92:c5c1:: with SMTP id s1mr7148287ilt.144.1596262010593;
 Fri, 31 Jul 2020 23:06:50 -0700 (PDT)
MIME-Version: 1.0
References: <1596163501-7113-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1596163501-7113-1-git-send-email-wenxu@ucloud.cn>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 31 Jul 2020 23:06:39 -0700
Message-ID: <CAM_iQpVLJOOUcLpTp817TihSr-Ax3P0HES5gVSN9sRp=6Bm4mw@mail.gmail.com>
Subject: Re: [PATCH net v2] net/sched: act_ct: fix miss set mru for ovs after
 defrag in act_ct
To:     wenxu <wenxu@ucloud.cn>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 7:45 PM <wenxu@ucloud.cn> wrote:
>
> From: wenxu <wenxu@ucloud.cn>
>
> When openvswitch conntrack offload with act_ct action. Fragment packets
> defrag in the ingress tc act_ct action and miss the next chain. Then the
> packet pass to the openvswitch datapath without the mru. The over
> mtu packet will be dropped in output action in openvswitch for over mtu.
>
> "kernel: net2: dropped over-mtu packet: 1528 > 1500"
>
> This patch add mru in the tc_skb_ext for adefrag and miss next chain
> situation. And also add mru in the qdisc_skb_cb. The act_ct set the mru
> to the qdisc_skb_cb when the packet defrag. And When the chain miss,
> The mru is set to tc_skb_ext which can be got by ovs datapath.
>
> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks.
