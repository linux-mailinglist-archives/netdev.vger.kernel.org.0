Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA53E1981C6
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 18:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbgC3Q7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 12:59:16 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:35698 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728075AbgC3Q7P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 12:59:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9492A20501;
        Mon, 30 Mar 2020 18:59:13 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vBtvAdggbp0M; Mon, 30 Mar 2020 18:59:13 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 26171201A0;
        Mon, 30 Mar 2020 18:59:13 +0200 (CEST)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 MAIL-ESSEN-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 30 Mar 2020 18:59:13 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 30 Mar
 2020 18:59:12 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id E69D43180136;
 Mon, 30 Mar 2020 18:59:11 +0200 (CEST)
Date:   Mon, 30 Mar 2020 18:59:11 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Florian Westphal <fw@strlen.de>
CC:     <netdev@vger.kernel.org>, Xiumei Mu <xmu@redhat.com>,
        Xin Long <lucien.xin@gmail.com>
Subject: Re: [PATCH net 1/1] net: fix fraglist segmentation reference count
 leak
Message-ID: <20200330165911.GS13121@gauss3.secunet.de>
References: <20200330165129.5200-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200330165129.5200-1-fw@strlen.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-dresden-01.secunet.de (10.53.40.199)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 06:51:29PM +0200, Florian Westphal wrote:
> Xin Long says:
>  On udp rx path udp_rcv_segment() may do segment where the frag skbs
>  will get the header copied from the head skb in skb_segment_list()
>  by calling __copy_skb_header(), which could overwrite the frag skbs'
>  extensions by __skb_ext_copy() and cause a leak.
> 
>  This issue was found after loading esp_offload where a sec path ext
>  is set in the skb.
> 
> Fix this by discarding head state of the fraglist skb before replacing
> its contents.
> 
> Fixes: 3a1296a38d0cf62 ("net: Support GRO/GSO fraglist chaining.")
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Tested-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

