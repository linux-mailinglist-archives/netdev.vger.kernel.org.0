Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A0137FAA1
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 17:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbhEMPZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 11:25:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232518AbhEMPZQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 11:25:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4826F613B5;
        Thu, 13 May 2021 15:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620919446;
        bh=1kNuS869OF5IBxShiMjWYu0F7KultguVWQekX/GDkks=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WNwDzMIwlQGuwPZ+peL1idWwWvCxGP75xXHrZ9lUN/xSTQWDllSKtns/Rg0waJrkx
         J532DHIvfaxsIUKYUC3wKbOERf9DFpyefWqoRp7pWok08Dw8iiM2MEFRfH/gYmAQTa
         evkUVMUt68A5LvcMyyghqXqenhYiQutk58hTXlTTR6KYUV2H8yLzJtfcRdr+Nq+dQK
         24i5Z3GNoPyweaBC9FQdXMkYMWUSkQ5eacP7LE8yF7uoadW0ihjFhEWN/qtkA/4WA7
         JAc+ELB44uE4FAzjTS4s8KU9ZBjhMqifiR9WCChXKnm+VD1pUbzyiQgt80FNJYWhlG
         7eIMKxoj3/lrA==
Date:   Thu, 13 May 2021 08:24:04 -0700
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
Subject: Re: [PATCH net v7 0/3] fix packet stuck problem for lockless qdisc
Message-ID: <20210513082404.3e07619b@kicinski-fedora-PC1C0HJN>
In-Reply-To: <1620868260-32984-1-git-send-email-linyunsheng@huawei.com>
References: <1620868260-32984-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 May 2021 09:10:57 +0800 Yunsheng Lin wrote:
> This patchset fixes the packet stuck problem mentioned in [1].
> 
> Patch 1: Add STATE_MISSED flag to fix packet stuck problem.
> Patch 2: Fix a tx_action rescheduling problem after STATE_MISSED
>          flag is added in patch 1.
> Patch 3: Fix the significantly higher CPU consumption problem when
>          multiple threads are competing on a saturated outgoing
>          device.
> 
> V7: Fix netif_tx_wake_queue() data race noted by Jakub.
> V6: Some performance optimization in patch 1 suggested by Jakub
>     and drop NET_XMIT_DROP checking in patch 3.
> V5: add patch 3 to fix the problem reported by Michal Kubecek.
> V4: Change STATE_NEED_RESCHEDULE to STATE_MISSED and add patch 2.

Another review from someone who knows this code better would be great,
but it seems good to me (w/ minor nit on patch 3 addressed):

Acked-by: Jakub Kicinski <kuba@kernel.org>
