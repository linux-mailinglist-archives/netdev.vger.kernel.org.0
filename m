Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA242B34D8
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 13:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgKOMSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 07:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbgKOMSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 07:18:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683E5C0613D1;
        Sun, 15 Nov 2020 04:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SqBkoMisN8DRT7Ugl7/Kskn70ZM+RV1ZXq04Kt9+Zxk=; b=Fc13oNdA5LMGuxAfQ+cshr3PRq
        uKzkSPTQ1CFEqEsskFx41rAFTodBdHAnA2A7YA3Nps1cnwwZkgYsB2pw3M1Dp5GQFRMKytpA+Fu1S
        0cPoQUJ2wU9gQCnPjrU35rXPhLGuRr3KBtiWl2S+CO8anENkcFKfXvF1cbXVwzl75fUMdCSOZ112F
        qFXivRmLn+hKZqwfukred3rOLgyM9222Voh5Wmpr9eR8HIivgDrvCTXS+juikfiNiI3adujhz3l3O
        d+5/XNH06bFAWtzJ8sL22st8+nRyCoHLTHysKdAYiHd0Mr+5gR4dGRz5NYTfVRX5EtwXjv+qQkbS7
        N/Kjjm5w==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1keGzE-00041W-Am; Sun, 15 Nov 2020 12:18:28 +0000
Date:   Sun, 15 Nov 2020 12:18:28 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     linux-mm@kvack.org, netdev@vger.kernel.org,
        aruna.ramakrishna@oracle.com, bert.barbe@oracle.com,
        rama.nichanamatlu@oracle.com, venkat.x.venkatsubra@oracle.com,
        manjunath.b.patil@oracle.com, joe.jin@oracle.com,
        srinivas.eeda@oracle.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, edumazet@google.com, vbabka@suse.cz
Subject: Re: [PATCH v2 1/1] page_frag: Recover from memory pressure
Message-ID: <20201115121828.GQ17076@casper.infradead.org>
References: <20201115065106.10244-1-dongli.zhang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201115065106.10244-1-dongli.zhang@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 10:51:06PM -0800, Dongli Zhang wrote:
> +		if (nc->pfmemalloc) {

You missed the unlikely() change that Eric recommended.
