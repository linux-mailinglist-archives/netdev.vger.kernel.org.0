Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4A942A12A
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 11:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235755AbhJLJfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 05:35:00 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:59536 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235715AbhJLJfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 05:35:00 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B14721FF4D;
        Tue, 12 Oct 2021 09:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634031177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uUH2uniB3EQO3dwCrSFaoRzeR2U8u7SDS04Yd4v70+U=;
        b=YhyfbjO5nAw5bwwzh728WNI5DvAqHjJZFQzjmHA1K2+FdNCUYVxUjqsq9Ae4F6bDEzoqJQ
        EEwVGKESG8YU55NGTFA+CFcmsIM5Doln5oqhNIvnNKw5GzbJco1gWy+9X50dKiW+sFqa2K
        BV+UzYXo89KlPkPy75N9K1j65LCFY+I=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 69D8E132D4;
        Tue, 12 Oct 2021 09:32:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 84kbGUlWZWHjaAAAMHmgww
        (envelope-from <mkoutny@suse.com>); Tue, 12 Oct 2021 09:32:57 +0000
Date:   Tue, 12 Oct 2021 11:32:55 +0200
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Quanyang Wang <quanyang.wang@windriver.com>
Cc:     Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
Message-ID: <20211012093255.GA14510@blackbody.suse.cz>
References: <20211007121603.1484881-1-quanyang.wang@windriver.com>
 <20211011162128.GC61605@blackbody.suse.cz>
 <6d76de0b-9de7-adbe-834b-c49ed991559d@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d76de0b-9de7-adbe-834b-c49ed991559d@windriver.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 02:22:13PM +0800, Quanyang Wang <quanyang.wang@windriver.com> wrote:
> Before this commit, percpu_ref is embedded in cgroup, it can be freed along
> with cgroup, so there is no memory leak. Since this commit, it causes the
> memory leak.
> Should I change it to "Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of
> cgroup_bpf from cgroup itself")"?

I see. The leak is a product so I'd tag both of them and explain it in
the commit message.

Thank you,
Michal
