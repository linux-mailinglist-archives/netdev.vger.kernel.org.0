Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE4A1B46A2
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 15:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgDVNv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 09:51:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33459 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726023AbgDVNv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 09:51:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587563487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fJykJXZNwJb+wmAp+LK5q4uWJS/bxzHVz4y7QTCDvU8=;
        b=DC244Llvin581bg3un91vF7HyrPiqMYxEc84mfgF3AiL8JrC/FhHHOCncF47qVByGlSGkd
        uxv3T1fqPUZuAjOm0NedFjXsDe7Tuqc/Fc/YJtTF2wvVlHRyZwusgvUqaJdfIKot2dNS1f
        +mJ4va3iHfHvpIH4ft2Yg3YUupH2X80=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-kp93UN4WPviCVIMwwnA8uw-1; Wed, 22 Apr 2020 09:51:24 -0400
X-MC-Unique: kp93UN4WPviCVIMwwnA8uw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92F2EDB21;
        Wed, 22 Apr 2020 13:51:23 +0000 (UTC)
Received: from carbon (unknown [10.40.208.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5C935C1B2;
        Wed, 22 Apr 2020 13:51:18 +0000 (UTC)
Date:   Wed, 22 Apr 2020 15:51:17 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH v2 net-next 5/5] dpaa2-eth: use bulk enqueue in
 .ndo_xdp_xmit
Message-ID: <20200422155117.419b694e@carbon>
In-Reply-To: <20200422120513.6583-6-ioana.ciornei@nxp.com>
References: <20200422120513.6583-1-ioana.ciornei@nxp.com>
        <20200422120513.6583-6-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Apr 2020 15:05:13 +0300
Ioana Ciornei <ioana.ciornei@nxp.com> wrote:

> Take advantage of the bulk enqueue feature in .ndo_xdp_xmit.
> We cannot use the XDP_XMIT_FLUSH since the architecture is not capable
> to store all the frames dequeued in a NAPI cycle so we instead are
> enqueueing all the frames received in a ndo_xdp_xmit call right away.
> 
> After setting up all FDs for the xdp_frames received, enqueue multiple
> frames at a time until all are sent or the maximum number of retries is
> hit.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
> Changes in v2:
>  - use a statically allocated array of dpaa2_fd for each fq
>  - use DEV_MAP_BULK_SIZE as the max number of xdp_frames received

Thanks for doing this.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

