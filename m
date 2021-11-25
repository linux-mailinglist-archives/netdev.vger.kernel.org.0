Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADE845D4ED
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 07:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347767AbhKYGue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 01:50:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:42628 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244527AbhKYGsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 01:48:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637822722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=flewxf0Pr7GnmX3CHXnbD+nEgt9Czz5AO5oxj939gS8=;
        b=BWktA4u7im62KTbGNQmRZ65zOQP/8S19xLPnWkYG5oFCuDmTik4tPPQxZzW4IUFDl6w6Wl
        5umlGM4VFDp7EnocGlSrvYCTVatbAIXUWsgyPNDaEK8HHo2H5Oan70uwvDIp3kl33jrZlU
        Xzs+9FuDx13gC7KdbU4Dggdqev2Lqk0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-237-ruQ1vCLwNTSqCwoH-QyI8w-1; Thu, 25 Nov 2021 01:45:20 -0500
X-MC-Unique: ruQ1vCLwNTSqCwoH-QyI8w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72BCC81EE61;
        Thu, 25 Nov 2021 06:45:19 +0000 (UTC)
Received: from x230 (unknown [10.39.192.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A235217C58;
        Thu, 25 Nov 2021 06:45:17 +0000 (UTC)
Date:   Thu, 25 Nov 2021 07:45:15 +0100
From:   Stefan Assmann <sassmann@redhat.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Mitch Williams <mitch.a.williams@intel.com>,
        netdev@vger.kernel.org,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: Re: [PATCH net-next 05/12] iavf: don't be so alarming
Message-ID: <20211125064515.wjoe4evnqdfy62c7@x230>
References: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
 <20211124171652.831184-6-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124171652.831184-6-anthony.l.nguyen@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-24 09:16, Tony Nguyen wrote:
> From: Mitch Williams <mitch.a.williams@intel.com>
> 
> Reduce the log level of a couple of messages. These can appear during normal
> reset and rmmod processing, and the driver recovers just fine. Debug
> level is fine for these.
> 
> Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
> Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c     | 2 +-
>  drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index cc1b3caa5136..bb2e91cb9cd4 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -3405,7 +3405,7 @@ static int iavf_close(struct net_device *netdev)
>  				    adapter->state == __IAVF_DOWN,
>  				    msecs_to_jiffies(500));
>  	if (!status)
> -		netdev_warn(netdev, "Device resources not yet released\n");
> +		netdev_dbg(netdev, "Device resources not yet released\n");
>  	return 0;

This message in particular has been a good indicator for some irregular
behaviour in VF reset. I'd rather keep it the way it is or change it
netdev_info().

  Stefan

