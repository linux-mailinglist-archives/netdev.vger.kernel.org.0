Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CC428F81A
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 20:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732852AbgJOSES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 14:04:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbgJOSER (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 14:04:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E175720797;
        Thu, 15 Oct 2020 18:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602785056;
        bh=p+alG96VqUHzWl/iQOrip1ok4bKiK0HcnG43T8fhhoA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SJuoRfy0QJPz03+HW9k8/hBgyICGcRUzaf6H5MAk04x8J8qNw347acMyl8IYgQcMl
         krZ7KvhGBcNBuT/HMQSRakPWnKwJU/OZvnIxpoMVK7J/69RFelISG5U4CCvRsv0NDw
         4UHUH0lZKmTwVGpYLr3BWkkdhdtTVNACkC/gQQC4=
Date:   Thu, 15 Oct 2020 11:04:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+5609d37b3a926aad75b7@syzkaller.appspotmail.com>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller <syzkaller@googlegroups.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: bpf-next test error: BUG: program execution failed: executor 0:
 exit status 67
Message-ID: <20201015110409.66a8a054@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015110203.7cffc1d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <000000000000376ecf05b1b92848@google.com>
        <CACT4Y+aTPCPRtJ2wJ5P58DijtG2pxXtZm6w=C838YKLKCEdSfw@mail.gmail.com>
        <20201015110203.7cffc1d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 11:02:08 -0700 Jakub Kicinski wrote:
> On Thu, 15 Oct 2020 19:46:35 +0200 Dmitry Vyukov wrote:
> > On Thu, Oct 15, 2020 at 7:41 PM syzbot
> > <syzbot+5609d37b3a926aad75b7@syzkaller.appspotmail.com> wrote:  
> > >
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    e688c3db bpf: Fix register equivalence tracking.
> > > git tree:       bpf-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=13d3c678500000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=ea7dc57e899da16d
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=5609d37b3a926aad75b7
> > > compiler:       gcc (GCC) 10.1.0-syz 20200507
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+5609d37b3a926aad75b7@syzkaller.appspotmail.com
> > >
> > > executing program
> > > 2020/10/15 14:32:51 BUG: program execution failed: executor 0: exit status 67
> > > iptable checkpoint filter/2: getsockopt(IPT_SO_GET_INFO) (errno 22)
> > > loop exited with status 67
> > >
> > > iptable checkpoint filter/2: getsockopt(IPT_SO_GET_INFO) (errno 22)
> > > loop exited with status 67    
> > 
> > +netfilter maintainers
> > 
> > It seems one of these recent commits broke netfiler.
> > Since syzkaller uses netfiler for sandboxing, syzbot is currently down
> > on bpf-next and linux-next. Other trees will follow once they merge
> > the breakage.  
> 
> Do you have this?
> 
> d25e2e9388ed ("netfilter: restore NF_INET_NUMHOOKS")

Ah, you're saying it's just linux-next and bpf-next that's down.
I think the quoted fix will hit bpf-next in a few hours.

Thanks!
