Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3520C1B46AA
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 15:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgDVNy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 09:54:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58866 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725787AbgDVNy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 09:54:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587563666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LWcEtDQPffOvaCCFTaaz7fVYd6xWZJU7R0MYzMiqxTo=;
        b=hNKd0RfbiCIfp2MkvVrwmK+91JcwX91yqjr9QacTyBIjbHeBVFFTrpZAFhi/GsljsKq0Og
        GjG1CiI9WqMRoIA3kCKkqMg6hrVCLx0+izr4FEbQmG2rcMQsVSLhqVxRMgKLkAlbBL0khL
        BB7PkXeFDd7inQtTVNLRjoNLfMRwcLE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-4e7wkpCLO62VAv9BneBqCw-1; Wed, 22 Apr 2020 09:54:23 -0400
X-MC-Unique: 4e7wkpCLO62VAv9BneBqCw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85BA013FC;
        Wed, 22 Apr 2020 13:54:22 +0000 (UTC)
Received: from carbon (unknown [10.40.208.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E06D600DB;
        Wed, 22 Apr 2020 13:54:18 +0000 (UTC)
Date:   Wed, 22 Apr 2020 15:54:17 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH v2 net-next 4/5] dpaa2-eth: split the .ndo_xdp_xmit
 callback into two stages
Message-ID: <20200422155417.230f94a6@carbon>
In-Reply-To: <20200422120513.6583-5-ioana.ciornei@nxp.com>
References: <20200422120513.6583-1-ioana.ciornei@nxp.com>
        <20200422120513.6583-5-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Apr 2020 15:05:12 +0300
Ioana Ciornei <ioana.ciornei@nxp.com> wrote:

> Instead of having a function that both creates a frame descriptor from
> an xdp_frame and enqueues it, split this into two stages.
> Add the dpaa2_eth_xdp_create_fd that just transforms an xdp_frame into a
> FD while the actual enqueue callback is called directly from the ndo for
> each frame.
> This is particulary useful in conjunction with bulk enqueue.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

LGTM - and I very recently had to do a deep dive into this driver code.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

