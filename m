Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0302322748B
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgGUBaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbgGUBaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:30:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484E7C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 18:30:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E3D5411FFCC34;
        Mon, 20 Jul 2020 18:13:25 -0700 (PDT)
Date:   Mon, 20 Jul 2020 18:30:10 -0700 (PDT)
Message-Id: <20200720.183010.1627184066290103703.davem@davemloft.net>
To:     briana.oursler@gmail.com
Cc:     jhs@mojatatu.com, mrv@mojatatu.com, shuah@kernel.org,
        sbrivio@redhat.com, dcaratti@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] tc-testing: Add tdc to kselftests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200717215439.51672-1-briana.oursler@gmail.com>
References: <20200717215439.51672-1-briana.oursler@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 18:13:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Briana Oursler <briana.oursler@gmail.com>
Date: Fri, 17 Jul 2020 14:54:39 -0700

> Add tdc to existing kselftest infrastructure so that it can be run with
> existing kselftests. TDC now generates objects in objdir/kselftest
> without cluttering main objdir, leaves source directory clean, and
> installs correctly in kselftest_install, properly adding itself to
> run_kselftest.sh script.
> 
> Add tc-testing as a target of selftests/Makefile. Create tdc.sh to run
> tdc.py targets with correct arguments. To support single target from
> selftest/Makefile, combine tc-testing/bpf/Makefile and
> tc-testing/Makefile. Move action.c up a directory to tc-testing/.
> 
> Tested with:
>  make O=/tmp/{objdir} TARGETS="tc-testing" kselftest
>  cd /tmp/{objdir}
>  cd kselftest
>  cd tc-testing
>  ./tdc.sh
> 
>  make -C tools/testing/selftests/ TARGETS=tc-testing run_tests
> 
>  make TARGETS="tc-testing" kselftest
>  cd tools/testing/selftests
>  ./kselftest_install.sh /tmp/exampledir
>  My VM doesn't run all the kselftests so I commented out all except my
>  target and net/pmtu.sh then:
>  cd /tmp/exampledir && ./run_kselftest.sh
> 
> Co-developed-by: Davide Caratti <dcaratti@redhat.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> Signed-off-by: Briana Oursler <briana.oursler@gmail.com>

Applied, but:

> @@ -0,0 +1,6 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./tdc.py -c actions --nobuildebpf
> +./tdc.py -c qdisc
> +

I had to remove this trailing newline.
