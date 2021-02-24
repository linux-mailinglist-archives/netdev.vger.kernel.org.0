Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C41032358D
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 03:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhBXCET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 21:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbhBXCEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 21:04:15 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7E0C061574
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 18:03:35 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id w18so203848plc.12
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 18:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wP5KCNceHvEk6NNLnybjCIBzbBvosEXRPaDvTKJxAB8=;
        b=Xfzn0EgxyuQ+PS3YsQv2v6+GV8D2yre85Rc9SF9AvdgtUUeYD4Pt03FBYqIVYaq3xH
         zRwbC1/Zu+6BYqDhMdKoHl5+okcWuRwD1qMqj6wp4GeJ+3uJiTTU1BVE1kL2PSz3Tpof
         nUT4gQWjo/jKd1zIo2JP+q80TIv2keWM5u6kcLUhvU8YUaaHVHwnieaZICnMHkvxTqr7
         e9vTFeiUAiGMoJAvsZHBWfgsZIWA82qb6aGcta4fhdAgGmiKRbnVGLodUDBBMvpTS72u
         fNEJ2ePm04+yUyGqxlGG/v8rqpIfS7Z+TgqS8fmE9gSI324TsWJPfif2Jx8t2NL/Oa5R
         Y88Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wP5KCNceHvEk6NNLnybjCIBzbBvosEXRPaDvTKJxAB8=;
        b=Nyw0Hpewc6iItzDBrB2kkhoAwqKN8Fnv7V2D40hey7ZY8Zsn/hyy/cIE1QLvLI1L90
         9cI4wxu05XLhpQVFh/K5inRW6ducaAUETnY+7Y1YkFS6WY5LsNEWampG9Fcaj4dWHQME
         aSTyuBszGDOzXE7OgmEPcKFCogcGxsia/uu6xxXxUjZgzOyRBepoxogN+ndA4P7SfD7l
         7MEl6Dsq4JUvCfaV9VvjNhmr83SgROANWpM/WTbgErMDkpQW9tRuY6rc6XR45a3QJF6i
         7SBOStaQG5tEVkjRld52zopa32fY0w5w8en7/NILWT4RMLbIHMwp0AtetzKmSaq1skMp
         vsfw==
X-Gm-Message-State: AOAM532V92HwaiqsoFIVkQKy8/Y4le/Lxb2KBQX2i4ppx9AB6LFOzI4h
        06/dsdJXmJvRL03dW/Issug=
X-Google-Smtp-Source: ABdhPJyzDl8HHtOnNGC2NxqVdJIIakAdMz+BT6SesdOfwhaFgXAsOjhoiRDSluPW62wuwXxOB/lmjg==
X-Received: by 2002:a17:90b:1a84:: with SMTP id ng4mr1781798pjb.59.1614132214861;
        Tue, 23 Feb 2021 18:03:34 -0800 (PST)
Received: from kakao-entui-MacBookPro.local ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id z137sm401109pfc.172.2021.02.23.18.03.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 18:03:34 -0800 (PST)
Subject: Re: [PATCH net] vxlan: move debug check after netdev unregister
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, vvs@virtuozzo.com,
        fw@strlen.de
References: <20210221154552.11749-1-ap420073@gmail.com>
 <20210223133424.3a8a081f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <927556a5-21f8-45b3-2dad-de6a15b79f03@gmail.com>
Date:   Wed, 24 Feb 2021 11:03:30 +0900
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210223133424.3a8a081f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ko
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021. 2. 24. 오전 6:34, Jakub Kicinski wrote:

Hi Jakub,
Thank you for the review!

 > On Sun, 21 Feb 2021 15:45:52 +0000 Taehee Yoo wrote:
 >> The debug check must be done after unregister_netdevice_many() call --
 >> the hlist_del_rcu() for this is done inside .ndo_stop.
 >>
 >> This is the same with commit 0fda7600c2e1 ("geneve: move debug check 
after
 >> netdev unregister")
 >>
 >> Test commands:
 >>      ip netns del A
 >>      ip netns add A
 >>      ip netns add B
 >>
 >>      ip netns exec B ip link add vxlan0 type vxlan vni 100 local 
10.0.0.1 \
 >> 	    remote 10.0.0.2 dstport 4789 srcport 4789 4789
 >>      ip netns exec B ip link set vxlan0 netns A
 >>      ip netns exec A ip link set vxlan0 up
 >>      ip netns del B
 >>
 >> Splat looks like:
 >> [   73.176249][    T7] ------------[ cut here ]------------
 >> [   73.178662][    T7] WARNING: CPU: 4 PID: 7 at 
drivers/net/vxlan.c:4743 vxlan_exit_batch_net+0x52e/0x720 [vxlan]
 >> [   73.182597][    T7] Modules linked in: vxlan openvswitch nsh 
nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 mlx5_core 
nfp mlxfw ixgbevf tls sch_fq_codel nf_tables nfnetlink ip_tables 
x_tables unix
 >> [   73.190113][    T7] CPU: 4 PID: 7 Comm: kworker/u16:0 Not tainted 
5.11.0-rc7+ #838
 >> [   73.193037][    T7] Hardware name: QEMU Standard PC (i440FX + 
PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
 >> [   73.196986][    T7] Workqueue: netns cleanup_net
 >> [   73.198946][    T7] RIP: 0010:vxlan_exit_batch_net+0x52e/0x720 
[vxlan]
 >> [   73.201509][    T7] Code: 00 01 00 00 0f 84 39 fd ff ff 48 89 ca 
48 c1 ea 03 80 3c 1a 00 0f 85 a6 00 00 00 89 c2 48 83 c2 02 49 8b 14 d4 
48 85 d2 74 ce <0f> 0b eb ca e8 b9 51 db dd 84 c0 0f 85 4a fe ff ff 48 
c7 c2 80 bc
 >> [   73.208813][    T7] RSP: 0018:ffff888100907c10 EFLAGS: 00010286
 >> [   73.211027][    T7] RAX: 000000000000003c RBX: dffffc0000000000 
RCX: ffff88800ec411f0
 >> [   73.213702][    T7] RDX: ffff88800a278000 RSI: ffff88800fc78c70 
RDI: ffff88800fc78070
 >> [   73.216169][    T7] RBP: ffff88800b5cbdc0 R08: fffffbfff424de61 
R09: fffffbfff424de61
 >> [   73.218463][    T7] R10: ffffffffa126f307 R11: fffffbfff424de60 
R12: ffff88800ec41000
 >> [   73.220794][    T7] R13: ffff888100907d08 R14: ffff888100907c50 
R15: ffff88800fc78c40
 >> [   73.223337][    T7] FS:  0000000000000000(0000) 
GS:ffff888114800000(0000) knlGS:0000000000000000
 >> [   73.225814][    T7] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 >> [   73.227616][    T7] CR2: 0000562b5cb4f4d0 CR3: 0000000105fbe001 
CR4: 00000000003706e0
 >> [   73.229700][    T7] DR0: 0000000000000000 DR1: 0000000000000000 
DR2: 0000000000000000
 >> [   73.231820][    T7] DR3: 0000000000000000 DR6: 00000000fffe0ff0 
DR7: 0000000000000400
 >> [   73.233844][    T7] Call Trace:
 >> [   73.234698][    T7]  ? vxlan_err_lookup+0x3c0/0x3c0 [vxlan]
 >> [   73.235962][    T7]  ? ops_exit_list.isra.11+0x93/0x140
 >> [   73.237134][    T7]  cleanup_net+0x45e/0x8a0
 >> [ ... ]
 >
 > Please trim the logs if possible, there is no need to list the time
 > and thread ID in commit messages unless it adds to the information
 > somehow.
 >

Okay, I will trim logs if it's not needed.

 >> Fixes: 0e4ec5acad8b ("vxlan: exit_net cleanup checks added")
 >
 > The Fixes looks incorrect - I changed it to:
 >
 > Fixes: 57b61127ab7d ("vxlan: speedup vxlan tunnels dismantle")
 >

Thank you for fixing this tag.

 >> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
 >
 > Applied, thanks!
 >

Thanks a lot!
Taehee Yoo
