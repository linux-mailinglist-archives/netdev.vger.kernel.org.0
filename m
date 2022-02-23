Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B404C0701
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 02:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236612AbiBWBnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 20:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbiBWBnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 20:43:00 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B3F506D7;
        Tue, 22 Feb 2022 17:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ffcgj6PnfV+M4dz8TXbmYxJQqYgM/0KYmfMhVlUwUgY=; b=Z1vaisi3Aham/6C/t+iH1xp0YY
        437zJDe/FjItXhy9Q86HR1G005qohaLmQJHI0WCDmpCCnHZ80kh27hi6u1ImMjmCgliHBVb8So6/Q
        VuYLdPUADGADnDgm/kdHkifGKPMh+rp5HyQ2FFoC/oIHCubCH+pxKN2/lluzR0sA4uRVuA8u83rbV
        +S+XWee5Morh4t9GbUfr3ZGWsLK822F+GiWjaX17eNy4zvfUm1dvAS4gG/x9MfG+DZlc2l3ju0BL/
        qI5H47QmeJ3KfSVbMx2JEGRV4euh17I+nWH65KWqqIMNbh9e/UhH5BoxxYrAxBHNGeDyGjwG6g2bp
        NpHxA2Bw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMgfb-00C950-Dn; Wed, 23 Feb 2022 01:42:19 +0000
Date:   Tue, 22 Feb 2022 17:42:19 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Yan Zhu <zhuyan34@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        keescook@chromium.org, yzaikin@google.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, zengweilin@huawei.com,
        liucheng32@huawei.com, nixiaoming@huawei.com,
        xiechengliang1@huawei.com
Subject: Re: [PATCH] bpf: move the bpf syscall sysctl table to its own module
Message-ID: <YhWQ+0qPorcJ/Z8l@bombadil.infradead.org>
References: <20220223013529.67335-1-zhuyan34@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223013529.67335-1-zhuyan34@huawei.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 09:35:29AM +0800, Yan Zhu wrote:
> Sysctl table is easier to read under its own module.

Hey Yan, thanks for you patch!

This does not explain how this is being to help with maitenance as
otherwise this makes kernel/sysctl.c hard to maintain and we also
tend to get many conflicts. It also does not explain how all the
filesystem sysctls are not gone and that this is just the next step,
moving slowly the rest of the sysctls. Explaining this in the commit
log will help patch review and subsystem maintainers understand the
conext / logic behind the move.

> Signed-off-by: Yan Zhu <zhuyan34@huawei.com>

I'd be more than happy to take this if bpf folks Ack. To avoid conflicts
I can route this through sysctl-next which is put forward in particular
to avoid conflicts across trees for this effort. Let me know.

 Luis
