Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A823229FC5
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 21:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731760AbgGVTC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 15:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgGVTCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 15:02:55 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16634C0619DC;
        Wed, 22 Jul 2020 12:02:55 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id u8so1495828qvj.12;
        Wed, 22 Jul 2020 12:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=12epvX/YDdXmyKZnFd07mtt1bamPJ0DstDN5iDweXtM=;
        b=eJY1XYN/eqs5gaHFISnW7MlvUpIZZE2Z09LhmguAZfDAHOJKHDQbn78ZCY/zlVjj3C
         Z13p2TUXhKnae2+0mdX/NAmZ9Qp1V7evVd8HoxqvX62G1J6Mn136JYEKh1uc7awz1DRt
         LtQA1FxjizDXcBmbIU2r6rLUO24XTCKl0U07H/xZEicBsvGALeoqanhb3UnMAKlhDKG1
         TYhm3AvNUwFhC5IdcO7iIZs/RzZ6paxh3cRZv/WKmRiRCWRaM+MyriAi8oSAurfdKv9q
         O7CiBKINzBbckaL0dW2CJfwN3LruYeYrThQxOsyE+F0vMVXCzX87qxtC9ngvm/1acMuP
         Ag8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=12epvX/YDdXmyKZnFd07mtt1bamPJ0DstDN5iDweXtM=;
        b=S7VhFVTGRjqbQlXiRy10PYEtTQxu0a+e1eCcf18ctQ2SVb2Xw+utq6ttOPwtdaeMqP
         604N1igv0SNyTDm7+026hDr7dnZJV+SPXIq6m/vHCtl2Ivd3pncdx/UB+u6jQwi+b4fM
         FX1/VLtR/YtIovsBdQMWBxaNlQy/BZhIBvvUT9vKFEm37WC/mLH54uDEpcSkj6ENQ0Sb
         h5lcQpwR5WON1EHivScHkvzsz4TYGGaUqog3cZ+8FHI3eO0deINf4VtweXD3MA0HMf56
         aPJn49oL7WquEKvAlMTRk2MGXOsYKGku8+OcVipvbWU0p14JDyZZvTLTl0ix8ERaOc8E
         npjA==
X-Gm-Message-State: AOAM532yeAg/p5a0oxFA+UsURj/B870Y8Kqzt4dmyJx2/yKPjpqzrJNw
        RqGJL37Ud6hd7Ojxwvap2AU=
X-Google-Smtp-Source: ABdhPJxKfqgjc+tpXcSxtpjEKWq7KBS8lT1TQN2pdqTb1eZ3k2Gd79q4iBAfLZBK9y4qMJWZiuB7og==
X-Received: by 2002:a0c:ec04:: with SMTP id y4mr1448669qvo.148.1595444574218;
        Wed, 22 Jul 2020 12:02:54 -0700 (PDT)
Received: from localhost.localdomain ([138.204.24.96])
        by smtp.gmail.com with ESMTPSA id y12sm430437qto.87.2020.07.22.12.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 12:02:53 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id EAF9CC18B3; Wed, 22 Jul 2020 16:02:50 -0300 (-03)
Date:   Wed, 22 Jul 2020 16:02:50 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     syzbot <syzbot+0e4699d000d8b874d8dc@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com,
        vyasevich@gmail.com, hch@lst.de
Subject: Re: KASAN: slab-out-of-bounds Write in sctp_setsockopt
Message-ID: <20200722190250.GE3307@localhost.localdomain>
References: <0000000000003b813605ab0bd243@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000003b813605ab0bd243@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 11:22:23AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4f1b4da5 Merge branch 'net-atlantic-various-features'
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=14b3a040900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2b7b67c0c1819c87
> dashboard link: https://syzkaller.appspot.com/bug?extid=0e4699d000d8b874d8dc
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c93358900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ab61f0900000

The syz repo has:
setsockopt$inet_sctp6_SCTP_MAX_BURST(r0, 0x84, 0x10, &(0x7f0000000100)=@assoc_value, 0x8)
                      ^^^^^^^^^^^^^^           ^^^^

#define SCTP_DELAYED_ACK_TIME   16
#define SCTP_DELAYED_ACK SCTP_DELAYED_ACK_TIME
#define SCTP_DELAYED_SACK SCTP_DELAYED_ACK_TIME
#define SCTP_MAX_BURST  20              /* Set/Get max burst */

C repro has:
  syscall(__NR_setsockopt, r[0], 0x84, 0x10, 0x20000100ul, 8ul);
                                       ^^^^

So I'm wondering, what was the real intention of the call?


Anyhow, the issue is real, introduced by ebb25defdc17 ("sctp: pass a
kernel pointer to sctp_setsockopt_delayed_ack"). It used to use a
local storage bigger than the data provided by the user and used
one struct to read another's content on top of it. Quite masked.
I'll cook a fix.

  Marcelo
