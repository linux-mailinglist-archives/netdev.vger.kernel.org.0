Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A31D5A62B
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 23:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfF1VO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 17:14:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42490 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbfF1VO4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 17:14:56 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 172EA3082B43;
        Fri, 28 Jun 2019 21:14:56 +0000 (UTC)
Received: from ovpn-204-55.brq.redhat.com (ovpn-204-55.brq.redhat.com [10.40.204.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 672015D9CA;
        Fri, 28 Jun 2019 21:14:54 +0000 (UTC)
Message-ID: <5f04b3f5b5d54a86f151f17d83bfe4931433ec33.camel@redhat.com>
Subject: Re: [Patch net 2/3] idr: introduce idr_for_each_entry_continue_ul()
From:   Davide Caratti <dcaratti@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     chrism@mellanox.com, willy@infradead.org,
        Li Shuang <shuali@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>
In-Reply-To: <20190628180343.8230-3-xiyou.wangcong@gmail.com>
References: <20190628180343.8230-1-xiyou.wangcong@gmail.com>
         <20190628180343.8230-3-xiyou.wangcong@gmail.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 28 Jun 2019 23:14:53 +0200
Mime-Version: 1.0
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Fri, 28 Jun 2019 21:14:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-06-28 at 11:03 -0700, Cong Wang wrote:
> Similarly, other callers of idr_get_next_ul() suffer the same
> overflow bug as they don't handle it properly either.
> 
> Introduce idr_for_each_entry_continue_ul() to help these callers
> iterate from a given ID.
> 
> cls_flower needs more care here because it still has overflow when
> does arg->cookie++, we have to fold its nested loops into one
> and remove the arg->cookie++.

hello Cong,

I confirm that this patch fixes the infinite loop when dumping TC flower
rule with handle 0xffffffff on kernel 5.2.0-0.rc5.git0.1.fc31.i686.

Tested-by: Davide Caratti <dcaratti@redhat.com>

thanks!
-- 
davide

