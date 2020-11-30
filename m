Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5BF42C84BC
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 14:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgK3NLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 08:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgK3NLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 08:11:17 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E4EC0613D2;
        Mon, 30 Nov 2020 05:10:31 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id r2so6463898pls.3;
        Mon, 30 Nov 2020 05:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KhSKNJyOdWzUFv/t2dlusew/QsNoUu7oOeZSlVYMWxI=;
        b=bD39giwcjOnpDGptQOfJSaxCzRtqDIrg7++zAsmhh73jtMgFIfuR2kT56s/JROrlGY
         kCKL/xFuXEGdlum5nyIrMhDGFU+CjRd94ASHeUhNBRLqL3bv+0qcCr2QMn+xdoYoD3Y6
         cZAuTqDFp6u4hlIrjmv8MNwaQKy4YNpHloodd8fXgosiOrmw1c+Zan/DRRiJdvwx/Cqr
         +TuOobOKNDGYQfqe3xaNNj61sgCmAvH1toUIN3aP3jPQQAkhsQzWnXQMX+WsbVaWrIDO
         KeOThgRzdSu53lbfbDV/BkJM/ydTNSDlBhxEWqovMPb86L9SU0AV/VR22jcQoPbCk4Vm
         qQAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KhSKNJyOdWzUFv/t2dlusew/QsNoUu7oOeZSlVYMWxI=;
        b=mXQY9qSpZrAy1cIXSHCePzbIX363uqucVkiCD7vQyQv3YAwguwFK2GUvFGzIKVKrgy
         8AxKGcFvkifUP616Uqj/uYi6b+/q8ZVtn8VFeQ0R9zHwZjHOlNMoitUx9h48IQVJNbVY
         Q5IAl5zHoUGN3oFuA/ZqavhdhRo0Zn7QJeaz4fQAuAVdW6i8dqJIM6mSf6Wuw0dBlON0
         h6amghMAxPIOPnPONUjQbDzLa1g++V2jZ0Q9itc7WApBVpsKLxrJa1bP7K3DmH6nin6Z
         PdCFVyW5q7M1rKhMsU90BiF0Q6u0GRxnIK1P+xgnSVRUZeDblgk66WN/JHcyRoIrCY09
         ZbPQ==
X-Gm-Message-State: AOAM532qQ/6eSU5n73E7iQaDzsfS3mKghPtwtYj2AHk4Svxec0nfjh+K
        mHnp1eEY/KQ7N74n2ptJYHE=
X-Google-Smtp-Source: ABdhPJwPHzYjDimR9D/F2INfX5fzOoCsFnd1xqrAeh/l9VSLGzt2IrOrvBGVmPnJ3ZVArXMchvsBBA==
X-Received: by 2002:a17:902:d692:b029:da:3b7d:5ec4 with SMTP id v18-20020a170902d692b02900da3b7d5ec4mr18561628ply.70.1606741831212;
        Mon, 30 Nov 2020 05:10:31 -0800 (PST)
Received: from localhost.localdomain ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y15sm5669148pju.13.2020.11.30.05.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 05:10:30 -0800 (PST)
Date:   Mon, 30 Nov 2020 21:10:20 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: [PATCHv2 bpf-next] samples/bpf: add xdp program on egress for
 xdp_redirect_map
Message-ID: <20201130131020.GC277949@localhost.localdomain>
References: <20201110124639.1941654-1-liuhangbin@gmail.com>
 <20201126084325.477470-1-liuhangbin@gmail.com>
 <54642499-57d7-5f03-f51e-c0be72fb89de@fb.com>
 <20201130075107.GB277949@localhost.localdomain>
 <20201130103208.6d5305e2@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130103208.6d5305e2@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 10:32:08AM +0100, Jesper Dangaard Brouer wrote:
> > I plan to write a example about vlan header modification based on egress
> > index. I will post the patch later.
> 
> I did notice the internal thread you had with Toke.  I still think it
> will be more simple to modify the Ethernet mac addresses.  Adding a
> VLAN id tag is more work, and will confuse benchmarks.  You are

I plan to only modify the vlan id if there has. If you prefer to modify the
mac address, which way you'd like? Set src mac to egress interface's MAC?

> As Alexei already pointed out, you assignment is to modify the packet
> in the 2nd devmap XDP-prog.  Why: because you need to realize that this
> will break your approach to multicast in your previous patchset.
> (Yes, the offlist patch I gave you, that move running 2nd devmap
> XDP-prog to a later stage, solved this packet-modify issue).

BTW, it looks with your patch, the counter on egress would make more sense.
Should I add the counter after your patch posted?

Thanks
Hangbin
