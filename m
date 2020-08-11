Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C8524167F
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 08:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgHKGvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 02:51:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:34292 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727971AbgHKGvQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Aug 2020 02:51:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E2729AD43;
        Tue, 11 Aug 2020 06:51:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D9FD0DAFD3; Tue, 11 Aug 2020 08:50:13 +0200 (CEST)
Date:   Tue, 11 Aug 2020 08:50:13 +0200
From:   David Sterba <dsterba@suse.cz>
To:     syzbot <syzbot+7b1677fecb5976b0a099@syzkaller.appspotmail.com>
Cc:     clm@fb.com, davem@davemloft.net, dsterba@suse.com,
        johan.hedberg@gmail.com, josef@toxicpanda.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcel@holtmann.org,
        nborisov@suse.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Write in hci_conn_del
Message-ID: <20200811065013.GI2026@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        syzbot <syzbot+7b1677fecb5976b0a099@syzkaller.appspotmail.com>,
        clm@fb.com, davem@davemloft.net, dsterba@suse.com,
        johan.hedberg@gmail.com, josef@toxicpanda.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcel@holtmann.org,
        nborisov@suse.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000734f2505ac0f2426@google.com>
 <000000000000f7ec6f05ac91c11d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000f7ec6f05ac91c11d@google.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 08:35:08PM -0700, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 6a3c7f5c87854e948c3c234e5f5e745c7c553722
> Author: Nikolay Borisov <nborisov@suse.com>
> Date:   Thu May 28 08:05:13 2020 +0000
> 
>     btrfs: don't balance btree inode pages from buffered write path

This does not make sense wrt use-after-free in HCI, which is completely
unrelated subsystem.

The patch removes a call to function doing some potentially heavy work,
so this likely affects timing and making the bisection unreliable.
