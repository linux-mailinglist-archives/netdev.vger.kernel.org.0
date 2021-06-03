Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DA839AA22
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 20:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhFCShg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 14:37:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFCShf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 14:37:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11DE9613F3;
        Thu,  3 Jun 2021 18:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622745350;
        bh=ff8c2MjuINj4Z68DxBy172+R76+T6ILfVjdeXXZ2NaM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t8J2VpCStOku7beQqJjqRzVTE8AevnBQGPNheec5ehM+Y0n/6juzl7mty2DeEFclm
         LXJjpFIYVPkYSNY4nd1K2CvufA6ehDSHxdWZIBMsm7VfLnB/OlNYCOq00mnX2pjUMq
         RjDPyJNqyAsbVXSSoq6jhcNH3QI1BYBI8Ea/lNPCUS4DCn+/F5CyuS62GoC4ufP7AE
         uA0DdRMLafHql1E2iLZbPHi1F2LFLYOjIXuhLNajCH66vDtsf3Y9SAtNYqCGG/ufKL
         fL9DzXsAq55rCTMcls+6AC+rhT2aGu1UwnS4DVI5iPAhpaZQLW0bVG47wiCSHiYiaq
         59ar0AirWhTew==
Date:   Thu, 3 Jun 2021 11:35:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <davem@davemloft.net>, <olteanv@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andriin@fb.com>, <edumazet@google.com>,
        <weiwan@google.com>, <cong.wang@bytedance.com>,
        <ap420073@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <mkl@pengutronix.de>, <linux-can@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>, <jonas.bonn@netrounds.com>,
        <pabeni@redhat.com>, <mzhivich@akamai.com>, <johunt@akamai.com>,
        <albcamus@gmail.com>, <kehuan.feng@gmail.com>,
        <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        <alexander.duyck@gmail.com>, <hdanton@sina.com>, <jgross@suse.com>,
        <JKosina@suse.com>, <mkubecek@suse.cz>, <bjorn@kernel.org>,
        <alobakin@pm.me>
Subject: Re: [PATCH net-next v2 0/3] Some optimization for lockless qdisc
Message-ID: <20210603113548.2d71b4d3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1622684880-39895-1-git-send-email-linyunsheng@huawei.com>
References: <1622684880-39895-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Jun 2021 09:47:57 +0800 Yunsheng Lin wrote:
> Patch 1: remove unnecessary seqcount operation.
> Patch 2: implement TCQ_F_CAN_BYPASS.
> Patch 3: remove qdisc->empty.
> 
> Performance data for pktgen in queue_xmit mode + dummy netdev
> with pfifo_fast:
> 
>  threads    unpatched           patched             delta
>     1       2.60Mpps            3.21Mpps             +23%
>     2       3.84Mpps            5.56Mpps             +44%
>     4       5.52Mpps            5.58Mpps             +1%
>     8       2.77Mpps            2.76Mpps             -0.3%
>    16       2.24Mpps            2.23Mpps             +0.4%
> 
> Performance for IP forward testing: 1.05Mpps increases to
> 1.16Mpps, about 10% improvement.

Acked-by: Jakub Kicinski <kuba@kernel.org>
