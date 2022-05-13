Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55CC5525988
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 03:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347633AbiEMBvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 21:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiEMBvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 21:51:43 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC14B606D8
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 18:51:42 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id cu23-20020a17090afa9700b001d98d8e53b7so7160827pjb.0
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 18:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LtFh0CZhZBPX6ceEsXYYQk4yljv6t73gvpwwZ90s18E=;
        b=WfOB31llj0s7JCtEcWt/m+SiLscZMPLpyT2o7sbZCQejxsO0qWVRblTUDyGUD7LhKA
         T0iPQb+LwJTfR+ah8XAF+2OCVghXY04Xv7LiJJO0KHniCY/CCNqflWlB4SL15l+DTYEH
         4KeohGeAPfnoHM/ZC4Nr3XIpEHdWVRoVKoVMYkPK+ogif1IDuvUYRYDehaUFEqzL15RK
         Be/ocp0GGa8Wb6KO9uDGW8RGdr0RWzVlMkFMoCl8Xsgp3XX8y5t+NNkQvBX+1mHttl0L
         LgkKcnN6XtECxNDrYSOe3ThOLKWaywF8jYjEpOH9zxsLMzX13cO3NXC7DF36hnpqbnxR
         mrOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LtFh0CZhZBPX6ceEsXYYQk4yljv6t73gvpwwZ90s18E=;
        b=ooK/GEMZCPO7GEc45R53HFseWz/2hrw3OR5QqtRiRxLijRa8Ch8kOj9N1ZnrlXQULP
         kH51698AkG05iLgFKObbbj5/r3a6ayfrGFXlzrhpxEGwQZdNtO0V6WF9y4wO+jHRsTq7
         34FvZut5owGXSOU5bJvndnGm0bpvNHxEXoZ9T8D/cSpD23VWjJZn1kHGyU+Wzmr9L9Gm
         qc2+e62G3H5gI0bYiNHmvbPDm0bR+ALEzXim76Q1o2ONqLRQB6NfyoTITwfcKaCAfCqs
         n01CN4s9fE4Jqb7c8FCtY1LZtozujuZUOAx5NGX1MYLJzHvS3EwsiLtIgP5BlTWZRj+Y
         s0ew==
X-Gm-Message-State: AOAM530FpKEO0idHtqkNuSVNJmPt5GMsEO98NZZQS22nJwVBPUz7cP0l
        SBPhREQ9lNg9hTq64JX7O2I=
X-Google-Smtp-Source: ABdhPJxG9VwqYxu3xxnyGCpj/okSH3LKiX/zpiDBgPpas9WDy3Dx+p4YW42qNk4VoxTNH4tWRfwCVw==
X-Received: by 2002:a17:90a:b78d:b0:1d9:4f4f:bc2a with SMTP id m13-20020a17090ab78d00b001d94f4fbc2amr13647187pjr.155.1652406701859;
        Thu, 12 May 2022 18:51:41 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 37-20020a631065000000b003db8691008esm385227pgq.12.2022.05.12.18.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 18:51:41 -0700 (PDT)
Date:   Fri, 13 May 2022 09:51:34 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>
Cc:     Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        pabeni@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com>
Subject: Re: [syzbot] WARNING: suspicious RCU usage in
 bond_ethtool_get_ts_info
Message-ID: <Yn25ppe3XtdsxJt+@Laptop-X1>
References: <000000000000fd857805ded5a88e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000fd857805ded5a88e@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove bpf guys from cc list.

On Thu, May 12, 2022 at 12:35:28PM -0700, syzbot wrote:
> 
> The issue was bisected to:
> 
> commit aa6034678e873db8bd5c5a4b73f8b88c469374d6
> Author: Hangbin Liu <liuhangbin@gmail.com>
> Date:   Fri Jan 21 08:25:18 2022 +0000
> 
>     bonding: use rcu_dereference_rtnl when get bonding active slave
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16fce349f00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=15fce349f00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=11fce349f00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com
> Fixes: aa6034678e87 ("bonding: use rcu_dereference_rtnl when get bonding active slave")
> 
> =============================
> WARNING: suspicious RCU usage
> 5.18.0-rc5-syzkaller-01392-g01f4685797a5 #0 Not tainted
> -----------------------------
> include/net/bonding.h:353 suspicious rcu_dereference_check() usage!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 2, debug_locks = 1
> 1 lock held by syz-executor317/3599:
>  #0: ffff88801de78130 (sk_lock-AF_INET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1680 [inline]
>  #0: ffff88801de78130 (sk_lock-AF_INET){+.+.}-{0:0}, at: sock_setsockopt+0x1e3/0x2ec0 net/core/sock.c:1066
> 
> stack backtrace:
> CPU: 0 PID: 3599 Comm: syz-executor317 Not tainted 5.18.0-rc5-syzkaller-01392-g01f4685797a5 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  bond_option_active_slave_get_rcu include/net/bonding.h:353 [inline]
>  bond_ethtool_get_ts_info+0x32c/0x3a0 drivers/net/bonding/bond_main.c:5595
>  __ethtool_get_ts_info+0x173/0x240 net/ethtool/common.c:554
>  ethtool_get_phc_vclocks+0x99/0x110 net/ethtool/common.c:568
>  sock_timestamping_bind_phc net/core/sock.c:869 [inline]
>  sock_set_timestamping+0x3a3/0x7e0 net/core/sock.c:916
>  sock_setsockopt+0x543/0x2ec0 net/core/sock.c:1221

Oh, I forgot to check setsockopt path...

Hi Vladimir, Jay,

Do you think if I should revert my previous commit, or just add
rcu_read_lock()/rcu_read_unlock() back to bond_ethtool_get_ts_info()?

Thanks
Hangbin
