Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D40B369071
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 12:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236107AbhDWKfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 06:35:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51464 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229772AbhDWKfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 06:35:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619174110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x6V3sezXsAAxDR9VM4Vjf0CE1EnjmSBiIUUbI8iN2Aw=;
        b=emiS5OlSyq7IUYeVWAYUG6xwAiOx+7Eg1oYIdoZ+dGE4yVXSR3FCICr40idoy9vk1hfJd7
        F+5jMwbb5huUpfaNTWp5uSB1ESrtpy4ZIflvwl8tztVQE39dRZxmqm3D4bhnEK6xOTrJWD
        9paFZcUAqJAxprFA+00G8rbpaoWtV28=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-KPx-srr6Mtas2ozr-3_I7Q-1; Fri, 23 Apr 2021 06:35:08 -0400
X-MC-Unique: KPx-srr6Mtas2ozr-3_I7Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA954343A0;
        Fri, 23 Apr 2021 10:35:06 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E93342D103;
        Fri, 23 Apr 2021 10:34:56 +0000 (UTC)
Date:   Fri, 23 Apr 2021 12:34:55 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, toke@redhat.com,
        song@kernel.org, brouer@redhat.com
Subject: Re: [PATCH v4 bpf-next] cpumap: bulk skb using
 netif_receive_skb_list
Message-ID: <20210423123455.279dae88@carbon>
In-Reply-To: <c729f83e5d7482d9329e0f165bdbe5adcefd1510.1619169700.git.lorenzo@kernel.org>
References: <c729f83e5d7482d9329e0f165bdbe5adcefd1510.1619169700.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Apr 2021 11:27:27 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Rely on netif_receive_skb_list routine to send skbs converted from
> xdp_frames in cpu_map_kthread_run in order to improve i-cache usage.
> The proposed patch has been tested running xdp_redirect_cpu bpf sample
> available in the kernel tree that is used to redirect UDP frames from
> ixgbe driver to a cpumap entry and then to the networking stack.
> UDP frames are generated using pkt_gen. Packets are discarded by the
> UDP layer.
> 
> $xdp_redirect_cpu  --cpu <cpu> --progname xdp_cpu_map0 --dev <eth>
> 
> bpf-next: ~2.35Mpps
> bpf-next + cpumap skb-list: ~2.72Mpps
> 
> Rename drops counter in kmem_alloc_drops since now it reports just
> kmem_cache_alloc_bulk failures
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

