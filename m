Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDD645EB0
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 15:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbfFNNoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 09:44:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57302 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727979AbfFNNoG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 09:44:06 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 63D1A30C1207;
        Fri, 14 Jun 2019 13:44:06 +0000 (UTC)
Received: from treble (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F4FA6A4A0;
        Fri, 14 Jun 2019 13:44:03 +0000 (UTC)
Date:   Fri, 14 Jun 2019 08:44:01 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Alexei Starovoitov' <alexei.starovoitov@gmail.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 6/9] x86/bpf: Fix JIT frame pointer usage
Message-ID: <20190614134401.q2wbh6mvo4nzmw2o@treble>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <03ddea21a533b7b0e471c1d73ebff19dacdcf7e3.1560431531.git.jpoimboe@redhat.com>
 <20190613215807.wjcop6eaadirz5xm@ast-mbp.dhcp.thefacebook.com>
 <57f6e69da6b3461a9c39d71aa1b58662@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <57f6e69da6b3461a9c39d71aa1b58662@AcuMS.aculab.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 14 Jun 2019 13:44:06 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 10:50:23AM +0000, David Laight wrote:
> On Thu, Jun 13, 2019 at 08:21:03AM -0500, Josh Poimboeuf wrote:
> > The BPF JIT code clobbers RBP.  This breaks frame pointer convention and
> > thus prevents the FP unwinder from unwinding through JIT generated code.
> >
> > RBP is currently used as the BPF stack frame pointer register.  The
> > actual register used is opaque to the user, as long as it's a
> > callee-saved register.  Change it to use R12 instead.
> 
> Could you maintain the system %rbp chain through the BPF stack?

Do you mean to save RBP again before changing it again, so that we
create another stack frame inside the BPF stack?  That might work.

> It might even be possible to put something relevant in the %rip
> location.

I'm not sure what you mean here.

-- 
Josh
