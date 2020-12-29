Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C84D2E732C
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 20:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgL2TJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 14:09:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:47152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbgL2TJT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Dec 2020 14:09:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB876207CC;
        Tue, 29 Dec 2020 19:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609268919;
        bh=xM2U2x0Y/Ber8zTRSI8K8l/zwjlXobgrzvh08myXKZU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MZvqWY0/IZnFbgRID8zhw1fMrvTkdjELsDdOFyWMkttqeRMbAdFubiWlbNKrIcnVK
         CBOIJTO2pHifqImyODBhAFsCfupJ74WBLOavk6xIi/ZA43QQXtiE+3Ophjr6oM6LQx
         UWIR4S+Su/srD+VMfKJgXbM1Eh4QZFkwSabzKDWpORdprz7OcX9GDjhRW4oV7Eh+zZ
         sWWfbz38zf1evzamF5bxb1RjH4ZF1Glw84V8CIcuAWSuEM/a4hSpnBvZ1aTJgJDPm5
         dTgMHP4ak8Qv6EIVbEjAmrtja3Lc6kQLXutnoWzv6Nnwauqs7ylC8Fzfj6Gc0vsBsO
         dNr53E4SEO3Zg==
Date:   Tue, 29 Dec 2020 11:08:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     syzbot <syzbot+ba431dd9afc3a918981a@syzkaller.appspotmail.com>
Cc:     andriin@fb.com, ast@kernel.org, aviadye@mellanox.com,
        borisp@mellanox.com, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: INFO: task hung in tls_sw_cancel_work_tx
Message-ID: <20201229110838.7d3b080e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <000000000000861441059e047626@google.com>
References: <000000000000861441059e047626@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 07 Feb 2020 15:08:09 -0800 syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    90568ecf Merge tag 'kvm-5.6-2' of git://git.kernel.org/pub..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16513809e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=69fa012479f9a62
> dashboard link: https://syzkaller.appspot.com/bug?extid=ba431dd9afc3a918981a
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1036b6b5e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1651f6e9e00000

#syz dup: INFO: task hung in tls_sk_proto_close

Looks like the exact same bug, perhaps syzbot got LTO enabled around
March which changed the function in which hung is reported..
