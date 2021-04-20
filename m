Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC2836583A
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 13:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhDTL6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 07:58:09 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:46672 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbhDTL6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 07:58:09 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id E501780004A;
        Tue, 20 Apr 2021 13:57:36 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Apr 2021 13:57:36 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 20 Apr
 2021 13:57:36 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 4439231803A8; Tue, 20 Apr 2021 13:57:36 +0200 (CEST)
Date:   Tue, 20 Apr 2021 13:57:36 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Juri Lelli <jlelli@redhat.com>,
        Xiumei Mu <xmu@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH ipsec-next] xfrm: ipcomp: remove unnecessary get_cpu()
Message-ID: <20210420115736.GF62598@gauss3.secunet.de>
References: <2bc5f05b0c50082cf0f5c817ae7c9f660848f146.1618394396.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2bc5f05b0c50082cf0f5c817ae7c9f660848f146.1618394396.git.sd@queasysnail.net>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 05:11:46PM +0200, Sabrina Dubroca wrote:
> While testing ipcomp on a realtime kernel, Xiumei reported a "sleeping
> in atomic" bug, caused by a memory allocation while preemption is
> disabled (ipcomp_decompress -> alloc_page -> ... get_page_from_freelist).
> 
> As Sebastian noted [1], this get_cpu() isn't actually needed, since
> ipcomp_decompress() is called in napi context anyway, so BH is already
> disabled.
> 
> This patch replaces get_cpu + per_cpu_ptr with this_cpu_ptr, then
> simplifies the error returns, since there isn't any common operation
> left.
> 
> [1] https://lore.kernel.org/lkml/20190820082810.ixkmi56fp7u7eyn2@linutronix.de/
> 
> Cc: Juri Lelli <jlelli@redhat.com>
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

Applied, thanks a lot!
