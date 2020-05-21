Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A161DD116
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729931AbgEUPVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 11:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727898AbgEUPVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 11:21:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750F5C061A0E;
        Thu, 21 May 2020 08:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=q0/V8y0Nv8zA7Pp8oKLblpvhLC3VMtOQmusIqCMTC7g=; b=DKXGp2RtTdyH8/q8s6RUq1anmn
        vJwQd0AvOKxBpp0Q8kSMcneF8wUZA1uqNZd3kTiAb8dVQohGM8Ayhhje/Jn23xXFo49/a4BMstDH6
        PW9xzhRJ9kbCsK1TPiuUvzuY1yhGhp2NtK577cARhvmyMcyibgB92G+rTwVMHgdPG+//N3KfWdNMg
        TXtHeamDEE2wpRAwZAT+/6p+ng4gV4rKLtcP9PTVq9rH9JLilKLoTWzCojtnb0q82vtpaKRIFwnRZ
        Y/K6d7GqMG7/4SPrsn+0r1FQCGLG3T8EHoM0/hZ850+OXsEgcmHwMZZHPazRwLI62UAbKFXFe7z4s
        5SmXbAsQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbn0X-0003oT-R1; Thu, 21 May 2020 15:21:18 +0000
Date:   Thu, 21 May 2020 08:21:17 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     adobriyan@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        ebiederm@xmission.com, bernd.edlinger@hotmail.de,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] files: Use rcu lock to get the file structures for
 better performance
Message-ID: <20200521152117.GC28818@bombadil.infradead.org>
References: <20200521123835.70069-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521123835.70069-1-songmuchun@bytedance.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 08:38:35PM +0800, Muchun Song wrote:
> There is another safe way to get the file structure without
> holding the files->file_lock. That is rcu lock, and this way
> has better performance. So use the rcu lock instead of the
> files->file_lock.

What makes you think this is safe?  Are you actually seeing contention
on this spinlock?

