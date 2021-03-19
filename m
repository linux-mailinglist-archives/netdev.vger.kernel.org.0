Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276F634226F
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 17:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhCSQtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 12:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhCSQso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 12:48:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E527C06174A;
        Fri, 19 Mar 2021 09:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Rkw34tqvp9ADJCx4j+4Sapfq6ylmx57b1tZJEf0MLzo=; b=AzBkcVVJ9hLMYNIfui3Ciu+vqF
        UXXBIzvU6+fEwtCrrmcDFqZR6jDqGKZ8Wxp4pDfGomBI3L9M2dIiVerh9clT1Kcf9X4wx1JKixu6A
        mM8kE4n2yWdWcMUFyl7vCPUoSdEJGFNw1DqlwA68Ki0bNUkSfhzoOO/zCwoCdpEmXamuwZ4Oy6FQ9
        A9qecdkOO1G8VtPQIcO+NNJ4Cx7f4b1ArMv+J+pLPcUNNt6awXYUjM9SFQN8zXC3aFJZMQm+L7lKw
        XCwmXx7VP2B5Rwq8DruFGaMnC2G3Rf4OKwYjYA1LddcYoEN3nYnXftG1R5YDBFizaY9IEv8P9NsuG
        gNmPAEQQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lNIIR-004iZG-4q; Fri, 19 Mar 2021 16:48:30 +0000
Date:   Fri, 19 Mar 2021 16:48:23 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     William Kucharski <william.kucharski@oracle.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net/rds: correct socket tunable error in rds_tcp_tune()
Message-ID: <20210319164823.GA1124392@casper.infradead.org>
References: <20210317145204.7282-1-william.kucharski@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317145204.7282-1-william.kucharski@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 08:52:04AM -0600, William Kucharski wrote:
> Correct an error where setting /proc/sys/net/rds/tcp/rds_tcp_rcvbuf would
> instead modify the socket's sk_sndbuf and would leave sk_rcvbuf untouched.
> 
> Signed-off-by: William Kucharski <william.kucharski@oracle.com>

Looks like a pretty clear copy-n-paste error.  I think Coverity have
started looking for issues like this?

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Also, maybe,

Fixes: c6a58ffed536 ("RDS: TCP: Add sysctl tunables for sndbuf/rcvbuf on rds-tcp socket")
