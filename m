Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF314527DD
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 11:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731422AbfFYJVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 05:21:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44184 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731407AbfFYJVR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 05:21:17 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 898793082E64;
        Tue, 25 Jun 2019 09:21:17 +0000 (UTC)
Received: from carbon (ovpn-200-34.brq.redhat.com [10.40.200.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CCDE10021B4;
        Tue, 25 Jun 2019 09:21:07 +0000 (UTC)
Date:   Tue, 25 Jun 2019 11:21:04 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <jakub.kicinski@netronome.com>, <john.fastabend@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <xdp-newbies@vger.kernel.org>, <bpf@vger.kernel.org>,
        brouer@redhat.com
Subject: Re: [PATCH net-next] xdp: Make __mem_id_disconnect static
Message-ID: <20190625112104.6654a048@carbon>
In-Reply-To: <20190625023137.29272-1-yuehaibing@huawei.com>
References: <20190625023137.29272-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 25 Jun 2019 09:21:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jun 2019 10:31:37 +0800
YueHaibing <yuehaibing@huawei.com> wrote:

> Fix sparse warning:
> 
> net/core/xdp.c:88:6: warning:
>  symbol '__mem_id_disconnect' was not declared. Should it be static?

I didn't declare it static as I didn't want it to get inlined.  As
during development I was using kprobes to inspect this function.  In
the end I added a tracepoint in this function as kprobes was not enough
to capture the state needed.

So, I guess we can declare it static.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  net/core/xdp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index b29d7b5..829377c 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -85,7 +85,7 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_head *rcu)
>  	kfree(xa);
>  }
>  
> -bool __mem_id_disconnect(int id, bool force)
> +static bool __mem_id_disconnect(int id, bool force)
>  {
>  	struct xdp_mem_allocator *xa;
>  	bool safe_to_remove = true;


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
