Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9AA4C0B0D
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 05:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235962AbiBWE31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 23:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiBWE30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 23:29:26 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CA33191A;
        Tue, 22 Feb 2022 20:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ITh+6/zqypACfDKP1xCozFEaV7Q420DOd3CPJf9hv3c=; b=NE8bL2818F64Oiui19bFjQs0fc
        34abiO9uhaaNkDfpa7HqLTdqvAb8xJnXubxuqGrCPdi+nPofnA3wSRIDO9Au0tWJVbxO8/It8pPWC
        w2Vx836ff7BerEFcn4V6WTcSzz+JK8N6y7LhcNCy0/NzXGfrQkT0iBYIOkp5bQ++lCXd2H8BY0aPy
        GONrzyNeaxhrRo9sYzjV8r3H3xx560Fksd/I6/k1DKicFFdq2PgnqYtCuWesF+MU2ZSpnEnJUAEGS
        Fj5A+O1AeayTUiQmt1djsTjt1dzt01yzKy6sTVRhmkhBXZNkvgILCdTVp21JrPCQXbRfGhpSx2VsV
        XGy48ZCQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMjGB-003RGl-By; Wed, 23 Feb 2022 04:28:15 +0000
Date:   Wed, 23 Feb 2022 04:28:15 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Yan Zhu <zhuyan34@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, mcgrof@kernel.org,
        keescook@chromium.org, yzaikin@google.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, zengweilin@huawei.com,
        liucheng32@huawei.com, nixiaoming@huawei.com,
        xiechengliang1@huawei.com
Subject: Re: [PATCH] bpf: move the bpf syscall sysctl table to its own module
Message-ID: <YhW335H//CkhCut8@casper.infradead.org>
References: <20220223013529.67335-1-zhuyan34@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223013529.67335-1-zhuyan34@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 09:35:29AM +0800, Yan Zhu wrote:
> +static struct ctl_table bpf_syscall_table[] = {
> +	{
> +		.procname	= "unprivileged_bpf_disabled",
> +		.data		= &sysctl_unprivileged_bpf_disabled,
> +		.maxlen		= sizeof(sysctl_unprivileged_bpf_disabled),
> +		.mode		= 0644,
> +		.proc_handler	= bpf_unpriv_handler,
> +		.extra1		= SYSCTL_ZERO,
> +		.extra2		= SYSCTL_TWO,
> +	},
> +	{
> +		.procname	= "bpf_stats_enabled",
> +		.data		= &bpf_stats_enabled_key.key,
> +		.maxlen		= sizeof(bpf_stats_enabled_key),
> +		.mode		= 0644,
> +		.proc_handler	= bpf_stats_handler,
> +	},
> +	{ }
> +};

No progress towards a counted array instead of a NULL terminated one?
