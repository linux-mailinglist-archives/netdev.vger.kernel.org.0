Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05796462C5
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 17:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfFNPaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 11:30:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbfFNPaf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 11:30:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD9E42175B;
        Fri, 14 Jun 2019 15:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560526234;
        bh=yHr9pq/10KysBErHEUNYe66X5QjENZmZbRJgZ95Q5/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YQSkaSpALbREELFlyjYwtyXX2zZ40opkg5+4KefS4XBIuG2ytKNe/HlyefrPeKCy0
         E/FugLo4jefFccnnPx66ACowyYQe8Bea79xHMfRvngOsTctElVKuYIxt72NvyX9Rye
         Xmh7GqKPGUeRorB/KJsSF7isbiZer4sAIhDPDf20=
Date:   Fri, 14 Jun 2019 17:30:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-s390@vger.kernel.org,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-mm@kvack.org, iommu@lists.linux-foundation.org,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 12/16] staging/comedi: mark as broken
Message-ID: <20190614153032.GD18049@kroah.com>
References: <20190614134726.3827-1-hch@lst.de>
 <20190614134726.3827-13-hch@lst.de>
 <20190614140239.GA7234@kroah.com>
 <20190614144857.GA9088@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614144857.GA9088@lst.de>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 04:48:57PM +0200, Christoph Hellwig wrote:
> On Fri, Jun 14, 2019 at 04:02:39PM +0200, Greg KH wrote:
> > Perhaps a hint as to how we can fix this up?  This is the first time
> > I've heard of the comedi code not handling dma properly.
> 
> It can be fixed by:
> 
>  a) never calling virt_to_page (or vmalloc_to_page for that matter)
>     on dma allocation
>  b) never remapping dma allocation with conflicting cache modes
>     (no remapping should be doable after a) anyway).

Ok, fair enough, have any pointers of drivers/core code that does this
correctly?  I can put it on my todo list, but might take a week or so...

Ian, want to look into doing this sooner?

thanks,

greg k-h
