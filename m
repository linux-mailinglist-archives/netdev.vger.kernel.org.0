Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261B435E5BD
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 19:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345874AbhDMR6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 13:58:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23242 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345826AbhDMR6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 13:58:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618336669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EiOkUDbZ189pvJ/K60Ips+so6MTqbBYnCmEHS0RhH4Y=;
        b=NqojeKJuUAoOSv/kyKK80Ch1mGjMCu2UsyU0WeTcbaIa4gAmP2KB3bCQbY88cUUVNQMLOW
        H0IlEWmT23aBkTG0MBYf6yYtIiULvCcvSFtjI/Cw9VYMCepSZJY9zwh1M/iSaOXe+E34wz
        iWIPcFvjV70dA3o+E1x9CUNlUqeIPUQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-rMk0UHI9NK6133zHFICuAw-1; Tue, 13 Apr 2021 13:57:45 -0400
X-MC-Unique: rMk0UHI9NK6133zHFICuAw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2543801814;
        Tue, 13 Apr 2021 17:57:43 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F1CF7614FA;
        Tue, 13 Apr 2021 17:57:33 +0000 (UTC)
Date:   Tue, 13 Apr 2021 19:57:32 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, song@kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH v2 bpf-next] cpumap: bulk skb using
 netif_receive_skb_list
Message-ID: <20210413195732.5a124b8f@carbon>
In-Reply-To: <bb627106428ea3223610f5623142c24270f0e14e.1618330734.git.lorenzo@kernel.org>
References: <bb627106428ea3223610f5623142c24270f0e14e.1618330734.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Apr 2021 18:22:02 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Rely on netif_receive_skb_list routine to send skbs converted from
> xdp_frames in cpu_map_kthread_run in order to improve i-cache usage.
> The proposed patch has been tested running xdp_redirect_cpu bpf sample
> available in the kernel tree that is used to redirect UDP frames from
> ixgbe driver to a cpumap entry and then to the networking stack.
> UDP frames are generated using pkt_gen.
> 
> $xdp_redirect_cpu  --cpu <cpu> --progname xdp_cpu_map0 --dev <eth>
> 
> bpf-next: ~2.2Mpps
> bpf-next + cpumap skb-list: ~3.15Mpps
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

