Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0140211367
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 21:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgGATSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 15:18:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43412 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725771AbgGATSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 15:18:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593631125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xVbq41HYiUuhXfB/SOS513rA/0EbUDHepxgXv4IoTvs=;
        b=DMM3yIpSsGncxRMVzmaNkRYe8Mdvc5z2E8dpQC9aC7k1TmI3sSmEofH7JCzrK/FEVGO5k3
        0xeCEHERw1Ga5SdzfRMVd3bORlQPYBxUkScOu08do7M+y4T71gocFQc2pNFor0OvZFZ8lN
        1dxWk5U6vMQHrG8cJuArGwtrNgtz5rI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-1yYkT_APM7Ce7kXnFly36A-1; Wed, 01 Jul 2020 15:18:42 -0400
X-MC-Unique: 1yYkT_APM7Ce7kXnFly36A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39C7819200CF;
        Wed,  1 Jul 2020 19:18:40 +0000 (UTC)
Received: from carbon (unknown [10.40.208.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76E7F60BE1;
        Wed,  1 Jul 2020 19:18:32 +0000 (UTC)
Date:   Wed, 1 Jul 2020 21:18:30 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Matteo Croce <mcroce@linux.microsoft.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Sven Auhagen <sven.auhagen@voleatech.de>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, maxime.chevallier@bootlin.com,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com,
        brouer@redhat.com
Subject: Re: [PATCH net-next 0/4] mvpp2: XDP support
Message-ID: <20200701211830.74a2f53c@carbon>
In-Reply-To: <20200630180930.87506-1-mcroce@linux.microsoft.com>
References: <20200630180930.87506-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Ilias,

Could you please review this driver mvpp2 for XDP and page_pool usage?


On Tue, 30 Jun 2020 20:09:26 +0200
Matteo Croce <mcroce@linux.microsoft.com> wrote:

> From: Matteo Croce <mcroce@microsoft.com>
> 
> Add XDP support to mvpp2. This series converts the driver to the
> page_pool API for RX buffer management, and adds native XDP support.
> 
> These are the performance numbers, as measured by Sven:
> 
> SKB fwd page pool:
> Rx bps     390.38 Mbps
> Rx pps     762.46 Kpps
> 
> XDP fwd:
> Rx bps     1.39 Gbps
> Rx pps     2.72 Mpps
> 
> XDP Drop:
> eth0: 12.9 Mpps
> eth1: 4.1 Mpps
> 
> Matteo Croce (4):
>   mvpp2: refactor BM pool init percpu code
>   mvpp2: use page_pool allocator
>   mvpp2: add basic XDP support
>   mvpp2: XDP TX support
> 
>  drivers/net/ethernet/marvell/Kconfig          |   1 +
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  49 +-
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 600 ++++++++++++++++--
>  3 files changed, 588 insertions(+), 62 deletions(-)
> 

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

