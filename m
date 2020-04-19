Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30921AFCD0
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 19:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgDSRcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 13:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725969AbgDSRcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 13:32:42 -0400
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92187C061A0C;
        Sun, 19 Apr 2020 10:32:42 -0700 (PDT)
Received: by mail-vk1-xa43.google.com with SMTP id x9so276973vkd.4;
        Sun, 19 Apr 2020 10:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/TqDWfB8cUBXogmz2+ksGks4wWKUG39YBeLr7SZP+ks=;
        b=pHtaVDFtydBeKDed2OkXR74O6lwGCWGCPOpMyFaMnoTbYzVb9LOxEELnsnyU5gNI7n
         vxJu8pj/jiyo0ihToGPpMbeH6qhYy0NuPfwppmILjJs/7T6CiG70FNEOnxce9+aN2Zoe
         ZZd7XDyWTYT28pPN8Y6k5IC2kPaJCnbPWweKSPzVEgw3ueiqTV22ZXdNgpX7w9Qdl7/w
         NrtR55HklfXY8sd8wskRbN8C9nmfTVhxpxubKATjpDH9iAJMJAeONSmGD9aI+UaHV0sc
         rXP5BOuf6YyW1DGimSjbtJPNp9RmIPuYbfbCzIoSuxtnPviC1OBfip2GpgGMeLLbTItv
         A9Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/TqDWfB8cUBXogmz2+ksGks4wWKUG39YBeLr7SZP+ks=;
        b=jxYj+to1ec5nnd5KYDPfWHcwc7I9w31QF5YA4WP7bbGc1B3hNv58IgezrLQXRXQ7HQ
         O21IBNmT8EItiw8hdnse1r6pj9zAexuL9QwXtP+Z+fKGDCZOSLMmx9kMJrgCT57zDgbo
         lB+PbZgfDU8OKllftNZ0NBikC8tut9r/MuBjiX4ZVD4/rzPOhHVAw1d55N33Seau208c
         VbR2y1p+W40ckD53THc0eT8/zo9/EETDHfzsES+TByeVF37lhXeuvm8MqwvYU9ahjlHC
         FzZVpPg0K3b9fqpZYOI+nGTkCrcR2uo9kEv/W5shBf1EmqCRcuuNmoXmhbvrKUlIXt8+
         lBqA==
X-Gm-Message-State: AGi0PuZWuou+T92MbtajAHeoXMxTR+AHokO+28Kd2OZHfk3+RlKvMK9F
        0+8DRu1DpjNIeiei0eiW1B+rCh76JlYeinlXniceTZgS
X-Google-Smtp-Source: APiQypKN8NI7vCpugHw0jz+xvmW0SEVc2PQIK2816SpywZShPmiXtMbVtbRRT9+GWJ9ibc5w2VQZRsG9y8mnHjArHAo=
X-Received: by 2002:a1f:9541:: with SMTP id x62mr8357446vkd.82.1587317561712;
 Sun, 19 Apr 2020 10:32:41 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000e642a905a0cbee6e@google.com> <1587063451-54027-1-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1587063451-54027-1-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Sun, 19 Apr 2020 10:32:30 -0700
Message-ID: <CAOrHB_CjZ1oyNyuj7tgZLZ1XXFahCSO76BfHX7YFo_O68FfrXQ@mail.gmail.com>
Subject: Re: [PATCH] net: openvswitch: ovs_ct_exit to be done under ovs_lock
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     syzbot+7ef50afd3a211f879112@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        ovs dev <dev@openvswitch.org>, kuba@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com, Yi-Hung Wei <yihung.wei@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 19, 2020 at 1:44 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> syzbot wrote:
> | =============================
> | WARNING: suspicious RCU usage
> | 5.7.0-rc1+ #45 Not tainted
> | -----------------------------
> | net/openvswitch/conntrack.c:1898 RCU-list traversed in non-reader section!!
> |
> | other info that might help us debug this:
> | rcu_scheduler_active = 2, debug_locks = 1
> | ...
> |
> | stack backtrace:
> | Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-0-ga698c8995f-prebuilt.qemu.org 04/01/2014
> | Workqueue: netns cleanup_net
> | Call Trace:
> | ...
> | ovs_ct_exit
> | ovs_exit_net
> | ops_exit_list.isra.7
> | cleanup_net
> | process_one_work
> | worker_thread
>
> To avoid that warning, invoke the ovs_ct_exit under ovs_lock and add
> lockdep_ovsl_is_held as optional lockdep expression.
>
> Link: https://lore.kernel.org/lkml/000000000000e642a905a0cbee6e@google.com
> Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
> Cc: Pravin B Shelar <pshelar@ovn.org>
> Cc: Yi-Hung Wei <yihung.wei@gmail.com>
> Reported-by: syzbot+7ef50afd3a211f879112@syzkaller.appspotmail.com
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks.
