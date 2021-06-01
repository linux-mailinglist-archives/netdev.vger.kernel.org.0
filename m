Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5042539720F
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 13:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbhFALId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 07:08:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33097 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231610AbhFALIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 07:08:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622545610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aaASPp3wsnjRSRxwYNnrbRgJnT5vvPPdfGvm6PNwdHA=;
        b=KPfK2bGq+PG6tXPU+SV56oltBQLhYSgFpoNvNYfNsxLofYjmOK9DD0TlYNw7B4WTYJ/B9S
        WfqRWRZ8Z8tq73q4jg3k9E6RzVx+uotC1pzl26epzpmjE4HOl9ktO8ITJvZDHQU5cZ3FJE
        MowZgpeOLTnsNTrzmZvGn0vmIIl7+CQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-C9_V3q6ONYyf2BKLwIWrFA-1; Tue, 01 Jun 2021 07:06:49 -0400
X-MC-Unique: C9_V3q6ONYyf2BKLwIWrFA-1
Received: by mail-wm1-f69.google.com with SMTP id f13-20020a05600c154db0290195f6af2ea9so313937wmg.1
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 04:06:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aaASPp3wsnjRSRxwYNnrbRgJnT5vvPPdfGvm6PNwdHA=;
        b=mzLabKkkmdYYEwrXUPUc66L10Plp0KAJTTNVwvDQpIH5m+q+cB/BsCQX2nqBsakP2s
         oMLgFyqK98dhVwUYT6UprcChP82XB4l0jAZvHdxWOMHnAFCPDRlhF3uEt2JqR5HYZyL3
         QKm4jql9s39HzFAcvqKM+gYpYs4jEAfZAJ4yboRrRsVyUS0xhjYoXKTbRoiUe9mATJJE
         O+MPplkibVWzeQmOOwuVt958jUg6TA2dXIL+KuOcBOCKoWI20wwB5O/bGt5UHNqzAxwK
         l4LQd7iZrW7udBzMswvfWNKNwI0nT5SfyJXbK6mhNINHEMvkOsoBzYwsgzhQqhwo3Ed9
         7zHA==
X-Gm-Message-State: AOAM533B7hHUA0FSR3eG6PVIvbIQl12RHgfNyuMjMtSaVWh+OLbkmSqw
        FsO5x1Qh8sa023L7ZwWkPRc3xQ81IiblMTnvx8ABr1vtmYIgIWMsOgzn0V9mArGnaBEswHO+9zN
        s29kJ5/BRGvD7L3DJ
X-Received: by 2002:adf:c38a:: with SMTP id p10mr13213655wrf.138.1622545608108;
        Tue, 01 Jun 2021 04:06:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxse7H7NC7uKSyVhO6tqCkb28FmQf5X8G+WwPdEHDAGaDn6G2Zi6zozpeSFKQlrGMyxGwqDxw==
X-Received: by 2002:adf:c38a:: with SMTP id p10mr13213630wrf.138.1622545607887;
        Tue, 01 Jun 2021 04:06:47 -0700 (PDT)
Received: from redhat.com (line103-35.adsl.actcom.co.il. [192.117.103.35])
        by smtp.gmail.com with ESMTPSA id o17sm2656386wrp.47.2021.06.01.04.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 04:06:47 -0700 (PDT)
Date:   Tue, 1 Jun 2021 07:06:43 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH net v2 0/2] virtio-net: fix for build_skb()
Message-ID: <20210601070610-mutt-send-email-mst@kernel.org>
References: <20210601064000.66909-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601064000.66909-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 02:39:58PM +0800, Xuan Zhuo wrote:
> #1 Fixed a serious error.
> #2 Fixed a logical error, but this error did not cause any serious consequences.
> 
> The logic of this piece is really messy. Fortunately, my refactored patch can be
> completed with a small amount of testing.

Looks good, thanks!
Also needed for stable I think.

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> Thanks.
> 
> Xuan Zhuo (2):
>   virtio-net: fix for unable to handle page fault for address
>   virtio_net: get build_skb() buf by data ptr
> 
>  drivers/net/virtio_net.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
> 
> --
> 2.31.0

