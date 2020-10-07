Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA8C28563A
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 03:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgJGBWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 21:22:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbgJGBWI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 21:22:08 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7AE920882;
        Wed,  7 Oct 2020 01:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602033728;
        bh=Su1MhiAyhgjEpRqeaSy6dwAxQyrhpztEpnz5h7rbtns=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bEPQv6KCPYltlS+upH/DICGE0s3GAz5unL2W/W6Kx2uTWFx8/AWNqmAeLXTtonyOj
         npSPsrj/DTmtTSXjpZjyrlKQB/641/FsVw4OjtubwBtflkkXlt9C4OHKwBVGsR2u+F
         jRGKYQBrD5XrXggCV1GcWDsQJbw5nDSSvmPIqxCw=
Date:   Tue, 6 Oct 2020 18:22:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: Add profiler test
Message-ID: <20201006182205.78f436bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201006200955.12350-4-alexei.starovoitov@gmail.com>
References: <20201006200955.12350-1-alexei.starovoitov@gmail.com>
        <20201006200955.12350-4-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Oct 2020 13:09:55 -0700 Alexei Starovoitov wrote:
> +static ino_t get_inode_from_kernfs(struct kernfs_node* node)

nit: my bot suggests this may be missing an "INLINE" since it's a
     static function in a header

> +{
> +	struct kernfs_node___52* node52 = (void*)node;
> +
> +	if (bpf_core_field_exists(node52->id.ino)) {
> +		barrier_var(node52);
> +		return BPF_CORE_READ(node52, id.ino);
> +	} else {
> +		barrier_var(node);
> +		return (u64)BPF_CORE_READ(node, id);
> +	}
> +}
